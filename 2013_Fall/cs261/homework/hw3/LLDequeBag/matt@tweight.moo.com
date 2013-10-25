# unbind some default keybindings
unbind C-b

# set prefix key to ctrl-a
set -g prefix C-a

# set C-a k to kill session
bind q kill-session

# Set title to something descriptive of the entire sessions
set-option -g set-titles on

# window number, program name, active vel non
set-option -g set-titles-string '#H:#S.#I.#P #W #T'

# If a bell is used in any of the attached sessions, trigger a
# bell in the current window
set-option -g bell-action any

# Aggressive-resize makes it so that tmux only resizes windows
# in larger clients when smaller clients are actually looking at it
setw -g aggressive-resize on

# Enlarge console history
set -g history-limit 100000

# lower command delay
set -sg escape-time 1

# start first window and pane at 1, not zero
set -g base-index 1
set -g pane-base-index 1

# bind r to reloading the config file
bind r source-file ~/.tmux.conf \; display "Reloaded tmux config file."

# pass through a ctrl-a if you press it twice
bind C-a send-prefix

# better mnemonics for splitting panes!
bind | split-window -h
bind - split-window -v

# vim / xmonad style bindings for pane movement
bind -r h select-pane -L
bind -r j select-pane -D
bind -r k select-pane -U
bind -r l select-pane -R

# vim / xmonad style bindings for window movement
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# shift-movement keys will resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# disable mouse support (at least while we're learning)
setw -g mode-mouse off
set -g mouse-select-pane off
set -g mouse-resize-pane off
set -g mouse-select-window off

# turn on 256 color support in tmux
set -g default-terminal "screen-256color"

# fiddle with colors of status bar
set -g status-fg white
set -g status-bg colour234

# fiddle with colors of inactive windows
setw -g window-status-fg cyan
setw -g window-status-bg colour234
setw -g window-status-attr dim

# change color of active window
setw -g window-status-current-fg white
setw -g window-status-current-bg colour88
setw -g window-status-current-attr bright

# set color of regular and active panes
set -g pane-border-fg colour238
set -g pane-border-bg default
set -g pane-active-border-fg green
set -g pane-active-border-bg default

# set color of command line
set -g message-fg white
set -g message-bg colour22
set -g message-attr bright

# configure contents of status bar
set -g status-utf8 on
set -g status-left-length 40
set -g status-left "#[fg=green]\"#S\""

set -g status-right "#[fg=green] #h | %d %b %R"

set -g status-justify centre
setw -g monitor-activity on
set -g visual-activity on

# navigate using vim-style keys
setw -g mode-keys vi

# copy/paste using vim-style keys
bind Escape copy-mode
unbind p
bind p paste-buffer
bind -t vi-copy 'v' begin-selection
bind -t vi-copy 'y' copy-selection

# xclip support (commented as this often doesn't make sense on remote servers)
#bind C-c run "tmux save-buffer - / xclip -i -sel clipboard"
#bind C-v run "tmux set-buffer \"$(xclip -o -sel clipboard)\"; tmux paste-buffer"

# set up aliases for temporarily maximizing panes
unbind Up
bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp

unbind Down
bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp

# set up alias for turning on logging
bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"