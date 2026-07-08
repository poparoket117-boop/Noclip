-- Drunix Hub (Red Theme) :: NoClip + InfJump + God Mode
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local noclip = false
local infJump = false
local god = false
local walkSpeed = 16
local menuOpen = false

-- GOD MODE
local function SetGod(state)
    god = state
    if state then
        hum.MaxHealth = 9e9
        hum.Health = 9e9
        hum.BreakJointsOnDeath = false
    else
        hum.MaxHealth = 100
        hum.Health = 100
        hum.BreakJointsOnDeath = true
    end
end

-- INFINITE JUMP
local jumpCon
local function SetInfJump(state)
    infJump = state
    if state then
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end
end

local function startInfJump()
    if jumpCon then jumpCon:Disconnect() end
    jumpCon = hum.StateChanged:Connect(function(old, new)
        if infJump and (new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Freefall) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function SetNoClip(state)
    noclip = state
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if noclip then SetNoClip(true) end
    if infJump then SetInfJump(true) startInfJump() end
    if god then SetGod(true) end
    hum.WalkSpeed = walkSpeed
end)

-- Loops
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
    if god and hum then
        hum.Health = 9e9
        hum.MaxHealth = 9e9
        hum.BreakJointsOnDeath = false
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if infJump and hum then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DrunixHub"
gui.ResetOnSpawn = false

-- КНОПКА INFINITE JUMP (отдельная, перетаскиваемая)
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 80, 0, 80)
jumpBtn.Position = UDim2.new(0.85, -40, 0.5, -40)
jumpBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
jumpBtn.BackgroundTransparency = 0
jumpBtn.BorderSizePixel = 3
jumpBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
jumpBtn.Text = "Jump"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextSize = 18
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.Draggable = true
jumpBtn.Active = true
local cornerJump = Instance.new("UICorner", jumpBtn)
cornerJump.CornerRadius = UDim.new(1, 0)

-- Текст статуса на кнопке
local statusText = Instance.new("TextLabel", jumpBtn)
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 0.7, 0)
statusText.Text = "OFF"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.TextSize = 14
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.GothamBold

jumpBtn.MouseButton1Click:Connect(function()
    SetInfJump(not infJump)
    if infJump then startInfJump() end
    jumpBtn.Text = infJump and "Jump ON" or "Jump"
    statusText.Text = infJump and "ON" or "OFF"
    statusText.TextColor3 = infJump and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    jumpBtn.BorderColor3 = infJump and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
end)

-- КНОПКА ОТКРЫТИЯ МЕНЮ (по центру)
local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0.5, -35, 0.5, -35)
openBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
openBtn.BackgroundTransparency = 0
openBtn.BorderSizePixel = 3
openBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
openBtn.Image = "rbxassetid://6023420470"
openBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Draggable = true
openBtn.Active = true
local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = UDim.new(1, 0)

-- МЕНЮ
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 380)
menu.Position = UDim2.new(0.5, -160, 0.5, -190)
menu.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
menu.BackgroundTransparency = 0
menu.BorderSizePixel = 3
menu.BorderColor3 = Color3.fromRGB(255, 50, 50)
menu.Visible = false
menu.Active = true
menu.Draggable = true

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Drunix Hub"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextSize = 26
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.BackgroundTransparency = 0
title.Font = Enum.Font.GothamBold

local close = Instance.new("TextButton", menu)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 3)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.BorderSizePixel = 1
close.BorderColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function()
    menuOpen = false
    menu.Visible = false
end)

local ncBtn = Instance.new("TextButton", menu)
ncBtn.Size = UDim2.new(0.8, 0, 0, 32)
ncBtn.Position = UDim2.new(0.1, 0, 0.16, 0)
ncBtn.Text = "NoClip: OFF"
ncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ncBtn.TextSize = 15
ncBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
ncBtn.BorderSizePixel = 2
ncBtn.BorderColor3 = Color3.fromRGB(150, 50, 50)
ncBtn.MouseButton1Click:Connect(function()
    SetNoClip(not noclip)
    ncBtn.Text = noclip and "NoClip: ON" or "NoClip: OFF"
    ncBtn.TextColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    ncBtn.BorderColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 50, 50)
end)

local godBtn = Instance.new("TextButton", menu)
godBtn.Size = UDim2.new(0.8, 0, 0, 32)
godBtn.Position = UDim2.new(0.1, 0, 0.36, 0)
godBtn.Text = "God Mode: OFF"
godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godBtn.TextSize = 15
godBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
godBtn.BorderSizePixel = 2
godBtn.BorderColor3 = Color3.fromRGB(150, 50, 50)
godBtn.MouseButton1Click:Connect(function()
    SetGod(not god)
    godBtn.Text = god and "God Mode: ON" or "God Mode: OFF"
    godBtn.TextColor3 = god and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    godBtn.BorderColor3 = god and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 50, 50)
end)

local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
speedLabel.Text = "Walk Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
speedLabel.TextSize = 14
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham

local sliderWalk = Instance.new("Frame", menu)
sliderWalk.Size = UDim2.new(0.8, 0, 0, 10)
sliderWalk.Position = UDim2.new(0.1, 0, 0.59, 0)
sliderWalk.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
sliderWalk.BorderSizePixel = 0

local fillWalk = Instance.new("Frame", sliderWalk)
fillWalk.Size = UDim2.new(0.16, 0, 1, 0)
fillWalk.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
fillWalk.BorderSizePixel = 0

local sliderWalkBtn = Instance.new("TextButton", sliderWalk)
sliderWalkBtn.Size = UDim2.new(0, 22, 0, 22)
sliderWalkBtn.Position = UDim2.new(0.16, -11, 0.5, -11)
sliderWalkBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderWalkBtn.BorderSizePixel = 2
sliderWalkBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
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

SetupSlider(sliderWalk, fillWalk, sliderWalkBtn, speedLabel, 1, 500, function(v)
    walkSpeed = v
    if hum then hum.WalkSpeed = v end
end)

local both = Instance.new("TextButton", menu)
both.Size = UDim2.new(0.8, 0, 0, 32)
both.Position = UDim2.new(0.1, 0, 0.76, 0)
both.Text = "Enable All"
both.TextColor3 = Color3.fromRGB(255, 255, 255)
both.TextSize = 15
both.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
both.BorderSizePixel = 2
both.BorderColor3 = Color3.fromRGB(255, 50, 50)
both.MouseButton1Click:Connect(function()
    SetNoClip(true)
    SetInfJump(true)
    startInfJump()
    SetGod(true)
    ncBtn.Text = "NoClip: ON"
    ncBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    ncBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    godBtn.Text = "God Mode: ON"
    godBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    godBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    jumpBtn.Text = "Jump ON"
    statusText.Text = "ON"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    jumpBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
end)

openBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)

-- Родитель
openBtn.Parent = gui
menu.Parent = gui
jumpBtn.Parent = gui
gui.Parent = game:GetService("CoreGui")
