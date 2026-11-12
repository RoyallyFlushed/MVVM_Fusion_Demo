--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")

--// Modules
const KnitUtil = require(ReplicatedStorage.Shared.Modules.KnitUtil)

--// Packages
const Packages = ReplicatedStorage.Packages
const Knit = require(Packages.Knit)

-- Add controllers
KnitUtil.AddControllers(ReplicatedStorage.Client.Controllers)

-- Start Knit
Knit.Start()
	:andThen(function()
		-- Debug
		if RunService:IsStudio() then
			print("[Knit.Client]: Started!")
		end
	end)
	:catch(function(err)
		warn("[Knit.Client]: Failed to start:", err)
	end)
