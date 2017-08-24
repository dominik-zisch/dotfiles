 " Turn on smart indent
set smartindent              " use intelligent indenation for C
set autoindent               " use indentation of previous line
set tabstop=2                " set tab character to 4 characters
set expandtab                " turn tabs into whitespace
set shiftwidth=2             " indent width for autoindent
filetype indent on           " indent depends on filetype

 " Shortcut to auto indent entire file
nmap <F7> 1G=G
imap <F7> <ESC>1G=Ga

 " Set color scheme
set t_Co=256
syntax on

 " Turn on incremental search with ignore case (except explicit caps)
set incsearch
set ignorecase
set smartcase

 " Enable indent folding
 " set foldenable
 " set fdm=indent

 " Set space to toggle a fold
 " nnoremap <space> za

 " Set line numbers
set number

 " highlight matching braces
set showmatch

" DoxygenToolkit
let g:DoxygenToolkit_authorName="Dominik Zisch <dominik.zisch@gmail.com>"

 " in normal mode F5 will save the file
nmap <F5> :w<CR>

 " in insert mode F5 will exit insert, save, enters insert again
imap <F5> <ESC>:w<CR>i

 " create doxygen comment
map <F6> :Dox<CR>


