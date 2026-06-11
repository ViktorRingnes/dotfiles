local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("ViktorIncludeFormatter", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = { "*.h", "*.hpp", "*.hh", "*.hxx", "*.c", "*.cc", "*.cpp", "*.cxx" },
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			if ft == "typst" then return end
			require("viktor.tools.include_formatter").format(args.buf)
		end,
	})

	local typst_job = nil

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		pattern = "*.typ",
		callback = function(args)
			local file = vim.api.nvim_buf_get_name(args.buf)
			local pdf = file:gsub("%.typ$", ".pdf")

			if typst_job then
				vim.fn.jobstop(typst_job)
			end

			typst_job = vim.fn.jobstart({ "typst", "compile", file, pdf })
		end,
	})

	vim.api.nvim_create_user_command("Skel", function()
		require("viktor.tools.skeleton").insert()
	end, {})

	vim.api.nvim_create_user_command("TypstPreview", function()
		local file = vim.fn.expand("%")
		local pdf = file:gsub("%.typ$", ".pdf")
		vim.fn.jobstart({ "zathura", pdf })
	end, {})

	require("viktor.tools.cpp_extract").setup()
end

return M
