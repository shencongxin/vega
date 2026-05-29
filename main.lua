ab22a390752305680f3da8a1de1bfbf87e=function (vip)
---[=[脚本可以复制到下面]=]-------------------------------------------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "恐鬼症 - 局内 euphoria开源",
    Footer = "付费版[正式版]",
    ToggleKeybind = Enum.KeyCode.C,
    Center = true,
    AutoShow = true,
    ShowCustomCursor = false,
    Icon = 77444606786842,
    IconSize = UDim2.fromOffset(40, 40),
    BackgroundImage = 77444606786842,
})

local TabPlayer = Window:AddTab("玩家", "user-round-pen", "本地玩家修改")
local GroupPlayer = TabPlayer:AddLeftGroupbox("玩家")
local GroupGame = TabPlayer:AddLeftGroupbox("游戏")
local GroupMatch = TabPlayer:AddRightGroupbox("对局")
local GroupZone = TabPlayer:AddRightGroupbox("区域")

local GhostRoomPart = nil -- 用于存储鬼房位置(r11_0)
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 玩家功能: 透视/夜视
GroupPlayer:AddButton({
    Text = "透视/夜视",
    Func = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        for _, v in pairs(Lighting:GetDescendants()) do
            v:Destroy()
        end
    end,
})

-- 玩家功能: 无限体力
GroupPlayer:AddButton({
    Text = "无限体力",
    Func = function()
        for i = 1, 10 do
            if LocalPlayer:FindFirstChild("DoubleStamina") then
                LocalPlayer.DoubleStamina.Value = true
            end
        end
    end,
})

-- 玩家功能: 白天可见(聊天窗)
local ChatWindowConn = nil
GroupPlayer:AddToggle("DaylightChat", {
    Text = "白天可见(聊天窗)",
    Default = false,
    Callback = function(Value)
        local ChatConfig = game:GetService("TextChatService").ChatWindowConfiguration
        if Value then
            ChatConfig.Enabled = true
            ChatWindowConn = ChatConfig:GetPropertyChangedSignal("Enabled"):Connect(function()
                ChatConfig.Enabled = true
            end)
        elseif ChatWindowConn then
            ChatWindowConn:Disconnect()
            ChatConfig.Enabled = false
        end
    end,
})

-- 玩家功能: 区域温度显示
GroupPlayer:AddToggle("ShowTemp", {
    Text = "区域温度",
    Default = false,
    Callback = function(Value)
        if LocalPlayer.PlayerGui:FindFirstChild("TemperatureDisplay") then
            LocalPlayer.PlayerGui.TemperatureDisplay.Enabled = Value
        end
    end,
})

-- 玩家功能: 高频精灵盒
local SpiritBoxConn = nil
GroupPlayer:AddToggle("AutoSpiritBox", {
    Text = "高频精灵盒对话",
    Default = false,
    Callback = function(Value)
        if Value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Spirit Box") then
                SpiritBoxConn = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character:FindFirstChild("Spirit Box") then
                        LocalPlayer.Character["Spirit Box"].AskQuestion:FireServer("ButtonA")
                    end
                end)
            else
                Library:Notify("请确保角色手持了精灵盒", 5)
            end
        elseif SpiritBoxConn then
            SpiritBoxConn:Disconnect()
        end
    end,
})

-- 玩家功能: 透视幽灵仇恨
GroupPlayer:AddToggle("IgnoreGhost", {
    Text = "透视幽灵仇恨",
    Tooltip = "使用该功能会让幽灵无视你(请不要在房子内开启)",
    Default = false,
    Callback = function(Value)
        if LocalPlayer.Zone.Value ~= "Outside" and Value == true then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Workspace.Map.Zones.Outside, 0)
            task.wait(0.1)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Workspace.Map.Zones.Outside, 1)
        end
        for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
            if not zone:IsA("Folder") then
                zone.CanTouch = not Value
            end
        end
    end,
})

-- 玩家功能: 远程互动
local ProximityConn = nil
GroupPlayer:AddToggle("RemoteInteract", {
    Text = "远程互动",
    Default = false,
    Callback = function(Value)
        if Value then
            if fireproximityprompt then
                ProximityConn = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
                    fireproximityprompt(prompt)
                end)
            else
                Library:Notify("你的注入器不支持此命令(fireproximityprompt)", 5)
            end
        elseif ProximityConn then
            ProximityConn:Disconnect()
            ProximityConn = nil
        end
    end,
})

-- 玩家功能: 速度修改
local SpeedConn = nil
local TargetSpeed = 0
GroupPlayer:AddInput("WalkSpeed", {
    Text = "速度修改",
    Default = "负数关闭,正数开启",
    Numeric = true,
    Finished = true,
    Placeholder = "负数关闭,正数开启",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 0 then
            if SpeedConn then
                TargetSpeed = num
            else
                SpeedConn = LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
                end)
                LocalPlayer.Character.Humanoid.WalkSpeed = num
                TargetSpeed = num
            end
        elseif SpeedConn then
            SpeedConn:Disconnect()
            SpeedConn = nil
        end
    end,
})

-- 游戏功能: 删门
GroupGame:AddButton({
    Text = "删门",
    Func = function()
        for _, door in ipairs(Workspace.Map.Doors:GetChildren()) do
            door:Destroy()
        end
    end,
})

-- 游戏功能: 收集所有照片
local PhotoTypes = {
    "Cursed Object", "Ghost", "Dirty Water", "Stepped In Salt",
    "Written In Book", "Burning Crucifix", "Dead Body", "Boo-Boo Doll", "UV Print"
}
GroupGame:AddButton({
    Text = "收集所有照片",
    Func = function()
        if LocalPlayer.Character:FindFirstChild("Photo Camera") then
            for _, pType in pairs(PhotoTypes) do
                LocalPlayer.Character["Photo Camera"].Remote.FireCameraEvent:FireServer(unpack({
                    [1] = LocalPlayer.Character:FindFirstChild("Head").CFrame,
                    [2] = { Type = pType },
                }))
            end
        else
            Library:Notify("请确保角色手持了照相机", 5)
        end
    end,
})

-- 游戏功能: 凭空放盐
GroupGame:AddButton({
    Text = "凭空放盐",
    Func = function()
        if GhostRoomPart and LocalPlayer.Character:FindFirstChild("Salt") then
            LocalPlayer.Character.Salt.Remote.Drop:FireServer(unpack({
                [1] = GhostRoomPart.CFrame,
                [2] = LocalPlayer.Character.Salt.Ammo.Capacity,
            }))
        else
            Library:Notify("请确保角色手持了盐，且已探测到鬼房(最低温度)", 5)
        end
    end,
})

-- 游戏功能: 血月加成
GroupGame:AddButton({
    Text = "血月加成",
    Func = function()
        ReplicatedStorage.Remotes.BloodMoonEvent:FireServer()
    end,
})

