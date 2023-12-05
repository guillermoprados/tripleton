
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

### sync game design

Dependencies:

´´´
pip3 install google-api-python-client
pip3 install google-auth google-auth-oauthlib google-auth-httplib2
pip3 install requests
´´´
(read google cloud credentials section for more info)

command:

´´´
python3 bash/sync_gdrive.py
´´´

## download file and export data:

run :
python3 bash/sync_game_config_and_export.py

## google cloud credentials
## How to get the google cloud credentials to access the excel file
To use the Google Sheets API in this project, you'll need Google Cloud credentials. Follow these steps:

1. **Go to the [Google Cloud Console](https://console.cloud.google.com/).**
   - If you don't have an account, you'll need to sign up.
   
2. **Create a New Project:**
   - Click on the project dropdown in the top bar.
   - Click the "New Project" button.
   - Enter a name for your project and click "Create."

3. **Enable the Google Sheets API:**
   - In the left navigation pane, click on "APIs & Services" > "Dashboard."
   - Click on "+ ENABLE APIS AND SERVICES" at the top.
   - Search for "Google Sheets API" and select it.
   - Click the "Enable" button.

4. **Create Credentials:**
   - In the left navigation pane, click on "APIs & Services" > "Credentials."
   - Click on the "Create Credentials" dropdown and select "Service account key."
   - Choose or create a service account, set a role (e.g., Project > Editor), and select "JSON" as the key type.
   - Click "Continue" and then "Create." This will download a JSON file containing your credentials.

5. **Add Permissions (if needed):**
   - If you're working with Google Sheets in Google Drive, you might need to share the sheet with the service account email address found in the JSON file under `"client_email"`.

6. **Keep Your Credentials Secure:**
   - Treat your credentials file (`client_secrets.json`) like a password. Keep it secure and don't share it in public repositories.

7. **Use the Credentials in Your Script:**
   - In your script, provide the path to the downloaded `client_secrets.json` file to authenticate.
