import os
import pandas as pd
import json
import subprocess

def get_current_directory():
    return os.getcwd()

def check_file_existence(file_path):
    return os.path.exists(file_path)

def export_res_files_names():
    # Get the current working directory
    directory = get_current_directory()
    # Specify the command as a list of strings
    command = [directory + '/bash/files_to_json.sh', directory + '/data/tokens_data',
               directory + '/generated/res_tokens_data.json']
    # Run the command
    subprocess.run(command)

def convert_to_int_if_possible(value):
    # Convert to integer if the value is a whole number
    try:
        float_value = float(value)
        if float_value.is_integer():
            return int(float_value)
        return float_value
    except ValueError:
        return value

def process_tokens_sheet(sheet):
    # Process the tokens sheet
    result = {}
    for _, row in sheet.iterrows():
        token_name = row['token_id']
        if pd.notna(token_name):
            if token_name not in result:
                result[token_name] = {}
            # Iterate through each property column (starting from the second column)
            for prop_name, prop_value in row.items():
                # Skip the 'token_id' column and ignore empty values
                # Convert to integer if possible
                if prop_name.lower() != 'token_id' and pd.notna(prop_value):
                    try:
                        result[token_name][prop_name.lower()] = convert_to_int_if_possible(prop_value)
                    except ValueError:
                        result[token_name][prop_name.lower()] = prop_value
    return result

def process_difficulties_sheet(sheet):
    result = {}
    for _, row in sheet.iterrows():
        level_name = row['level']
        if pd.notna(level_name):
            if level_name.lower() not in result:
                result[level_name.lower()] = {}
            for prop_name, prop_value in row.items():
                # Skip the 'level' column and ignore empty values
                # Convert to integer if possible
                if prop_name.lower() != 'level' and pd.notna(prop_value):
                    try:
                        result[level_name.lower()][prop_name.lower()] = convert_to_int_if_possible(prop_value)
                    except ValueError:
                        result[level_name.lower()][prop_name.lower()] = prop_value
    return result

def process_spawn_probabilities_sheet(sheet):
    result = {}
    
    # Exclude the 'total' row
    sheet = sheet.iloc[:-1]
    
    # Use the first column as token_id/level
    token_id_column = sheet.columns[0]
    
    # Iterate over each column (except the first one)
    for column_name in sheet.columns[1:]:
        result[column_name.lower()] = {}
        
        # Iterate over each row
        for _, row in sheet.iterrows():
            token_id = str(row[token_id_column]).lower()
            probability = convert_to_int_if_possible(row[column_name])
            
            # Ignore rows where probability is 0
            if probability != 0:
                result[column_name.lower()][token_id] = probability
    
    return result

def process_file_info_sheet(sheet):
    result = {}

    # Iterate over each row
    for _, row in sheet.iterrows():
        prop_name = row.iloc[0]  # Use the first column as the property name
        prop_value = row.iloc[1]  # Use the second column as the property value

        # Skip rows with empty or NaN property names or values
        if pd.notna(prop_name) and pd.notna(prop_value):
            # Use the property value directly without attempting to convert to int
            result[str(prop_name).lower()] = prop_value

    return result

def process_chest_prizes_sheet(sheet):
    result = {}

    # Exclude the 'total' row
    sheet = sheet.iloc[:-1]

    # Use the first column as the key (probs/chest)
    key_column = sheet.columns[0]

    # Iterate over each column (except the first one)
    for column_name in sheet.columns[1:]:
        result[column_name.lower()] = {}

        # Iterate over each row
        for _, row in sheet.iterrows():
            key_value = str(row[key_column]).lower()
            probability = convert_to_int_if_possible(row[column_name])

            # Ignore rows where probability is 0
            if probability != 0:
                result[column_name.lower()][key_value] = probability

    return result


def save_to_json(output_dict, folder, filename):
    # Create the folder if it doesn't exist
    os.makedirs(folder, exist_ok=True)
    # Join the folder and filename to get the full path
    json_file_path = os.path.join(folder, filename)
    # Convert the output dictionary to JSON and write it to a file
    with open(json_file_path, 'w') as json_file:
        json.dump(output_dict, json_file, indent=2)

def process_excel_file(file_path):
    # Read all sheets into a dictionary
    df_dict = pd.read_excel(file_path, sheet_name=None)

    # Create a dictionary to hold the final output
    output_dict = {}

    for sheet_name, sheet_data in df_dict.items():
        if sheet_name.lower() == 'tokens':
            result = process_tokens_sheet(sheet_data)
            output_dict['tokens'] = result
        elif sheet_name.lower() == 'difficulties':
            result = process_difficulties_sheet(sheet_data)
            output_dict['difficulties'] = result
        elif sheet_name.lower() == 'spawn_probabilities':
            result = process_spawn_probabilities_sheet(sheet_data)
            output_dict['spawn_probabilities'] = result
        elif sheet_name.lower() == 'chest_prizes':
            result = process_chest_prizes_sheet(sheet_data)
            output_dict['chest_prizes'] = result
        elif sheet_name.lower() == 'file_info':
            result = process_file_info_sheet(sheet_data)
            output_dict['file_info'] = result
        else:
            print(f"Unsupported sheet: {sheet_name}")

    # Save the final output to a JSON file
    save_to_json(output_dict, get_current_directory() + '/generated', 'game_config.json')

def main():
    current_directory = get_current_directory()
    print("Current Working Directory:", current_directory)

    print("Exporting game config")
    excel_file_path = current_directory + '/game_design/game_config.xlsx'

    if check_file_existence(excel_file_path):
        process_excel_file(excel_file_path)
    else:
        print(f"File not found: {excel_file_path}")

    print("Exporting Tokens Resources")
    export_res_files_names()

if __name__ == "__main__":
    main()
