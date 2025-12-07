-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

vim.o.autoread = true;
vim.o.completeopt = 'menuone'
vim.o.mouse = 'a';
vim.o.ttyfast = true;

-- BLACK
vim.g.black_linelength = 100;

-- BACKUPS
vim.o.backup = false;

-- SEARCH
vim.o.incsearch = true; -- As chars entered.
vim.o.ignorecase = true;
vim.o.smartcase = true;
vim.o.hlsearch = true;

-- COLORS
vim.o.termguicolors = true;

-- LINES
vim.o.softtabstop = 4;
vim.o.shiftwidth = 4;
vim.o.tabstop = 4;
vim.o.expandtab = true;
vim.o.smartindent = true;

vim.wo.cursorline = true;
vim.o.backspace = 'indent,eol,start';
vim.o.textwidth = 0;
vim.o.hidden = true;
vim.o.lazyredraw = true; -- Redraw only as needed.
vim.o.showmatch = true; -- Highlight matching parens.

-- SIDEBAR
vim.wo.number = true;
vim.wo.relativenumber = true;
vim.o.showcmd = true; -- Show command in bottom bar.

-- IGNORANCE
vim.o.wildignore = vim.o.wildignore .. '*/tmp/*,*.so,*.swp,*.zip,*~';

-- Remap ctrl+a and ctrl+e to home and end respectively
vim.api.nvim_set_keymap('n', '<C-a>', '<Home>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-e>', '<End>', {noremap = true})

local silent = { silent = true }
local noremap = { noremap = true }

local noremap_silent = { noremap = true, silent = true }

-- Movement.
vim.api.nvim_set_keymap("n", "j", "gj", noremap)
vim.api.nvim_set_keymap("n", "k", "gk", noremap)

-- Shortcuts
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', noremap) -- Copy.
vim.api.nvim_set_keymap("n", "<leader>p", '"+gp', noremap) -- Paste.

require("lazy").setup({
    spec = {
		{
			"nvim-treesitter/nvim-treesitter",
			cond = function()
				return not vim.g.vscode
			end,
			event = { "BufReadPost", "BufNewFile" },
			build = ":TSUpdate",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			opts = {
				ensure_installed = {
					"lua",
					"terraform",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
				},
				sync_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			},
			config = function(_, opts)
				require("nvim-treesitter.configs").setup(opts)
			end,
		},

		{
			"nvim-telescope/telescope.nvim",
			cond = function()
				return not vim.g.vscode
			end,
			version = "0.1.5",
			cmd = "Telescope",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return not vim.g.vscode and vim.fn.executable("make") == 1
					end,
				},
			},
			-- lazy-load telescope on first use
			keys = function()
				local b = function(fn)
					return function()
						require("telescope.builtin")[fn]()
					end
				end
				local utils = function()
					return require("telescope.utils")
				end
				return {
					{ "<leader>ff", b("find_files"), desc = "Telescope: Find Files" },
					{
						"<leader>fc",
						function()
							require("telescope.builtin").find_files({ cwd = utils().buffer_dir() })
						end,
						desc = "Telescope: Find Files (buffer dir)",
					},
					{ "<leader>fg", b("live_grep"), desc = "Telescope: Live Grep" },
					{ "<leader>fb", b("buffers"), desc = "Telescope: Buffers" },
					{ "<leader>fh", b("help_tags"), desc = "Telescope: Help Tags" },
					{ "<leader>fd", b("diagnostics"), desc = "Telescope: Diagnostics" },
				}
			end,
			config = function()
				local telescope = require("telescope")
				telescope.setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})
				pcall(telescope.load_extension, "fzf")
				pcall(telescope.load_extension, "ui-select")
			end,
		},

		-- Mason UI opens fast when you actually need it; lspconfig loads on first buffer
		{
			"williamboman/mason.nvim",
			cmd = { "Mason", "MasonInstall", "MasonUpdate" },
			config = function()
				require("mason").setup()
			end,
		},
		{
			"neovim/nvim-lspconfig",
			event = { "BufReadPre", "BufNewFile" },
		},
		{
			"williamboman/mason-lspconfig.nvim",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"gopls",
						"pyrefly",
					},
					automatic_enable = not vim.g.vscode,
				})

				-- If running inside VSCode (vim.g.vscode = true), don't start any LSP
				if vim.g.vscode then
					return
				end

				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
					callback = function(event)
						-- modified from https://github.com/nvim-lua/kickstart.nvim
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end
						-- Jump to the definition of the word under your cursor.
						--  This is where a variable was first declared, or where a function is defined, etc.
						--  To jump back, press <C-t>.
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

						-- Find references for the word under your cursor.
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

						-- Jump to the implementation of the word under your cursor.
						--  Useful when your language has ways of declaring types without an actual implementation.
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

						-- Jump to the type of the word under your cursor.
						--  Useful when you're not sure what type a variable is and you want to see
						--  the definition of its *type*, not where it was *defined*.
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

						-- Fuzzy find all the symbols in your current document.
						--  Symbols are things like variables, functions, types, etc.
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

						-- Fuzzy find all the symbols in your current workspace.
						--  Similar to document symbols, except searches over your entire project.
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if
							client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
						then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end

						-- The following code creates a keymap to toggle inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})
			end,
		},

		-- Whitespace (load on file open; command also available)
		{
			"ntpeters/vim-better-whitespace",
			event = { "BufReadPost", "BufNewFile" },
			cmd = { "StripWhitespace" },
		},

		-- Indent text object (tiny, just load very lazily)
		{ "michaeljsmith/vim-indent-object", event = "VeryLazy" },

		{
			"saghen/blink.cmp",
			cond = function()
				return not vim.g.vscode
			end,
			version = "1.*",
			opts = {
				keymap = { preset = "default" },
				appearance = {
					nerd_font_variant = "normal",
				},
				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = false } },

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},

		{
			"nvim-mini/mini.comment",
			event = "VeryLazy",
			cond = function()
				return not vim.g.vscode
			end,
			opts = {
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
				},
			},
		},

		{
			"nvim-mini/mini.surround",
			version = "*",
			opts = {
				mappings = {
					add = "gsa", -- Add surrounding in Normal and Visual modes
					delete = "gsd", -- Delete surrounding
					find = "gsf", -- Find surrounding (to the right)
					find_left = "gsF", -- Find surrounding (to the left)
					highlight = "gsh", -- Highlight surrounding
					replace = "gsr", -- Replace surrounding
					update_n_lines = "gsn", -- Update `n_lines`
				},
			},
		},

		-- tpope classics (lightweight; load when you actually hit them)
		{ "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gblame", "Gread", "Gwrite", "Ggrep" } },
		{ "tpope/vim-rhubarb", cmd = { "GBrowse" } }, -- rhubarb enhances fugitive
		{ "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
	},

    install = {},
    checker = { enabled = false },

    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

if not vim.g.vscode then
    local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
    local result = handle:read('*a')
    handle:close()
    local config_dir = vim.fn.stdpath('config')
    if result:find("Dark") then
        vim.cmd('source ' .. config_dir .. '/tempus_night.vim')
    else
        vim.cmd('source ' .. config_dir .. '/tempus_totus.vim')
    end
end
