# `Pipex`

## Description
`Pipex` is a program that simulates the behavior of shell pipelines. The program takes four arguments: two filenames and two shell commands with their parameters. It replicates the behavior of the shell command:

```bash
< file1 cmd1 | cmd2 > file2
```

## Usage
```bash
./pipex file1 cmd1 cmd2 file2
```
file1: The name of the input file.
cmd1: The first command to execute.
cmd2: The second command to execute.
file2: The name of the output file.

## Examples
```bash
$ ./pipex infile "ls -l" "wc -l" outfile
```
### This should behave like:
```bash
< infile ls -l | wc -l > outfile
```
```bash
$ ./pipex infile "grep a1" "wc -w" outfile
```
### This should behave like:
```bash
< infile grep a1 | wc -w > outfile
```
