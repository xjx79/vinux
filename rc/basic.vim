" basic package
" Package info {{{
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle','NERDTreeFind'] }
let s:sexy_command=[':NERDTreeToggle']
if te#env#check_requirement()
    Plug 'majutsushi/tagbar'
    " Open tagbar
    nnoremap <silent><F9> :TagbarToggle<CR>
    nnoremap <leader>tt :TagbarToggle<CR>
    call add(s:sexy_command, 'TagbarOpen')
else
    Plug 'tracyone/vim-taglist'
    nnoremap <silent><F9> :TlistToggle<CR>
    nnoremap <leader>tt :TlistToggle<CR>
    call add(s:sexy_command, ':TlistToggle')
endif
if te#env#IsMac()
    Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
elseif te#env#IsUnix()
    Plug 'Shougo/vimproc.vim', { 'do': 'make' }
else
    Plug 'Shougo/vimproc.vim'
endif
if !te#env#SupportTerminal() 
    Plug 'Shougo/vimshell.vim',{'on':'VimShell'}
    Plug 'tracyone/ctrlp-vimshell.vim',{'on':'VimShell'}
endif
Plug 'tracyone/love.vim'
Plug 'tracyone/mark.vim'
Plug 'itchyny/vim-cursorword'
Plug 'thinca/vim-quickrun',{'on': '<Plug>(quickrun)'}
if(!te#env#IsWindows())
    Plug 'vim-scripts/sudo.vim', {'on': ['SudoRead', 'SudoWrite']}
    if !te#env#IsNvim() 
        Plug 'lambdalisue/vim-manpager'
    endif
    if te#env#IsMac()
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote','on': [] }
    else
        Plug 'CodeFalling/fcitx-vim-osx', { 'on': [] }
    endif

    call te#feat#register_vim_plug_insert_setting([], 
                \ ['fcitx-vim-osx'])
endif
if te#env#IsVim8() || te#env#IsNvim()
    Plug 'neomake/neomake', { 'commit': '459ac69da3eb00850eb3efefe31b3fb237d7926d'}
    Plug 'tracyone/neomake-multiprocess'
    "ag search c family function
    nnoremap <leader>vf :call neomakemp#global_search(expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]")<cr>
    "set grepprg=ag\ --nogroup\ --nocolor
    "set grepformat=%f:%l:%c%m
else
    let g:grepper_plugin.cur_val = 'vim-easygrep'
endif
if g:grepper_plugin.cur_val ==# 'vim-easygrep'
    Plug 'dkprice/vim-easygrep',{'commit':'d0c36a77cc63c22648e792796b1815b44164653a'}
    let g:EasyGrepRecursive=1
    if te#env#Executable('rg')
        set grepprg=rg\ -H\ --no-heading\ --vimgrep\ $*
        let g:EasyGrepCommand="rg"
        set grepformat=%f:%l:%c:%m
    elseif te#env#Executable('ag')
        set grepprg=ag\ --nocolor\ --nogroup\ --vimgrep\ $*
        let g:EasyGrepCommand="ag"
        set grepformat=%f:%l:%c:%m
    elseif te#env#Executable('grep')
        set grepprg=grep\ -n\ $*\ /dev/null
        let g:EasyGrepCommand=1
    endif
    function s:search_in_opened_buffer()
        let g:EasyGrepMode=1
        execute 'normal '."\<plug>EgMapGrepCurrentWord_v"
        let g:EasyGrepMode=0
    endfunction
    function! Easygrep_mapping()
        map <silent> <Leader>vV <plug>EgMapGrepCurrentWord_v
        vmap <silent> <Leader>vV <plug>EgMapGrepSelection_v
        map <silent> <Leader>vv <plug>EgMapGrepCurrentWord_V
        vmap <silent> <Leader>vv <plug>EgMapGrepSelection_V
        map <silent> <Leader>vb :call <SID>search_in_opened_buffer()<cr>
        map <silent> <Leader>vi <plug>EgMapReplaceCurrentWord_r
        map <silent> <Leader>vI <plug>EgMapReplaceCurrentWord_R
        vmap <silent> <Leader>vi <plug>EgMapReplaceSelection_r
        vmap <silent> <Leader>vI <plug>EgMapReplaceSelection_R
        map <silent> <Leader>vo <plug>EgMapGrepOptions
        nnoremap  <Leader>vs :Grep 
    endfunction
    call te#feat#register_vim_enter_setting(function('Easygrep_mapping'))
endif
if get(g:, 'feat_enable_help') == 0
    Plug 'xolox/vim-session', {'on': ['OpenSession', 'SaveSession', 'DeleteSession']}
    Plug 'xolox/vim-misc', {'on': ['OpenSession', 'SaveSession', 'DeleteSession']}
    let g:session_autoload=0
    let g:session_autosave='no'
    " Session save 
    nnoremap <Leader>ss :SaveSession 
    " Session load
    nnoremap <Leader>sl :OpenSession<cr> 
    " Session delete
    nnoremap <Leader>sd :DeleteSession<cr>
    let g:session_directory=$VIMFILES.'/sessions'
