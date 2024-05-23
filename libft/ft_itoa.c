#include "libft.h"

static int	count_digits(int n)
{
	int count;

	if (n == 0)
		return (1);
	count = 0;
	if (n < 0)
	{
		n *= -1;
		count++;
	}
	while (n > 0)
	{
		n /= 10;
		count++;
	}
	return (count);
}

char	*ft_itoa(int n)
{
	int length;

	if (n == -2147483648)
		return (ft_strdup("-2147483648"));
	length = count_digits(n);
	char	*buffer = (char *)malloc(length + 1);
	if (buffer == NULL)
		return (NULL);
	buffer[0] = '0';
	if (n < 0)
	{
		buffer[0] = '-';
		n *= -1;
	}
	buffer[length] = '\0';
	length--;
	while (n > 0)
	{
		buffer[length] = (n % 10) + '0';
		n /= 10;
		length--;
	}
	return (buffer);
}
