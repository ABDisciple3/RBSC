local AceConfig = LibStub('AceConfigDialog-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('RaidBuffStatus')

RaidBuffStatus = LibStub("AceAddon-3.0"):NewAddon("RaidBuffStatus", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

RaidBuffStatus.L = L

inspectqueuename = ""
local inspectqueueunitid = ""
local inspectqueueclass = ""
local inspectqueuetime = 0
local buttons = {}
local optionsbuttons = {}
local incombat = false
local dashwasdisplayed = true
local tankList = '|'
local nextscan = 0
local timer = false


-- babblespell replacement using GetSpellInfo(key)
local BSmeta = {
	__index = function(self, key)
		local name, icon
		if type(key) == "number" then
			name, _, icon = GetSpellInfo(key)
		elseif type(key) == "string" then
			geterrorhandler()(("No longer supported call by name name %q"):format(key))
		else
			geterrorhandler()(("Unknown spell key %q"):format(key))
		end
		if name then
			BS[key] = name
			BS[name] = name
			BSI[key] = icon
			BSI[name] = icon
		else
			BS[key] = false
			BSI[key] = false
			geterrorhandler()(("Unknown spell info key %q"):format(key))
		end
		return self[key]
	end,
}
BS = setmetatable({}, BSmeta)
BSI = setmetatable({}, BSmeta)

local function SpellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end

-- Thanks to BigBrother developers saving me time looking these up!

local flasks = {
	SpellName(17626), -- 17626 Flask of the Titans
	SpellName(17627), -- 17627 [Flask of] Distilled Wisdom
	SpellName(17628), -- 17628 [Flask of] Supreme Power
	SpellName(17629), -- 17629 [Flask of] Chromatic Resistance
	SpellName(28518), -- 28518 Flask of Fortification
	SpellName(28519), -- 28519 Flask of Mighty Restoration
	SpellName(28520), -- 28520 Flask of Relentless Assault
	SpellName(28521), -- 28521 Flask of Blinding Light
	SpellName(28540), -- 28540 Flask of Pure Death
	SpellName(33053), -- 33053 Mr. Pinchy's Blessing
	SpellName(42735), -- 42735 [Flask of] Chromatic Wonder
	SpellName(40567), -- 40567 Unstable Flask of the Bandit
	SpellName(40568), -- 40568 Unstable Flask of the Elder
	SpellName(40572), -- 40572 Unstable Flask of the Beast
	SpellName(40573), -- 40573 Unstable Flask of the Physician
	SpellName(40575), -- 40575 Unstable Flask of the Soldier
	SpellName(40576), -- 40576 Unstable Flask of the Sorcerer
	SpellName(41608), -- 41608 Relentless Assault of Shattrath
	SpellName(41609), -- 41609 Fortification of Shattrath
	SpellName(41610), -- 41610 Mighty Restoration of Shattrath
	SpellName(41611), -- 41611 Supreme Power of Shattrath
	SpellName(46837), -- 46837 Pure Death of Shattrath
	SpellName(46839), -- 46839 Blinding Light of Shattrath
}


local belixirs = {
	SpellName(11390),-- 11390 Arcane Elixir
	SpellName(17538),-- 17538 Elixir of the Mongoose
	SpellName(17539),-- 17539 Greater Arcane Elixir
	SpellName(28490),-- 28490 Major Strength
	SpellName(28491),-- 28491 Healing Power
	SpellName(28493),-- 28493 Major Frost Power
	SpellName(28497),-- 28497 Major Agility
	SpellName(28501),-- 28501 Major Firepower
	SpellName(28503),-- 28503 Major Shadow Power
	SpellName(38954),-- 38954 Fel Strength Elixir
	SpellName(33720),-- 33720 Onslaught Elixir
	SpellName(33721),-- 33721 Adept's Elixir
	SpellName(33726),-- 33726 Elixir of Mastery
	SpellName(26276),-- 26276 Elixir of Greater Firepower
	SpellName(45373),-- 45373 Bloodberry - only works on Sunwell Plateau
}
local gelixirs = {
	SpellName(11348),-- 11348 Greater Armor/Elixir of Superior Defense
	SpellName(11396),-- 11396 Greater Intellect
	SpellName(24363),-- 24363 Mana Regeneration/Mageblood Potion
	SpellName(28502),-- 28502 Major Armor/Elixir of Major Defense
	SpellName(28509),-- 28509 Greater Mana Regeneration/Elixir of Major Mageblood
	SpellName(28514),-- 28514 Empowerment
	SpellName(29626),-- 29626 Earthen Elixir
	SpellName(39625),-- 39625 Elixir of Major Fortitude
	SpellName(39627),-- 39627 Elixir of Draenic Wisdom
	SpellName(39628),-- 39628 Elixir of Ironskin
}

local foods = {
	SpellName(35272), -- Well Fed
	SpellName(44106), -- "Well Fed" from Brewfest
	SpellName(43730), -- Electrified
	SpellName(43722), -- Enlightened
	SpellName(25661), -- Increased Stamina
	SpellName(25804), -- Rumsey Rum Black Label
}

local fortitude = {
	SpellName(1243), -- Power Word: Fortitude
	SpellName(21562), -- Prayer of Fortitude
}

local wild = {
	SpellName(1126), -- Mark of the Wild
	SpellName(21849), -- Gift of the Wild
}

local intellect = {
	SpellName(1459), -- Arcane Intellect
	SpellName(23028), -- Arcane Brilliance
}

local spirit = {
	SpellName(14752), -- Divine Spirit
	SpellName(27681), -- Prayer of Spirit
}

local shadow = {
	SpellName(976), -- Shadow Protection
	SpellName(27683), -- Prayer of Shadow Protection
}

local auras = {
	SpellName(32223), -- Crusader Aura
	SpellName(465), -- Devotion Aura
	SpellName(7294), -- Retribution Aura
	SpellName(19746), -- Concentration Aura
	SpellName(20218), -- Sanctity Aura
	SpellName(19876), -- Shadow Resistance Aura
	SpellName(19888), -- Frost Resistance Aura
	SpellName(19891), -- Fire Resistance Aura
}

local aspects = {
	SpellName(13163), -- Aspect of the Monkey
	SpellName(13165), -- Aspect of the Hawk
	SpellName(13161), -- Aspect of the Beast
	SpellName(20043), -- Aspect of the Wild
	SpellName(34074), -- Aspect of the Viper
	SpellName(5118), -- Aspect of the Cheetah
	SpellName(13159), -- Aspect of the Pack
}

local badaspects = {
	SpellName(5118), -- Aspect of the Cheetah
	SpellName(13159), -- Aspect of the Pack
}

local magearmors = {
	SpellName(6117), -- Mage Armor
	SpellName(168), -- Frost Armor
	SpellName(7302), -- Ice Armor
	SpellName(30482), -- Molten Armor
}


local blessings = {
	BS[19742], -- Blessing of Wisdom
	BS[25894], -- Greater Blessing of Wisdom
	BS[19740], -- Blessing of Might
	BS[25782], -- Greater Blessing of Might
	BS[1038], -- Blessing of Salvation
	BS[25895], -- Greater Blessing of Salvation
	BS[19977], -- Blessing of Light
	BS[25890], -- Greater Blessing of Light
	BS[20217], -- Blessing of Kings
	BS[25898], -- Greater Blessing of Kings
	BS[27168], -- Blessing of Sanctuary
	BS[27169], -- Greater Blessing of Sanctuary
}

local blessingsns = {
	BS[19742], -- Blessing of Wisdom
	BS[25894], -- Greater Blessing of Wisdom
	BS[19740], -- Blessing of Might
	BS[25782], -- Greater Blessing of Might
	BS[19977], -- Blessing of Light
	BS[25890], -- Greater Blessing of Light
	BS[20217], -- Blessing of Kings
	BS[25898], -- Greater Blessing of Kings
	BS[27168], -- Blessing of Sanctuary
	BS[27169], -- Greater Blessing of Sanctuary
}

local wisdom = {
	BS[19742], -- Blessing of Wisdom
	BS[25894], -- Greater Blessing of Wisdom
}

local might = {
	BS[19740], -- Blessing of Might
	BS[25782], -- Greater Blessing of Might
}

local flaskzones = {
	gruul = {
		zones = {
			L["Gruul's Lair"],
		},
		flasks = {
			SpellName(40567), -- 40567 Unstable Flask of the Bandit
			SpellName(40568), -- 40568 Unstable Flask of the Elder
			SpellName(40572), -- 40572 Unstable Flask of the Beast
			SpellName(40573), -- 40573 Unstable Flask of the Physician
			SpellName(40575), -- 40575 Unstable Flask of the Soldier
			SpellName(40576), -- 40576 Unstable Flask of the Sorcerer
		},
	},
	shattrath = {
		zones = {
			L["Tempest Keep"],
			L["Serpentshrine Cavern"],
			L["Black Temple"],
			L["Sunwell Plateau"],
			L["Hyjal Summit"],
		},
		flasks = {
			SpellName(41608), -- 41608 Relentless Assault of Shattrath
			SpellName(41609), -- 41609 Fortification of Shattrath
			SpellName(41610), -- 41610 Mighty Restoration of Shattrath
			SpellName(41611), -- 41611 Sureme Power of Shattrath
			SpellName(46837), -- 46837 Pure Death of Shattrath
			SpellName(46839), -- 46839 Blinding Light of Shattrath
		},
	},
}

-- Thanks to MoBuffs for the original list
local wepbuffs = {
	L["(Ward of Shielding)"], -- (Lesser|Greater) Ward of Shielding
	L["^(Weighted %(%+%d+)"], -- Weighted (+xx 
	L["^(Sharpened %(%+%d+)"], -- Sharpened (+xx 
	L["( Poison ?[IVX]*)"], -- Anesthetic Poison, Deadly Poison [IVX]*, Crippling Poison [IVX]*, Wound Poison [IVX]*, Instant Poison [IVX]*, Mind-numbing Poison [IVX]*
	L["(Mana Oil)"], -- (Minor|Superior|Brillant|Blessed) Mana Oil
	L["(Wizard Oil)"], -- (Minor|Superior|Brillant|Blessed) Wizard Oil
	L["(Frost Oil)"], -- Frost Oil
	L["(Shadow Oil)"], -- Shadow Oil
	L["(Weapon Coating)"], -- Blessed Weapon Coating or Righteous Weapon Coating
}

local classes = {
	"PRIEST",
	"DRUID",
	"PALADIN",
	"ROGUE",
	"MAGE",
	"WARLOCK",
	"SHAMAN",
	"WARRIOR",
	"HUNTER",
}


raid = {
	classes = {
		PRIEST = {},
		DRUID = {},
		PALADIN = {},
		ROGUE = {},
		MAGE = {},
		WARLOCK = {},
		SHAMAN = {},
		WARRIOR = {},
		HUNTER = {},
	},
	SpiritTalent = {},
	KingsTalent = {},
	SanctuaryTalent = {},
	ClassNumbers = {},
	BuffTimers = {},
	TankList = {},
	israid = false,
	isparty = false,
	readid = 0,
	size = 1,
}
raid.reset = function()
	raid.classes = {}
	raid.classes.PRIEST = {}
	raid.classes.DRUID = {}
	raid.classes.PALADIN = {}
	raid.classes.ROGUE = {}
	raid.classes.MAGE = {}
	raid.classes.WARLOCK = {}
	raid.classes.SHAMAN = {}
	raid.classes.WARRIOR = {}
	raid.classes.HUNTER = {}
	raid.SpiritTalent = {}
	raid.KingsTalent = {}
	raid.SanctuaryTalent = {}
	raid.ClassNumbers = {}
	raid.BuffTimers = {}
	raid.TankList = {}
	raid.israid = false
	raid.isparty = false
	raid.readid = 0
	raid.size = 1
end


local specicons = {
	UNKNOWN = "Interface\\Icons\\INV_Misc_QuestionMark",
	Hybrid = "Interface\\Icons\\Spell_Nature_ElementalAbsorption",
}

local classicons = {
	PALADIN = "Interface\\Icons\\Ability_ThunderBolt",
	PRIEST = "Interface\\Icons\\INV_Staff_30",
	DRUID = "Interface\\Icons\\Ability_Druid_Maul",
	MAGE = "Interface\\Icons\\INV_Staff_13",
	ROGUE = "Interface\\Icons\\INV_ThrowingKnife_04",
	WARLOCK = "Interface\\Icons\\Spell_Nature_FaerieFire",
	SHAMAN = "Interface\\Icons\\Spell_Nature_BloodLust",
	WARRIOR = "Interface\\Icons\\INV_Sword_27",
	HUNTER = "Interface\\Icons\\INV_Weapon_Bow_07",
	UNKNOWN = "Interface\\Icons\\INV_Misc_QuestionMark",
}


local tfi = {
	namewidth = 120,
	classwidth = 50,
	specwidth = 50,
	specialisationswidth = 160,
	gap = 2,
	edge = 5,
	inset = 3,
	topedge = 45,
	rowheight = 17,
	rowgap = 0,
	maxrows = 40,
	okbuttonheight = 55,
	rowdata = {},
	rowframes = {},
	buttonsize = 15,
	sort = "class",
	sortorder = 1,
}
tfi.namex = tfi.edge
tfi.classx = tfi.namex + tfi.namewidth + tfi.gap
tfi.specx = tfi.classx + tfi.classwidth + tfi.gap
tfi.specialisationsx = tfi.specx + tfi.specwidth + tfi.gap
tfi.framewidth = tfi.specialisationsx + tfi.specialisationswidth + tfi.edge
tfi.rowwidth = tfi.framewidth - tfi.edge - tfi.edge - tfi.inset - tfi.inset


SP = {
	spirittalent = {
		order = 1000,
		icon = BSI[14752], -- Divine Spirit
		tip = L["Can buff Divine Spirit"],
		callalways = true,
		code = function()
			raid.SpiritTalent = {}
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[1].talent[14] > 0 then
						table.insert(raid.SpiritTalent, name)
						raid.classes.PRIEST[name].talents.specialisations.spirittalent = true
					end
				end
			end
		end,
	},
	improvedspiritone = {
		order = 990,
		icon = BSI[14752], -- Divine Spirit
		tip = L["Can buff improved Divine Spirit level 1"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[1].talent[15] > 0 then
						raid.classes.PRIEST[name].talents.specialisations.improvedspiritone = true
					end
				end
			end
		end,
	},
	improvedspirittwo = {
		order = 980,
		icon = BSI[14752], -- Divine Spirit
		tip = L["Can buff improved Divine Spirit level 2"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[1].talent[15] > 1 then
						raid.classes.PRIEST[name].talents.specialisations.improvedspirittwo = true
					end
				end
			end
		end,
	},
	improvedmotwone = {
		order = 970,
		icon = BSI[1126], -- Mark of the Wild
		tip = L["Can buff improved Mark of the Wild level 1"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[1] > 0 then
						raid.classes.DRUID[name].talents.specialisations.improvedmotwone = true
					end
				end
			end
		end,
	},
	improvedmotwtwo = {
		order = 960,
		icon = BSI[1126], -- Mark of the Wild
		tip = L["Can buff improved Mark of the Wild level 2"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[1] > 1 then
						raid.classes.DRUID[name].talents.specialisations.improvedmotwtwo = true
					end
				end
			end
		end,
	},
	improvedmotwthree = {
		order = 950,
		icon = BSI[1126], -- Mark of the Wild
		tip = L["Can buff improved Mark of the Wild level 3"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[1] > 2 then
						raid.classes.DRUID[name].talents.specialisations.improvedmotwthree = true
					end
				end
			end
		end,
	},
	improvedmotwfour = {
		order = 940,
		icon = BSI[1126], -- Mark of the Wild
		tip = L["Can buff improved Mark of the Wild level 4"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[1] > 3 then
						raid.classes.DRUID[name].talents.specialisations.improvedmotwfour = true
					end
				end
			end
		end,
	},
	improvedmotwfive = {
		order = 930,
		icon = BSI[1126], -- Mark of the Wild
		tip = L["Can buff improved Mark of the Wild level 5"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[1] > 4 then
						raid.classes.DRUID[name].talents.specialisations.improvedmotwfive = true
					end
				end
			end
		end,
	},

	improvedhealthstoneone = {
		order = 920,
		icon = "Interface\\Icons\\INV_Stone_04",
		tip = L["Improved Health Stone level 1"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARLOCK) do
				if raid.classes.WARLOCK[name].talents then
					if raid.classes.WARLOCK[name].talents.tree[2].talent[1] > 0 then
						raid.classes.WARLOCK[name].talents.specialisations.improvedhealthstoneone = true
					end
				end
			end
		end,
	},
	improvedhealthstonetwo = {
		order = 920,
		icon = "Interface\\Icons\\INV_Stone_04",
		tip = L["Improved Health Stone level 2"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARLOCK) do
				if raid.classes.WARLOCK[name].talents then
					if raid.classes.WARLOCK[name].talents.tree[2].talent[1] > 1 then
						raid.classes.WARLOCK[name].talents.specialisations.improvedhealthstonetwo = true
					end
				end
			end
		end,
	},
	lightwell = {
		order = 910,
		icon = BSI[724], -- Lightwell
		tip = L["Can create a Lightwell"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[2].talent[18] > 0 then
						raid.classes.PRIEST[name].talents.specialisations.lightwell = true
					end
				end
			end
		end,
	},
	improvedfortitudeone = {
		order = 900,
		icon = BSI[1243], -- Power Word: Fortitude
		tip = L["Can buff improved Power Word: Fortitude level 1"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[1].talent[4] > 0 then
						raid.classes.PRIEST[name].talents.specialisations.improvedfortitudeone = true
					end
				end
			end
		end,
	},
	improvedfortitudetwo = {
		order = 890,
		icon = BSI[1243], -- Power Word: Fortitude
		tip = L["Can buff improved Power Word: Fortitude level 2"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					if raid.classes.PRIEST[name].talents.tree[1].talent[4] > 1 then
						raid.classes.PRIEST[name].talents.specialisations.improvedfortitudetwo = true
					end
				end
			end
		end,
	},
	improveddemoone = {
		order = 880,
		icon = BSI[1160], -- Demoralizing Shout
		tip = L["Can buff improved Demoralizing Shout level 1"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[3] > 0 then
						raid.classes.WARRIOR[name].talents.specialisations.improveddemoone = true
					end
				end
			end
		end,
	},
	improveddemotwo = {
		order = 870,
		icon = BSI[1160], -- Demoralizing Shout
		tip = L["Can buff improved Demoralizing Shout level 2"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[3] > 1 then
						raid.classes.WARRIOR[name].talents.specialisations.improveddemotwo = true
					end
				end
			end
		end,
	},
	improveddemothree = {
		order = 860,
		icon = BSI[1160], -- Demoralizing Shout
		tip = L["Can buff improved Demoralizing Shout level 3"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[3] > 2 then
						raid.classes.WARRIOR[name].talents.specialisations.improveddemothree = true
					end
				end
			end
		end,
	},
	improveddemofour = {
		order = 850,
		icon = BSI[1160], -- Demoralizing Shout
		tip = L["Can buff improved Demoralizing Shout level 4"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[3] > 3 then
						raid.classes.WARRIOR[name].talents.specialisations.improveddemofour = true
					end
				end
			end
		end,
	},
	improveddemofive = {
		order = 840,
		icon = BSI[1160], -- Demoralizing Shout
		tip = L["Can buff improved Demoralizing Shout level 5"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[3] > 4 then
						raid.classes.WARRIOR[name].talents.specialisations.improveddemofive = true
					end
				end
			end
		end,
	},
	improvedbattleone = {
		order = 780,
		icon = BSI[2048], -- Battle Shout
		tip = L["Can buff improved Battle Shout level 1"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[8] > 0 then
						raid.classes.WARRIOR[name].talents.specialisations.improvedbattleone = true
					end
				end
			end
		end,
	},
	improvedbattletwo = {
		order = 770,
		icon = BSI[2048], -- Battle Shout
		tip = L["Can buff improved Battle Shout level 2"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[8] > 1 then
						raid.classes.WARRIOR[name].talents.specialisations.improvedbattletwo = true
					end
				end
			end
		end,
	},
	improvedbattlethree = {
		order = 760,
		icon = BSI[2048], -- Battle Shout
		tip = L["Can buff improved Battle Shout level 3"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[8] > 2 then
						raid.classes.WARRIOR[name].talents.specialisations.improvedbattlethree = true
					end
				end
			end
		end,
	},
	improvedbattlefour = {
		order = 750,
		icon = BSI[2048], -- Battle Shout
		tip = L["Can buff improved Battle Shout level 4"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[8] > 3 then
						raid.classes.WARRIOR[name].talents.specialisations.improvedbattlefour = true
					end
				end
			end
		end,
	},
	improvedbattlefive = {
		order = 740,
		icon = BSI[2048], -- Battle Shout
		tip = L["Can buff improved Battle Shout level 5"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.WARRIOR) do
				if raid.classes.WARRIOR[name].talents then
					if raid.classes.WARRIOR[name].talents.tree[2].talent[8] > 4 then
						raid.classes.WARRIOR[name].talents.specialisations.improvedbattlefive = true
					end
				end
			end
		end,
	},
	blessingofkings = {
		order = 830,
		icon = BSI[20217], -- Blessing of Kings
		tip = L["Can buff Blessing of Kings"],
		callalways = true,
		code = function()
			raid.KingsTalent = {}
			for name,_ in pairs(raid.classes.PALADIN) do
				if raid.classes.PALADIN[name].talents then
					if raid.classes.PALADIN[name].talents.tree[2].talent[6] > 0 then
						table.insert(raid.KingsTalent, name)
						raid.classes.PALADIN[name].talents.specialisations.blessingofkings = true
					end
				end
			end
		end,
	},
	blessingofsanctuary = {
		order = 820,
		icon = BSI[27168], -- Blessing of Sanctuary,
		tip = L["Can buff Blessing of Sanctuary"],
		callalways = true,
		code = function()
			raid.SanctuaryTalent = {}
			for name,_ in pairs(raid.classes.PALADIN) do
				if raid.classes.PALADIN[name].talents then
					if raid.classes.PALADIN[name].talents.tree[2].talent[14] > 0 then
						table.insert(raid.SanctuaryTalent, name)
						raid.classes.PALADIN[name].talents.specialisations.blessingofsanctuary = true
					end
				end
			end
		end,
	},
	auramastery = {
		order = 815,
		icon = "Interface\\Icons\\Spell_Holy_AuraMastery",
		tip = L["Has Aura Mastery"],
		callalways = false,
		code = function()
			for name,_ in pairs(raid.classes.PALADIN) do
				if raid.classes.PALADIN[name].talents then
					if raid.classes.PALADIN[name].talents.tree[1].talent[6] > 0 then
						raid.classes.PALADIN[name].talents.specialisations.auramastery = true
					end
				end
			end
		end,
	},
	earthshield = {
		order = 810,
		icon = BSI[32594], -- Earth Shield
		tip = L["Can buff Earth Shield"],
		callalways = true,
		code = function()
			for name,_ in pairs(raid.classes.SHAMAN) do
				if raid.classes.SHAMAN[name].talents then
					if raid.classes.SHAMAN[name].talents.tree[3].talent[20] > 0 then
						raid.classes.SHAMAN[name].talents.specialisations.earthshield = true
					end
				end
			end
		end,
	},
}


BF = {
	pvp = {											-- button name
		order = 1000,
		list = "pvplist",								-- list name
		check = "checkpvp",								-- check name
		default = true,									-- default state enabled
		defaultbuff = false,								-- default state report as buff missing
		defaultwarning = true,								-- default state report as warning
		defaultdash = true,								-- default state show on dash
		defaultdashcombat = false,							-- default state show on dash when in combat
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,								-- check when unit is not in this zone
		selfbuff = true,								-- is it a buff the player themselves can fix
		timer = true,									-- rbs will count how many minutes this buff has been missing/active
		chat = L["PVP On"],								-- chat report
		pre = nil,
		main = function(self, name, class, unit, raid, report)				-- called in main loop
			if UnitIsPVP(unit.unitid) then
				table.insert(report.pvplist, name)
			end
		end,
		post = nil,									-- called after main loop
		icon = "Interface\\Icons\\INV_BannerPVP_02",					-- icon
		update = function(self)								-- icon text
			RaidBuffStatus:DefaultButtonUpdate(self, report.pvplist, RaidBuffStatus.db.profile.checkpvp, true)
		end,
		click = function(self, button, down)						-- button click
			RaidBuffStatus:ButtonClick(self, button, down, "pvp")
		end,
		tip = function(self)								-- tool tip
			RaidBuffStatus:Tooltip(self, L["PVP is On"], report.pvplist, raid.BuffTimers.pvptimerlist)
		end,
		partybuff = nil,
	},
	crusader = {
		order = 990,
		list = "crusaderlist",
		check = "checkcrusader",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[32223], -- Crusader Aura
		main = function(self, name, class, unit, raid, report)
			if class == "PALADIN" then
				report.checking.crusader = true
				if unit.hasbuff[BS[32223]] then -- Crusader Aura
					table.insert(report.crusaderlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[32223], -- Crusader Aura
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.crusaderlist, RaidBuffStatus.db.profile.checkcrusader, report.checking.crusader or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "crusader")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Paladin has Crusader Aura"], report.crusaderlist)
		end,
		partybuff = nil,
	},

	shadows = {
		order = 980,
		list = "shadowslist",
		check = "checkshadows",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Shadow Resistance Aura AND Shadow Protection"],
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 then
				if class == "PALADIN" then
					report.checking.shadows = true
					if unit.hasbuff[BS[19876]] then -- Shadow Resistance Aura
						table.insert(report.shadowslist, name)
					end
				end
			end
		end,
		post = nil,
		icon = BSI[19876], -- Shadow Resistance Aura
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.shadowslist, RaidBuffStatus.db.profile.checkshadows, report.checking.shadows or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "shadows")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Paladin has Shadow Resistance Aura AND Shadow Protection"], report.shadowslist)
		end,
		partybuff = nil,
	},

	wrongblessing = {
		order = 975,
		list = "wrongblessinglist",
		check = "checkwrongblessing",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = L["Wrong Paladin blessing"],
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PALADIN < 1 then
				return
			end
			report.checking.wrongblessing = true
			if class == "ROGUE" then
				local hasbuff = false
				for _, v in ipairs(wisdom) do
					if unit.hasbuff[v] then
						hasbuff = true
						break
					end
				end
				if hasbuff then
					table.insert(report.wrongblessinglist, name .. "(" .. BS[19742] .. ")" ) -- Blessing of Wisdom
				end
			elseif class == "MAGE" or class == "WARLOCK" or class == "PRIEST" then
				local hasbuff = false
				for _, v in ipairs(might) do
					if unit.hasbuff[v] then
						hasbuff = true
						break
					end
				end
				if hasbuff then
					table.insert(report.wrongblessinglist, name .. "(" .. BS[19740] .. ")" ) -- Blessing of Might
				end
			end
		end,
		post = nil,
		icon = BSI[19740], -- Blessing of Might
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.wrongblessinglist, RaidBuffStatus.db.profile.checkwrongblessing, report.checking.wrongblessing or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "wrongblessing")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player has a wrong Paladin blessing"], report.wrongblessinglist)
		end,
		partybuff = nil,
	},

	health = {
		order = 970,
		list = "healthlist",
		check = "checkhealth",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Health less than 80%"],
		main = function(self, name, class, unit, raid, report)
			if not unit.isdead then
				local maxhealth = UnitHealthMax(unit.unitid)
				local health = UnitHealth(unit.unitid)
				local percent = (health/maxhealth)*100
				if percent < 80 then
					table.insert(report.healthlist, name)
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_131",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.healthlist, RaidBuffStatus.db.profile.checkhealth, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "health")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player has health less than 80%"], report.healthlist)
		end,
		partybuff = nil,
	},

	mana = {
		order = 960,
		list = "manalist",
		check = "checkmana",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Mana less than 80%"],
		main = function(self, name, class, unit, raid, report)
			if not unit.isdead then
				if class ~= "WARRIOR" and class ~= "ROGUE" then
					local maxmana = UnitManaMax(unit.unitid)
					local mana = UnitMana(unit.unitid)
					local percent = (mana/maxmana)*100
					if percent < 80 then
						table.insert(report.manalist, name)
					end
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_137",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.manalist, RaidBuffStatus.db.profile.checkmana, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "mana")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player has mana less than 80%"], report.manalist)
		end,
		partybuff = nil,
	},
	zone = {
		order = 950,
		list = "zonelist",
		check = "checkzone",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true, -- actually has no effect
		selfbuff = false,
		timer = false,
		chat = L["Different Zone"],
		main = nil, -- done by main code
		post = nil,
		icon = "Interface\\Icons\\INV_Misc_QuestionMark",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.zonelist, RaidBuffStatus.db.profile.checkzone, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "zone")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player is in a different zone"], report.zonelist)
		end,
		partybuff = nil,
	},

	offline = {
		order = 940,
		list = "offlinelist",
		check = "checkoffline",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true, -- actualy has no effect
		selfbuff = false,
		timer = true,
		chat = L["Offline"],
		main = nil, -- done by main code
		post = nil,
		icon = "Interface\\Icons\\INV_Gizmo_FelStabilizer",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.offlinelist, RaidBuffStatus.db.profile.checkoffline, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "offline")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player is Offline"], report.offlinelist, raid.BuffTimers.offlinetimerlist)
		end,
		partybuff = nil,
	},

	afk = {
		order = 930,
		list = "afklist",
		check = "checkafk",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,
		selfbuff = true,
		timer = true,
		chat = L["AFK"],
		main = function(self, name, class, unit, raid, report)
			if UnitIsAFK(unit.unitid) then
				table.insert(report.afklist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\Trade_Fishing",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.afklist, RaidBuffStatus.db.profile.checkafk, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "afk")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player is AFK"], report.afklist, raid.BuffTimers.afktimerlist)
		end,
		partybuff = nil,
	},

	dead = {
		order = 920,
		list = "deadlist",
		check = "checkdead",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,
		selfbuff = false,
		timer = true,
		chat = L["Dead"],
		main = function(self, name, class, unit, raid, report)
			if unit.isdead then
				table.insert(report.deadlist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\Spell_Holy_SenseUndead",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.deadlist, RaidBuffStatus.db.profile.checkdead, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "dead")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player is Dead"], report.deadlist, raid.BuffTimers.deadtimerlist)
		end,
		partybuff = nil,
	},


	auras = {
		order = 910,
		list = "auraslist",
		check = "checkauras",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = function(report, raid, prefix)
			prefix = prefix or ""
			for _, v in ipairs(report.auraslist) do
				local palalist = {}
				for i, k in pairs(raid.classes.PALADIN) do
					if k.group == v then
						table.insert(palalist, i)
					end
				end
				RaidBuffStatus:Say(prefix .. "<" .. L["Paladin Different Aura - Group"] .. ">: " .. v .. ": " .. table.concat(palalist, ", "))
			end
		end,
		pre = function(self, raid, report)
			report.palapergrouplist = {{},{},{},{},{},{},{},{}}
			report.palaaurapergrouplist = {{},{},{},{},{},{},{},{}}
		end,
		main = function(self, name, class, unit, raid, report)
			if class == "PALADIN" then
				report.checking.auras = true
				table.insert(report.palapergrouplist[unit.group], name)
				for _, v in ipairs(auras) do
					if unit.hasbuff[v] then
						local foundauraingroup = false
						for _, k in ipairs(report.palaaurapergrouplist[unit.group]) do
							if v == k then
								foundauraingroup = true
								break
							end
						end
						if not foundauraingroup then
							table.insert(report.palaaurapergrouplist[unit.group], v)
						end
					end
				end
			end
		end,
		post = function(self, raid, report)
			for i, v in ipairs(report.palapergrouplist) do
			if # v > 1 then
				if # v > # report.palaaurapergrouplist[i] then
					table.insert(report.auraslist, i)
				end
			end
		end
		end,
		icon = BSI[7294], -- Retribution Aura
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.auraslist, RaidBuffStatus.db.profile.checkauras, report.checking.auras or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "auras")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["There are more Paladins than different Auras in group"], report.auraslist)
		end,
		partybuff = nil,
	},

	cheetahpack = {
		order = 900,
		list = "cheetahpacklist",
		check = "checkcheetahpack",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Aspect Cheetah/Pack On"],
		main = function(self, name, class, unit, raid, report)
			if class == "HUNTER" then
				report.checking.cheetahpack = true
				local hasbuff = false
				for _, v in ipairs(badaspects) do
					if unit.hasbuff[v] then
						hasbuff = true
						break
					end
				end
				if hasbuff then
					if RaidBuffStatus.db.profile.ReportGroupNumber then
						table.insert(report.cheetahpacklist, name .. "(" .. unit.group .. ")" )
					else
						table.insert(report.cheetahpacklist, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.cheetahpacklist)
		end,
		icon = BSI[5118], -- Aspect of the Cheetah
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.cheetahpacklist, RaidBuffStatus.db.profile.checkcheetahpack, report.checking.cheetahpack or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "cheetahpack")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Aspect of the Cheetah or Pack is on"], report.cheetahpacklist)
		end,
		partybuff = nil,
	},

	righteousfury = {
		order = 890,
		list = "righteousfurylist",
		check = "checkrighteousfury",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[25780], -- Righteous Fury
		main = function(self, name, class, unit, raid, report)
			if class == "PALADIN" then
				report.checking.righteousfury = true
				if raid.classes.PALADIN[name].talents then
					if raid.classes.PALADIN[name].talents.spec == "Protection" then
						if not unit.hasbuff[BS[25780]] then -- Righteous Fury
							table.insert(report.righteousfurylist, name)
						end
					end
				end
			end
		end,
		post = nil,
		icon = BSI[25780], -- Righteous Fury
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.righteousfurylist, RaidBuffStatus.db.profile.checkrighteousfury, report.checking.righteousfury or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "righteousfury", BS[25780]) -- Righteous Fury
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Protection paladin with no Righteous Fury"], report.righteousfurylist)
		end,
		partybuff = nil,
	},

	thorns = {
		order = 880,
		list = "thornslist",
		check = "checkthorns",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[26992],  -- Thorns
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.DRUID < 1 then
				return
			end
			if not unit.istank then
				return  -- only tanks need thorns
			end
			if class == "PALADIN" or class == "DRUID" or class == "WARRIOR" then  -- only mele tanks need thorns
				report.checking.thorns = true
				if not unit.hasbuff[BS[26992]] then  -- Thorns
					table.insert(report.thornslist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[26992],  -- Thorns
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.thornslist, RaidBuffStatus.db.profile.checkthorns, report.checking.thorns or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "thorns", BS[26992], BS[26992], true)  -- Thorns
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Tank missing Thorns"], report.thornslist, nil, BF.thorns:buffers())
		end,
		partybuff = function(reportl, prefix)
			for name,_ in pairs(raid.classes.DRUID) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.thorns.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thedruids = {}
			for name,_ in pairs(raid.classes.DRUID) do
				table.insert(thedruids, name)
			end
			return thedruids
		end,
	},

	earthshield = {
		order = 875,
		list = "earthshieldlist",
		check = "checkearthshield",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[32594],  -- Earth Shield
		pre = function(self, raid, report)
			report.tanksneedingearthshield = {}
			report.tanksgotearthshield = {}
			report.shamanwithearthshield = {}
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.SHAMAN < 1 then
				return
			end
			if class == "SHAMAN" then
				if raid.classes.SHAMAN[name].talents then
					if raid.classes.SHAMAN[name].talents.specialisations.earthshield then
						table.insert(report.shamanwithearthshield, name)
					end
				end
			elseif unit.istank then
				if class == "PALADIN" or class == "DRUID" or class == "WARRIOR" then  -- only mele tanks need earthshield
					report.checking.earthshield = true
					if unit.hasbuff[BS[32594]] then  -- Earth Shield
						table.insert(report.tanksgotearthshield, name)
					else
						table.insert(report.tanksneedingearthshield, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			local numberneeded = #report.tanksneedingearthshield
			local numberavailable = #report.shamanwithearthshield - #report.tanksgotearthshield
			if #report.tanksneedingearthshield > 0 and #report.shamanwithearthshield > 0 then
				report.checking.earthshield = true
			end
			if numberneeded > 0 and numberavailable > 0 then
				report.earthshieldlist = report.tanksneedingearthshield
			end
		end,
		icon = BSI[32594],  -- Earth Shield
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.earthshieldlist, RaidBuffStatus.db.profile.checkearthshield, report.checking.earthshield or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "earthshield", BS[32594], BS[32594], true)  -- Earth Shield
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Tank missing Earth Shield"], report.earthshieldlist, nil, BF.earthshield:buffers())
		end,
		partybuff = function(reportl, prefix)
			local theshamans = BF.earthshield:buffers()
			for name,_ in pairs(theshamans) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.earthshield.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local theshamans = {}
			for name,_ in pairs(raid.classes.SHAMAN) do
				if raid.classes.SHAMAN[name].talents then
					if raid.classes.SHAMAN[name].talents.specialisations.earthshield then
						table.insert(theshamans, name)
					end
				end
			end
			return theshamans
		end,
	},

	salvation = {
		order = 870,
		list = "salvationlist",
		check = "checksalvation",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[1038],  -- Blessing of Salvation
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PALADIN < 1 then
				return
			end
			if not unit.istank then
				return  -- only tanks need not salvation
			end
			if class == "PALADIN" or class == "DRUID" or class == "WARRIOR" or class == "MAGE" or class == "WARLOCK" then  -- only tanks
				report.checking.salvation = true
				if unit.hasbuff[BS[1038]] or unit.hasbuff[BS[25895]] then  -- Blessing of Salvation and Greater
					table.insert(report.salvationlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[25895],  -- Greater Blessing of Salvation
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.salvationlist, RaidBuffStatus.db.profile.checksalvation, report.checking.salvation or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "salvation")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Tank with Salvation"], report.salvationlist)
		end,
		partybuff = nil,
	},


	soulstone = {
		order = 860,
		list = "nosoulstonelist",
		check = "checksoulstone",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = true,
		selfbuff = false,
		timer = false,
		chat = function(report, raid, prefix)
			prefix = prefix or ""
			if report.checking.soulstone then
				if # report.soulstonelist < 1 then
					RaidBuffStatus:Say(prefix .. "<" .. L["No Soulstone detected"] .. ">")
				end
			end
		end,
		pre = function(self, raid, report)
			report.soulstonelist = {}
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.WARLOCK > 0 then
				report.checking.soulstone = true
				if unit.hasbuff[BS[20707]] then -- Soulstone Resurrection
					table.insert(report.soulstonelist, name)
				end
			end
		end,
		post = function(self, raid, report)
			if raid.ClassNumbers.WARLOCK > 0 then
				if # report.soulstonelist < 1 then
					table.insert(report.nosoulstonelist, "raid")
				end
			end
		end,
		icon = "Interface\\Icons\\Spell_Shadow_SoulGem",
		update = function(self)
			if RaidBuffStatus.db.profile.checksoulstone then
				if report.checking.soulstone then
					self:SetAlpha(1)
					if # report.soulstonelist > 0 then
						self.count:SetText("0")
					else
						self.count:SetText("1")
					end
				else
					self:SetAlpha(0.15)
					self.count:SetText("")
				end
			else
				self:SetAlpha(0.5)
				self.count:SetText("X")
			end
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "soulstone")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Someone has a Soulstone"], report.soulstonelist)
		end,
		partybuff = nil,
	},

	food = {
		order = 500,
		list = "foodlist",
		check = "checkfood",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[35272], -- Well Fed
		main = function(self, name, class, unit, raid, report)
			local missingbuff = true
			for _, v in ipairs(foods) do
				if unit.hasbuff[v] then
					missingbuff = false
					break
				end
			end
			if missingbuff then
				table.insert(report.foodlist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Misc_Food_74",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.foodlist, RaidBuffStatus.db.profile.checkfood, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "food")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Not Well Fed"], report.foodlist)
		end,
		partybuff = nil,
	},
	flask = {
		order = 490,
		list = "flasklist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Flask or two Elixirs"],
		pre = function(self, raid, report)
			report.belixirlist = {}
			report.gelixirlist = {}
			report.flaskzonelist = {}
		end,
		main = function(self, name, class, unit, raid, report)
			local missingbuff = true
			for _, v in ipairs(flasks) do
				if unit.hasbuff[v] then
					missingbuff = false
					-- has flask now check the zone
					if raid.israid then
						local thiszone = GetRealZoneText()
						local flaskmatched = false
						for _, types in pairs (flaskzones) do
							for _, flask in ipairs(types.flasks) do
								if flask == v then
									flaskmatched = true
									local zonematched = false
									for _, zone in ipairs(types.zones) do
										if thiszone == zone then
											zonematched = true
											break
										end
									end
									if not zonematched then
										table.insert(report.flaskzonelist, name .. "(" .. v .. ")")
									end
								break
								end
							end
							if flaskmatched then break end
						end
					end
					break
				end
			end
			if missingbuff then
				local numbbelixir = 0
				local numbgelixir = 0
				for _, v in ipairs(belixirs) do
					if unit.hasbuff[v] then
						numbbelixir = 1
						break
					end
				end
				for _, v in ipairs(gelixirs) do
					if unit.hasbuff[v] then
						numbgelixir = 1
						break
					end
				end
				local totalelixir = numbbelixir + numbgelixir
				if totalelixir == 0 then
					table.insert(report.flasklist, name) -- no flask or elixir
				elseif totalelixir == 1 then
					if numbbelixir == 0 then
						table.insert(report.belixirlist, name)
					else
						table.insert(report.gelixirlist, name)
					end
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_119",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.flasklist, RaidBuffStatus.db.profile.checkflaskir, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing a Flask or two Elixirs"], report.flasklist)
		end,
		partybuff = nil,
	},
	belixir = {
		order = 480,
		list = "belixirlist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Battle Elixir"],
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_111",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.belixirlist, RaidBuffStatus.db.profile.checkflaskir, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing a Battle Elixir"], report.belixirlist)
		end,
		partybuff = nil,
	},
	
	gelixir = {
		order = 470,
		list = "gelixirlist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Guardian Elixir"],
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_158",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.gelixirlist, RaidBuffStatus.db.profile.checkflaskir, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing a Guardian Elixir"], report.gelixirlist)
		end,
		partybuff = nil,
	},

	flaskzone = {
		order = 465,
		list = "flaskzonelist",
		check = "checkflaskir",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Wrong flask for this zone"],
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_35",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.flaskzonelist, RaidBuffStatus.db.profile.checkflaskir, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "flaskzone")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Wrong flask for this zone"], report.flaskzonelist)
		end,
		partybuff = nil,
	},
	wepbuff = {
		order = 464,
		list = "wepbufflist",
		check = "checkwepbuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Weapon buff"],
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if _G.InspectFrame and _G.InspectFrame:IsShown() then
				return -- can't inspect at same time as UI
			end
			if inspectqueuename ~= "" then
				return  -- can't inspect as someone in the queue
			end
			if not CanInspect(unit.unitid) then
				return
			end
			NotifyInspect(unit.unitid)
			local missingbuffmh = true
			local missingbuffoh = true
			RBSToolScanner:ClearLines()
			RBSToolScanner:SetInventoryItem(unit.unitid, 16)
			for _,buff in ipairs(wepbuffs) do
				if RBSToolScanner:Find(buff) then
					missingbuffmh = false
					break
				end
			end
			RBSToolScanner:ClearLines()
			RBSToolScanner:SetInventoryItem(unit.unitid, 17)
			for _,buff in ipairs(wepbuffs) do
				if RBSToolScanner:Find(buff) then
					missingbuffoh = false
					break
				end
			end
			if RaidBuffStatus:IsMele(name, class) and RaidBuffStatus:InGroupWithEnhShaman(unit) and class ~= "DRUID" then -- in WotLK remove the druid check
				if not missingbuffmh then   -- mele with enhancement shaman should not have wep bufs
					table.insert(report.wepbufflist, name .. L["(Remove buff)"])
				end
			else
				if missingbuffmh and missingbuffoh then
					table.insert(report.wepbufflist, name)
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_101",
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.wepbufflist, RaidBuffStatus.db.profile.checkwepbuff, true)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "wepbuff")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing a temporary weapon buff"], report.wepbufflist)
		end,
		partybuff = nil,
	},

	spirit = {
		order = 460,
		list = "spiritlist",
		check = "checkspirit",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[14752], -- Divine Spirit
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if # raid.SpiritTalent > 0 then
				report.checking.spirit = true
				if class ~= "ROGUE" and class ~= "WARRIOR" then
					local missingbuff = true
					for _, v in ipairs(spirit) do
						if unit.hasbuff[v] then
							missingbuff = false
							break
						end
					end
					if missingbuff then
						if RaidBuffStatus.db.profile.ReportGroupNumber then
							table.insert(report.spiritlist, name .. "(" .. unit.group .. ")" )
						else
							table.insert(report.spiritlist, name)
						end
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.spiritlist)
		end,
		icon = BSI[14752], -- Divine Spirit
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.spiritlist, RaidBuffStatus.db.profile.checkspirit, report.checking.spirit or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "spirit", BS[14752], BS[27681], true) -- Divine Spirit and Prayer of Spirit
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Divine Spirit"], report.spiritlist, nil, BF.spirit:buffers())
		end,
		partybuff = function(reportl, prefix)
			local thepriests = BF.spirit:buffers()
			for _,name in ipairs(thepriests) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.spirit.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thepriests = {}
			local maxpoints = 1
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					local points = raid.classes.PRIEST[name].talents.tree[1].talent[14] + raid.classes.PRIEST[name].talents.tree[1].talent[15]
					if points > maxpoints then
						maxpoints = points
						thepriests = {}
						table.insert(thepriests, name)
					elseif points == maxpoints then
						table.insert(thepriests, name)
					end
				end
			end
			return thepriests
		end,
	},

	intellect = {
		order = 450,
		list = "intellectlist",
		check = "checkintellect",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[1459], -- Arcane Intellect
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.MAGE > 0 then
				report.checking.intellect = true
				if class ~= "ROGUE" and class ~= "WARRIOR" then
					local missingbuff = true
					for _, v in ipairs(intellect) do
						if unit.hasbuff[v] then
							missingbuff = false
							break
						end
					end
					if missingbuff then
						if RaidBuffStatus.db.profile.ReportGroupNumber then
							table.insert(report.intellectlist, name .. "(" .. unit.group .. ")" )
						else
							table.insert(report.intellectlist, name)
						end
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.intellectlist)
		end,
		icon = BSI[1459], -- Arcane Intellect
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.intellectlist, RaidBuffStatus.db.profile.checkintellect, report.checking.intellect or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "intellect", BS[1459], BS[23028], true) -- Arcane Intellect and Arcane Brilliance
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Arcane Intellect"], report.intellectlist, nil, BF.intellect:buffers())
		end,
		partybuff = function(reportl, prefix)
			for name,_ in pairs(raid.classes.MAGE) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.intellect.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local themages = {}
			for name,_ in pairs(raid.classes.MAGE) do
				table.insert(themages, name)
			end
			return themages
		end,
	},

	wild = {
		order = 440,
		list = "wildlist",
		check = "checkwild",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[1126], -- Mark of the Wild
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.DRUID > 0 then
				report.checking.wild = true
				local missingbuff = true
				for _, v in ipairs(wild) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					if RaidBuffStatus.db.profile.ReportGroupNumber then
						table.insert(report.wildlist, name .. "(" .. unit.group .. ")" )
					else
						table.insert(report.wildlist, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.wildlist)
		end,
		icon = BSI[1126], -- Mark of the Wild
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.wildlist, RaidBuffStatus.db.profile.checkwild, report.checking.wild or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "wild", BS[1126], BS[21849], true) -- Mark of the Wild and Gift of the Wild
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Mark of the Wild"], report.wildlist, nil, BF.wild:buffers())
		end,
		partybuff = function(reportl, prefix)
			local thedruids = BF.wild:buffers()
			for _,name in ipairs(thedruids) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.wild.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thedruids = {}
			local maxpoints = 0
			for name,_ in pairs(raid.classes.DRUID) do
				if raid.classes.DRUID[name].talents then
					local points = raid.classes.DRUID[name].talents.tree[3].talent[1]
					if points > maxpoints then
						maxpoints = points
						thedruids = {}
						table.insert(thedruids, name)
					elseif points == maxpoints then
						table.insert(thedruids, name)
					end
				else
					table.insert(thedruids, name)
				end
			end
			return thedruids
		end,
	},

	fortitude = {
		order = 430,
		list = "fortitudelist",
		check = "checkfortitude",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		chat = BS[1243], -- Power Word: Fortitude
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 then
				report.checking.fortitude = true
				local missingbuff = true
				for _, v in ipairs(fortitude) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					if RaidBuffStatus.db.profile.ReportGroupNumber then
						table.insert(report.fortitudelist, name .. "(" .. unit.group .. ")" )
					else
						table.insert(report.fortitudelist, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.fortitudelist)
		end,
		icon = BSI[1243], -- Power Word: Fortitude
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.fortitudelist, RaidBuffStatus.db.profile.checkfortitude, report.checking.fortitude or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "fortitude", BS[1243], BS[21562], true) -- Power Word: Fortitude and Prayer of Fortitude
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Power Word: Fortitude"], report.fortitudelist, nil, BF.fortitude:buffers())
		end,
		partybuff = function(reportl, prefix)
			local thepriests = BF.fortitude:buffers()
			for _,name in ipairs(thepriests) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.fortitude.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thepriests = {}
			local maxpoints = 0
			for name,_ in pairs(raid.classes.PRIEST) do
				if raid.classes.PRIEST[name].talents then
					local points = raid.classes.PRIEST[name].talents.tree[1].talent[4]
					if points > maxpoints then
						maxpoints = points
						thepriests = {}
						table.insert(thepriests, name)
					elseif points == maxpoints then
						table.insert(thepriests, name)
					end
				else
					table.insert(thepriests, name)
				end
			end
			return thepriests
		end,
	},

	shadow = {
		order = 420,
		list = "shadowlist",
		check = "checkshadow",
		default = false,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[976], -- Shadow Protection
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 then
				report.checking.shadow = true
				local missingbuff = true
				for _, v in ipairs(shadow) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					if RaidBuffStatus.db.profile.ReportGroupNumber then
						table.insert(report.shadowlist, name .. "(" .. unit.group .. ")" )
					else
						table.insert(report.shadowlist, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			RaidBuffStatus:SortNameBySuffix(report.shadowlist)
		end,
		icon = BSI[976], -- Shadow Protection
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.shadowlist, RaidBuffStatus.db.profile.checkshadow, report.checking.shadow or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "shadow", BS[976], BS[27683], true) -- Shadow Protection and Prayer of Shadow Protection
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Shadow Protection"], report.shadowlist, nil, BF.shadow:buffers())
		end,
		partybuff = function(reportl, prefix)
			for name,_ in pairs(raid.classes.PRIEST) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.shadow.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thepriests = {}
			for name,_ in pairs(raid.classes.PRIEST) do
				table.insert(thepriests, name)
			end
			return thepriests
		end,
	},

	noaura = {
		order = 410,
		list = "noauralist",
		check = "checknoaura",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Paladin Aura"],
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "PALADIN" then
				report.checking.noaura = true
				local missingbuff = true
				for _, v in ipairs(auras) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					table.insert(report.noauralist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[465], -- Devotion Aura
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.noauralist, RaidBuffStatus.db.profile.checknoaura, report.checking.noaura or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "noaura")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Paladin has no Aura at all"], report.noauralist)
		end,
		partybuff = nil,
	},

	noaspect = {
		order = 400,
		list = "noaspectlist",
		check = "checknoaspect",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Hunter Aspect"],
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "HUNTER" then
				report.checking.noaspect = true
				local missingbuff = true
				for _, v in ipairs(aspects) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					table.insert(report.noaspectlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[13163], -- Aspect of the Monkey
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.noaspectlist, RaidBuffStatus.db.profile.checknoaspect, report.checking.noaspect or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "noaspect")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Hunter has no aspect at all"], report.noaspectlist)
		end,
		partybuff = nil,
	},

	trueshotaura = {
		order = 395,
		list = "trueshotauralist",
		check = "checktrueshotaura",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[27066], -- Trueshot Aura
		main = function(self, name, class, unit, raid, report)
			if class == "HUNTER" then
				if raid.classes.HUNTER[name].talents then
					if raid.classes.HUNTER[name].talents.tree[2].talent[17] > 0 then
						report.checking.trueshotaura = true
						if not unit.hasbuff[BS[27066]] then -- Trueshot Aura
							table.insert(report.trueshotauralist, name)
						end
					end
				end
			end
		end,
		post = nil,
		icon = BSI[27066], -- Trueshot Aura
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.trueshotauralist, RaidBuffStatus.db.profile.checktrueshotaura, report.checking.trueshotaura or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "trueshotaura", BS[27066]) -- Trueshot Aura
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Hunter is missing Trueshot Aura"], report.trueshotauralist)
		end,
		partybuff = nil,
	},

	innerfire = {
		order = 390,
		list = "innerfirelist",
		check = "checkinnerfire",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[588], -- Inner Fire
		main = function(self, name, class, unit, raid, report)
			if class == "PRIEST" then
				report.checking.innerfire = true
				if not unit.hasbuff[BS[588]] then -- Inner Fire
					table.insert(report.innerfirelist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[588], -- Inner Fire
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.innerfirelist, RaidBuffStatus.db.profile.checkinnerfire, report.checking.innerfire or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "innerfire", BS[588]) -- Inner Fire
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Priest is missing Inner Fire"], report.innerfirelist)
		end,
		partybuff = nil,
	},

	felarmor = {
		order = 380,
		list = "felarmorlist",
		check = "checkfelarmor",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[28176], -- Fel Armor
		main = function(self, name, class, unit, raid, report)
			if class == "WARLOCK" then
				report.checking.felarmor = true
				if not unit.hasbuff[BS[28176]] then -- Fel Armor
					table.insert(report.felarmorlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[28176], -- Fel Armor
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.felarmorlist, RaidBuffStatus.db.profile.checkfelarmor, report.checking.felarmor or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "felarmor", BS[28176]) -- Fel Armor
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Warlock is missing Fel Armor"], report.felarmorlist)
		end,
		partybuff = nil,
	},

	magearmor = {
		order = 370,
		list = "magearmorlist",
		check = "checkmagearmor",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[6117], -- Mage Armor
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "MAGE" then
				report.checking.magearmor = true
				local missingbuff = true
				for _, v in ipairs(magearmors) do
					if unit.hasbuff[v] then
						missingbuff = false
						break
					end
				end
				if missingbuff then
					table.insert(report.magearmorlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[6117], -- Mage Armor
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.magearmorlist, RaidBuffStatus.db.profile.checkmagearmor, report.checking.magearmor or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "magearmor")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Mage is missing a Mage Armor"], report.magearmorlist)
		end,
		partybuff = nil,
	},

	omenofclarity = {
		order = 360,
		list = "omenofclaritylist",
		check = "checkomenofclarity",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[16864], -- Omen of Clarity
		main = function(self, name, class, unit, raid, report)
			if class == "DRUID" then
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.tree[3].talent[8] > 0 then
						report.checking.omenofclarity = true
						if not unit.hasbuff[BS[16864]] then -- Omen of Clarity
							table.insert(report.omenofclaritylist, name)
						end
					end
				end
			end
		end,
		post = nil,
		icon = BSI[16864], -- Omen of Clarity
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.omenofclaritylist, RaidBuffStatus.db.profile.checkomenofclarity, report.checking.omenofclarity or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "omenofclarity", BS[16864]) -- Omen of Clarity
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Druid is missing Omen of Clarity"], report.omenofclaritylist)
		end,
		partybuff = nil,
	},

	shamanshield = {
		order = 355,
		list = "shamanshieldlist",
		check = "checkshamanshield",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = BS[33736], -- Water Shield
		main = function(self, name, class, unit, raid, report)
			if class == "SHAMAN" then
				report.checking.shamanshield = true
				if not unit.hasbuff[BS[33736]] then -- Water Shield
					table.insert(report.shamanshieldlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[33736], -- Water Shield
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.shamanshieldlist, RaidBuffStatus.db.profile.checkshamanshield, report.checking.shamanshield or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "shamanshield", BS[33736]) -- Water Shield
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Shaman is missing Water Shield"], report.shamanshieldlist)
		end,
		partybuff = nil,
	},

	missingblessing = {
		order = 350,
		list = "missingblessinglist",
		check = "checkmissingblessing",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = L["Paladin blessing"],
		pre = function(self, raid, report)
			if raid.ClassNumbers.PALADIN < 1 then
				return
			end
			local commonblessings = 2 -- light, salvation
			if # raid.KingsTalent > 0 then
				commonblessings = commonblessings + 1 -- kings
			end
			if # raid.SanctuaryTalent > 0 then
				commonblessings = commonblessings + 1 -- sanctuary
			end
			local maxblessings = raid.ClassNumbers.PALADIN
			if maxblessings > (commonblessings + 2) then -- might, wisdom
				maxblessings = commonblessings + 2
			end
			report.minblessings = {}
			if maxblessings == 1 then  -- one paladin so everyone will have at least one blessing
				report.minblessings.WARRIOR = 1
				report.minblessings.ROGUE = 1
				report.minblessings.PRIEST = 1
				report.minblessings.MAGE = 1
				report.minblessings.WARLOCK = 1
				report.minblessings.PALADIN = 1
				report.minblessings.DRUID = 1
				report.minblessings["Feral Combat DRUID"] = 1
				report.minblessings.SHAMAN = 1
				report.minblessings.HUNTER = 1
			elseif maxblessings > 1 and maxblessings <= (commonblessings - 1) then
				report.minblessings.WARRIOR = maxblessings - 1  -- might not need salvation
				report.minblessings.ROGUE = maxblessings
				report.minblessings.PRIEST = maxblessings
				report.minblessings.MAGE = maxblessings - 1  -- might not need salvation
				report.minblessings.WARLOCK = maxblessings - 1  -- might not need salvation
				report.minblessings.PALADIN = maxblessings - 1  -- might not need salvation
				report.minblessings.DRUID = maxblessings
				report.minblessings["Feral Combat DRUID"] = maxblessings - 1 -- might not need salvation
				report.minblessings.SHAMAN = maxblessings
				report.minblessings.HUNTER = maxblessings - 1  -- might not need salvation
			else
				report.minblessings.WARRIOR = maxblessings - 1  -- might not need salvation
				report.minblessings.ROGUE = maxblessings - 1  -- does not need wisdom
				report.minblessings.PRIEST = maxblessings - 1 -- does not need might
				report.minblessings.MAGE = maxblessings - 2  -- might not need salvation and does not need might
				report.minblessings.WARLOCK = maxblessings - 2  -- might not need salvation and does not need might
				report.minblessings.PALADIN = maxblessings - 1  -- might not need salvation
				report.minblessings.DRUID = maxblessings - 1 -- does not need might
				report.minblessings["Feral Combat DRUID"] = maxblessings - 1  -- might not need salvation
				report.minblessings.SHAMAN = maxblessings - 1 -- does not need might
				report.minblessings.HUNTER = maxblessings - 1  -- might not need salvation
			end

		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PALADIN < 1 then
				return
			end
			report.checking.missingblessing = true
			if raid.ClassNumbers.PALADIN == 1 then  -- special case for 1 pala - everyone gets a blessing
				if RaidBuffStatus:NumberOfBlessings(unit, false) < report.minblessings[class] then
					table.insert(report.missingblessinglist, name)
				end
				return
			end

			if class == "ROGUE" or class == "PRIEST" or class == "SHAMAN" then
				if RaidBuffStatus:NumberOfBlessings(unit, false) < report.minblessings[class] then
					table.insert(report.missingblessinglist, name)
				end
			elseif class == "WARRIOR" or class == "PALADIN" or class == "MAGE" or class == "WARLOCK" or class == "HUNTER" then
				if RaidBuffStatus:NumberOfBlessings(unit, true) < report.minblessings[class] then
					table.insert(report.missingblessinglist, name)
				end
			elseif class == "DRUID" then
				local isferal = false
				if raid.classes.DRUID[name].talents then
					if raid.classes.DRUID[name].talents.spec == "Feral Combat" then
						isferal = true
					end
				end
				if isferal then
					if RaidBuffStatus:NumberOfBlessings(unit, true) < report.minblessings["Feral Combat DRUID"] then
						table.insert(report.missingblessinglist, name)
					end
				else
					if RaidBuffStatus:NumberOfBlessings(unit, false) < report.minblessings.DRUID then
						table.insert(report.missingblessinglist, name)
					end
				end
			end
		end,
		post = nil,
		icon = BSI[25898], -- Greater Blessing of Kings
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.missingblessinglist, RaidBuffStatus.db.profile.checkmissingblessing, report.checking.missingblessing or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "missingblessing")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Player is missing at least one Paladin blessing"], report.missingblessinglist, nil, BF.missingblessing:buffers())
		end,
		partybuff = function(reportl, prefix)
			for name,_ in pairs(raid.classes.PALADIN) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.missingblessing.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local thelols = {}
			for name,_ in pairs(raid.classes.PALADIN) do
				table.insert(thelols, name)
			end
			return thelols
		end,
	},

	amplifymagic = {
		order = 340,
		list = "amplifymagiclist",
		check = "checkamplifymagic",
		default = false,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = false,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = BS[33946], -- Amplify Magic
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.MAGE > 0 then
				report.checking.amplifymagic = true
				if not unit.hasbuff[BS[33946]] then
					table.insert(report.amplifymagiclist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[33946], -- Amplify Magic
		update = function(self)
			RaidBuffStatus:DefaultButtonUpdate(self, report.amplifymagiclist, RaidBuffStatus.db.profile.checkamplifymagic, report.checking.amplifymagic or false)
		end,
		click = function(self, button, down)
			RaidBuffStatus:ButtonClick(self, button, down, "amplifymagic")
		end,
		tip = function(self)
			RaidBuffStatus:Tooltip(self, L["Missing Amplify Magic"], report.amplifymagiclist, nil, BF.amplifymagic:buffers()) -- same as intellect for amplify magic
		end,
		partybuff = function(reportl, prefix)
			for name,_ in pairs(raid.classes.MAGE) do
				RaidBuffStatus:Say(prefix .. "<" .. BF.amplifymagic.chat .. ">: " .. table.concat(reportl, ", "), name)
			end
		end,
		buffers = function()
			local themages = {}
			for name,_ in pairs(raid.classes.MAGE) do
				table.insert(themages, name)
			end
			return themages
		end,
	},
	tanklist = {
		order = 20,
		list = "none",
		check = "checktanklist",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = false,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\Ability_Defend",
		update = function(self)
			self.count:SetText("")
			if #raid.TankList > 0 then
				self:SetAlpha("1")
			else
				self:SetAlpha("0.15")
			end
		end,
		click = nil,
		tip = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["RBS Tank List"],1,1,1)
			for _,v in ipairs(raid.TankList) do
				local class = "WARRIOR"
				local unit = RaidBuffStatus:GetUnitFromName(v)
				if unit then
					class = unit.class
				end
				GameTooltip:AddLine(v,RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b,nil)
			end
			GameTooltip:Show()
		end,
		partybuff = nil,
	},
	help20080731 = {
		order = 10,
		list = "none",
		check = "checkhelp20080731",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\Mail_GMIcon",
		update = function(self)
			self.count:SetText("")
		end,
		click = nil,
		tip = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["RBS Dashboard Help"],1,1,1)
			GameTooltip:AddLine(L["Click buffs to disable and enable."],nil,nil,nil)
			GameTooltip:AddLine(L["Shift-Click buffs to report on only that buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Ctrl-Click buffs to whisper those who need to buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Alt-Click on a self buff will renew that buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Alt-Click on a party buff will cast on someone missing that buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Remove this button from this dashboard in the buff options window."],nil,nil,nil)
			GameTooltip:AddLine(L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."],nil,nil,nil)
			GameTooltip:Show()
		end,
		partybuff = nil,
	},
}