endif
"}}}
" Tagbar {{{
let g:tagbar_left=0
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
let g:tagbar_iconchars = ['+', '-']
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen=1
"}}}
" Vimshell {{{
if(!te#env#SupportTerminal())
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_editor_command='gvim'
    let g:vimshell_prompt = '$ '
    if te#env#IsWindows()
        " Display user name on Windows.
        let g:vimshell_user_prompt = '$USERNAME." : ".fnamemodify(getcwd(), ":~").
                    \" [".b:vimshell.system_variables["status"]."]"'
    else
        " Display user name on Linux.
        let g:vimshell_user_prompt = '$USER." < ".te#git#get_cur_br_name().te#git#get_status()." \> "." : ".fnamemodify(getcwd(), ":~").
                    \" [".b:vimshell.system_variables["status"]."]"'
    endif

    "let g:vimshell_popup_command='rightbelow 10split'
    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    silent! call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
    silent! call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
    let g:vimshell_split_command='tabnew'
    augroup vimshell_group
        autocmd!
        au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head) 
                    \ | :imap <buffer> <c-l> <Plug>(vimshell_clear)
                    \ | :imap <buffer> <c-k> <c-o>:stopinsert<cr>:call ctrlp#vimshell#start()<cr> 
                    \ | :imap <buffer> <up> <c-o>:stopinsert<cr>:call ctrlp#vimshell#start()<cr>
                    \ | :imap <buffer> <c-d> <Plug>(vimshell_exit)
                    \ | :imap <buffer> <c-j> <Plug>(vimshell_enter) 
                    \ | setlocal completefunc=vimshell#complete#omnifunc omnifunc=vimshell#complete#omnifunc 
                    \ buftype= nonu nornu 
                    \ | call vimshell#altercmd#define('g', 'git') 
                    \ | call vimshell#altercmd#define('i', 'iexe') 
                    \ | call vimshell#altercmd#define('ls', 'ls --color=auto') 
                    \ | call vimshell#altercmd#define('ll', 'ls -al --color=auto') 
                    \ | call vimshell#altercmd#define('l', 'ls -al --color=auto') 
                    \ | call vimshell#altercmd#define('gtab', 'gvim --remote-tab') 
                    \ | call vimshell#altercmd#define('c', 'clear') 
        "\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

        "function! g:my_chpwd(args, context)
        "call vimshell#execute('ls')
        "endfunction

        autocmd FileType int-* call s:interactive_settings()
    augroup END
    function! s:interactive_settings()
    endfunction
    if te#env#IsWin64()
        let g:vimproc#dll_path=$VIMRUNTIME.'/vimproc_win64.dll'
    elseif te#env#IsWin32()
        let g:vimproc#dll_path=$VIMRUNTIME.'/vimproc_win32.dll'
    endif
endif

"}}}
" Nerdtree {{{
let g:NERDTreeShowLineNumbers=0	"don't show line number
let g:NERDTreeWinPos='left'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let g:NERDTreeShowBookmarks=1
let g:NERDTreeChDirMode=2
noremap <F12> :NERDTreeToggle .<CR> 
" Open nerd tree
nnoremap <leader>te :NERDTreeToggle .<CR> 
" Open nerd tree
nnoremap <leader>nf :NERDTreeFind<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
inoremap <F12> <ESC> :NERDTreeToggle<CR>
let g:cursorword = 0

"remove mapping of * and # in mark.vim
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap <leader>mm <Plug>MarkSet
xmap <Leader>mm <Plug>MarkSet
nmap <leader>mr <Plug>MarkRegex
xmap <Leader>mr <Plug>MarkRegex
nmap <leader>mn <Plug>MarkClear
xmap <leader>mn <Plug>MarkClear
nmap <leader>m? <Plug>MarkSearchAnyPrev
nmap <leader>m/ <Plug>MarkSearchAnyNext
"}}}
" Quickrun {{{
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'message',
            \   },
            \}

let g:quickrun_no_default_key_mappings = 1
map <F6> <Plug>(quickrun)
vnoremap <F6> :'<,'>QuickRun<cr>
" run cunrrent file
nmap <leader>yr <Plug>(quickrun)
" run selection text
vnoremap <leader>yr :'<,'>QuickRun<cr>
" }}}
" Misc {{{
if te#env#SupportAsync()
    let g:love_support_option=['termguicolors']
endif
" Save basic setting
nnoremap <Leader>lo :Love<cr>
nnoremap <Leader>sc :Neomake<cr>
"let g:neomake_open_list=2
if !te#env#IsGui()
    let g:neomake_info_sign = {'text': 'i', 'texthl': 'NeomakeInfoSign'}
    let g:neomake_warning_sign = {
                \ 'text': 'W',
                \ 'texthl': 'WarningMsg',
                \ }
    let g:neomake_error_sign = {
                \ 'text': 'E',
                \ 'texthl': 'ErrorMsg',
                \ }
endif

if g:enable_sexy_mode.cur_val ==# 'on'
    function! SexyCommnad()
        for l:n in s:sexy_command
            silent! execute l:n
        endfor
        silent! execute '2 wincmd w'
    endfunction
    call te#feat#register_vim_enter_setting(function('SexyCommnad'))
endif


" }}}
