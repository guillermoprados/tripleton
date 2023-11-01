source ~/.zshrc

#!/bin/bash

# Get the directory where the script is located
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$script_dir"

#export token images
aseprite -b ../asesprite/tokens.aseprite --save-as ../images/tokens/{slice}.png

aseprite -b ../asesprite/monsters.aseprite --save-as ../images/monsters/{slice}.png