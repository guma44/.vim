" GENERAL
" ############################################################################################
filetype off
set nocompatible
execute pathogen#infect()
set encoding=utf-8
filetype plugin indent on   " set the syntax indent
filetype plugin on
syntax enable                 " Syntax highlighting

" set default behaviour for other filetypes than python
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent                  " Indent at the same level of the previous line
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set pastetoggle=<F9>           " pastetoggle (sane indentation on pastes)

set backspace=indent,eol,start  " Backspace for dummies
set background=dark         " Assume a dark background

" mouse behaviour
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

set clipboard=exclude:.*
" set clipboard+=unnamedplus   " set the register to clipboard
" set clipboard+=unnamed
set history=1000            " set a lot of history
set virtualedit=onemore     " Allow for cursor beyond last character
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set spell                           " Spell checking on
set hidden                          " Allow buffer switching without saving

set backup                  " Backups are nice ...
set backupdir=~/tmp
if has('persistent_undo')
   set undofile                " So is persistent undo ...
   set undodir=$HOME/.vimundo
   set undolevels=1000         " Maximum number of changes that can be undone
   set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" set different files coloring
autocmd BufRead,BufNewFile *.fasta,*.fa set filetype=fasta
autocmd BufRead,BufNewFile *.bed,*.tsv,*.tab,*.asmbed :RainbowTab

"Start in the last position when opening a file
if has("autocmd")
   augroup LastPos
   au!
   autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  exe "normal g`\"" | endif
   augroup END
endif


" set solarized monokai
set t_Co=256
colorscheme monokai

set cursorline                  " Highlight current line
set showmode
highlight clear SignColumn      " SignColumn should match background
" highlight clear LineNr          " Current line number row will have same background color in relative mode
let g:CSApprox_hook_post = ['hi clear SignColumn']


if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set relativenumber              " Relative line numbers
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

let mapleader = ','  " map leader to coma
" ############################################################################


" Key (re)Mappings
" ############################################################################
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk
nnoremap Y y$

nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier formatting
nnoremap <silent> <leader>q gwip

" ##############################################################################

" PLUGINS
" ##############################################################################
" NerdComenter
let g:NERDSpaceDelims=1 " add some space to the comments

" neocomplicache

let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_max_list = 15
let g:neocomplcache_force_overwrite_completefunc = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" syntastic
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_python_checker = 1
let g:syntastic_python_checkers = ['pep8'] " ['pylint' , 'pyflakes', 'pep8']
let g:syntastic_python_pep8_args="--max-line-length=99"
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = "EE"  " - For syntax errors, defaults to '>>'
let g:syntastic_style_error_symbol = "ES"    " - For style errors, defaults to 'S>'
let g:syntastic_warning_symbol = "WW" " - For syntax warnings, defaults to '>>'
let g:syntastic_style_warning_symbol = "WS" " - For style warnings, defaults to 'S>'
let g:syntastic_loc_list_height = 5
let g:syntastic_quiet_messages = {"regex": '\m\[C0[13]\d\d\]'}
set completeopt-=preview

" fugitive (GIT)
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>

" rainbow columns
let g:disable_rainbow_csv_autodetect = 0
let g:rcsv_max_columns = 30

" vim-template
" let g:templates_plugin_loaded = 1 " to skip loading of this plugin.
" let g:templates_no_autocmd = 0 " to disable automatic insertion of template in new files.
" let g:templates_debug = 1 " to have vim-template output debug information
let g:email = "r.gumienny@unibas"
let g:username = "Rafal Gumienny"
let g:license = "GPL"

" UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-u>"
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsListSnippets = "<c-tab>"

" snippets
let g:ultisnips_python_style = "sphinx"

