#!/usr/bin/env bash

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
tmux bind-key -n M-Left if-shell "$is_vim" "send-keys C-h" "resize-pane -L 5"
tmux bind-key -n M-Down if-shell "$is_vim" "send-keys C-j" "resize-pane -D 5"
tmux bind-key -n M-Up if-shell "$is_vim" "send-keys C-k" "resize-pane -U 5"
tmux bind-key -n M-Right if-shell "$is_vim" "send-keys C-l" "resize-pane -R 5"

tmux bind-key -T copy-mode-vi M-Left resize-pane -L 5
tmux bind-key -T copy-mode-vi M-Down resize-pane -D 5
tmux bind-key -T copy-mode-vi M-Up resize-pane -U 5
tmux bind-key -T copy-mode-vi M-Right resize-pane -R 5
