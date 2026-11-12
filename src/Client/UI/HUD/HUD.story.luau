--// Modules
const HUD = require(script.Parent["HUD.fusion"])
const HUDViewModel = require(script.Parent.HUDViewModel)

return function(root: Instance): () -> ()
	const vm = HUDViewModel.new({
		ToggleShop = function()
			print("[HUD.story]: Shop button activated")
		end,
	})

	HUD({
		ViewModel = vm,
	}).Parent = root

	return function()
		vm:Destroy()
	end
end
