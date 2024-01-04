local M = {}

M.normalize = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[ç]", "c")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

return M
