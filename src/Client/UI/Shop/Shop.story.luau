--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Palette = require(ReplicatedStorage.Shared.Config.Palette)
const Shop = require(script.Parent["Shop.fusion"])
const ShopViewModel = require(script.Parent.ShopViewModel)
const ShopUtil = require(ReplicatedStorage.Shared.Modules.ShopUtil)
const ViewportScale = require(ReplicatedStorage.Client.Modules.ViewportScale)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const UILabs = require(ReplicatedStorage.Packages.UILabs)
const peek = Fusion.peek

--// Constants
const LONG_NAME_SUFFIX = " Limited Collector's Edition"
const BROKEN_ICON = "rbxassetid://0"
const PRODUCT_COUNT = #ShopUtil.GetProducts()
const EASING_STYLES = {
	Linear = Enum.EasingStyle.Linear,
	Sine = Enum.EasingStyle.Sine,
	Quad = Enum.EasingStyle.Quad,
	Cubic = Enum.EasingStyle.Cubic,
	Quart = Enum.EasingStyle.Quart,
	Quint = Enum.EasingStyle.Quint,
	Exponential = Enum.EasingStyle.Exponential,
	Circular = Enum.EasingStyle.Circular,
	Back = Enum.EasingStyle.Back,
	Bounce = Enum.EasingStyle.Bounce,
	Elastic = Enum.EasingStyle.Elastic,
}
-- Vector2.zero means the real viewport (no override).
const VIEWPORT_PRESETS = {
	["Real viewport"] = Vector2.zero,
	["Desktop 1440p"] = Vector2.new(2560, 1440),
	["Desktop 1080p"] = Vector2.new(1920, 1080),
	["Laptop 720p"] = Vector2.new(1280, 720),
	["Tablet"] = Vector2.new(1024, 768),
	["Phone (landscape)"] = Vector2.new(844, 390),
}
const SORT_MODES = {
	["Default"] = "Default",
	["Price: low to high"] = "PriceAscending",
	["Price: high to low"] = "PriceDescending",
	["Name"] = "Name",
}

