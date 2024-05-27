#!/bin/bash

valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file=valgrind-outt.txt ./pipex in.txt "grep aaa" "wc -l" out.txt