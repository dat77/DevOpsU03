#!/bin/bash

# Script automatically creates "group" and "user" assiged to this group based on user input

# Keyboard input, returns input string as $name variable
read_name(){
        read -p "Enter $1 name: " -t 20 name
        if [ -z "$name" ];
        then
                echo ":Input timeout. Exiting..."
                exit 1
        fi
}

# check if group/user exists
# param $1 name of group or user
# param $2 "group" for group checking, "passwd" for user checking
grp_usr_exists() {
        if grep -q "^$1:" /etc/$2;
        then
                return 0 # exists
        else
                return 1 # does not exist
        fi
}

create_group() {
        if grp_usr_exists "$1" "group"
        then
                echo "Group $1 already exists. You can assign user to"
        else
                sudo groupadd "$1"
                echo "Group $1 has been created. You can assign user to"
        fi
}

create_user() {
        if grp_usr_exists "$1" "passwd"
        then
                echo "ERROR. User $1 already exists."
        else
                sudo useradd -g $2 $1
                echo "User $1 has been created and assigned to the group $2"
        fi
}

echo "Create group and user assigned to the group."

read_name "group"
group_name="$name"
create_group $group_name

read_name "user"
user_name="$name"
create_user $user_name $group_name