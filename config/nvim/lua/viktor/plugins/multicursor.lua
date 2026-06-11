return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set
		set({ "n", "x" }, "<C-n>", function()
			mc.matchAddCursor(1)
		end, { desc = "Add cursor at next match of word/selection" })
		set({ "n", "x" }, "<C-s>", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip next match" })
		set("x", "I", mc.insertVisual)
		set("x", "A", mc.appendVisual)
		set("x", "S", mc.splitCursors, { desc = "Split selection into cursors by regex" })
		set("x", "M", mc.matchCursors, { desc = "Cursor on every regex match in selection" })

		set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			elseif mc.hasCursors() then
				mc.clearCursors()
			else
				vim.cmd.nohlsearch()
			end
		end)
	end,
}
