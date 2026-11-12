--// Redefinitions
const RGB = Color3.fromRGB

--// Class
const Palette = {}

--// Types
export type Palette = typeof(Palette)

Palette.Colors = {
	TEXT = RGB(255, 255, 255),
	TEXT_MUTED = RGB(170, 170, 180),

	PANEL_BACKGROUND = RGB(32, 32, 36),
	PANEL_STROKE = RGB(70, 70, 78),
	SCROLLBAR = RGB(110, 110, 120),

	CARD_BACKGROUND = RGB(46, 46, 52),
	CARD_ICON_BACKGROUND = RGB(60, 60, 68),
	SELECTED = RGB(90, 170, 255),

	PRICE = RGB(255, 205, 64),
	EXIT = RGB(198, 70, 58),
}

return Palette
