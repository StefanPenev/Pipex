/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: stefan <stefan@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/27 12:14:25 by spenev            #+#    #+#             */
/*   Updated: 2024/06/13 11:16:20 by stefan           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	ft_perror(char *str)
{
	perror(str);
	exit(EXIT_FAILURE);
}

void	ft_error(char *str)
{
	ft_putendl_fd(str, STDERR_FILENO);
	ft_putendl_fd(COLOR_GREEN"\nExample of using:\
$$> ./pipex infile \"cmd1\" \"cmd2\" outfile"COLOR_RESET, STDERR_FILENO);
	exit(EXIT_FAILURE);
}

void	ft_free(char **data)
{
	size_t	i;

	i = 0;
	while (data[i])
	{
		free(data[i]);
		i++;
	}
	free(data);
}

static char	*ft_getenv(char *envp[], const char *name)
{
	char	**ep;
	size_t	len;

	if (envp == NULL || name[0] == '\0')
		return (NULL);
	len = ft_strlen (name);
	ep = envp;
	while (*ep != NULL)
	{
		if (name[0] == (*ep)[0] &&
			ft_strncmp (name, *ep, len) == 0 && (*ep)[len] == '=')
			return (*ep + len + 1);
		ep++;
	}
	return (NULL);
}

char	*find_path(char *cmd, char **envp)
{
	char	**paths;
	char	*path;
	int		i;
	char	*part_path;

	paths = ft_split(ft_getenv(envp, "PATH"), ':');
	i = 0;
	while (paths[i])
	{
		part_path = ft_strjoin(paths[i], "/");
		path = ft_strjoin(part_path, cmd);
		free(part_path);
		if (access(path, F_OK | X_OK) == 0)
			return (path);
		free(path);
		i++;
	}
	ft_free(paths);
	return (cmd);
}
