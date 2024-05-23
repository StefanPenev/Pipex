/* 
	DESCRIPTION:
				The tolower() function converts an upper-case letter to the 
				corresponding lower-case letter.

	RETURN VALUES:
				If the argument is an upper-case letter, the tolower()
				function returns the corresponding lower-case letter if 
				there is one; otherwise, the argument is returned unchanged.
 */

int	ft_tolower(int c)
{
    if (c >= 'A' && c <= 'Z')
        return (c += 32);
    return (c);
}
