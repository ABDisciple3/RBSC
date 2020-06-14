local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("RaidBuffStatus", "frFR")
if not L then return end

-- French localization
-- Last update : 09/04/2008
-- By ( Veve CDO EU Server )

-- Command options

	L["Show the buff report dashboard."] = "Montrer la fen\195\170tre de rapports sur l\'\195\169tat des buffs."
	L["Hide the buff report dashboard."] = "Cacher la fen\195\170tre de rapports sur l\'\195\169tat des buffs."
	L["Report to /raid or /party who is not buffed to the max."] = "Faire un rapport au canal Raid ou Groupe pour ceux qui ne sont pas Max Full Buffs."
	L["Hide and show the buff report dashboard."] = "Cacher et Montrer la fen\195\170tre de rapports sur l\'\195\169tat des buffs"

-- Messages

	L["No buffs needed! (Boss)"] = "Plus besoin de buffs! (Boss)"
	L["No buffs needed! (Trash)"] = "Plus besoin de buffs! (Trash)"
	L["Not Well Fed"] = "Pas bien nourri"
	L["Missing Arcane Intellect"] = "Pas de Buff Intel"
	L["Missing Mark of the Wild"] = "Pas de Papate"
	L["Missing Divine Spirit"] = "Pas de Buff Esprit"
	L["Missing Power Word: Fortitude"] = "Pas d\'Endu"
	L["Missing Shadow Protection"] = "Pas de Protection Ombre"
	L["Flask or two Elixirs"] = "Flacon ou deux elixirs"
	L["Missing a Flask or two Elixirs"] = "Manque un Flacon ou Deux Elixirs"
	L["Battle Elixir"] = "Elixir de bataille"
	L["Missing a Battle Elixir"] = "Manque l\'elixir de bataille"
	L["Guardian Elixir"] = "Elixir du gardien"
	L["Missing a Guardian Elixir"] = "Manque l\'Elixir du gardien"
	L["Missing buffs (Trash): "] = "Buffs manquants (Trashs)"
	L["Missing buffs (Boss): "] = "Buffs manquants (Boss)"
	L["Warnings: "] = "Attention: "
	L["Paladin has Crusader Aura"] = "Paladin ayant l\'Aura de crois\195\169"
	L["PVP On"] = "PVP actif"
	L["PVP is On"] = "Qui a le PVP actif"
	L["AFK"] = "ABS"
	L["Player is AFK"] = "Qui est ABS"
	L["Offline"] = "Hors Ligne"
	L["Player is Offline"] = "Qui est Hors Ligne"
	L["Shadow Resistance Aura AND Shadow Protection"] = "Aura de r\195\169sistance \195\160 l\'ombre ET Protection contre l\'Ombre"
	L["Paladin has Shadow Resistance Aura AND Shadow Protection"] = "Paladin dispose de Aura de r\195\169sistance \195\160 l\'ombre ET Protection contre l\'Ombre"
	L["Paladin Aura"] = "Aura Paladin"
	L["Paladin has no Aura at all"] = "Paladin sans Aura active"
	L["Paladin Different Aura - Group"] = "Paladin autre Aura - Groupe"
	L["There are more Paladins than different Auras in group"] = "Il y a plus de Paladins que d\'Auras dans le groupe"
	L["Dead"] = "Mort"
	L["Player is Dead"] = "Perso est mort"
	L["Different Zone"] = "Zone Diff\195\169rente"
	L["Player is in a different zone"] = "Perso dans une Zone Diff\195\169rente"
	L["Health less than 80%"] = "Vie sous les 80%"
	L["Player has health less than 80%"] = "Perso avec vie sous les 80%"
	L["Mana less than 80%"] = "Mana sous les 80%"
	L["Player has mana less than 80%"] = "Perso avec Mana sous les 80%"
	L["Boss"] = "Boss"
	L["Trash"] = "Trash"
	L["R"] = "P" -- P is short for Prêt
	L["Aspect Cheetah/Pack On"] = "Aspect du Gu\195\169pard/Meute actif"
	L["Hunter Aspect"] = "Aspect chasseur"
	L["Aspect of the Cheetah or Pack is on"] = "Aspect du gu\195\169pard ou meute est actif"
	L["Hunter has no aspect at all"] = "Chasseur sans Aspect Actif"
--	L["Hunter is missing Trueshot Aura"] = ""
	L["Protection paladin with no Righteous Fury"] = "Paladin Protect sans Fureur vertueuse active"
	L["No Soulstone detected"] = "Pas de Pierre d\'Ame d\195\`169tect\195\169e"
	L["Someone has a Soulstone"] = "Pierre d\'Ame pos\195\169e"
	L["Priest is missing Inner Fire"] = "Pr\195\170tre sans Feu int\195\169rieur"
	L["Warlock is missing Fel Armor"] = "D\195\169moniste sans Gangrarmure"
	L["Druid is missing Omen of Clarity"] = "Druide sans Augure de clart\195\169"
	L["Mage is missing a Mage Armor"] = "Mage sans Armure du mage"
