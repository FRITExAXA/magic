local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/FRITExAXA/Rayfield/refs/heads/main/main.lua'))()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Mkt = game:GetService("MarketplaceService")
local LP = Players.LocalPlayer

local gN = "Unknown"
local ok1, res1 = pcall(function()
	return Mkt:GetProductInfo(game.PlaceId).Name
end)
if ok1 and res1 then
	gN = res1
end

local W = Rayfield:CreateWindow({
	Name = "FRITE HUB - " .. gN,
	Icon = 0,
	LoadingTitle = "FRITE HUB",
	LoadingSubtitle = gN,
	Theme = "Dark",
	ToggleUIKeybind = "V",
	ConfigurationSaving = {
		Enabled = false
	}
})

if game.PlaceId == 116223724643557 then

	local T1 = W:CreateTab("Farm")
	local T2 = W:CreateTab("Rebirth")
	local T3 = W:CreateTab("Win")
	local T4 = W:CreateTab("Wand")
	local T5 = W:CreateTab("Smart Farm")
	local T7 = W:CreateTab("Eggs")
	local T6 = W:CreateTab("Scripts")

	local Cfg = {
		AF = false,
		AR = false,
		AW = false,
		BAW = false,
		Stage = 1,
		SF = false,
		WandMode = "Stage 20",
		EggBasic   = false,
		EggFire    = false,
		EggArcane  = false,
		EggAstral  = false,
		EggDemonic = false,
	}

	local function gC()
		local Char = LP.Character
		if not Char then return nil end
		local Hrp = Char:FindFirstChild("HumanoidRootPart")
		if not Hrp then return nil end
		return Char, Hrp
	end

	local function fM()
		local Ev = RS:FindFirstChild("Remotes")
		if not Ev then return end
		Ev = Ev:FindFirstChild("GainMagicPower")
		if not Ev then return end
		Ev:FireServer()
	end

	local function gMyReb()
		local ok, result = pcall(function()
			return LP.PlayerGui.GUI.HUD.Labels.RebirthLabel.ContentText
		end)
		if not ok or not result then return nil end
		local n = string.match(result, "%d+")
		if not n then return nil end
		return tonumber(n)
	end

local function parseWins(txt)
	if not txt then return nil end
	txt = txt:gsub("%s+", ""):upper()
	local suffixes = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
	local num, suf = txt:match("^([%d%.]+)([KMBTQ]?)$")
	if not num then return nil end
	num = tonumber(num)
	if not num then return nil end
	if suf and suf ~= "" and suffixes[suf] then
		return num * suffixes[suf]
	end
	return num
