# @CNG/dotfiles

This project controls my desktop and laptop configurations, including software installation.
It takes [@holman/dotfiles](https://github.com/holman/dotfiles)’s topic based approach to grouping configurations a step further by allowing for installation and uninstallation per grouping, which I call modules.

Do not run this program without modification.
I am working to generalize this so it becomes portable to others, but for now, please use it as a starting point or for ideas.

Notably, you should review any `Brewfile` files and comment out any lines for software you do not want installed upon installing the module.
Also, you can create these two Zsh configuration files to contain any personal settings, aliases, functions, etc.:

* [`zshenv.local.symlink`](mods-available/zsh/zshenv.local.symlink)
* [`zshrc.local.symlink`](mods-available/zsh/zshrc.local.symlink)

## Installation

You can install this program anywhere, but many similar projects use `~/.dotfiles`.
If you install it somewhere else, define `DOTFILES=/path/to/dotfiles` in `mods-available/zsh/zshenv.local.symlink`.

    git clone https://github.com/CNG/dotfiles.git ~/.dotfiles
    ~/.dotfiles/dotfiles install

If you later move the directory, you should run `./dotfiles reinstall --all` to update any symbolic links set up by installed modules.

## Configuration

Installable modules are simply folders in [`mods-available`](mods-available) that contain any number of files outlined below.
Each module's files can be customized, and new modules can be created simply by creating a directory.
Modules are not actually installed until the `dotfiles install module_name` command is run.

### Module structure

* **`Brewfile`**
    Each module can contain one file called `Brewfile` that lists dependencies for [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) to install and keep updated.
* **`install*.[ba]sh`**
    Files starting with `install` and ending with `.bash` or `.sh` are run by the `dotfiles install` command.
    These should contain actions to be performed only once, upon initial module installation, but they may be run again by subsequent `dotfiles install` commands or `dotfiles reinstall` commands.
* **`upgrade*.[ba]sh`**
    Files starting with `upgrade` and ending with `.bash` or `.sh` are run by the `dotfiles install` command and the `dotfiles upgrade` command.
    These should contain actions to be performed periodically to keep any components outside the package manifest up to date.
    Since the `dotfiles install` command also runs the update scripts, actions do not need to be duplicated in both scripts for the sake of having them run on initial install.
* **`remove*.[ba]sh`**
    Files starting with `remove` and ending with `.bash` or `.sh` are run by the `dotfiles remove` command.
    These should undo the corresponding install scripts so the system is left as if the module had never been installed.
* **`env*.zsh`**
    Files starting with `env ` and ending with `.zsh` are loaded into the environment first and are expected to set up environment variables like `$PATH` or custom ones and set up anything needed in cron jobs.
* **`plugins*.zsh`**
    Files starting with `plugins` and ending with `.zsh` are loaded into the interactive shell (which loads after the environment) first and are expected to specify [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh) plugins.
    Format: `plugins=(${plugins:-} brew)`
* **`completion*.zsh`**
    Files starting with `completion` and ending with `.zsh` are loaded into the interactive shell (which loads after the environment) last and are expected to setup autocomplete.
* **`*.zsh`**
    Any other files ending in `.zsh` are loaded into the interactive shell after plugins and before completions. These might include shell configuration and aliases.
* **`*.symlink`**
    Files ending in `.symlink` get referenced from symbolic links created in your `$HOME` directory such that `~/.filename` is a symbolic link pointing to `filename.symlink`.
    This allows your system configuration files to automatically reflect updates to this dotfiles project.
    Links are created by the `dotfiles install` command.
    If new `.symlink` files are created after a module is already installed, run the `dotfiles install` command again.
* **`functions/*`**
    Any [appropriately formatted](http://zsh.sourceforge.net/Doc/Release/Functions.html) files in a folder called `functions` are loaded into `$fpath` and become functions accessible anywhere, similar to aliases.
    The folder also can contain `#compdef` [completion files](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Autoloaded-files) that usually start with `_`.

## Usage

* **`dotfiles install`**
    Install the required module, **base**.

    **`dotfiles install A`**
    Install a module.

    **`dotfiles install A B C ...`**
    Install multiple modules.

    **`dotfiles install --all`**
    Install all available modules.

* **`dotfiles reinstall `**
    Reinstall all installed modules.

    **`dotfiles reinstall A`**
    Reinstall a module.

    **`dotfiles reinstall A B C ...`**
    Reinstall multiple modules.

* **`dotfiles upgrade`**
    Upgrade all installed modules.

    **`dotfiles upgrade A`**
    Upgrade a module.

    **`dotfiles upgrade A B C ...`**
    Upgrade multiple modules.

* **`dotfiles remove A`**
    Remove a module.

    **`dotfiles remove A B C ...`**
    Remove multiple modules.

    **`dotfiles remove --all`**
    Remove all available modules.

* **`dotfiles cleanup`**

    Uninstall any installed `brew` packages that are not required by currently installed modules.
    This does not run any module scripts or modify symbolic links but only analyzes the required package manifests in each installed module and removes any extras that were installed manually or by a module that has since changed.

* **`dotfiles list`**
    List modules installed and available but not installed.

    **`dotfiles list --installed`**
    List modules installed.

    **`dotfiles list --available`**
    List all modules.

    **`dotfiles list --not-installed`**
    List modules available but not installed.

* **`dotfiles tests`**
    Run nonexhaustive internal tests.

* **`dotfiles help`**
    Display the help page.

## Notes

I am struggling with or have not much thought about a sensible splitting between the modules `zsh`, `base`, `macos` and `developer`.

Nowhere for functions not written in sh/bash/zsh? Or can ruby etc. work in fpath?