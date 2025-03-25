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


local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

-- LSP setup
lspconfig.pyright.setup { capabilities = capabilities }
lspconfig.clangd.setup { capabilities = capabilities }
lspconfig.hls.setup { 
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	filetypes = { "haskell", "lhaskell" }
}

-- Load the theme
vim.cmd[[colorscheme tokyonight]]
require('tokyonight').setup({
    style = 'storm',
})
vim.o.background = 'dark'



require'nvim-treesitter.configs'.setup {
  ensure_installed = { "verilog" },
  highlight = { enable = true }
}

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require'lspconfig'.verible.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    root_dir = function() return vim.uv.cwd() end
}

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.g.copilot_enabled = 0
vim.o.shell = "/opt/homebrew/bin/fish"


vim.keymap.set('n', '<C-t>', function()
  vim.cmd("vsplit | terminal")
end, { noremap = true, silent = true })

