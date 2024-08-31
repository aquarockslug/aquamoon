tmux set -g prefix C-p

# Split window
tmux bind -T prefix P split-window -v -c "#{pane_current_path}" # vertical
tmux bind -T prefix p split-window -h -c "#{pane_current_path}" # horizontal

# Move window
tmux bind -T prefix h select-window -t -1
tmux bind -T prefix l select-window -t +1

# Panes
tmux bind -n ^h select-pane -L
tmux bind -n ^j select-pane -D
tmux bind -n ^k select-pane -U
tmux bind -n ^l select-pane -R
tmux bind -n C-w kill-pane # ^w doesn't work?

# Vim like selection and copy text
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wcopy'

tmux set -g mouse on
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then tmux; fi
