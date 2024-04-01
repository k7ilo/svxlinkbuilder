#!/bin/bash
# Assign the codename from the output of lsb_release -c to a variable
#function check_os {
# 
#OS_name=$(lsb_release -c | grep -oP '(?<=Codename:\s)\w+')#

## Print the value of the variable
#if [ $OS_name != 'bookworm' ]; then
#whiptail --title "SVXLink" --msgbox "This script is only for the Bookworm Linux distribution.\n\n Shutdown and Change to OS Bookworm, with user pi." 8 78
#fi
## Assign the current user of the terminal to a variable
#source ./check_user.sh
#user=$(get_current_user)
#current_user=$user#

## Print the value of the variable
#if [ $current_user != "pi" ]; then
#whiptail --title "SVXLink" --msgbox "This script is only for the pi user. Shutdown and reload the OS with user pi" 8 78
#fi
# 
#}
function check_os {
    # Retrieve the OS codename
    OS_name=$(lsb_release -c | grep -oP '(?<=Codename:\s)\w+')

    # Check if the OS is Bookworm
    if [ "$OS_name" != 'bookworm' ]; then
        whiptail --title "SVXLink" --msgbox "This script is only for the Bookworm Linux distribution.\n\n Shutdown and Change to OS Bookworm, with user pi." 8 78
        exit 1  # Exit the script if the OS is not Bookworm
    fi

    # Check if the current user is 'pi'
    #!/bin/bash

# Source the file containing the functions
source ../functions/check_user.sh

# Call the usercheck function
usercheck

# Continue with the rest of your script...

    current_user=$user

}

