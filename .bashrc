# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# # ----------------------------------------------- Planet_Exp_MP helps ----------------------------
# #sudo date -s "Fri Jan 21 05:03:00 UTC 2021"
# source /opt/ros/noetic/setup.bash
# source ~/catkin_ws/devel/setup.bash
# #source ~/planetexp_ws/devel/setup.bash
 
# disros() {
#   # Setup for distributed ROS
#   export ROS_IP="$(hostname -I | cut -d' ' -f1)"
#   echo "Identifying as: $ROS_IP"
 
#   if [ "$#" -eq 1 ]
#   then
#     export ROS_MASTER_URI="http://$1:11311"
#     echo "Connecting to: $ROS_MASTER_URI"
#   fi
# }
 
# # Start by default with as master
# disros

# #planetExp help functions:
# alias gazeboDVP="export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:~/catkin_ws/src/uas_gazebo_sim/models/; export PX4_SITL_WORLD=~/catkin_ws/src/uas_gazebo_sim/worlds/dvp/dvp.world"
# # export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:~/catkin_ws/src/uas_gazebo_sim/models/
# # export PX4_SITL_WORLD=~/catkin_ws/src/uas_gazebo_sim/worlds/dvp/dvp.world
# alias cd-planet="cd ~/catkin_ws/src/planetExp_mission_planner/src/problems/planetexp/"
 
# # Activate console
# function l-planet (){
#     echo "Starting Tmux session for Planet Exp"
#     sleep 2
#     tmux new-session -s pexp\; send-keys "roscore" \; split-window -h -p 85\; select-pane -t 0\; split-window -v\;                   \
#         send-keys "~/Desktop/./QGroundControl.AppImage" \; select-pane -t 2\; split-window -h\; select-pane -t 2\;                   \
#         send-keys "cd ~/PX4-Autopilot/" \; send-keys "make px4_sitl gazebo_typhoon_h480" \; split-window -v -p 75\;               \
#         send-keys "sleep 10; roslaunch ~/catkin_ws/launch/control.launch" \; split-window -v -p 60\;                                 \
#         send-keys "sleep 5; roslaunch qutas_lab_450 environment.launch" \; split-window -v \;                                        \
#         send-keys "sleep 5; roslaunch ~/catkin_ws/launch/breadcrumb.launch" \;  select-pane -t 6\;                                   \
#         send-keys "rosrun planetexp_nav exp_nav" \;  split-window -v -p 85\;                      \
#         send-keys "sleep 10; rostopic echo /planetexp_nav/state" C-m\; split-window -v -p 80\; select-pane -t 7\; split-window -h\; \
#         send-keys "sleep 10; rostopic echo /planetExp/command" C-m\; select-pane -t 9\;                                                 \
#         send-keys "roslaunch planetexp_mp planetexp.launch runSimulation:=false" \; split-window -v -p 10\;                             \
#         send-keys "tmux kill-session" \;
 
# }
# export -f l-planet

#################### Here EGB349 bash.rc tools nice to have in every new terminal

source /opt/ros/noetic/setup.bash
catkin_ws="catkin_ws"

source ~/${catkin_ws}/devel/setup.bash
 
disros() {
  # Setup for distributed ROS
  export ROS_IP="$(hostname -I | cut -d' ' -f1)"
  echo "Identifying as: $ROS_IP"
 
  if [ "$#" -eq 1 ]
  then
    export ROS_MASTER_URI="http://$1:11311"
    echo "Connecting to: $ROS_MASTER_URI"
  fi
}
 
# Start by default with as master
disros

# Activate multiple terminals
function run349(){
    echo "Starting Tmux session for EGB349 UAV control"
    sleep 2
    tmux new-session -s cdrone\; set -g mouse on\; send-keys "roscore" C-m\; split-window -h -p 85\; select-pane -t 0\; split-window -v\;                   \
        send-keys "htop" C-m\; select-pane -t 2\; split-window -h\; select-pane -t 2\;                   \
        send-keys "roslaunch spar_node spar_uavasr.launch" \; split-window -v -p 75\;               \
        send-keys "roslaunch ~/${catkin_ws}/launch/control.launch" \; split-window -v -p 60\;                                 \
        send-keys "roslaunch qutas_lab_450 environment.launch" \; split-window -v \;                                        \
        send-keys "rosrun depthai_publisher dai_publisher_yolov5_runner" \;  select-pane -t 6\;                                   \
        send-keys "rosbag record -a -b 2048" \;  split-window -v -p 85\;                      \
        send-keys "rostopic echo /mavros/local_position/pose" C-m\; split-window -v -p 80\; select-pane -t 7\; split-window -h\; \
        send-keys "rostopic echo /mavros/vision_pose/pose" C-m\; select-pane -t 9\;                                                 \
        send-keys "" \; split-window -v -p 5\;                             \
        send-keys "tmux kill-session" \;
}
export -f run349

function run_sim(){
    echo "Starting Tmux session for Simulated UAV control"
    sleep 2
    tmux new-session -s cdrone\; set -g mouse on\; send-keys "roscore" C-m\; split-window -h -p 85\; select-pane -t 0\; split-window -v\;                   \
        send-keys "htop" C-m\; select-pane -t 2\; split-window -h\; select-pane -t 2\;                   \
        send-keys "roslaunch spar_node spar_uavasr.launch" \; split-window -v -p 75\;               \
        send-keys "roslaunch ~/${catkin_ws}/launch/breadcrumb.launch" \; split-window -v -p 75\;               \
        send-keys "roslaunch uavasr_emulator emulator.launch" \; split-window -v -p 60\;                                 \
        send-keys "roslaunch qutas_lab_450 environment.launch" \; split-window -v \;                                        \
        send-keys "" \; split-window -v -p 5\;                             \
        send-keys "tmux kill-session" \;
}
export -f run_sim

cd ~/catkin_ws/
export PATH=/opt/ros/noetic/bin:/home/cdrone/.vscode-server/cli/servers/Stable-17baf841131aa23349f217ca7c570c76ee87b957/server/bin/remote-cli:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/cdrone/.vscode-server/extensions/ms-python.debugpy-2025.6.0-linux-arm64/bundled/scripts/noConfigScripts:/home/cdrone/.vscode-server/data/User/globalStorage/github.copilot-chat/debugCommand:/home/cdrone/code_dev/:/home/cdrone/code_dev/
export PATH=/opt/ros/noetic/bin:/home/cdrone/.vscode-server/cli/servers/Stable-17baf841131aa23349f217ca7c570c76ee87b957/server/bin/remote-cli:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/cdrone/.vscode-server/extensions/ms-python.debugpy-2025.6.0-linux-arm64/bundled/scripts/noConfigScripts:/home/cdrone/.vscode-server/data/User/globalStorage/github.copilot-chat/debugCommand:/home/cdrone/code_dev/:/home/cdrone/code_dev/:/home/cdrone/code_dev/
export PATH=/opt/ros/noetic/bin:/home/cdrone/.vscode-server/cli/servers/Stable-17baf841131aa23349f217ca7c570c76ee87b957/server/bin/remote-cli:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/cdrone/.vscode-server/extensions/ms-python.debugpy-2025.6.0-linux-arm64/bundled/scripts/noConfigScripts:/home/cdrone/.vscode-server/data/User/globalStorage/github.copilot-chat/debugCommand:/home/cdrone/code_dev/:/home/cdrone/code_dev/:/sys/class/gpio
