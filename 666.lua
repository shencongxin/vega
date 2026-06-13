-- 加载你的 UI 库
local library = loadstring(game:HttpGet("https://pastebin.com/raw/nBq2D86q"))()
local win = library.new("Poop Game Hub", "dark")

-- 创建 Poop Game 标签页
local UITab22 = win:Tab("『Poop Game』", "5169151075")
local about = UITab22:section("『Poop Game』", true)

-- 自动发射控制变量
getgenv().autoBigPoop = false
getgenv().autoIcePoop = false
getgenv().autoSlidePoop = false
getgenv().autoExplode = false
getgenv().autoExplosivePoop = false
getgenv().autoColorPoop = false
getgenv().autoFirePoop = false
getgenv().autoBouncePoop = false

-- 手动发射按钮
about:Button("🈲 大的", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("BigPoop"):FireServer()
end)

about:Button("🈲 自动大的 [开/关]", function()
    getgenv().autoBigPoop = not getgenv().autoBigPoop
    if getgenv().autoBigPoop then
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

about:Button("❄️ 自动冰 [开/关]", function()
    getgenv().autoIcePoop = not getgenv().autoIcePoop
    if getgenv().autoIcePoop then
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

about:Button("📽️ 自动幻灯片 [开/关]", function()
    getgenv().autoSlidePoop = not getgenv().autoSlidePoop
    if getgenv().autoSlidePoop then
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

about:Button("💥 自动爆炸1 [开/关]", function()
    getgenv().autoExplode = not getgenv().autoExplode
    if getgenv().autoExplode then
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

about:Button("💣 自动爆炸2 [开/关]", function()
    getgenv().autoExplosivePoop = not getgenv().autoExplosivePoop
    if getgenv().autoExplosivePoop then
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

about:Button("🌈 自动彩虹 [开/关]", function()
    getgenv().autoColorPoop = not getgenv().autoColorPoop
    if getgenv().autoColorPoop then
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

about:Button("🔥 自动火 [开/关]", function()
    getgenv().autoFirePoop = not getgenv().autoFirePoop
    if getgenv().autoFirePoop then
        spawn(function()
            while getgenv().autoFirePoop and task.wait(0.1) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
                end)
            end
        end)
    end
end)

about:Button("☢️ 弹跳", function()
    game:GetService("ReplicatedStorage"):WaitForChild("PoopItems"):WaitForChild("FirePoop"):FireServer()
end)

about:Button("☢️ 自动弹跳 [开/关]", function()
    getgenv().autoBouncePoop = not getgenv().autoBouncePoop
    if getgenv().autoBouncePoop then
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

about:Button("🛑 全部停止", function()
    getgenv().autoBigPoop = false
    getgenv().autoIcePoop = false
    getgenv().autoSlidePoop = false
    getgenv().autoExplode = false
    getgenv().autoExplosivePoop = false
    getgenv().autoColorPoop = false
    getgenv().autoFirePoop = false
    getgenv().autoBouncePoop = false
end)