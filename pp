-- Tải Fluent UI Library
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
-- Âm thanh khởi động
local startupSound = Instance.new("Sound")
startupSound.SoundId = "rbxassetid://8594342648"
startupSound.Volume = 5000 -- Điều chỉnh âm lượng nếu cần
startupSound.Looped = false -- Không lặp lại âm thanh
startupSound.Parent = game.CoreGui-- Đặt parent vào CoreGui để đảm bảo âm thanh phát
startupSound:Play() -- Phát âm thanh khi script chạy
-- Tạo cửa sổ chính
local Window = Library:CreateWindow{
    Title = "Tuấn Anh DepZai",
    SubTitle = "discord.gg/tEeQZXtEZv",
    TabWidth = 160,
    Size = UDim2.fromOffset(1280, 860),
    Resize = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Phím thu nhỏ
}

-- Tạo ScreenGui chứa nút điều khiển
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGUI"
screenGui.Parent = game.CoreGui

-- Tạo nút (ImageButton)
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 45, 0, 45) -- Kích thước nhỏ, hình vuông
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Gần góc trái trên
toggleButton.Image = "rbxassetid://124229496087770" -- Hình ảnh của nút
toggleButton.BackgroundTransparency = 1 -- Không có nền
toggleButton.Parent = screenGui

-- Biến lưu trạng thái hiển thị Fluent UI
local isFluentVisible = true

-- Di chuyển nút
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Ẩn/Hiện Fluent UI khi nhấn nút
toggleButton.MouseButton1Click:Connect(function()
    isFluentVisible = not isFluentVisible

    if isFluentVisible then
        -- Hiện Fluent UI
        Window:Minimize(false) -- Mở lại cửa sổ
    else
        -- Ẩn Fluent UI
        Window:Minimize(true) -- Thu nhỏ cửa sổ
    end
end)

-- Tạo các tab
local TanhTab = Window:AddTab({ Title = "Discord", Icon = "" })
local ChestTab = Window:AddTab({ Title = "Main", Icon = "" })
local FixTab = Window:AddTab({ Title = "Fix Lag", Icon = "" })
local OtherTab = Window:AddTab({ Title = "Khác", Icon = "" })
local FruitTab = Window:AddTab({ Title = "Fruit", Icon = "" }) -- Tab Fruit mới

-- Biến toàn cục
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Fluent = Library -- Gán biến Fluent

local currentTween = nil
local leviathanGateConnection = nil
local rockConnection = nil -- No longer used for DescendantAdded
local scriptEnabled = false
local lockHeightMode = true
local destroyRockMode = false
local customY = 100
local tweenSpeed = 350
local minimized = false
local lastBoat, lastSeat = nil, nil
local playerTweening = false -- Khôi phục biến playerTweening
local autoReturnEnabled = false
local killAuraEnabled = false
local killAuraRange = 100
local selectedIslandCoord = nil
local islandTweening = false
local boatProtectImmediateEnabled = false
-- Hàm Kill Aura
local function killAuraLoop()
    local monstersFolder = Workspace:FindFirstChild("Enemies")
    while killAuraEnabled do
        task.wait(1)
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp or not monstersFolder then continue end

        for _, monster in pairs(monstersFolder:GetChildren()) do
            local hum = monster:FindFirstChild("Humanoid")
            local mrp = monster:FindFirstChild("HumanoidRootPart")
            if hum and mrp and hum.Health > 0 then
                local distance = (mrp.Position - hrp.Position).Magnitude
                if distance <= killAuraRange then
                    hum.Health = 0
                end
            end
        end
    end
end

-- Find Fruit
local fruitsESP = {}
local findFruitEnabled = false
local function createESP(fruit)
    if not fruit:FindFirstChild("Handle") then return end

    if fruitsESP[fruit] then
        fruitsESP[fruit]:Destroy()
        fruitsESP[fruit] = nil
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = fruit.Handle
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = fruit.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextScaled = true

    billboard.Parent = fruit
    fruitsESP[fruit] = billboard
end

local function findFruits()
    local fruits = {}
    for _, object in pairs(workspace:GetChildren()) do
        if object:IsA("Tool") and object.Name:lower():find("fruit") then
            table.insert(fruits, object)
            if findFruitEnabled then
                createESP(object)
            end
        end
    end
    return fruits
end

local function teleportToFruit(fruit)
    if fruit and fruit:FindFirstChild("Handle") then
        if findFruitEnabled then
            LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
        end
    end
end

local runService = game:GetService("RunService")
runService.Heartbeat:Connect(function()
    local fruits = findFruits()
    if #fruits > 0 then
        for _, fruit in pairs(fruits) do
            if fruit.Parent == workspace then
                teleportToFruit(fruit)
                wait(1)
            end
        end
    end
end)

workspace.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child.Name:lower():find("fruit") then
        wait(0.5)
        if findFruitEnabled then
            createESP(child)
        end
        teleportToFruit(child)
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if fruitsESP[child] then
        fruitsESP[child]:Destroy()
        fruitsESP[child] = nil
    end
end)