-- 游戏功能: 蜡烛互动距离
GroupGame:AddSlider("CandleDistance", {
    Text = "蜡烛互动距离",
    Default = 4,
    Min = 4,
    Max = 10,
    Compact = false,
    Callback = function(Value)
        for _, v in ipairs(Workspace.Map:FindFirstChild("Candles"):GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.MaxActivationDistance = Value
            end
        end
    end,
})

-- 对局功能: 辅助函数
local CrashConn = nil
local function ClearPictures()
    for _, v in ipairs(Workspace.Map.Items:GetDescendants()) do
        if v.Name == "PictureGui" then v:Destroy() end
    end
end

local function RandomString(len)
    math.randomseed(os.time())
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local str = ""
    for i = 1, len do
        local r = math.random(1, #chars)
        str = str .. string.sub(chars, r, r)
    end
    return str
end

-- 对局功能: 轰炸清理
GroupMatch:AddButton({
    Text = "轰炸对局清理",
    Tooltip = "如果在使用炸对局功能时使用者出现严重卡顿，请使用此功能",
    Func = function()
        ClearPictures()
    end,
})

local EnableAdMsg = true
GroupMatch:AddToggle("AdMsg", {
    Text = "使用广告(炸对局发送消息)",
    Tooltip = "高程度避免被视频录制举报",
    Default = false,
    Callback = function(Value)
        EnableAdMsg = not Value -- 逻辑取反
    end,
})

local LoadedCrashBot = true
GroupMatch:AddToggle("CrashMatch", {
    Text = "炸对局",
    Tooltip = "该功能会致使对局中所有人卡顿掉线(设备好则不会崩退)",
    Default = false,
    Callback = function(Value)
        if Value then
            if LoadedCrashBot then
                LoadedCrashBot = false
                loadstring(game:HttpGet("https://raw.githubusercontent.com/longchneg/GAl/refs/heads/main/%E6%9C%BA%E5%99%A8%E4%BA%BA"))()
            end
            if EnableAdMsg then
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("GAl独家[炸对局]功能开启:" .. RandomString(10))
            end
            ClearPictures()
            task.wait(2)
            CrashConn = RunService.Stepped:Connect(function()
                if Workspace.Map.Items:FindFirstChild("Photo Camera") then
                    Workspace.Map.Items["Photo Camera"].Remote.FireCameraEvent:FireServer(LocalPlayer.Character.HumanoidRootPart.CFrame, {})
                else
                    print("未找到照相机")
                end
            end)
        elseif CrashConn then
            CrashConn:Disconnect()
        end
    end,
})

-- 区域功能
local ZoneList = {}
for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
    if not zone:IsA("Folder") then
        table.insert(ZoneList, zone.Name)
    end
end

local OldZoneSize = nil
local OldZoneName = nil
local HuntTpConn = nil
local HasModdedZone = false

GroupZone:AddLabel([[
友情提示:该功能开启前请务必搭配[狩猎传回]，否则幽灵在外面猎杀,目标只有你一个

开启后这会导致撤离前需要等待30秒才能撤离

当你选择了区域后[狩猎传回]将自动转换为频繁而不是单次(如果在选择区域前就已经开启了[狩猎传回]就需要重新开启该功能)]], true)

GroupZone:AddToggle("HuntTp", {
    Text = "狩猎传回",
    Default = false,
    Tooltip = "当猎杀后本地玩家会被传送到安全点避免被猎杀",
    Callback = function(Value)
        if Value then
            if HasModdedZone then
                HuntTpConn = RunService.Stepped:Connect(function()
                    if ReplicatedStorage.Disruption.Value == true and LocalPlayer.Character then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace.TempSpawn.SpawnPart.CFrame + Vector3.new(0, 5, 0)
                    end
                end)
            else
                HuntTpConn = ReplicatedStorage.Disruption:GetPropertyChangedSignal("Value"):Connect(function()
                    if ReplicatedStorage.Disruption.Value == true and LocalPlayer.Character then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace.TempSpawn.SpawnPart.CFrame + Vector3.new(0, 5, 0)
                    end
                end)
            end
        else
            if HuntTpConn then HuntTpConn:Disconnect() end
        end
    end,
})

GroupZone:AddDropdown("SelectZone", {
    Values = ZoneList,
    Default = nil,
    Multi = false,
    Text = "选择区域",
    Tooltip = "该功能让你不进房子就能减少理智或者吸引仇恨(找到名为[Outside]即可关闭)",
    Callback = function(Value)
        HasModdedZone = true
        -- 恢复旧区域
        if OldZoneName then
            for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
                if zone.Name == OldZoneName then
                    zone.Size = OldZoneSize
                end
            end
            OldZoneSize = nil
            OldZoneName = nil
        end

        -- 设置Outside为极小
        for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
            if zone.Name == "Outside" then
                zone.Size = Vector3.new(1, 1, 1)
            end
        end
        
        -- 设置新区域
        for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
            if zone.Name == Value then
                OldZoneSize = zone.Size
                OldZoneName = zone.Name
                zone.Size = Vector3.new(2048, 2048, 2048)
            end
        end
    end,
})

-- ESP 系统
local IsGhostRoomESP = false
local ESPFolderGUID = game:GetService("HttpService"):GenerateGUID(false)
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = ESPFolderGUID
ESPFolder.Parent = Workspace

local function CreateESP(adornee, name, text, color, offset, useHighlight)
    if not Workspace:FindFirstChild(ESPFolderGUID) then
        local f = Instance.new("Folder")
        f.Name = ESPFolderGUID
        f.Parent = Workspace
    end
    
    if Workspace:FindFirstChild(ESPFolderGUID) and adornee then
        -- 检查是否已存在
        for _, child in ipairs(Workspace:FindFirstChild(ESPFolderGUID):GetChildren()) do
            if child.Name == name and child.Adornee == adornee then
                child:FindFirstChild("Name").Text = text
                return 
            end
        end

        local bg = Instance.new("BillboardGui")
        local txtName = Instance.new("TextLabel")
        local txtDist = Instance.new("TextLabel")
        
        bg.AlwaysOnTop = true
        bg.Name = name
        bg.Size = UDim2.new(0, 100, 0, 40)
        bg.ClipsDescendants = true
        bg.Adornee = adornee
        bg.MaxDistance = math.huge
        bg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        bg.StudsOffset = offset or Vector3.new(0, 3, 0)
        bg.Parent = Workspace:FindFirstChild(ESPFolderGUID)
        
        txtName.Name = "Name"
        txtName.TextWrapped = true
        txtName.TextStrokeTransparency = 0
        txtName.TextScaled = true
        txtName.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        txtName.Size = UDim2.new(1, 0, 0.5, 0)
        txtName.Text = text or "nil"
        txtName.TextColor3 = color or Color3.new(1, 1, 1)
        txtName.BackgroundTransparency = 1
        txtName.Parent = bg
        
        txtDist.Name = "Distance"
        txtDist.TextWrapped = true
        txtDist.TextStrokeTransparency = 0.4
        txtDist.TextScaled = true
        txtDist.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        txtDist.Size = UDim2.new(1, 0, 0.5, 0)
        txtDist.Text = "[无数据]"
        txtDist.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        txtDist.BackgroundTransparency = 1
        txtDist.Position = UDim2.new(0, 0, 0.5, 0)
        txtDist.Parent = bg
        
        if useHighlight then
            local hl = Instance.new("Highlight")
            hl.OutlineTransparency = 1
            hl.Adornee = adornee
            hl.FillColor = color
            hl.FillTransparency = 0.6
            hl.Parent = bg
        end
    end
end

local function ClearESP(name)
    for _, v in ipairs(Workspace:FindFirstChild(ESPFolderGUID):GetChildren()) do
        if v.Name == name then v:Destroy() end
    end
end

local ESPList = { "诅咒道具", "幽灵球", "幽灵", "最低温度", "巫毒娃娃", "互动", "发电电机", "血月定鬼房" }
local OrbConn, GhostESPConn, EMFConn = nil, nil, nil
local BloodMoonConns = {}

local function UpdateESP(selected)
    if table.find(selected, "诅咒道具") then
        local cursedItems = {"Music Box", "Spirit Board", "SummoningCircle", "Tarot Cards"}
        for _, v in ipairs(Workspace:GetDescendants()) do
            if table.find(cursedItems, v.Name) and (v:IsA("Tool") or v:IsA("Model")) then
                CreateESP(v, "CursedESP", "诅咒道具", Color3.fromRGB(255, 234, 0), nil, true)
            end
        end
    else
        ClearESP("CursedESP")
    end

    if table.find(selected, "幽灵球") then
        CreateESP(Workspace.Map.Orbs:FindFirstChild("OrbPart"), "OrbPart", "幽灵球", Color3.fromRGB(121, 255, 248), Vector3.new(0, 0, 0), false)
        if not OrbConn then
            OrbConn = Workspace.Map.Orbs.ChildAdded:Connect(function(child)
                CreateESP(child, "OrbPart", "幽灵球", Color3.fromRGB(121, 255, 248), Vector3.new(0, 0, 0), false)
            end)
        end
    elseif OrbConn then
        OrbConn:Disconnect()
        OrbConn = nil
        ClearESP("OrbPart")
    end

    if table.find(selected, "幽灵") and not GhostESPConn then
        GhostESPConn = Workspace.ChildAdded:Connect(function(child)
            if child.Name == "Ghost" and child:IsA("Model") then
                CreateESP(child, "GhostESP", "幽灵", Color3.fromRGB(255, 119, 56), Vector3.new(0, 0, 0), false)
            end
        end)
    elseif GhostESPConn then
        GhostESPConn:Disconnect()
        GhostESPConn = nil
        ClearESP("GhostESP")
    end

    if table.find(selected, "最低温度") then
        IsGhostRoomESP = true
        CreateESP(GhostRoomPart, "GhostRoomESP", "最低温度房间", Color3.fromRGB(186, 250, 144), Vector3.new(0, 0, 0), true)
    else
        IsGhostRoomESP = false
        ClearESP("GhostRoomESP")
    end

    if table.find(selected, "巫毒娃娃") then
        for _, v in ipairs(Workspace:GetChildren()) do
            if v.Name == "BooBooDoll" then
                CreateESP(v, "BooBooDollESP", "巫毒娃娃", Color3.fromRGB(179, 113, 255), Vector3.new(0, 0, 0), true)
            end
        end
    else
        ClearESP("BooBooDollESP")
    end

    if table.find(selected, "发电机") then
        if Workspace.Map.Generators:FindFirstChild("GeneratorMesh") then
            CreateESP(Workspace.Map.Generators:FindFirstChild("GeneratorMesh"), "GeneratorsESP", "发电机", Color3.fromRGB(12, 156, 125), nil, true)
        end
    else
        ClearESP("GeneratorsESP")
    end

    if table.find(selected, "互动") and not EMFConn then
        EMFConn = Workspace.Map.DescendantAdded:Connect(function(child)
            if child:IsA("Part") and child.Name == "EMFPart" then
                CreateESP(child, "EMFPartESP", "互动", Color3.fromRGB(79, 153, 79), Vector3.new(0, 0, 0), false)
            end
        end)
    elseif EMFConn then
        EMFConn:Disconnect()
        EMFConn = nil
        ClearESP("EMFPartESP")
    end

    if table.find(selected, "血月定鬼房") then
        for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
            table.insert(BloodMoonConns, zone.ChildAdded:Connect(function(child)
                if child:IsA("Sound") then
                    CreateESP(child.Parent, "BloodMoonSound", "准确鬼房(血月)", Color3.fromRGB(255, 112, 172), Vector3.new(0, 0, 0), false)
                end
            end))
        end
    else
        for _, conn in pairs(BloodMoonConns) do conn:Disconnect() end
        ClearESP("BloodMoonSound")
    end
end

-- 绘制 Tab
local TabESP = Window:AddTab("绘制", "map-pinned", "绘制工作区对象"):AddLeftGroupbox("绘制")
local ESPWarning = TabESP:AddLabel("<font color='rgb(255,0,0)'>!!!正在等待车门开启,确保绘制正常运行!!!</font>")

-- 数据 Tab
local TabData = Window:AddTab("数据", "ghost", "录幽灵数值")
local GroupGhostData = TabData:AddLeftGroupbox("幽灵")
local GhostSpeedLabel = GroupGhostData:AddLabel("最低: 幽灵未出现\n速度: 幽灵未出现\n最高: 幽灵未出现", true)
GroupGhostData:AddDivider()
local GhostFadeLabel = GroupGhostData:AddLabel("透明度变化时间: 幽灵未出现\n平均值: 幽灵未出现", true)

local MinSpeed = 100
local CurrentSpeed = 0
local MaxSpeed = 0
local AvgFadeTime = 0
local LastFadeTime = 0
local FadeTimes = {}

Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Ghost" and child:IsA("Model") then
        task.wait(0.5)
        local Humanoid = child:FindFirstChild("Humanoid")
        if Humanoid then
            GhostSpeedLabel:SetText("最低: " .. string.format("%.2f", Humanoid.WalkSpeed) .. "\n速度: " .. string.format("%.2f", Humanoid.WalkSpeed) .. "\n最高: " .. string.format("%.2f", Humanoid.WalkSpeed))
            Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                CurrentSpeed = Humanoid.WalkSpeed
                if CurrentSpeed < MinSpeed then MinSpeed = CurrentSpeed end
                if CurrentSpeed > MaxSpeed then MaxSpeed = CurrentSpeed end
                GhostSpeedLabel:SetText("最低: " .. string.format("%.2f", MinSpeed) .. "\n速度: " .. string.format("%.2f", CurrentSpeed) .. "\n最高: " .. string.format("%.2f", MaxSpeed))
            end)
        end

        local Head = child:FindFirstChild("Head")
        if Head then
            local lastTrans = Head.Transparency
            local startTime = tick()
            Head:GetPropertyChangedSignal("Transparency"):Connect(function()
                if lastTrans < Head.Transparency then
                    LastFadeTime = tick() - startTime
                    if LastFadeTime <= 8 then
                        table.insert(FadeTimes, LastFadeTime)
                        local sum = 0
                        for _, t in ipairs(FadeTimes) do sum = sum + t end
                        AvgFadeTime = sum / #FadeTimes
                        GhostFadeLabel:SetText("透明度变化时间: " .. string.format("%.2f", LastFadeTime) .. "秒\n平均值: " .. string.format("%.2f", AvgFadeTime) .. "秒")
                    end
                end
                lastTrans = Head.Transparency
                startTime = tick()
            end)
        end
    end
end)

