--[[

    DESC: The base button component. It scales the button up on hover and down on press,
          and passes all other props to an ImageButton. Put it inside a holder frame when
          a layout controls its position, so that the size tween does not move the layout.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

--// Modules
const TableUtil = require(ReplicatedStorage.Shared.Modules.TableUtil)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const OnEvent = Fusion.OnEvent

--// Constants
const DEFAULT_PROPS = {
	Size = UDim2.fromScale(1, 1),
	SizeScalar = 1,
	Active = true,
	ButtonTweenInfo = TweenInfo.new(0.1),
}
const CUSTOM_PROPS = { "Scope", "SizeScalar", "ButtonTweenInfo" }

--// Types
export type Props = {
	Scope: Fusion.Scope<any>,
	-- 1 scales the button by 10%: up on hover, down on press.
	SizeScalar: number?,
	ButtonTweenInfo: TweenInfo?,
} & Fusion.PropertyTable
export type BaseType = ImageButton

--// Functions
local function scaleSize(size: UDim2, scalar: number): UDim2
	return UDim2.new(size.X.Scale * scalar, size.X.Offset * scalar, size.Y.Scale * scalar, size.Y.Offset * scalar)
end

local function isTouchInput(): boolean
	return UserInputService:GetLastInputType() == Enum.UserInputType.Touch
end

return function(_props: Props): BaseType
	local props = TableUtil.Merge(DEFAULT_PROPS, _props) :: any
	local s = props.Scope:innerScope()
	local localStates = {}
	local localCallbacks = {}
	local sizeStep = props.SizeScalar * 0.1

	local function callUserHandler(eventName: string, ...: any): ()
		local handler = props[OnEvent(eventName)]
		if handler then
			handler(...)
		end
	end

	-- States
	localStates.IsHovering = s:Value(false)
	localStates.IsPressed = s:Value(false)
	localStates.ButtonSize = s:Computed(function(use: Fusion.Use)
		local size: UDim2 = use(props.Size)
		if use(props.Active) == false then
			return size
		elseif use(localStates.IsPressed) then
			return scaleSize(size, 1 - sizeStep)
		elseif use(localStates.IsHovering) then
			return scaleSize(size, 1 + sizeStep)
		end
		return size
	end)
	localStates.ButtonSizeTween = s:Tween(localStates.ButtonSize, props.ButtonTweenInfo)

	-- Callbacks
	localCallbacks.OnMouseEnter = function(...)
		-- A tap fires MouseEnter, but MouseLeave does not always come after it. Touch has no hover,
		-- so the button does not stay big.
		if not isTouchInput() then
			localStates.IsHovering:set(true)
		end
		callUserHandler("MouseEnter", ...)
	end
	localCallbacks.OnMouseLeave = function(...)
		localStates.IsHovering:set(false)
		localStates.IsPressed:set(false)
		callUserHandler("MouseLeave", ...)
	end
	localCallbacks.OnMouseButton1Down = function(...)
		localStates.IsPressed:set(true)
		callUserHandler("MouseButton1Down", ...)
	end
	localCallbacks.OnMouseButton1Up = function(...)
		localStates.IsPressed:set(false)
		callUserHandler("MouseButton1Up", ...)
	end
	-- The gamepad selection gives the same hover effect as the mouse.
	localCallbacks.OnSelectionGained = function(...)
		localStates.IsHovering:set(true)
		callUserHandler("SelectionGained", ...)
	end
	localCallbacks.OnSelectionLost = function(...)
		localStates.IsHovering:set(false)
		callUserHandler("SelectionLost", ...)
	end

	-- Remove custom props from instance props
	local iprops = table.clone(props)
	for _, key in CUSTOM_PROPS do
		iprops[key] = nil
	end
	iprops.Size = localStates.ButtonSizeTween
	iprops[OnEvent "MouseEnter"] = localCallbacks.OnMouseEnter
	iprops[OnEvent "MouseLeave"] = localCallbacks.OnMouseLeave
	iprops[OnEvent "MouseButton1Down"] = localCallbacks.OnMouseButton1Down
	iprops[OnEvent "MouseButton1Up"] = localCallbacks.OnMouseButton1Up
	iprops[OnEvent "SelectionGained"] = localCallbacks.OnSelectionGained
	iprops[OnEvent "SelectionLost"] = localCallbacks.OnSelectionLost
	return s:New("ImageButton")(iprops)
end
