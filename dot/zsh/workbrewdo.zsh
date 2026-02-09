# Workbrew sudo helper (work machine only)
if [ -d /opt/workbrew ]; then
  alias workbrewdo='sudo --set-home --preserve-env --user=workbrew --'
fi
