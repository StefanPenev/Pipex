#!/bin/bash

# Stop script on any error
# set -e

#Files
INPUT=Tests/input.txt
INPUT_INVALID=Tests/none
INPUT_INFINITE=/dev/urandom
OUTPUT_EXPECTED=Tests/expected_output.txt
OUTPUT_PIPEX=Tests/output.txt
OUTPUT_FILES=Tests/outs
OUTPUT_INVALID=Tests/invalid_output.txt

#Colors
NC="\033[0m"
BOLD="\033[1m"
ULINE="\033[4m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"

VALGRIND="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"

COMMAND_WITH_PATH=/bin/cat
LEAK_TOGGLE=1
num=0

banner=(
$GREEN"----------------------------------------------------------------------------\n"
$GREEN"######                            #######                                   \n"
$GREEN"#     # # #####  ###### #    #       #    ######  ####  ##### ###### #####  \n"
$GREEN"#     # # #    # #       #  #        #    #      #        #   #      #    # \n"
$GREEN"######  # #    # #####    ##         #    #####   ####    #   #####  #    # \n"
$GREEN"#       # #####  #        ##         #    #           #   #   #      #####  \n"
$GREEN"#       # #      #       #  #        #    #      #    #   #   #      #   #  \n"
$GREEN"#       # #      ###### #    #       #    ######  ####    #   ###### #    # \n"
$GREEN"----------------------------------------------------------------------------\n"$NC
)
printf "${banner[*]}"

