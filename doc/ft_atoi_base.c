/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi_base.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jkong <jkong@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/01/13 14:42:00 by jkong             #+#    #+#             */
/*   Updated: 2022/01/14 17:20:05 by jkong            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

int	ft_isspace(char c)
{
	if (c == '\t')
		return (1);
	if (c == '\n')
		return (1);
	if (c == '\v')
		return (1);
	if (c == '\f')
		return (1);
	if (c == '\r')
		return (1);
	if (c == ' ')
		return (1);
	return (0);
}

int	get_negative(char **str_ptr)
{
	char	*str;
	int		negative;

	str = *str_ptr;
	negative = 0;
	while (*str && ft_isspace(*str))
		str++;
	while (*str)
	{
		if (*str == '-')
		{
			negative ^= 1;
			str++;
		}
		else if (*str == '+')
		{
			str++;
		}
		else
		{
			break ;
		}
	}
	*str_ptr = str;
	return (negative);
}

int	get_number(char c, char *base)
{
	int	i;

	i = 0;
	while (base[i] && base[i] != c)
		i++;
	return (i);
}

int	assert_argument_atoi(char *base)
{
	char	*next;

	if (base[0] == '\0' || base[1] == '\0')
		return (0);
	while (*base)
	{
		if (*base == '+' || *base == '-' || ft_isspace(*base))
			return (0);
		next = base + 1;
		while (*next)
		{
			if (*base == *next)
				return (0);
			next++;
		}
		base++;
	}
	return (1);
}

int	ft_atoi_base(char *str, char *base)
{
	int	num_sys;
	int	negative;
	int	number;
	int	digit;

	if (!assert_argument_atoi(base))
		return (0);
	num_sys = get_number('\0', base);
	negative = get_negative(&str);
	number = 0;
	while (*str)
	{
		digit = get_number(*str, base);
		if (digit == num_sys)
			break ;
		str++;
		number *= num_sys;
		if (negative)
			number -= digit;
		else
			number += digit;
	}
	return (number);
}
