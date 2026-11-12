--!strict

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const ShopViewModel = require(script.Parent.ShopViewModel)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children
const OnEvent = Fusion.OnEvent

type Props = {
	ViewModel: ShopViewModel.ViewModel,
}

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope

	return s:New "Frame" {
		Name = "Shop",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(32, 32, 36),
		BorderSizePixel = 0,
		Visible = vm.IsVisible,

		[Children] = {
			s:New "UICorner" {
				CornerRadius = UDim.new(0, 18),
			},
			s:New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(70, 70, 78),
				Thickness = 3,
			},
			s:New "TextLabel" {
				Name = "Title",
				Position = UDim2.fromOffset(24, 18),
				Size = UDim2.new(1, -82, 0, 42),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansExtraBold,
				Text = "SHOP",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 30,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
			s:New "TextButton" {
				Name = "Close",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -18, 0, 18),
				Size = UDim2.fromOffset(42, 42),
				AutoButtonColor = true,
				BackgroundColor3 = Color3.fromRGB(198, 70, 58),
				BorderSizePixel = 0,
				Font = Enum.Font.BuilderSansBold,
				Text = "×",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 28,

				[OnEvent "Activated"] = function()
					vm:Hide()
				end,

				[Children] = {
					s:New "UICorner" {
						CornerRadius = UDim.new(0, 11),
					},
				},
			},
			s:New "Frame" {
				Name = "Content",
				Position = UDim2.fromOffset(18, 78),
				Size = UDim2.new(1, -36, 1, -96),
				BackgroundTransparency = 1,
			},
		},
	} :: Frame
end
