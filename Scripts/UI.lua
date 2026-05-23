
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Config = require(script.Parent.Config)
local LockOn = require(script.Parent.LockOn)

local UI = {}

function UI:Create()

	local gui = Instance.new("ScreenGui")
	gui.Name = "DragonWaveUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	-- MAIN BUTTON

	local button = Instance.new("TextButton")
	button.Parent = gui

	button.Size = UDim2.new(0,140,0,55)
	button.Position = UDim2.new(0.75,0,0.82,0)

	button.BackgroundColor3 = Color3.fromRGB(20,20,20)
	button.TextColor3 = Color3.new(1,1,1)

	button.TextScaled = true
	button.Font = Enum.Font.GothamBold
	button.Text = Config.ButtonText

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = button

	--================ DRAG SYSTEM =================--

	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)

		local delta = input.Position - dragStart

		button.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	button.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

			dragging = true
			dragStart = input.Position
			startPos = button.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	button.InputChanged:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)

		if input == dragInput and dragging then
			update(input)
		end
	end)

	--================ LOCK BUTTON =================--

	button.MouseButton1Click:Connect(function()

		LockOn:Toggle()

		if LockOn.Locked then
			button.Text = Config.UnlockText
		else
			button.Text = Config.ButtonText
		end
	end)
end

return UI
