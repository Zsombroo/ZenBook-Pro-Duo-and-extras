-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").colorscheme("main")
		vim.cmd("colorscheme rose-pine")
	end
}
