#!/bin/bash

#Colors
NC="\033[0m"
CYAN="\033[36m"
BOLD="\033[1m"
ULINE="\033[4m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"

# Compile the pipex program
make re

# Set the timeout duration (in seconds)
TIMEOUT_DURATION=10

# Start the pipex program in the background
START_TIME=$(date +%s)
./pipex /dev/urandom "cat" "head -1" output.txt &
PIPEX_PID=$!

# Start a background process to kill the pipex process after the timeout
(
    sleep $TIMEOUT_DURATION
    if kill -0 $PIPEX_PID 2>/dev/null; then
        kill -9 $PIPEX_PID
    fi
) &
WATCHDOG_PID=$!

# Wait for the pipex program to finish
wait $PIPEX_PID
EXIT_STATUS=$?

# Stop the watchdog process
kill -9 $WATCHDOG_PID 2>/dev/null

END_TIME=$(date +%s)

# Calculate the elapsed time
ELAPSED_TIME=$(($END_TIME - $START_TIME))

# Check if the program was killed by the watchdog
if [ $EXIT_STATUS -eq 137 ]; then
    printf "${RED}Pipex timed out after $TIMEOUT_DURATION seconds.${NC}"
else
    printf "${GREEN}pipex completed successfully in $ELAPSED_TIME seconds.${NC}"
fi

# Display the output of the pipex program if it didn't timeout
if [ $EXIT_STATUS -ne 137 ]; then
    echo "Output of pipex:"
    cat output.txt
fi

# # Clean up
# make fclean