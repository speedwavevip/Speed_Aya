local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local bangAnim = nil
local bang = nil
local bangDied = nil
local bangLoop = nil
local isBangOn = false

local bangSpeed = 3
local targetName = ""

local function isR15(player)
	if not player or not player.Character then
		return false
	end
	local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid and humanoid.RigType then
		return humanoid.RigType == Enum.HumanoidRigType.R15
	end
	return false
end

local function getPlayerByName(name)
	if not name or name == "" then
		return nil
	end
	name = tostring(name):lower()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower() == name or (plr.DisplayName and plr.DisplayName:lower() == name) then
			return plr
		end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():find(name, 1, true) or (plr.DisplayName and plr.DisplayName:lower():find(name, 1, true)) then
			return plr
		end
	end
	return nil
end

local function getRoot(character)
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
		or character:FindFirstChild("Torso")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("LowerTorso")
end

local function startBang()
	if isBangOn then
		return
	end

	local speaker = LocalPlayer
	if not speaker or not speaker.Character then
		return
	end

	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	bangAnim = Instance.new("Animation")
	if isR15(speaker) then
		bangAnim.AnimationId = "rbxassetid://5918726674"
	else
		bangAnim.AnimationId = "rbxassetid://148840371"
	end

	bang = humanoid:LoadAnimation(bangAnim)
	bang:Play(0.1, 1, 1)

	local speedNum = tonumber(bangSpeed) or 3
	bang:AdjustSpeed(speedNum)

	if bangDied then
		pcall(function()
			bangDied:Disconnect()
		end)
		bangDied = nil
	end

	if bangLoop then
		pcall(function()
			bangLoop:Disconnect()
		end)
		bangLoop = nil
	end

	bangDied = humanoid.Died:Connect(function()
		pcall(function()
			if bang then
				bang:Stop()
			end
			if bangAnim then
				bangAnim:Destroy()
			end
			if bangLoop then
				bangLoop:Disconnect()
			end
		end)
		bang = nil
		bangAnim = nil
		bangLoop = nil
		isBangOn = false
		if bangDied then
			pcall(function()
				bangDied:Disconnect()
			end)
			bangDied = nil
		end
	end)

	if targetName and targetName ~= "" then
		local targetPlayer = getPlayerByName(targetName)
		if targetPlayer and targetPlayer.Character then
			local offset = CFrame.new(0, 0, 1.1)
			bangLoop = RunService.Stepped:Connect(function()
				pcall(function()
					local otherRoot = getRoot(targetPlayer.Character)
					local myRoot = getRoot(speaker.Character)
					if otherRoot and myRoot then
						myRoot.CFrame = otherRoot.CFrame * offset
					end
				end)
			end)
		end
	end

	isBangOn = true
end

local function stopBang()
	if bangDied then
		pcall(function()
			bangDied:Disconnect()
		end)
		bangDied = nil
	end

	if bangLoop then
		pcall(function()
			bangLoop:Disconnect()
		end)
		bangLoop = nil
	end

	if bang then
		pcall(function()
			bang:Stop()
		end)
		bang = nil
	end

	if bangAnim then
		pcall(function()
			bangAnim:Destroy()
		end)
		bangAnim = nil
	end

	isBangOn = false
end

local LMG2L = {}

LMG2L["ScreenGui_1"] = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
LMG2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

LMG2L["ImageButton_2"] = Instance.new("ImageButton", LMG2L["ScreenGui_1"])
LMG2L["ImageButton_2"].BorderSizePixel = 0
LMG2L["ImageButton_2"].ImageTransparency = 0.5
LMG2L["ImageButton_2"].BackgroundTransparency = 0.5
LMG2L["ImageButton_2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LMG2L["ImageButton_2"].Size = UDim2.new(0, 264, 0, 178)
LMG2L["ImageButton_2"].Position = UDim2.new(0, 226, 0, 46)

LMG2L["UICorner_3"] = Instance.new("UICorner", LMG2L["ImageButton_2"])

LMG2L["TextButton_4"] = Instance.new("TextButton", LMG2L["ImageButton_2"])
LMG2L["TextButton_4"].BorderSizePixel = 0
LMG2L["TextButton_4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LMG2L["TextButton_4"].Size = UDim2.new(0, 54, 0, 40)
LMG2L["TextButton_4"].Position = UDim2.new(0, 122, 0, 108)
LMG2L["TextButton_4"].Text = "Bang"

LMG2L["UICorner_5"] = Instance.new("UICorner", LMG2L["TextButton_4"])

LMG2L["TextBox_6"] = Instance.new("TextBox", LMG2L["ImageButton_2"])
LMG2L["TextBox_6"].BorderSizePixel = 0
LMG2L["TextBox_6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LMG2L["TextBox_6"].Size = UDim2.new(0, 128, 0, 70)
LMG2L["TextBox_6"].Position = UDim2.new(0, 80, 0, 22)
LMG2L["TextBox_6"].Text = ""

LMG2L["TextBox_6"].FocusLost:Connect(function()
	targetName = tostring(LMG2L["TextBox_6"].Text or "")
	if isBangOn then
		stopBang()
		startBang()
	end
end)

LMG2L["TextButton_4"].MouseButton1Click:Connect(function()
	if isBangOn then
		stopBang()
	else
		startBang()
	end
end)

return LMG2L["ScreenGui_1"], require
