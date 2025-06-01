local M = {}

function M.generate_section(title, comment_type)
	title = title .. " Section"
	local padding = 80 - (2 * #comment_type) - 4
	local l_padding = math.floor((padding - #title) / 2)
	local r_padding = (#title % 2 == 0) and l_padding or (l_padding + 1)

	local reversed_comment_type = comment_type:reverse()

	local section = comment_type .. " @" .. string.rep("-", padding) .. "@ " .. reversed_comment_type .. "\n"
	section = section
		.. comment_type
		.. " |"
		.. string.rep(" ", l_padding)
		.. title
		.. string.rep(" ", r_padding)
		.. "| "
		.. reversed_comment_type
		.. "\n"
	section = section .. comment_type .. " @" .. string.rep("-", padding) .. "@ " .. reversed_comment_type

	return section
end

local function choose_comment_type(filetype)
	local comment_type = {
		default = "#",
		python = "#",
		sh = "#",
		rust = "/*",
		cpp = "/*",
		go = "/*",
		c = "/*",
		javascript = "/*",
		typescript = "/*",
		lua = "--",
		vim = '"',
	}
	return comment_type[filetype] or comment_type.default
end

function M.insert_section()
	vim.ui.input({ prompt = "Section title: " }, function(input)
		if not input or input == "" then
			print("Cancelled")
			return
		end

		local filetype = vim.opt.filetype
		local comment_type = choose_comment_type(filetype)
		local section_text = M.generate_section(input, comment_type)

		local row = unpack(vim.api.nvim_win_get_cursor(0)) - 1
		vim.api.nvim_buf_set_lines(0, row, row, false, vim.split(section_text, "\n"))
	end)
end

return M
