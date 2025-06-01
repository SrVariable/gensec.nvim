vim.keymap.set("n", "<leader>is", function()
	require("gensec").insert_section()
end, { desc = "Insert Section" })
