package com.tanookistudios.shared

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** The Android autofill service's matching and codes. Same cases as ios/AutoFillTests/main.swift. */
class AutofillTest {
    // The exact shape app/lib/core/widget_share.dart autofillAccounts sends.
    private val json = """
        [{"id":"1","type":"totp","issuer":"GitHub","label":"me","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha1","digits":6,"period":30,"domains":["github.com"]},
         {"id":"2","type":"steam","issuer":"Steam","label":"gamer","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha1","digits":5,"period":30,"domains":[]},
         {"id":"3","type":"totp","issuer":"Bank of Example","label":"","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha256","digits":8,"period":60,"domains":["example.com"],"requireAuth":true},
         {"id":"4","type":"totp","issuer":"Discord","label":"","secret":"not base32!","algorithm":"sha1","digits":6,"period":30,"domains":[]}]
    """
    private val accounts = AutofillMatch.parse(json)
    private val github = accounts[0]
    private val steam = accounts[1]
    private val bank = accounts[2]
    private val discord = accounts[3]

    @Test
    fun parsesTheAppsJson() {
        assertEquals(4, accounts.size)
        assertEquals(listOf("github.com"), github.domains)
        assertTrue(bank.requireAuth)
        assertFalse(github.requireAuth)
        assertEquals("steam", steam.type)
        assertTrue(AutofillMatch.parse("not json").isEmpty())
    }

    @Test
    fun codes() {
        assertEquals("287082", github.code(59))
        assertEquals("PV9M4", steam.code(59))
        assertEquals("VHHQY", steam.code(1234567890))
        assertEquals(8, bank.code(59)!!.length)
        assertNull("a broken secret gives no code rather than a wrong one", discord.code(59))
    }

    @Test
    fun websites() {
        assertTrue(AutofillMatch.matchesSite(github, "github.com"))
        assertTrue(AutofillMatch.matchesSite(github, "https://www.GitHub.com/login?x=1"))
        assertTrue(AutofillMatch.matchesSite(github, "accounts.github.com"))
        assertFalse("lookalike", AutofillMatch.matchesSite(github, "notgithub.com"))
        assertFalse("prefix", AutofillMatch.matchesSite(github, "github.com.evil.io"))
        assertFalse(AutofillMatch.matchesSite(github, ""))
        assertFalse(AutofillMatch.matchesSite(steam, "store.steampowered.com"))
        assertTrue("name fallback", AutofillMatch.matchesSite(steam, "steam.com"))
        assertTrue(AutofillMatch.matchesSite(discord, "https://discord.com/login"))
        assertFalse("with domains, no name fallback", AutofillMatch.matchesSite(bank, "bankofexample.com"))
    }

    @Test
    fun apps() {
        assertTrue(AutofillMatch.matchesApp(github, "com.github.android"))
        assertTrue(AutofillMatch.matchesApp(steam, "com.valvesoftware.android.steam.community"))
        assertTrue(AutofillMatch.matchesApp(discord, "com.discord"))
        assertTrue(AutofillMatch.matchesApp(bank, "com.example.banking"))
        assertFalse("filler words never match", AutofillMatch.matchesApp(github, "com.android.chrome"))
        assertFalse(AutofillMatch.matchesApp(bank, "com.app.mobile"))
    }

    @Test
    fun ranking() {
        val ranked = AutofillMatch.ranked(accounts, listOf("accounts.github.com", "discord.com", "github.com"))
        assertEquals(listOf("1", "4"), ranked.map { it.id })
        assertEquals(listOf("2"), AutofillMatch.ranked(accounts, emptyList(), listOf("com.valvesoftware.android.steam.community")).map { it.id })
        assertTrue(AutofillMatch.ranked(accounts, emptyList()).isEmpty())
        assertEquals("GitHub (me)", github.suggestionLabel)
        assertEquals("Discord", discord.suggestionLabel)
    }
}
