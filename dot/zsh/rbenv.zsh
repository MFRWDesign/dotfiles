# Set RBENV_PATH based on Homebrew prefix (Intel vs Apple Silicon)
if [ -x /opt/homebrew/bin/rbenv ]; then
  export RBENV_PATH="/opt/homebrew/bin/rbenv"
elif [ -x /usr/local/bin/rbenv ]; then
  export RBENV_PATH="/usr/local/bin/rbenv"
fi
