:set number
:set autoindent
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
" :set expandtab
:set mouse=a

call plug#begin()
Plug 'https://github.com/neovim/nvim-lspconfig' " LSP
Plug 'https://github.com/vim-scripts/DoxygenToolkit.vim' " Doxygen	
Plug 'https://github.com/vim-airline/vim-airline' " status bar 
Plug 'https://github.com/wbthomason/packer.nvim' " packer
Plug 'preservim/nerdtree' " file tree
Plug 'http://github.com/tpope/vim-surround' " Surrounding
Plug 'https://github.com/tpope/vim-commentary' " Comments
Plug 'https://github.com/ryanoasis/vim-devicons' "Icons
Plug 'https://github.com/nvim-treesitter/nvim-treesitter' "Syntax highlight
Plug 'https://github.com/jiangmiao/auto-pairs' "Pairs
Plug 'https://github.com/github/copilot.vim' "GH Copilot
Plug 'https://github.com/preservim/tagbar' "Tagbar
Plug 'https://github.com/folke/tokyonight.nvim' "Theme
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'dikiaap/minimalist'
call plug#end()

let &runtimepath.=', "~/.local/share/nvim/lua"'
:luafile ~/.local/share/nvim/lua/init.lua

:colorscheme tokyonight
vmap <Leader>s S)
nnoremap <Leader>l dd
nnoremap <Leader>w dw
nnoremap <C-f> :NERDTreeToggle<CR>
nnoremap <C-d> :NERDTreeFocus<CR>
nnoremap <Leader>v viw

nnoremap <A-up> 5<up>
nnoremap <A-down> 5<down>
nnoremap <A-left> 5<left>
nnoremap <A-right> 5<right>

vnoremap <A-up> 5<up>
vnoremap <A-down> 5<down>

vnoremap <A-left> 5<left>
vnoremap <A-right> 5<right>

nnoremap <A-h> 5<left>
nnoremap <A-j> 5<down>
nnoremap <A-k> 5<up>
nnoremap <A-l> 5<right>

vnoremap <A-h> 5<left>
vnoremap <A-j> 5<down>
vnoremap <A-k> 5<up>
vnoremap <A-l> 5<right>


nnoremap <A-t> :TagbarToggle<CR>
nnoremap <Leader>p Vap
nnoremap <Enter> i<Enter><Esc>
nnoremap <Backspace> i<Backspace><Esc>

" Map Ctrl+Shift+C to yank to the system clipboard
nnoremap <C-c> "+y
vnoremap <C-c> "+y

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
