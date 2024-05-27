/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: spenev <spenev@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/27 12:13:36 by spenev            #+#    #+#             */
/*   Updated: 2024/05/27 12:32:19 by spenev           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdio.h>
# include <stdlib.h>
# include <fcntl.h>
# include <sys/wait.h>
# include <string.h>
# include "Libft/libft.h"

void	ft_free(char **data);
void	ft_error(char *str);
void	ft_perror(char *str);
void	pipex(int argc, char *argv[], char *envp[]);

#endif