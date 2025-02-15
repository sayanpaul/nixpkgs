-- Install packer
local install_path = "~/.local/share/nvim/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.cmd([[ packadd packer.nvim ]])
end

local use = require("packer").use
require("packer").startup(function()
    use("wbthomason/packer.nvim")
    use("michaeljsmith/vim-indent-object")
    use("neovim/nvim-lspconfig")
    use("ntpeters/vim-better-whitespace")
    use({
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    })
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      requires = {
          {'nvim-lua/plenary.nvim'},
          {'nvim-telescope/telescope-ui-select.nvim'},
      }
    }
    use("tpope/vim-abolish")
    use("tpope/vim-commentary")
    use("tpope/vim-fugitive")
    use("tpope/vim-sleuth")
    use("tpope/vim-surround")
end)

-- SETTTINGS
local home = os.getenv('HOME')

-- GLOBALS
vim.g.python3_host_prog = home .. '/.asdf/shims/python';

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

-- Buffers
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", noremap)
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", noremap)
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", noremap)
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", noremap)

-- FUGITIVE
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", noremap)
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", noremap)

if not vim.g.vscode then
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'terraform', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
        sync_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }

    local telescope_builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Telescope help tags' })

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
