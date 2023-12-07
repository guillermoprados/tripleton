import os
import subprocess

# Function to get the current working directory
def get_current_directory():
    return os.getcwd()

if __name__ == "__main__":
    # Get the current working directory
    current_directory = get_current_directory()
    print("Current Working Directory:", current_directory)

    # Call sync_gdrive.py
    sync_gdrive_script = current_directory + '/bash/sync_gdrive.py'
    subprocess.run(['python3', sync_gdrive_script])

    # Call export_game_data_to_json.py
    export_script = current_directory + '/bash/export_game_data_to_json.py'
    subprocess.run(['python3', export_script])
