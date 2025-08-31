local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Syndromehsh/Lua/refs/heads/main/AlienX/AlienX%20Wind%203.0%20UI.txt"))()

WindUI:Notify({
    Title = "AlienX",
    Content = "被遗弃",
    Duration = 4
})

local player = game.Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "AlienX<font color='#00FF00'>2.0</font> / 被遗弃",
    Icon = "rbxassetid://4483362748",
    IconTransparency = 0.5,
    Author = "AlienX",
    Folder = "AlienX",
    Size = UDim2.fromOffset(100, 150),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 145,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        Thumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家: " .. player.Name .. " (" .. player.DisplayName .. ")",
                Duration = 3
            })
        end
    }
})

Window:EditOpenButton({
    Title = "AlienX",
    Icon = "monitor",
    CornerRadius = UDim.new(1,10),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
    }),
    Draggable = true,
})

local Tabs = {
    Main = Window:Section({ Title = "主要功能", Opened = true })
}



local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "主要" }),
    Player = Tabs.Main:Tab({ Title = "玩家" }),
    ESP = Tabs.Main:Tab({ Title = "透视" }),
    Other = Tabs.Main:Tab({ Title = "其他" }),
    Anti = Tabs.Main:Tab({ Title = "阻止" })
}
Window:SelectTab(1)

_G.REP = 1.8
_G.BTE = false

TabHandles.Elements:Section({ Title = "全局" })


local repairSlider = TabHandles.Elements:Slider({
    Title = "修电箱延迟[秒]",
    Step = 0.1,
    Value = { Min = 1.8, Max = 10, Default = _G.REP },
    Callback = function(value)
        _G.REP = value
        print("修理间隔设置为:", string.format("%.2f", _G.REP), "秒")
    end
})

local repairToggle = TabHandles.Elements:Toggle({
    Title = "自动修电箱",
    Default = false,
    Callback = function(state)
        _G.BTE = state

        local function RepairGenerators()
            local map = workspace:FindFirstChild("Map")
            local ingame = map and map:FindFirstChild("Ingame")
            local currentMap = ingame and ingame:FindFirstChild("Map")

            if currentMap then
                for _, obj in ipairs(currentMap:GetChildren()) do
                    if obj.Name == "Generator" and obj:FindFirstChild("Progress") and obj.Progress.Value < 100 then
                        local remote = obj:FindFirstChild("Remotes") and obj.Remotes:FindFirstChild("RE")
                        if remote then
                            remote:FireServer()
                        end
                    end
                end
            end
        end

        if state then
            task.spawn(function()
                while _G.BTE do
                    RepairGenerators()
                    task.wait(_G.REP or 1.80) 
                end
            end)
        end
    end
})



local sprintModule
local isStaminaDrainDisabled = false
local staminaMonitorConnection = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function modifyStaminaSettings()
    pcall(function()
        if not sprintModule then
            local success, module = pcall(require, ReplicatedStorage.Systems.Character.Game.Sprinting)
            if success and module then
                sprintModule = module
                return
            end
        end
        if sprintModule and sprintModule.StaminaLossDisabled ~= nil then
             sprintModule.StaminaLossDisabled = isStaminaDrainDisabled
        end
    end)
end

local function monitorAndReapplyStamina()
    if staminaMonitorConnection then
        staminaMonitorConnection:Disconnect()
    end
    staminaMonitorConnection = RunService.Heartbeat:Connect(function()
        if isStaminaDrainDisabled then
            modifyStaminaSettings()
        else
            if staminaMonitorConnection then
                staminaMonitorConnection:Disconnect()
                staminaMonitorConnection = nil
            end
        end
    end)
end

local infiniteStaminaToggle = TabHandles.Elements:Toggle({
    Title = "无限体力",
    Default = false,
    Callback = function(state)
        isStaminaDrainDisabled = state
        modifyStaminaSettings()
        
        if state then
            monitorAndReapplyStamina()
        else
            if staminaMonitorConnection then
                staminaMonitorConnection:Disconnect()
                staminaMonitorConnection = nil
            end
            if sprintModule and sprintModule.StaminaLossDisabled ~= nil then
                sprintModule.StaminaLossDisabled = false 
            end
        end
    end
})


local ReplicatedStorage = game:GetService("ReplicatedStorage")


local function restoreStamina()
    pcall(function()
     
        local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
        local sprintModule = require(SprintingModule)
        
       
        if sprintModule and sprintModule.SetStamina then
            sprintModule.SetStamina(sprintModule.MaxStamina or 100)
        end
    end)
end