--	L["Warning: "] =
--	L["Missing buff: "] =
	L["Gruul's Lair"] = "Repaire de Gruul"
	L["Tempest Keep"] = "Donjon de la Tempête"
	L["Serpentshrine Cavern"] = "Caverne du sanctuaire du Serpent"
	L["Black Temple"] = "Temple noir"
	L["Sunwell Plateau"] = "Plateau du Puits de soleil"
	L["Hyjal Summit"] = "Sommet d'Hyjal"
--	L["Wrong flask for this zone"] =
--	L["Weapon buff"] =
--	L["Missing a temporary weapon buff"] =
--	L["(Ward of Shielding)"] =
--	L["^(Weighted %(%+%d+)"] =
--	L["^(Sharpened %(%+%d+)"] =
--	L["( Poison ?[IVX]*)"] =
--	L["(Mana Oil)"] =
--	L["(Wizard Oil)"] =
--	L["(Frost Oil)"] =
--	L["(Shadow Oil)"] =
--	L["(Weapon Coating)"] =
--	L["Wrong Paladin blessing"] =
--	L["Player has a wrong Paladin blessing"] =
--	L["Paladin blessing"] =
--	L["Player is missing at least one Paladin blessing"] =
--	L["Missing Amplify Magic"] =
--	L["RBS Dashboard Help"] =
--	L["Click buffs to disable and enable."] =
--	L["Shift-Click buffs to report on only that buff."] =
--	L["Ctrl-Click buffs to whisper those who need to buff."] =
--	L["Alt-Click on a self buff will renew that buff."] =
--	L["Alt-Click on a party buff will cast on someone missing that buff."] =
--	L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."] =
--	L["Remove this button from this dashboard in the options window."] =
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

	L["Talent Specialisations"] = "Sp\195\169cialisation des Talents"
	L["Name"] = "Nom"
	L["Class"] = "Classe"
	L["Spec"] = "Sp\195\169"
	L["Specialisations"] = "Sp\195\169cialisation"
	L["Can buff Divine Spirit"] = "Buff Esprit Possible"
	L["Can buff improved Divine Spirit level 1"] = "Buff Esprit Am\195\169lio Possible (Niv1)"
	L["Can buff improved Divine Spirit level 2"] = "Buff Esprit Am\195\169lio Possible (Niv2)"
	L["Can buff improved Mark of the Wild level 1"] = "Buff Papate Am\195\169lio (Niv1)"
	L["Can buff improved Mark of the Wild level 2"] = "Buff Papate Am\195\169lio (Niv2)"
	L["Can buff improved Mark of the Wild level 3"] = "Buff Papate Am\195\169lio (Niv3)"
	L["Can buff improved Mark of the Wild level 4"] = "Buff Papate Am\195\169lio (Niv4)"
	L["Can buff improved Mark of the Wild level 5"] = "Buff Papate Am\195\169lio (Niv5)"
	L["Improved Health Stone level 1"] = "Pierre de Soins Am\195\169lio (niv1)"
	L["Improved Health Stone level 2"] = "Pierre de Soins Am\195\169lio (niv2)"
	L["Can create a Lightwell"] = "Puit de Lumi\195\168re Possible"
	L["Can buff improved Power Word: Fortitude level 1"] = "Endu Am\195\169lio (Niv1)"
	L["Can buff improved Power Word: Fortitude level 2"] = "Endu Am\195\169lio (Niv2)"
--	L["Can buff improved Demoralizing Shout level 1"] =
--	L["Can buff improved Demoralizing Shout level 2"] =
--	L["Can buff improved Demoralizing Shout level 3"] =
--	L["Can buff improved Demoralizing Shout level 4"] =
--	L["Can buff improved Demoralizing Shout level 5"] =
--	L["Can buff improved Battle Shout level 1"] =
--	L["Can buff improved Battle Shout level 2"] =
--	L["Can buff improved Battle Shout level 3"] =
--	L["Can buff improved Battle Shout level 4"] =
--	L["Can buff improved Battle Shout level 5"] =
--	L["Can buff Blessing of Kings"] =
--	L["Can buff Blessing of Sanctuary"] =
--	L["Can buff Earth Shield"] = 
--	L["Has Aura Mastery"] = 

-- Options window
--	L["Buff Options"] =
--	L["Is a warning"] =
--	L["Is a buff"] =
--	L["Show on dashboard"] =
--	L["Report on Boss"] =
--	L["Report on Trash"] =
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
