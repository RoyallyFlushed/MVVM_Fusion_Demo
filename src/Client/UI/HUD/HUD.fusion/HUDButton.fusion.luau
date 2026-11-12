--[[

    DESC: A square HUD button with an icon and a label. It is built on the Button component,
          so it accepts all Button props. The icon and the label scale with the hover tween.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Button = require(ReplicatedStorage.Client.UI.Common.Button)
const TableUtil = require(ReplicatedStorage.Shared.Modules.TableUtil)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children

--// Constants
const DEFAULT_PROPS = {
	Name = "HUDButton",
	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutoButtonColor = false,
	BackgroundColor3 = Color3.fromRGB(32, 32, 36),
	BorderSizePixel = 0,
	ButtonTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	Icon = "",
	Text = "",
}
const CUSTOM_PROPS = { "Icon", "Text" }

--// Types
export type Props = {
	Icon: string?,
	Text: string?,
} & Button.Props
export type BaseType = Button.BaseType

return function(_props: Props): BaseType
	local props = TableUtil.Merge(DEFAULT_PROPS, _props) :: any
	local s = props.Scope

	-- Remove custom props from instance props
	local iprops: Button.Props = table.clone(props)
	for _, key in CUSTOM_PROPS do
		iprops[key] = nil
	end
	iprops[Children] = {
		s:New "UICorner" {
			CornerRadius = UDim.new(0.2, 0),
		},
		s:New "UIStroke" {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(70, 70, 78),
			Thickness = 2,
		},
		s:New "TextLabel" {
			Name = "Icon",
			Position = UDim2.fromScale(0, 0.08),
			Size = UDim2.fromScale(1, 0.52),
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansBold,
			Text = props.Icon,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
		},
		s:New "TextLabel" {
			Name = "Label",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 0.92),
			Size = UDim2.fromScale(1, 0.25),
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansExtraBold,
			Text = props.Text,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
		},
		props[Children],
	}
	return Button(iprops)
end