TanhTab:AddButton({
    Title = "discord.gg/tEeQZXtEZv",
    Description = "Nhấn để copy link Discord",
    Callback = function()
        setclipboard("https://discord.gg/tEeQZXtEZv")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Thông báo",
            Text = "Đã sao chép link Discord!",
            Duration = 3
        })
    end
})
TanhTab:AddButton({
    Title = "Phở Bò:Tuấn Anh",
    Description = "Nhấn để copy link FaceBook",
    Callback = function()
        setclipboard("https://www.facebook.com/tuanangg10")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Thông báo",
            Text = "Đã sao chép link FaceBook!",
            Duration = 3
        })
    end
})
-- Tab Chest
ChestTab:AddToggle("Kill Aura", {
    Title = "Haki Bá Vương",
    Description = "Bật/Tắt Haki Bá Vương",
    Callback = function(Value)
        killAuraEnabled = Value
        if killAuraEnabled then
            task.spawn(killAuraLoop)
        end
    end
})
ChestTab:AddToggle("TuanAnhIOS_Toggle", {
    Title = "Auto Nhặt Rương",
    Description = "Bật Tắt Tuấn Anh DepZai✅",
    Callback = function(value)
        _G.TuanAnhIOS_Enabled = value

        if value then
            -- Bật script (chạy trên luồng riêng)
            ScriptThread = task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/AutoChest/refs/heads/main/AutoChestTuanAnhIOS.Lua"))()
            end)
        else
            -- Dừng script bằng cách hủy luồng
            if ScriptThread then
                task.cancel(ScriptThread)
                ScriptThread = nil
            end
        end
    end
})
OtherTab:AddButton({
    Title = "Hop Sever",
    Description = "Đổi Sever✅",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
OtherTab:AddButton({
    Title = "Vào Lại Sever",
    Description = "Tham Gia Lại Sever✅",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
OtherTab:AddButton({
    Title = "Hop Sever Ít Người",
    Description = "Đổi Sever✅",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
ChestTab:AddToggle("TuanAnhIOS_Toggle", {
    Title = "Click Đánh Quái",
    Description = "Bật/Tắt Click Đánh",
    Callback = function(value)
        _G.TuanAnhIOS_Enabled = value

        if value then
            -- Bật script (chạy trên luồng riêng)
            ScriptThread = task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/Click/refs/heads/main/ClickDanh"))()
            end)
        else
            -- Dừng script bằng cách hủy luồng
            if ScriptThread then
                task.cancel(ScriptThread)
                ScriptThread = nil
            end
        end
    end
})
FixTab:AddButton({
    Title = "Xoá Sương Mù",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/XoaSuongMu/refs/heads/main/SuongMu.lua"))()
    end
})
FruitTab:AddButton({
    Title = "Mưa Khói",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
FruitTab:AddButton({
    Title = "Mưa Trái",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
ChestTab:AddButton({
    Title = "Trade Scam",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
FixTab:AddButton({
    Title = "Fix Lag",
    Description = "Để Treo Game",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/FixLagFull/refs/heads/main/FixlagVipTanh"))()
    end
})
FruitTab:AddButton({
    Title = "Haki Màu",
    Description = "Mua Haki Màu Hồng",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/ScriptMaru/refs/heads/main/MaruHubPremium.Lua"))()
    end
})
-- Tab Fruit
FruitTab:AddToggle("Find Fruit", {
    Title = "Nhặt Trái",
    Description = "Nhặt Trái Trong Sever+ Esp fruit",
    Callback = function(Value)
        findFruitEnabled = Value
        if not findFruitEnabled then
            local fruits = findFruits()
            for _, fruit in ipairs(fruits) do
                if fruitsESP[fruit] then
                    fruitsESP[fruit]:Destroy()
                    fruitsESP[fruit] = nil
                end
            end
        end
    end
})

-- Auto Random Fruit Toggle
FruitTab:AddToggle("Auto Random Fruit", {
    Title = "Auto Random Fruit",
    Description = "Bật Tắt Random Trái",
    Callback = function(state)
        _G.Random_Auto = state
        if state then
            task.spawn(function()
                pcall(function()
                    while _G.Random_Auto do
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy") -- Mua random fruit
                    end
                end)
            end)
        else



            _G.Random_Auto = false -- Ensure to set _G.Random_Auto to false when disabling
        end
    end
})

-- Hàm để đóng hoặc thu nhỏ cửa sổ (toggle)
local minimized = false
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        Window:SetSize(UDim2.fromOffset(160, 60)) -- Adjust for a smaller minimized size
        Window:SetProperty("Acrylic", false)

        -- Ẩn tất cả các tab
        for _, tab in ipairs(Window:GetTabs()) do
            tab:SetProperty("Visible", false)
        end

        Window.TitleBar:SetProperty("Visible", false)
        Window.SubTitleLabel:SetProperty("Visible", false)

    else
        Window:SetSize(UDim2.fromOffset(580, 460)) -- Restore original size
        Window:SetProperty("Acrylic", true)
        for _, tab in ipairs(Window:GetTabs()) do
            tab:SetProperty("Visible", true)
        end

        Window.TitleBar:SetProperty("Visible", true)
        Window.SubTitleLabel:SetProperty("Visible", true)
    end
end
Window.MinimizeKeybind = toggleMinimize
while true do task.wait(0.00001) 
print("Ey yo skider")
end
