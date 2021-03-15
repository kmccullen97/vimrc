" General ----------------------------------------------------------------------
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
syntax on
set clipboard=unnamedplus
set relativenumber
set hidden
set nowrap
set nohlsearch
let mapleader = ' '

" Shortcuts for Split Navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move lines up and down with Alt-j and Alt-k
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" TODO: Move back 2 previous buffers (do this without plugin)
noremap <leader>^ :Buffers<CR> <Up> <Enter> 

" Plugins ----------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'stsewd/fzf-checkout.vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'mileszs/ack.vim'
Plug 'ThePrimeagen/harpoon'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'OmniSharp/omnisharp-vim'
Plug 'adamclerk/vim-razor'

call plug#end()


" Airline ----------------------------------------------------------------------
let g:airline#extensions#hunks#enabled=0


" Ale --------------------------------------------------------------------------
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\ }

let g:ale_fixers = {
\ 'typescriptreact': ['prettier', 'eslint']
\ }

let g:ale_fix_on_save = 1


" COC --------------------------------------------------------------------------
let g:coc_global_extensions = [
 \ 'coc-tsserver',
 \ 'coc-prettier',
 \ 'coc-eslint',
 \ 'coc-omnisharp'
 \ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Fugitive ---------------------------------------------------------------------
nmap <leader>gf :diffget //2<CR>
nmap <leader>gj :diffget //3<CR>


" Fzf --------------------------------------------------------------------------
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>

let g:fzf_layout = { 'down': '40%' }

noremap <leader>gb :GBranches<CR>


" Gruvbox ----------------------------------------------------------------------
colorscheme gruvbox
set background=dark


" Harpoon ----------------------------------------------------------------------
nmap <leader>tj :call GotoBuffer(0)<CR>
nmap <leader>tk :call GotoBuffer(1)<CR>
nmap <leader>tl :call GotoBuffer(2)<CR>
nmap <leader>t; :call GotoBuffer(3)<CR>



" NerdTree ---------------------------------------------------------------------
nnoremap <C-f> :NERDTreeToggle<CR>

" OmniSharp --------------------------------------------------------------------
autocmd FileType cs nmap <leader>hl <Plug>(omnisharp_highlight)
autocmd FileType cs nmap gd <Plug>(omnisharp_go_to_definition)
autocmd FileType cs nmap <leader>fu <Plug>(omnisharp_find_usages)
autocmd FileType cs nmap <leader>pd <Plug>(omnisharp_preview_definition)
autocmd FileType cs nmap <leader>fm <Plug>(omnisharp_find_members)
autocmd FileType cs nmap <leader>rn <Plug>(omnisharp_rename)

let g:OmniSharp_server_stdio = 0

autocmd BufNewFile,BufRead *.razor setf razor
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ keepend
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

autocmd BufNewFile,BufRead *.razor call TextEnableCodeSnip('cs', '@code {', '\n}', 'SpecialComment')

" Vimspector -------------------------------------------------------------------
nnoremap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader>ds :call vimspector#Reset()<CR>
