# Compiler settings needed for python-build to work correctly
# Detects Homebrew prefix for portability across Intel and Apple Silicon
if command -v brew &>/dev/null; then
  _brew_prefix="$(brew --prefix)"
  if [ -d "$_brew_prefix/opt/zlib" ]; then
    export LDFLAGS="-L$_brew_prefix/opt/zlib/lib -L$_brew_prefix/opt/bzip2/lib"
    export CPPFLAGS="-I$_brew_prefix/opt/zlib/include -I$_brew_prefix/opt/bzip2/include"
    export PKG_CONFIG_PATH="$_brew_prefix/opt/zlib/lib/pkgconfig"
  fi
  unset _brew_prefix
fi
