#!/bin/bash

# Default values
name=${1:-"Guest"}
age=0

echo "Hello, $name!"

# Get age if not provided as an argument
if [ "$#" -lt 2 ]; then
    echo "Enter your age:"
    read age
else
    age=$2
fi

echo "You are $age years old."

