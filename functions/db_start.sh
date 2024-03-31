#!/bin/bash

# Define the filename for the SQLite database
DB_FILE="example.db"

# Define the list of categories
CATEGORIES=("header" "GLOBAL" "RepeaterLogic" "SimplexLogic" "ReflectorLogic" "LinkToReflector" "Macros" "Rx1" "Tx1" "Voter" "MultiTx" "NetRx" "NetTx" "QsoRecorder" "TxStream" "WbRx1" "Location")

# Read the filenames for each category's content from category_list.txt
FILES=($(<../configs/category_list.txt))

# Check if the number of categories matches the number of filenames
if [ ${#CATEGORIES[@]} -ne ${#FILES[@]} ]; then
    echo "Error: Number of categories does not match the number of filenames."
    exit 1
fi

# Create the SQLite database file with elevated privileges using sudo
{
    # Create tables for categories and insert data into tables
    for ((i=0; i<${#CATEGORIES[@]}; i++)); do
        category="${CATEGORIES[$i]}"
        file="${FILES[$i]}"
        
        # Create table for current category
        echo "CREATE TABLE IF NOT EXISTS $category (
            id INTEGER PRIMARY KEY,
            command TEXT,
            value TEXT
        );"

        # Insert data into table for current category
        echo "-- Insert data into $category table"
        echo "BEGIN;"
        if [ -f "$file" ]; then
            while IFS= read -r line; do
                # Process all lines, including commented ones
                command=$(echo "$line" | cut -d '=' -f 1)
                value=$(echo "$line" | cut -d '=' -f 2)
                echo "INSERT INTO $category (command, value) VALUES ('$command', '$value');"
            done < "$file"
        fi
        echo "COMMIT;"
    done
} | sudo sqlite3 "$DB_FILE"

