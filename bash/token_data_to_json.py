import os
import pandas as pd
import json

def get_current_directory():
    return os.getcwd()

def check_file_existence(file_path):
    return os.path.exists(file_path)

def process_excel_file(file_path):
    # Read the Excel file
    df = pd.read_excel(file_path)

    # Create an empty dictionary to store the JSON structure
    result = {}

    # Iterate through each row in the DataFrame
    for _, row in df.iterrows():
        token_name = row['token_id']

        # Check if the 'token_id' column is not empty
        if pd.notna(token_name):
            # Check if the token is already in the result dictionary
            if token_name not in result:
                result[token_name] = {}

            # Iterate through each property column (starting from the second column)
            for prop_name, prop_value in row.items():
                if prop_name != 'token_id' and pd.notna(prop_value):
                    # Skip the 'token_id' column and ignore empty values
                    # Convert to integer if possible
                    try:
                        result[token_name][prop_name] = int(float(prop_value))
                    except ValueError:
                        result[token_name][prop_name] = prop_value

    return result, df

def save_to_json(result, json_file_path):
    # Convert the result dictionary to JSON and write it to a file
    with open(json_file_path, 'w') as json_file:
        json.dump(result, json_file, indent=2)

def main():
    current_directory = get_current_directory()
    print("Current Working Directory:", current_directory)

    excel_file_path = current_directory + '/game_design/tokens_values.xlsx'

    if check_file_existence(excel_file_path):
        result, df = process_excel_file(excel_file_path)
        save_to_json(result, 'tokens_values.json')

        # Print the first few rows of the DataFrame
        print(df.head())
    else:
        print(f"File not found: {excel_file_path}")

if __name__ == "__main__":
    main()
