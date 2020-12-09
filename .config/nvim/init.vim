" Plug {{{
call plug#begin(stdpath('data') . '/plugged')
" Appearance
Plug 'itchyny/lightline.vim'           " Statusline (https://github.com/itchyny/lightline.vim)
Plug 'nathanaelkane/vim-indent-guides' " Display indents (https://github.com/nathanaelkane/vim-indent-guides)
Plug 'morhetz/gruvbox'                 " Colorscheme (https://github.com/morhetz/gruvbox)

" IDE
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                                                  " Fuzzy finder (https://github.com/junegunn/fzf.vim)
Plug 'airblade/vim-rooter'                                               " Change working dir to project root (https://github.com/airblade/vim-rooter)
Plug 'brooth/far.vim', { 'on': ['Far', 'Farr'] }                         " Find and replace (https://github.com/brooth/far.vim)
Plug 'jiangmiao/auto-pairs'                                              " Insert syntax in pairs (https://github.com/jiangmiao/auto-pairs)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }                        " Intellisense engine (https://github.com/neoclide/coc.nvim)
Plug 'norcalli/nvim-colorizer.lua'                                       " Colorizer (https://github.com/norcalli/nvim-colorizer.lua)
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind']  } " Tree explorer (https://github.com/preservim/nerdtree)
Plug 'vimwiki/vimwiki'                                                   " Personal wiki (https://github.com/vimwiki/vimwiki)

" Commands
Plug 'AndrewRadev/splitjoin.vim'                      " Toggle single and multi-line (https://github.com/AndrewRadev/splitjoin.vim)
Plug 'Asheq/close-buffers.vim', { 'on': ['Bdelete'] } " Close buffers (https://github.com/Asheq/close-buffers.vim)
Plug 'junegunn/vim-easy-align'                        " Align whitespace (https://github.com/junegunn/vim-easy-align)
Plug 'justinmk/vim-sneak'                             " Faster motions (https://github.com/justinmk/vim-sneak)
Plug 'mattn/emmet-vim'                                " Emmet for vim (https://github.com/mattn/emmet-vim)
Plug 'tomtom/tcomment_vim'                            " Commenting (https://github.com/tomtom/tcomment_vim)
Plug 'tpope/vim-abolish'                              " Word manipulation (https://github.com/tpope/vim-abolish)
Plug 'tpope/vim-obsession'                            " Update session automatically (https://github.com/tpope/vim-obsession)
Plug 'tpope/vim-repeat'                               " Better repeat commands (https://github.com/tpope/vim-repeat)
Plug 'tpope/vim-surround'                             " Simple quoting/parenthesizing (https://github.com/tpope/vim-surround)
Plug 'tpope/vim-unimpaired'                           " Handy bracket mappings (https://github.com/tpope/vim-unimpaired)

" Git
Plug 'mhinz/vim-signify'  " Diff sign column (https://github.com/mhinz/vim-signify)
Plug 'tpope/vim-fugitive' " Git wrapper (https://github.com/tpope/vim-fugitive)
Plug 'tpope/vim-rhubarb'  " vim-fugitive GitHub extension (https://github.com/tpope/vim-rhubarb)

" Tmux
Plug 'christoomey/vim-tmux-navigator' " Move between tmux panes and vim splits (https://github.com/christoomey/vim-tmux-navigator)
Plug 'christoomey/vim-tmux-runner'    " Control tmux from vim (https://github.com/christoomey/vim-tmux-runner)

" Language
Plug 'mattn/vim-lsp-settings' " Config for vim-lsp (https://github.com/mattn/vim-lsp-settings)
Plug 'prabirshrestha/vim-lsp' " Language server protocol (https://github.com/prabirshrestha/vim-lsp)
Plug 'sheerun/vim-polyglot'   " Syntax highlighting (https://github.com/sheerun/vim-polyglot)

Plug 'tmhedberg/SimpylFold', { 'for': 'python' }      " Python code folding (https://github.com/tmhedberg/SimpylFold)
Plug 'hashivim/vim-terraform', { 'for': 'terraform' } " Terraform integration (https://github.com/hashivim/vim-terraform)

" Snippets
Plug 'epilande/vim-es2015-snippets' " (https://github.com/epilande/vim-es2015-snippets)
Plug 'epilande/vim-react-snippets'  " (https://github.com/epilande/vim-react-snippets)
call plug#end()
" }}}
" General {{{
set clipboard+=unnamedplus     " Use clipboard for all operations
set colorcolumn=80             " Show a column at 80
set complete+=kspell           " Autocomplete when spell check is on
set cursorline                 " Highlight current line
set expandtab                  " Expand tabs into spaces
set hidden                     " Handle multiple buffers better
set nobackup
set noshowmode                 " Hide redundant mode
set nowritebackup
set noswapfile
set number                     " Show line numbers
set relativenumber             " Line numbers relative to cursor
set scrolloff=5                " Always show at least five lines above/below cursor
set shiftwidth=4               " Indent four spaces
set shortmess=Iac              " Disable start up message and abbreviate items
set showbreak=↪
set sidescrolloff=5            " Always show at least five columns left/right cursor
set signcolumn=yes             " Always show the signcolumn
set smartcase                  " Switch to case-sensitive search for capital letters
set spelllang=en_us
set spellfile=$XDG_CONFIG_HOME/nvim/spell/en.utf-8.add
set splitbelow                 " More natural split opening
set splitright
set termguicolors              " Support for true color (https://github.com/termstandard/colors)
set title                      " Set the terminal title
set updatetime=300             " Shorten update time
set visualbell                 " Disable beeping
set wildmode=longest:full,full " Completion settings
" }}}
" Key Mappings {{{
" H to move to the first character in a line
nmap H ^
" L to move to the last character in a line
nmap L g_

" Move up/down five lines
nmap J 5j
nmap K 5k
vmap J 5j
vmap K 5k

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

" Yank to end of current line
nmap Y y$

" Visually select the text that was last edited/pasted (Vimcast#26).
nmap gV `[v`]

