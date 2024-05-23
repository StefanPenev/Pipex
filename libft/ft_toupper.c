/* 
	DESCRIPTION:
				The toupper() function converts a lower-case letter to the 
				corresponding upper-case letter.

	RETURN VALUES:
				If the argument is a lower-case letter, the toupper() 
				function returns the corresponding upper-case letter if 
				there is one; otherwise, the argument is returned unchanged.
 */

int	ft_toupper(int c)
{
	if (c >= 'a' && c <= 'z')
		return (c -= 32);
	return (c);
}