report = {
	checking = {},
}
report.reset = function()
	for reportname,_ in pairs(report) do
		if type(report[reportname]) == "number" then
			report[reportname] = 0
		elseif type(report[reportname]) == "table" then
			report[reportname] = {}
		end
	end
end

-- End of inits


function RaidBuffStatus:OnInitialize()
	local profiledefaults = { profile = {
		options = {},
		ReportSelf = false,
		ReportChat = true,
		ReportOfficer = false,
		PrependRBS = false,
		ReportGroupNumber = true,
		LockWindow = false,
		IgnoreLastThreeGroups = true,
		DisableInCombat = false,
		bgr = 0,
		bgg = 0,
		bgb = 0,
		bga = 0.99,
		bbr = 0,
		bbg = 0,
		bbb = 0,
		bba = 1,
		x = 0,
		y = 0,
		MiniMap = true,
		AutoShowDashParty = true,
		AutoShowDashRaid = true,
		MiniMapAngle = math.rad(random(0, 360)),
		dashcols = 5,
		ShortenNames = false,
		Debug = false,
	}}
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].list then
			report[BF[buffcheck].list] = {} -- add empty list to report
		end
		if BF[buffcheck].default then  -- if default setting for buff check is enabled
			profiledefaults.profile[BF[buffcheck].check] = true
		else
			profiledefaults.profile[BF[buffcheck].check] = false
		end
		for _, defname in ipairs({"buff", "warning", "dash", "dashcombat", "boss", "trash"}) do
			if BF[buffcheck]["default" .. defname] then
				profiledefaults.profile[buffcheck .. defname] = true
			else
				profiledefaults.profile[buffcheck .. defname] = false
			end
		end
	end
	RaidBuffStatusDefaultProfile = RaidBuffStatusDefaultProfile or {false, "Modders: In your SavedVars, replace the first argument of this table with the profile you want loaded by default, like 'Default'."}
	self.db = LibStub("AceDB-3.0"):New("RaidBuffStatusDB", profiledefaults, RaidBuffStatusDefaultProfile[1])
	RaidBuffStatus.optFrame = AceConfig:AddToBlizOptions("RaidBuffStatus", "RaidBuffStatus")
	self.configOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
