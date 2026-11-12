--// Services
const Players = game:GetService("Players")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const HUD = require(ReplicatedStorage.Client.UI.HUD["HUD.fusion"])
const HUDViewModel = require(ReplicatedStorage.Client.UI.HUD.HUDViewModel)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Knit = require(ReplicatedStorage.Packages.Knit)
const Children = Fusion.Children

local HUDController = {
	Name = "HUDController",
	ViewModel = nil :: HUDViewModel.ViewModel?,
}
export type HUDController = typeof(HUDController)

function HUDController.KnitStart(self: HUDController): ()
	const shopController = Knit.GetController("ShopController")

	const vm = HUDViewModel.new({
		ToggleShop = function()
			shopController:Toggle()
		end,
	})
	self.ViewModel = vm

	vm.Scope:New "ScreenGui" {
		Name = "HUD",
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			HUD({
				ViewModel = vm,
			}),
		},
	}
end

return HUDController
