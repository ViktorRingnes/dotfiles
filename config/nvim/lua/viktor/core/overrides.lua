-- Cohesion overlay applied on top of whatever colorscheme is active. Every
-- value is derived from the live palette, so it works for every theme in the
-- switcher and is reapplied on each :Theme change (colorscheme resets
-- highlights, so a one-shot at startup would not survive).

local function hl(name)
	local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	return ok and t or {}
end

local function fg(name, fallback)
	local c = hl(name).fg
	return c and string.format("#%06x", c) or fallback
end

local function bg(name, fallback)
	local c = hl(name).bg
	return c and string.format("#%06x", c) or fallback
end

-- Blend two #rrggbb colors; amount 0 keeps a, 1 returns b.
local function blend(a, b, amount)
	local function channels(hex)
		hex = hex:gsub("#", "")
		return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
	end
	local ar, ag, ab = channels(a)
	local br, bg_, bb = channels(b)
	local function mix(x, y)
		return math.floor(x + (y - x) * amount + 0.5)
	end
	return string.format("#%02x%02x%02x", mix(ar, br), mix(ag, bg_), mix(ab, bb))
end

local function set(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local function apply()
	local normal_bg = bg("Normal", "#1a1b26")
	local normal_fg = fg("Normal", "#c0caf5")
	local accent = fg("Function", "#7aa2f7")
	local subtle = fg("Comment", "#565f89")

	local err = fg("DiagnosticError", "#f7768e")
	local warn = fg("DiagnosticWarn", "#e0af68")
	local info = fg("DiagnosticInfo", "#7dcfff")
	local hint = fg("DiagnosticHint", "#9ece6a")

	-- Floats: share the editor background, hairline border in a muted accent.
	set("NormalFloat", { bg = normal_bg })
	set("FloatBorder", { fg = blend(subtle, normal_bg, 0.2), bg = normal_bg })
	set("FloatTitle", { fg = accent, bg = normal_bg, bold = true })
	set("LspInfoBorder", { link = "FloatBorder" })

	-- Telescope harmony.
	for _, b in ipairs({
		"TelescopeBorder",
		"TelescopePromptBorder",
		"TelescopeResultsBorder",
		"TelescopePreviewBorder",
	}) do
		set(b, { link = "FloatBorder" })
	end
	set("TelescopeNormal", { bg = normal_bg })
	set("TelescopePromptNormal", { bg = normal_bg })
	set("TelescopeSelection", { link = "CursorLine" })
	set("TelescopeMatching", { fg = accent, bold = true })
	for _, t in ipairs({ "TelescopePromptTitle", "TelescopeResultsTitle", "TelescopePreviewTitle" }) do
		set(t, { fg = accent, bold = true })
	end

	-- blink.cmp menu and docs follow Pmenu / float styling.
	set("BlinkCmpMenuBorder", { link = "FloatBorder" })
	set("BlinkCmpDocBorder", { link = "FloatBorder" })
	set("BlinkCmpDoc", { link = "NormalFloat" })
	set("BlinkCmpMenuSelection", { link = "PmenuSel" })
	set("BlinkCmpLabelMatch", { fg = accent, bold = true })

	-- Diagnostic underlines: undercurl, colored from the live palette, never a
	-- solid underline.
	set("DiagnosticUnderlineError", { undercurl = true, sp = err })
	set("DiagnosticUnderlineWarn", { undercurl = true, sp = warn })
	set("DiagnosticUnderlineInfo", { undercurl = true, sp = info })
	set("DiagnosticUnderlineHint", { undercurl = true, sp = hint })
	-- rust-analyzer marks unused code with this; default rendering looks odd.
	set("DiagnosticUnnecessary", { fg = subtle, undercurl = true, sp = warn })

	-- Current line: make sure it reads on near-monochrome themes, and give the
	-- current line number an accent so it pops.
	local cursor_bg = bg("CursorLine", normal_bg)
	if cursor_bg == normal_bg then
		set("CursorLine", { bg = blend(normal_bg, normal_fg, 0.06) })
	end
	set("CursorLineNr", { fg = accent, bold = true })

	-- The match under the cursor during n/N, often left unstyled.
	set("CurSearch", { fg = normal_bg, bg = warn, bold = true })

	-- Git signs follow the diagnostic/diff palette.
	set("GitSignsAdd", { fg = fg("Added", hint) })
	set("GitSignsChange", { fg = fg("Changed", warn) })
	set("GitSignsDelete", { fg = fg("Removed", err) })

	-- treesitter-context: subtle lift plus a hairline bottom rule.
	set("TreesitterContext", { bg = blend(normal_bg, normal_fg, 0.04) })
	set("TreesitterContextBottom", { underline = true, sp = blend(subtle, normal_bg, 0.4) })
	set("TreesitterContextLineNumberBottom", { underline = true, sp = blend(subtle, normal_bg, 0.4) })

	-- snacks indent guides: passive nearly invisible, active scope an accent.
	set("SnacksIndent", { fg = blend(normal_bg, subtle, 0.4) })
	set("SnacksIndentScope", { fg = blend(accent, normal_bg, 0.3) })

	-- Restrained taste: italic comments (keep their color), bold keywords.
	local comment = hl("Comment")
	set("Comment", vim.tbl_extend("force", comment, { italic = true }))
	set("@keyword", { bold = true })
	set("@keyword.function", { bold = true })

	-- Rust semantic tokens (priority 125 > treesitter 100, so these win in
	-- rust-analyzer buffers). Mutable bindings underlined, unsafe stands out.
	set("@lsp.typemod.variable.mutable.rust", { underline = true })
	set("@lsp.typemod.parameter.mutable.rust", { underline = true })
	set("@lsp.mod.unsafe.rust", { fg = err, bold = true })
	set("@lsp.type.lifetime.rust", { link = "Special" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("ViktorOverrides", { clear = true }),
	pattern = "*",
	callback = apply,
})

-- Fire once for whatever is already loaded when this is required.
apply()