--	RaidBuffStatus:Debug('Init, init?')
end

-- credit for original code goes to Peragor and GridLayoutPlus
function RaidBuffStatus:oRA_MainTankUpdate()
	RaidBuffStatus:Debug('oRA_MainTankUpdate()')
	-- oRa2 and CT raid integration: get list of unitids for configured tanks
	local tankTable = nil
	tankList = '|'
	if oRA and oRA.maintanktable then
		tankTable = oRA.maintanktable
		RaidBuffStatus:Debug('Using ora')
	elseif CT_RA_MainTanks then
		tankTable = CT_RA_MainTanks
		RaidBuffStatus:Debug('Using ctra')
	end
	if tankTable then
		for key, val in pairs(tankTable) do
			local unit = RaidBuffStatus:GetUnitFromName(val)
			if unit then
				local unitid = unit.unitid
				if unitid and UnitExists(unitid) and UnitPlayerOrPetInRaid(unitid) then
					tankList = tankList .. val .. '|'
				end
			end
		end
	end
end

function RaidBuffStatus:ShowReportFrame()
	ShowUIPanel(RBSFrame)
end

function RaidBuffStatus:HideReportFrame()
	HideUIPanel(RBSFrame)
end

function RaidBuffStatus:ToggleOptionsFrame()
	if (InCombatLockdown()) then
		return
	end
	if RaidBuffStatus.optionsframe:IsVisible() then
		HideUIPanel(RBSOptionsFrame)
	else
		RaidBuffStatus:ShowOptionsFrame()
	end
