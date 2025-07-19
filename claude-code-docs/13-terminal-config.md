# Optimize Your Terminal Setup

## Themes and Appearance
Claude cannot control the terminal theme directly. Users can match Claude Code's theme using the `/config` command.

## Line Breaks
Two primary methods for entering line breaks:

1. **Quick escape**: Type `\` followed by Enter
2. **Keyboard shortcut**: Configure a custom keybinding

### Shift+Enter Setup (VS Code/iTerm2)
- Run `/terminal-setup` to automatically configure

### Option+Enter Setup (Mac Terminals)

#### For macOS Terminal.app:
1. Open Settings → Profiles → Keyboard
2. Check "Use Option as Meta Key"

#### For iTerm2 and VS Code terminal:
1. Open Settings → Profiles → Keys
2. Set Left/Right Option key to "Esc+"

## Notification Setup

### Terminal Bell Notifications
Configure global notification channel:
```sh
claude config set --global preferredNotifChannel terminal_bell
```

**Note for macOS**: Enable notification permissions in System Settings

### iTerm 2 System Notifications
1. Open iTerm 2 Preferences
2. Navigate to Profiles → Terminal
3. Enable "Silence bell" and "Send escape sequence-generated alerts"
4. Set preferred notification delay

### Custom Notification Hooks
Create [custom notification hooks](/en/docs/claude-code/hooks#notification) for advanced handling

## Handling Large Inputs
- Avoid direct pasting of very long content
- Use file-based workflows
- Be aware of VS Code terminal limitations for long pastes

## Vim Mode
Claude Code supports a subset of Vim keybindings:

### Mode Switching
- `Esc`: NORMAL mode
- `i`/`I`, `a`/`A`, `o`/`O`: INSERT mode

### Navigation
- Movement: `h`/`j`/`k`/`l`
- Word navigation: `w`/`e`/`b`
- Line navigation: `0`/`$`/`^`, `gg`/`G`

### Editing
- Delete: `x`, `dw`/`de`/`db`/`dd`/`D`
- Change: `cw`/`ce`/`cb`/`cc`/`C`