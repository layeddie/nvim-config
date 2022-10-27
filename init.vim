:set number " Line numbers
:set relativenumber " Relative line numbers
:set tabstop=2 " Tab width
:set shiftwidth=2 " Indent width
:set expandtab " Use spaces instead of tabs
:set autoindent " Auto indent
:set smartindent " Smart indent
:set mouse=a " Mouse support

" Plugins
call plug#begin()

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
" Airline
Plug 'vim-airline/vim-airline'
" File system
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Copilot
Plug 'github/copilot.vim'
" Languages
Plug 'leafgarland/typescript-vim'
Plug 'elixir-editors/vim-elixir'
Plug 'lervag/vimtex'
" Git
Plug 'APZelos/blamer.nvim'
Plug 'tpope/vim-fugitive'
" Themes
Plug 'rafi/awesome-vim-colorschemes'
" Utilities
Plug 'ap/vim-css-color'
Plug 'tpope/vim-commentary'
Plug 'tc50cal/vim-terminal'
Plug 'mhinz/vim-mix-format'
Plug 'mhinz/vim-signify'
Plug 'airblade/vim-rooter'
Plug 'editorconfig/editorconfig-vim'

call plug#end()

" Key bindings
nnoremap <C-y> :redo<CR>
nnoremap <C-z> :u<CR>

nnoremap <C-n> :NERDTreeToggle<CR>

nnoremap <C-t> :term<CR>

map <c-o> :Buffers<cr>
map <c-p> :Files<cr>
nnoremap <c-f> :Rg<cr>

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Set jellybeans theme
:colorscheme jellybeans

" File associations
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

" Plugin config
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*'] " Exclude fugitive and scp
let NERDTreeShowHidden = 1 " Show hidden files
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-elixir'] " CoC extensions
let g:blamer_enabled = 1 " Enable Git blame
let g:mix_format_on_save = 1 " Format Elixir code on save

" Signify
let g:signify_sign_add = '+'
let g:signify_sign_delete = '_'
let g:signify_sign_delete_first_line = '-'
let g:signify_sign_change = '~'

" FZF 
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-v': 'split',
  \ 'ctrl-h': 'vsplit' }
" Enable per-command history.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" Tags command
let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
" FZF options
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden --ignore-vcs"
" Colors
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always -S -F '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),  <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" VimTex
let g:vimtex_view_general_viewer = 'firefox'
let g:vimtex_view_general_options = '@pdf'
