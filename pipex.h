#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdio.h>
# include <stdlib.h>
# include <fcntl.h>
# include <sys/wait.h>
# include <string.h>
# include "libft/libft.h"

void    ft_free(char **data);
void    ft_error(char *str);
void    ft_perror(char *str);
void    pipex(int argc, char *argv[], char *envp[]);

#endif