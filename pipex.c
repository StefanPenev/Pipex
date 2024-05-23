#include "pipex.h"

char *ft_getenv (char *envp[], const char *name)
{
    char **ep;

    if (envp == NULL || name[0] == '\0')
    return NULL;
    size_t len = ft_strlen (name);
    ep = envp;
    while (*ep != NULL)
    {
        if (name[0] == (*ep)[0] && 
            ft_strncmp (name, *ep, len) == 0 && (*ep)[len] == '=')
	        return *ep + len + 1;
        ep++;
    }
    return NULL;
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
		if (access(path, F_OK) == 0)
			return (path);
		free(path);
		i++;
	}
	//i = 0;
	ft_free(paths);
	return (0);
}

void	execute(char *argv, char **envp)
{
    //int 	i;
	char	**cmd;
	char	*path;
	
	//i = 0;
	cmd = ft_split(argv, ' ');
	path = find_path(cmd[0], envp);
	if (!path)	
	{
		ft_free(cmd);
		ft_perror("ERROR! Path error.");
	}
	if (execve(path, cmd, envp) == -1)
		ft_perror("ERROR! Execution error.");
}

void parent_process(char *argv[], char *envp[], int fd[])
{
    int fd_out;

    fd_out = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0777);
    if (fd_out == -1)
        ft_perror("ERROR! Output file.");
    dup2(fd[0], STDIN_FILENO);
	dup2(fd_out, STDOUT_FILENO);
	close(fd[1]);
	execute(argv[3], envp);
}

void child_process(char *argv[], char *envp[], int fd[])
{
    int fd_in;

    fd_in = open(argv[1], O_RDONLY, 0777);
    if (fd_in == -1)
        ft_perror("ERROR! Input file.");
    dup2(fd[1], STDOUT_FILENO);
	dup2(fd_in, STDIN_FILENO);
	close(fd[0]);
	execute(argv[2], envp);
}

void    pipex(int argc, char *argv[], char *envp[]) 
{
    int fd[2];
    int pid1;

    if (argc != 5)
        ft_error("ERROR! Wrong number of arguments.");
    if (pipe(fd) == -1)
        ft_perror("ERROR!");
    pid1 = fork();
    if (pid1 == -1)
        ft_perror("ERROR!");
    if (pid1 == 0)
        child_process(argv, envp, fd);
    waitpid(pid1, NULL, 0);
    parent_process(argv, envp, fd);
}