TabHandles.Elements:Button({
    Title = "恢复体力",
    Callback = function()
        restoreStamina()
    end
})



TabHandles.Elements:Section({ Title = "Shedletsky幸存者" })


local autoSlashEnabled = false
local slashConnection = nil
local RunService = game:GetService("RunService")

local function checkAndSlash()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local killersFolder = workspace:FindFirstChild("Players")
    if not killersFolder then return end
    
    local killers = killersFolder:FindFirstChild("Killers")
    if not killers then return end
    
    local playerPosition = humanoidRootPart.Position
    
    for _, killer in ipairs(killers:GetChildren()) do
        local killerRoot = killer:FindFirstChild("HumanoidRootPart")
        if killerRoot then
            local distance = (playerPosition - killerRoot.Position).Magnitude
            if distance <= 10 then
                local args = {
                    [1] = "UseActorAbility",
                    [2] = "Slash"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                break
            end
        end
    end
end

local autoSlashToggle = TabHandles.Elements:Toggle({
    Title = "自动斩击(被动)",
    Default = false,
    Callback = function(state)
        autoSlashEnabled = state
        
        if state then
            if slashConnection then
                slashConnection:Disconnect()
            end
            slashConnection = RunService.Heartbeat:Connect(function()
                if autoSlashEnabled then
                    checkAndSlash()
                end
            end)
        else
            if slashConnection then
                slashConnection:Disconnect()
                slashConnection = nil
            end
        end
    end
})




local shedletskyAimbotEnabled = false
local shedloop = nil

local function shedletskyAimbot(state)
    shedletskyAimbotEnabled = state
    
    if state then
       
        if game:GetService("Players").LocalPlayer.Character.Name ~= "Shedletsky" then
            return
        end
        
        shedloop = game:GetService("Players").LocalPlayer.Character.Sword.ChildAdded:Connect(function(child)
            if not shedletskyAimbotEnabled then return end
            if child:IsA("Sound") then 
                local FAN = child.Name
                if FAN == "rbxassetid://12222225" or FAN == "83851356262523" then 
                    local killersFolder = game.Workspace.Players:FindFirstChild("Killers")
                    if killersFolder then 
                        local killer = killersFolder:FindFirstChildOfClass("Model")
                        if killer and killer:FindFirstChild("HumanoidRootPart") then 
                            local killerHRP = killer.HumanoidRootPart
                            local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if playerHRP then 
                                local distance = (killerHRP.Position - playerHRP.Position).Magnitude
                               
                                if distance <= 30 then
                                    local num = 1
                                    local maxIterations = 100
                                    while num <= maxIterations do
                                        task.wait(0.01)
                                        num = num + 1
                                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, killerHRP.Position)
                                        playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, killerHRP.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if shedloop then 
            shedloop:Disconnect()
            shedloop = nil
        end
    end
end

local shedAimbotToggle = TabHandles.Elements:Toggle({
    Title = "自动瞄准",
    Default = false,
    Callback = function(state)
        shedletskyAimbot(state)
    end
   
})


TabHandles.Elements:Section({ Title = "Chance幸存者" })


local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local PredictionAim = {
    Enabled = false,
    Prediction = 1,
    Duration = 1.7,
    MaxDistance = 50, 
    Targets = { "Jason", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" },
    TrackedAnimations = {
        ["103601716322988"] = true, ["133491532453922"] = true, ["86371356500204"] = true,
        ["76649505662612"] = true, ["81698196845041"] = true
    },
    Humanoid = nil,
    HRP = nil,
    LastTriggerTime = 0,
    IsAiming = false,
    OriginalState = nil
}

local function setupCharacter(char)
    PredictionAim.Humanoid = char:WaitForChild("Humanoid")
    PredictionAim.HRP = char:WaitForChild("HumanoidRootPart")
end

local function getValidTarget()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, name in ipairs(PredictionAim.Targets) do
            local target = killersFolder:FindFirstChild(name)
            if target and target:FindFirstChild("HumanoidRootPart") then
                
                if PredictionAim.HRP and (PredictionAim.HRP.Position - target.HumanoidRootPart.Position).Magnitude <= PredictionAim.MaxDistance then
                    return target.HumanoidRootPart
                end
            end
        end
    end
    return nil
end

local function getPlayingAnimationIds()
    local ids = {}
    if PredictionAim.Humanoid then
        for _, track in ipairs(PredictionAim.Humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId then
                local id = track.Animation.AnimationId:match("%d+")
                if id then ids[id] = true end
            end
        end
    end
    return ids
end

local function OnRenderStep()
    if not PredictionAim.Enabled or not PredictionAim.Humanoid or not PredictionAim.HRP then return end
    local playing = getPlayingAnimationIds()
    local triggered = false
    for id in pairs(PredictionAim.TrackedAnimations) do
        if playing[id] then triggered = true; break end
    end

    if triggered then
        PredictionAim.LastTriggerTime = tick()
        PredictionAim.IsAiming = true
    end

    if PredictionAim.IsAiming and tick() - PredictionAim.LastTriggerTime <= PredictionAim.Duration then
        if not PredictionAim.OriginalState then
            PredictionAim.OriginalState = {
                WalkSpeed = PredictionAim.Humanoid.WalkSpeed,
                JumpPower = PredictionAim.Humanoid.JumpPower,
                AutoRotate = PredictionAim.Humanoid.AutoRotate
            }
            PredictionAim.Humanoid.AutoRotate = false
            PredictionAim.HRP.AssemblyAngularVelocity = Vector3.zero
        end
        local targetHRP = getValidTarget()
        if targetHRP then
            local predictedPos = targetHRP.Position + (targetHRP.CFrame.LookVector * PredictionAim.Prediction)
            local direction = (predictedPos - PredictionAim.HRP.Position).Unit
            local yRot = math.atan2(-direction.X, -direction.Z)
            PredictionAim.HRP.CFrame = CFrame.new(PredictionAim.HRP.Position) * CFrame.Angles(0, yRot, 0)
        end
    elseif PredictionAim.IsAiming then
        PredictionAim.IsAiming = false
        if PredictionAim.OriginalState then
            PredictionAim.Humanoid.WalkSpeed = PredictionAim.OriginalState.WalkSpeed
            PredictionAim.Humanoid.JumpPower = PredictionAim.OriginalState.JumpPower
            PredictionAim.Humanoid.AutoRotate = PredictionAim.OriginalState.AutoRotate
            PredictionAim.OriginalState = nil
        end
    end
end

if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)



local predictionSlider = TabHandles.Elements:Slider({
    Title = "预测",
    Value = { Min = 1, Max = 10, Default = PredictionAim.Prediction },
    Callback = function(value)
        PredictionAim.Prediction = value
    end
})

local aimToggle = TabHandles.Elements:Toggle({
    Title = "自动瞄准",
    Default = false,
    Callback = function(state)
        PredictionAim.Enabled = state
    end
})

RunService.RenderStepped:Connect(OnRenderStep)


local AutoFlipCoins = false
local flipCoinsThread = nil

local autoCoinToggle = TabHandles.Elements:Toggle({
    Title = "自动翻转硬币(3)",
    Default = false,
    Callback = function(state)
        AutoFlipCoins = state
        
        if AutoFlipCoins then
            flipCoinsThread = task.spawn(function()
                while AutoFlipCoins and task.wait() do
                 
                    local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                    local chargesText = playerGui:FindFirstChild("MainUI") and 
                                       playerGui.MainUI:FindFirstChild("AbilityContainer") and
                                       playerGui.MainUI.AbilityContainer:FindFirstChild("Shoot") and
                                       playerGui.MainUI.AbilityContainer.Shoot:FindFirstChild("Charges")
                    
                    if chargesText and chargesText:IsA("TextLabel") and chargesText.Text == "3" then
                      
                        break
                    else
                        
                        local args = {
                            [1] = "UseActorAbility",
                            [2] = "CoinFlip"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    end
                end
            end)
        elseif flipCoinsThread then
            task.cancel(flipCoinsThread)
            flipCoinsThread = nil
        end
    end
})

local autoCoinToggle = TabHandles.Elements:Toggle({
    Title = "自动翻转硬币(1)",
    Default = false,
    Callback = function(state)
        AutoFlipCoins = state
        
        if AutoFlipCoins then
            flipCoinsThread = task.spawn(function()
                while AutoFlipCoins and task.wait() do
                 
                    local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                    local chargesText = playerGui:FindFirstChild("MainUI") and 
                                       playerGui.MainUI:FindFirstChild("AbilityContainer") and
                                       playerGui.MainUI.AbilityContainer:FindFirstChild("Shoot") and
                                       playerGui.MainUI.AbilityContainer.Shoot:FindFirstChild("Charges")
                    
                    if chargesText and chargesText:IsA("TextLabel") and chargesText.Text == "1" then
                      
                        break
                    else
                        
                        local args = {
                            [1] = "UseActorAbility",
                            [2] = "CoinFlip"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    end
                end
            end)
        elseif flipCoinsThread then
            task.cancel(flipCoinsThread)
            flipCoinsThread = nil
        end
    end
})



