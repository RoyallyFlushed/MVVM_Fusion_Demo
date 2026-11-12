--[[

    DESC: A utility module for generic functions used on both the server and client
          initialisation process.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")

--// Packages
const Packages = ReplicatedStorage.Packages
const Knit = require(Packages.Knit)

--// Class
const KnitUtil = {}

function KnitUtil.AddServices(folder: Folder)
	assert(RunService:IsServer(), "Attempt to call KnitUtil.AddServices on non-server!")

	for _, service: Instance in folder:GetDescendants() do
		if service:IsA("ModuleScript") and service.Name:upper():match("SERVICE$") then
			Knit.CreateService(require(service))
		end
	end
end

function KnitUtil.AddControllers(folder: Folder)
	assert(RunService:IsClient(), "Attempt to call KnitUtil.AddControllers on non-client!")

	for _, controller: Instance in folder:GetDescendants() do
		if controller:IsA("ModuleScript") and controller.Name:upper():match("CONTROLLER$") then
			Knit.CreateController(require(controller))
		end
	end
end

return KnitUtil
