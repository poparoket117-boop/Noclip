local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local nc = false
local ij = false

local function NC(s)
    nc = s
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = not s end
    end
end

local function IJ(s)
    ij = s
    if s then
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end
end

local c
local function startIJ()
    if c then c:Disconnect() end
    c = hum.StateChanged:Connect(function(o,n)
        if ij and (n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Freefall) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

plr.CharacterAdded:Connect(function(new)
    char = new
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if nc then NC(true) end
    if ij then startIJ() end
end)

game:GetService("UserInputService").InputBegan:Connect(function(i,p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.X then NC(not nc) end
    if i.KeyCode == Enum.KeyCode.C then IJ(not ij) if ij then startIJ() end end
end)
