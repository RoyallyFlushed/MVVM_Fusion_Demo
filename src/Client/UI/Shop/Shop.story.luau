--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Shop = require(script.Parent["Shop.fusion"])
const ShopViewModel = require(script.Parent.ShopViewModel)
const ShopUtil = require(ReplicatedStorage.Shared.Modules.ShopUtil)

local function getProducts(): { ShopViewModel.ProductEntry }
	local products: { ShopViewModel.ProductEntry } = {}
	for index, product in ShopUtil.GetProducts() do
		table.insert(products, {
			AssetId = product.AssetId,
			Name = product.Name,
			Price = product.Price,
			Icon = ShopUtil.GetThumbnail(product.AssetId),
			LayoutOrder = index,
		})
	end
	return products
end

return function(root: Instance): () -> ()
	const vm = ShopViewModel.new({
		IsVisible = true,
		Products = getProducts(),
	})

	Shop({
		ViewModel = vm,
	}).Parent = root

	return function()
		vm:Destroy()
	end
end