end

function RaidBuffStatus:ShowOptionsFrame()
	RaidBuffStatus:UpdateOptionsButtons()
	ShowUIPanel(RBSOptionsFrame)
end

function RaidBuffStatus:ToggleTalentsFrame()
	if RaidBuffStatus.talentframe:IsVisible() then
		HideUIPanel(RBSTalentsFrame)
	else
		RaidBuffStatus:ShowTalentsFrame()
	end
end

function RaidBuffStatus:ShowTalentsFrame()
	RaidBuffStatus:UpdateTalentsFrame()
	ShowUIPanel(RBSTalentsFrame)
end

function RaidBuffStatus:UpdateMiniMapButton()
	if RaidBuffStatus.db.profile.MiniMap then
		RBSMinimapButton:UpdatePosition()
		RBSMinimapButton:Show()
	else
		RBSMinimapButton:Hide()
	end
end

function RaidBuffStatus:UpdateTalentsFrame()
	local height = tfi.topedge + (raid.size * (tfi.rowheight + tfi.rowgap)) + tfi.okbuttonheight
	RaidBuffStatus.talentframe:SetHeight(height)
	for i = 1, tfi.maxrows do
		tfi.rowframes[i].rowframe:Hide()
	end
	for speccheck, _ in pairs(SP) do
		SP[speccheck].code()
	end
	RaidBuffStatus:GetTalentRowData()
	RaidBuffStatus:SortTalentRowData(tfi.sort, tfi.sortorder)
	RaidBuffStatus:CopyTalentRowDataToRowFrames()
	for i = 1, raid.size do
		tfi.rowframes[i].rowframe:Show()
	end