GroupGhostData:AddDivider()
local HuntTimeLabel = GroupGhostData:AddLabel("剩余时间: 幽灵未出现", true)
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "HuntDuration" then
        child:GetPropertyChangedSignal("Value"):Connect(function()
            HuntTimeLabel:SetText("剩余时间: " .. tostring(child.Value))
        end)
    end
end)

GroupGhostData:AddToggle("Watermark", {
    Text = "显示水印",
    Default = false,
    Callback = function(Value)
        Library:SetWatermarkVisibility(Value)
    end,
})

local GroupEvidence = TabData:AddRightGroupbox("证据")
local MinRoomTemp = math.huge
local TempLabel = GroupEvidence:AddLabel("最低房间温度\n无数据", true)

-- 温度监控循环
for _, zone in ipairs(Workspace.Map.Zones:GetChildren()) do
    if zone.Name ~= "Outside" then
        for _, v in ipairs(zone:GetDescendants()) do
            if v.Name == "_____Temperature" and v:IsA("NumberValue") then
                v:GetPropertyChangedSignal("Value"):Connect(function()
                    if v.Value < MinRoomTemp then
                        MinRoomTemp = v.Value
                        if TempLabel then
                            TempLabel:SetText("最低房间温度\n" .. tostring(string.format("%.2f", MinRoomTemp)))
                        end
                        GhostRoomPart = v.Parent -- 更新鬼房
                        if IsGhostRoomESP then
                            ClearESP("GhostRoomESP")
                            CreateESP(GhostRoomPart, "GhostRoomESP", "最低温度房间", Color3.fromRGB(186, 250, 144), Vector3.new(0, 0, 0), true)
                        end
                    end
                end)
            end
        end
    end
