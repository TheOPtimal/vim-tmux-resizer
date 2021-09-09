" Maps <C-Left/Down/Up/Right> to resize vim splits in the given direction.
" If the pane is right- or bottom-most, forwards the command to tmux

if exists("g:loaded_tmux_resizer") || &cp || !has('patch-8.1.1140')
  finish
endif
let g:loaded_tmux_resizer = 1

function! s:VimResize(direction)
  if a:direction == 'l'
    if winnr('l') == winnr()
      execute 'vertical resize -5'
    else
      execute 'vertical resize +5'
    endif
  elseif a:direction == 'h'
    if winnr('l') == winnr()
      execute 'vertical resize +5'
    else
      execute 'vertical resize -5'
    endif
  elseif a:direction == 'j'
    if winnr('j') == winnr()
      execute 'resize -5'
    else
      execute 'resize +5'
    endif
  elseif a:direction == 'k'
    if winnr('j') == winnr()
      execute 'resize +5'
    else
      execute 'resize -5'
    endif
  endif
endfunction

if !get(g:, 'tmux_resizer_no_mappings', 0)
  nnoremap <silent> <m-Left> :TmuxResizeLeft<cr>
  nnoremap <silent> <m-Down> :TmuxResizeDown<cr>
  nnoremap <silent> <m-Up> :TmuxResizeUp<cr>
  nnoremap <silent> <m-Right> :TmuxResizeRight<cr>
endif

if empty($TMUX)
  command! TmuxResizeLeft call s:VimResize('h')
  command! TmuxResizeDown call s:VimResize('j')
  command! TmuxResizeUp call s:VimResize('k')
  command! TmuxResizeRight call s:VimResize('l')
  finish
endif

command! TmuxResizeLeft call s:TmuxAwareResize('h')
command! TmuxResizeDown call s:TmuxAwareResize('j')
command! TmuxResizeUp call s:TmuxAwareResize('k')
command! TmuxResizeRight call s:TmuxAwareResize('l')

function! s:TmuxOrTmateExecutable()
  return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  let l:x=&shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag=l:x
  return retval
endfunction

function! s:TmuxresizerProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxresizerProcessList call s:TmuxresizerProcessList()

function! s:NeedsVitalityRedraw()
  return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:TmuxAwareResize(direction)
  let l:vim = 1
  if (a:direction == 'l' || a:direction == 'h') && winnr('l') == winnr()
    let l:vim = 0
  elseif (a:direction == 'j' || a:direction == 'k') && winnr('j') == winnr()
    let l:vim = 0
  endif
  " TODO: would be nice to detect when vim is an edge pane and resize internally
  if l:vim
    call s:VimResize(a:direction)
  else
    let args = 'resize-pane -' . tr(a:direction, 'hjkl', 'LDUR') . ' 5'
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
      redraw!
    endif
  endif
endfunction
