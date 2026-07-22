<div align="center">

# 🕺 nx_AnimationsMenu

[![Base Project](https://img.shields.io/badge/based%20on-rpemotes--reborn-0d0d1a?style=for-the-badge&logoColor=00e5ff)](https://github.com/rpemotes/rpemotes-reborn)
[![Framework](https://img.shields.io/badge/framework-ESX%20%2F%20QB--Core-0d0d1a?style=for-the-badge&logoColor=ff2d95)](#-requirements)
[![Language](https://img.shields.io/badge/language-Lua-0d0d1a?style=for-the-badge&logo=lua&logoColor=b967ff)](#-tech-stack)
[![Free Forever](https://img.shields.io/badge/price-free%20forever-0d0d1a?style=for-the-badge&logoColor=00e5ff)](#-credits--base-project)

</div>

---

## 📖 About

**`nx_AnimationsMenu`** ist unser Redesign des Emote-Menüs für unseren Server —
Banner, Farben und Konfiguration auf unser Branding zugeschnitten, auf Basis
des exzellenten **[rpemotes-reborn](https://github.com/rpemotes/rpemotes-reborn)**.
Spieler können sich über eigene Animationen, unzählige Gesichtsausdrücke,
Laufstile und Props im Roleplay ausdrücken.

> ⚠️ **Wichtig:** Der komplette Emote-/Animations-Unterbau stammt von
> rpemotes-reborn und ihrem Team. rpemotes-reborn ist **kostenlos und bleibt
> es auch** — dieses Redesign ändert nur Optik/Branding/Config, nicht die
> zugrunde liegende Arbeit der Original-Autoren und Animations-/Prop-Ersteller.
> Details dazu im [Credits-Abschnitt](#-credits--base-project).

---

## ✨ Features

- 🎬 Emote Preview & Placement — Emotes vor der Nutzung ansehen und platzieren
- 🖼️ Anpassbares Banner (Bild, Text, Textfarbe)
- 🔎 Emote-Suchfunktion
- 🕺 Community-beigetragene Custom-Animationen
- 👯 Gruppen-Emotes (Tanzen, Salutieren u.a. mit 2+ Personen)
- 🚪 Exit-Emotes — sanfte Übergänge beim Verlassen einer Animation
- 💾 Persistente Gesichtsausdrücke & Laufstile via Client-KVP
- 🔄 Menyoo → RPEmotes Konverter
- 🔞 Adult-Emotes ausblendbar
- ⛔ Animal-Emotes ausblendbar
- 🐩 Eigene Animal-Emotes
- 💨 Geteilte Partikeleffekte (Rauch, Feuer, u.a.)
- ⚙️ QB-Core- und ESX-Unterstützung inkl. KVP-Keybinding
- 👫 Geteilte/Paar-Posen & Animationen
- 🎥 Persistentes Deaktivieren der Idle-Kamera via KVP
- 💾 Props-Extractor für Anticheat-Kompatibilität
- 🐞 Crouching, 🐛 Crawling, 👆 Finger Pointing, 😵 Ragdoll, 🙌 Hands Up
- 👀 Fernglas, 🎤📹 Nachrichtenkamera

**Verfügbare Sprachen:** Albanisch, brasilianisches Portugiesisch, Chinesisch
(vereinfacht/traditionell), Tschechisch, Dänisch, Niederländisch, Englisch,
Finnisch, Französisch, Deutsch, Griechisch, Ungarisch, Indonesisch,
Italienisch, Litauisch, Norwegisch, Persisch, Polnisch, Rumänisch, Russisch,
Serbisch, Singhalesisch, Slowenisch, Spanisch, Schwedisch, Türkisch,
Vietnamesisch — auswählbar/erweiterbar in `config.lua`.

---

## 🛠️ Tech Stack

<div align="center">

![Lua](https://img.shields.io/badge/Lua-2B2E3A?style=flat-square&logo=lua&logoColor=00E5FF)
![ESX](https://img.shields.io/badge/ESX-2B2E3A?style=flat-square&logoColor=FF2D95)
![QBCore](https://img.shields.io/badge/QBCore-2B2E3A?style=flat-square&logoColor=BD93F9)
![OneSync Infinity](https://img.shields.io/badge/OneSync-Infinity-2B2E3A?style=flat-square&logoColor=00E5FF)

</div>

---

## ⚙️ Requirements

- ESX **oder** QB-Core (`Framework = "qb-core"` bzw. `false` in `config.lua`)
- Aktuelle FiveM-Artifacts, Gamebuild auf den neuesten Stand erzwungen
- **OneSync Infinity** für Partikeleffekte

---

## 📦 Installation

1. `ensure nx_AnimationsMenu` (bzw. euer Resource-Ordnername) in die
   `server.cfg`.
2. Aktuelle FiveM-Artifacts nutzen, Gamebuild auf den neuesten Stand
   erzwingen, damit alle Emotes/Props korrekt funktionieren.
3. OneSync Infinity aktivieren (für Partikeleffekte zwingend nötig):
   ```
   +set onesync on +set onesync_enableInfinity 1 +set onesync_enableBeyond 1 +set onesync_population true
   ```
4. Sprache setzen: `MenuLanguage = 'en'` (o.ä.) in `config.lua`.
5. Bei QB-Core: `Framework = "qb-core"` setzen, sonst `false` lassen.
6. Banner (512×128, Dateiname **nicht** ändern), Menütitel, Schriftart und
   Position nach eigenem Branding anpassen.
7. `/refresh` + `/ensure` oder Server neu starten.

---

## ⌨️ Menü & Keybinds

| Taste / Command | Aktion |
|---|---|
| `F4` (änderbar) | Menü öffnen/schließen |
| `LEFT ALT` | Im Menü springen (1er/10er-Schritte) |
| `B` / `/pointing` | Finger Pointing |
| `Y` / `/handsup` | Hands Up |
| `LEFT CTRL` / `/crouch` | Crouching |
| `RIGHT CTRL` / `/crawl` | Crawling |
| `U` | Ragdoll (falls aktiviert) |
| `/walks`, `/moods` | Laufstil-/Mood-Liste im Chat |
| `/reset mood`, `/reset walk` | Zurücksetzen auf Standard |
| `/binoculars` | Fernglas |
| `/newscam` | Nachrichtenkamera |
| `emoteextract` | Prop-Liste für Anticheat-Whitelisting generieren |

---

## 🔌 Exports (Auszug)

```lua
exports["nx_AnimationsMenu"]:Execute(emoteName, emoteType, textureVariation)
exports["nx_AnimationsMenu"]:EmoteCancel(forceCancel)
exports["nx_AnimationsMenu"]:IsPlayerInAnim()
exports["nx_AnimationsMenu"]:GetEmoteCatalog()
```

Zum Blockieren von Emotes/Cancel (z. B. in Haft oder gefesselt):

```lua
LocalPlayer.state:set('canEmote', false, true)
LocalPlayer.state:set('canCancel', false, true)
```

Vollständige Export-Liste und Doku: siehe Original-
[Dokumentation](https://rpemotes-reborn.gitbook.io/guide).

---

## 🤝 Credits & Base Project

Dieses Redesign ist **keine eigenständige Neuentwicklung** des
Emote-Systems — die gesamte Animations-/Prop-Logik stammt von
**[rpemotes-reborn](https://github.com/rpemotes/rpemotes-reborn)** und ihrer
Community. rpemotes-reborn ist kostenlos und soll es laut den
Original-Autoren und allen beitragenden Erstellern auch **immer bleiben** —
kein Weiterverkauf, keine Aneignung als eigene Originalarbeit.

<details>
<summary>Vollständige Original-Credits anzeigen</summary>

**Entwicklung:**
The Popcorn RP Community, Mathu_lmn, Manason, CritteRo, ChristopherM (cm8263),
enzo2991, DerDevHD, iSentrie, Kibook, AvaN0x, Mads (MadsLeander), Tigerle,
GeekGarage, northsqrd (0sqrd), Chico, Scully, Crusopaul, Eki.

**Emote- & Prop-Ersteller:**
FalseHopeDesigns, SMGMissy, MissSnowie, Smokey, BzZzi, Natty3d, Amnilka,
LittleSpoon, LadyyShamrockk, Pupppy, SapphireMods, QueenSisters Animations,
DurtyFree (GTA V Data Dumps), BoringNeptune, CMG Mods, prue 颜, PataMods,
Crowded1337, EnchantedBrownie, Chocoholic Animations, CrunchyCat, KayKayMods,
MonkeyWhisper & Project Sloth, Brummieee, Dark Animations, -EcLiPsE-, MrWitt,
Vedere, DRX Animations, VNSIanims, PNWParksFan, LSPDFR member Sam, GTA5Mods
user Sladus_Slawonkus, EP (EpKouhia), TayMcKenzieNZ, 41anims, corbs, jaysigx,
Payzee.

</details>

Original-Discord der rpemotes-reborn-Community:
[discord.gg/UJ72w8rgar](https://discord.gg/UJ72w8rgar)

---

## 📜 License

Basierend auf rpemotes-reborn — **kostenlos, nicht zum Weiterverkauf**. Dieses
Redesign betrifft ausschließlich Branding/Konfiguration unseres eigenen
Servers.

<div align="center">

Redesign & Branding by **nxService & Streams**
Emote-System & Animationen by **rpemotes-reborn** und ihrem Team

</div>