end

	local function gMyWins()
		local ok, result = pcall(function()
			return LP.PlayerGui.GUI.HUD.Labels.TrophyLabel.ContentText
		end)
		if not ok or not result then return nil end
		return parseWins(result)
	end

	local function gTpReq(Tp)
		local Hp = Tp:FindFirstChild("HitPart")
		if not Hp then return nil end
		local Ru = Hp:FindFirstChild("RockUI")
		if not Ru then return nil end
		local Rl = Ru:FindFirstChild("RobuxLabel")
		if Rl and (Rl.Visible == nil or Rl.Visible) then
			return nil, true
		end
		local Lbl = Ru:FindFirstChild("RebirthLabel")
		if not Lbl then return nil end
		local n = string.match(Lbl.ContentText, "%d+")
		if not n then return nil end
		return tonumber(n), false
	end

	local function gBestTp()
		local Tps = workspace:FindFirstChild("TargetPractices")
		if not Tps then return nil end
		local myReb = gMyReb()
		if not myReb then return nil end
		local bestI, bestTp = nil, nil
		for i = 1, 10 do
			local Tp = Tps:FindFirstChild("TargetPractice" .. i)
			if Tp then
				local req, isRobux = gTpReq(Tp)
				if not isRobux and req and myReb >= req then
					if not bestI or i > bestI then
						bestI = i
						bestTp = Tp
					end
				end
			end
		end
		return bestTp, bestI
	end

	local lastFarmI = nil

	local function gFarmPos()
		local Tp, i = gBestTp()
		if not Tp then return nil end
		if i ~= lastFarmI then
			lastFarmI = i
		end
		local Hp = Tp:FindFirstChild("HitPart")
		if Hp and Hp:IsA("BasePart") then
			return Hp.Position
		end
		return Tp:GetPivot().Position
	end

	local function sAF()
		while Cfg.AF do
			local Char, Hrp = gC()
			local Pos = gFarmPos()
			if Char and Pos then
				Char:PivotTo(CFrame.new(Pos) + Vector3.new(0, 3, 0))
			end
			fM()
			task.wait()
		end
	end

	local function cReb()
		local _, Hrp = gC()
		if not Hrp then return false end
		local Gui = LP:FindFirstChild("PlayerGui")
		if not Gui then return false end
		local p = Gui:FindFirstChild("GUI")
		if not p then return false end
		p = p:FindFirstChild("Frames")
		if not p then return false end
		p = p:FindFirstChild("Rebirth")
		if not p then return false end
		p = p:FindFirstChild("Frame")
		if not p then return false end
		p = p:FindFirstChild("Bar")
		if not p then return false end
		p = p:FindFirstChild("LevelLabel")
		if not p then return false end
		local LvL = p.ContentText
		local c, m = string.match(LvL, "(%d+)%s*/%s*(%d+)")
		if not c or not m then return false end
		c = tonumber(c)
		m = tonumber(m)
		if not c or not m then return false end
		return c >= m
	end

	local function dReb()
		if not cReb() then return end
		local Ev = RS:FindFirstChild("Remotes")
		if not Ev then return end
		Ev = Ev:FindFirstChild("Rebirth")
		if not Ev then return end
		Ev:FireServer()
	end

	local function sAR()
		while Cfg.AR do
			dReb()
			task.wait()
		end
	end

	local function tT(Part)
		local _, Hrp = gC()
		if not Hrp or not Part then return end
		if not Part:IsA("BasePart") then return end
		firetouchinterest(Hrp, Part, 0)
		task.wait()
		firetouchinterest(Hrp, Part, 1)
	end

	local function dbgModel(Obj)
		for _, d in ipairs(Obj:GetDescendants()) do end
	end

	local function gPart(Obj)
		if Obj:IsA("BasePart") then
			return Obj, nil, nil
		end
		if Obj:IsA("Model") then
			if Obj.PrimaryPart then
				return Obj.PrimaryPart, nil, nil
			end
			local CD, PP, BP = nil, nil, nil
			for _, d in ipairs(Obj:GetDescendants()) do
				if d:IsA("BasePart") and not BP then
					BP = d
				elseif d:IsA("ClickDetector") and not CD then
					CD = d
				elseif d.ClassName == "ProximityPrompt" and not PP then
					PP = d
				end
			end
			return BP, CD, PP
		end
		return nil, nil, nil
	end

	local sbDbg = {}
	local BLUE_COLOR   = Color3.fromRGB(9, 137, 207)
	local PURPLE_COLOR = Color3.fromRGB(98, 37, 209)

	local function gColor(Sb)
		local Cp = Sb:FindFirstChild("Color")
		if Cp and Cp:IsA("BasePart") then return Cp.Color end
		if Sb:IsA("BasePart") then return Sb.Color end
		if Sb:IsA("Model") then
			local Pt = Sb.PrimaryPart
			if Pt then return Pt.Color end
			for _, d in ipairs(Sb:GetDescendants()) do
				if d:IsA("BasePart") then return d.Color end
			end
		end
		return nil
	end

	local function cMatch(c, target)
		return (math.abs(c.R - target.R) < 0.05)
			and (math.abs(c.G - target.G) < 0.05)
			and (math.abs(c.B - target.B) < 0.05)
	end

	local function gTp(Sb)
		local Tp = Sb:FindFirstChild("TouchPart")
		if not Tp then
			for _, d in ipairs(Sb:GetDescendants()) do
				if d:IsA("BasePart") and d.Name ~= "Color" then
					Tp = d
					break
				end
			end
		end
		return Tp
	end

	local function gWB(i)
		local SbF = workspace:FindFirstChild("StaffButtons")
		if not SbF then return nil, nil end
		local Sb = SbF:FindFirstChild("Staff Button" .. i)
		if not Sb then return nil, nil end
		local c = gColor(Sb)
		if not c then return nil, nil end
		if cMatch(c, PURPLE_COLOR) then return "equipped", nil end
		if cMatch(c, BLUE_COLOR) then
			local Tp = gTp(Sb)
			if not Tp then return nil, nil end
			return "available", Tp
		end
		return "locked", nil
	end

	local function gScan()
		local equippedI = nil
		local bestAvailI, bestAvailTp = nil, nil
		for i = 20, 1, -1 do
			local state, Tp = gWB(i)
			if state == "equipped" and not equippedI then
				equippedI = i
			elseif state == "available" and not bestAvailI then
				bestAvailI = i
				bestAvailTp = Tp
			end
		end
		return equippedI, bestAvailI, bestAvailTp
	end

	local lastScan = ""

	local function eW()
		local equippedI, bestAvailI, bestAvailTp = gScan()
		if not bestAvailI then return end
		if not equippedI or bestAvailI > equippedI then
			local Char, Hrp = gC()
			if not Char or not Hrp then return end
			Char:PivotTo(bestAvailTp.CFrame + Vector3.new(0, 3, 0))
			task.wait(0.15)
			tT(bestAvailTp)
		end
	end

	local function sAW2()
		while Cfg.BAW do
			eW()
			task.wait()
		end
	end

	local function gSB(stageNum)
		local St = workspace:FindFirstChild("Stages")
		if not St then return nil end
		local n = stageNum or Cfg.Stage
		local Sg = St:FindFirstChild("Stage" .. n)
		if not Sg then return nil end
		local WB = Sg:FindFirstChild("WinButton")
		if not WB then return nil end
		return WB
	end

	local fired = {}

	local function wWB(WB, timeout)
		local t0 = os.clock()
		while os.clock() - t0 < timeout do
			local Pt, CD, PP = gPart(WB)
			if Pt or CD or PP then return Pt, CD, PP end
			task.wait()
		end
		return gPart(WB)
	end

	local function dWin(stageNum)
		local WB = gSB(stageNum)
		if not WB then return end
		local Char, Hrp = gC()
		if not Char or not Hrp then return end
		local ZonePos = WB:GetPivot().Position
		Char:PivotTo(CFrame.new(ZonePos) + Vector3.new(0, 3, 0))
		local Pt, CD, PP = wWB(WB, 2)
		if Pt or CD or PP then
			if Pt then
				Char:PivotTo(Pt.CFrame + Vector3.new(0, 3, 0))
				task.wait(0.15)
				tT(Pt)
			elseif CD then
				fireclickdetector(CD)
			elseif PP then
				fireproximityprompt(PP)
			end
			fired[WB] = nil
		else
			if not fired[WB] then
				fired[WB] = true
				dbgModel(WB)
			end
		end
	end

	local function sAW()
		while Cfg.AW do
			dWin()
			task.wait()
		end
	end

	local sfStatusLabel = nil
	local AFToggle = nil
	local ARToggle = nil

	local function sfLog(msg)
		if sfStatusLabel then
			pcall(function()
				if sfStatusLabel.Set then
					sfStatusLabel:Set(msg)
				elseif sfStatusLabel.UpdateLabel then
					sfStatusLabel:UpdateLabel(msg)
				end
			end)
		end
	end

	local function sfSetAF(v)
		Cfg.AF = v
		if AFToggle then pcall(function() AFToggle:Set(v) end) end
		if v then task.spawn(sAF) end
	end

	local function sfSetAR(v)
		Cfg.AR = v
		if ARToggle then pcall(function() ARToggle:Set(v) end) end
		if v then task.spawn(sAR) end
	end

	local WIN_TARGET = 100e9

	local function sSmartFarm()
		local cycle = 0
		while Cfg.SF do
			cycle = cycle + 1
			while Cfg.SF do
				local wins = gMyWins() or 0
				if wins >= WIN_TARGET then break end
				local winAvant = wins
				dWin(31)
				local t0 = os.clock()
				while Cfg.SF and os.clock() - t0 < 5 do
					if (gMyWins() or 0) > winAvant then break end
					task.wait(0.2)
				end
				task.wait(0.3)
			end
			if not Cfg.SF then break end
			if Cfg.WandMode == "Inventory" then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.RequestEquipBestWand:FireServer()
				end)
				task.wait(0.5)
			else
				while Cfg.SF do
					local eq, avail, availTp = gScan()
					if eq and not avail then break end
					if eq and avail and avail <= eq then break end
					eW()
					task.wait(0.5)
				end
			end
			if not Cfg.SF then break end
			local rebAvant = gMyReb() or 0
			sfSetAF(true)
			sfSetAR(true)
			while Cfg.SF do
				if (gMyReb() or 0) > rebAvant then break end
				task.wait(0.1)
			end
			sfSetAF(false)
			sfSetAR(false)
			if not Cfg.SF then break end
		end
		sfSetAF(false)
		sfSetAR(false)
		sfLog("Smart Farm stopped")
	end

	AFToggle = T1:CreateToggle({
		Name = "Auto Farm",
		CurrentValue = false,
		Callback = function(v)
			Cfg.AF = v
			if v then task.spawn(sAF) end
		end
	})

	ARToggle = T2:CreateToggle({
		Name = "Auto Rebirth",
		CurrentValue = false,
		Callback = function(v)
			Cfg.AR = v
			if v then task.spawn(sAR) end
		end
	})

	local sL = {}
	for i = 1, 31 do
		table.insert(sL, "Stage " .. i)
	end

	T3:CreateDropdown({
		Name = "Select Stage",
		Options = sL,
		CurrentOption = {"Stage 1"},
		MultipleOptions = false,
		Callback = function(o)
			local s = o[1] or o
			local n = tonumber(string.match(s, "%d+"))
			if n then Cfg.Stage = n end
		end
	})

	local AWToggle = T3:CreateToggle({
		Name = "Auto Win",
		CurrentValue = false,
		Callback = function(v)
			Cfg.AW = v
			if v then task.spawn(sAW) end
		end
	})

	T3:CreateKeybind({
		Name = "Toggle Auto Win",
		CurrentKeybind = "X",
		HoldToInteract = false,
		Callback = function()
			Cfg.AW = not Cfg.AW
			AWToggle:Set(Cfg.AW)
			if Cfg.AW then task.spawn(sAW) end
		end
	})

	T4:CreateToggle({
		Name = "Best Auto Equip Wand",
		CurrentValue = false,
		Callback = function(v)
			Cfg.BAW = v
			if v then task.spawn(sAW2) end
		end
	})

	sfStatusLabel = T5:CreateLabel("Waiting...")

	T5:CreateDropdown({
		Name = "Wand Mode",
		Options = {"Stage 20", "Inventory"},
		CurrentOption = {"Stage 20"},
		MultipleOptions = false,
		Callback = function(o)
			local s = o[1] or o
			Cfg.WandMode = s
		end
	})

	T5:CreateToggle({
		Name = "Smart Farm",
		CurrentValue = false,
		Callback = function(v)
			Cfg.SF = v
			if v then task.spawn(sSmartFarm) end
		end
	})

	T5:CreateKeybind({
		Name = "Toggle Smart Farm",
		CurrentKeybind = "G",
		HoldToInteract = false,
		Callback = function()
			Cfg.SF = not Cfg.SF
			if Cfg.SF then task.spawn(sSmartFarm) end
		end
	})

	local EGG_EVENT = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("OpenEgg")

	local EGGS = {
		{ name = "Basic Egg",   cfg = "EggBasic"   },
		{ name = "Fire Egg",    cfg = "EggFire"    },
		{ name = "Arcane Egg",  cfg = "EggArcane"  },
		{ name = "Astral Egg",  cfg = "EggAstral"  },
		{ name = "Demonic Egg", cfg = "EggDemonic" },
	}

	local function openEgg(eggName)
		local Char, Hrp = gC()
		if not Char or not Hrp then return end
		local EggsFolder = workspace:FindFirstChild("Eggs")
		if not EggsFolder then return end
		local EggObj = EggsFolder:FindFirstChild(eggName)
		if not EggObj then return end
		local pos = EggObj:IsA("BasePart") and EggObj.Position
			or (EggObj:IsA("Model") and EggObj:GetPivot().Position)
		if not pos then return end
		Char:PivotTo(CFrame.new(pos) + Vector3.new(0, 3, 0))
		task.wait(0.1)
		if not EGG_EVENT then
			EGG_EVENT = RS.Remotes:FindFirstChild("OpenEgg")
		end
		if EGG_EVENT then
			EGG_EVENT:InvokeServer(eggName)
		end
	end

	local function sEggLoop(egg)
		while Cfg[egg.cfg] do
			openEgg(egg.name)
			task.wait(0.05)
		end
	end

	T7:CreateSection("Auto Open Eggs")

	for _, egg in ipairs(EGGS) do
		local cfgKey = egg.cfg
		local eggName = egg.name
		T7:CreateToggle({
			Name = "Auto " .. eggName,
			CurrentValue = false,
			Callback = function(v)
				Cfg[cfgKey] = v
				if v then
					task.spawn(sEggLoop, { name = eggName, cfg = cfgKey })
				end
			end
		})
	end

	T6:CreateSection("Anti AFK")

	T6:CreateButton({
		Name = "Anti AFK",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/xpzrmodzz/anti-afk2/refs/heads/main/anti%20afk13"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Anti AFK Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})

	T6:CreateSection("Auto Respawn")

	T6:CreateButton({
		Name = "Auto Respawn Last Position",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/FRITExRAZMO/auto-respawn/refs/heads/main/main.lua"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Auto Respawn Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})

	T6:CreateSection("Infinite Yield")

	T6:CreateButton({
		Name = "Infinite Yield",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Infinite Yield Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})

	local GiveItemTab = W:CreateTab("GIVE ITEM")

	local RunesRoot = RS:FindFirstChild("Remotes")
	local RuneEvent = RunesRoot and RunesRoot:FindFirstChild("RunePickedUp")
	local ArmorEvent = RunesRoot and RunesRoot:FindFirstChild("ArmorPickedUp")

	local function getRuneFolder()
		local ok, folder = pcall(function()
			return LP.PlayerGui.GUI.Frames.Backpack.Gear.Runes.Rune4.RuneImages
		end)
		if ok then
			return folder
		end
		return nil
	end

	local function getGearSubFolder(category, subFolderName)
		local ok, folder = pcall(function()
			return LP.PlayerGui.GUI.Frames.Backpack.Gear.Gears[category][subFolderName]
		end)
		if ok then
			return folder
		end
		return nil
	end

	local function getUniqueNames(folder)
		local items = {}
		local seen = {}
		if folder then
			for _, child in ipairs(folder:GetChildren()) do
				if not seen[child.Name] then
					table.insert(items, child.Name)
					seen[child.Name] = true
				end
			end
		end
		table.sort(items)
		return items
	end

	local runeFolder = getRuneFolder()
	local runeOptions = getUniqueNames(runeFolder)
	local selectedRune = nil

	if #runeOptions == 0 then
		runeOptions = {"NO RUNES FOUND"}
	end

	GiveItemTab:CreateSection("Rune")

	GiveItemTab:CreateDropdown({
		Name = "UNLOCK UR RUNE",
		Options = runeOptions,
		CurrentOption = {"CLICK HERE TO CHOOSE UR RUNE"},
		MultipleOptions = false,
		Flag = "RuneDropdown",
		Callback = function(Option)
			selectedRune = Option[1]
		end
	})

	GiveItemTab:CreateButton({
		Name = "UNLOCK",
		Callback = function()
			if not selectedRune then
				Rayfield:Notify({
					Title = "RUNE",
					Content = "Select a rune first",
					Duration = 3
				})
				return
			end
			if not RuneEvent then
				Rayfield:Notify({
					Title = "RUNE",
					Content = "RunePickedUp remote not found",
					Duration = 3
				})
				return
			end
			RuneEvent:FireServer(selectedRune)
			Rayfield:Notify({
				Title = "RUNE UNLOCKED",
				Content = selectedRune,
				Duration = 3
			})
		end
	})

	local chestplateFolder = getGearSubFolder("Chestplate", "ChestplateImages")
	local chestplateOptions = getUniqueNames(chestplateFolder)
	local selectedChestplate = nil

	if #chestplateOptions == 0 then
		chestplateOptions = {"NO CHESTPLATES FOUND"}
	end

	GiveItemTab:CreateSection("Chestplate")

	GiveItemTab:CreateDropdown({
		Name = "UNLOCK UR CHESTPLATE",
		Options = chestplateOptions,
		CurrentOption = {"CLICK HERE TO CHOOSE UR CHESTPLATE"},
		MultipleOptions = false,
		Flag = "ChestplateDropdown",
		Callback = function(Option)
			selectedChestplate = Option[1]
		end
	})

	GiveItemTab:CreateButton({
		Name = "UNLOCK",
		Callback = function()
			if not selectedChestplate then
				Rayfield:Notify({
					Title = "ARMOR",
					Content = "Select a chestplate first",
					Duration = 3
				})
				return
			end
			if not ArmorEvent then
				Rayfield:Notify({
					Title = "ARMOR",
					Content = "ArmorPickedUp remote not found",
					Duration = 3
				})
				return
			end
			ArmorEvent:FireServer(selectedChestplate)
			Rayfield:Notify({
				Title = "CHESTPLATE UNLOCKED",
				Content = selectedChestplate,
				Duration = 3
			})
		end
	})

	local bootsFolder = getGearSubFolder("Boots", "BootsImages")
	local bootsOptions = getUniqueNames(bootsFolder)
	local selectedBoots = nil

	if #bootsOptions == 0 then
		bootsOptions = {"NO BOOTS FOUND"}
	end

	GiveItemTab:CreateSection("Boots")

	GiveItemTab:CreateDropdown({
		Name = "UNLOCK UR BOOTS",
		Options = bootsOptions,
		CurrentOption = {"CLICK HERE TO CHOOSE UR BOOTS"},
		MultipleOptions = false,
		Flag = "BootsDropdown",
		Callback = function(Option)
			selectedBoots = Option[1]
		end
	})

	GiveItemTab:CreateButton({
		Name = "UNLOCK",
		Callback = function()
			if not selectedBoots then
				Rayfield:Notify({
					Title = "ARMOR",
					Content = "Select boots first",
					Duration = 3
				})
				return
			end
			if not ArmorEvent then
				Rayfield:Notify({
					Title = "ARMOR",
					Content = "ArmorPickedUp remote not found",
					Duration = 3
				})
				return
			end
			ArmorEvent:FireServer(selectedBoots)
			Rayfield:Notify({
				Title = "BOOTS UNLOCKED",
				Content = selectedBoots,
				Duration = 3
			})
		end
	})

elseif game.PlaceId == 140070560575882 then

	local T8 = W:CreateTab("Dungeon")

	local _G_Power = false
	local _G_Kill  = false

	local function Power()
		task.spawn(function()
			_G_Power = true
			while _G_Power do
				task.wait()
				pcall(function()
					local remote = game:GetService("ReplicatedStorage").Remotes.GainMagicPower
					for _ = 1, 3 do
						remote:FireServer()
					end
					task.wait()
				end)
			end
		end)
	end

	local function Kill()
		task.spawn(function()
			_G_Kill = true
			while _G_Kill do
				task.wait()
				pcall(function()
					for _, mob in pairs(workspace.DungeonMobs:GetChildren()) do
						local remote = game:GetService("ReplicatedStorage").Remotes.DealMobDamage
						remote:FireServer(mob, math.huge)
					end
					task.wait(0.5)
				end)
			end
		end)
	end

	T8:CreateToggle({
		Name = "Auto Power",
		CurrentValue = false,
		Callback = function(v)
			_G_Power = v
			if v then Power() end
		end
	})

	T8:CreateToggle({
		Name = "Kill Aura",
		CurrentValue = false,
		Callback = function(v)
			_G_Kill = v
			if v then Kill() end
		end
	})

	T8:CreateSlider({
		Name = "HipHeight",
		Range = {2, 50},
		Increment = 1,
		Suffix = "",
		CurrentValue = 2,
		Callback = function(value)
			local char = game.Players.LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.HipHeight = value
			end
		end
	})

	local T9 = W:CreateTab("Scripts")

	T9:CreateSection("Anti AFK")

	T9:CreateButton({
		Name = "Anti AFK",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/xpzrmodzz/anti-afk2/refs/heads/main/anti%20afk13"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Anti AFK Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})

	T9:CreateSection("Auto Respawn")

	T9:CreateButton({
		Name = "Auto Respawn Last Position",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/FRITExRAZMO/auto-respawn/refs/heads/main/main.lua"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Auto Respawn Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})

	T9:CreateSection("Infinite Yield")

	T9:CreateButton({
		Name = "Infinite Yield",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
			Rayfield:Notify({
				Title = "FRITE HUB",
				Content = "Infinite Yield Enabled",
				Duration = 3,
				Image = "check"
			})
		end,
	})
end
