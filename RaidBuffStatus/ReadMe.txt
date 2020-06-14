Instructions: http://www.wowace.com/wiki/RaidBuffStatus

Version 1.0 8th March 2008
-- This version checks raids for:
-- Fortitude
-- Mark of the Wild
-- Intellect
-- Spirit
-- Shadow
-- Intelligently skips checks of buffs from classes that are not in the raid
-- Intelligently spots priests with the spirit talent and skips spirit check if there are none
-- Checks that paladins don't have shadow aura and priest shadow aura as they don't stack
-- Food buff
-- Flask or Battle and Guardian elixir
-- AFK
-- PVP
-- Dead
-- Offline
-- In different zone
-- There is a different aura per paladin per group
-- All paladins have an aura
-- Paladins for Crusader Aura
-- Chars with < 80% mana
-- Chars with < 80% health
-- Works in a party and a raid
-- Only allow you report to raid if you are a leader or assist but always allows report to self or party
-- Checking for a buff or warning can be enabled or disabled by clicking on the buff button
-- Window position and buff options are preserved between logins
-- Support profiles
-- Support debug mode
-- Window auto shows and closes when joining or leaving a party or raid
-- Currently it scans every 6 secs or on buff event.

Version 1.1 9th March 2008
-- Currently it scans every 10 secs or on buff event.
-- Hunter with no aspect
-- Hunter with aspect of the pack or cheetah
-- Protection paladin with no Righteous Fury
-- Checks events actually registered before unregistering
-- Fixed bug: Shadow and Aura at same time check not enabling
-- Fixed bug: Sometimes an inspect fails and this is now captured
-- Fixed bug: Noisy talent inspection addons would interfere with the inspect ready event so
   this is handled by using a secure hook
-- toc file now has svn revision information
-- Check someone has a soul stone

Version 1.2 14th March 2008
-- Fixed bug: Re-showing all the time.  Now hiding stays hidden until you join a party or raid again.
-- Added to the Well Fed check "Increased Stamina", "Rumsey Rum Black Label", and "Electrified".

Version 1.3 24th March 2008
-- Added German translations. (Done by Farook)
-- Completely re-worked how buttons and buff checks are stored and displayed.  Now it is completely
   dynamic thus making it easier to add more checks and an options window in the near future.
-- Boss only buff checks are now in their own section.
-- Window title changed to RBS 1.3.
-- Disabled-manually buffs now display a "." instead of being blank so you can tell the difference
   between disabled and not being used due to lack of a class.
-- Soulstone is now a boss check only.

Version 1.31 25th March 2008
-- Added /rbs toggle option for toggling open and close the dashboard.
-- Fixed bug: frame and icons not on same level.  Now comes to front when clicked.
-- Fixed bug: offline check would not disable.
-- Fixed bug: tooltip was much too wide when many people need a buff.
-- Added ability to shift click and report only on a single missing buff.
-- Priest with spirit buff detected now only appears if you are the leader.
-- Added check for Inner Fire.
-- Fixed bug: missing number of buffs and warnings are correctly counted again now.
-- It no longer says it has activated on start.  No need to add to the other spam.

Version 1.32 26th March 2008
-- Updated to WoW version 2.4.
-- Added missing flasks Mr Pinchy's Blessing, Flask of Blinding Light, Flask of Pure Death.
-- Added new 2.4 flasks Shattrath Flask of Pure Death and Shattrath Flask of Blinding Light.
-- Mouse-over hi-lighting added.

Version 1.40 1st April 2008
-- Changed talent inspection to work properly with 2.4.
-- Added check for Fel Armor.
-- Added a talent and specialisation report window.  Many more specialisation reports to come in future.
-- Moved the spirit buff talent announce from raid chat to just display on the talent report window.
-- Added a talent report for priests with improved spirit buff.
-- Tidied German translations file.  It sill needs some translations.
-- It now ignores players in groups 5 and above.  This is a temporary change until something better is written.
-- Text colours now set properly.
-- Fixed bug in dynamic button layout maths.
-- Added report for Druids with improved Mark of the Wild.

Version 1.41 2nd April 2008
-- Added report on Warlock healthstone talents.
-- Added check for Druids who have the Omen of Clarity talent point that they have self buffed with it.
-- Fixed Shattrath Flask of Pure Death and Shattrath Flask of Blinding Light.  Stupid Blizzard inconsistent naming.
-- Fixed missing tool tip for Shadow Aura and Protection.

Version 1.42 4th April 2008
-- Added diplaying of group number next to the character name on group buffs.

