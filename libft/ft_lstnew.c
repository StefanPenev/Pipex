#include "libft.h"

t_list	*ft_lstnew(void *content)
{
	t_list *list;

    list = (t_list *)malloc(sizeof(*list));
    if (!list)
        return (NULL);
    list->content = content;
    list->next = NULL;
    return (list);
}