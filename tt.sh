#!/bin/bash

# Compile the pipex program
make re

# Set the timeout duration (in seconds)
# TIMEOUT_DURATION=10

# Run the pipex program with /dev/urandom and check the execution time using timeout
START_TIME=$(date +%s)
timeout 10 ./pipex /dev/urandom "cat" "head -1" ot.txt
EXIT_STATUS=$?
END_TIME=$(date +%s)

# Calculate the elapsed time
ELAPSED_TIME=$(($END_TIME - $START_TIME))

# Check if the program timed out
if [ $EXIT_STATUS -eq 124 ]; then
    echo "pipex timed out after $TIMEOUT_DURATION seconds."
else
    echo "pipex completed successfully in $ELAPSED_TIME seconds."
fi

# Display the output of the pipex program if it didn't timeout
if [ $EXIT_STATUS -ne 124 ]; then
    echo "Output of pipex:"
    cat ot.txt
fi

# # Clean up
# make fclean