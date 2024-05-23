#include "libft.h"

/* 
	DESCRIPTION:
				The bzero() function writes n zeroed bytes to the string s.
				If n is zero, bzero() does nothing.
 */

void	ft_bzero(void *s, size_t n)
{
	ft_memset(s, '\0', n);
}
