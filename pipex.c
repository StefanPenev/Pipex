/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: spenev <spenev@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/27 12:13:32 by spenev            #+#    #+#             */
/*   Updated: 2024/05/27 13:23:05 by spenev           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	execute(char *argv, char **envp)
{
	char	**cmd;
	char	*path;

	cmd = ft_split(argv, ' ');
	path = find_path(cmd[0], envp);
	if (!path)
	{
		ft_free(cmd);
		ft_perror(COLOR_RED"ERROR! Wrong command");
	}
	if (execve(path, cmd, envp) == -1)
		ft_perror(COLOR_RED"ERROR! Execution error");
}

void	parent_process(char *argv[], char *envp[], int fd[])
{
	int	fd_out;

	fd_out = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (fd_out == -1)
		ft_perror(COLOR_RED"ERROR! Output file");
	dup2(fd[0], STDIN_FILENO);
	dup2(fd_out, STDOUT_FILENO);
	close(fd[1]);
	execute(argv[3], envp);
}

void	child_process(char *argv[], char *envp[], int fd[])
{
	int	fd_in;

	fd_in = open(argv[1], O_RDONLY, 0777);
	if (fd_in == -1)
		ft_perror(COLOR_RED"ERROR! Input file");
	dup2(fd[1], STDOUT_FILENO);
	dup2(fd_in, STDIN_FILENO);
	close(fd[0]);
	execute(argv[2], envp);
}

void	pipex(int argc, char *argv[], char *envp[])
{
	int	fd[2];
	int	pid1;

	if (argc != 5)
		ft_error(COLOR_RED"ERROR! Wrong number of arguments");
	if (pipe(fd) == -1)
		ft_perror(COLOR_RED"ERROR");
	pid1 = fork();
	if (pid1 == -1)
		ft_perror(COLOR_RED"ERROR");
	if (pid1 == 0)
		child_process(argv, envp, fd);
	waitpid(pid1, NULL, 0);
	parent_process(argv, envp, fd);
}
