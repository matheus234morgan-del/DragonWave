
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Config = require(script.Parent.Config)

local LockOn = {}

LockOn.Locked = false
LockOn.Target = nil

local function getRoot(model)
	return model and model:FindFirstChild("HumanoidRootPart")
end

function LockOn:GetClosestTarget()

	local closest = nil
	local shortest = Config.LockDistance

	local character = player.Character
	if not character then return nil end

	local myRoot = getRoot(character)
	if not myRoot then return nil end

	for _, obj in pairs(workspace:GetDescendants()) do

		if obj:IsA("Model") then

			local humanoid = obj:FindFirstChildOfClass("Humanoid")
			local root = getRoot(obj)

			if humanoid and root and obj ~= character then

				if humanoid.Health > 0 then

					local distance =
						(root.Position - myRoot.Position).Magnitude

					if distance < shortest then
						shortest = distance
						closest = obj
					end
				end
			end
		end
	end

	return closest
end

function LockOn:Toggle()

	if self.Locked then

		self.Locked = false
		self.Target = nil

	else

		local target = self:GetClosestTarget()

		if target then
			self.Locked = true
			self.Target = target
		end
	end
end

RunService.RenderStepped:Connect(function()

	if LockOn.Locked and LockOn.Target then

		local character = player.Character
		if not character then return end

		local myRoot = getRoot(character)
		local enemyRoot = getRoot(LockOn.Target)

		if myRoot and enemyRoot then

			local cameraPos =
				myRoot.Position
				- (enemyRoot.CFrame.LookVector * Config.CameraDistance)
				+ Vector3.new(0, Config.CameraHeight, 0)

			camera.CFrame = camera.CFrame:Lerp(
				CFrame.new(cameraPos, enemyRoot.Position),
				Config.Smoothness
			)
		end
	end
end)

return LockOn
