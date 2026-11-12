--[[

    DESC: A utility module that gives the shop catalog. All products are Roblox catalog
          accessories. The prices are demo values in an in-game currency.

--]]

--// Types
export type ShopProduct = {
	AssetId: number,
	Name: string,
	Price: number,
}

--// Constants
const THUMBNAIL_SIZE = 150
const PRODUCTS: { ShopProduct } = {
	{ AssetId = 1365767, Name = "Valkyrie Helm", Price = 25000 },
	{ AssetId = 21070012, Name = "Dominus Empyreus", Price = 50000 },
	{ AssetId = 48545806, Name = "Dominus Frigidus", Price = 45000 },
	{ AssetId = 1031429, Name = "Domino Crown", Price = 40000 },
	{ AssetId = 1285307, Name = "Sparkle Time Fedora", Price = 30000 },
	{ AssetId = 100929604, Name = "Green Sparkle Time Fedora", Price = 20000 },
	{ AssetId = 1235488, Name = "Clockwork's Headphones", Price = 12000 },
	{ AssetId = 11748356, Name = "Clockwork's Shades", Price = 15000 },
	{ AssetId = 1081300, Name = "Golden Crown", Price = 8000 },
	{ AssetId = 1125510, Name = "The Void Star", Price = 9000 },
	{ AssetId = 1193866, Name = "The Crimson Catseye", Price = 6000 },
	{ AssetId = 1158416, Name = "Eerie Pumpkin Head", Price = 5000 },
	{ AssetId = 1029025, Name = "The Classic ROBLOX Fedora", Price = 3500 },
	{ AssetId = 64082730, Name = "Rainbow Shaggy", Price = 2500 },
	{ AssetId = 1091572, Name = "Coif of Glory", Price = 950 },
	{ AssetId = 1309911, Name = "Ninja Mask of Shadows", Price = 250 },
	{ AssetId = 1374269, Name = "Kitty Ears", Price = 100 },
}

--// Class
const ShopUtil = {}

--- Returns a copy of the shop catalog in display order
function ShopUtil.GetProducts(): { ShopProduct }
	local products: { ShopProduct } = {}
	for _, product in PRODUCTS do
		table.insert(products, table.clone(product))
	end
	return products
end

--- Returns a thumbnail content ID for a catalog asset
function ShopUtil.GetThumbnail(assetId: number): string
	return `rbxthumb://type=Asset&id={assetId}&w={THUMBNAIL_SIZE}&h={THUMBNAIL_SIZE}`
end

return ShopUtil
