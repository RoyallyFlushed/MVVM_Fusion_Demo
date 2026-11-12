--!strict

--// Services
const Players = game:GetService("Players")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Shop = require(ReplicatedStorage.Client.UI.Shop["Shop.fusion"])
const ShopViewModel = require(ReplicatedStorage.Client.UI.Shop.ShopViewModel)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children

local ShopController = {
	Name = "ShopController",
	ViewModel = nil :: ShopViewModel.ViewModel?,
}
export type ShopController = typeof(ShopController)

function ShopController.KnitStart(self: ShopController): ()
	const vm = ShopViewModel.new({
		IsVisible = true,
	})
	self.ViewModel = vm

	vm.Scope:New "ScreenGui" {
		Name = "Shop",
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 10,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			Shop({
				ViewModel = vm,
			}),
		},
	}
end

function ShopController.Show(self: ShopController): ()
	if self.ViewModel then
		self.ViewModel:Show()
	end
end

function ShopController.Hide(self: ShopController): ()
	if self.ViewModel then
		self.ViewModel:Hide()
	end
end

function ShopController.Toggle(self: ShopController): ()
	if self.ViewModel then
		self.ViewModel:Toggle()
	end
end

return ShopController
