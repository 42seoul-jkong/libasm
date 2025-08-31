/* ************************************************************************** */
/*                                                                            */
/*     _ _ _                                           :::      ::::::::      */
/*    | (_) |__   __ _ ___ _ __ ___                  :+:      :+:    :+:      */
/*    | | | '_ \ / _` / __| '_ ` _ \               +:+ +:+         +:+        */
/*    | | | |_) | (_| \__ \ | | | | |            +#+  +:+       +#+           */
/*    |_|_|_.__/ \__,_|___/_| |_| |_|          +#+#+#+#+#+   +#+              */
/*                                                  #+#    #+#                */
/*                                                 ###   ########   seoul.kr  */
/*                                                                            */
/* ************************************************************************** */

#pragma once

#include <stddef.h>
#include <sys/types.h>

size_t ft_strlen(const char* s);
char* ft_strcpy(char* dst, const char* src);
int ft_strcmp(const char* s1, const char* s2);
ssize_t ft_write(int fd, const void* buf, size_t count);
ssize_t ft_read(int fd, void* buf, size_t count);
char* ft_strdup(const char* s);

int ft_atoi_base(const char* nptr, const char* base);

typedef struct s_list
{
    void* data;
    struct s_list* next;
} t_list;

typedef int (*t_list_cmp_data)(const void* data1, const void* data2);
typedef void (*t_list_free_data)(void* data);

t_list* ft_list_push_front(t_list** begin_list_ptr, void* data);
size_t ft_list_size(const t_list* begin_list);
void ft_list_sort(t_list** begin_list_ptr, t_list_cmp_data cmp);
size_t ft_list_remove_if(t_list** begin_list_ptr, void* data_ref, t_list_cmp_data cmp, t_list_free_data free_data);
