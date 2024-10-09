#!/bin/bash

VERSION="v0.6.9"

# display help message
show_help() {
  cat <<EOF
Usage: sysopctl [COMMAND] [OPTIONS]

A system administration tool for managing services, processes, and system health.

Commands:
  service list                  List all active services.
  service start <service-name>  Start a specified service.
  service stop <service-name>   Stop a specified service.
  system load                   Display system load averages.
  disk usage                    Show disk usage statistics.
  process monitor               Monitor real-time process activity.
  logs analyze                  Summarize recent critical log entries.
  backup <path>                 Initiate backup of the specified path.

Options:
  --help                        Display this help message.
  --version                     Show version information.

EOF
}

# display version information
show_version() {
  echo "sysopctl $VERSION"
}

# main script
case "$1" in
--help)
  show_help
  ;;
--version)
  show_version
  ;;
service)
  case "$2" in
  list)
    echo "Listing active services..."
    systemctl list-units --type=service --state=running
    ;;
  start)
    if [ -z "$3" ]; then
      echo "Please specify a service to start."
    else
      echo "Starting service $3..."
      sudo systemctl start "$3"
    fi
    ;;
  stop)
    if [ -z "$3" ]; then
      echo "Please specify a service to stop."
    else
      echo "Stopping service $3..."
      sudo systemctl stop "$3"
    fi
    ;;
  *)
    echo "Invalid service command."
    show_help
    ;;
  esac
  ;;
disk)
  if [ "$2" = "usage" ]; then
    echo "Showing disk usage statistics..."
    df -h
  else
    echo "Invalid disk command."
    show_help
  fi
  ;;
process)
  if [ "$2" = "monitor" ]; then
    echo "Monitoring real-time process activity..."
    top
  else
    echo "Invalid process command."
    show_help
  fi
  ;;
logs)
  if [ "$2" = "analyze" ]; then
    echo "Analyzing recent critical log entries..."
    sudo journalctl -p crit -n 50
  else
    echo "Invalid logs command."
    show_help
  fi
  ;;
backup)
  if [ -z "$2" ]; then
    echo "Please specify a path to backup."
  else
    echo "Backing up $2..."
    tar -czvf backup_$(date +%F).tar.gz "$2"
  fi
  ;;
*)
  echo "Invalid command."
  show_help
  ;;
esac
