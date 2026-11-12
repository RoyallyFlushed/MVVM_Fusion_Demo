--[[

    DESC: The details panel on the right side of the shop. It shows the selected product, or
          a prompt when no product is selected.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Palette = require(ReplicatedStorage.Shared.Config.Palette)
const ShopViewModel = require(ReplicatedStorage.Client.UI.Shop.ShopViewModel)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children

--// Constants
const PADDING = 12

--// Types
type ProductEntry = ShopViewModel.ProductEntry
type Props = {
	ViewModel: ShopViewModel.ViewModel,
	Position: Fusion.UsedAs<UDim2>,
	Size: Fusion.UsedAs<UDim2>,
	BackgroundColor: Fusion.UsedAs<Color3>,
	TextColor: Fusion.UsedAs<Color3>,
	PriceColor: Fusion.UsedAs<Color3>,
}

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope
	local localStates = {}

	-- Returns a state that reads one field of the selected product, or a fallback with no selection
	local function selectedField<T>(read: (product: ProductEntry) -> T, fallback: T): Fusion.Computed<T>
		return s:Computed(function(use: Fusion.Use): T
			const product: ProductEntry? = use(vm.SelectedProduct)
			return if product then read(product) else fallback
		end)
	end

	-- States
	localStates.HasSelection = selectedField(function()
		return true
	end, false)
	localStates.HasNoSelection = s:Computed(function(use: Fusion.Use)
		return not use(localStates.HasSelection)
	end)
	localStates.Icon = selectedField(function(product)
		return product.LargeIcon
	end, "")
	localStates.Name = selectedField(function(product)
		return product.Name
	end, "")
	localStates.Price = selectedField(function(product)
		return product.PriceText
	end, "")
	localStates.Description = selectedField(function(product)
		return product.Description
	end, "")

	return s:New "Frame" {
		Name = "ProductDetails",
		Position = props.Position,
		Size = props.Size,
		BackgroundColor3 = props.BackgroundColor,
		BorderSizePixel = 0,

		[Children] = {
			s:New "UICorner" {
				CornerRadius = UDim.new(0, 12),
			},
			s:New "TextLabel" {
				Name = "Prompt",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -PADDING * 4, 0, 60),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansBold,
				Text = "Select a product to see its details.",
				TextColor3 = Palette.Colors.TEXT_MUTED,
				TextSize = 18,
				TextWrapped = true,
				Visible = localStates.HasNoSelection,
			},
			s:New "Frame" {
				Name = "Details",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = localStates.HasSelection,

				[Children] = {
					s:New "UIPadding" {
						PaddingTop = UDim.new(0, PADDING),
						PaddingBottom = UDim.new(0, PADDING),
						PaddingLeft = UDim.new(0, PADDING),
						PaddingRight = UDim.new(0, PADDING),
					},
					s:New "UIListLayout" {
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					s:New "ImageLabel" {
						Name = "Icon",
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Palette.Colors.CARD_ICON_BACKGROUND,
						BorderSizePixel = 0,
						Image = localStates.Icon,
						ScaleType = Enum.ScaleType.Fit,

						[Children] = {
							s:New "UIAspectRatioConstraint" {
								AspectRatio = 1,
							},
							s:New "UICorner" {
								CornerRadius = UDim.new(0.06, 0),
							},
						},
					},
					s:New "TextLabel" {
						Name = "ProductName",
						LayoutOrder = 2,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Font = Enum.Font.BuilderSansExtraBold,
						Text = localStates.Name,
						TextColor3 = props.TextColor,
						TextSize = 22,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					},
					s:New "TextLabel" {
						Name = "Price",
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundTransparency = 1,
						Font = Enum.Font.BuilderSansExtraBold,
						Text = localStates.Price,
						TextColor3 = props.PriceColor,
						TextSize = 18,
						TextXAlignment = Enum.TextXAlignment.Left,
					},
					s:New "ScrollingFrame" {
						Name = "DescriptionScroller",
						LayoutOrder = 4,
						Size = UDim2.fromScale(1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(),
						ScrollBarThickness = 4,
						ScrollBarImageColor3 = Palette.Colors.SCROLLBAR,
						ScrollingDirection = Enum.ScrollingDirection.Y,

						[Children] = {
							-- The description fills the space that is left under the other details.
							s:New "UIFlexItem" {
								FlexMode = Enum.UIFlexMode.Fill,
							},
							s:New "TextLabel" {
								Name = "Description",
								Size = UDim2.new(1, -8, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								Font = Enum.Font.BuilderSans,
								Text = localStates.Description,
								TextColor3 = Palette.Colors.TEXT_MUTED,
								TextSize = 15,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
							},
						},
					},
				},
			},
		},
	} :: Frame
end
