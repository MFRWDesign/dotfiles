# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that integrates with [Strap](https://github.com/MikeMcQuaid/strap) to automate macOS development environment setup. The repository follows Strap's conventions and uses Prezto for ZSH configuration management.

## Key Commands

### Setup Commands
- **Initial setup**: `bash ~/strap/strap.sh` (runs full Strap bootstrap including this repo)
- **Run setup directly**: `./script/setup` (can be run standalone)
- **Post-setup tasks**: `./script/strap-after-setup` (version managers setup)

### Dotfiles Management Commands
- **Edit dotfiles**: `dotfiles edit` - Opens the dotfiles directory in the editor
- **Update dotfiles**: `dotfiles pull` - Pulls latest changes from git
- **Reload shell**: `dotfiles reload` - Sources the shell configuration
- **Setup dotfiles**: `dotfiles setup` - Runs the setup script

### Common Tasks
- **Update Homebrew packages**: Edit `dot/Brewfile` then run `brew bundle`
- **Apply macOS preferences**: Run scripts in `preferences/macos/` or `preferences/applications/`
- **Reload ZSH configuration**: `dotfiles reload` or `source ~/.zshrc`

## ZSH/Prezto Configuration

### Loading Order
1. **Custom ZSH scripts** (`~/.zsh/*`): Loaded first, before Prezto
2. **Prezto initialization**: Sources the Prezto framework
3. **PATH modifications**: Adds custom bin directories
4. **Tool initializations**: Fabric AI, Atuin, etc.

### Prezto Configuration (`dot/zpreztorc`)
- **Theme**: "giddie" prompt theme
- **Key bindings**: Emacs mode
- **Modules loaded**: environment, terminal, editor, history, directory, spectrum, utility, completion, prompt, ruby, python, node
- **Features**: Auto-titles for terminal windows/tabs, global color output

### Custom ZSH Modules Pattern (`dot/zsh/`)
Each file in this directory is automatically sourced. Current modules:
- `dotfiles.zsh`: Defines the dotfiles management command
- `editor.zsh`: Sets EDITOR to "cursor"
- `visual.zsh`: Sets VISUAL to "code"
- `homebrew.zsh`: Creates homebrew alias
- `clear.zsh`: Overrides clear with educational message
- `raise.zsh`: Sources raise environment tool
- `rbenv.zsh`: Configures Ruby environment

To add new aliases or functions, create a new `.zsh` file in `dot/zsh/`.

## Custom Commands and Aliases

### Git Commands and Workflow

#### Git Aliases (in `dot/gitconfig`)
- **Navigation**: `co` (checkout), `branch-name` (get current branch)
- **Publishing**: `pub` (push current branch with tracking: `git push -u origin $(git branch-name)`)
- **Quick commits**: `gc` (commit with message), `redo` (amend without editing message)
- **Status**: `gst` (status), `ga` (add), `gp` (push)
- **Security**: `password` (reset GitHub keychain credentials)
- **AI-Assisted Development** (all commands support preview and edit):
  - `snapshotc`: Create timestamped checkpoint commits (format: "snapshot: [description] JUL-03-25 05:06A")
  - `smrtsnap`: Analyze all changes and create multiple snapshot commits automatically
  - `claudeautoc`: Generate conventional commit message based on staged changes
  - `smrtautoc`: Analyze all changes and create multiple conventional commits automatically

#### Git Search
- **`pickaxe`**: Search git history for code changes (`git log -p -S`)

### Shell Command Enhancements

#### Command Replacements
- **`cat`** → **`bat`**: Syntax-highlighted file viewing with "ansi" theme
- **`clear`** → Educational message encouraging Ctrl+L usage

#### Project Navigation
- **`dotfiles`**: Multi-function command
  - `dotfiles` - cd to dotfiles directory
  - `dotfiles edit` - open in editor
  - `dotfiles pull` - update from git
  - `dotfiles reload` - reload shell config
  - `dotfiles setup` - run setup script
- **`raise`**: Similar pattern for raisedev project

### System Control Scripts

#### Audio Management (`audio-out`)
```bash
audio-out speakers    # Switch to desk speakers
audio-out headphones  # Switch to external headphones  
audio-out airpods     # Switch to AirPods
```

#### Bluetooth Control (`bluetooth`)
```bash
bluetooth connect airpods     # Connect AirPods and switch audio
bluetooth connect jdb-air     # Connect specific device
bluetooth disconnect <device> # Disconnect device
```

