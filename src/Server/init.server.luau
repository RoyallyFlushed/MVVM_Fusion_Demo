--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")
const ServerScriptService = game:GetService("ServerScriptService")

--// Modules
const KnitUtil = require(ReplicatedStorage.Shared.Modules.KnitUtil)

--// Packages
const Packages = ReplicatedStorage.Packages
const Knit = require(Packages.Knit)

-- Add services
KnitUtil.AddServices(ServerScriptService.Server.Services)

-- Start Knit
Knit.Start()
	:andThen(function()
		-- Debug
		if RunService:IsStudio() then
			print("[Knit.Server]: Started!")
		end
	end)
	:catch(function(err)
		warn("[Knit.Server]: Failed to start:", err)
	end)
