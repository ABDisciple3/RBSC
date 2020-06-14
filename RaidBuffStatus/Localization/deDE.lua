local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("RaidBuffStatus","deDE")
if not L then return end

-- German Localization
-- Last update : 07/06/2008
-- By Carylon of Aman'Thul

-- Command options

	L["Show the buff report dashboard."] = "Die Zusammenfassungsfenster des Buff-Reports anzeigen."
	L["Hide the buff report dashboard."] = "Die Zusammenfassungsfenster des Buff-Reports ausblenden."
	L["Report to /raid or /party who is not buffed to the max."] = "An /schlachtzug oder /gruppe berichten, wer nicht maximal gebufft ist."
	L["Hide and show the buff report dashboard."] = "Ausblenden und Einblenden der Zusammenfassungsfenster des Buff-Reports"

-- Messages

	L["No buffs needed! (Boss)"] = "Keine Buffs ben\195\182tigt! (Boss)"
	L["No buffs needed! (Trash)"] = "Keine Buffs ben\195\182tigt! (Trash)"
	L["Not Well Fed"] = "Nicht optimal gen\195\164hrt"
	L["Missing Arcane Intellect"] = "Keine Arkane Intelligenz"
	L["Missing Mark of the Wild"] = "Kein Mal der Wildnis"
	L["Missing Divine Spirit"] = "Kein G\195\182ttlicher Wille"
	L["Missing Power Word: Fortitude"] = "Kein Machtwort: Seelenst\195\164rke"
	L["Missing Shadow Protection"] = "Kein Schattenschutz"
	L["Flask or two Elixirs"] = "Fl\195\164schchen oder zwei Elixiere"
	L["Missing a Flask or two Elixirs"] = "Keine Fl\195\164schchen oder zwei Elixiere"
	L["Battle Elixir"] = "Kampfelixier"
	L["Missing a Battle Elixir"] = "Kein Kampfelexier"
	L["Guardian Elixir"] = "W\195\164chterelixier"
	L["Missing a Guardian Elixir"] = "Kein W\195\164chterelixier"
	L["Missing buffs (Trash): "] = "Fehlende Buffs (Trash)"
	L["Missing buffs (Boss): "] = "Fehlende Buffs (Boss)"
	L["Warnings: "] = "Warnungen: "
	L["Paladin has Crusader Aura"] = "Loladin hat Aura des Kreuzfahrers"
	L["PVP On"] = "PVP aktiv"
	L["PVP is On"] = "PVP ist aktiv"
	L["AFK"] = "AFK"
	L["Player is AFK"] = "Spieler ist AFK"
	L["Offline"] = "Offline"
	L["Player is Offline"] = "Spieler ist Offline"
	L["Shadow Resistance Aura AND Shadow Protection"] = "Aura des Schattenwiderstands UND Schattenschutz"
	L["Paladin has Shadow Resistance Aura AND Shadow Protection"] = "Paladin hat Aura des Schattenwiderstands UND Schattenschutz"
	L["Paladin Aura"] = "Paladin Aura"
	L["Paladin has no Aura at all"] = "Paladin ohne aktive Aura"
	L["Paladin Different Aura - Group"] = "Paladin andere Aura - Gruppe"
	L["There are more Paladins than different Auras in group"] = "Hier sind mehr Paladine als verschiedene Auren in der Gruppe"
	L["Dead"] = "Tot"
	L["Player is Dead"] = "Spieler ist tot"
	L["Different Zone"] = "Andere Zone"
	L["Player is in a different zone"] = "Spieler ist in einer anderen Zone"
	L["Health less than 80%"] = "Gesundheit unter 80%"
	L["Player has health less than 80%"] = "Spieler mit Gesundheit unter 80%"
	L["Mana less than 80%"] = "Mana unter 80%"
	L["Player has mana less than 80%"] = "Spieler mit Mana unter 80%"
	L["Boss"] = "Boss"
	L["Trash"] = "Trash"
	L["R"] = "B" -- B is short for Bereit
	L["Aspect Cheetah/Pack On"] = "Aspekt Gepard/Rudel aktiv"
	L["Hunter Aspect"] = "J\195\164ger Aspekt"
	L["Aspect of the Cheetah or Pack is on"] = "Aspekt des Geparden oder Rudels ist aktiv"
	L["Hunter has no aspect at all"] = "J\195\164ger ohne aktive Aura"
