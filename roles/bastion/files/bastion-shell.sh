# Check that the SSH client did not supply a command
if [[ -z $SSH_ORIGINAL_COMMAND ]]; then
# The format of log files is /var/log/bastion/YYYY-MM-DD_HH-MM-SS_user
  LOG_FILE="`date --date="today" "+%Y-%m-%d_%H-%M-%S"`_`whoami`"
  LOG_DIR="/var/log/bastion/`whoami`/"
# Print a welcome message
  echo ""
  echo "NOTE: This SSH session will be recorded"
  echo "AUDIT KEY: $LOG_FILE"
  echo ""
# I suffix the log file name with a random string. I explain why
# later on.
  SUFFIX=`mktemp -u _record`
# Wrap an interactive shell into "script" to record the SSH session
  script -qf --timing=$LOG_DIR$LOG_FILE$SUFFIX.time $LOG_DIR$LOG_FILE$SUFFIX.data --command=/bin/bash
else
# The "script" program could be circumvented with some commands
# (e.g. bash, nc). Therefore, I intentionally prevent users
# from supplying commands.
echo "This bastion supports interactive sessions only. Do not supply a command"
  exit 1
fi