Version 1.43 5th April 2008
-- Displaying of group numbers is now sorted by group number in the report.
-- A number of the buffs are no longer checked if the person is not in the same zone.
-- Rogues and Warriors are now ignored for Intellect and Spirit buffs.
-- Reports on Priests with Lightwell ability.
-- Reports on Priests with improved Power Word: Fortitude.

Version 1.44 8th April 2008
-- Added check that a Mage has an armor self buff.
-- Default talent report sort order is class now.

Version 1.44b 9th April 2008
-- Fixed MotW report.  It incorrectly reported 4 or 5 points spent even when they where not.  Spotted by Tanagra in a code review.

Version 1.44t 10th April 2008
-- Added Spanish translations by Tanagra on Kul Tiras Europe server.
-- Added French translations by Veve CDO EU Server.
-- Fixed bug causing error when other addons check talents.
-- Added zhTW translations.  Actually someone ninja added it to SVN not me.

Version 1.44u 12th April 2008
-- Fixed German translation by commenting out the translations not done and by doing some.

Version 1.45 12th April 2008
-- Added a Ready Check button.

Version 1.46 20th April 2008
-- Corrected positioning of the Ready check button.
-- Hidden Options Window button as it's taken longer than expected to get around to implementing it.
-- Removed BabbleSpell and instead use GetSpellInfo() with spell IDs.
-- Removed a huge number of translation lines that are now automatically translated using GetSpellInfo().
-- Added some translations for the Ready check button.
-- When no buffs are needed it now also lets you know if it was a Boss or a Trash check.

Version 1.46t 21st April 2008
-- Corrected some Spanish translations.

Version 1.50 30th April 2008
-- Added options window which allows you to configure which buffs to check and when.

Version 1.60 11th May 2008
-- Added the ability to Ctrl-click a self buff and have the addon whisper those who need it.
-- Added some Spanish translations.
-- Added a talent report for Paladins with Kings and Sanctuary.
-- Added a talent report for Warriors with improved demo shout.
-- Auto-disabled buffs are now faded out on the dashboard for improved clarity.
-- Disabled buffs are now faded out and have a cross on the dashboard for improved clarity.
-- Shift clicking a missing buff will now display in raid "Missing buff:" or "Warning:" as appropriate.
-- Sorting has been made slightly neater.
-- Added a new warning which checks the flasks are correct for the zone, eg Unstable at Gruul.

Version 1.61 13th May 2008
-- Fixed some translation and zone issues with the flask zone checker.
-- Added some Spanish translations.

Version 1.70 21st May 2008
-- Added a feature where it tells you how long someone was AFK, Offline, PVP or dead.
-- Added a feature where Ctrl-click Shadow Protection and it will whisper all the Priests a list of who needs it.
-- Added a feature where Ctrl-click Arcane Intellect and it will whisper all the Mages a list of who needs it.
-- Added a feature where Ctrl-click Mark of the Wild and it will whisper all the Druids, with the most talent points spend in MotW, a list of who needs it.
-- Added a feature where Ctrl-click Fortitude and it will whisper all the Priests, with the most talent points spend in Fortitude, a list of who needs it.
-- Added a feature where Ctrl-click Spirit and it will whisper all the Priests, with the most talent points spend in Spirit, a list of who needs it.

Version 1.71 28th May 2008
-- Added the option to hide selected dashboard items on entering combat to reduce the size and only show what matters in combat.

Version 1.72 30th May 2008
-- Added a check for Priests, Mages and Warlocks with Blessing of Might.  And Rogues with Blessing of Wisdom.
-- Added a check that looks for players obviously missing Paladin blessings.
-- Added a check for Amplify Magic. It is disabled and hidden by default as most encounters don't need it. Enable in the options window.

Version 1.72b 31st May 2008
-- Fixed some of the Paladin blessing checking especially when in a party.

Version 1.73 2nd June 2008
-- Fixed bug with Paladin blessings and Feral Combat druids and Enhancement Shamans.
-- Added temporary weapon buff checking.  Warning: This is experimental code.

Version 1.80 27th June 2008
-- Fixed some bugs with temporary weapon buff checking.
-- Removed the warning about temporary weapon buff checking being experimental.  It seems to work but is range limited.
-- Mele dps with a temporary weapon buff and are in a group with an enhancement shaman will show a warning.
-- Reworked Paladin blessing checking to cope with fringe scenarios better.
-- Party based buffs now show in the tooltip who the buffers are, as well.
-- Added a fake buff button.  The tooltip gives help information.  It can be disabled in the options window.
-- Alt-click on a self buff will renew that buff.
-- Alt-click on a party buff will cast a spell on someone in a party missing that buff.
   If 3 or more people are missing, the longer reagent buff will be cast otherwise the shorter one.

