package com.tanookistudios.shared

import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/** RFC 4226 / 6238 codes for the widget and Wear OS. Mirrors app/lib/core/totp.dart; tested in wear/src/test. */
object Totp {
    fun base32Decode(input: String): ByteArray? {
        val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        var buffer = 0
        var bits = 0
        val out = java.io.ByteArrayOutputStream()
        for (ch in input.uppercase()) {
            if (ch == ' ' || ch == '=' || ch == '-') continue
            val v = alphabet.indexOf(ch)
            if (v < 0) return null
            buffer = (buffer shl 5) or v
            bits += 5
            if (bits >= 8) {
                bits -= 8
                out.write((buffer shr bits) and 0xff)
            }
        }
        return out.toByteArray().takeIf { it.isNotEmpty() }
    }

    fun hotp(key: ByteArray, counter: Long, digits: Int = 6, algorithm: String = "sha1"): String {
        val name = when (algorithm) {
            "sha256" -> "HmacSHA256"
            "sha512" -> "HmacSHA512"
            else -> "HmacSHA1"
        }
        val mac = Mac.getInstance(name).apply { init(SecretKeySpec(key, name)) }
            .doFinal(java.nio.ByteBuffer.allocate(8).putLong(counter).array())
        val offset = mac[mac.size - 1].toInt() and 0x0f
        val binary = ((mac[offset].toInt() and 0x7f) shl 24) or
            ((mac[offset + 1].toInt() and 0xff) shl 16) or
            ((mac[offset + 2].toInt() and 0xff) shl 8) or
            (mac[offset + 3].toInt() and 0xff)
        var mod = 1L
        repeat(digits) { mod *= 10 }
        return (binary % mod).toString().padStart(digits, '0')
    }

    fun totp(key: ByteArray, unixSeconds: Long, period: Int = 30, digits: Int = 6, algorithm: String = "sha1"): String =
        hotp(key, unixSeconds / period, digits, algorithm)

    /** "123 456" / "1234 5678", like the app. */
    fun grouped(code: String): String = when (code.length) {
        6 -> code.substring(0, 3) + " " + code.substring(3)
        8 -> code.substring(0, 4) + " " + code.substring(4)
        else -> code
    }
}
