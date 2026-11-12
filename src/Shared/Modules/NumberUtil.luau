--[[

    DESC: A utility module for generic number functions.

--]]

--// Class
const NumberUtil = {}

--- Returns a whole number as text with a comma between each group of 3 digits, for example 1,250,000
function NumberUtil.FormatWithCommas(value: number): string
	local digits = tostring(math.floor(math.abs(value)))
	local formatted = digits:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	if formatted:sub(1, 1) == "," then
		formatted = formatted:sub(2)
	end
	return if value < 0 then `-{formatted}` else formatted
end

return NumberUtil
