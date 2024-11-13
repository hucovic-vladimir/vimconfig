
-- Ensure Packer is installed
require('packer').startup(function()
    use 'wbthomason/packer.nvim'  -- Let Packer manage itself

    -- Add your other plugins here
    use 'neovim/nvim-lspconfig'  -- LSP
    -- Add more plugins as needed
end)

require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}

-- Basic settings
vim.o.number = true
vim.o.autoindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.mouse = 'a'
vim.o.encoding = 'utf-8'
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.signcolumn = 'yes'

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('v', '<Leader>s', 'S)', opts)
map('n', '<Leader>l', 'dd', opts)
map('n', '<Leader>w', 'dw', opts)
map('n', '<C-f>', ':NERDTreeToggle<CR>', opts)
map('n', '<C-d>', ':NERDTreeFocus<CR>', opts)
map('n', '<Leader>v', 'viw', opts)

local arrow_mappings = {
    { 'up', '5<up>' },
    { 'down', '5<down>' },
    { 'left', '5<left>' },
    { 'right', '5<right>' }
}

for _, dir in ipairs(arrow_mappings) do
    map('n', '<A-' .. dir[1] .. '>', dir[2], opts)
    map('v', '<A-' .. dir[1] .. '>', dir[2], opts)
end

map('n', '<A-h>', '5<left>', opts)
map('n', '<A-j>', '5<down>', opts)
map('n', '<A-k>', '5<up>', opts)
map('n', '<A-l>', '5<right>', opts)
map('v', '<A-h>', '5<left>', opts)
map('v', '<A-j>', '5<down>', opts)
map('v', '<A-k>', '5<up>', opts)
map('v', '<A-l>', '5<right>', opts)

map('n', '<A-t>', ':TagbarToggle<CR>', opts)
map('n', '<Leader>p', 'Vap', opts)
map('n', '<Enter>', 'i<Enter><Esc>', opts)
map('n', '<Backspace>', 'i<Backspace><Esc>', opts)

-- Yank to system clipboard
map('n', '<C-c>', '"+y', opts)
map('v', '<C-c>', '"+y', opts)

-- LSP and plugins setup
require('packer').startup(function()
    use 'neovim/nvim-lspconfig'          -- LSP
    use 'vim-scripts/DoxygenToolkit.vim' -- Doxygen
    use 'vim-airline/vim-airline'        -- status bar 
    use 'wbthomason/packer.nvim'         -- packer
    use 'preservim/nerdtree'             -- file tree
    use 'tpope/vim-surround'              -- Surrounding
    use 'tpope/vim-commentary'            -- Comments
    use 'ryanoasis/vim-devicons'          -- Icons
    use 'nvim-treesitter/nvim-treesitter' -- Syntax highlight
    use 'jiangmiao/auto-pairs'            -- Pairs
    use 'github/copilot.vim'              -- GH Copilot
    use 'preservim/tagbar'                -- Tagbar
    use 'folke/tokyonight.nvim'           -- Theme
    use 'leafgarland/typescript-vim'      -- TypeScript support
    use 'ianks/vim-tsx'                   -- TSX support
    use 'dikiaap/minimalist'               -- Minimalist
		use 'hrsh7th/nvim-cmp'       -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'   -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'      -- Buffer completions
    use 'hrsh7th/cmp-path'        -- File path completions
    use 'hrsh7th/cmp-cmdline'     -- Command line completions
    use 'hrsh7th/cmp-vsnip'       -- Snippet completions
		use 'hrsh7th/vim-vsnip'       -- Snippet engine
		use({
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!:).
			run = "make install_jsregexp"
		})
	end)


-- Set up nvim-cmp
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native Neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
		completion = {
			completeopt = 'menu,menuone,noinsert',
			autocomplete = { cmp.TriggerEvent.TextChanged },
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- Uncomment and install `petertriho/cmp-git` to use git completion
-- Set configuration for specific filetype
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

require("cmp_git").setup() ]]--

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for `:`
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig with nvim-cmp capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['pyright'].setup {
    capabilities = capabilities
}



require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}


-- Load the theme
vim.cmd[[colorscheme tokyonight]]

-- Optional: Set additional options for the theme
require('tokyonight').setup({
    style = 'storm',  -- Choose 'night', 'day', 'storm', etc.
    -- Other options can be set here
})

-- Set background
vim.o.background = 'dark'  -- or 'light'


vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = 'solarized',
	-- group = ...,
	callback = function()
		vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
			fg = '#555555',
			ctermfg = 8,
			force = true
		})
	end
})


vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<C-w>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