" Replay macro
nmap Q @q

" Disable arrow keys
no <down> <Nop>
no <left> <Nop>
no <right> <Nop>
no <up> <Nop>
" }}}
" Leader Commands {{{
let mapleader=" "  "

" Rapid editing/sourcing config
nmap <Leader>rc :vsp $MYVIMRC<CR>
nmap <Leader>so :source $MYVIMRC<CR>

" Quick save/quit
nmap <silent><Leader>w :w<CR>
nmap <silent><Leader>q :q<CR>

" Asheq/close-buffers.vim (https://github.com/Asheq/close-buffers.vim)
nmap <silent><Leader>d :Bdelete menu<CR>

" christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
nmap <silent><Leader>v :VtrSendCommandToRunner<Space>
nmap <silent><Leader>va :VtrAttachToPane<Space>
nmap <silent><Leader>vc :VtrSendCtrlC<CR>
nmap <silent><Leader>vf :VtrFocusRunner!<CR>
nmap <silent><Leader>vk :VtrKillRunner<CR>
nmap <silent><Leader>vo :VtrOpenRunner<CR>

" junegunn/fzf.vim (https://github.com/junegunn/fzf.vim)
nmap <silent><Leader>p :Files<CR>
nmap <silent><Leader>rg :Rg<CR>
nmap <silent><leader>* :Rg <C-R><C-W><CR>
nmap <silent><Leader>b :Buffers<CR>
nmap <silent><Leader>/ :BLines<CR>
nmap <silent><Leader>l :Lines<CR>
nmap <silent><Leader>c :Commands<CR>
nmap <silent><Leader>h :History<CR>
nmap <silent><Leader>: :History:<CR>
nmap <silent><Leader>F :Filetypes<CR>

" neoclide/coc.nvim (https://github.com/neoclide/coc.nvim)
nmap <silent><Leader>rn <Plug>(coc-rename)
nmap <silent><Leader>ac <Plug>(coc-codeaction)
nmap <silent><Leader>af <Plug>(coc-fix-current)
nmap <silent><Leader>y  :<C-u>CocList -A --normal yank<CR>

" preservim/nerdtree (https://github.com/preservim/nerdtree)
nmap <silent><Leader>e :NERDTreeToggle<CR>
nmap <silent><Leader>f :NERDTreeFind<CR>

" vimwiki/vimwiki (https://github.com/vimwiki/vimwiki)
nmap <silent><Leader>n <Plug>VimwikiMakeDiaryNote
nmap <silent><Leader>wg :RgVimwiki<CR>
" }}}
" Plugin Settings {{{
" AndrewRadev/splitjoin.vim (https://github.com/AndrewRadev/splitjoin.vim)
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping  = ''
nmap gss :SplitjoinSplit<CR>
nmap gsj :SplitjoinJoin<CR>

" brooth/far.vim (https://github.com/brooth/far.vim)
let g:far#source      = 'rg'
let g:far#enable_undo = 1

" christoomey/vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_save_on_switch      = 2

" christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
let g:VtrOrientation = 'v'
let g:VtrPercentage  = 20

" georgewitteman/vim-fish via sheerun/vim-polyglot (https://github.com/sheerun/vim-polyglot)
" https://github.com/georgewitteman/vim-fish#teach-a-vim-to-fish
if &shell =~# 'fish$'
    set shell=bash
endif

" hashivim/vim-terraform (https://github.com/hashivim/vim-terraform)
let g:terraform_align       = 1
let g:terraform_fmt_on_save = 1

" junegunn/fzf.vim (https://github.com/junegunn/fzf.vim)
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**'"
let $FZF_DEFAULT_OPTS    = '--layout=reverse'

