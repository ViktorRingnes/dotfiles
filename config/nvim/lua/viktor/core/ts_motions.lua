-- Native treesitter function/parameter motions. Replaces the
-- nvim-treesitter-textobjects move module, whose legacy master branch broke
-- against current treesitter. Uses only the stable vim.treesitter API.

local M = {}

local FUNCTION_TYPES = {
	function_item = true, -- rust
	closure_expression = true, -- rust
	function_declaration = true, -- ts, go
	function_definition = true, -- c, cpp
	method_declaration = true, -- go, c#
	method_definition = true, -- ts, js
	arrow_function = true, -- ts, js
	local_function = true, -- lua
	function_signature_item = true, -- rust trait fns
}

local PARAM_TYPES = {
	parameter = true, -- rust
	required_parameter = true, -- ts
	optional_parameter = true, -- ts
	parameter_declaration = true, -- go, c
	argument = true, -- call sites
}

local function collect(types)
	local ok, parser = pcall(vim.treesitter.get_parser)
	if not ok or not parser then
		return {}
	end
	local trees = parser:parse()
	if not trees or not trees[1] then
		return {}
	end

	local positions = {}
	local seen = {}
	local function walk(node)
		if types[node:type()] then
			local row, col = node:start()
			local key = row * 100000 + col
			if not seen[key] then
				seen[key] = true
				positions[#positions + 1] = { row, col }
			end
		end
		for child in node:iter_children() do
			walk(child)
		end
	end
	walk(trees[1]:root())

	table.sort(positions, function(a, b)
		if a[1] == b[1] then
			return a[2] < b[2]
		end
		return a[1] < b[1]
	end)
	return positions
end

local function jump(types, forward)
	local positions = collect(types)
	if #positions == 0 then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local target

	if forward then
		for _, p in ipairs(positions) do
			if p[1] > row or (p[1] == row and p[2] > col) then
				target = p
				break
			end
		end
	else
		for i = #positions, 1, -1 do
			local p = positions[i]
			if p[1] < row or (p[1] == row and p[2] < col) then
				target = p
				break
			end
		end
	end

	if target then
		-- Push the current spot onto the jumplist so <C-o> returns here.
		vim.cmd("normal! m'")
		vim.api.nvim_win_set_cursor(0, { target[1] + 1, target[2] })
	end
end

function M.setup()
	local modes = { "n", "x", "o" }
	local map = vim.keymap.set
	map(modes, "]f", function()
		jump(FUNCTION_TYPES, true)
	end, { desc = "Next function start" })
	map(modes, "[f", function()
		jump(FUNCTION_TYPES, false)
	end, { desc = "Previous function start" })
	map(modes, "]a", function()
		jump(PARAM_TYPES, true)
	end, { desc = "Next parameter or argument" })
	map(modes, "[a", function()
		jump(PARAM_TYPES, false)
	end, { desc = "Previous parameter or argument" })
end

return M