--// Types
type Controls = {
	Visible: Fusion.Value<boolean>,
	SlideDuration: Fusion.Value<number>,
	SlideEasing: Fusion.Value<Enum.EasingStyle>,
	ViewportPreset: Fusion.Value<Vector2>,
	Columns: Fusion.Value<number>,
	VisibleRows: Fusion.Value<number>,
	ProductCount: Fusion.Value<number>,
	SortMode: Fusion.Value<ShopViewModel.SortMode>,
	SelectedProduct: Fusion.Value<number>,
	LongNames: Fusion.Value<boolean>,
	BrokenIcons: Fusion.Value<boolean>,
	CurrencyName: Fusion.Value<string>,
	PriceMultiplier: Fusion.Value<number>,
	HoverScale: Fusion.Value<number>,
	HoverEasing: Fusion.Value<Enum.EasingStyle>,
	PanelBackground: Fusion.Value<Color3>,
	CardBackground: Fusion.Value<Color3>,
	Text: Fusion.Value<Color3>,
	Price: Fusion.Value<Color3>,
	Exit: Fusion.Value<Color3>,
}

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = {
		-- Window
		Visible = UILabs.Ordered(true, 1),
		SlideDuration = UILabs.Ordered(UILabs.Slider(0.35, 0.05, 2, 0.05), 2),
		SlideEasing = UILabs.Ordered(UILabs.EnumList(EASING_STYLES, "Quint"), 3),
		-- Previews the scale that the shop uses on another screen size.
		ViewportPreset = UILabs.Ordered(UILabs.EnumList(VIEWPORT_PRESETS, "Real viewport"), 4),
		Columns = UILabs.Ordered(UILabs.Slider(4, 1, 6, 1), 5),
		VisibleRows = UILabs.Ordered(UILabs.Slider(3, 1, 5, 1), 6),

		-- Products
		-- 0 shows the empty state, 1 to 4 show one row, and more than 12 makes the list scroll.
		ProductCount = UILabs.Ordered(UILabs.Slider(PRODUCT_COUNT, 0, PRODUCT_COUNT, 1), 7),
		SortMode = UILabs.Ordered(UILabs.EnumList(SORT_MODES, "Default"), 8),
		-- 0 clears the selection. Other values select that product in catalog order.
		SelectedProduct = UILabs.Ordered(UILabs.Slider(0, 0, PRODUCT_COUNT, 1), 9),
		LongNames = UILabs.Ordered(false, 10),
		-- Gives every product an invalid image, to show how a failed thumbnail looks.
		BrokenIcons = UILabs.Ordered(false, 11),
		CurrencyName = UILabs.Ordered("Coins", 12),
		PriceMultiplier = UILabs.Ordered(UILabs.Slider(1, 1, 1000, 1), 13),

		-- Product cards
		HoverScale = UILabs.Ordered(UILabs.Slider(0.6, 0, 2, 0.1), 14),
		HoverEasing = UILabs.Ordered(UILabs.EnumList(EASING_STYLES, "Quad"), 15),

		-- Colors
		PanelBackground = UILabs.Ordered(Palette.Colors.PANEL_BACKGROUND, 16),
		CardBackground = UILabs.Ordered(Palette.Colors.CARD_BACKGROUND, 17),
		Text = UILabs.Ordered(Palette.Colors.TEXT, 18),
		Price = UILabs.Ordered(Palette.Colors.PRICE, 19),
		Exit = UILabs.Ordered(Palette.Colors.EXIT, 20),
	},
}, function(props: UILabs.FusionProps): () -> ()
	const s: Fusion.Scope<typeof(Fusion)> = props.scope
	const controls = props.controls :: Controls
	const catalog = ShopUtil.GetProducts()

	-- The same mapping as ShopController, changed by the product controls.
	const products = s:Computed(function(use: Fusion.Use): { ShopViewModel.ProductEntry }
		const count = math.clamp(math.floor(use(controls.ProductCount)), 0, #catalog)
		const longNames: boolean = use(controls.LongNames)
		const brokenIcons: boolean = use(controls.BrokenIcons)
		const currencyName: string = use(controls.CurrencyName)
		const priceMultiplier: number = use(controls.PriceMultiplier)

		local result: { ShopViewModel.ProductEntry } = {}
		for index = 1, count do
			const product = catalog[index]
			const price = math.floor(product.Price * priceMultiplier)
			table.insert(result, {
				AssetId = product.AssetId,
				Name = if longNames then product.Name .. LONG_NAME_SUFFIX else product.Name,
				Description = product.Description,
				Price = price,
				PriceText = ShopUtil.FormatPrice(price, currencyName),
				Icon = if brokenIcons then BROKEN_ICON else ShopUtil.GetThumbnail(product.AssetId),
				LargeIcon = if brokenIcons then BROKEN_ICON else ShopUtil.GetLargeThumbnail(product.AssetId),
				LayoutOrder = index,
			})
		end
		return result
	end)
	const slideTweenInfo = s:Computed(function(use: Fusion.Use): TweenInfo
		return TweenInfo.new(use(controls.SlideDuration), use(controls.SlideEasing), Enum.EasingDirection.Out)
	end)
	const hoverTweenInfo = s:Computed(function(use: Fusion.Use): TweenInfo
		return TweenInfo.new(0.15, use(controls.HoverEasing), Enum.EasingDirection.Out)
	end)

	const vm = ShopViewModel.new({
		IsVisible = peek(controls.Visible),
		Products = products,
		SlideTweenInfo = slideTweenInfo,
	})

	s:Observer(controls.Visible):onChange(function()
		if peek(controls.Visible) then
			vm:Show()
		else
			vm:Hide()
		end
	end)
	s:Observer(controls.SortMode):onBind(function()
		vm:SetSortMode(peek(controls.SortMode))
	end)
	s:Observer(controls.SelectedProduct):onBind(function()
		const product = peek(products)[peek(controls.SelectedProduct)]
		if product then
			vm:SelectProduct(product)
		else
			vm:ClearSelection()
		end
	end)
	s:Observer(controls.ViewportPreset):onBind(function()
		const size: Vector2 = peek(controls.ViewportPreset)
		ViewportScale.SetOverride(if size == Vector2.zero then nil else size)
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
		Layout = {
			Columns = controls.Columns,
			VisibleRows = controls.VisibleRows,
		},
		CardProps = {
			SizeScalar = controls.HoverScale,
			ButtonTweenInfo = hoverTweenInfo,
		},
	}).Parent =
		props.target

	return function()
		-- The override is global, so it must not stay after the story unmounts.
		ViewportScale.SetOverride(nil)
		vm:Destroy()
	end
end)