end

local OrbLabel = GroupEvidence:AddLabel("幽灵球\n不存在", true)
Workspace.Map.Orbs.ChildAdded:Connect(function() OrbLabel:SetText("幽灵球\n存在") end)

local SaltLabel = GroupEvidence:AddLabel("盐罐\n未踩", true)
Workspace.Map.Misc.ChildAdded:Connect(function(c)
    if c.Name == "SaltStepped" and c:IsA("MeshPart") then SaltLabel:SetText("盐罐\n已踩") end
end)

local SpiritBoxLabel = GroupEvidence:AddLabel("精灵盒\n不存在/未知", true)
for _, v in ipairs(Workspace:GetDescendants()) do
    if v.Name == "Spirit Box" and v:IsA("Tool") and v:FindFirstChild("Handle") then
        v.Handle.ChildAdded:Connect(function(c)
            if c:IsA("Sound") then SpiritBoxLabel:SetText("精灵盒\n存在") end
        end)
    end
end

local EMFCount = 0
local EMFLabel = GroupEvidence:AddLabel("互动\n未出现", true)
Workspace.Map.DescendantAdded:Connect(function(c)
    if c:IsA("Part") and c.Name == "EMFPart" then
        EMFCount = EMFCount + 1
        EMFLabel:SetText("互动\n出现次数: " .. EMFCount)
    end
end)

local SLSCount = 0
local SLSLabel = GroupEvidence:AddLabel("SLS异常\n未出现", true)
Workspace.ChildAdded:Connect(function(c)
    if c.Name == "SLS_Sitting" and c:IsA("Model") then
        SLSCount = SLSCount + 1
        SLSLabel:SetText("SLS异常\n出现次数: " .. SLSCount)
    end
end)

local UVCount = 0
local UVLabel = GroupEvidence:AddLabel("紫外线\n未出现", true)
Workspace.Map.Prints.ChildAdded:Connect(function()
    UVCount = UVCount + 1
    UVLabel:SetText("紫外线\n出现次数: " .. UVCount)
end)

local ShadowCount = 0
local ShadowLabel = GroupEvidence:AddLabel("黑影人物\n未出现", true)
Workspace.ChildAdded:Connect(function(c)
    if c.Name == "ShadowyFigure" and c:IsA("Model") then
        ShadowCount = ShadowCount + 1
        ShadowLabel:SetText("黑影人物\n出现次数: " .. ShadowCount)
    end
end)

local GroupLocalStats = TabData:AddLeftGroupbox("本地玩家")
local SanityLabel = GroupLocalStats:AddLabel("理智\n0%/100%", true)
local LivesLabel = GroupLocalStats:AddLabel("生命\n0条", true)

LocalPlayer:FindFirstChild("Sanity"):GetPropertyChangedSignal("Value"):Connect(function()
    SanityLabel:SetText("理智\n" .. tostring(string.format("%.2f", LocalPlayer.Sanity.Value)) .. "%")
end)
LocalPlayer:FindFirstChild("Lives"):GetPropertyChangedSignal("Value"):Connect(function()
    LivesLabel:SetText("生命\n" .. LocalPlayer.Lives.Value .. "条")
end)

-- 清理其它玩家的图片GUI
for _, p in ipairs(Players:GetPlayers()) do
    if p.Character and p.Character:FindFirstChild("Photo Camera") and p.Character["Photo Camera"]:FindFirstChild("PictureGui") then
        p.Character["Photo Camera"].PictureGui:Destroy()
    end
end

-- 等待车门开启激活ESP选择
local TimeVal = ReplicatedStorage:FindFirstChild("Time")
local TimeConn = nil
TimeConn = TimeVal:GetPropertyChangedSignal("Value"):Connect(function()
    if TimeVal.Value >= 3 then
        TimeConn:Disconnect()
        ESPWarning:SetVisible(false)
        TabESP:AddDropdown("SelectESP", {
            Values = ESPList,
            Default = nil,
            Multi = true,
            Text = "选择对象",
            Callback = function(Val)
                local selected = {}
                for k, v in pairs(Val) do table.insert(selected, k) end
                UpdateESP(selected)
            end,
        })
    end
end)

-- 新玩家加入踢出保护
Players.ChildAdded:Connect(function(p)
    LocalPlayer:Kick("[新玩家加入]为确保您的账号安全已将你踢出对局\n玩家名字：" .. p.Name .. "\n玩家ID：" .. p.UserId)
end)

