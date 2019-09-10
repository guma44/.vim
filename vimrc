" General
set noautochdir         " Don't chdir to the location where the file is by default
set confirm             " Instead of failing a command because of unsaved changes, instead raise a dialogue asking if you wish to save changed files.
set mouse=a             " Enable use of the mouse for all modes
set mousehide
set virtualedit=onemore
set backup            " Don't create backup files
set backupdir=~/.vimbackup

if has('persistent_undo')
   set undofile                " So is persistent undo ...
   set undodir=$HOME/.vimundo
   set undolevels=1000         " Maximum number of changes that can be undone
   set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

syntax enable           " enable syntax processing

" Spaces & Tabs
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab
set shiftwidth=4        " when indenting with '>', use 4 spaces width
set smarttab
set autoindent
set backspace=indent,eol,start  " Backspace for dummies
filetype indent on      " load filetype-specific indent files
filetype plugin on
" Tab in normal mode is used to jump between parenthesis
nnoremap <tab> %
vnoremap <tab> %
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier formatting
nnoremap <silent> <leader>q gwip

" UI Layout
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set lazyredraw          " redraw only when we need to (e.g. don't redraw while executing macros)
set showmatch           " higlight matching parenthesis
set wildmenu            " visual autocomplete for command menu
set wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc   " Ignore compiled files

" Searching
set ignorecase smartcase          " make searches case-insensitive, unless they contain upper-case letters
set incsearch           " search as characters are entered
set incsearch showmatch hlsearch  " show the `best match so far' as search strings are typed and highlight it
" Map <C-L> (redraw screen) to also turn off search highlighting until the next search
nnoremap <C-L> :noh<CR><C-L>

" Scrolling
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor

" Folding
set foldmethod=indent   " fold based on indent level
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " max 10 nested fold

"Lists
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" space open/closes folds
nnoremap <space> za

" Line Shortcuts
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default
map Y y$
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Window
set splitright          " Force vsplit to open new window on the right
set splitbelow          " Force vsplit to open new window below
" Move between split windows more naturally
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
" replaces the 'Redraw screen' action. :redraw doesn't do the same thing.
map <C-L> <C-W>l

" vim's status line
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%#Error#                     " color highlight for Syntastic error
set statusline+=%{SyntasticStatuslineFlag()} " Syntastic error location
set statusline+=%*                           " reset highlight
set statusline+=%-8.(%)                      " offset
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset
set laststatus=2        " Always display statusline, even if there's only one window in vim

let mapleader = ','  " map leader to coma
" ############################################################################


" Key (re)Mappings

" ############################################################################
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_


" Git - Displaying git content in a split window
" move the cursor to line 0 if doing a git commit
autocmd BufRead *.git/COMMIT_EDITMSG 0
" split window with currect git diff --cached
autocmd BufRead *.git/COMMIT_EDITMSG DiffGitCached -C --patch --stat --no-ext-diff | wincmd L
" set different files coloring
autocmd BufRead,BufNewFile *.fasta,*.fa set filetype=fasta
autocmd BufRead,BufNewFile *.bed,*.tsv,*.tab :RainbowTab

"Start in the last position when opening a file
if has("autocmd")
   augroup LastPos
   au!
   autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  exe "normal g`\"" | endif
   augroup END
endif

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif


" declare plugins
silent! if plug#begin()

    " NERD tree will be loaded on the first invocation of NERDTreeToggle command
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    " Nerd commenter too
    Plug 'scrooloose/nerdcommenter'
    " Monokai color scheme
    Plug 'crusoexia/vim-monokai'
    Plug 'mechatroner/rainbow_csv'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " a syntax checking plugin for Vim that integrates with external syntax checkers to provide in-editor feedback on your code as you make changes
    Plug 'scrooloose/syntastic'
    " JSON support
    Plug 'elzr/vim-json'
    " Comments
    Plug 'tpope/vim-commentary'
    " Surround text with parentheses, brackets, quotes, XML tags, and more
    Plug 'tpope/vim-surround'
    Plug 'broadinstitute/vim-wdl'
    Plug 'luochen1990/rainbow'
    Plug 'mechatroner/rainbow_csv'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'sirver/ultisnips'
    " Plug 'valloric/youcompleteme'

  call plug#end()
endif

" Colors
colorscheme monokai
let airline_theme='molokai'
set t_ut=               " disable Background Color Erase (BCE) so color schemes work properly when Vim is used inside tmux and GNU screen
let g:NERDSpaceDelims=1 " add some space to the comments

" syntastic
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_python_checker = 1
let g:syntastic_python_checkers = ['pep8'] " ['pylint' , 'pyflakes', 'pep8']
let g:syntastic_python_pep8_args="--max-line-length=79"
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

" UltiSnips
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-u>"
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsListSnippets = "<c-tab>"

" snippets
let g:ultisnips_python_style = "sphinx"
