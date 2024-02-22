#!/bin/sh
# Disables and re-enables bismuth tiling due to bug that causes some windows to not tile until it is restarted
#
# Restart command copied from https://github.com/ragusa87/kde-tiling-on-drag/blob/main/Makefile
# Referenced from https://discuss.kde.org/t/how-to-properly-reload-a-kwin-script/4260
#
# Runs once per minute via crontab, YMMV. Copy/adapt paths as appropriate.
# * * * * * sh $HOME/code/personal-knowledge-repository/scripts/restart_bismuth_tiling.sh >> /dev/null 2>&1

# Cron doesn't have access to DISPLAY/DBUS Session data
# Help sourced from https://unix.stackexchange.com/questions/111188/using-notify-send-with-cron
userid=$(id -u)
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$userid/bus"
export DBUS_SESSION_BUS_ADDRESS

# Disable bismuth
sed -i s/bismuthEnabled=true/bismuthEnabled=false/ ~/.config/kwinrc
# Reload config
dbus-send --session --print-reply=literal --dest="org.kde.KWin" "/Scripting" "org.kde.kwin.Scripting.start"

# Ensable bismuth
sed -i s/bismuthEnabled=false/bismuthEnabled=true/ ~/.config/kwinrc
# Reload config
dbus-send --session --print-reply=literal --dest="org.kde.KWin" "/Scripting" "org.kde.kwin.Scripting.start"
