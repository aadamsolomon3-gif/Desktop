#!/bin/bash

# Check if Fish shell is installed
if ! command -v fish &> /dev/null; then
    echo "Fish shell is not installed. Aborting."
    exit 1
fi

# Create Fish functions directory if it doesn't exist
mkdir -p ~/.config/fish/functions

# Write the cd function for Fish
cat << 'EOF' > ~/.config/fish/functions/cd.fish
function cd
    builtin cd $argv; and ls --color=auto -lh
end
EOF

# Save the function permanently
fish -c "funcsave cd"

echo "Fish cd override installed! 'cd' will now automatically list directory contents."
