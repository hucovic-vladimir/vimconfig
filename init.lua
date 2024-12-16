-- Plugin manager setup
require('packer').startup(function()
    use 'wbthomason/packer.nvim'  -- Let Packer manage itself

    -- LSP and autocompletion plugins
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    -- Additional plugins
    use 'vim-airline/vim-airline'
    use 'preservim/nerdtree'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'ryanoasis/vim-devicons'
    use 'nvim-treesitter/nvim-treesitter'
    use 'jiangmiao/auto-pairs'
    use 'github/copilot.vim'
    use 'preservim/tagbar'
    use 'folke/tokyonight.nvim'
    use 'leafgarland/typescript-vim'
    use 'ianks/vim-tsx'
    use 'dikiaap/minimalist'
    use { 'iamcco/markdown-preview.nvim', run = 'cd app && npm install', ft = { 'markdown' } }
    use {
        'L3MON4D3/LuaSnip',
        tag = 'v2.*',
        run = 'make install_jsregexp'
    }
end)

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

-- Leader key shortcuts
map('v', '<Leader>s', 'S)', opts)
map('n', '<Leader>l', 'dd', opts)
map('n', '<Leader>w', 'dw', opts)
map('n', '<C-f>', ':NERDTreeToggle<CR>', opts)
map('n', '<C-d>', ':NERDTreeFocus<CR>', opts)
map('n', '<Leader>v', 'viw', opts)

-- Arrow key mappings
local arrow_mappings = {
    { 'up', '5<Up>' },
    { 'down', '5<Down>' },
    { 'left', '5<Left>' },
    { 'right', '5<Right>' }
}
for _, dir in ipairs(arrow_mappings) do
    map('n', '<A-' .. dir[1] .. '>', dir[2], opts)
    map('v', '<A-' .. dir[1] .. '>', dir[2], opts)
end

-- Additional key mappings
map('n', '<A-h>', '5<Left>', opts)
map('n', '<A-j>', '5<Down>', opts)
map('n', '<A-k>', '5<Up>', opts)
map('n', '<A-l>', '5<Right>', opts)
map('n', '<A-t>', ':TagbarToggle<CR>', opts)
map('n', '<Leader>p', 'Vap', opts)
map('n', '<Enter>', 'i<Enter><Esc>', opts)
map('n', '<Backspace>', 'i<Backspace><Esc>', opts)
map('n', '<C-c>', '"+y', opts)
map('v', '<C-c>', '"+y', opts)

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Use cmdline & path source for `:`
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
    })
})

-- LSP setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').pyright.setup { capabilities = capabilities }
require('lspconfig').clangd.setup { capabilities = capabilities }

-- Load the theme
vim.cmd[[colorscheme tokyonight]]
require('tokyonight').setup({
    style = 'storm',
})
vim.o.background = 'dark'