" junegunn/vim-easy-align (https://github.com/junegunn/vim-easy-align)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" justinmk/vim-sneak (https://github.com/justinmk/vim-sneak)
let g:sneak#label = 1

" nathanaelkane/vim-indent-guides (https://github.com/nathanaelkane/vim-indent-guides)
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes     = ['help', 'nerdtree']

" norcalli/nvim-colorizer.lua (https://github.com/norcalli/nvim-colorizer.lua)
lua require'colorizer'.setup({ '*' }, { hsl_fn = true })

" preservim/nerdtree (https://github.com/preservim/nerdtree)
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeMinimalMenu         = 1
let g:NERDTreeShowHidden          = 1
let g:NERDTreeShowLineNumbers     = 0
let g:NERDTreeDirArrowExpandable  = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeStatusline          = '%#NonText#'

" morhetz/gruvbox (https://github.com/morhetz/gruvbox)
let g:gruvbox_contrast_dark    = 'hard'
let g:gruvbox_sign_column      = 'bg0'
let g:gruvbox_color_column     = 'bg0'
let g:gruvbox_invert_selection = 0
" Must be after gruvbox options
colorscheme gruvbox

" vimwiki/vimwiki (https://github.com/vimwiki/vimwiki)
let wiki1 = {
\    'auto_toc': 1,
\    'path': '~/.config/nvim/vimwiki/',
\    'syntax': 'markdown', 'ext': '.md',
\ }
let g:vimwiki_list           = [wiki1]
let g:vimwiki_table_mappings = 0
" }}}
" Coc {{{
let g:coc_global_extensions = [
\    'coc-eslint',
\    'coc-json',
\    'coc-snippets',
\    'coc-tailwindcss',
\    'coc-tsserver',
\    'coc-vimlsp',
\    'coc-yank',
\ ]

" Use tab for trigger completion with characters ahead and navigate
imap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <C-Space> to trigger completion
imap <silent><expr> <C-Space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use \ to show documentation in preview window
nmap <silent> \ :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" }}}
" Lightline {{{
let g:lightline = {
\   'colorscheme': 'gruvbox',
\   'active': {
\     'left': [
\       [],
\       ['mode', 'paste'],
\       ['gitbranch', 'readonly', 'filename']],
\     'right': [
\       [],
\       ['lineinfo'],
\       ['percent'],
\       ['coc_error', 'coc_warning', 'coc_hint', 'coc_info']],
\   },
\   'component_function': {
\     'gitbranch'  : 'FugitiveHead',
\     'filename'   : 'LightlineFilename',
\   },
\   'component_expand': {
\     'coc_error'    : 'LightlineCocErrors',
\     'coc_warning'  : 'LightlineCocWarnings',
\     'coc_info'     : 'LightlineCocInfos',
\     'coc_hint'     : 'LightlineCocHints',
\     'coc_fix'      : 'LightlineCocFixes',
\   },
\ }

let g:lightline.component_type = {
\   'coc_error'    : 'error',
\   'coc_warning'  : 'warning',
\   'coc_info'     : 'tabsel',
\   'coc_hint'     : 'middle',
\   'coc_fix'      : 'middle',
\ }

" Trim space between filename and modified sign
" https://github.com/itchyny/lightline.vim#can-i-trim-the-bar-between-the-filename-and-modified-sign
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" Coc Lightline
" https://github.com/neoclide/coc.nvim/issues/401#issuecomment-469051524
function! s:lightline_coc_diagnostic(kind) abort
    let info = get(b:, 'coc_diagnostic_info', 0)
    if empty(info) || get(info, a:kind, 0) == 0
        return ''
    endif
    let s = '●'
    return printf('%s %d', s, info[a:kind])
endfunction

function! LightlineCocErrors() abort
    return s:lightline_coc_diagnostic('error')
endfunction

function! LightlineCocWarnings() abort
    return s:lightline_coc_diagnostic('warning')
endfunction

function! LightlineCocInfos() abort
    return s:lightline_coc_diagnostic('information')
endfunction

function! LightlineCocHints() abort
    return s:lightline_coc_diagnostic('hints')
endfunction

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" }}}
" Autocommands {{{
" Hybrid line numbers
" Switch between relative and absolute line numbers based on mode
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * call SetRelativeNumber()
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Auto reload if file was changed somewhere else (for autoread)
autocmd CursorHold * checktime
" }}}
" Commands {{{
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0, '.')
command! -nargs=* -bang RgVimwiki
    \ call RipgrepFzf(<q-args>, <bang>0, '~/.vim/vimwiki')
" }}}
" Functions {{{
" Advanced ripgrep fzf integration
" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen, dir)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command], 'dir': a:dir}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" Set relativenumber only for certain files
function! SetRelativeNumber()
    if &filetype != 'nerdtree' && &filetype != 'fzf'
        set relativenumber
    endif
endfunction
" }}}
" vim:foldmethod=marker
