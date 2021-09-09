Vim Tmux Resizer
==================

This plugin is a re-fork-magining of Chris Toomey's [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator). When combined with a set of tmux key bindings, the plugin will allow you to resize seamlessly between vim and tmux splits using a consistent set of hotkeys.

**NOTE**: This requires tmux v1.8 or higher and vim 8.1.1104 or higher.

Usage
-----

This plugin provides the following mappings which allow you to resize between
Vim panes and tmux splits seamlessly.

- `<alt-left>` => Resize right-most pane border left
- `<alt-down>` => Resize lowest pane border down
- `<alt-up>` => Resize lowest pane border up
- `<alt-right>` => Resize right-most border right

**Note** - you don't need to use your tmux `prefix` key sequence before using
the mappings.

If you want to use alternate key mappings, see the [configuration section
below][].

Installation
------------

### Vim

If you don't have a preferred installation method, I recommend using [Vundle][].
Assuming you have Vundle installed and configured, the following steps will
install the plugin:

Add the following line to your `~/.vimrc` file

``` vim
Plugin 'evs-chris/vim-tmux-resizer'
```

Then run

```
:PluginInstall
```

If you are using Vim 8+, you don't need any plugin manager. Simply clone this repository inside `~/.vim/pack/plugin/start/` directory and restart Vim.

```
git clone git@github.com:evs-chris/vim-tmux-resizer.git ~/.vim/pack/plugins/start/vim-tmux-resizer
```


### tmux

To configure the tmux side of this customization there are two options:

#### Add a snippet

Add the following to your `~/.tmux.conf` file:

``` tmux
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/evs-chris/vim-tmux-resizer
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-Left'  'resize-pane -L 5'
bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-Down'  'resize-pane -D 5'
bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-Up'  'resize-pane -U 5'
bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-Right'  'resize-pane -R 5'

bind-key -T copy-mode-vi 'C-Left' resize-pane -L 5
bind-key -T copy-mode-vi 'C-Down' resize-pane -D 5
bind-key -T copy-mode-vi 'C-Up' resize-pane -U 5
bind-key -T copy-mode-vi 'C-Right' resize-pane -R 5
```

Configuration
-------------

### Custom Key Bindings

If you don't want the plugin to create any mappings, you can use the four
provided functions to define your own custom maps. You will need to define
custom mappings in your `~/.vimrc` as well as update the bindings in tmux to
match.

#### Vim

Add the following to your `~/.vimrc` to define your custom maps:

``` vim
let g:tmux_resizer_no_mappings = 1

nnoremap <silent> {Left-Mapping} :TmuxResizeLeft<cr>
nnoremap <silent> {Down-Mapping} :TmuxResizeDown<cr>
nnoremap <silent> {Up-Mapping} :TmuxResizeUp<cr>
nnoremap <silent> {Right-Mapping} :TmuxResizeRight<cr>
```

*Note* Each instance of `{Left-Mapping}` or `{Down-Mapping}` must be replaced
in the above code with the desired mapping. Ie, the mapping for `<Alt-Left>` =>
Left would be created with `nnoremap <silent> <m-Left> :TmuxResizeLeft<cr>`.

#### Tmux

Alter each of the lines of the tmux configuration listed above to use your
custom mappings. **Note** each line contains two references to the desired
mapping.

### Additional Customization

#### Nesting

I dunno, maybe don't? It might work or might not. I personally try to avoid nested sessions, so it's untested. I'm happy to accept PRs that fix jank, though.

Troubleshooting
---------------

### Vim doesn't do C-Left and friends

You'll likely need to tell it how for your terminal emulator. Thanks to [this handy StackExchange](https://unix.stackexchange.com/questions/1709/how-to-fix-ctrl-arrows-in-vim), the
way forward is to get in insert mode and press ctrl-v ctrl-<arrow> once for each
of up, down, left, and right and create a vim mapping for each output. Make sure you're holding ctrl for the arrows too.

If you get `^[1;5A` for up, like I did, you can map it with `map <ESC>[1;5A <M-Up>` in your vimrc. The important note here is that `^` is `<ESC>` and everyting else is usually literal. For reference in Konsole, my mappings are:

```vimscript
map <ESC>[1;5A <M-Up>
map <ESC>[1;5B <M-Down>
map <ESC>[1;5D <M-Left>
map <ESC>[1;5C <M-Right>
```

### Vim -> Tmux doesn't work!

This is likely due to conflicting key mappings in your `~/.vimrc`. You can use
the following search pattern to find conflicting mappings
`\vn(nore)?map\s+\<c-(Left|Down|Up|Right)\>`. Any matching lines should be deleted or
altered to avoid conflicting with the mappings from the plugin.

Another option is that the pattern matching included in the `.tmux.conf` is
not recognizing that Vim is active. To check that tmux is properly recognizing
Vim, use the provided Vim command `:TmuxResizerProcessList`. The output of
that command should be a list like:

```
Ss   -zsh
S+   vim
S+   tmux
```

If you encounter a different output please [open an issue][] with as much info
about your OS, Vim version, and tmux version as possible.

[open an issue]: https://github.com/evs-chris/vim-tmux-resizer/issues/new

### Tmux Can't Tell if Vim Is Active

This functionality requires tmux version 1.8 or higher. You can check your
version to confirm with this shell command:

``` bash
tmux -V # should return 'tmux 1.8'
```

### It Still Doesn't Work!!!

The tmux configuration uses an inlined grep pattern match to help determine if
the current pane is running Vim. If you run into any issues with the resizing
not happening as expected, you can try using [Mislav's original external
script][] which has a more robust check.

[Vundle]: https://github.com/gmarik/vundle
[configuration section below]: #custom-key-bindings
