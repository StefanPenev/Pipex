#include "libft.h"

/* 
	DESCRIPTION:
				The strlcpy() function copy and concatenate strings with 
				the same input parameters and output result as snprintf(3).
	
	RETURN VALUES:
				The strlcpy() function return the total length of the string 
				tried to create. For strlcpy() that means the length of src.
 */

size_t	ft_strlcpy(char *dst, const char *src, size_t dstsize)
{
	size_t	i;

	i = 0;
	if (dstsize == 0)
		return (ft_strlen(src));
	while (src[i] != '\0' && i < (dstsize - 1))
	{
		dst[i] = src[i];
		i++;
	}
	dst[i] = '\0';
	return (ft_strlen(src));
}