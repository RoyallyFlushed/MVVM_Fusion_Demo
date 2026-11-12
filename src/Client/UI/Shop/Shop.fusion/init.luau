--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Button = require(ReplicatedStorage.Client.UI.Common.Button)
const Palette = require(ReplicatedStorage.Shared.Config.Palette)
const ShopViewModel = require(script.Parent.ShopViewModel)
const ProductCard = require(script["ProductCard.fusion"])
const ProductDetails = require(script["ProductDetails.fusion"])
const TableUtil = require(ReplicatedStorage.Shared.Modules.TableUtil)
const ViewportScale = require(ReplicatedStorage.Client.Modules.ViewportScale)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children
const OnEvent = Fusion.OnEvent

--// Types
export type Colors = {
	PanelBackground: Fusion.UsedAs<Color3>,
	CardBackground: Fusion.UsedAs<Color3>,
	Text: Fusion.UsedAs<Color3>,
	Price: Fusion.UsedAs<Color3>,
	Exit: Fusion.UsedAs<Color3>,
}
export type Layout = {
	Columns: Fusion.UsedAs<number>,
	VisibleRows: Fusion.UsedAs<number>,
}
type Props = {
	ViewModel: ShopViewModel.ViewModel,
	-- Optional color overrides, for example from story controls. The default is the Palette.
	Colors: Colors?,
	-- Optional grid layout. The default is 4 columns and 3 visible rows.
	Layout: Layout?,
	-- Optional extra props for every ProductCard, for example SizeScalar or ButtonTweenInfo.
	CardProps: { [any]: any }?,
}

