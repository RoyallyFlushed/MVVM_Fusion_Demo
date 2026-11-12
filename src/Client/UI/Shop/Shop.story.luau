--!strict

--// Modules
const Shop = require(script.Parent["Shop.fusion"])
const ShopViewModel = require(script.Parent.ShopViewModel)

return function(root: Instance): () -> ()
	const vm = ShopViewModel.new({
		IsVisible = true,
	})

	Shop({
		ViewModel = vm,
	}).Parent = root

	return function()
		vm:Destroy()
	end
end
