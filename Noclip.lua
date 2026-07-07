local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local nc = false
local ij = false
local menuOpen = false

local function NC(s)
    nc = s
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not s
        end
    end
end

local function IJ(s)
    ij = s
    if s then
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end
end

local jumpCon
local function startIJ()
    if jumpCon then jumpCon:Disconnect() end
    jumpCon = hum.StateChanged:Connect(function(old, new)
        if ij and (new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Freefall) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if nc then NC(true) end
    if ij then startIJ() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SWILL_Menu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "SWILL HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 22
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
    menuOpen = false
    mainFrame.Visible = false
end)

local ncBtn = Instance.new("TextButton", mainFrame)
ncBtn.Size = UDim2.new(0.8, 0, 0, 35)
ncBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ncBtn.Text = "NoClip: OFF"
ncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ncBtn.TextSize = 16
ncBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ncBtn.BorderSizePixel = 0
ncBtn.MouseButton1Click:Connect(function()
    NC(not nc)
    ncBtn.Text = nc and "NoClip: ON" or "NoClip: OFF"
    ncBtn.TextColor3 = nc and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local ijBtn = Instance.new("TextButton", mainFrame)
ijBtn.Size = UDim2.new(0.8, 0, 0, 35)
ijBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ijBtn.Text = "InfJump: OFF"
ijBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ijBtn.TextSize = 16
ijBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ijBtn.BorderSizePixel = 0
ijBtn.MouseButton1Click:Connect(function()
    IJ(not ij)
    if ij then startIJ() end
    ijBtn.Text = ij and "InfJump: ON" or "InfJump: OFF"
    ijBtn.TextColor3 = ij and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local bothBtn = Instance.new("TextButton", mainFrame)
bothBtn.Size = UDim2.new(0.8, 0, 0, 35)
bothBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
bothBtn.Text = "Enable All"
bothBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bothBtn.TextSize = 16
bothBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
bothBtn.BorderSizePixel = 0
bothBtn.MouseButton1Click:Connect(function()
    NC(true)
    IJ(true)
    startIJ()
    ncBtn.Text = "NoClip: ON"
    ncBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    ijBtn.Text = "InfJump: ON"
    ijBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

screenGui.Parent = plr:WaitForChild("PlayerGui")
mainFrame.Parent = screenGui

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end
end)