--	L["Hunter is missing Trueshot Aura"] = ""
	L["Protection paladin with no Righteous Fury"] = "Schutzpaladin ohne Zorn der Gerechtigkeit"
	L["No Soulstone detected"] = "Kein Seelenstein entdeckt"
	L["Someone has a Soulstone"] = "Jemand hat einen Seelenstein"
	L["Priest is missing Inner Fire"] = "Priester hat kein Inneres Feuer aktiv"
	L["Warlock is missing Fel Armor"] = "Hexenmeister hat kein Teufelsr\195\188stung aktiv"
	L["Druid is missing Omen of Clarity"] = "Druide hat kein Omen der Klarsicht aktiv"
	L["Mage is missing a Mage Armor"] = "Magier hat keine Magische R\195\188stung aktiv"
	L["Warning: "] = "Warnung"
	L["Missing buff: "] = "Fehlender Buff:"
	L["Gruul's Lair"] = "Gruuls Unterschlupf"
	L["Tempest Keep"] = "Festung der Stürme"
	L["Serpentshrine Cavern"] = "Höhle des Schlangenschreins"
	L["Black Temple"] = "Der Schwarze Tempel"
	L["Sunwell Plateau"] = "Sonnenbrunnenplateau"
	L["Hyjal Summit"] = "Hyjalgipfel"
	L["Wrong flask for this zone"] = "Falsches Fl\195\164schchen f\195\188r diese Zone"
	L["Weapon buff"] = "Waffenbuff"
	L["Missing a temporary weapon buff"] = "tempor\195\164rer Waffenbuff fehlt"
	L["(Ward of Shielding)"] = "(Zauberschutz der Abschirmung)"
	L["^(Weighted %(%+%d+)"] = "^(Weighted %(%+%d+)"
	L["^(Sharpened %(%+%d+)"] = "^(Geschärfte %(%+%d+)"
	L["( Poison ?[IVX]*)"] = "( Gift ?[IVX]*)"
	L["(Mana Oil)"] = "(Manaöl)"
	L["(Wizard Oil)"] = "(Zauberöl)"
	L["(Frost Oil)"] = "(Frostöl)"
	L["(Shadow Oil)"] = "(Schattenöl)"
--	L["(Weapon Coating)"] =
	L["Paladin blessing"] = "Paladin-Segen fehlt"
	L["Player is missing at least one Paladin blessing"] = "Spieler fehlt mindestens ein Paladin-Segen"
	L["Missing Amplify Magic"] = "Magie verst\195\164rken fehlt"
--	L["RBS Dashboard Help"] =
--	L["Click buffs to disable and enable."] =
--	L["Shift-Click buffs to report on only that buff."] =
--	L["Ctrl-Click buffs to whisper those who need to buff."] =
--	L["Alt-Click on a self buff will renew that buff."] =
--	L["Alt-Click on a party buff will cast on someone missing that buff."] =
--	L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."] =
--	L["Remove this button from this dashboard in the buff options window."] =
--	L["Buffers: "] =
--	L["(Remove buff)"] = 
--	L["Tank missing Thorns"] = 
--	L["Tank with Salvation"] = 
--	L["Out of range"] = 
--	L["RBS Tank List"] = 
--	L["Click to toggle the RBS dashboard"] = 
--	L["Right-click to open the addons options menu"] = 
--	L["Shaman is missing Water Shield"] = 
--	L["Tank missing Earth Shield"] = 


