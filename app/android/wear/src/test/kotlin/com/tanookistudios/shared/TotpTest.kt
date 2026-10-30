package com.tanookistudios.shared

import org.junit.Assert.assertEquals
import org.junit.Test

/** RFC 6238 Appendix B, plus the base32 path the widget and watch use. */
class TotpTest {
    private val seeds = mapOf(
        "sha1" to "12345678901234567890",
        "sha256" to "12345678901234567890123456789012",
        "sha512" to "1234567890123456789012345678901234567890123456789012345678901234",
    )
    private val vectors = listOf(
        Triple(59L, "sha1", "94287082"), Triple(59L, "sha256", "46119246"), Triple(59L, "sha512", "90693936"),
        Triple(1111111109L, "sha1", "07081804"), Triple(1111111109L, "sha256", "68084774"), Triple(1111111109L, "sha512", "25091201"),
        Triple(1111111111L, "sha1", "14050471"), Triple(1111111111L, "sha256", "67062674"), Triple(1111111111L, "sha512", "99943326"),
        Triple(1234567890L, "sha1", "89005924"), Triple(1234567890L, "sha256", "91819424"), Triple(1234567890L, "sha512", "93441116"),
        Triple(2000000000L, "sha1", "69279037"), Triple(2000000000L, "sha256", "90698825"), Triple(2000000000L, "sha512", "38618901"),
        Triple(20000000000L, "sha1", "65353130"), Triple(20000000000L, "sha256", "77737706"), Triple(20000000000L, "sha512", "47863826"),
    )

    @Test
    fun rfc6238Vectors() {
        for ((t, alg, want) in vectors) {
            assertEquals("t=$t $alg", want, Totp.totp(seeds.getValue(alg).toByteArray(), t, digits = 8, algorithm = alg))
        }
    }

    @Test
    fun base32SixDigits() {
        assertEquals("287082", Totp.totp(Totp.base32Decode("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")!!, 59))
        assertEquals("287 082", Totp.grouped("287082"))
    }

    /** Steam Guard, same seed, checked against an independent Python implementation (hmac module). */
    @Test
    fun steamVectors() {
        val key = seeds.getValue("sha1").toByteArray()
        for ((t, want) in listOf(59L to "PV9M4", 1111111109L to "PY4YB", 1234567890L to "VHHQY", 2000000000L to "9N776",
            // Together these use every letter of the Steam alphabet, so a wrong letter anywhere fails.
            60L to "B26KJ", 90L to "5H85C", 120L to "6Y9J3", 150L to "MD224", 180L to "P2GRF", 210L to "C9PRW", 300L to "X5TCK",
        )) {
            assertEquals("steam t=$t", want, Totp.steam(key, t))
        }
    }
}
