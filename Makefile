# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: spenev <spenev@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/27 12:14:32 by spenev            #+#    #+#              #
#    Updated: 2024/05/27 13:33:34 by spenev           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PROG	= pipex

SRCS 	= pipex.c utils.c main.c
OBJS 	= ${SRCS:.c=.o}

CC 		= gcc
CFLAGS 	= -Wall -Wextra -Werror -g

COLOR_RED = '\033[31m'
COLOR_GREEN = '\033[32m'
COLOR_BLUE = '\033[34m'
COLOR_YELLOW = '\033[33m'

.c.o:		%.o : %.c
					@gcc ${CFLAGS} ${HEADER} -c $< -o $(<:.c=.o)

all: 		${PROG}

${PROG}:	${OBJS}
					@echo ${COLOR_BLUE}"----Compiling lib----"
					@make re -C ./libft
					@$(CC) ${OBJS} -Llibft -lft -o ${PROG}
					@echo ${COLOR_GREEN}"Pipex Compiled!\n\n\
Example of using: $$> ./pipex infile \"cmd1\" \"cmd2\" outfile"

clean:
					@make clean -C ./libft
					@rm -f ${OBJS} ${OBJS_B}

fclean: 	clean
					@echo ${COLOR_YELLOW}"Cleaning"
					@make fclean -C ./libft
					@rm -f $(NAME)
					@rm -f ${PROG}
					@echo ${COLOR_RED}"\nCleaning Done!\n"

re:			fclean all

.PHONY: all clean fclean re re_bonus bonus party