import os
from google.oauth2 import service_account
import requests

def download_file_from_google_drive(file_id, destination, credentials_path):
    # Load the credentials from the service account file
    credentials = service_account.Credentials.from_service_account_file(credentials_path)

    # Download the file
    url = 'https://drive.google.com/uc?id={}'.format(file_id)

    # Set up headers with authorization token
    headers = {'Authorization': 'Bearer {}'.format(credentials.token)}

    # Download the file using requests with custom headers
    response = requests.get(url, headers=headers, stream=True)

    # Save the content to the destination file
    with open(destination, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            if chunk:
                f.write(chunk)

if __name__ == "__main__":
    file_id = '968182285'

    current_dir = os.getcwd()
    # Replace 'YOUR_DESTINATION_PATH' with the desired destination path
    destination_path = current_dir+'/game_design/game_config_downloaded.xlsx'

    credentials_path = current_dir+'/keys/tripleton-449811bdca96.json'

    # Download the file using service account credentials
    download_file_from_google_drive(file_id, destination_path, credentials_path)