end

function RaidBuffStatus:GetTalentRowData()
	tfi.rowdata = {}
	local row = 1
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			local unit = raid.classes[class][name]
			tfi.rowdata[row] = {}
			tfi.rowdata[row].name = name
			tfi.rowdata[row].class = class
			tfi.rowdata[row].specialisations = {}
			if unit.talents then
				tfi.rowdata[row].spec = unit.talents.spec
				tfi.rowdata[row].specicon = unit.talents.specicon
				for speccheck, _ in pairs(SP) do
					if unit.talents.specialisations[speccheck] then
						table.insert(tfi.rowdata[row].specialisations, speccheck)
					end
				end
			else
				tfi.rowdata[row].spec = "UNKNOWN"
				tfi.rowdata[row].specicon = "UNKNOWN"
			end
			
			table.sort(tfi.rowdata[row].specialisations, function (a,b)
				return(SP[a].order > SP[b].order)
			end)
			row = row + 1
		end
	end
end

function RaidBuffStatus:SortTalentRowData(sort, sortorder)
	tfi.sort = sort
	tfi.sortorder = sortorder
	if sort == "name" then
		table.sort(tfi.rowdata, function (a,b)
			return (RaidBuffStatus:Compare(a.name, b.name, sortorder))
		end)
	elseif sort == "class" then
		table.sort(tfi.rowdata, function (a,b)
			if a.class == b.class then
				if a.spec == b.spec then
					return (RaidBuffStatus:Compare(a.name, b.name, sortorder))
				end
				return (RaidBuffStatus:Compare(a.spec, b.spec, sortorder))
			else
				return (RaidBuffStatus:Compare(a.class, b.class, sortorder))
			end
		end)
	elseif sort == "spec" then
		table.sort(tfi.rowdata, function (a,b)
			if a.spec == b.spec then
				return (RaidBuffStatus:Compare(a.class, b.class, sortorder))
			else
				return (RaidBuffStatus:Compare(a.spec, b.spec, sortorder))
			end
		end)
	elseif sort == "specialisations" then
		table.sort(tfi.rowdata, function (a,b)
			if #a.specialisations == #b.specialisations then
				return (RaidBuffStatus:Compare(a.name, b.name, sortorder))
			end
			return (RaidBuffStatus:Compare(#a.specialisations, #b.specialisations, sortorder))
		end)
	end
end

function RaidBuffStatus:Compare(a, b, sortorder)
	if sortorder == 1 then
			return (a < b)
		else
			return (a > b)
	end
end

function RaidBuffStatus:CopyTalentRowDataToRowFrames()
	for i, _ in ipairs(tfi.rowdata) do
		local class = tfi.rowdata[i].class
		local name = tfi.rowdata[i].name
		local r = RAID_CLASS_COLORS[class].r
		local g = RAID_CLASS_COLORS[class].g
		local b = RAID_CLASS_COLORS[class].b
		tfi.rowframes[i].name:SetText(name)
		tfi.rowframes[i].name:SetTextColor(r,g,b)
		tfi.rowframes[i].class:SetNormalTexture(classicons[class] or classicons.UNKNOWN)
		tfi.rowframes[i].class:SetScript("OnEnter", function() RaidBuffStatus:Tooltip(tfi.rowframes[i].class, RaidBuffStatus:TitleCaps(class), nil) end )
		tfi.rowframes[i].class:SetScript("OnLeave", function() GameTooltip:Hide() end)
		if raid.classes[class][name].talents then
			local spec = raid.classes[class][name].talents.spec
			local specicon = raid.classes[class][name].talents.specicon
			tfi.rowframes[i].spec:SetScript("OnEnter", function() RaidBuffStatus:Tooltip(tfi.rowframes[i].spec, spec) end )
			tfi.rowframes[i].spec:SetScript("OnLeave", function() GameTooltip:Hide() end)
			if spec == "Hybrid" then
				tfi.rowframes[i].spec:SetNormalTexture(specicons.Hybrid)
			else
				tfi.rowframes[i].spec:SetNormalTexture(specicon or specicons.UNKNOWN)
			end
		else
			tfi.rowframes[i].spec:SetNormalTexture(specicons.UNKNOWN)
			tfi.rowframes[i].spec:SetScript("OnEnter", function() RaidBuffStatus:Tooltip(tfi.rowframes[i].spec, "Unknown") end )
			tfi.rowframes[i].spec:SetScript("OnLeave", function() GameTooltip:Hide() end)
		end
		for j, v in ipairs (tfi.rowframes[i].specialisations) do
			v:Hide()
			local speccheck = tfi.rowdata[i].specialisations[j]
			if speccheck then
				v:SetNormalTexture(SP[speccheck].icon)
				v:SetScript("OnEnter", function() RaidBuffStatus:Tooltip(v, SP[speccheck].tip) end )
				v:SetScript("OnLeave", function() GameTooltip:Hide() end)
				v:Show()
			end
		end
	end
end

function RaidBuffStatus:DoReport(force)
	if not force then
		if nextscan > GetTime() then
			return  -- ensure we don't get called many times a second
		end
		if incombat and RaidBuffStatus.db.profile.DisableInCombat then
			return  -- no buff checking in combat
		end
	end
	nextscan = GetTime() + 1
	report:reset()
	RaidBuffStatus:ReadRaid()
	if (not raid.israid) and (not raid.isparty) then
		RaidBuffStatus:UpdateButtons()
		return
	end
	RaidBuffStatus:CalculateReport()
	RaidBuffStatus:UpdateButtons()
end

function RaidBuffStatus:CalculateReport()
	-- PRE HERE
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].pre then
			if RaidBuffStatus.db.profile[BF[buffcheck].check] then
				if (not incombat) or (incombat and RaidBuffStatus.db.profile[buffcheck .. "dashcombat"]) then
					BF[buffcheck].pre(self, raid, report)
				end
			end
		end
	end

	-- MAIN HERE
	local thiszone = GetRealZoneText()
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			local unit = raid.classes[class][name]
			if unit.online then
				local zonedin = true
				if raid.israid then
					if thiszone ~= unit.zone then
						zonedin = false
						if RaidBuffStatus.db.profile.checkzone then
							table.insert(report.zonelist, name)
						end
					end
				end

				for buffcheck, _ in pairs(BF) do
					if RaidBuffStatus.db.profile[BF[buffcheck].check] then
						if zonedin or BF[buffcheck].checkzonedout then
							if (not incombat) or (incombat and RaidBuffStatus.db.profile[buffcheck .. "dashcombat"]) then
								if BF[buffcheck].main then
									BF[buffcheck].main(self, name, class, unit, raid, report)
								end
							end
						end
					end
				end
				if unit.talents == nil then
					RaidBuffStatus:RequestInspect(name, class, unit.unitid) -- find out all talent info eventually
				end
			else
				if RaidBuffStatus.db.profile.checkoffline then
					table.insert(report.offlinelist, name)  -- used by offline warning check
				end
			end
		end
	end

	-- do timers
	local thetimenow = math.floor(GetTime())
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].timer then
			if not raid.BuffTimers[buffcheck .. "timerlist"] then
				raid.BuffTimers[buffcheck .. "timerlist"] = {}
			end
			for _, v in ipairs(report[BF[buffcheck].list]) do  -- first add those on the list to the timer list if not there
				local missing = true
				for n, t in pairs(raid.BuffTimers[buffcheck .. "timerlist"]) do
					if v == n then
						missing = false
						break
					end
				end
				if missing then
					raid.BuffTimers[buffcheck .. "timerlist"][v] = thetimenow
				end
			end
			for n, t in pairs(raid.BuffTimers[buffcheck .. "timerlist"]) do -- now remove those who are no longer on the list
				local missing = true
				for _, v in ipairs(report[BF[buffcheck].list]) do
					if v == n then
						missing = false
						break
					end
				end
				if missing then
					raid.BuffTimers[buffcheck .. "timerlist"][n] = nil
				end
			end
		end
	end

	-- sort names
	for buffcheck, _ in pairs(BF) do
		if # report[BF[buffcheck].list] > 1 then
			table.sort(report[BF[buffcheck].list])
		end
	end

	-- POST HERE
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].post then
			if RaidBuffStatus.db.profile[BF[buffcheck].check] then
				if (not incombat) or (incombat and RaidBuffStatus.db.profile[buffcheck .. "dashcombat"]) then
					BF[buffcheck].post(self, raid, report)
				end
			end
		end
	end
end

function RaidBuffStatus:ReportToChat(boss, player)
	local warnings = 0
	local buffs = 0
	for buffcheck, _ in pairs(BF) do
		if # report[BF[buffcheck].list] > 0 then
			if (boss and RaidBuffStatus.db.profile[buffcheck .. "boss"]) or ((not boss) and RaidBuffStatus.db.profile[buffcheck .. "trash"]) then
				if RaidBuffStatus.db.profile[buffcheck .. "warning"] then
					warnings = warnings + # report[BF[buffcheck].list]
				end
				if RaidBuffStatus.db.profile[buffcheck .. "buff"] then
					buffs = buffs + # report[BF[buffcheck].list]
				end
			end
		end
	end
	if warnings > 0 then
		RaidBuffStatus:Say(L["Warnings: "] .. warnings, nil, true)
		for buffcheck, _ in pairs(BF) do
			if # report[BF[buffcheck].list] > 0 then
				if (boss and RaidBuffStatus.db.profile[buffcheck .. "boss"] ) or ((not boss) and RaidBuffStatus.db.profile[buffcheck .. "trash"]) then
					if RaidBuffStatus.db.profile[buffcheck .. "warning"] then
						if type(BF[buffcheck].chat) == "string" then
							if BF[buffcheck].timer then
								local timerlist = {}
								for _, n in ipairs(report[BF[buffcheck].list]) do
									if raid.BuffTimers[buffcheck .. "timerlist"][n] then
										table.insert(timerlist, n .. "(" .. RaidBuffStatus:TimeSince(raid.BuffTimers[buffcheck .. "timerlist"][n]) .. ")")
									else
										table.insert(timerlist, n)
									end
								end
								RaidBuffStatus:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(timerlist, ", "))
							else
								RaidBuffStatus:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "))
							end
						elseif type(BF[buffcheck].chat) == "function" then
							BF[buffcheck].chat(report, raid)
						end
					end
				end
			end
		end
	end
	if buffs > 0 then
		if boss then
			RaidBuffStatus:Say(L["Missing buffs (Boss): "] .. buffs, nil, true)
		else
			RaidBuffStatus:Say(L["Missing buffs (Trash): "] .. buffs, nil, true)
		end
		for buffcheck, _ in pairs(BF) do
			if # report[BF[buffcheck].list] > 0 then
				if (boss and RaidBuffStatus.db.profile[buffcheck .. "boss"] ) or ((not boss) and RaidBuffStatus.db.profile[buffcheck .. "trash"]) then
					if RaidBuffStatus.db.profile[buffcheck .. "buff"] then
						if type(BF[buffcheck].chat) == "string" then
							RaidBuffStatus:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "))
						elseif type(BF[buffcheck].chat) == "function" then
							BF[buffcheck].chat(report, raid)
						end
					end
				end
			end
		end
	else
		if boss then
			RaidBuffStatus:Say(L["No buffs needed! (Boss)"], nil, true)
		else
			RaidBuffStatus:Say(L["No buffs needed! (Trash)"], nil, true)
		end
	end
