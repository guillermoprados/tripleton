import io
import os
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2 import service_account

def download_file(real_file_id, credentials, export_mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', destination_path='.'):
    """Downloads a file
    Args:
        real_file_id: ID of the file to download
        credentials: Service account credentials
        export_mimetype: MIME type for export (default is 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        destination_path: Path to save the downloaded file (default is the current directory)
    Returns: Full path to the downloaded file.
    """
    try:
        # create drive api client
        service = build("drive", "v3", credentials=credentials)

        file_id = real_file_id

        request = service.files().export_media(fileId=file_id, mimeType=export_mimetype)
        file_path = os.path.join(destination_path, 'game_config.xlsx')  # Change the file extension based on your export type
        file = io.FileIO(file_path, 'wb')
        downloader = MediaIoBaseDownload(file, request)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print(f"Download {int(status.progress() * 100)}.")

    except HttpError as error:
        print(f"An error occurred: {error}")
        file_path = None

    return file_path

if __name__ == "__main__":
    current_dir = os.getcwd()
    file_id = '1OSIRBxDzhq0kEK6OOmUV9GM9uxbSI-aA7gFrkZeup9w'
    # Replace 'YOUR_DESTINATION_PATH' with the desired destination path
    destination_path = current_dir + '/game_design'
    credentials_path = current_dir + '/keys/tripleton-449811bdca96.json'

    credentials = service_account.Credentials.from_service_account_file(
        credentials_path,
        scopes=['https://www.googleapis.com/auth/drive']
    )

    downloaded_file = download_file(file_id, credentials, destination_path=destination_path)

    if downloaded_file:
        print(f"File downloaded successfully: {downloaded_file}")
    else:
        print("Failed to download file.")
