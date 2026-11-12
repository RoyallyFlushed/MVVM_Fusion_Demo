--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Palette = require(ReplicatedStorage.Shared.Config.Palette)
const Shop = require(script.Parent["Shop.fusion"])
const ShopViewModel = require(script.Parent.ShopViewModel)
const ShopUtil = require(ReplicatedStorage.Shared.Modules.ShopUtil)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const UILabs = require(ReplicatedStorage.Packages.UILabs)
const peek = Fusion.peek

--// Constants
const LONG_NAME_SUFFIX = " Limited Collector's Edition"
const PRODUCT_COUNT = #ShopUtil.GetProducts()

--// Types
type Controls = {
	Visible: Fusion.Value<boolean>,
	ProductCount: Fusion.Value<number>,
	LongNames: Fusion.Value<boolean>,
	PriceMultiplier: Fusion.Value<number>,
	PanelBackground: Fusion.Value<Color3>,
	CardBackground: Fusion.Value<Color3>,
	Text: Fusion.Value<Color3>,
	Price: Fusion.Value<Color3>,
	Exit: Fusion.Value<Color3>,
}

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

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = {
		-- Shows or hides the shop through the ViewModel, so the slide tween plays.
		Visible = UILabs.Ordered(true, 1),
		-- 0 shows the empty state, 1 to 4 show one row, and more than 12 makes the list scroll.
		ProductCount = UILabs.Ordered(UILabs.Slider(PRODUCT_COUNT, 0, PRODUCT_COUNT, 1), 2),
		-- Adds a long suffix to each name, to test the text truncation.
		LongNames = UILabs.Ordered(false, 3),
		-- Multiplies each price, to test large numbers.
		PriceMultiplier = UILabs.Ordered(UILabs.Slider(1, 1, 1000, 1), 4),

		PanelBackground = UILabs.Ordered(Palette.Colors.PANEL_BACKGROUND, 5),
		CardBackground = UILabs.Ordered(Palette.Colors.CARD_BACKGROUND, 6),
		Text = UILabs.Ordered(Palette.Colors.TEXT, 7),
		Price = UILabs.Ordered(Palette.Colors.PRICE, 8),
		Exit = UILabs.Ordered(Palette.Colors.EXIT, 9),
	},
}, function(props: UILabs.FusionProps): () -> ()
	const s: Fusion.Scope<typeof(Fusion)> = props.scope
	const controls = props.controls :: Controls
	const allProducts = getProducts()

	const products = s:Computed(function(use: Fusion.Use)
		const count = math.clamp(math.floor(use(controls.ProductCount)), 0, #allProducts)
		const longNames: boolean = use(controls.LongNames)
		const priceMultiplier: number = use(controls.PriceMultiplier)

		local result: { ShopViewModel.ProductEntry } = {}
		for index = 1, count do
			local product = table.clone(allProducts[index])
			if longNames then
				product.Name ..= LONG_NAME_SUFFIX
			end
			product.Price = math.floor(product.Price * priceMultiplier)
			table.insert(result, product)
		end
		return result
	end)

	const vm = ShopViewModel.new({
		IsVisible = peek(controls.Visible),
		Products = products,
	})

	s:Observer(controls.Visible):onChange(function()
		if peek(controls.Visible) then
			vm:Show()
		else
			vm:Hide()
		end
	end)

	Shop({
		ViewModel = vm,
		Colors = {
			PanelBackground = controls.PanelBackground,
			CardBackground = controls.CardBackground,
			Text = controls.Text,
			Price = controls.Price,
			Exit = controls.Exit,
		},
	}).Parent =
		props.target

	return function()
		vm:Destroy()
	end
end)