end




function RaidBuffStatus:ReadRaid()
	raid.readid = raid.readid + 1
	raid.TankList = {}
	local raidnum = GetNumRaidMembers()
	local partynum = GetNumPartyMembers()
--	RaidBuffStatus:Debug("tankList:" .. tankList)
	if raidnum < 2 then
		if partynum < 1 then
			raid.reset()
			return
		else
			raid.isparty = true
			raid.israid = false
			raid.size = partynum + 1
			for i = 1, partynum do
				RaidBuffStatus:ReadUnit("party" .. i)
			end
			RaidBuffStatus:ReadUnit("player")
		end
	else
		if raid.isparty then -- Party has converted to Raid!
			RaidBuffStatus:oRA_MainTankUpdate()
			raid.reset()
		end
		raid.isparty = false
		raid.israid = true
		raid.size = raidnum
		for i = 1, raidnum do
			RaidBuffStatus:ReadUnit("raid" .. i)
		end
	end
	RaidBuffStatus:DeleteOldUnits()
	RaidBuffStatus:CalculateClassNumbers()
	for speccheck, _ in pairs(SP) do
		if SP[speccheck].callalways then
			SP[speccheck].code()
		end
	end
end


-- raid = { classes = { CLASS = { NAME = { readid, unitid, group, zone, online, isdead, istank, class, talents = {spec, tree = { talent = {}}}, hasbuff = {}
function RaidBuffStatus:ReadUnit(unitid)
	if not UnitExists(unitid) then
		return
	end
	local unitindex = select(3, unitid:find("(%d+)"))
	local name = UnitName(unitid)
	if name and name ~= UNKNOWNOBJECT and name ~= UKNOWNBEING then

		local class = select(2, UnitClass(unitid))
		local isDead = UnitIsDeadOrGhost(unitid) or false
		local rank = 0
		local subgroup = 1
		local online =  UnitIsConnected(unitid)
		local role = ""
		local zone = "UNKNOWN"
		local nametwo = name
		local isML = false
		local istank = false
		local level = UnitLevel(unitid)
		local hasbuff = {}
		
		if raid.israid then
			nametwo, rank, subgroup, _, _, _, zone, _, _, role, isML = GetRaidRosterInfo(unitindex)
		end
		if RaidBuffStatus.db.profile.IgnoreLastThreeGroups then
			if subgroup > 5 then
				raid.size = raid.size - 1
				return
			end
		end
		if raid.classes[class][name] == nil then
			raid.classes[class][name] = {}
		end
		for b = 1, 24 do
			local buffName = UnitBuff(unitid, b)
			if buffName then
				hasbuff[buffName] = true
			else
				break
			end
		end
		if (string.find(tankList, '|' .. name .. '|')) or role == "MAINTANK" then
--			RaidBuffStatus:Debug("on tankList:" .. name)
			if class ~= "PRIEST" and class ~= "ROGUE" then
				if class == "PALADIN" then
					if hasbuff[BS[25780]] then -- Righteous Fury
						istank = true
					end
				elseif class == "WARRIOR" then
					if raid.classes.WARRIOR[name].talents then
						if raid.classes.WARRIOR[name].talents.spec == "Protection" then
							istank = true
						end
					end
				elseif class == "DRUID" then
					local powerType = UnitPowerType(unitid) or -1
					if powerType == 1 then -- bear form
						istank = true
					end
				else
					istank = true
				end
			end
		end

		if istank then
--			RaidBuffStatus:Debug("is tank:" .. name)
			table.insert(raid.TankList, name)
		end
		
		local rcn = raid.classes[class][name]
		rcn.readid = raid.readid
		rcn.unitid = unitid
		rcn.group = subgroup
		rcn.zone = zone
		rcn.online = online
		rcn.isdead = isDead
		rcn.role = role
		rcn.rank = rank
		rcn.istank = istank
		rcn.class = class
		rcn.level = level
		rcn.hasbuff = hasbuff
	end
end

function RaidBuffStatus:DeleteOldUnits()
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			if raid.classes[class][name].readid < raid.readid then
				raid.classes[class][name] = nil
			end
		end
	end
end

function RaidBuffStatus:RequestInspect(name, class, unitid)
	if raid.classes[class][name].level < 10 then
		return -- no talents below lvl 10
	end
	if _G.InspectFrame and _G.InspectFrame:IsShown() then
		return -- can't inspect at same time as UI
	end
	if CanInspect(unitid) and inspectqueuetime < GetTime() then
		if inspectqueuename == name then
			inspectqueuename = ""
			inspectqueueclass = ""
			inspectqueueunitid = ""
			return -- must be a timed out retry so skip and allow next request to get in the queue
		end
		inspectqueuetime = GetTime() + 15
		inspectqueuename = name
		inspectqueueunitid = unitid
		inspectqueueclass = class
		if UnitIsUnit(inspectqueueunitid, "player") then
			RaidBuffStatus:INSPECT_TALENT_READY()
		else
			NotifyInspect(unitid)
			RaidBuffStatus:RegisterEvent("INSPECT_TALENT_READY")
		end
	end
end


function RaidBuffStatus:INSPECT_TALENT_READY()
	self:UnregisterEvent("INSPECT_TALENT_READY")
	if inspectqueuename == "" then
		inspectqueuetime = 0
		return
	end
	local isnotme = true
	if UnitIsUnit(inspectqueueunitid, "player") then
		isnotme = false
	end
	if GetNumTalentTabs(isnotme) == 0 then -- sometimes the inspect fails
		ClearInspectPlayer()
		inspectqueuetime = 0
		return
	end
	local name = inspectqueuename
	local class = inspectqueueclass
	inspectqueuename = ""
	inspectqueueclass = ""
	raid.classes[class][name].talents = { tree = {}, spec = "UNKNOWN", specicon = "UNKNOWN", specialisations = {} }
	local tree = raid.classes[class][name].talents.tree
	local tabtotal = {0, 0, 0}
	for tab = 1, GetNumTalentTabs(isnotme) do
		local name, icon, spent = GetTalentTabInfo(tab, isnotme);
		tree[tab] = {name=name, icon=icon, spent=spent, talent={ }};
		for talent = 1, GetNumTalents(tab, isnotme) do
			tree[tab].talent[talent] = select(5, GetTalentInfo(tab, talent, isnotme));
			tabtotal[tab] = tabtotal[tab] + tree[tab].talent[talent]
		end
	end
	if tabtotal[1] > 31 then
		raid.classes[class][name].talents.spec = tree[1].name
		raid.classes[class][name].talents.specicon = tree[1].icon
	elseif tabtotal[2] > 31 then
		raid.classes[class][name].talents.spec = tree[2].name
		raid.classes[class][name].talents.specicon = tree[2].icon
	elseif tabtotal[3] > 31 then
		raid.classes[class][name].talents.spec = tree[3].name
		raid.classes[class][name].talents.specicon = tree[3].icon
	else
		raid.classes[class][name].talents.spec = "Hybrid"
	end
	if RaidBuffStatus.talentframe:IsVisible() then
		RaidBuffStatus:UpdateTalentsFrame()
	end
	inspectqueuetime = 0
end


function RaidBuffStatus:CalculateClassNumbers()
	for _,class in ipairs(classes) do
		raid.ClassNumbers[class] = RaidBuffStatus:DicSize(raid.classes[class])
	end
end


function RaidBuffStatus:Say(msg, player, prepend)
	local pre = ""
	if prepend or RaidBuffStatus.db.profile.PrependRBS then
		pre = "RBS::"
	end
	local str = pre
	local canspeak = IsRaidLeader() or IsRaidOfficer()
	for _,s in pairs({strsplit(" ", msg)}) do
		if #str + #s >= 250 then
			if player then
				SendChatMessage(str, "WHISPER", nil, player)
			else
				if RaidBuffStatus.db.profile.ReportChat and raid.isparty then SendChatMessage(str, "party") end
				if RaidBuffStatus.db.profile.ReportChat and raid.israid and canspeak then SendChatMessage(str, "raid") end
				if RaidBuffStatus.db.profile.ReportSelf then RaidBuffStatus:Print(str) end
				if RaidBuffStatus.db.profile.ReportOfficer then SendChatMessage(str, "officer") end
			end
			str = pre
		end
		str = str .. " " .. s
	end
	if player then
		SendChatMessage(str, "WHISPER", nil, player)
	else
		if RaidBuffStatus.db.profile.ReportChat and raid.isparty then SendChatMessage(str, "party") end
		if RaidBuffStatus.db.profile.ReportChat and raid.israid and canspeak then SendChatMessage(str, "raid") end
		if RaidBuffStatus.db.profile.ReportSelf then RaidBuffStatus:Print(str) end
		if RaidBuffStatus.db.profile.ReportOfficer then SendChatMessage(str, "officer") end
	end
end

function RaidBuffStatus:Debug(msg)
	if not RaidBuffStatus.db.profile.Debug then
		return
	end
	local str = "RBS::"
	for _,s in pairs({strsplit(" ", msg)}) do
		if #str + #s >= 250 then
			RaidBuffStatus:Print(str)
			str = "RBS::"
		end
		str = str .. " " .. s
	end
	RaidBuffStatus:Print(str)
end


function RaidBuffStatus:DicSize(dic) -- is there really no built-in function to do this??
	local i = 0
	for _,_ in pairs(dic) do
		i = i + 1
	end
	return i
end

function RaidBuffStatus:OnProfileChanged()
	RaidBuffStatus:LoadFramePosition()
	RaidBuffStatus:AddBuffButtons()
	RaidBuffStatus:SetFrameColours()
end

function RaidBuffStatus:SetFrameColours()
	RaidBuffStatus.frame:SetBackdropBorderColor(RaidBuffStatus.db.profile.bbr, RaidBuffStatus.db.profile.bbg, RaidBuffStatus.db.profile.bbb, RaidBuffStatus.db.profile.bba)
	RaidBuffStatus.frame:SetBackdropColor(RaidBuffStatus.db.profile.bgr, RaidBuffStatus.db.profile.bgg, RaidBuffStatus.db.profile.bgb, RaidBuffStatus.db.profile.bga)
	RaidBuffStatus.talentframe:SetBackdropBorderColor(RaidBuffStatus.db.profile.bbr, RaidBuffStatus.db.profile.bbg, RaidBuffStatus.db.profile.bbb, RaidBuffStatus.db.profile.bba)
	RaidBuffStatus.talentframe:SetBackdropColor(RaidBuffStatus.db.profile.bgr, RaidBuffStatus.db.profile.bgg, RaidBuffStatus.db.profile.bgb, RaidBuffStatus.db.profile.bga)
	RaidBuffStatus.optionsframe:SetBackdropBorderColor(RaidBuffStatus.db.profile.bbr, RaidBuffStatus.db.profile.bbg, RaidBuffStatus.db.profile.bbb, RaidBuffStatus.db.profile.bba)
	RaidBuffStatus.optionsframe:SetBackdropColor(RaidBuffStatus.db.profile.bgr, RaidBuffStatus.db.profile.bgg, RaidBuffStatus.db.profile.bgb, RaidBuffStatus.db.profile.bga)
end

function RaidBuffStatus:SetupFrames()
	-- main frame
	RaidBuffStatus.frame = CreateFrame("Frame", "RBSFrame", UIParent)
	RaidBuffStatus.frame:Hide()
	RaidBuffStatus.frame:EnableMouse(true)
	RaidBuffStatus.frame:SetFrameStrata("MEDIUM")
	RaidBuffStatus.frame:SetMovable(true)
	RaidBuffStatus.frame:SetToplevel(true)
	RaidBuffStatus.frame:SetWidth(128)
	RaidBuffStatus.frame:SetHeight(190)
	RaidBuffStatus.rbsfs = RaidBuffStatus.frame:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText("RBS " .. GetAddOnMetadata("RaidBuffStatus", "Version"))
	RaidBuffStatus.rbsfs:SetPoint("TOP",0,-5)
	RaidBuffStatus.rbsfs:SetTextColor(.9,0,0)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.frame:SetBackdrop( { 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	RaidBuffStatus.frame:ClearAllPoints()
	RaidBuffStatus.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	RaidBuffStatus.frame:SetScript("OnMouseDown",function()
		if ( arg1 == "LeftButton" ) then
			if not RaidBuffStatus.db.profile.LockWindow then
				this:StartMoving()
			end
		end
	end)
	RaidBuffStatus.frame:SetScript("OnMouseUp",function()
		if ( arg1 == "LeftButton" ) then
			this:StopMovingOrSizing()
			RaidBuffStatus:SaveFramePosition()
		end
	end)
	RaidBuffStatus.frame:SetScript("OnHide",function() this:StopMovingOrSizing() end)
	RaidBuffStatus.frame:SetClampedToScreen(true)
	RaidBuffStatus:LoadFramePosition()

	RaidBuffStatus:AddBuffButtons()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.frame, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Boss"])
	RaidBuffStatus.button:SetWidth(45)
	RaidBuffStatus.button:SetPoint("BOTTOMLEFT", RaidBuffStatus.frame, "BOTTOMLEFT", 7, 5)
	RaidBuffStatus.button:SetScript("OnClick", function() RaidBuffStatus:DoReport() RaidBuffStatus:ReportToChat(true) end)
	RaidBuffStatus.button:Show()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.frame, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Trash"])
	RaidBuffStatus.button:SetWidth(45)
	RaidBuffStatus.button:SetPoint("BOTTOMRIGHT", RaidBuffStatus.frame, "BOTTOMRIGHT", -7, 5)
	RaidBuffStatus.button:SetScript("OnClick", function() RaidBuffStatus:DoReport() RaidBuffStatus:ReportToChat(false) end)
	RaidBuffStatus.button:Show()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.frame, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["R"])
	RaidBuffStatus.button:SetWidth(22)
	RaidBuffStatus.button:SetPoint("BOTTOM", RaidBuffStatus.frame, "BOTTOM", 0, 5)
	RaidBuffStatus.button:SetScript("OnClick", function()
		if IsRaidLeader() or IsRaidOfficer() then
			DoReadyCheck()
		end
	end)
	RaidBuffStatus.button:Show()

	RaidBuffStatus.talentsbutton = CreateFrame("Button", "talentsbutton", RaidBuffStatus.frame, "SecureActionButtonTemplate")
	RaidBuffStatus.talentsbutton:SetWidth(20)
	RaidBuffStatus.talentsbutton:SetHeight(20)
	RaidBuffStatus.talentsbutton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	RaidBuffStatus.talentsbutton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down") 
	RaidBuffStatus.talentsbutton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	RaidBuffStatus.talentsbutton:ClearAllPoints()
	RaidBuffStatus.talentsbutton:SetPoint("TOPLEFT", RaidBuffStatus.frame, "TOPLEFT", 5, -5)
	RaidBuffStatus.talentsbutton:SetScript("OnClick", function()
		RaidBuffStatus:ToggleTalentsFrame()
	end
	)
	RaidBuffStatus.talentsbutton:Show()

	RaidBuffStatus.optionsbutton = CreateFrame("Button", "optionsbutton", RaidBuffStatus.frame, "SecureActionButtonTemplate")
	RaidBuffStatus.optionsbutton:SetWidth(20)
	RaidBuffStatus.optionsbutton:SetHeight(20)
	RaidBuffStatus.optionsbutton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	RaidBuffStatus.optionsbutton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down") 
	RaidBuffStatus.optionsbutton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	RaidBuffStatus.optionsbutton:ClearAllPoints()
	RaidBuffStatus.optionsbutton:SetPoint("TOPRIGHT", RaidBuffStatus.frame, "TOPRIGHT", -5, -5)
	RaidBuffStatus.optionsbutton:SetScript("OnClick", function()
		RaidBuffStatus:ToggleOptionsFrame()
	end
	)
	RaidBuffStatus.optionsbutton:Show()

	-- talents window frame

	RaidBuffStatus.talentframe = CreateFrame("Frame", "RBSTalentsFrame", UIParent, "DialogBoxFrame")
	RaidBuffStatus.talentframe:Hide()
	RaidBuffStatus.talentframe:EnableMouse(true)
	RaidBuffStatus.talentframe:SetFrameStrata("MEDIUM")
	RaidBuffStatus.talentframe:SetMovable(true)
	RaidBuffStatus.talentframe:SetToplevel(true)
	RaidBuffStatus.talentframe:SetWidth(tfi.framewidth)
	RaidBuffStatus.talentframe:SetHeight(190)
	RaidBuffStatus.rbsfs = RaidBuffStatus.talentframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText("RBS " .. GetAddOnMetadata("RaidBuffStatus", "Version") .. " - " .. L["Talent Specialisations"])
	RaidBuffStatus.rbsfs:SetPoint("TOP",0,-5)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.talentframe:SetBackdrop( { 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	RaidBuffStatus.talentframe:ClearAllPoints()
	RaidBuffStatus.talentframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	RaidBuffStatus.talentframe:SetScript("OnMouseDown",function()
		if ( arg1 == "LeftButton" ) then
			if not RaidBuffStatus.db.profile.LockWindow then
				this:StartMoving()
			end
		end
	end)
	RaidBuffStatus.talentframe:SetScript("OnMouseUp",function()
		if ( arg1 == "LeftButton" ) then
			this:StopMovingOrSizing()
			RaidBuffStatus:SaveFramePosition()
		end
	end)
	RaidBuffStatus.talentframe:SetScript("OnHide",function() this:StopMovingOrSizing() end)
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.talentframe, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Name"])
	RaidBuffStatus.button:SetWidth(tfi.namewidth)
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.talentframe, "TOPLEFT", tfi.namex, -20)
	RaidBuffStatus.button:SetScript("OnClick", function()
		tfi.sort = "name"
		tfi.sortorder = 0 - tfi.sortorder
		RaidBuffStatus:ShowTalentsFrame()
	end)
	RaidBuffStatus.button:Show()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.talentframe, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Class"])
	RaidBuffStatus.button:SetWidth(tfi.classwidth)
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.talentframe, "TOPLEFT", tfi.classx, -20)
		RaidBuffStatus.button:SetScript("OnClick", function()
		tfi.sort = "class"
		tfi.sortorder = 0 - tfi.sortorder
		RaidBuffStatus:ShowTalentsFrame()
	end)
	RaidBuffStatus.button:Show()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.talentframe, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Spec"])
	RaidBuffStatus.button:SetWidth(tfi.specwidth)
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.talentframe, "TOPLEFT", tfi.specx, -20)
		RaidBuffStatus.button:SetScript("OnClick", function()
		tfi.sort = "spec"
		tfi.sortorder = 0 - tfi.sortorder
		RaidBuffStatus:ShowTalentsFrame()
	end)
	RaidBuffStatus.button:Show()
	RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.talentframe, "OptionsButtonTemplate")
	RaidBuffStatus.button:SetText(L["Specialisations"])
	RaidBuffStatus.button:SetWidth(tfi.specialisationswidth)
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.talentframe, "TOPLEFT", tfi.specialisationsx, -20)
		RaidBuffStatus.button:SetScript("OnClick", function()
		tfi.sort = "specialisations"
		tfi.sortorder = 0 - tfi.sortorder
		RaidBuffStatus:ShowTalentsFrame()
	end)
	RaidBuffStatus.button:Show()

	rowy = 0 - tfi.topedge
	for i = 1, tfi.maxrows do
		tfi.rowframes[i] = {}
		RaidBuffStatus.rowframe = CreateFrame("Frame", "", RaidBuffStatus.talentframe)
		tfi.rowframes[i].rowframe = RaidBuffStatus.rowframe
		RaidBuffStatus.rowframe:SetWidth(tfi.rowwidth)
		RaidBuffStatus.rowframe:SetHeight(tfi.rowheight)
		RaidBuffStatus.rowframe:ClearAllPoints()
		RaidBuffStatus.rowframe:SetPoint("TOPLEFT", RaidBuffStatus.talentframe, "TOPLEFT", tfi.edge + tfi.inset, rowy)
		RaidBuffStatus.rbsfs = RaidBuffStatus.rowframe:CreateFontString(nil,"ARTWORK","GameFontNormal")
		tfi.rowframes[i].name = RaidBuffStatus.rbsfs
		RaidBuffStatus.rbsfs:SetText("gief raid")
		RaidBuffStatus.rbsfs:SetPoint("TOPLEFT", RaidBuffStatus.rowframe, "TOPLEFT", 0, -2)
		RaidBuffStatus.rbsfs:SetTextColor(.9,0,0)
		RaidBuffStatus.rbsfs:Show()

		RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.rowframe)
		tfi.rowframes[i].class = RaidBuffStatus.button
		RaidBuffStatus.button:SetWidth(tfi.buttonsize)
		RaidBuffStatus.button:SetHeight(tfi.buttonsize)
		RaidBuffStatus.button:SetNormalTexture("Interface\\Icons\\INV_ValentinesCandy")
		RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.rowframe, "TOPLEFT", tfi.classx + ((tfi.classwidth - 30) / 2), 0)
		RaidBuffStatus.button:Show()

		RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.rowframe)
		tfi.rowframes[i].spec = RaidBuffStatus.button
		RaidBuffStatus.button:SetWidth(tfi.buttonsize)
		RaidBuffStatus.button:SetHeight(tfi.buttonsize)
		RaidBuffStatus.button:SetNormalTexture("Interface\\Icons\\Ability_ThunderBolt")
		RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.rowframe, "TOPLEFT", tfi.specx + ((tfi.specwidth - 30) / 2), 0)
		RaidBuffStatus.button:Show()
		
		tfi.rowframes[i].specialisations = {}
		RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.rowframe)
		tfi.rowframes[i].specialisations[1] = RaidBuffStatus.button
		RaidBuffStatus.button:SetWidth(tfi.buttonsize)
		RaidBuffStatus.button:SetHeight(tfi.buttonsize)
		RaidBuffStatus.button:SetNormalTexture("Interface\\Icons\\Ability_ThunderBolt")
		RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		RaidBuffStatus.button:SetPoint("TOPRIGHT", RaidBuffStatus.rowframe, "TOPRIGHT", 0 - tfi.inset, 0)
		RaidBuffStatus.button:Show()
		
		for j = 2, 10 do
			RaidBuffStatus.button = CreateFrame("Button", "", RaidBuffStatus.rowframe)
			tfi.rowframes[i].specialisations[j] = RaidBuffStatus.button
			RaidBuffStatus.button:SetWidth(tfi.buttonsize)
			RaidBuffStatus.button:SetHeight(tfi.buttonsize)
			RaidBuffStatus.button:SetNormalTexture("Interface\\Icons\\Ability_ThunderBolt")
			RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
			RaidBuffStatus.button:SetPoint("TOPRIGHT", tfi.rowframes[i].specialisations[j - 1], "TOPLEFT", 0, 0)
			RaidBuffStatus.button:Show()
		end
		rowy = rowy - tfi.rowheight - tfi.rowgap
	end


	-- options window frame
	RaidBuffStatus.optionsframe = CreateFrame("Frame", "RBSOptionsFrame", UIParent, "DialogBoxFrame")
	RaidBuffStatus.optionsframe:Hide()
	RaidBuffStatus.optionsframe:EnableMouse(true)
	RaidBuffStatus.optionsframe:SetFrameStrata("MEDIUM")
	RaidBuffStatus.optionsframe:SetMovable(true)
	RaidBuffStatus.optionsframe:SetToplevel(true)
	RaidBuffStatus.optionsframe:SetWidth(300)
	RaidBuffStatus.optionsframe:SetHeight(228)
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText("RBS " .. GetAddOnMetadata("RaidBuffStatus", "Version") .. " - " .. L["Buff Options"])
	RaidBuffStatus.rbsfs:SetPoint("TOP",0,-5)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.optionsframe:SetBackdrop( { 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	RaidBuffStatus.optionsframe:ClearAllPoints()
	RaidBuffStatus.optionsframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	RaidBuffStatus.optionsframe:SetScript("OnMouseDown",function()
		if ( arg1 == "LeftButton" ) then
			if not RaidBuffStatus.db.profile.LockWindow then
				this:StartMoving()
			end
		end
	end)
	RaidBuffStatus.optionsframe:SetScript("OnMouseUp",function()
		if ( arg1 == "LeftButton" ) then
			this:StopMovingOrSizing()
			RaidBuffStatus:SaveFramePosition()
		end
	end)
	RaidBuffStatus.optionsframe:SetScript("OnHide",function() this:StopMovingOrSizing() end)

	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Is a warning"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-53)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Is a buff"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-73)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Show on dashboard"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-93)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Show/Report in combat"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-113)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Report on Trash"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-133)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()
	RaidBuffStatus.rbsfs = RaidBuffStatus.optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	RaidBuffStatus.rbsfs:SetText(L["Report on Boss"] .. ":")
	RaidBuffStatus.rbsfs:SetPoint("TOPLEFT",10,-153)
	RaidBuffStatus.rbsfs:SetTextColor(1,1,1)
	RaidBuffStatus.rbsfs:Show()

	local bufflist = {}
	for buffcheck, _ in pairs(BF) do
		table.insert(bufflist, buffcheck)
	end
	table.sort(bufflist, function (a,b) return BF[a].order > BF[b].order end)

	local saveradio = function ()
		local name = this:GetName()
		RaidBuffStatus.db.profile[name] = this:GetChecked() and true or false
		local buffradio = false
		local isbuff = false
		if name:find("buff$") then
			buffradio = name:sub(1, name:find("buff$") - 1)
			isbuff = true
		elseif name:find("warning$") then
			buffradio = name:sub(1, name:find("warning$") - 1)
		end
		if buffradio then
			local value = true
			if RaidBuffStatus.db.profile[name] then
				value = false  -- if I am ticked then make the other unticked
			end
			if isbuff then
				RaidBuffStatus.db.profile[buffradio .. "warning"] = value
			else
				RaidBuffStatus.db.profile[buffradio .. "buff"] = value
			end
			RaidBuffStatus:UpdateOptionsButtons()
		end
		RaidBuffStatus:AddBuffButtons()
		RaidBuffStatus:UpdateButtons()
	end

	local currentx = 165
	for _, buffcheck in ipairs(bufflist) do
		RaidBuffStatus:AddOptionsBuffButton(buffcheck, currentx, -25, BF[buffcheck].icon, BF[buffcheck].tip)
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "warning", currentx, -50, saveradio, "Radio")
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "buff", currentx, -70, saveradio, "Radio")
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "dash", currentx, -90, saveradio, "Check")
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "dashcombat", currentx, -110, saveradio, "Check")
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "trash", currentx, -130, saveradio, "Check")
		RaidBuffStatus:AddOptionsBuffRadioButton(buffcheck .. "boss", currentx, -150, saveradio, "Check")
		currentx = currentx + 22
	end
	RaidBuffStatus.optionsframe:SetWidth(currentx + 9)
	RaidBuffStatus:SetFrameColours()