--// Constants
const DEFAULT_COLORS: Colors = {
	PanelBackground = Palette.Colors.PANEL_BACKGROUND,
	CardBackground = Palette.Colors.CARD_BACKGROUND,
	Text = Palette.Colors.TEXT,
	Price = Palette.Colors.PRICE,
	Exit = Palette.Colors.EXIT,
}
const DEFAULT_LAYOUT: Layout = {
	Columns = 4,
	VisibleRows = 3,
}
const CARD_SIZE = 132
const CARD_GAP = 10
const SCROLLBAR_GUTTER = 12
-- Space around the cards so that a hovered card is not clipped by the scrolling frame.
const HOVER_ROOM = 6
const HEADER_HEIGHT = 78
const EDGE_PADDING = 18
const CLOSE_BUTTON_SIZE = 42
const DETAILS_WIDTH = 248
const DETAILS_GAP = 12
-- The details panel needs this height for its icon, name, price, and some description.
const DETAILS_MIN_HEIGHT = 400
-- The part of the viewport that the panel can fill when it shrinks to fit a small screen.
const VIEWPORT_FILL = 0.9

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope
	const colors = props.Colors or DEFAULT_COLORS
	const layout = props.Layout or DEFAULT_LAYOUT
	local localStates = {}

	-- States
	localStates.GridSize = s:Computed(function(use: Fusion.Use): Vector2
		const columns = math.max(1, math.floor(use(layout.Columns)))
		const rows = math.max(1, math.floor(use(layout.VisibleRows)))
		return Vector2.new(
			HOVER_ROOM + columns * CARD_SIZE + (columns - 1) * CARD_GAP + SCROLLBAR_GUTTER,
			HOVER_ROOM * 2 + rows * CARD_SIZE + (rows - 1) * CARD_GAP
		)
	end)
	localStates.BodyHeight = s:Computed(function(use: Fusion.Use): number
		return math.max(use(localStates.GridSize).Y, DETAILS_MIN_HEIGHT)
	end)
	localStates.PanelSize = s:Computed(function(use: Fusion.Use): Vector2
		return Vector2.new(
			EDGE_PADDING + use(localStates.GridSize).X + DETAILS_GAP + DETAILS_WIDTH + EDGE_PADDING,
			HEADER_HEIGHT + use(localStates.BodyHeight) + EDGE_PADDING
		)
	end)
	localStates.PanelUDim2 = s:Computed(function(use: Fusion.Use): UDim2
		const size: Vector2 = use(localStates.PanelSize)
		return UDim2.fromOffset(size.X, size.Y)
	end)
	localStates.GridUDim2 = s:Computed(function(use: Fusion.Use): UDim2
		const size: Vector2 = use(localStates.GridSize)
		return UDim2.fromOffset(size.X, size.Y)
	end)
	localStates.DetailsPosition = s:Computed(function(use: Fusion.Use): UDim2
		return UDim2.fromOffset(EDGE_PADDING + use(localStates.GridSize).X + DETAILS_GAP, HEADER_HEIGHT)
	end)
	localStates.DetailsSize = s:Computed(function(use: Fusion.Use): UDim2
		return UDim2.fromOffset(DETAILS_WIDTH, use(localStates.BodyHeight))
	end)

	return s:New "Frame" {
		Name = "Shop",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = vm.WindowPositionTween,
		Size = localStates.PanelUDim2,
		BackgroundColor3 = colors.PanelBackground,
		BorderSizePixel = 0,
		Visible = vm.IsVisible,

		[Children] = {
			s:New "UIScale" {
				Scale = ViewportScale.Fit(s, localStates.PanelSize, VIEWPORT_FILL),
			},
			s:New "UICorner" {
				CornerRadius = UDim.new(0, 18),
			},
			s:New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Palette.Colors.PANEL_STROKE,
				Thickness = 3,
			},
			s:New "TextLabel" {
				Name = "Title",
				Position = UDim2.fromOffset(24, 18),
				Size = UDim2.new(1, -82, 0, 42),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansExtraBold,
				Text = "SHOP",
				TextColor3 = colors.Text,
				TextSize = 30,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
			Button {
				Scope = s,
				Name = "Close",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(
					1,
					-(EDGE_PADDING + CLOSE_BUTTON_SIZE / 2),
					0,
					EDGE_PADDING + CLOSE_BUTTON_SIZE / 2
				),
				Size = UDim2.fromOffset(CLOSE_BUTTON_SIZE, CLOSE_BUTTON_SIZE),
				AutoButtonColor = false,
				BackgroundColor3 = colors.Exit,
				BorderSizePixel = 0,

				[OnEvent "Activated"] = function()
					vm:Hide()
				end,

				[Children] = {
					s:New "UICorner" {
						CornerRadius = UDim.new(0.26, 0),
					},
					s:New "TextLabel" {
						Name = "Label",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Font = Enum.Font.BuilderSansBold,
						Text = "×",
						TextColor3 = colors.Text,
						TextScaled = true,
					},
				},
			},
			ProductDetails {
				ViewModel = vm,
				Position = localStates.DetailsPosition,
				Size = localStates.DetailsSize,
				BackgroundColor = colors.CardBackground,
				TextColor = colors.Text,
				PriceColor = colors.Price,
			},
			s:New "TextLabel" {
				Name = "EmptyMessage",
				Position = UDim2.fromOffset(EDGE_PADDING, HEADER_HEIGHT),
				Size = localStates.GridUDim2,
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansBold,
				Text = "No products are available right now.",
				TextColor3 = Palette.Colors.TEXT_MUTED,
				TextSize = 20,
				TextWrapped = true,
				Visible = vm.IsEmpty,
			},
			s:New "ScrollingFrame" {
				Name = "Content",
				Position = UDim2.fromOffset(EDGE_PADDING, HEADER_HEIGHT),
				Size = localStates.GridUDim2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollBarThickness = 6,
				ScrollBarImageColor3 = Palette.Colors.SCROLLBAR,
				ScrollingDirection = Enum.ScrollingDirection.Y,

				[Children] = {
					s:New "UIListLayout" {
						FillDirection = Enum.FillDirection.Horizontal,
						Wraps = true,
						Padding = UDim.new(0, CARD_GAP),
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					s:New "UIPadding" {
						PaddingTop = UDim.new(0, HOVER_ROOM),
						PaddingBottom = UDim.new(0, HOVER_ROOM),
						PaddingLeft = UDim.new(0, HOVER_ROOM),
						PaddingRight = UDim.new(0, SCROLLBAR_GUTTER),
					},
					s:ForPairs(vm.SortedProducts, function(_, s, index: number, product: ShopViewModel.ProductEntry)
						-- The holder keeps the layout still while the card size tweens.
						return index,
							s:New "Frame" {
								Name = product.Name,
								LayoutOrder = index,
								Size = UDim2.fromOffset(CARD_SIZE, CARD_SIZE),
								BackgroundTransparency = 1,

								[Children] = {
									ProductCard(TableUtil.Merge(props.CardProps, {
										Scope = s,
										Product = product,
										BackgroundColor3 = colors.CardBackground,
										TextColor = colors.Text,
										PriceColor = colors.Price,
										IsSelected = s:Computed(function(use: Fusion.Use)
											return use(vm.SelectedAssetId) == product.AssetId
										end),

										[OnEvent "Activated"] = function()
											vm:SelectProduct(product)
										end,
									})),
								},
							}
					end),
				},
			},
		},
	} :: Frame
end
