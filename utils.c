#include "pipex.h"

void    ft_perror(char *str)
{
    perror(str);
    exit(EXIT_FAILURE);
}

void    ft_error(char *str)
{
    ft_putendl_fd(str, 1);
    exit(EXIT_FAILURE);
}

void    ft_free(char **data)
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