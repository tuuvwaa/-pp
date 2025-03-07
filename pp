local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/GiaoDien/refs/heads/main/AnhTuanIOS"))()
local Window = redzlib:MakeWindow({
  Title = "Tuấn Anh IOS",
  SubTitle = "Discord.gg/MkpDxJVTyb",
})

local AFKOptions = {}

local Discord = Window:MakeTab({"Discode", "info"})
Discord:AddDiscordInvite({
  Name = "Tham Gia Discode",
  Description = "Discode Đây Cu",
  Logo = "rbxassetid://112455697889846",
  Invite = "https://discord.gg/MkpDxJVTyb"
})
local Discord = Window:MakeTab({"Facebook", "info"})
Discord:AddDiscordInvite({
  Name = "Tuấn Anh",
  Description = "Phở Bò Đó Cu",
  Logo = "rbxassetid://112455697889846",
  Invite = "https://www.facebook.com/tuanangg10"
})
local Tab = Window:MakeTab({"Script Hot Nhất",
	Icon = "rbxassetid://10723407389",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Redz Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
  	end    
})
Tab:AddButton({
	Name = "w-azure",
	Callback = function()
       loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
  	end    
})
Tab:AddButton({
	Name = "Xero Hub",
	Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"))()
  	end    
})
Tab:AddButton({
	Name = "Zenith Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script"))()
  	end    
})
Tab:AddButton({
	Name = "Bắp Red Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/BapRed/main/BapRedHub"))()
  	end    
})
Tab:AddButton({
	Name = "Trẩu Roblox",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/TrauHub/refs/heads/main/TrauV1"))()
  	end    
})
Tab:AddButton({
	Name = "Zis Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/giaotrinhhoc/ZisRb/refs/heads/main/ZisRbV5"))()
  	end    
})
Tab:AddButton({
	Name = "Quantum Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua"))()
  	end    
})
Tab:AddButton({
	Name = "Cokka Hub",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua"))()
  	end    
})
Tab:AddButton({
	Name = "HoHo Hub Phải Get Key",
	Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
  	end    
})
local Tab4 = Window:MakeTab({"Script Premium Free",
	Icon = "rbxassetid://10709761889",
	PremiumOnly = false
})
Tab4:AddButton({
	Name = "Cụt Tay Hub Auto Mirage",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/a1498369f289af2671cca90085f23fb8.lua"))()
	end
})
Tab4:AddButton({
	Name = "KaiTan Premium",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/simple-hubs/contents/refs/heads/main/bloxfruit-kaitan-main.lua"))()
	end
})
Tab4:AddButton({
	Name = "Auto Bounty Xero Hub",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/pisovn/OisiRoblox1/refs/heads/main/AutoBountyXero"))()
	end
})
Tab4:AddButton({
	Name = "Fix Lag Premium",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
	end
})
Tab4:AddButton({
	Name = "Aim Buddy Gun|Key:Kao",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaodontsuyy/BloxFruit/refs/heads/main/Kaohub.lua"))()
	end
})
local Tab4 = Window:MakeTab({"Script Banana |Maru",
	Icon = "rbxassetid://10709761889",
	PremiumOnly = false
})
Tab4:AddButton({
	Name = "Maru Hub",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/AutoKick/refs/heads/main/TrollHaHa"))()
	end
})
Tab4:AddButton({
	Name = "Banana Hub",
	Callback = function()
         repeat wait(5) until game:IsLoaded()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/AutoKick/refs/heads/main/TrollHaHa"))()
	end
})

-- Tạo nút bên ngoài để ẩn/hiện hub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleHubGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Tạo ImageButton (nút hình tròn với mũi tên)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Góc trên bên trái
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://112455697889846" -- ID hình ảnh từ hình bạn cung cấp
toggleButton.Parent = screenGui

-- Biến trạng thái
local isVisible = true

-- Thử lấy giao diện chính của redzlib
local mainGui = nil
if Window and typeof(Window) == "table" then
    for k, v in pairs(Window) do
        if v:IsA("ScreenGui") or v:IsA("Frame") then
            mainGui = v
            break
        end
    end
end

if not mainGui then
    warn("Không tìm thấy giao diện chính của redzlib. Vui lòng kiểm tra tài liệu!")
else
    -- Xử lý sự kiện khi nhấn nút
    toggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        if mainGui then
            mainGui.Visible = isVisible -- Sử dụng thuộc tính Visible để ẩn/hiện
            if isVisible then
                toggleButton.Image = "rbxassetid://112455697889846" -- Hiển thị (mũi tên sang phải)
            else
                toggleButton.Image = "rbxassetid://112455697889846" -- Ẩn (mũi tên sang trái)
            end
        end
    end)
end

-- Làm nút có thể kéo thả
local dragging
local dragInput
local dragStart
local startPos

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("
