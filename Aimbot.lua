local npc = script.Parent
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local head = npc:FindFirstChild("Head")
local shootInterval = 1
local range = 100
local aimbotEnabled = false

local remoteEvent = game.ReplicatedStorage:FindFirstChild("AimbotToggleEvent")
if not remoteEvent then
    remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "AimbotToggleEvent"
    remoteEvent.Parent = game.ReplicatedStorage
end

local function getClosestPlayer()
    local players = game.Players:GetPlayers()
    local closestPlayer, closestDistance = nil, range

    for _, player in ipairs(players) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local distance = (char.HumanoidRootPart.Position - head.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = char
            end
        end
    end
    return closestPlayer
end

local function aimAndShoot()
    while true do
        if aimbotEnabled then
            local target = getClosestPlayer()
            if target then
                head.CFrame = CFrame.lookAt(head.Position, target.HumanoidRootPart.Position)

                local bullet = Instance.new("Part")
                bullet.Size = Vector3.new(0.3, 0.3, 0.3)
                bullet.Shape = Enum.PartType.Ball
                bullet.Material = Enum.Material.Neon
                bullet.BrickColor = BrickColor.new("Bright red")
                bullet.Position = head.Position
                bullet.Velocity = (target.HumanoidRootPart.Position - head.Position).unit * 50
                bullet.Parent = game.Workspace
                game:GetService("Debris"):AddItem(bullet, 3)
            end
        end
        wait(shootInterval)
    end
end

local function toggleAimbot(player, state)
    aimbotEnabled = state
    print("Aimbot " .. (state and "ENABLED" or "DISABLED") .. " by " .. player.Name)
end

remoteEvent.OnServerEvent:Connect(toggleAimbot)
task.spawn(aimAndShoot)
