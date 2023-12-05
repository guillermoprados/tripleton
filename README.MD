
# Project Scripts

This repository contains several useful scripts for project automation. Follow the instructions below to set up and use these scripts.

## Scripts


### Alias
in order to easily use the scripts, you can modify `~/.zshrc` to set the alias:

``` bash
alias export_sprites="/path/to/project/bash/export_sprites.sh"
alias run_android="/path/to/project/bash/run_android.sh"
alias files_to_json="/path/to/project/bash/files_to_json.sh"
alias export_tokens_data="/path/to/project/bash/export_tokens_data.sh"
```
you also need to navigate inside the project folder and run for each script:

```bash
chmod +x bash/the_script_name.sh
```

### Export Sprites Script:
Export the sprites defined in slices from the aseprite folder

### Run Android
Just tries to install the apk into the android phone (the apk needs to be previusly generated in godot)

### Export Tokens Data
Updates the tokens data files with all the tokens inside tokens data folder

This script has some dependencies:
install jq 
´´´bash
brew install jq
´´´
install pandas:
´´´bash
pip3 install pandas
pip3 install openpyxl
´´´
then just run:
´´´bash
python3 bash/export_game_data_to_json.py
´´´