Version 1.81 29th June 2008
-- Fixed bug in Paladin blessing checking for Druids and Shamans.

Version 1.81g 30th June 2008
-- Fixed problem with German translation file.

Version 1.81h 5th July 2008
-- Fixed bug causing an error to pop up sometimes when the tank list is set up.

Version 1.90 6th July 2008
-- Role information and main tank lists are now parsed to be able to know who is a tank.
-- Added a new warning for mele tanks missing thorns.
-- Added a new warning for tanks with salvation.
-- Group 6 is no longer ignored so you must use groups 7 and 8 for reserves.  This will be configurable in the future.
-- Buffers on tooltips now in green to make it clearer.
-- Added a button that shows the tanks.  Hidden by default.  The tanks listed are, in theory, true tanks and not just
   those listed on the tank list.  I.e. it looks at spec etc.

Version 1.91 10th July 2008
-- Added a minimap button.
-- Group 6 is again ignored due to popular demand.  This will be configurable in the future.

Version 1.92 27th July 2008
-- Added Righteous and Blessed Weapon Coatings to the weapon buffs list.
-- Added talent report on improved Battle Shout.
-- Added some checks for being in combat or not and if in combat disable some protected actions causing taint log spam.

Version 1.92t 30th July 2008
-- Updated Spanish translations.

Version 1.93 1st August 2008
-- Added a Blizzard UI addon options pane.
-- Added option to ignore or not groups 6 to 8.
-- Added option to hide or show the Minimap icon.
-- Added option to report only to self instead of raid.

Version 2.00 13th August 2008
-- Ported from Ace2 to Ace3 framework.  Ace3 is faster and uses less memory and provides nice config widgets.
-- You can now alt-click on tanks missing thorns to automatically buff just like the party buffs.
-- Reworked buff checking to be faster and also to not check buffs that are not displayed during combat.
-- Raid scanning is now rate-limited so combat action will not cause lots of CPU usage.
-- Ace 2 Aura-Special-Events library (seemingly-no-longer-maintained) has been replaced with a few lines of my own code.
-- Fixed taint error on clicking on self buffs during combat.
-- Corrected Rumsy Rum Black Label spell id.
-- The few remaining spells referenced by name are now by number for speed.
-- Fixed a long standing bug where if you were the same class as somone who was offline you might be skipped for buff checking.
-- Added the option to report to some different channels.
-- Added an option to allow you to configure the number of buff columns and hense the width and height.
-- Implemented my own minimal replacement for Ace 2 Gratuity library.
-- You can now change the colour and alpha of the window.

Version 2.01 14th August 2008
-- Fixed issue with it not reading the tank list when reconnecting when already in a raid.

Version 2.02 23rd August 2008
-- Added check for Trueshot Aura.
-- Added an option to completely disable the dashboard and buff checking during combat.

Version 2.02t 25th August 2008
-- Updated Spanish translation.
-- Added Simplified Chinese translation.

Version 2.03 25th August 2008
-- Added an option to allow you to configure if the dashboard automatically shows or not when you join a party or raid.

Version 2.04 31st August 2008
-- Cybersea fixed Inner Fire spell checking. It has been broken since version 2 as it was using a spell name instead of a spell id.
-- Added an option to switch off or on the group number of a person in reporting.
-- Added an option to spam "RBS::" a lot less.
-- Added some more simplified Chinese translations.
-- Fixed weapon buff checking with enhancement shamans.  Now it knows druids don't get Windfury.

Version 2.05 2nd September 2008
-- Added talent report for Earth Shield.
-- Added buff check for Shaman Water Shield.
-- Added some simplified Chinese and Spanish translations.

Version 2.06 7th September 2008
-- Added talent report for Aura Mastery.
-- Added some Spanish translations.

Daniel Barron daniel@jadeb.com

























NOTES FOR AUTHOR ONLY

Maybe one day I will implement these....

-- Check the SS is on priest/pala/shaman
-- change to using LibTalentQuery
-- icon for ace options in game
-- scrolls for MTs
-- mt has no imp
-- Item check
-- runes
-- Recommend flask/elixir
-- wrong kind of elixir for class
-- support UI scaling
-- check someone has soul stone or shaman rebirth not on cool down
Bloodberry Elixir is a zone-specific elixir that (I think) only takes effect on Isle of Quel'Danas, Magister's Terrace and Sunwell Plateau.
Use profilefu to see what it's like in combat
Report on number of shards locks have
-- option to shorten names in report eg: Danielbarron, Tanagra, Darinia -> Dan, Tan, Dar.