-- Talents window

	L["Talent Specialisations"] = "Talent Spezialisierung"
	L["Name"] = "Name"
	L["Class"] = "Klasse"
	L["Spec"] = "Skillung"
	L["Specialisations"] = "Spezialisierung"
	L["Can buff Divine Spirit"] = "beherrscht Verbesserter g\195\182ttlicher Wille"
	L["Can buff improved Divine Spirit level 1"] = "beherrscht Verbesserter g\195\182ttlicher Wille (Rang 1)"
	L["Can buff improved Divine Spirit level 2"] = "beherrscht Verbesserter g\195\182ttlicher Wille (Rang 2)"
	L["Can buff improved Mark of the Wild level 1"] = "beherrscht Verbessertes Mal der Wildnis (Rang 1)"
	L["Can buff improved Mark of the Wild level 2"] = "beherrscht Verbessertes Mal der Wildnis (Rang 2)"
	L["Can buff improved Mark of the Wild level 3"] = "beherrscht Verbessertes Mal der Wildnis (Rang 3)"
	L["Can buff improved Mark of the Wild level 4"] = "beherrscht Verbessertes Mal der Wildnis (Rang 4)"
	L["Can buff improved Mark of the Wild level 5"] = "beherrscht Verbessertes Mal der Wildnis (Rang 5)"
	L["Improved Health Stone level 1"] = "beherrscht Verbesserter Gesundheitsstein (Rang 1)"
	L["Improved Health Stone level 2"] = "beherrscht Verbesserter Gesundheitsstein (Rang 2)"
	L["Can create a Lightwell"] = "beherrscht Brunnen des Lichts"
	L["Can buff improved Power Word: Fortitude level 1"] = "beherrscht Verbessertes Machtwort: Seelenst\195\164rke (Rang 1)"
	L["Can buff improved Power Word: Fortitude level 2"] = "beherrscht Verbessertes Machtwort: Seelenst\195\164rke (Rang 2)"
	L["Can buff improved Demoralizing Shout level 1"] = "beherrscht Verbesserter Demolarisierungsruf (Rang 1)"
	L["Can buff improved Demoralizing Shout level 2"] = "beherrscht Verbesserter Demolarisierungsruf (Rang 2)"
	L["Can buff improved Demoralizing Shout level 3"] = "beherrscht Verbesserter Demolarisierungsruf (Rang 3)"
	L["Can buff improved Demoralizing Shout level 4"] = "beherrscht Verbesserter Demolarisierungsruf (Rang 4)"
	L["Can buff improved Demoralizing Shout level 5"] = "beherrscht Verbesserter Demolarisierungsruf (Rang 5)"
--	L["Can buff improved Battle Shout level 1"] =
--	L["Can buff improved Battle Shout level 2"] =
--	L["Can buff improved Battle Shout level 3"] =
--	L["Can buff improved Battle Shout level 4"] =
--	L["Can buff improved Battle Shout level 5"] =
	L["Can buff Blessing of Kings"] = "beherrscht Segen der K\195\182nige"
	L["Can buff Blessing of Sanctuary"] = "beherrscht Segen des Refugiums"
--	L["Can buff Earth Shield"] = 
--	L["Has Aura Mastery"] = 

-- Options window
	L["Buff Options"] = "Buff Optionen"
	L["Is a warning"] = "Ist eine Warnung"
	L["Is a buff"] = "Ist ein Buff"
	L["Show on dashboard"] = "Zeige auf der \195\156bersicht"
	L["Report on Boss"] = "Report bei Bossen"
	L["Report on Trash"] = "Report bei Trashmobs"
--	L["Show/Report in combat"] =

-- Blizzard addons window
--	L['Appearance'] =
--	L['Skin and minimap options'] =
--	L["Minimap icon"] =
--	L['Toggle to display a minimap icon'] =
--	L['Background colour'] =
--	L['Border colour'] =
--	L['Dashboard columns'] =
--	L['Number of columns to display on the dashboard'] =
--	L['Reporting'] =
--	L['Reporting options'] =
--	L['Ignore groups 6 to 8 when reporting as these are for subs'] =
--	L['Ignore groups 6 to 8'] =
--	L['Report to self'] =
--	L['Report to raid/party'] =
--	L['Report to raid/party - requires raid assistant'] =
--	L['Report to officers'] =
--	L['Report to officer channel'] =
--	L['Shorten names'] =
--	L['Shorten names in the report to reduce channel spam'] =
--	L['Combat'] = 
--	L['Combat options'] = 
--	L['Disable in combat'] = 
--	L['Hide dashboard and skip buff checking during combat'] = 
--	L['Show in party'] = 
--	L['Automatically show the dashboard when you join a party'] = 
--	L['Show in raid'] = 
--	L['Automatically show the dashboard when you join a raid'] = 
--	L['Prepend RBS::'] = 
--	L['Prepend RBS:: to all lines of report chat. Disable to only prepend on the first line of a report'] = 
--	L['Show group number'] = 
--	L['Show the group number of the person missing a party buff'] = 