delete_files() {
    local dir="$1"
    
    # if [ -z "$dir" ]; then
    #     echo "Usage: delete_files <directory>"
    #     return 1
    # fi
    
    # if [ ! -d "$dir" ]; then
    #     echo "Error: $dir is not a directory"
    #     return 1
    # fi
    
    # echo "Deleting files in $dir ..."
    rm -f "$dir"/*
    # echo "Files deleted."
}

compare_outputs() {
    local num="$1"
    local result
    local color

    if cmp -s "$OUTPUT_EXPECTED" "$OUTPUT_PIPEX"; then
        result="OK"
        color="$GREEN"
    else
        result="FAIL"
        color="$RED"
        diff "$OUTPUT_EXPECTED" "$OUTPUT_PIPEX" > Tests/outs/test-$num.txt
        printf "\r${color}    --ERROR: check /Tests/outs/test-$num.txt for more information.{$NC}"
    fi
    printf "\r${color} %-68s [%s]${NC}\n" " " "$result"
}

delete_files "Tests/outs"

#Norminette
((num++))
norminette > "Tests/outs/norminette.txt" 2>&1

if grep -q "Error" Tests/outs/norminette.txt || [ -s Tests/outs/norminette.txt ]; then
    result="FAIL"
    color=$RED
else
    result="OK"
    color=$GREEN
fi
printf "\r${color}* $num: %-64s [%s]${NC}\n" "Norminette check." "$result"

if [ "$result" = "FAIL" ];  then
    printf "\r${color}    --Norminette Error: %s${NC}\n\n" "Check /Tests/outs/norminette.txt"
fi

#Compiling
((num++))
make re > /dev/null 2>&1
if [ $? -eq 0 ]; then
    result="OK"
    color=$GREEN
else 
    result="FAIL"
    color=$RED
fi
printf "\r\n${color}* $num: %-64s [%s]${NC}\n" "Program compilation." "$result"

if [ "$result" = "FAIL" ];  then
    printf "\r${color}    --%s${NC}\n\n" "Compilation failed."
fi

#Execution
((num++))
if [ -x ./pipex ]; then
	result="OK"
    color=$GREEN
else
    result="FAIL"
    color=$RED
fi
printf "\r\n${color}* $num: %-64s [%s]${NC}\n" "Is pipex executable." "$result"

if [ "$result" = "FAIL" ];  then
    printf "\r${color}    --%s${NC}\n\n" "Pipex is not executable or \"./pipex\" does not exist."
fi

#Tests
##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Counting number of lines in the input file." 
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT cat | wc -l > $OUTPUT_EXPECTED\n${NC}"
<$INPUT cat | wc -l > $OUTPUT_EXPECTED
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"cat\" \"wc -l\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "cat" "wc -l" $OUTPUT_PIPEX

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then 
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "cat" "wc -l" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Grep command to search for a string in the input file."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT cat | grep Lorem > $OUTPUT_EXPECTED${NC}\n"
<$INPUT cat | grep Lorem > $OUTPUT_EXPECTED
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"cat\" \"grep Lorem\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "cat" "grep Lorem" $OUTPUT_PIPEX

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "cat" "grep USER=" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Grep command to search for a string that does not exist in the input file."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT grep aaaaaa | wc -l > $OUTPUT_EXPECTED${NC}\n"
<$INPUT grep aaaaaa | wc -l > $OUTPUT_EXPECTED
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"grep aaaaaa\" \"wc -l\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "grep aaaaaa" "wc -l" $OUTPUT_PIPEX

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "grep abracadabra" "wc -l" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Command contains the path."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT $COMMAND_WITH_PATH | wc -l > $OUTPUT_EXPECTED${NC}\n"
<$INPUT $COMMAND_WITH_PATH | wc -l > $OUTPUT_EXPECTED
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT "$COMMAND_WITH_PATH" \"wc -l\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT $COMMAND_WITH_PATH "wc -l" $OUTPUT_PIPEX

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT $COMMAND_WITH_PATH "wc -l" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Input file does not exist."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT_INVALID cat | wc -l > $OUTPUT_EXPECTED${NC}\n"
if [ ! -f "$INPUT_INVALID" ]; then
    echo "No such file or directory" > $OUTPUT_EXPECTED
fi
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT_INVALID \"cat\" \"wc -l\" $OUTPUT_PIPEX${NC}\n"
CMD="./pipex $INPUT_INVALID "cat" "wc -l" $OUTPUT_PIPEX"
if ! < "$CMD"; then
    echo "No such file or directory" > $OUTPUT_PIPEX
fi

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT_INVALID "cat" "wc -l" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "First command is wrong."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT wrong | wc -l > $OUTPUT_EXPECTED${NC}\n"
<$INPUT wrong | wc -l > $OUTPUT_EXPECTED 
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    echo "The first command in the pipeline failed." > $OUTPUT_EXPECTED
fi
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"wrong\" \"wc -l\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "wrong" "wc -l" $OUTPUT_PIPEX
if [[ ${PIPESTATUS[0]} -ne 1 ]]; then
    echo "The first command in the pipeline failed." > $OUTPUT_PIPEX
fi

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "wrong" "wc -l" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Second command is wrong."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT cat | wrong > $OUTPUT_EXPECTED${NC}\n"
<$INPUT cat | wrong > $OUTPUT_EXPECTED
if [[ ${PIPESTATUS[1]} -ne 0 ]]; then
    echo "The second command in the pipeline failed." > $OUTPUT_EXPECTED
fi
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"cat\" \"wrong\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "cat" "wrong" $OUTPUT_PIPEX
if [[ ${PIPESTATUS[1]} -ne 1 ]]; then
    echo "The second command in the pipeline failed." > $OUTPUT_PIPEX
fi

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "cat" "wrong" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Both commands are wrong."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT wrong | wrong > $OUTPUT_EXPECTED${NC}\n"
<$INPUT wrong | wrong > $OUTPUT_EXPECTED
if [[ ${PIPESTATUS[0]} -ne 0 && ${PIPESTATUS[1]} -ne 0 ]]; then
    echo "Both commands in the pipeline failed." > $OUTPUT_EXPECTED
fi
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"wrong\" \"wrong\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT "wrong" "wrong" $OUTPUT_PIPEX
if [[ ${PIPESTATUS[0]} -ne 1 && ${PIPESTATUS[1]} -ne 1 ]]; then
    echo "Both commands in the pipeline failed." > $OUTPUT_PIPEX
fi

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "wrong" "wrong" $OUTPUT_PIPEX
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Output file can not be opened. Permission denied."
touch Tests/invalid_output.txt
chmod 000 Tests/invalid_output.txt
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT cat | wc -l > $OUTPUT_INVALID${NC}\n"
if ! cat "$INPUT" | wc -l > "$OUTPUT_INVALID" 2>/dev/null; then
    echo "Permission denied." > $OUTPUT_EXPECTED
fi
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT \"cat\" \"wc -l\" $OUTPUT_INVALID${NC}\n"
CMD="./pipex $INPUT 'cat' 'wc -l' $OUTPUT_INVALID"
eval "$CMD"
if [ $? -ne 126 ]; then
    echo "Permission denied." > $OUTPUT_PIPEX
fi

compare_outputs $num

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT "cat" "wc -l" $OUTPUT_INVALID
fi

##
((num++))
printf "\r\n${color}* $num: %s${NC}\n" "Infinite input file. Should not hang."
printf "${ULINE}Shell command: ${BOLD}${BLUE}<$INPUT_INFINITE cat | head -1 > $OUTPUT_EXPECTED${NC}\n"
<$INPUT_INFINITE cat | head -1 > $OUTPUT_EXPECTED
printf "${ULINE}Pipex command: ${BOLD}${BLUE}./pipex $INPUT_INFINITE \"cat\" \"head -1\" $OUTPUT_PIPEX${NC}\n"
./pipex $INPUT_INFINITE "cat" "head -1" $OUTPUT_PIPEX
TIMEOUT_DURATION=10
START_TIME=$(date +%s)
timeout $TIMEOUT_DURATION ./pipex /dev/urandom "cat" "head -1" $OUTPUT_PIPEX
EXIT_STATUS=$?
END_TIME=$(date +%s)
ELAPSED_TIME=$(($END_TIME - $START_TIME))
if [ $EXIT_STATUS -eq 124 ]; then
    result="FAIL"
    color=$RED
    printf "\r${color}    --%s${NC}\n" "Pipex timed out after $TIMEOUT_DURATION seconds."
else
    result="OK"
    color=$GREEN
    # printf "${GREEN}Pipex completed successfully in $ELAPSED_TIME seconds.${NC}"
fi
printf "\r${color} %-68s [%s]${NC}\n" " " "$result"

if [ $LEAK_TOGGLE -eq 1 ]; then
    printf "Leak check:${BLUE}\n"
    $VALGRIND ./pipex $INPUT_INFINITE "cat" "head -1" $OUTPUT_PIPEX
fi