-- 加载你的 UI 库
local library = loadstring(game:HttpGet("https://pastebin.com/raw/nBq2D86q"))()
local win = library.new("Poop Game Hub", "dark")

-- 创建 Poop Game 标签页
local UITab22 = win:Tab("『Poop Game』", "5169151075")
local about = UITab22:section("『Poop Game』", true)

-- 手动发射按钮
about:Button("💩 大的", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("BigPoop"):FireServer()
end)

about:Toggle("💩 自动大的", "AutoBigPoop", false, function(Value)
    getgenv().autoBigPoop = Value
    if Value then
        spawn(function()
            while getgenv().autoBigPoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("BigPoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("❄️ 冰", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("IcePoop"):FireServer()
end)

about:Toggle("❄️ 自动冰", "AutoIcePoop", false, function(Value)
    getgenv().autoIcePoop = Value
    if Value then
        spawn(function()
            while getgenv().autoIcePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("IcePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("📽️ 幻灯片", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("SlidePoop"):FireServer()
end)

about:Toggle("📽️ 自动幻灯片", "AutoSlidePoop", false, function(Value)
    getgenv().autoSlidePoop = Value
    if Value then
        spawn(function()
            while getgenv().autoSlidePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("SlidePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("💥 爆炸1", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("Explode"):FireServer()
end)

about:Toggle("💥 自动爆炸1", "AutoExplode", false, function(Value)
    getgenv().autoExplode = Value
    if Value then
        spawn(function()
            while getgenv().autoExplode and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("Explode"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("💣 爆炸2", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ExplosivePoop"):FireServer()
end)

about:Toggle("💣 自动爆炸2", "AutoExplosivePoop", false, function(Value)
    getgenv().autoExplosivePoop = Value
    if Value then
        spawn(function()
            while getgenv().autoExplosivePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ExplosivePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("🌈 彩虹", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ColorPoop"):FireServer()
end)

about:Toggle("🌈 自动彩虹", "AutoColorPoop", false, function(Value)
    getgenv().autoColorPoop = Value
    if Value then
        spawn(function()
            while getgenv().autoColorPoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ColorPoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("🔥 火", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
end)

about:Toggle("🔥 自动火", "AutoFirePoop", false, function(Value)
    getgenv().autoFirePoop = Value
    if Value then
        spawn(function()
            while getgenv().autoFirePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("🏀 弹跳", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
end)

about:Toggle("🏀 自动弹跳", "AutoBouncePoop", false, function(Value)
    getgenv().autoBouncePoop = Value
    if Value then
        spawn(function()
            while getgenv().autoBouncePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("✈️ 飞行V3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shencongxin/vega/refs/heads/main/fly%20v3.lua"))()
end)