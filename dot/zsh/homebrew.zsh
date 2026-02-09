# Alias 'homebrew' to the system brew (useful on work machines with workbrew)
if [ -x /opt/homebrew/bin/brew ]; then
  alias homebrew='/opt/homebrew/bin/brew'
elif [ -x /usr/local/bin/brew ]; then
  alias homebrew='/usr/local/bin/brew'
fi