-- 主循环
RunService.Stepped:Connect(function()
    -- ESP 距离更新
    for _, v in ipairs(Workspace:FindFirstChild(ESPFolderGUID):GetChildren()) do
        if v.Adornee.Parent == nil then
            v:Destroy()
        elseif v.Adornee and LocalPlayer.Character then
            local pos = v.Adornee:IsA("BasePart") and v.Adornee.Position or v.Adornee:GetPivot().Position
            v:FindFirstChild("Distance").Text = "[" .. math.floor((pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
        end
    end

    ReplicatedStorage.Remotes.FreezingTempatureObjective:FireServer()
    
    if LocalPlayer.PlayerGui.Rewards.Frame:FindFirstChild("MapThumbnail") then
        LocalPlayer.PlayerGui.Rewards.Frame.MapThumbnail.Title.Text = "GAl 付费版脚本"
    end
    
    Library:SetWatermark("速度:<font color='#55ff00'>" .. string.format("%.2f", CurrentSpeed) .. "</font> | 透明度平均值:<font color='#55ff00'>" .. string.format("%.2f", AvgFadeTime) .. "</font>")
end)

if LocalPlayer:WaitForChild("SanityTracker") then
    LocalPlayer.SanityTracker.Value = true
    Library:Notify("已经为您自动解锁[便携理智查看器]", 5)
end

LocalPlayer.DoubleStamina:GetPropertyChangedSignal("Value"):Connect(function()
    LocalPlayer.DoubleStamina.Value = false -- 这里的逻辑似乎是如果被重置则重新设为false，原脚本如此，可能意图是防检测或重置？原脚本是设为false，这里保持原样
end)

-- 设置界面
local TabSettings = Window:AddTab("设置", "settings")
local GroupMenu = TabSettings:AddLeftGroupbox("菜单")

GroupMenu:AddToggle("KeybindMenu", {
    Default = Library.KeybindFrame.Visible,
    Text = "打开按键绑定菜单",
    Callback = function(Value) Library.KeybindFrame.Visible = Value end,
})
GroupMenu:AddToggle("CustomCursor", {
    Text = "自定义光标",
    Default = false,
    Callback = function(Value) Library.ShowCustomCursor = Value end,
})
GroupMenu:AddDropdown("DPI", {
    Values = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"},
    Default = "100%",
    Text = "DPI 比例",
    Callback = function(Value) Library:SetDPIScale(tonumber(Value:gsub("%%", ""))) end,
})
GroupMenu:AddLabel("菜单显示绑定"):AddKeyPicker("MenuKey", {
    Default = "C",
    NoUI = true,
    Text = "Menu keybind",
})
GroupMenu:AddButton("关闭UI", function() Library:Unload() end)

Library.ToggleKeybind = Library.Options.MenuKey
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:BuildConfigSection(TabSettings)
SaveManager:LoadAutoloadConfig()



--content





---[=[上面可以复制上你的脚本]=]------------------------------------------------------------------------------------------------------------------- end-- ab80fff28ac9259a245266d5b0cc5575c7
end


function md5(code)    local code = tostring(code)    local HexTable = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}    local A = 0x67452301    local B = 0xefcdab89    local C = 0x98badcfe    local D = 0x10325476    local S11 = 7    local S12 = 12    local S13 = 17    local S14 = 22                 local S21 = 5       local S22 = 9       local S23 = 14       local S24 = 20       local S31 = 4       local S32 = 11       local S33 = 16       local S34 = 23       local S41 = 6       local S42 = 10       local S43 = 15       local S44 = 21       local function F(x,y,z)         return (x & y) | ((~x) & z)       end       local function G(x,y,z)         return (x & z) | (y & (~z))       end       local function H(x,y,z)         return x ~ y ~ z       end       local function I(x,y,z)         return y ~ (x | (~z))       end       local function FF(a,b,c,d,x,s,ac)         a = a + F(b,c,d) + x + ac         a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b         return a & 0xffffffff       end       local function GG(a,b,c,d,x,s,ac)         a = a + G(b,c,d) + x + ac         a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b         return a & 0xffffffff       end       local function HH(a,b,c,d,x,s,ac)         a = a + H(b,c,d) + x + ac         a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b         return a & 0xffffffff       end       local function II(a,b,c,d,x,s,ac)         a = a + I(b,c,d) + x + ac         a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b         return a & 0xffffffff       end       local function MD5StringFill(s)         local len = s:len()         local mod512 = len * 8 % 512         local fillSize = (448 - mod512) // 8         if mod512 > 448 then           fillSize = (960 - mod512) // 8         end         local rTab = {}         local byteIndex = 1         for i = 1,len do           local index = (i - 1) // 4 + 1           rTab[index] = rTab[index] or 0           rTab[index] = rTab[index] | (s:byte(i) << (byteIndex - 1) * 8)           byteIndex = byteIndex + 1           if byteIndex == 5 then             byteIndex = 1           end         end         local b0x80 = false         local tLen = #rTab         if byteIndex ~= 1 then           rTab[tLen] = rTab[tLen] | 0x80 << (byteIndex - 1) * 8           b0x80 = true         end         for i = 1,fillSize // 4 do           if not b0x80 and i == 1 then             rTab[tLen + i] = 0x80            else             rTab[tLen + i] = 0x0           end         end         local bitLen = math.floor(len * 8)         tLen = #rTab         rTab[tLen + 1] = bitLen & 0xffffffff         rTab[tLen + 2] = bitLen >> 32         return rTab       end              function getmd5(s)         local fillTab = MD5StringFill(s)         local result = {A,B,C,D}         for i = 1,#fillTab // 16 do           local a = result[1]           local b = result[2]           local c = result[3]           local d = result[4]           local offset = (i - 1) * 16 + 1           a = FF(a, b, c, d, fillTab[offset + 0], S11, 0xd76aa478)           d = FF(d, a, b, c, fillTab[offset + 1], S12, 0xe8c7b756)           c = FF(c, d, a, b, fillTab[offset + 2], S13, 0x242070db)           b = FF(b, c, d, a, fillTab[offset + 3], S14, 0xc1bdceee)           a = FF(a, b, c, d, fillTab[offset + 4], S11, 0xf57c0faf)           d = FF(d, a, b, c, fillTab[offset + 5], S12, 0x4787c62a)           c = FF(c, d, a, b, fillTab[offset + 6], S13, 0xa8304613)           b = FF(b, c, d, a, fillTab[offset + 7], S14, 0xfd469501)           a = FF(a, b, c, d, fillTab[offset + 8], S11, 0x698098d8)           d = FF(d, a, b, c, fillTab[offset + 9], S12, 0x8b44f7af)           c = FF(c, d, a, b, fillTab[offset + 10], S13, 0xffff5bb1)           b = FF(b, c, d, a, fillTab[offset + 11], S14, 0x895cd7be)           a = FF(a, b, c, d, fillTab[offset + 12], S11, 0x6b901122)           d = FF(d, a, b, c, fillTab[offset + 13], S12, 0xfd987193)           c = FF(c, d, a, b, fillTab[offset + 14], S13, 0xa679438e)           b = FF(b, c, d, a, fillTab[offset + 15], S14, 0x49b40821)           a = GG(a, b, c, d, fillTab[offset + 1], S21, 0xf61e2562)           d = GG(d, a, b, c, fillTab[offset + 6], S22, 0xc040b340)           c = GG(c, d, a, b, fillTab[offset + 11], S23, 0x265e5a51)           b = GG(b, c, d, a, fillTab[offset + 0], S24, 0xe9b6c7aa)           a = GG(a, b, c, d, fillTab[offset + 5], S21, 0xd62f105d)           d = GG(d, a, b, c, fillTab[offset + 10], S22, 0x2441453)           c = GG(c, d, a, b, fillTab[offset + 15], S23, 0xd8a1e681)           b = GG(b, c, d, a, fillTab[offset + 4], S24, 0xe7d3fbc8)           a = GG(a, b, c, d, fillTab[offset + 9], S21, 0x21e1cde6)           d = GG(d, a, b, c, fillTab[offset + 14], S22, 0xc33707d6)           c = GG(c, d, a, b, fillTab[offset + 3], S23, 0xf4d50d87)           b = GG(b, c, d, a, fillTab[offset + 8], S24, 0x455a14ed)           a = GG(a, b, c, d, fillTab[offset + 13], S21, 0xa9e3e905)           d = GG(d, a, b, c, fillTab[offset + 2], S22, 0xfcefa3f8)           c = GG(c, d, a, b, fillTab[offset + 7], S23, 0x676f02d9)           b = GG(b, c, d, a, fillTab[offset + 12], S24, 0x8d2a4c8a)           a = HH(a, b, c, d, fillTab[offset + 5], S31, 0xfffa3942)           d = HH(d, a, b, c, fillTab[offset + 8], S32, 0x8771f681)           c = HH(c, d, a, b, fillTab[offset + 11], S33, 0x6d9d6122)           b = HH(b, c, d, a, fillTab[offset + 14], S34, 0xfde5380c)           a = HH(a, b, c, d, fillTab[offset + 1], S31, 0xa4beea44)           d = HH(d, a, b, c, fillTab[offset + 4], S32, 0x4bdecfa9)           c = HH(c, d, a, b, fillTab[offset + 7], S33, 0xf6bb4b60)           b = HH(b, c, d, a, fillTab[offset + 10], S34, 0xbebfbc70)           a = HH(a, b, c, d, fillTab[offset + 13], S31, 0x289b7ec6)           d = HH(d, a, b, c, fillTab[offset + 0], S32, 0xeaa127fa)           c = HH(c, d, a, b, fillTab[offset + 3], S33, 0xd4ef3085)           b = HH(b, c, d, a, fillTab[offset + 6], S34, 0x4881d05)           a = HH(a, b, c, d, fillTab[offset + 9], S31, 0xd9d4d039)           d = HH(d, a, b, c, fillTab[offset + 12], S32, 0xe6db99e5)           c = HH(c, d, a, b, fillTab[offset + 15], S33, 0x1fa27cf8)           b = HH(b, c, d, a, fillTab[offset + 2], S34, 0xc4ac5665)           a = II(a, b, c, d, fillTab[offset + 0], S41, 0xf4292244)           d = II(d, a, b, c, fillTab[offset + 7], S42, 0x432aff97)           c = II(c, d, a, b, fillTab[offset + 14], S43, 0xab9423a7)           b = II(b, c, d, a, fillTab[offset + 5], S44, 0xfc93a039)           a = II(a, b, c, d, fillTab[offset + 12], S41, 0x655b59c3)           d = II(d, a, b, c, fillTab[offset + 3], S42, 0x8f0ccc92)           c = II(c, d, a, b, fillTab[offset + 10], S43, 0xffeff47d)           b = II(b, c, d, a, fillTab[offset + 1], S44, 0x85845dd1)           a = II(a, b, c, d, fillTab[offset + 8], S41, 0x6fa87e4f)           d = II(d, a, b, c, fillTab[offset + 15], S42, 0xfe2ce6e0)           c = II(c, d, a, b, fillTab[offset + 6], S43, 0xa3014314)           b = II(b, c, d, a, fillTab[offset + 13], S44, 0x4e0811a1)           a = II(a, b, c, d, fillTab[offset + 4], S41, 0xf7537e82)           d = II(d, a, b, c, fillTab[offset + 11], S42, 0xbd3af235)           c = II(c, d, a, b, fillTab[offset + 2], S43, 0x2ad7d2bb)           b = II(b, c, d, a, fillTab[offset + 9], S44, 0xeb86d391)           result[1] = result[1] + a           result[2] = result[2] + b           result[3] = result[3] + c           result[4] = result[4] + d           result[1] = result[1] & 0xffffffff           result[2] = result[2] & 0xffffffff           result[3] = result[3] & 0xffffffff           result[4] = result[4] & 0xffffffff         end         local retStr = ''         for i = 1,4 do           for _ = 1,4 do             local temp = result[i] & 0x0F             local str = HexTable[temp + 1]             result[i] = result[i] >> 4             temp = result[i] & 0x0F             retStr = retStr .. HexTable[temp + 1] .. str             result[i] = result[i] >> 4           end         end         return string.lower(retStr)       end       return getmd5(code)     end
--md5加密 md5("加密内容")

ZZRc4 = {} 
ZZMathBit = {} 
function ZZMathBit.__xorBit(left, right)       return (left + right) == 1 and 1 or 0 end function ZZMathBit.__base(left, right, op)       if left < right then           left, right = right, left       end       local res = 0       local shift = 1       while left ~= 0 do           local ra = left % 2           local rb = right % 2           res = shift * op(ra,rb) + res           shift = shift * 2           left = math.modf( left / 2)           right = math.modf( right / 2)       end       return res end function ZZMathBit.xorOp(left, right)       return ZZMathBit.__base(left, right, ZZMathBit.__xorBit) end function RC4(text,key,kasi)
if kasi==false then      str = text      str=str:gsub("[%s%p]",""):upper()       local index=1       local ret=""       for index=1,str:len(),2 do         ret=ret..string.char(tonumber(str:sub(index,index+1),16))       end       text=ret     end          local function KSA(key)           local keyLen = string.len(key)           local schedule = {}           local keyByte = {}           for i = 0, 255 do               schedule[i] = i           end              for i = 1, keyLen do               keyByte[i - 1] = string.byte(key, i, i)           end              local j = 0           for i = 0, 255 do               j = (j + schedule[i] + keyByte[ i % keyLen]) % 256               schedule[i], schedule[j] = schedule[j], schedule[i]           end           return schedule       end          local function PRGA(schedule, textLen)           local i = 0           local j = 0           local k = {}           for n = 1, textLen do               i = (i + 1) % 256               j = (j + schedule[i]) % 256               schedule[i], schedule[j] = schedule[j], schedule[i]               k[n] = schedule[(schedule[i] + schedule[j]) % 256]           end           return k       end          local function output(schedule, text)           local len = string.len(text)           local c = nil           local res = {}           for i = 1, len do               c = string.byte(text, i,i)               res[i] = string.char(ZZMathBit.xorOp(schedule[i], c))           end           return table.concat(res)       end          local textLen = string.len(text)       local schedule = KSA(key)       local k = PRGA(schedule, textLen)          str=output(k, text) if kasi==true then       str = tostring(str)       local index=1       local ret=""       for index=1,str:len() do         ret=ret..string.format("%02X",str:sub(index):byte())       end       return string.lower(ret) else     return str end end 
--极简云RC42加密和解密配置     RC4("加密内容","密码",false=解密_true=加密)

function ultra(get,post)    local c=gg.makeRequest(get,nil,post).content     return c  end 
--请求

---[=[上面不要乱动]=]-------------------------------------------------------------------------------------------------------------------


---[=[下方为后台配置]=]-------------------------------------------------------------------------------------------------------------------

xxxxxxx="https://yz.52tyun.com"
local xxxxxxx_Kami=xxxxxxx.."/api.php?api=kmlogon"
--接口名称[卡密登录]

local xxxxxxx_jieba=xxxxxxx.."/api.php?api=kmunmachine"
--接口名称[卡密解绑]

local xxxxxxx_to_configure=xxxxxxx.."/api.php?api=ini"
--接口名称[应用配置]

local xxxxxxx_Notice=xxxxxxx.."/api.php?api=notice"
--接口名称[应用公告]

local xxxxxxx_RC4=true
--是否 RC4 加密[false=关 true=开] 
--选择 RC4加密-2 否则会乱码 
--打开 签名放DATA里:打开


local xxxxxxx_APPID="24802
--APPID

local xxxxxxx_APPKEY="yy641i1n41Y3IyiZ"
--APPKEY

local xxxxxxx_RC4_key="4zSFv4r75V724802"
--是否 RC4 加密[key 密钥]


local xxxbanb=""
--1.0

local xxxQQ="536100056"
--作者QQ


if xxxxxxx_APPID=="" or xxxxxxx_RC4_key=="" or xxxxxxx_APPKEY=="" then
gg.alert("关键东西没填，运行啥啊？")--对话框
os.exit() 
end


FILES_DIR="/sdcard/Android/"
--卡密 设备码 路径


---[=[   ↑配置  ]=]-------------------------------------------------------------------------------------------------------------------

Notice=ultra(xxxxxxx_Notice.."&app=".. xxxxxxx_APPID,"")

No=Notice:match('"code":(.-),')
if  No ~= nil then 
No=Notice:match('"msg":"(.-)",')
if No==nil then
xxxxxxx_RC4=false--判定是否关闭
else
gg.alert("公告接口："..No)--对话框
os.exit() 
end
end

if  xxxxxxx_RC4 == true then 
Notice=RC4(Notice,xxxxxxx_RC4_key,false) 
end


Notice=Notice:match('"app_gg":"(.-)",')--获取公告
if Notice==nil then
No=Notice:match('"code":(.-),')
if  No ~= nil then 
No=Notice:match('"msg":"(.-)",')
if No==nil then
xxxxxxx_RC4=false--判定是否关闭
else
gg.alert("公告接口："..No)--对话框
os.exit() 
end
end

else
if Notice~="" then
gg.alert(Notice,"确定")--对话框
end
end

---[=[上面是公告]=]-------------------------------------------------------------------------------------------------------------------

xxcisu="无法获取"
gongxing=ultra(xxxxxxx_to_configure.."&app=".. xxxxxxx_APPID,"")


No=gongxing:match('"code":(.-),')
if  No ~= nil then 
No=gongxing:match('"msg":"(.-)",')
if No==nil then
xxxxxxx_RC4=false--判定是否关闭
else
gg.alert("应用配置接口："..No)--对话框
os.exit() 
end
end

if  xxxxxxx_RC4 == true then 
gongxing=RC4(gongxing,xxxxxxx_RC4_key,false) 
end

xxxxbanben=gongxing:match('"version":"(.-)",')--获取版本号
xxxxgxnr=gongxing:match('app_update_show":"(.-)",')--更新内容
xxxxlianjie=gongxing:match('app_update_url":"(.-)","app_update_must')--更新链接
xxcisu=gongxing:match('"api_total":"(.-)"}')--启动次数

if gongxing==nil then

No=gongxing:match('"code":(.-),')
if  No ~= nil then 
No=gongxing:match('"msg":"(.-)",')
if No==nil then
xxxxxxx_RC4=false--判定是否关闭
else
gg.alert("应用配置接口："..No)--对话框
os.exit() 
end
end

else

if xxxxbanben==xxxbanb then
gg.toast("最新版本")--提示 
else
if xxxxlianjie=="未提交URL" then
print("\n没有要更新的链接\n请联系作者:"..xxxQQ)
os.exit() 
end
bhh=gg.alert("发现新版本，请更新内容 ","开始下载","浏览器更新")--对话框

if xxxxbanben == xxxbanb then

xxxxlianjie=gg.makeRequest(xxxxlianjie).content
io.open("/storage/emulated/0/最新版本.lua","w+"):write(xxxxlianjie)--写
gg.setVisible(true)
print("---[=[ 下载成功]=]---------------\n\n[新版本]:\n"..xxxxbanben.."\n\n[更新内容]:\n"..xxxxgxnr.."\n\n[新脚本路径]:\n/storage/emulated/0/最新版本.lua\n")--打印
 elseif bhh == 2 then
gg.setVisible(true)
print("\n[新版本]:\n"..xxxxbanben.."\n\n[更新内容]:\n"..xxxxgxnr.."\n\n[更新链接]:\n"..xxxxlianjie)--打印 end
os.exit() 
end
end

end
---[=[获取更新↑]=]-------------------------------------------------------------------------------------------------------------------


function yanzzzzz(km,sbm)

key=md5("kami="..km.."&markcode="..sbm.."&t="..os.time().."&".. xxxxxxx_APPKEY)
--计算签名

Random=md5(RC4(os.time().."极简云",xxxxxxx_RC4_key,true)..xxxxxxx_APPKEY..sbm)
--随机[用来计算是否相等]

bops="kami="..km.."&markcode="..sbm.."&t="..os.time().."&sign="..key
--需要请求的数据

if  xxxxxxx_RC4 == true then
bops="data="..RC4(bops,xxxxxxx_RC4_key,true)
end-- 把请求数据用RC4加密

HUT=ultra(xxxxxxx_Kami.."&app=".. xxxxxxx_APPID,bops.."&value="..Random)
--请求数据


if HUT~=nil then
if  xxxxxxx_RC4 == true then
HUT=RC4(HUT,xxxxxxx_RC4_key,false) 
end-- 把返回的数据用RC4解密

qued=HUT:match('code":(.-),')--获取编号 200是成功
vip=HUT:match('vip":"(.-)"},')--获取 卡密时间
yanzen=HUT:match('check":"(.-)"')--获取随机值
tinme=HUT:match('time":(.-),')--获取时间搓
fanhui=HUT:match('msg":"(.-)",')--获取错误

if qued~="200" then
gg.alert(fanhui)--返回错误
io.open(FILES_DIR.."/km","w"):write("")--写
else

if (tinme-os.time())>10 or (tinme-os.time())<-10 then
gg.setVisible(false)
gg.toast("\n(▔_▔) 数据超时！")
else--时间10小于就跳转

if yanzen~=md5(tinme..xxxxxxx_APPKEY..Random) then
gg.setVisible(false)
gg.toast("\n️(▔_▔) 请不要修改数据！")
else--网络数据是否修改

gg.setVisible(false)
vip1=os.date("%Y".."年".."%m".."月".."%d".."日".."\r".."%H".."时".."%M".."分".."%S".."秒\n",vip)
io.open(FILES_DIR.."/km","w"):write(km)--写
kll=gg.alert("\n登入成功:\n\n[到期时间]\n"..vip1,"确定","返回")--提示--获取到期时间
if kll==2 then
io.open(FILES_DIR.."/lko","w"):write("false")--写
oqvqo(xxxxxxx)
end


ab22a390752305680f3da8a1de1bfbf87e(vip)--
--登入成功后的动作------------------------------------------------------------------------------------------------------------------


end
end
end
else
gg.setVisible(false)
gg.toast("\n️(▔_▔) 请检查网络！")
end

end


---[=[  卡密登入↑ ]=]-------------------------------------------------------------------------------------------------------------------

function jiebang(km,sbm)
gg.setVisible(false)
key=md5("kami="..km.."&markcode="..sbm.."&t="..os.time().."&".. xxxxxxx_APPKEY)

bops="kami="..km.."&markcode="..sbm.."&t="..os.time().."&sign="..key

if  xxxxxxx_RC4 == true then
bops= "data="..RC4(bops,xxxxxxx_RC4_key,true) 
end


HUT=ultra(xxxxxxx_jieba.."&app=".. xxxxxxx_APPID,bops)

if  xxxxxxx_RC4 == true then
HUT=RC4(HUT,xxxxxxx_RC4_key,false) 
end-- xxxxxxx_Base64

qued=HUT:match('code":(.-),')
fanhui=HUT:match('msg":"(.-)",')
yanzen=HUT:match('check":"(.-)"')
tinme=HUT:match('time":(.-),')
gg.toast(fanhui)

end

---[=[  解绑卡密↑ ]=]-------------------------------------------------------------------------------------------------------------------



rq=os.date("%Y".."年".."%m".."月".."%d".."日".." ".."%H".."时".."%M".."分".."%S".."秒")
local a={}
fien={io.open(FILES_DIR.."/km","r"),io.open(FILES_DIR.."/miux","r"),io.open(FILES_DIR.."/lko","r")}

if fien[1]==nil then
io.open(FILES_DIR.."/km","w"):write("")--写
a[1]=io.open(FILES_DIR.."/km","r"):read("*a")--读
else
a[1]=io.open(FILES_DIR.."/km","r"):read("*a")--读
end--fien[1]--卡密

if fien[2]==nil then
io.open(FILES_DIR.."/miux","w"):write(md5(rq))--写
a[2]=io.open(FILES_DIR.."/miux","r"):read("*a")--读
else
a[2]=io.open(FILES_DIR.."/miux","r"):read("*a")--读
end--fien[2]--机器码

fien2=io.open(FILES_DIR.."/miux","r"):read("*a")--读
if fien2=="" then
io.open(FILES_DIR.."/miux","w"):write(md5(rq))--写
fien2=io.open(FILES_DIR.."/miux","r"):read("*a")--读
a[2]=fien2
end

if fien[3]==nil then
io.open(FILES_DIR.."/lko","w"):write("false")--写
a[3]=io.open(FILES_DIR.."/lko","r"):read("*a")--读
else
a[3]=io.open(FILES_DIR.."/lko","r"):read("*a")--读
end--fien[2]--机器码

fien3=io.open(FILES_DIR.."/lko","r"):read("*a")--读
if fien3=="" then
io.open(FILES_DIR.."/lko","w"):write("false")--写
fien3=io.open(FILES_DIR.."/lko","r"):read("*a")--读
a[3]=fien3
end

sbm=a[2]--设备码
km=a[1]--卡密

--判定自动登入
if a[3]=="true" then
a[3]=true
elseif a[3]=="false" then
a[3]=false
end



if a[3]==true then
yanzzzzz(a[1],sbm)
end


hak=gg.prompt({
'[输入: 1 开始解绑卡密]\n[输入: 2 邮箱反馈]\n现在时间:'..rq.."\n[本脚本使用："..xxcisu.." 次]\n请输入卡密：",
"[自动登入]"
},{
km,
a[3]
},{
'text',--文字
'checkbox',--多选
})--文本功能



if hak==nil then
gg.setVisible(false)
gg.toast("取消……")--提示
elseif hak[1]=="1" then---[=[ ↓解绑  ]=]-------------------------------------------------------------------------------------------------------------------

gg.toast("开始解绑卡密……")--提示
hak2=gg.prompt({
'现在时间:'..rq.."\n请输入解绑卡密："
},{
},{
'text',--文字
})--文本功能

if hak2==nil then
gg.setVisible(false)
gg.toast("取消……")--提示
else
jiebang(hak2[1],sbm)
---[=[  ↑ 输入卡密跳转解绑卡密  ]=]-------------------------------------------------------------------------------------------------------------------
end

elseif hak[1]=="2" then ---[=[  ↓ 邮箱反馈 ]=]-------------------------------------------------------------------------------------------------------------------
if xxxQQ=="" then
gg.alert("作者没有填写QQ")
else

b=gg.prompt({
"联系方式(QQ或网名,手机号等)",
"反馈内容",
"取消就是[返回主页面]",
},{
"",
"",
true
},{
'text',
'text',
'checkbox',
})

if b ==nil then
gg.setVisible(false)
gg.toast("取消……")--提示
else


if b[1] ~= "" then
if b[2] ~= "" then
bh="&name="..b[1].."&certno="..b[2]
b=gg.makeRequest(xxxxxxx.."/api/mail/api.php?address="..xxxQQ.."@qq.com"..bh)
if b.code=="200" then
gg.alert("反馈成功[谢谢你的支持]")
else
gg.alert("反馈失败")
end
else
gg.alert("空内容")
end
else
gg.alert("空联系方式")
end
end
end
---[=[ ↘你们可以自己加购卡 加群什么的  ]=]-------------------------------------------------------------------------------------------------------------------
--elseif hak[1]=="3" then 输入3 干啥干啥





else---[=[  ↓卡密登入  ]=]-------------------------------------------------------------------------------------------------------------------

if hak[2]==true then
io.open(FILES_DIR.."/lko","w"):write("true")--写
elseif hak[2]==false then
io.open(FILES_DIR.."/lko","w"):write("false")--写
end

yanzzzzz(hak[1],sbm)
---[=[  ↑ 输入卡密跳转登入卡密  ]=]-------------------------------------------------------------------------------------------------------------------
end
