#!/usr/bin/env bash

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
tmux bind-key -n C-Left if-shell "$is_vim" "send-keys C-h" "resize-pane -L 5"
tmux bind-key -n C-Down if-shell "$is_vim" "send-keys C-j" "resize-pane -D 5"
tmux bind-key -n C-Up if-shell "$is_vim" "send-keys C-k" "resize-pane -U 5"
tmux bind-key -n C-Right if-shell "$is_vim" "send-keys C-l" "resize-pane -R 5"

tmux bind-key -T copy-mode-vi C-Left resize-pane -L 5
tmux bind-key -T copy-mode-vi C-Down resize-pane -D 5
tmux bind-key -T copy-mode-vi C-Up resize-pane -U 5
tmux bind-key -T copy-mode-vi C-Right resize-pane -R 5