end


function RaidBuffStatus:SaveFramePosition()
	RaidBuffStatus.db.profile.x = RaidBuffStatus.frame:GetLeft()
	RaidBuffStatus.db.profile.y = RaidBuffStatus.frame:GetTop() - UIParent:GetTop()
end

function RaidBuffStatus:LoadFramePosition()
	RaidBuffStatus.frame:ClearAllPoints()
	if (RaidBuffStatus.db.profile.x ~= 0) or (RaidBuffStatus.db.profile.y ~= 0) then
		RaidBuffStatus.frame:SetPoint("TOPLEFT", UIParent,"TOPLEFT", RaidBuffStatus.db.profile.x, RaidBuffStatus.db.profile.y)
	else
		RaidBuffStatus.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end


function RaidBuffStatus:AddBuffButtons()
	if (InCombatLockdown()) then
		return
	end
	local buffs = {}
	local warnings = {}
	local bosses = {}
	for _, v in ipairs(buttons) do
		v.free = true
		v:Hide()
	end
	for buffcheck, _ in pairs(BF) do
		
		if not RaidBuffStatus.db.profile[buffcheck .. "dash"] and not RaidBuffStatus.db.profile[buffcheck .. "dashcombat"] and not RaidBuffStatus.db.profile[buffcheck .. "boss"] and not RaidBuffStatus.db.profile[buffcheck .. "trash"] then
			 RaidBuffStatus.db.profile[BF[buffcheck].check] = false -- if nothing using it then switch off
		end
		if not RaidBuffStatus.db.profile[buffcheck .. "dash"] and RaidBuffStatus.db.profile[buffcheck .. "dashcombat"] then
			 RaidBuffStatus.db.profile[BF[buffcheck].check] = true
		end

		if  (not incombat and RaidBuffStatus.db.profile[buffcheck .. "dash"]) or (incombat and RaidBuffStatus.db.profile[buffcheck .. "dashcombat"]) then
			if RaidBuffStatus.db.profile[buffcheck .. "boss"] and (not RaidBuffStatus.db.profile[buffcheck .. "trash"]) then
				table.insert(bosses, buffcheck)
			else
				if RaidBuffStatus.db.profile[buffcheck .. "warning"] then
					table.insert(warnings, buffcheck)
				end
				if RaidBuffStatus.db.profile[buffcheck .. "buff"] then
					table.insert(buffs, buffcheck)
				end
			end
		end
		
	end
	RaidBuffStatus:SortButtons(bosses)
	RaidBuffStatus:SortButtons(buffs)
	RaidBuffStatus:SortButtons(warnings)
	local currenty = 8
	local maxcols = RaidBuffStatus.db.profile.dashcols
	local cols = { 10, 32, 54, 76, 98, 120, 142, 164, 186, 208, 230, 252, 274, 296, 318, 340, 362}
	if # bosses > 0 then
		currenty = RaidBuffStatus:AddButtonType(bosses, maxcols, cols, currenty)
	end
	if # buffs > 0 then
		currenty = RaidBuffStatus:AddButtonType(buffs, maxcols, cols, currenty)
	end
	if # warnings > 0 then
		currenty = RaidBuffStatus:AddButtonType(warnings, maxcols, cols, currenty)
	end
	RaidBuffStatus.frame:SetHeight(currenty + 42)
	RaidBuffStatus.frame:SetWidth(maxcols * 22 + 18)
end

