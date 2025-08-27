# Kitty Dotfiles Installer

This repository provides a Bash script (`installer_kitty_dots.sh`) to automate the installation of the Kitty terminal emulator, the FantasqueSansM Nerd Font, and custom Kitty configurations. It supports Debian/Ubuntu (`apt`) and Arch-based (`pacman`) systems. All default Kitty shortcuts are blocked and manually remapped to suit my preferences, as detailed in `kitty_custom.conf`.

- This is part of my [dotfiles](https://github.com/corechunk/dotfiles) repository. You can use the [dotfiles](https://github.com/corechunk/dotfiles) repo to automatically download this repo along with other dotfiles repositories like Neovim, Tmux, and Bash.

<p align="center">
  <img src="https://raw.githubusercontent.com/kovidgoyal/kitty/master/logo/kitty.png" alt="Kitty Dotfiles Badge" width="200"/>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Kitty-Dotfiles-181717?style=flat-square&logo=kitty" alt="Kitty Dotfiles Badge" width="200"/>
</p>

---

## ✨ Features

- **Automated Installation**: Installs Kitty and the FantasqueSansM Nerd Font for a modern terminal experience.
- **Custom Configurations**: Sets up `~/.config/kitty/kitty.conf`, `kitty_custom.conf`, and `kitty-colors_custom.conf` for personalized settings.
- **Theme Support**: Installs `kitty-themes` for customizable terminal themes.
- **Safe File Handling**: Prompts to avoid overwriting existing configuration files.
- **Cross-Distro Compatibility**: Supports Debian/Ubuntu (`apt`) and Arch-based (`pacman`) systems.

## 📋 Prerequisites

- A Debian/Ubuntu or Arch-based Linux system.
- `git` for cloning themes (optional).
- `curl` and `unzip` for font installation.
- `sudo` permissions for package installation.
- A terminal for interactive execution or a non-interactive environment for `curl | bash`.

### Install Prerequisites
```bash
sudo apt install curl git unzip -y
```

---

## 🛠️ Installation

### Manual Installation
Clone the repository, run the script, and clean up:
```bash
git clone https://github.com/corechunk/Kitty.git temp101
cd temp101
chmod +x installer_kitty_dots.sh
./installer_kitty_dots.sh
cd ..
rm -rf temp101
```

### One-Liner Installation
```bash
git clone https://github.com/corechunk/Kitty.git temp101 && cd temp101 && chmod +x installer_kitty_dots.sh && ./installer_kitty_dots.sh && cd .. && rm -rf temp101
```

The script will:
1. Detect the package manager (`apt` or `pacman`).
2. Install Kitty if not already present.
3. Install the FantasqueSansM Nerd Font if not present.
4. Create or update `~/.config/kitty/kitty.conf`, `kitty_custom.conf`, and `kitty-colors_custom.conf`.
5. Install `kitty-themes` for theme support.
6. Include custom configurations in `kitty.conf`.

---

## ⚙️ Kitty Configuration

The `~/.config/kitty/kitty.conf`, `kitty_custom.conf`, and `kitty-colors_custom.conf` files provide a customized Kitty setup with:
- **Blocked Default Shortcuts**: All default Kitty keybindings are disabled for a clean slate.
- **Custom Keybindings**: Remapped shortcuts tailored to my workflow (see `kitty_custom.conf` for details).
- **Font**: Uses FantasqueSansM Nerd Font for enhanced terminal visuals.
- **Themes**: Supports `kitty-themes` for customizable color schemes.
- **Customizable**: Add settings to `kitty_custom.conf` or `kitty-colors_custom.conf` to extend or override defaults.

To include custom settings in `~/.config/kitty/kitty.conf`:
```bash
include ./kitty_<customName>.conf
include ./kitty-colors_<customName>.conf
```

---

## ⌨️ Keybindings

All default Kitty keybindings are disabled, and custom shortcuts are defined in `kitty_custom.conf`. Refer to `kitty_custom.conf` in the repository for the full list of remapped keybindings, which are tailored to my workflow.

| **Category**         | **Keybinding**            | **Action**                              |
|----------------------|---------------------------|-----------------------------------------|
| **General**          | -                        | See `kitty_custom.conf` for details     |
| -                    | -                        | -                                       |
| **Window Management**| -                        | See `kitty_custom.conf` for details     |
| -                    | -                        | -                                       |
| **Tab Management**   | -                        | See `kitty_custom.conf` for details     |

---

## 🎨 Themes

The `kitty-themes` directory provides a collection of themes installed to `~/.config/kitty/kitty-themes`. To apply a theme, add to `kitty.conf` or `kitty_custom.conf`:
```bash
include ./kitty-themes/<theme_name>.conf
```

---

## 📝 Customization

- **Extend Configurations**: Add custom settings to `~/.config/kitty/kitty_custom.conf` or `kitty-colors_custom.conf` to override or extend defaults without modifying `kitty.conf`.
- **Theme Management**: Add or remove themes in `~/.config/kitty/kitty-themes` and update `kitty.conf` to include them.

---

## 📜 License

This project is licensed under the [Apache 2.0 License](LICENSE).

---

[![Back to Dotfiles](https://img.shields.io/badge/Back_to_Dotfiles-181717?style=flat-square&logo=github)](https://github.com/corechunk/dotfiles)
[![Connect on X](https://img.shields.io/badge/Connect_on_X-1DA1F2?style=flat-square&logo=x)](https://x.com/Mahmudul__Miraj)