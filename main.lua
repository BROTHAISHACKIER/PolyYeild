--made by brothaishackier
local version = "2.0"
local keybrd = "qwerty" --qwerty or azerty
local prefix = ";"
if not PlayerGUI:FindChild("PolyYield") then
	local function getplayer(who)
		for i, v in ipairs(Players:GetPlayers()) do
			if v.Name:lower():sub(1, #who) == who:lower() then
				return v
			end
		end
		return nil
	end
	local function notify(msg)
		Chat:BroadcastMessage(msg)
	end
	local function tp(who)
		if getplayer(who) and getplayer(who) ~= Players.LocalPlayer then
			Players.LocalPlayer.Position = getplayer(who).Position
			notify("teleported LocalPlayer to " .. getplayer(who).Name)
		elseif who == "all" then
			for i, v in ipairs(Players:GetPlayers()) do
				if not v == Players.LocalPlayer then
	                wait(0.05)
					Players.LocalPlayer.Position = v.Position
				end
			end
		else
			notify(who .. " is not a player")
		end
	end
	local function gettime()
		return 0.01
	end
	local banging = nil
	local function bang(who, speed)
		banging = nil
		wait(gettime() + 0.01)
		banging = getplayer(who)
		if banging and banging ~= Players.LocalPlayer then
			local last = 0
			local out = true
			local time = gettime()
			local speed = speed and tonumber(speed) or 1
			while true do
				wait(time)

				if banging then
					Players.LocalPlayer.Rotation = banging.Rotation

					if last >= 3 then
						out = false
					elseif last <= 1 then
						out = true
					end

					if out then
						last = last + time / 0.25 * speed
					else
						last = last - time / 0.25 * speed
					end

					local offset = Vector3.New(0, 0, -last)

					local rotatedOffset = banging.Right * offset.X + banging.Up * offset.Y + banging.Forward * offset.Z

					Players.LocalPlayer.Position = banging.Position + rotatedOffset
				else
					break
				end
			end
		end
	end
	local function fbang(who, speed)
		banging = nil
		wait(gettime() + 0.01)
		banging = getplayer(who)
		if banging and banging ~= Players.LocalPlayer then
			local last = 0
			local out = true
			local time = gettime()
			local speed = speed and tonumber(speed) or 1
			while true do
				wait(time)

				if banging then
					Players.LocalPlayer.Rotation = banging.Rotation + Vector3.New(0, 180, 0)

					if last >= 3 then
						out = false
					elseif last <= 1 then
						out = true
					end

					if out then
						last = last + time / 0.25 * speed
					else
						last = last - time / 0.25 * speed
					end

					local offset = Vector3.New(0, 1.5, last)

					local rotatedOffset = banging.Right * offset.X + banging.Up * offset.Y + banging.Forward * offset.Z

					Players.LocalPlayer.Position = banging.Position + rotatedOffset
				else
					break
				end
			end
		end
	end

	local function headsit(who)
		banging = nil
		wait(gettime() + 0.01)
		banging = getplayer(who)
		if banging and banging ~= Players.LocalPlayer then
			local bf = Players.LocalPlayer.Character.Animator.CurrentAnimation
			while true do
				wait(time)
				if banging then
					Players.LocalPlayer.Character.Animator.CurrentAnimation = "emote_sit"
					Players.LocalPlayer.Position = banging.Position + Vector3.New(0, 5.75, 0)
					Players.LocalPlayer.Rotation = banging.Rotation
				else
					Players.LocalPlayer.Character.Animator.CurrentAnimation = bf
					Players.LocalPlayer.Character.CurrentState = Enums.CharacterModelState.Idle
					break
				end
			end
		end
	end

	local pressed = {}

	Input.KeyDown:Connect(function(k, a)
		if a then
			table.insert(pressed, k)
		end
	end)

	Input.KeyUp:Connect(function(k, a)
		local i = table.find(pressed, k)
		if i then
			table.remove(pressed, i)
		end
	end)

	local flying = false

	local function fly(sped)
		local plr = Players.LocalPlayer
		flying = false
		wait(gettime() + 0.01)
		flying = true
		local sts = plr.Anchored
		local speed = sped and tonumber(sped) or 30
		local gv = Environment.Gravity

		while true do
			wait(gettime())

			if flying then
	            plr.JumpPower = 0
				Players.LocalPlayer.Character.CurrentState = Enums.CharacterModelState.Idle
				Environment.Gravity = Vector3.New(Environment.Gravity.X, 0, Environment.Gravity.Y)
				plr.Anchored = false
				plr.Rotation = Environment.Camera.Rotation + Vector3.New(180, 0, 180)

				local offset = Vector3.New(0, 0, 0)

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.W)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.Z)
				then
					offset = offset + Vector3.New(0, 0, speed / 60)
				end

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.A)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.Q)
				then
					offset = offset + Vector3.New(speed / 60, 0, 0)
				end

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.S)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.S)
				then
					offset = offset + Vector3.New(0, 0, -(speed / 60))
				end

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.D)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.D)
				then
					offset = offset + Vector3.New(-(speed / 60), 0, 0)
				end

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.Space)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.Space)
				then
					offset = offset + Vector3.New(0, speed / 60, 0)
				end

				if
					keybrd == "qwerty" and table.find(pressed, Enums.KeyCode.Shift)
					or keybrd == "azerty" and table.find(pressed, Enums.KeyCode.Shift)
				then
					offset = offset + Vector3.New(0, -(speed / 60), 0)
				end

				plr.Position = plr.Position + plr.Right * offset.X + plr.Up * offset.Y + plr.Forward * offset.Z
			else
				plr.Anchored = sts
				plr.Rotation = Vector3.New(0, 0, 0)
				Environment.Gravity = gv
				Players.LocalPlayer.Character.CurrentState = Enums.CharacterModelState.Idle
				plr.JumpPower = PlayerDefaults.JumpPower
	            break
			end
		end
	end

	local function emote(id)
		Players.LocalPlayer.Character.Animator.CurrentAnimation = id
	end
	local function unemote()
		Players.LocalPlayer.Character.Animator.CurrentAnimation = ""
	end
	local function unfly()
		flying = false
	end

	local function speed(speed)
		local plr = Players.LocalPlayer
		plr.WalkSpeed = speed and tonumber(speed) or PlayerDefaults.WalkSpeed
	end
	local function sprint(speed)
		local plr = Players.LocalPlayer
		plr.SprintSpeed = speed and tonumber(speed) or PlayerDefaults.SprintSpeed
	end
	local function jumppower(power)
		local plr = Players.LocalPlayer
		plr.JumpPower = power and tonumber(power) or PlayerDefaults.JumpPower
	end
	local function anchor()
		local plr = Players.LocalPlayer
		plr.Anchored = true
	end
	local function unanchor()
		local plr = Players.LocalPlayer
		plr.Anchored = false
	end
	local function noclip() end

	local function unnoclip() end
	local grav = Environment.Gravity
	local function gravity(power)
		Environment.Gravity = power and Vector3.New(Environment.Gravity.X, tonumber(power), Environment.Gravity.Y) or grav
	end

	local function resetsim()
		gravity()
		jumppower()
		sprint()
		speed()
	end

	local function unbang()
		banging = nil
	end
	--[[ unsuported concept
	local function rejoin()
	    local worldid = world.WorldID
	    Worlds:JoinWorldAsync(Players.LocalPlayer, worldid)
	end
	]]

	local cmd = {
		["goto"] = {
			["cmds"] = { "goto" },
			["act"] = tp,
			["use"] = "[player]",
			["help"] = "Go to a player.",
			["FE"] = true,
		},
		["fly"] = {
			["cmds"] = { "fly" },
			["act"] = fly,
			["use"] = "[speed]",
			["help"] = "Makes you fly.",
			["FE"] = true,
		},
		["unfly"] = {
			["cmds"] = { "unfly" },
			["act"] = unfly,
			["use"] = "",
			["help"] = "Disables fly.",
			["FE"] = true,
		},
		["bang"] = {
			["cmds"] = { "bang", "b" },
			["act"] = bang,
			["use"] = "[player] [speed]",
			["help"] = "Bangs a player.",
			["FE"] = true,
		},
		["fbang"] = {
			["cmds"] = { "fbang", "fb" },
			["act"] = fbang,
			["use"] = "[player] [speed]",
			["help"] = "Bangs a player face.",
			["FE"] = true,
		},
		["unbang"] = {
			["cmds"] = { "unbang", "unb", },
			["act"] = unbang,
			["use"] = "",
			["help"] = "Stops Banging.",
			["FE"] = true,
		},
		["unfacebang"] = {
			["cmds"] = { "unfacebang", "unfb" },
			["act"] = unbang,
			["use"] = "",
			["help"] = "Stops Banging.",
			["FE"] = true,
		},
		["headsit"] = {
			["cmds"] = { "headsit", "hs" },
			["act"] = headsit,
			["use"] = "[player]",
			["help"] = "Sit on a players head.",
			["FE"] = true,
		},
		["unheadsit"] = {
			["cmds"] = { "unheadsit", "unhs" },
			["act"] = unbang,
			["use"] = "",
			["help"] = "Stops Sitting on a players head.",
			["FE"] = true,
		},
		["reset"] = {
			["cmds"] = { "reset", "kill" },
			["act"] = function()
				Players.LocalPlayer:Kill()
			end,
			["use"] = "",
			["help"] = "Kills LocalPlayer.",
			["FE"] = true,
		},
		["respawn"] = {
			["cmds"] = { "respawn" },
			["act"] = function()
				Players.LocalPlayer:Kill()
			end,
			["use"] = "",
			["help"] = "Respawns LocalPlayer without killing.",
			["FE"] = true,
		},
		["walkspeed"] = {
			["cmds"] = { "walkspeed", "ws" },
			["act"] = speed,
			["use"] = "[speed]",
			["help"] = "Sets the LocalPlayer WalkSpeed.",
			["FE"] = true,
		},
		["runspeed"] = {
			["cmds"] = { "runspeed", "rs", "sprintspeed" },
			["act"] = sprint,
			["use"] = "[speed]",
			["help"] = "Sets the LocalPlayer SprintSpeed.",
			["FE"] = true,
		},
		["anchor"] = {
			["cmds"] = { "anchor" },
			["act"] = anchor,
			["use"] = "",
			["help"] = "Anchors the LocalPlayer.",
			["FE"] = true,
		},
		["unanchor"] = {
			["cmds"] = { "unanchor" },
			["act"] = unanchor,
			["use"] = "",
			["help"] = "UnAnchors the LocalPlayer.",
			["FE"] = true,
		},
		["jumppower"] = {
			["cmds"] = { "jumppower", "jp" },
			["act"] = jumppower,
			["use"] = "[power]",
			["help"] = "Sets the LocalPlayer JumpPower.",
			["FE"] = true,
		},
		["resetsim"] = {
			["cmds"] = {"resetsim", "rs"},
			["act"] = resetsim,
			["use"] = "",
			["help"] = "Resets all simulation artifacts (gravity, walkspeed, sprintspeed, jumppower).",
			["FE"] = true,
		}
		["emote"] = {
			["cmds"] = { "emote", "e" },
			["act"] = emote,
			["use"] = "[emoteid]",
			["help"] = "Makes the LocalPlayer emote with the id.",
			["FE"] = true,
		},
		["unemote"] = {
			["cmds"] = { "unemote", "une" },
			["act"] = unemote,
			["use"] = "",
			["help"] = "Makes the LocalPlayer stop emote.",
			["FE"] = true,
		},
		["gravity"] = {
			["cmds"] = { "gravity", "grav" },
			["act"] = gravity,
			["use"] = "[power]",
			["help"] = "Makes the enviornment the set gravity.",
			["FE"] = true,
		},
		--[[    ["rejoin"] = {
	        ["cmds"] = {"rejoin","rj"},
	        ["act"] = rejoin,
	        ["use"] = "",
	        ["help"] = "Makes the LocalPlayer ReJoin."
	    },]]
	}

	local function help()
		for icmd, vin in pairs(cmd) do
			local cmds = {}

			for i, v in ipairs(vin.cmds) do
				table.insert(cmds, i == 1 and v or " / " .. v)
			end

			local aliases = prefix .. table.concat(cmds, "")
			local usage = vin.use ~= "" and (" " .. vin.use) or ""

			if vin["FE"] then
				print("Command: " .. icmd .. " | Usage: " .. aliases .. usage .. " | Info: " .. vin.help .. "\n")
			else
				warn("Command: " .. icmd .. " | Usage: " .. aliases .. usage .. " | Info: " .. vin.help .. "\n")
			end
		end
		notify("Check the console by pressing F8.")
	end

	cmd["help"] = {
		["cmds"] = { "help" },
		["act"] = help,
		["use"] = "",
		["help"] = "Gives you info about the commads.",
	}
		
	local function go(msg)
		if msg:sub(1, #prefix) == prefix then
			local things = {}
			local first = false
			for word in msg:gmatch("%w+") do
				if not first then
					first = word:sub(#prefix):lower()
				else
					table.insert(things, word)
				end
			end
			for i, v in pairs(cmd) do
				if table.find(v["cmds"], first) then
					v["act"](table.unpack(things))
					return
				end
			end
			notify(first .. " is not a command")
		end
	end
	function runcmd(command)
		local things = {}
			local first = false
			for word in command:gmatch("%w+") do
				if not first then
					first = word:sub(#prefix):lower()
				else
					table.insert(things, word)
				end
			end
			for i, v in pairs(cmd) do
				if table.find(v["cmds"], first) then
					v["act"](table.unpack(things))
					return
				end
			end
	end
		
	Players.LocalPlayer.Chatted:Connect(go)
	
	local gui = Instance.New("GUI",PlayerGUI)
	gui.Name = "PolyYield"
	
	local holder = Instance.New("UIView",gui)
	holder.Color = Color.FromRGB(46, 46, 47)
	holder.PivotPoint = Vector2.New(0,0)
	holder.PositionRelative = Vector2.New(1,1)
	holder.PositionOffset = Vector2.New(-250,-220)
	holder.SizeOffset = Vector2.New(250,220)
	Instance.New("UIAspectRatioRestraint",holder)
	
	local title = Instance.New("UILabel", holder)
	title.PivotPoint = Vector2.New(0,0)
	title.Color = Color.FromRGB(36, 36, 37)
	title.PositionRelative = Vector2.New(0,0)
	title.SizeOffset = Vector2.New(250,20)
	title.FontSize = 18/2
	title.FontAsset = BuiltInFontAsset.New()
	title.FontAsset.FontPreset = Enums.FontPreset.SourceSans
	title.Text = "PolyYield FE v"..version
	do
		local emoji = ({
			["01 01"] = "🎆",
			["02 14"] = "💝",
			["03 17"] = "☘️",
			[(function(Year)
				local A = math.floor(Year/100)
				local B = math.floor((13+8*A)/25)
				local C = (15-B+A-math.floor(A/4))%30
				local D = (4+A-math.floor(A/4))%7
				local E = (19*(Year%19)+C)%30
				local F = (2*(Year%4)+4*(Year%7)+6*E+D)%7
				local G = (22+E+F)
				if E == 29 and F == 6 then
					return "04 19"
				elseif E == 28 and F == 6 then
					return "04 18"
				elseif 31 < G then
					return ("04 %02d"):format(G-31)
				end
				return ("03 %02d"):format(G)
			end)(tonumber(os.date"%Y"))] = "🥚",
			["10 31"] = "🎃",
			["12 25"] = "🎄"
		})[os.date("%m %d")]
		if emoji then
			title.Text = ("%s %s %s"):format(emoji, title.Text, emoji)
		end
	end
	title.TextColor = Color.New(1,1,1)
	
	local dark = Instance.New("UIView",holder)
	dark.Color = Color.FromRGB(36, 36, 37)
	dark.PivotPoint = Vector2.New(0,0)
	dark.PositionRelative = Vector2.New(0,0)
	dark.PositionOffset = Vector2.New(0,45)
	dark.SizeOffset = Vector2.New(250,175)
	
	local cmdBar = Instance.New("UITextInput", holder)
	cmdBar.Name = "Cmdbar"
	cmdBar.Color = Color.New(0,0,0,0)
	cmdBar.PivotPoint = Vector2.New(0,0)
	cmdBar.PositionRelative = Vector2.New(0,0)
	cmdBar.PositionOffset = Vector2.New(5,20)
	cmdBar.SizeOffset = Vector2.New(240,25)
	cmdBar.FontSize = 18/2
	cmdBar.FontAsset = BuiltInFontAsset.New()
	cmdBar.FontAsset.FontPreset = Enums.FontPreset.SourceSans
	cmdBar.TextColor = Color.New(1,1,1)
	cmdBar.Text = ""
	cmdBar.Placeholder = "Command Bar ("..prefix..")"
	cmdBar.PlaceholderColor = Color.FromRGB(170,170,170)
	cmdBar.Submitted:Connect(function(text)
		if text:sub(1, #prefix) == prefix then
			go(text)
		else
			go(prefix .. text)
		end
		cmdBar.Text = ""
	end)
	
	local cmdList = Instance.New("UIScrollView", holder)
	local cmdLLayout = Instance.New("UIVLayout", cmdList)
	cmdLLayout.SizeOffset = Vector2.New(190,0)
	cmdLLayout.SizeRelative = Vector2.New(0,1)
	cmdList.PivotPoint = Vector2.New(0,0)
	cmdList.PositionRelative = Vector2.New(0,0)
	cmdList.PositionOffset = Vector2.New(5,45)
	cmdList.SizeOffset = Vector2.New(245,175)
	cmdList.HorizontalScrollMode = Enums.UIScrollMode.Disabled
	cmdList.VerticalScrollMode = Enums.UIScrollMode.AlwaysShow
	cmdLLayout.Spacing = 0
	
	local function makecmdd(commands, usage, hint, plugin)
		local cmds = {}
			for i, v in ipairs(commands) do
				table.insert(cmds, i == 1 and v or " / " .. v)
			end
		local aliases = table.concat(cmds, "")
		local cmdd = Instance.New("UILabel",cmdLLayout)
		cmdd.PivotPoint = Vector2.New(0,0)
		cmdd.PositionRelative = Vector2.New(0,0)
		cmdd.SizeOffset = Vector2.New(190,20)
		cmdd.FontSize = 18/2
		cmdd.FontAsset = BuiltInFontAsset.New()
		cmdd.FontAsset.FontPreset = Enums.FontPreset.SourceSans
		cmdd.Text = (plugin and "[PLUGIN] " or "") .. aliases .." " .. usage
		cmdd.HorizontalAlignment = Enums.HorizontalAlignment.Left
		cmdd.VerticalAlignment = Enums.VerticalAlignment.Middle
		cmdd.Color = Color.New(0,0,0,0)
		cmdd.TextColor = Color.New(1,1,1)
		cmdd.Name = aliases
	end
	for name, data in pairs(cmd) do
		makecmdd(data["cmds"],data["use"],data["hint"],false)
	end
	
	function addcommand(commands, usage, hint, func)
		cmd[commands[1]] = {
			["cmds"] = commands,
			["act"] = func,
			["use"] = usage,
			["hint"] = hint
		}
		makecmdd(commands,usage,hint,true)
		cmd["help"] = {
			["cmds"] = { "help" },
			["act"] = help,
			["use"] = "",
			["help"] = "Gives you info about the commads.",
		}
	end
	
	cmdBar.Changed:Connect(function(text)
		local text = cmdBar.Text
		for i, v in ipairs(cmdLLayout:GetChildren()) do
			if v.Name:lower():find(text:lower()) or text:lower():find(v.Name:lower()) then
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end)
	
	notify("PolyYield Loaded " .. prefix .. "help for a list of commands")
	return {
		addCommand = addcommand, -- parameters (commands, usage, hint, func) -commands. what the function gets actiavted with - usage. hint of inputs - hint. what the function does - function just the function
		runCommand = runcmd, -- parameters (command) -command. just the normal run command without prefix.
	}
end