function RaidBuffStatus:AddButtonType(buttonlist, maxcols, cols, currenty)
	for i, v in ipairs(buttonlist) do
		local x = cols[((i - 1) % maxcols) + 1]
		local y = currenty + (22 * (math.ceil((# buttonlist)/maxcols) - math.floor((i - 1) / maxcols)))
		RaidBuffStatus:AddBuffButton(v, x, y, BF[v].icon, BF[v].update, BF[v].click, BF[v].tip)
	end
	return (currenty + 6 + 22 * math.ceil((# buttonlist)/maxcols))
end

function RaidBuffStatus:SortButtons(buttonlist)
	table.sort(buttonlist, function (a,b)
		return (BF[a].order > BF[b].order)
	end)
end


function RaidBuffStatus:AddBuffButton(name, x, y, icon, update, click, tooltip)
	RaidBuffStatus.button = nil
	for _, v in ipairs(buttons) do
		if v.free then
			RaidBuffStatus.button = v
			RaidBuffStatus.button.update = nil
			RaidBuffStatus.button:SetScript("PreClick", nil)
			RaidBuffStatus.button:SetScript("PostClick", nil)
			RaidBuffStatus.button:SetScript("OnEnter", nil)
			RaidBuffStatus.button:SetScript("OnLeave", nil)
			RaidBuffStatus.button:SetAttribute("type", nil)
			RaidBuffStatus.button:SetAttribute("spell", nil)
			RaidBuffStatus.button:SetAttribute("unit", nil)
			RaidBuffStatus.button:SetAttribute("name", nil)
			break
		end
	end
	if not RaidBuffStatus.button then
		RaidBuffStatus.button = CreateFrame("Button", nil, RaidBuffStatus.frame, "SecureActionButtonTemplate")
		table.insert(buttons, RaidBuffStatus.button)
		RaidBuffStatus.button:Hide()
		RaidBuffStatus.button:SetWidth(20)
		RaidBuffStatus.button:SetHeight(20)
		RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		RaidBuffStatus.button:SetAlpha(1)
		RaidBuffStatus.count = RaidBuffStatus.button:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
		RaidBuffStatus.button.count = RaidBuffStatus.count
		RaidBuffStatus.count:SetWidth(20)
		RaidBuffStatus.count:SetHeight(20)
		RaidBuffStatus.count:SetFont(RaidBuffStatus.count:GetFont(),12,"OUTLINE")
		RaidBuffStatus.count:SetPoint("CENTER", self.button, "CENTER", 0, 0)
		RaidBuffStatus.count:SetText("X")
		RaidBuffStatus.count:Show()
	end
	RaidBuffStatus.button.free = false
	RaidBuffStatus.button:SetNormalTexture(icon)
	RaidBuffStatus.button:SetPoint("BOTTOMLEFT", RaidBuffStatus.frame, "BOTTOMLEFT", x, y)
	if click then
		RaidBuffStatus.button:SetScript("PreClick", click)
	end
	if update then
		RaidBuffStatus.button.update = update
	end
	if tooltip then
		RaidBuffStatus.button:SetScript("OnEnter", tooltip)
		RaidBuffStatus.button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	RaidBuffStatus.button:Show()
end

function RaidBuffStatus:AddOptionsBuffButton(name, x, y, icon, tooltip)
	RaidBuffStatus.button = CreateFrame("Button", name, RaidBuffStatus.optionsframe, "SecureActionButtonTemplate")
	RaidBuffStatus.button:Hide()
	RaidBuffStatus.button:SetWidth(20)
	RaidBuffStatus.button:SetHeight(20)
	RaidBuffStatus.button:SetNormalTexture(icon)
	RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.optionsframe, "TOPLEFT", x, y)
	if tooltip then
		RaidBuffStatus.button:SetScript("OnEnter", tooltip)
		RaidBuffStatus.button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	RaidBuffStatus.button:Show()
end

function RaidBuffStatus:AddOptionsBuffRadioButton(name, x, y, click, type)
	RaidBuffStatus.button = CreateFrame("CheckButton", name, RaidBuffStatus.optionsframe, "UI" .. type .. "ButtonTemplate")
	table.insert(optionsbuttons, RaidBuffStatus.button)
	RaidBuffStatus.button:Hide()
	if id then
		RaidBuffStatus.button:SetID(id)
	end
	RaidBuffStatus.button:SetWidth(20)
	RaidBuffStatus.button:SetHeight(20)
	RaidBuffStatus.button:SetPoint("TOPLEFT", RaidBuffStatus.optionsframe, "TOPLEFT", x, y)
	RaidBuffStatus.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	if click then
		RaidBuffStatus.button:SetScript("OnClick", click)
	end
	RaidBuffStatus.button:Show()
end



function RaidBuffStatus:ToggleCheck(...)
	if RaidBuffStatus.db.profile[...] then
		RaidBuffStatus.db.profile[...] = false
	else
		RaidBuffStatus.db.profile[...] = true
		RaidBuffStatus:DoReport()
	end
	RaidBuffStatus:UpdateButtons()
end


function RaidBuffStatus:UpdateButtons()
	for _,v in ipairs(buttons) do
		if not v.free then
			if v.update then
				v:update(v)
			end
		end
	end
end

function RaidBuffStatus:UpdateOptionsButtons()
	for _,v in ipairs(optionsbuttons) do
		v:SetChecked(RaidBuffStatus.db.profile[v:GetName()])
	end
end


function RaidBuffStatus:OnProfileEnable()
	RaidBuffStatus:LoadFramePosition()
	RaidBuffStatus:DoReport(true)
end

function RaidBuffStatus:JoinedPartyRaidChanged()
	local oldstatus = raid.isparty or raid.israid
	RaidBuffStatus:DoReport(true)
	if oldstatus then  -- was a raid or party last check
		if raid.isparty or raid.israid then -- still is a raid or party
			RaidBuffStatus:oRA_MainTankUpdate()
		else	-- no longer in raid or party
			RaidBuffStatus:HideReportFrame()
			RaidBuffStatus:UnregisterEvent("PLAYER_AURAS_CHANGED")
			if timer then
				RaidBuffStatus:CancelTimer(timer)
				timer = false
			end
		end
	else
		if raid.isparty or raid.israid then -- newly entered raid or party
			RaidBuffStatus:oRA_MainTankUpdate()
			RaidBuffStatus:RegisterEvent("PLAYER_AURAS_CHANGED", "DoReport")
			timer = RaidBuffStatus:ScheduleRepeatingTimer(RaidBuffStatus.DoReport, 7)
		end
		if (raid.isparty and RaidBuffStatus.db.profile.AutoShowDashParty) or (raid.israid and RaidBuffStatus.db.profile.AutoShowDashRaid) then
			RaidBuffStatus:ShowReportFrame()
		end
	end
end

function RaidBuffStatus:NotifyInspect(unitid)
	if unitid ~= inspectqueueunitid then
		self:UnregisterEvent("INSPECT_TALENT_READY")
		inspectqueuename = ""
		inspectqueueunitid = ""
		inspectqueuetime = 0
		return
	end
end

function RaidBuffStatus:OnEnable()
	RaidBuffStatus:SetupFrames()
	hooksecurefunc("NotifyInspect", function(...) return RaidBuffStatus:NotifyInspect(...) end)
	RaidBuffStatus:JoinedPartyRaidChanged()
	RaidBuffStatus:UpdateMiniMapButton()
	RaidBuffStatus:RegisterEvent("RAID_ROSTER_UPDATE", "JoinedPartyRaidChanged")
	RaidBuffStatus:RegisterEvent("PARTY_MEMBERS_CHANGED", "JoinedPartyRaidChanged")
	RaidBuffStatus:RegisterEvent("PLAYER_ENTERING_WORLD", "JoinedPartyRaidChanged")
	RaidBuffStatus:RegisterEvent("PLAYER_REGEN_ENABLED", "LeftCombat")
	RaidBuffStatus:RegisterEvent("PLAYER_REGEN_DISABLED", "EnteringCombat")
	RaidBuffStatus:Debug('Enabled!')
	if oRA then
		RaidBuffStatus:Debug('Registering ORA event')
		RaidBuffStatus.oRAEvent:RegisterForTankEvent(function() RaidBuffStatus:oRA_MainTankUpdate() end)
	elseif CT_RA_MainTanks then
		RaidBuffStatus:Debug('Registering CTRA event')
		hooksecurefunc("CT_RAOptions_UpdateMTs", function() RaidBuffStatus:oRA_MainTankUpdate() end)
	end
end


function RaidBuffStatus:OnDisable()
	RaidBuffStatus:Debug('Disabled!')
	RaidBuffStatus:UnregisterAllEvents()
	RaidBuffStatus.oRAEvent:UnRegisterForTankEvent()
end

function RaidBuffStatus:EnteringCombat()
	incombat = true
	if (InCombatLockdown()) then
		return
	end
	if RaidBuffStatus.db.profile.DisableInCombat then
		if RaidBuffStatus.frame:IsVisible() then
			dashwasdisplayed = true
			RaidBuffStatus:HideReportFrame()
		else
			dashwasdisplayed = false
		end
		return
	end
	RaidBuffStatus:AddBuffButtons()
	RaidBuffStatus:UpdateButtons()
end

function RaidBuffStatus:LeftCombat()
	incombat = false
	RaidBuffStatus:AddBuffButtons()
	RaidBuffStatus:UpdateButtons()
	if RaidBuffStatus.db.profile.DisableInCombat and dashwasdisplayed then
		RaidBuffStatus:ShowReportFrame()	
	end
end

function RaidBuffStatus:Tooltip(self, title, list, tlist, blist)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(title,1,1,1,1,1)
	if list then
		if #list > 0 then
			local thelisttouse = list
			local timerlist = {}
			if tlist then
				for _, n in ipairs(list) do
					if tlist[n] then
						table.insert(timerlist, n .. "(" .. RaidBuffStatus:TimeSince(tlist[n]) .. ")")
					else
						table.insert(timerlist, n)
					end
				end
				thelisttouse = timerlist
			end
			local str = ""
			for _,s in pairs({strsplit(" ", table.concat(thelisttouse, ", "))}) do
				if #str + #s >= 50 then
					GameTooltip:AddLine(str,nil,nil,nil,1)
					str = ""
				end
				str = str .. " " .. s
			end
			GameTooltip:AddLine(str,nil,nil,nil,1)
			if blist then
				str = L["Buffers: "]
				for _,s in pairs({strsplit(" ", table.concat(blist, ", "))}) do
					if #str + #s >= 50 then
						GameTooltip:AddLine(str,GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, 1)
						str = ""
					end
					str = str .. " " .. s
				end
				GameTooltip:AddLine(str,GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, 1)
			end
		end
	end
	GameTooltip:Show()
end

function RaidBuffStatus:DefaultButtonUpdate(self, table, profile, checking)
	if profile == false then
		self.count:SetText("X")
		self:SetAlpha("0.5")
	else
		if checking then
			self.count:SetText(# table)
			self:SetAlpha("1")
		else
			self.count:SetText("")
			self:SetAlpha("0.15")
		end
	end
end


function RaidBuffStatus:ButtonClick(self, button, down, buffcheck, cheapspell, reagentspell, partybuff)
	local check = BF[buffcheck].check
	local prefix
	if RaidBuffStatus.db.profile[buffcheck .. "buff"] then
		prefix = L["Missing buff: "]
	else
		prefix = L["Warning: "]
	end
	if RaidBuffStatus.db.profile[check] then
		if not InCombatLockdown() and cheapspell then
			self:SetAttribute("type", nil)
			self:SetAttribute("spell", nil)
			self:SetAttribute("unit", nil)
			self:SetScript("PostClick", nil)
		end
		if cheapspell and IsAltKeyDown() then
			RaidBuffStatus:DoReport()
			if not InCombatLockdown() and # report[BF[buffcheck].list] > 0 then
				self:SetAttribute("type", "spell")
				if partybuff then
					if # report[BF[buffcheck].list] > 0 then
						local unitidtobuff, spelltobuff = RaidBuffStatus:PartyBuff(report[BF[buffcheck].list], cheapspell, reagentspell)
						self:SetAttribute("spell", spelltobuff)
						self:SetAttribute("unit", unitidtobuff)
						if unitidtobuff then  -- maybe none in range
							self:SetScript("PostClick", function(self)
								self:SetAttribute("type", nil)
								self:SetAttribute("spell", nil)
								self:SetAttribute("unit", nil)
								self:SetScript("PostClick", nil)
							end)
						end
					end
				else
					self:SetAttribute("spell", cheapspell)
				end
			end
		elseif IsShiftKeyDown() then
			if type(BF[buffcheck].chat) == "string" then
				if # report[BF[buffcheck].list] > 0 then
					if BF[buffcheck].timer then
						local timerlist = {}
						for _, n in ipairs(report[BF[buffcheck].list]) do
							if raid.BuffTimers[buffcheck .. "timerlist"][n] then
								table.insert(timerlist, n .. "(" .. RaidBuffStatus:TimeSince(raid.BuffTimers[buffcheck .. "timerlist"][n]) .. ")")
							else
								table.insert(timerlist, n)
							end
						end
						RaidBuffStatus:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(timerlist, ", "))
					else
						RaidBuffStatus:Say(prefix .. "<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "))
					end
				end
			elseif type(BF[buffcheck].chat) == "function" then
				BF[buffcheck].chat(report, raid, prefix)
			end
		elseif IsControlKeyDown() then
			if BF[buffcheck].selfbuff then
				if type(BF[buffcheck].chat) == "string" then
					if # report[BF[buffcheck].list] > 0 then
						for _, v in ipairs(report[BF[buffcheck].list]) do
							local name = v
							if v:find("%(") then
								name = string.sub(v, 1, v:find("%(") - 1)
							end
							RaidBuffStatus:Say(prefix .. "<" .. BF[buffcheck].chat .. ">: " .. v, name)
						end
					end
				elseif type(BF[buffcheck].chat) == "function" then
					BF[buffcheck].chat(report, raid, prefix)
				end
			elseif BF[buffcheck].partybuff then
				BF[buffcheck].partybuff(report[BF[buffcheck].list], prefix)
			end
		else
			RaidBuffStatus:ToggleCheck(check)
		end
	else
		RaidBuffStatus:ToggleCheck(check)
	end
end

function RaidBuffStatus:SortNameBySuffix(thetable)
	table.sort(thetable, function (a,b)
		local grpa = select(3, a:find"(%d+)")
		local grpb = select(3, b:find"(%d+)")
		if grpa and grpb then
			if grpa == grpb then
				return a < b
			end
			return grpa < grpb
		else
			return a < b
		end
	end)
end

function RaidBuffStatus:TitleCaps(str)
	str = string.lower(str)
	return str:gsub("%a", string.upper, 1)
end

function RaidBuffStatus:TimeSince(thetimethen)
	local thedifference = math.floor(GetTime() - thetimethen)
	if thedifference < 60 then
		return (thedifference .. "s")
	end
	return (math.floor(thedifference / 60) .. "m" .. (thedifference % 60) .. "s")
end

function RaidBuffStatus:InGroupWithEnhShaman(unit)
	for name,_ in pairs(raid.classes.SHAMAN) do
		if raid.classes.SHAMAN[name].talents then
			if raid.classes.SHAMAN[name].talents.spec == "Enhancement" then
				if raid.classes.SHAMAN[name].group == unit.group then
					return true
				end
			end
		end
	end
	return false
end

function RaidBuffStatus:IsMele(name, class)
	if class == "ROGUE" then return true end
	if class == "WARRIOR" then return true end
	if class == "PALADIN" then
		if raid.classes.PALADIN[name].talents then
			if raid.classes.PALADIN[name].talents.spec ~= "Holy" then
				return true
			end
		end
		return false
	end
	if class == "DRUID" then
		if raid.classes.DRUID[name].talents then
			if raid.classes.DRUID[name].talents.spec == "Feral Combat" then
				return true
			end
		end
	end
	if class == "SHAMAN" then
		if raid.classes.SHAMAN[name].talents then
			if raid.classes.SHAMAN[name].talents.spec == "Enhancement" then
				return true
			end
		end
	end
	return false
end

function RaidBuffStatus:NumberOfBlessings(unit, nosalv)
	local list = blessings
	if nosalv then
		list = blessingsns
	end
	local numbless = 0
	for _, v in ipairs(list) do
		if unit.hasbuff[v] then
			numbless = numbless + 1
		end
	end
	return numbless
end




function RaidBuffStatus:GetUnitFromName(whom)
	if whom:find("%(") then
		whom = string.sub(whom, 1, whom:find("%(") - 1)
	end
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			if whom == name then
				return raid.classes[class][name]
			end
		end
	end
	return nil
end


function RaidBuffStatus:PartyBuff(list, cheapspell, reagentspell)
	local pb = {{},{},{},{},{},{},{},{}}
	for _, v in ipairs(list) do
		if v:find("%(") then
			v = string.sub(v, 1, v:find("%(") - 1)
		end
		local unit = RaidBuffStatus:GetUnitFromName(v)
		table.insert(pb[unit.group], unit.unitid)
	end
	table.sort(pb, function (a,b)
		return(#a > #b)
	end)
	for i,_ in ipairs(pb) do
		for _, v in ipairs(pb[i]) do
			if IsSpellInRange(cheapspell, v) == 1 then
				if #pb[i] > 2 then
					return v, reagentspell
				end
				return v, cheapspell
			end
		end
	end
	RaidBuffStatus:Print("RBS: " .. L["Out of range"])
	return nil
end