#### Display Configuration (`office`)
```bash
office display desk  # Configure 4-monitor office setup
```

#### Home Automation (`home-assistant`)
```bash
home-assistant toggle study-light      # Toggle study light
home-assistant toggle study-key-lights # Toggle key lights
```

### Shell Configuration

#### Enhanced History
- **atuin**: Advanced shell history with search and sync capabilities

#### Environment Setup
- **EDITOR**: cursor (default editor)
- **VISUAL**: code (visual editor)
- **Homebrew aliases**: Explicit path to avoid conflicts with workbrew

#### Workbrew Integration
- **`workbrewdo`**: Run commands as workbrew user with proper environment

### PATH Hierarchy
1. `$HOME/bin`: Custom user scripts
2. `/opt/workbrew/bin`: Work-specific Homebrew (if present)
3. `/opt/homebrew/bin`: Personal Homebrew
4. `$HOME/.local/bin`: Python tools installed via pipx

## Directory Structure Details

### `dot/` - Dotfiles to be symlinked
- **Shell**: `zshrc`, `zpreztorc`, `zsh/` (custom modules)
- **Development**: `gitconfig`, `gitignore`
- **Tools**: `Brewfile`, various config directories
- **Config directories**: `config/` contains subdirectories for specific tools (bat, karabiner)

### `files/` - Non-hidden files
Contains files that should be symlinked without a dot prefix.

### `preferences/` - System preferences
- **macos/**: System settings scripts (dock, finder, screensaver, etc.)
- **applications/**: App-specific preferences (currently has terminal subdirectory)

### `script/` - Automation scripts
- **setup**: Main setup script that creates symlinks and applies preferences
- **strap-after-setup**: Post-installation tasks for version managers

## Important Patterns and Conventions

### Adding New Configurations
1. **New dotfile**: Add to `dot/` directory, will be symlinked as `~/.filename`
2. **New alias/function**: Create a new file in `dot/zsh/` with `.zsh` extension
3. **New custom script**: Add to `files/bin/` for inclusion in PATH
4. **New Homebrew package**: Add to `dot/Brewfile`

### Symlink Management
The setup script uses a pattern of:
```bash
ln -sf "$DOTFILES_ROOT/dot/$file" "$HOME/.$file"
```
This creates forced symbolic links, overwriting existing files.

### Version Manager Integration
The repository supports:
- **rbenv**: Ruby version management
- **pyenv**: Python version management  
- **nodenv**: Node.js version management

Version files (`.ruby-version`, `.python-version`, `.node-version`) are symlinked from `files/` to home directory.

### Key Tools and Utilities
From the Brewfile, this environment includes:
- **Text processing**: ag, bat, colordiff, grep, jq
- **Development**: git, cmake, various language tools
- **System monitoring**: htop, iftop
- **Media**: ffmpeg, imagemagick
- **Security**: gnupg
- **Shell enhancement**: atuin (history sync), starship (prompt)

## Command Design Patterns

### Naming Conventions
- **Git aliases**: Short abbreviations for frequently used commands (ga, gp, gst)
- **Custom scripts**: Hyphenated names for clarity (audio-out, home-assistant)
- **Multi-function commands**: Single command with subcommands (dotfiles edit, dotfiles reload)

### Workflow Philosophy
1. **Efficiency First**: Replace common commands with enhanced versions (cat→bat)
2. **Context Switching**: Quick commands for changing environments (audio, display, projects)
3. **Smart Defaults**: Git aliases that combine common operations (pub for push with tracking)
4. **Educational**: Some overrides teach better practices (clear→Ctrl+L reminder)
5. **Project-Centric**: Navigation commands for important directories

### Adding New Commands
- **Simple alias**: Add to appropriate `.zsh` file in `dot/zsh/`
- **Complex script**: Create in `files/bin/` with descriptive hyphenated name
- **Git workflow**: Add alias to `dot/gitconfig`
- **Project navigation**: Follow dotfiles/raise pattern for consistency

### AI-Assisted Git Commands Features
All AI git commands include:
- **Preview**: Shows generated commit message before committing
- **Edit option**: Press 'e' to edit the message before committing
- **Error handling**: Validates Claude availability and git repository
- **Empty diff detection**: Warns if no actual changes exist
- **Auto-staging**: Prompts to stage all changes if nothing staged
- **Secure temp files**: Uses proper permissions for temporary files

## Notes on Missing Components
- iTerm2 configurations are not present in this repository
- No explicit test or validation commands exist
- Setup scripts are designed to be idempotent