--[[

    DESC: A utility module for generic table functions.

--]]

--// Class
const TableUtil = {}

--- Returns a new dictionary with the keys of all given dictionaries. A later dictionary
--- overrides the keys of an earlier one. Nil arguments are skipped.
function TableUtil.Merge(...: { [any]: any }?): { [any]: any }
	local merged = {}
	for index = 1, select("#", ...) do
		local dictionary = select(index, ...)
		if dictionary then
			for key, value in dictionary do
				merged[key] = value
			end
		end
	end
	return merged
end

return TableUtil
