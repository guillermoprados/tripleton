source ~/.zshrc

#!/bin/bash

# Get the directory where the script is located
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$script_dir"

adb install ../android/tripleton.apk

echo "start log"

adb logcat | grep godot