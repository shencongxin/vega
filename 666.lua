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

about:Toggle("💩 自动大的", "Auto BigPoop", false, function(state)
    if state then
        getgenv().autoBigPoop = true
        while getgenv().autoBigPoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("BigPoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoBigPoop = false
    end
end)

about:Button("❄️ 冰", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("IcePoop"):FireServer()
end)

about:Toggle("❄️ 自动冰", "Auto IcePoop", false, function(state)
    if state then
        getgenv().autoIcePoop = true
        while getgenv().autoIcePoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("IcePoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoIcePoop = false
    end
end)

about:Button("📽️ 幻灯片", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("SlidePoop"):FireServer()
end)

about:Toggle("📽️ 自动幻灯片", "Auto SlidePoop", false, function(state)
    if state then
        getgenv().autoSlidePoop = true
        while getgenv().autoSlidePoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("SlidePoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoSlidePoop = false
    end
end)

about:Button("💥 爆炸1", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("Explode"):FireServer()
end)

about:Toggle("💥 自动爆炸1", "Auto Explode", false, function(state)
    if state then
        getgenv().autoExplode = true
        while getgenv().autoExplode do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("Explode"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoExplode = false
    end
end)

about:Button("💣 爆炸2", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ExplosivePoop"):FireServer()
end)

about:Toggle("💣 自动爆炸2", "Auto ExplosivePoop", false, function(state)
    if state then
        getgenv().autoExplosivePoop = true
        while getgenv().autoExplosivePoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ExplosivePoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoExplosivePoop = false
    end
end)

about:Button("🌈 彩虹", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ColorPoop"):FireServer()
end)

about:Toggle("🌈 自动彩虹", "Auto ColorPoop", false, function(state)
    if state then
        getgenv().autoColorPoop = true
        while getgenv().autoColorPoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("ColorPoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoColorPoop = false
    end
end)

about:Button("🔥 火", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
end)

about:Toggle("🔥 自动火", "Auto FirePoop", false, function(state)
    if state then
        getgenv().autoFirePoop = true
        while getgenv().autoFirePoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoFirePoop = false
    end
end)

about:Button("🏀 弹跳", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
end)

about:Toggle("🏀 自动弹跳", "Auto BouncePoop", false, function(state)
    if state then
        getgenv().autoBouncePoop = true
        while getgenv().autoBouncePoop do
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
            end)
            task.wait(0.1)
        end
    else
        getgenv().autoBouncePoop = false
    end
end)

about:Button("✈️ 飞行V3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shencongxin/vega/refs/heads/main/fly%20v3.lua"))()
end)