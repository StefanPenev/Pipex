/* 
	DESCRIPTION:
				The isdigit() function tests for a decimal digit character.

	RETURN VALUES:
				The isdigit() function return zero if the character tests 
				false and return non-zero if the character tests true.
 */

int	ft_isdigit(int c)
{
    if (c >= '0' && c <= '9')
        return (1);
    return (0);
}
