#include "libft.h"

/* 
	DESCRIPTION:
				The strchr() function locates the first occurrence of c (converted to a char) 
				in the string pointed to by s.The terminating null character is considered to 
				be part of the string; therefore if c is ‘\0’, the functions locate the 
				terminating ‘\0’.

	RETURN VALUES:
				The function strchr() return a pointer to the located character, 
				or NULL if the character does not appear in the string.
 */

char	*ft_strchr(const char *s, int c)
{
	int	i;
	char *result_ptr;

	i = 1;
	result_ptr = (char *)s;
	if ((char)c == '\0')
	{	
		i = ft_strlen(s);
		return (result_ptr + i);
	}
	if (result_ptr[0] == (char)c)
		return (result_ptr);
	while (s[i] != '\0')
	{
		if (s[i] == (char)c)
			return(result_ptr + i);
		i++;
	}
	return (NULL);
}
