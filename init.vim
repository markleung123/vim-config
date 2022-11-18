""" ============= Vim-Plug =================
call plug#begin()

" Appearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'
Plug 'lukas-reineke/indent-blankline.nvim'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'psliwka/vim-smoothie'

" React
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

" Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" C#
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'

Emmet
Plug 'mattn/emmet-vim'

" Rainbow csv
Plug 'mechatroner/rainbow_csv'

" matching JSX tag
Plug 'andymass/vim-matchup'

call plug#end()

" Enable Flutter menu
autocmd FileType dart :call FlutterMenu()

""" ======== Main Configurations ===========
"set foldmethod=syntax "syntax highlighting items specify folds  
"set foldcolumn=1 "defines 1 col at window left, to indicate folding  
"let javaScript_fold=1 "activate folding by JS syntax  
set foldlevelstart=99 "start file with all folds opened

set foldmethod=indent
set foldexpr=nvim_treesitter#foldexpr()

set nu cursorline
set wildmenu
set cmdheight=1
set laststatus=2

let g:indent_blankline_filetype_exclude = ['startify']

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
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-jedi',
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
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s' || getline('.')[col - 1]  =~# '\"'
endfunction


" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-Space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" use python3.8 in conda enviroment
if has('nvim') && !empty($CONDA_PREFIX)
  let g:python3_host_prog = $CONDA_PREFIX . '/bin/python3.8'
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
nnoremap <C-l> :call CocAction('format')<CR>

" vmap <C-l> <Plug>(coc-format-selected)
nmap <C-s> <Plug>(coc-range-select)
xmap <C-s> <Plug>(coc-range-select)
nmap <Leader>r :NERDTreeRefreshRoot<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nmap <F2> <Plug>(coc-rename)
vnoremap <Leader>y "+y
nmap <Leader>p "+p

" New tab
nnoremap <leader>nt :tabnew<CR>

" No highlight!
nnoremap <leader>h :noh<CR>

" Buffer handling
nnoremap <leader>b :ls<CR>:b 
nnoremap <leader>w :bd<CR> 

" Move cursor in insert mode
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

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

" echo your postion in code
nnoremap <C-A-k> :<c-u>MatchupWhereAmI?<cr>

" C#
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }
augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

" Flutter
let g:flutter_autoscroll = 1
nnoremap <leader>fa :FlutterRun -d all<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>
