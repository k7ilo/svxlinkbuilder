##!/bin/bash
#CONF_DIR="/etc/svxlink"
#LOGIC_DIR="/usr/share/svxlink/events.d/local"
#svxfile="svxlink.conf"
#logictcl="Logic.tcl"
#logicfile="$LOGIC_DIR/$logictcl"
#svxconf_file="$CONF_DIR/$svxfile"
###### Adding a ReflectorLogic section to svxlink.conf #####
##if [[ "$NODE_OPTION" == "2" ]] || [[ "$NODE_OPTION" == "4" ]]; then 
#    section_name="ReflectorLogic"
#
#    # Check if the section already exists
#
#    if grep -q "\[${section_name}\]" "$svxconf_file"; then
#echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
#
#    else
#    echo "no valid option"
#
#    fi
# #   fi
#!/bin/bash

# Define directories and files
CONF_DIR="/etc/svxlink"
svxfile="svxlink.conf"
svxconf_file="$CONF_DIR/$svxfile"

section_name="ReflectorLogic"

# Function to prompt the user for a new value
prompt_for_value() {
    local field_name=$1
    local current_value=$2
    echo "Enter the new value for $field_name (current value: $current_value):"
    read new_value
    echo "Entered value: $new_value" # Debug statement
    echo "$new_value"
}

# Function to confirm the new value with the user
confirm_value() {
    local value=$1
    echo "Is this value correct? $value (yes/no)"
    read answer
    if [ "$answer" = "yes" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get the current value of a field from a specific section in the configuration file
get_current_value() {
    local section=$1
    local field_name=$2
    awk -v section="$section" -v field="$field_name" '
    $0 == "[" section "]" { in_section = 1; next }
    in_section && $0 ~ /^\[/ { in_section = 0 }
    in_section && $0 ~ "^" field "=" { print substr($0, index($0, "=") + 1); exit }
    ' "$svxconf_file" | tr -d '"'
}

# Function to update the value of a field in a specific section in the configuration file
update_field_value() {
    local section=$1
    local field_name=$2
    local new_value=$3
    awk -v section="$section" -v field="$field_name" -v new_val="$new_value" '
    $0 == "[" section "]" { in_section = 1; print; next }
    in_section && $0 ~ /^\[/ { in_section = 0 }
    in_section && $0 ~ "^" field "=" { print field "=" new_val; next }
    { print }
    ' "$svxconf_file" > "${svxconf_file}.tmp" && mv "${svxconf_file}.tmp" "$svxconf_file"
}

# Function to prompt for and confirm a value, allowing retries
prompt_and_confirm_value() {
    local field_name=$1
    local current_value=$2
    local new_value=""
    local confirmed=false
    while ! $confirmed; do
        new_value=$(prompt_for_value "$field_name" "$current_value")
        echo "Confirming value: $new_value" # Debug statement
        confirm_value "$new_value"
        if [ $? -eq 0 ]; then
            confirmed=true
        else
            echo "Please re-enter the value for $field_name."
        fi
    done
    echo "$new_value"
}

# Check if the section already exists
if grep -q "\[${section_name}\]" "$svxconf_file"; then
    echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
    
    # Get current value for HOSTS
    current_hosts=$(get_current_value "$section_name" "HOSTS")
    echo "Current HOSTS value: $current_hosts" # Debug statement

    # Prompt for new value with confirmation
    new_hosts=$(prompt_and_confirm_value "HOSTS" "$current_hosts")
    echo "New HOSTS value: $new_hosts" # Debug statement

    # Update the configuration file with the new value
    update_field_value "$section_name" "HOSTS" "$new_hosts"

else
    echo "Section $section_name does not exist in $svxconf_file" | tee -a /var/log/install.log
    # Optionally, add the section to the configuration file
    echo "Adding section $section_name to $svxconf_file" | tee -a /var/log/install.log
    
