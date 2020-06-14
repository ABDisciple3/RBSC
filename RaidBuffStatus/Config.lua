local L = LibStub('AceLocale-3.0'):GetLocale('RaidBuffStatus')

local options = { 
	type='group',
	args = {
		show = {
			type = 'execute',
			name = L['Show the buff report dashboard.'],
			desc = L['Show the buff report dashboard.'],
			func = function()
				RaidBuffStatus:DoReport()
				RaidBuffStatus:ShowReportFrame()
			end,
			guiHidden = true,
		},
		hide = {
			type = 'execute',
			name = L["Hide the buff report dashboard."],
			desc = L["Hide the buff report dashboard."],
			func = "HideReportFrame",
			guiHidden = true,
		},
		toggle = {
			type = 'execute',
			name = L["Hide and show the buff report dashboard."],
			desc = L["Hide and show the buff report dashboard."],
			func = function()
				if RaidBuffStatus.frame then
					if RaidBuffStatus.frame:IsVisible() then
						RaidBuffStatus:HideReportFrame()
					else
						RaidBuffStatus:DoReport()
						RaidBuffStatus:ShowReportFrame()
					end
				end
			end,
			guiHidden = true,
		},
		report = {
			type = 'execute',
			name = 'report',
			desc = L["Report to /raid or /party who is not buffed to the max."],
			func = function()
				RaidBuffStatus:DoReport()
				RaidBuffStatus:ReportToChat(true)
			end,
			guiHidden = true,
		},
		debug = {
			type = 'execute',
			name = 'debug',
			desc = 'Toggles debug messages.',
			func = function()
				RaidBuffStatus.db.profile.Debug = not RaidBuffStatus.db.profile.Debug
			end,
			guiHidden = true,
			cmdHidden = true,
		},
		taunt = {
			type = 'execute',
			name = 'debug',
			desc = 'Refreshes tank list.',
			func = function()
				RaidBuffStatus:oRA_MainTankUpdate()
			end,
			guiHidden = true,
			cmdHidden = true,
		},
		appearance = {
			type = 'group',
			name = L['Appearance'],
			desc = L['Skin and minimap options'],
			args = {
				autoshowdashparty = {
					type = 'toggle',
					name = L['Show in party'],
					desc = L['Automatically show the dashboard when you join a party'],
					get = function(info) return RaidBuffStatus.db.profile.AutoShowDashParty end,
					set = function(info, v)
						RaidBuffStatus.db.profile.AutoShowDashParty = v
					end,
				},
				autoshowdashraid = {
					type = 'toggle',
					name = L['Show in raid'],
					desc = L['Automatically show the dashboard when you join a raid'],
					get = function(info) return RaidBuffStatus.db.profile.AutoShowDashRaid end,
					set = function(info, v)
						RaidBuffStatus.db.profile.AutoShowDashRaid = v
					end,
				},
				minimap = {
					type = 'toggle',
					name = L['Minimap icon'],
					desc = L['Toggle to display a minimap icon'],
					get = function(info) return RaidBuffStatus.db.profile.MiniMap end,
					set = function(info, v)
						RaidBuffStatus.db.profile.MiniMap = v
						RaidBuffStatus:UpdateMiniMapButton()
					end,
				},
				backgroundcolour = {
					type = 'color',
					name = L['Background colour'],
					desc = L['Background colour'],
					hasAlpha = true,
					get = function(info)
						local r = RaidBuffStatus.db.profile.bgr
						local g = RaidBuffStatus.db.profile.bgg
						local b = RaidBuffStatus.db.profile.bgb
						local a = RaidBuffStatus.db.profile.bga
						return r, g, b, a
					end,
					set = function(info, r, g, b, a)
						RaidBuffStatus.db.profile.bgr = r
						RaidBuffStatus.db.profile.bgg = g
						RaidBuffStatus.db.profile.bgb = b
						RaidBuffStatus.db.profile.bga = a
						RaidBuffStatus:SetFrameColours()
					end,
				},
				bordercolour = {
					type = 'color',
					name = L['Border colour'],
					desc = L['Border colour'],
					hasAlpha = true,
					get = function(info)
						local r = RaidBuffStatus.db.profile.bbr
						local g = RaidBuffStatus.db.profile.bbg
						local b = RaidBuffStatus.db.profile.bbb
						local a = RaidBuffStatus.db.profile.bba
						return r, g, b, a
					end,
					set = function(info, r, g, b, a)
						RaidBuffStatus.db.profile.bbr = r
						RaidBuffStatus.db.profile.bbg = g
						RaidBuffStatus.db.profile.bbb = b
						RaidBuffStatus.db.profile.bba = a
						RaidBuffStatus:SetFrameColours()
					end,
				},
				dashboardcolumns = {
					type = 'range',
					name = L['Dashboard columns'],
					desc = L['Number of columns to display on the dashboard'],
					min = 5,
					max = 17,
					step = 1,
					bigStep = 1,
					get = function() return RaidBuffStatus.db.profile.dashcols end,
					set = function(info, v)
						RaidBuffStatus:AddBuffButtons()
						RaidBuffStatus.db.profile.dashcols = v
					end,
				},
			},
		},
		reporting = {
			type = 'group',
			name = L['Reporting'],
			desc = L['Reporting options'],
			args = {
				ignorelastthreegroups = {
					type = 'toggle',
					name = L['Ignore groups 6 to 8'],
					desc = L['Ignore groups 6 to 8 when reporting as these are for subs'],
					get = function(info) return RaidBuffStatus.db.profile.IgnoreLastThreeGroups end,
					set = function(info, v)
						RaidBuffStatus.db.profile.IgnoreLastThreeGroups = v
					end,
				},
				reportself = {
					type = 'toggle',
					name = L['Report to self'],
					desc = L['Report to self'],
					get = function(info) return RaidBuffStatus.db.profile.ReportSelf end,
					set = function(info, v)
						RaidBuffStatus.db.profile.ReportSelf = v
					end,
				},
				reportchat = {
					type = 'toggle',
					name = L['Report to raid/party'],
					desc = L['Report to raid/party - requires raid assistant'],
					get = function(info) return RaidBuffStatus.db.profile.ReportChat end,
					set = function(info, v)
						RaidBuffStatus.db.profile.ReportChat = v
					end,
				},
				reportofficer = {
					type = 'toggle',
					name = L['Report to officers'],
					desc = L['Report to officer channel'],
					get = function(info) return RaidBuffStatus.db.profile.ReportOfficer end,
					set = function(info, v)
						RaidBuffStatus.db.profile.ReportOfficer = v
					end,
				},
				prependrbs = {
					type = 'toggle',
					name = L['Prepend RBS::'],
					desc = L['Prepend RBS:: to all lines of report chat. Disable to only prepend on the first line of a report'],
					get = function(info) return RaidBuffStatus.db.profile.PrependRBS end,
					set = function(info, v)
						RaidBuffStatus.db.profile.PrependRBS = v
					end,
				},
				showgroupnumber = {
					type = 'toggle',
					name = L['Show group number'],
					desc = L['Show the group number of the person missing a party buff'],
					get = function(info) return RaidBuffStatus.db.profile.ReportGroupNumber end,
					set = function(info, v)
						RaidBuffStatus.db.profile.ReportGroupNumber = v
					end,
				},
-- The aliens stole my brain before I could write the code for this feature.
--				shortennames = {
--					type = 'toggle',
--					name = L['Shorten names'],
--					desc = L['Shorten names in the report to reduce channel spam'],
--					get = function(info) return RaidBuffStatus.db.profile.ShortenNames end,
--					set = function(info, v)
--						RaidBuffStatus.db.profile.ShortenNames = v
--					end,
--				},
			},
		},
		combat = {
			type = 'group',
			name = L['Combat'],
			desc = L['Combat options'],
			args = {
				disableincombat = {
					type = 'toggle',
					name = L['Disable in combat'],
					desc = L['Hide dashboard and skip buff checking during combat'],
					get = function(info) return RaidBuffStatus.db.profile.DisableInCombat end,
					set = function(info, v)
						RaidBuffStatus.db.profile.DisableInCombat = v
					end,
				},
			},
		},
    	},
}

RaidBuffStatus.configOptions = options
LibStub("AceConfig-3.0"):RegisterOptionsTable("RaidBuffStatus", options, {'rbs', 'raidbuffstatus'})
