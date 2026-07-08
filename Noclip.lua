local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local noclip = false
local fly = false
local god = false
local flySpeed = 50
local walkSpeed = 16
local menuOpen = false

local bodyVelocity = nil
local bodyGyro = nil

local function SetNoClip(state)
    noclip = state
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

local function SetFly(state)
    fly = state
    if state then
        hum.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 1e5
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
    else
        hum.PlatformStand = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = nil
        bodyGyro = nil
    end
end

local function SetGod(state)
    god = state
    if state then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
    else
        hum.MaxHealth = 100
        hum.Health = 100
        hum.BreakJointsOnDeath = true
    end
end

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:FindFirstChild("Humanoid")
    root = char:FindFirstChild("HumanoidRootPart")
    if noclip then SetNoClip(true) end
    if fly then SetFly(true) end
    if god then SetGod(true) end
    hum.WalkSpeed = walkSpeed
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide ~= false then
                v.CanCollide = false
            end
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if fly and root and bodyVelocity and bodyGyro then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local forward = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector

        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + forward end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - forward end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - right end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + right end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + up end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - up end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end
        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- God Mode loop
game:GetService("RunService").Heartbeat:Connect(function()
    if god and hum then
        hum.Health = hum.MaxHealth
        if hum.MaxHealth ~= math.huge then
            hum.MaxHealth = math.huge
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "SWILL"
gui.ResetOnSpawn = false

local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0.5, -35, 0.5, -35)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.BackgroundTransparency = 0
openBtn.BorderSizePixel = 3
openBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)
openBtn.Image = "rbxassetid://6023420470"
openBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Draggable = true
openBtn.Active = true
local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 340, 0, 480)
menu.Position = UDim2.new(0.5, -170, 0.5, -240)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
menu.BackgroundTransparency = 0
menu.BorderSizePixel = 3
menu.BorderColor3 = Color3.fromRGB(0, 200, 255)
menu.Visible = false
menu.Active = true
menu.Draggable = true

local bg = Instance.new("ImageLabel", menu)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://6031090944"
bg.ImageColor3 = Color3.fromRGB(50, 50, 70)
bg.ImageTransparency = 0.4

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "SWILL HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 24
title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
title.BackgroundTransparency = 0
title.Font = Enum.Font.GothamBold

local close = Instance.new("TextButton", menu)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 3)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 50, 50)
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
close.BorderSizePixel = 1
close.BorderColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function()
    menuOpen = false
    menu.Visible = false
end)

