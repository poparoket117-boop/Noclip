local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local noclip = false
local fly = false
local menuOpen = false

local function SetNoClip(state)
    noclip = state
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

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

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:FindFirstChild("Humanoid")
    root = char:FindFirstChild("HumanoidRootPart")
    if noclip then SetNoClip(true) end
    if fly then SetFly(true) end
end)

-- NoClip loop
game:GetService("RunService").Heartbeat:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide ~= false then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly loop
game:GetService("RunService").Heartbeat:Connect(function()
    if fly and root and bodyVelocity and bodyGyro then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local forward = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + forward
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - forward
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - right
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + right
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + up
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - up
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end
        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- GUI
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
menu.Size = UDim2.new(0, 300, 0, 280)
menu.Position = UDim2.new(0.5, -150, 0.5, -140)
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
ncBtn.Size = UDim2.new(0.8, 0, 0, 38)
ncBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ncBtn.Text = "NoClip: OFF"
ncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ncBtn.TextSize = 17
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
flyBtn.Size = UDim2.new(0.8, 0, 0, 38)
flyBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 17
flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
flyBtn.BorderSizePixel = 2
flyBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
flyBtn.MouseButton1Click:Connect(function()
    SetFly(not fly)
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    flyBtn.TextColor3 = fly and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    flyBtn.BorderColor3 = fly and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

local both = Instance.new("TextButton", menu)
both.Size = UDim2.new(0.8, 0, 0, 38)
both.Position = UDim2.new(0.1, 0, 0.7, 0)
both.Text = "Enable All"
both.TextColor3 = Color3.fromRGB(255, 255, 255)
both.TextSize = 17
both.BackgroundColor3 = Color3.fromRGB(0, 90, 0)
both.BorderSizePixel = 2
both.BorderColor3 = Color3.fromRGB(0, 255, 0)
both.MouseButton1Click:Connect(function()
    SetNoClip(true)
    SetFly(true)
    ncBtn.Text = "NoClip: ON"
    ncBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    ncBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    flyBtn.Text = "Fly: ON"
    flyBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    flyBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
end)

openBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)

openBtn.Parent = gui
menu.Parent = gui
gui.Parent = game:GetService("CoreGui")
