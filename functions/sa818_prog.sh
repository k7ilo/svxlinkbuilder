#!/bin/bash

function sa818_prog {
    # Paths to frequency files
    UHF_FILE="/home/pi/svxlinkbuilder/configs/UHF.txt"
    VHF_FILE="/home/pi/svxlinkbuilder/configs/VHF.txt"
    
    # Determine which frequency file to use based on $band
    if [ "$band" == "UHF" ]; then
        # Read UHF frequencies from file
        if [ -f "$UHF_FILE" ]; then
            mapfile -t frequencies < "$UHF_FILE"
        else
            whiptail --msgbox "Error: UHF frequency file not found!" 10 78
            exit 1
        fi
    elif [ "$band" == "VHF" ]; then
        # Read VHF frequencies from file
        if [ -f "$VHF_FILE" ]; then
            mapfile -t frequencies < "$VHF_FILE"
        else
            whiptail --msgbox "Error: VHF frequency file not found!" 10 78
            exit 1
        fi
    else
        whiptail --msgbox "Error: Invalid band selection!" 10 78
        exit 1
    fi

    # Create whiptail menu options from frequencies
    options=()
    for freq in "${frequencies[@]}"; do
        options+=("$freq" "")
    done

    # Frequency Selection
     echo "Options passed to whiptail: ${options[@]}"
     
    selected_frequency=$(whiptail --title "$band Frequency Selection" --radiolist 10 30 100 20\
    "Select the $band frequency:"  "${options[@]}" 3>&1 1>&2 2>&3)

    # Output the results for verification
    echo "SA818 device fitted: $sa818"
    echo "Selected frequency band: $band"
    echo "Selected frequency: $selected_frequency"

    #### Changing Frequency ####
}