local ncBtn = Instance.new("TextButton", menu)
ncBtn.Size = UDim2.new(0.8, 0, 0, 28)
ncBtn.Position = UDim2.new(0.1, 0, 0.12, 0)
ncBtn.Text = "NoClip: OFF"
ncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ncBtn.TextSize = 14
ncBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
ncBtn.BorderSizePixel = 2
ncBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
ncBtn.MouseButton1Click:Connect(function()
    SetNoClip(not noclip)
    ncBtn.Text = noclip and "NoClip: ON" or "NoClip: OFF"
    ncBtn.TextColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    ncBtn.BorderColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

local flyBtn = Instance.new("TextButton", menu)
flyBtn.Size = UDim2.new(0.8, 0, 0, 28)
flyBtn.Position = UDim2.new(0.1, 0, 0.24, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 14
flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
flyBtn.BorderSizePixel = 2
flyBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
flyBtn.MouseButton1Click:Connect(function()
    SetFly(not fly)
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    flyBtn.TextColor3 = fly and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    flyBtn.BorderColor3 = fly and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

local godBtn = Instance.new("TextButton", menu)
godBtn.Size = UDim2.new(0.8, 0, 0, 28)
godBtn.Position = UDim2.new(0.1, 0, 0.36, 0)
godBtn.Text = "God Mode: OFF"
godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godBtn.TextSize = 14
godBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
godBtn.BorderSizePixel = 2
godBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
godBtn.MouseButton1Click:Connect(function()
    SetGod(not god)
    godBtn.Text = god and "God Mode: ON" or "God Mode: OFF"
    godBtn.TextColor3 = god and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    godBtn.BorderColor3 = god and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

local speedFlyLabel = Instance.new("TextLabel", menu)
speedFlyLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedFlyLabel.Position = UDim2.new(0.1, 0, 0.48, 0)
speedFlyLabel.Text = "Fly Speed: 50"
speedFlyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedFlyLabel.TextSize = 13
speedFlyLabel.BackgroundTransparency = 1
speedFlyLabel.Font = Enum.Font.Gotham

local sliderFly = Instance.new("Frame", menu)
sliderFly.Size = UDim2.new(0.8, 0, 0, 10)
sliderFly.Position = UDim2.new(0.1, 0, 0.54, 0)
sliderFly.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sliderFly.BorderSizePixel = 0

local fillFly = Instance.new("Frame", sliderFly)
fillFly.Size = UDim2.new(0.5, 0, 1, 0)
fillFly.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
fillFly.BorderSizePixel = 0

local sliderFlyBtn = Instance.new("TextButton", sliderFly)
sliderFlyBtn.Size = UDim2.new(0, 22, 0, 22)
sliderFlyBtn.Position = UDim2.new(0.5, -11, 0.5, -11)
sliderFlyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderFlyBtn.BorderSizePixel = 2
sliderFlyBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
sliderFlyBtn.Text = ""
local cornerFly = Instance.new("UICorner", sliderFlyBtn)
cornerFly.CornerRadius = UDim.new(1, 0)

local speedWalkLabel = Instance.new("TextLabel", menu)
speedWalkLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedWalkLabel.Position = UDim2.new(0.1, 0, 0.64, 0)
speedWalkLabel.Text = "Walk Speed: 16"
speedWalkLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedWalkLabel.TextSize = 13
speedWalkLabel.BackgroundTransparency = 1
speedWalkLabel.Font = Enum.Font.Gotham

local sliderWalk = Instance.new("Frame", menu)
sliderWalk.Size = UDim2.new(0.8, 0, 0, 10)
sliderWalk.Position = UDim2.new(0.1, 0, 0.70, 0)
sliderWalk.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sliderWalk.BorderSizePixel = 0

local fillWalk = Instance.new("Frame", sliderWalk)
fillWalk.Size = UDim2.new(0.16, 0, 1, 0)
fillWalk.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
fillWalk.BorderSizePixel = 0

local sliderWalkBtn = Instance.new("TextButton", sliderWalk)
sliderWalkBtn.Size = UDim2.new(0, 22, 0, 22)
sliderWalkBtn.Position = UDim2.new(0.16, -11, 0.5, -11)
sliderWalkBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderWalkBtn.BorderSizePixel = 2
sliderWalkBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
sliderWalkBtn.Text = ""
local cornerWalk = Instance.new("UICorner", sliderWalkBtn)
cornerWalk.CornerRadius = UDim.new(1, 0)

local function SetupSlider(slider, fill, btn, label, minVal, maxVal, callback)
    local dragging = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local x = input.Position.X
            local absX = slider.AbsolutePosition.X
            local sizeX = slider.AbsoluteSize.X
            if sizeX > 0 then
                local pos = math.clamp((x - absX) / sizeX, 0, 1)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                btn.Position = UDim2.new(pos, -11, 0.5, -11)
                local value = math.round(minVal + pos * (maxVal - minVal))
                label.Text = label.Text:gsub("%d+$", "") .. value
                callback(value)
            end
        end
    end)
end

SetupSlider(sliderFly, fillFly, sliderFlyBtn, speedFlyLabel, 10, 200, function(v)
    flySpeed = v
end)

SetupSlider(sliderWalk, fillWalk, sliderWalkBtn, speedWalkLabel, 1, 500, function(v)
    walkSpeed = v
    if hum then hum.WalkSpeed = v end
end)

local both = Instance.new("TextButton", menu)
both.Size = UDim2.new(0.8, 0, 0, 28)
both.Position = UDim2.new(0.1, 0, 0.84, 0)
both.Text = "Enable All"
both.TextColor3 = Color3.fromRGB(255, 255, 255)
both.TextSize = 14
both.BackgroundColor3 = Color3.fromRGB(0, 90, 0)
both.BorderSizePixel = 2
both.BorderColor3 = Color3.fromRGB(0, 255, 0)
both.MouseButton1Click:Connect(function()
    SetNoClip(true)
    SetFly(true)
    SetGod(true)
    ncBtn.Text = "NoClip: ON"
    ncBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    ncBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    flyBtn.Text = "Fly: ON"
    flyBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    flyBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    godBtn.Text = "God Mode: ON"
    godBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    godBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
end)

openBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)

openBtn.Parent = gui
menu.Parent = gui
gui.Parent = game:GetService("CoreGui")
