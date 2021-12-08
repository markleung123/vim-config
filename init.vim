""" ============= Vim-Plug =================
call plug#begin()

" Appearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'releas:we'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" React
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

" Emmet
Plug 'mattn/emmet-vim'

call plug#end()


""" ======== Main Configurations ===========
set nu cursorline
set wildmenu
set cmdheight=1
set laststatus=2

" A buffer becomes hidden when it is abandoned
set hidden

" Line after line
set backspace=indent,eol,start

" Smart when searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" Regex
set magic

" Update tab behavior
set expandtab
set autoindent smartindent
set tabstop=4 softtabstop=4 shiftwidth=4

" Set to auto read when a file is changed from the outside
set autoread

set wrap breakindent
set encoding=utf-8
set mouse=a
set textwidth=0
set fillchars+=vert:\
set list listchars=trail:»,tab:»-

set nocompatible
filetype plugin on

set path+=**
set wildignore+=*/node_modules/*

" I need COLOR!
syntax enable
set termguicolors
colorscheme gruvbox

" Having longer updatetime (default is 4000ms) leads to noticeable
" delays and poor user experience
set updatetime=300
set shortmess+=c

" Turn backup off since it's handled by git
set nobackup nowb noswapfile

" No annoying sound on errors
set noerrorbells novisualbell
set t_vb=
set tm=500

" Allow jsx syntax in .js files
let g:jsx_ext_required=0

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':.'
let g:airline_theme='night_owl'
let g:airline_powerline_fonts=1

let g:startify_fortune_use_unicode=1

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

let g:UltiSnipsExpandTrigger="<nop>"
inoremap <expr> <CR> pumvisible() ? "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"

let g:user_emmet_expandabbr_key="<C-e>"

" NERDTree setting
let NERDTreeShowHidden=1
let g:NERDTreeIgnore = ['^node_modules$']

" On vim start
autocmd VimEnter * if ''==@% | Startify | NERDTree | endif

" File configurations
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType scss setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript,jsx setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType typescript,tsx setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python,shell set commentstring=#\ %s

" Make it sothat if files are changed externally
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if !bufexists("[Command Line]") | checktime | endif
autocmd FileChangedShellPost *
            \ echohl WarningMsh | echo "File changed on disk. Buffer reloaded." | echohl None

" Make it so any .env files are correctly styled.
autocmd BufNewFile,BufRead * if expand('%t') =~ '.env' | set filetype=sh | endif

" ctags configurations
" set tags=tags
" autocmd BufWritePost *.js execute "![ -d src ] && ctags src"

" Spell check!
autocmd BufRead,BufNewFile *.txt,*.md,COMMIT_EDITMSG setlocal spell
map <leader>sc :setlocal spell!<CR>
hi SpellBad cterm=underline

" Auto completion
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-Space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction


""" =========== Key mappings ===============
let mapleader = " "
let g:mapleader = " "
nnoremap <Space> <Nop>

nmap <leader>f :find 
nnoremap <C-l> :CocCommand prettier.formatFile<CR>
" vmap <C-l> <Plug>(coc-format-selected)
nmap <C-s> <Plug>(coc-range-select)
xmap <C-s> <Plug>(coc-range-select)
nmap <Leader>r :NERDTreeRefreshRoot<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nmap <F2> <Plug>(coc-rename)
vnoremap <Leader>y "+y
nmap <Leader>p "+p

" No highlight!
nnoremap <leader>h :noh<CR>

" Buffer handling
nnoremap <leader>b :ls<CR>:b 
nnoremap <leader>w :bd<CR> 

" Move line up/down
nnoremap <C-j> :m .+1<CR>
nnoremap <C-k> :m .-2<CR>
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi

" Window split
nmap spl :set splitright<CR>:vsplit<CR>
nmap sph :set nosplitright<CR>:vsplit<CR>
nmap spj :set splitbelow<CR>:split<CR>
nmap spk :set nosplitbelow<CR>:split<CR>
" Window resize
map <A-=> :vertical resize+5<CR>
map <A--> :vertical resize-5<CR>
map <A-+> :resize+5<CR>
map <A-_> :resize-5<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Run script!
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>