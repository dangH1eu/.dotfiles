--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	-- nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{ "L3MON4D3/LuaSnip", event = "VeryLazy" },
	{
		"rafamadriz/friendly-snippets",
		event = "VeryLazy",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	-- LSP
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		event = "VeryLazy",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{
		"kosayoda/nvim-lightbulb",
		event = "VeryLazy",
		dependencies = { "antoinemadec/FixCursorHold.nvim" },
		opts = {
			autocmd = { enabled = true },
		},
	},
	{ "jose-elias-alvarez/null-ls.nvim", event = "VeryLazy" },
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
	},
	-- others
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
	},
	{ "ThePrimeagen/harpoon", event = "VeryLazy" },
	{ "nvim-tree/nvim-tree.lua", event = "VeryLazy", opts = {} },
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
	{ "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
	{ "windwp/nvim-autopairs", event = "VeryLazy", opts = {} },
	-- Colorschemes
	{ "NvChad/nvim-colorizer.lua", event = "VeryLazy", opts = {} },
	{ "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
	{ "ellisonleao/gruvbox.nvim", event = "VeryLazy" },
})

-- neovim set options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4 -- insert 4 spaces for a tab
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- Make indenting smart
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.updatetime = 250 -- faster completion (4000ms default)
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.g.netrw_banner = 0
vim.opt.guicursor = ""

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
	group = highlight_group,
	pattern = "*",
})

-- Smart relative linenumber
local smart_relative_line = vim.api.nvim_create_augroup("SmartLineNumber", {})
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt.relativenumber = false
	end,
	group = smart_relative_line,
	pattern = "*",
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt.relativenumber = true
	end,
	group = smart_relative_line,
	pattern = "*",
})

--remap
vim.keymap.set("", "<Space>", "<Nop>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<cr>")
vim.keymap.set("n", "<leader>vc", "<cmd>e $MYVIMRC<cr>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "x", [["_x]])
vim.keymap.set("n", "s", [["_s]])
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Harpoon
vim.keymap.set("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
vim.keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>")
vim.keymap.set("n", "<C-h>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>")
-- Telescope
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope grep_string<cr>")
vim.keymap.set("n", "<leader>lg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>gh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
-- nvim-tree
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")

-- Completion
local kind_icons = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
}

local cmp = require("cmp")
cmp.setup({
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- Source
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				luasnip = "[LuaSnip]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client, bufnr)
	vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
	vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
	local bufopts = { buffer = bufnr }
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", bufopts)
	vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", bufopts)
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", bufopts)
	vim.keymap.set("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", bufopts)
	vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", bufopts)
	vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", bufopts)
	vim.keymap.set("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>", bufopts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)

	-- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", bufopts)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	-- if client.name == "tsserver" then
	-- 	client.server_capabilities.document_formatting = false
	-- end
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"html",
		"cssls",
		"tsserver",
		"jsonls",
		"clangd",
		"lua_ls",
		"emmet_language_server",
	},
})
local lspconfig = require("lspconfig")
local servers = {
	"html",
	"cssls",
	"tsserver",
	"jsonls",
	"clangd",
	"emmet_language_server",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettierd,
		require("null-ls").builtins.formatting.stylua,
	},
})
-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "cpp", "lua", "html", "javascript", "css" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = false,
	},
})
-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = false,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")
