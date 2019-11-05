r = game:service("RunService")

shaft = script.Parent
position = Vector3.new(0,0,0)
debris = game:GetService("Debris")

function tagHumanoid(humanoid)
	-- todo: make tag expire
	local tag = shaft:findFirstChild("creator")
	if tag ~= nil then
		-- kill all other tags
		while(humanoid:findFirstChild("creator") ~= nil) do
			humanoid:findFirstChild("creator").Parent = nil
		end

		local new_tag = tag:clone()
		new_tag.Parent = humanoid
		debris:AddItem(new_tag, 1)
	end
end

local function onExplosionHit(hit)
	local char = hit.Parent
	if char then
		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			tagHumanoid(humanoid)
		end
	end
end

function fly()
	direction = shaft.CFrame.lookVector
	position = position + direction
	error = position - shaft.Position
	shaft.Velocity = 7*error
end

function blow()
	swoosh:Stop()
	explosion = Instance.new("Explosion")
	explosion.Position = shaft.Position
	explosion.Parent = game.Workspace
	explosion.Hit:Connect(onExplosionHit)
	connection:disconnect()
	shaft.Explosion:Play()
	shaft.Anchored = true
	shaft.CanCollide = false
	shaft.Transparency = 1
	
	shaft.Explosion:Play()
	shaft.Explosion.Ended:Wait()
	shaft:Destroy()
end

t, s = r.Stepped:wait()

swoosh = script.Parent.Swoosh
swoosh:Play()

position = shaft.Position
d = t + 10.0 - s
connection = shaft.Touched:connect(blow)

while t < d do
	fly()
	t = r.Stepped:wait()
end

swoosh:Stop()
shaft:remove()
