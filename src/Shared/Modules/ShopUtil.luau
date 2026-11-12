--[[

    DESC: A utility module that gives the shop catalog. All products are Roblox catalog
          accessories, with their catalog descriptions. The prices are demo values in an
          in-game currency.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const NumberUtil = require(ReplicatedStorage.Shared.Modules.NumberUtil)

--// Types
export type ShopProduct = {
	AssetId: number,
	Name: string,
	Description: string,
	Price: number,
}

--// Constants
const CURRENCY_NAME = "Coins"
const THUMBNAIL_SIZE = 150
const DETAILS_THUMBNAIL_SIZE = 420
const PRODUCTS: { ShopProduct } = {
	{
		AssetId = 1365767,
		Name = "Valkyrie Helm",
		Description = "This splendid helm is a replica of ones worn by the valkyries, a group of minor deities who serve Odin in Norse mythology. Led by Freya, they uphold justice and righteousness.",
		Price = 25000,
	},
	{
		AssetId = 21070012,
		Name = "Dominus Empyreus",
		Description = "Quidquid latine dictum sit, altum sonatur...\n\nOur original hat in the Dominus series.",
		Price = 50000,
	},
	{
		AssetId = 48545806,
		Name = "Dominus Frigidus",
		Description = "Aut vincere aut mori",
		Price = 45000,
	},
	{
		AssetId = 1031429,
		Name = "Domino Crown",
		Description = "This golden crown was awarded as a prize in the June 2007 Domino Rally Building Contest. Perhaps its most unique characteristic is its ability to inspire viewers with awe while at the same time making the wearer look goofy.",
		Price = 40000,
	},
	{
		AssetId = 1285307,
		Name = "Sparkle Time Fedora",
		Description = "Mr. Sparkle! I am disrespectful to dirt! Can you see I am serious!",
		Price = 30000,
	},
	{
		AssetId = 100929604,
		Name = "Green Sparkle Time Fedora",
		Description = "Happy St. Patrick's Day!",
		Price = 20000,
	},
	{
		AssetId = 1235488,
		Name = "Clockwork's Headphones",
		Description = "Elite vintage headgear from the ROBLOX archives. These are museum-quality replicas of headphones originally made and worn by Clockwork. They are not for noobs...",
		Price = 12000,
	},
	{
		AssetId = 11748356,
		Name = "Clockwork's Shades",
		Description = "Straight from the ROBLOX archives, these shades are on limited release to commemorate interns from summers past. They're insanely expensive, because that's how Clockwork rolls...",
		Price = 15000,
	},
	{
		AssetId = 1081300,
		Name = "Golden Crown",
		Description = "To gain a crown by fighting is great, to reject it divine.",
		Price = 8000,
	},
	{
		AssetId = 1125510,
		Name = "The Void Star",
		Description = "Void Star to zer0,\nFoolishly dereferenced.\nNo call stack. All g0ne.",
		Price = 9000,
	},
	{
		AssetId = 1193866,
		Name = "The Crimson Catseye",
		Description = "The Crimson Catseye was once the talisman of a powerful sorcerer who lived alone in a dark, creepy mansion known to locals as Haunted Hill. One day the sorcerer just disappeared, but legend says he left his eye behind; and it's still there somewhere in Haunted Hill, waiting...",
		Price = 6000,
	},
	{
		AssetId = 1158416,
		Name = "Eerie Pumpkin Head",
		Description = "The Eerie Pumpkin Head was the prize for the October 2007 ROBLOX Spooky Building Contest.",
		Price = 5000,
	},
	{
		AssetId = 1029025,
		Name = "The Classic ROBLOX Fedora",
		Description = "A black felt fedora. Ideal for 1920s journalists, detectives, and Linux hackers. This hat demonstrates good taste and exudes class.",
		Price = 3500,
	},
	{
		AssetId = 64082730,
		Name = "Rainbow Shaggy",
		Description = "Because regular shaggys just don't express the depth of your complicated soul.",
		Price = 2500,
	},
	{
		AssetId = 1091572,
		Name = "Coif of Glory",
		Description = "Dios Achilleus:\n\nOne head among thousands when\n\nIllium died in fire",
		Price = 950,
	},
	{
		AssetId = 1309911,
		Name = "Ninja Mask of Shadows",
		Description = "The Ninjas of Shadow strike from the darkness. Absolutely silent. Absolutely deadly.",
		Price = 250,
	},
	{
		AssetId = 1374269,
		Name = "Kitty Ears",
		Description = "MY EARS. LET ME SHOW YOU THEM.",
		Price = 100,
	},
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

--- Returns a price as display text, for example "12,000 Coins"
function ShopUtil.FormatPrice(price: number, currencyName: string?): string
	return `{NumberUtil.FormatWithCommas(price)} {currencyName or CURRENCY_NAME}`
end

--- Returns a thumbnail content ID for a catalog asset, sized for a product card
function ShopUtil.GetThumbnail(assetId: number): string
	return `rbxthumb://type=Asset&id={assetId}&w={THUMBNAIL_SIZE}&h={THUMBNAIL_SIZE}`
end

--- Returns a larger thumbnail content ID for a catalog asset, sized for the details panel
function ShopUtil.GetLargeThumbnail(assetId: number): string
	return `rbxthumb://type=Asset&id={assetId}&w={DETAILS_THUMBNAIL_SIZE}&h={DETAILS_THUMBNAIL_SIZE}`
end

return ShopUtil
