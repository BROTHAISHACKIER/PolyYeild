--made by h4kcer
local keybrd = "qwerty" --qwerty or azerty
local prefix = ";"
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
	["teleport"] = {
		["cmds"] = { "teleport", "tp" },
		["act"] = tp,
		["use"] = "<*player>",
		["help"] = "Teleports you to the player.",
		["FE"] = true,
	},
	["fly"] = {
		["cmds"] = { "fly" },
		["act"] = fly,
		["use"] = "<speed>",
		["help"] = "Makes you fly.",
		["FE"] = true,
	},
	["unfly"] = {
		["cmds"] = { "unfly" },
		["act"] = unfly,
		["use"] = "",
		["help"] = "Stops the flying.",
		["FE"] = true,
	},
	["bang"] = {
		["cmds"] = { "bang", "b" },
		["act"] = bang,
		["use"] = "<*player> <speed>",
		["help"] = "Bangs the player.",
		["FE"] = true,
	},
	["fbang"] = {
		["cmds"] = { "fbang", "fb" },
		["act"] = fbang,
		["use"] = "<*player> <speed>",
		["help"] = "Bangs the player face.",
		["FE"] = true,
	},
	["unbang"] = {
		["cmds"] = { "unbang", "unb", "unfacebang", "unfb" },
		["act"] = unbang,
		["use"] = "",
		["help"] = "Stops Banging.",
		["FE"] = true,
	},
	["headsit"] = {
		["cmds"] = { "headsit", "hs" },
		["act"] = headsit,
		["use"] = "<*player>",
		["help"] = "Sits on the player head.",
		["FE"] = true,
	},
	["unheadsit"] = {
		["cmds"] = { "unheadsit", "unhs" },
		["act"] = unbang,
		["use"] = "",
		["help"] = "Stops Sitting on a head.",
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
		["use"] = "<speed!reset>",
		["help"] = "Sets the LocalPlayer WalkSpeed.",
		["FE"] = true,
	},
	["runspeed"] = {
		["cmds"] = { "runspeed", "rs", "sprintspeed" },
		["act"] = sprint,
		["use"] = "<speed!reset>",
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
		["use"] = "<power!reset>",
		["help"] = "Sets the LocalPlayer JumpPower.",
		["FE"] = true,
	},
	["emote"] = {
		["cmds"] = { "emote", "e" },
		["act"] = emote,
		["use"] = "<*emoteid>",
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
		["cmds"] = { "gravity", "grv" },
		["act"] = gravity,
		["use"] = "<power!reset>",
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
			table.insert(cmds, i == 1 and v or "/" .. v)
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

cmd["help"] =
	{
		["cmds"] = { "help" },
		["act"] = help,
		["use"] = "",
		["help"] = "Gives you info about the commads.",
	}, Players.LocalPlayer.Chatted:Connect(function(msg)
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
	end)
notify("PolyYeild Loaded " .. prefix .. "help for a list of commands")
