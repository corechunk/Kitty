#!/bin/bash

# Determine the source directory based on execution context
if [ -d "kitty" ]; then
    # Called from root of repo
    SCRIPT_DIR="kitty"
else
    # Called from within kitty folder
    SCRIPT_DIR="."
fi

# User configuration directory
CONFIG_DIR="$HOME/.config/kitty"

# Function to prompt user for y/n input
prompt_user() {
    local message=$1
    local response

    for(( i=0;i<2;i++ ));do
        read -p "$message [y/n]: " response
        if [[ "$response" == "y" || "$response" == "Y" ]];then
            return 0
        elif [[ "$response" == "n" || "$response" == "N" ]];then
            return 1
        fi
    done
    return 1
}


# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
    #echo $?
    return $?
}
#echo $(command_exists pacman)
#echo $(command_exists apt)

# Function to detect package manager
package_manager() {
    if command_exists apt; then
        echo "apt"
    elif command_exists pacman; then
        echo "pacman"
    else
        echo "none"
    fi
}

# Function to install FantasqueSansM Nerd Font
install_fonts() {
    local font_name="FantasqueSansM Nerd Font Mono"
    local font_dir="$HOME/.local/share/fonts"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FantasqueSansMono.zip"
    local temp_dir="temp_fonts_$(date +%s)"
    
    echo "Checking for $font_name..."
    if fc-list | grep -qi "FantasqueSansM Nerd Font Mono"; then
        echo "$font_name is already installed."
        return 0
    fi
    
    if prompt_user "Would you like to install $font_name?"; then
        echo "Downloading $font_name..."
        mkdir -p "$temp_dir"
        
        # Download the font zip
        if curl -L "$font_url" -o "$temp_dir/FantasqueSansMono.zip"; then
            # Create font directory
            mkdir -p "$font_dir"
            
            # Extract and install fonts
            unzip -q "$temp_dir/FantasqueSansMono.zip" -d "$temp_dir/fonts"
            mv "$temp_dir/fonts"/*.ttf "$font_dir/" 2>/dev/null || {
                echo "Error: No TTF files found in the downloaded zip."
                return 1
            }
            
            # Refresh font cache
            fc-cache -fv > /dev/null
            echo "$font_name installed successfully."
            
        else
            echo "Error: Failed to download $font_name."
            return 1
        fi
        rm -rf "$temp_dir"
    else
        echo "Skipping $font_name installation."
        return 0
    fi
}

# Function to install Kitty
install_kitty() {
    echo "Checking if Kitty is installed..."
    
    if command_exists kitty; then
        echo "Kitty is already installed."
        return 0
    fi
    
    if prompt_user "Kitty is not installed. Would you like to install it?"; then
        if [ "$(package_manager)" = "apt" ]; then
            echo "Installing Kitty using apt..."
            sudo apt update
            sudo apt install -y kitty
        elif [ "$(package_manager)" = "pacman" ]; then
            echo "Installing Kitty using pacman..."
            sudo pacman -Syu --noconfirm kitty
        else
            echo "Error: No supported package manager (apt or pacman) found."
            return 1
        fi
        
        if command_exists kitty; then
            echo "Kitty installed successfully."
            return 0
        else
            echo "Error: Kitty installation failed."
            return 1
        fi
    else
        echo "Skipping Kitty installation."
        return 1
    fi
}

#config checker                    (( 1 ))
config_checker(){
    echo "Checking for kitty.conf in $CONFIG_DIR..."
    if [ ! -d "$CONFIG_DIR" ]; then
        if prompt_user "Kitty configuration directory ($CONFIG_DIR) does not exist. Create it?"; then
            mkdir -p "$CONFIG_DIR" && echo "Created $CONFIG_DIR."
            return 0
        else
            echo "Cannot proceed without creating $CONFIG_DIR."
            return 1
        fi
    fi
    return 0
}
str_finder(){              #           (( 1.2 ))
    if grep -q "$2" "$1";then
        return 0
    else
        return 1
    fi
}
recopy(){
    if [[ -f "$2" ]];then
        cp "$1" "$2"
        if [ $? -eq 0 ];then echo "successfully re-copied"; fi
        return 0
    fi
    echo "file doesn't exist"
    return 1
}

# Function to ensure kitty.conf exists   (( 2 ))
ensure_kitty_conf() {
    if ! config_checker;then
        return 1
    fi

    
    if [ ! -f "$CONFIG_DIR/kitty.conf" ]; then
        if prompt_user "kitty.conf not found in $CONFIG_DIR. Create an empty kitty.conf?"; then
            touch "$CONFIG_DIR/kitty.conf"
            echo "Created empty kitty.conf."
        else
            echo "Cannot proceed without kitty.conf."
            return 1
        fi
    fi
    return 0
}

# SCRIPT_DIR
# script_themes_dir
# themes_dir

# Function to install kitty-themes     (( 3 ))
install_kitty_themes() {
    local themes_dir="$CONFIG_DIR/kitty-themes"
    local script_themes_dir="$SCRIPT_DIR/kitty-themes"
    
    if ! config_checker;then
        return 1
    fi

    if [ ! -d "$script_themes_dir" ]; then
        echo "Error: kitty-themes directory not found in $SCRIPT_DIR to install"
        return 1
    fi
    
    echo "Checking for kitty-themes in $CONFIG_DIR..."
    if prompt_user "Install or update kitty-themes in $CONFIG_DIR?"; then
        mkdir -p "$themes_dir"
        
        # Copy only new themes, skip existing ones
        for theme in "$script_themes_dir"/*.conf; do
            theme_name=$(basename "$theme")
            if [ -f "$themes_dir/$theme_name" ]; then
                echo "Theme $theme_name already exists, skipping."
            else
                cp "$theme" "$themes_dir/"
                echo "Installed theme $theme_name."
            fi
        done
        echo "Kitty themes installation complete."
        return 0
    else
        echo "Skipping kitty-themes installation."
        return 1
    fi
}

# Function to install kitty-colors.conf
install_kitty_colors_custom() {
    local script_colors="$SCRIPT_DIR/kitty-colors_custom.conf"
    local target_colors="$CONFIG_DIR/kitty-colors.conf"
    local custom_colors="$CONFIG_DIR/kitty-colors-custom.conf"

    if prompt_user "Install kitty-colors_custom.conf in $CONFIG_DIR?"; then

        if ! config_checker;then
            return 1
        fi

        if [ ! -f "$script_colors" ]; then
            echo "Error: kitty-colors_custom.conf not found in $SCRIPT_DIR."
            return 1
        fi
        
        echo "Checking for kitty-colors.conf in $CONFIG_DIR..."
        if [ ! -f "$target_colors" ]; then
            if prompt_user "Create kitty-colors.conf? (Required)";then
                touch "$target_colors"
            else
                echo "cant continue without kitty-colors.conf"
                return 1
            fi
        fi

        if [ -f "$custom_colors" ]; then   ##  !!
            echo "kitty-colors_custom.conf already installed in $CONFIG_DIR."
            if prompt_user "wanna re-install?";then
                if recopy "$script_colors" "$custom_colors";then
                    echo re-installed
                else
                    return 1
                fi
            else
                echo "skipping without re-installing"
            fi
        else
            cp "$script_colors" "$custom_colors"
            echo "kitty-colors_custom.conf pasted ... "
        fi
        

        if str_finder "$target_colors" "include ./kitty-colors_custom.conf"; then
            echo "custom colors script already included in $target_colors."
        else
            echo "include ./kitty-colors_custom.conf" >> "$target_colors"
            echo "kitty-colors_custom.conf file is included ... "
        fi
            
        return 0
    else
        echo "Skipping kitty-colors_custom.conf installation."
        return 1
    fi
}

# Function to install kitty_custom.conf and update kitty.conf
install_kitty_custom() {
    local script_custom="$SCRIPT_DIR/kitty_custom.conf"
    local target_custom="$CONFIG_DIR/kitty_custom.conf"
    
    if prompt_user "Install kitty_custom.conf and include it in kitty.conf?"; then

        if ! config_checker;then
            return 1
        fi

        if [ ! -f "$script_custom" ]; then
            echo "Error: kitty_custom.conf not found in $SCRIPT_DIR."
            return 1
        fi

        if [ -f "$target_custom" ]; then   ##  !!
            echo "custom conf script already installed in $CONFIG_DIR."
            if prompt_user "wanna re-install?";then
                if recopy "$script_custom" "$target_custom";then
                    echo re-installed
                else
                    return 1
                fi
            else
                echo "skipping without re-installing"
            fi
        else
            cp "$script_custom" "$target_custom"
            echo "Installed kitty_custom.conf."
        fi
        

        # Check if kitty_custom.conf is already included
        if ! grep -q "include ./kitty_custom.conf" "$CONFIG_DIR/kitty.conf"; then
            echo "Adding include directive for kitty_custom.conf to kitty.conf..."
            echo "include ./kitty_custom.conf" >> "$CONFIG_DIR/kitty.conf"
            echo "Included kitty_custom.conf in kitty.conf."
        else
            echo "kitty_custom.conf is already included in kitty.conf."
        fi
        return 0
    else
        echo "Skipping kitty_custom.conf installation."
        return 1
    fi
}



# ==========  ========== Main execution ==========  ========== 
# ==========  ========== Main execution ==========  ========== 

echo "Starting Kitty dotfiles installation..."

# Step 1: Install fonts
if ! install_fonts;then
    echo "Font installation failed or was skipped. Continuing with other steps."
fi

# Step 2: Check and install Kitty
if ! install_kitty; then
    echo "Kitty installation failed or was skipped. Exiting."
    exit 1
fi

# Step 3: Ensure kitty.conf exists
if ! ensure_kitty_conf; then
    echo "Failed to ensure kitty.conf exists. Exiting."
    exit 1
fi

# Step 4: Install kitty-themes
install_kitty_themes

# Step 5: Install kitty-colors.conf
install_kitty_colors_custom

# Step 6: Install kitty_custom.conf and update kitty.conf
install_kitty_custom

echo "Kitty dotfiles installation complete."
exit 0
