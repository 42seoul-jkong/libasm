#include "libasm.h"

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const char *sample_vector[] = {"",
                               "0",
                               "0123456789",
                               "0123456789ABCD-",
                               "0123456789ABCDEF",
                               "0123456789ABCDEF+",
                               "0123456789ABCDEF0123456789ABCD-",
                               "0123456789ABCDEF0123456789ABCDEF",
                               "0123456789ABCDEF0123456789ABCDEF+",
                               "0123456789ABCDEF0\000123456789ABCDEF",
                               "0123456789ABCDEF01\00023456789ABCDEF",
                               "0123456789ABCDEF012\0003456789ABCDEF",
                               "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                               "ZZZZZZZZZ",
                               "XXXXXXXXX",
                               "YYYYYYYYY",
                               "MMMMMMMMM",
                               "NNNNNNNNN",
                               "WWWWWWWWW",
                               "CCCCCCCCC",
                               "VVVVVVVVV",
                               "BBBBBBBBB",
                               "AAAAAAAAA",
                               "FFFFFFFFF",
                               "999999999",
                               "000000000",
                               "한글",
                               "각",
                               "가",
                               "갂",
                               "AB",
                               "A",
                               "ABC",
                               "ABD",
                               "ABB",
                               "2147483647",
                               "2147483648",
                               "-2147483648",
                               "-2147483649",
                               "+0",
                               "-0",
                               "      -42",
                               "       42",
                               NULL};

void panic(const char *error) {
  fprintf(stderr, "%s\n", error);
  exit(EXIT_FAILURE);
}

void *xmalloc(size_t size) {
  return malloc(size) ?: (panic("No memory"), NULL);
}

void cleanup_malloc(void **ptr_ptr) { free(*ptr_ptr); }
#define AUTO_PTR __attribute__((__cleanup__(cleanup_malloc))) void *

void cleanup_open(int *fd_ptr) { close(*fd_ptr); }
#define AUTO_FD __attribute__((__cleanup__(cleanup_open))) int

bool compare_strlen(const char *s) {
  if (strlen(s) != ft_strlen(s)) {
    printf("strlen 다름: \"%s\"\n", s);
    return false;
  }
  return true;
}

bool test_strlen(void) {
  bool success = true;
  for (const char **sample = sample_vector; *sample; sample++) {
    success &= compare_strlen(*sample);
  }
  return success;
}

bool compare_strcpy(const char *s) {
  size_t size = strlen(s) + 1;
  AUTO_PTR libc = xmalloc(size);
  AUTO_PTR libasm = xmalloc(size);

  if (strcpy(libc, s) != libc) {
    panic("libc의 strcpy가 dest를 반환하지 않았음");
  }
  if (ft_strcpy(libasm, s) != libasm) {
    printf("strcpy가 dest를 반환하지 않았음: \"%s\"\n", s);
    return false;
  }
  if (memcmp(libc, libasm, size) != 0) {
    printf("strcpy의 각 dest를 memcmp한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  return true;
}

bool test_strcpy(void) {
  bool success = true;
  for (const char **sample = sample_vector; *sample; sample++) {
    success &= compare_strcpy(*sample);
  }
  return success;
}

static int standardization(int x) { return x < 0 ? -1 : x > 0 ? 1 : 0; }

bool compare_strcmp(const char *s1, const char *s2) {
  int libc = standardization(strcmp(s1, s2));
  int libasm = standardization(ft_strcmp(s1, s2));
  if (libc != libasm) {
    printf("strcmp 다름: \"%s\", \"%s\"\n", s1, s2);
    printf("\tlibc: %d\n", libc);
    printf("\tlibasm: %d\n", libasm);
    return false;
  }
  return true;
}

bool test_strcmp(void) {
  bool success = true;
  for (const char **sample = sample_vector; *sample; sample++) {
    success &= compare_strcmp(sample[0], sample[1] ?: "");
  }
  return success;
}

bool test_write(void) {
  if (ft_write(STDOUT_FILENO, "표준 출력\n", 14) != 14) {
    printf("stdout의 partial write\n");
  }
  if (errno != 0) {
    perror("stdout 출력 중 오류 발생\n");
    return false;
  }
  if (ft_write(STDERR_FILENO, "표준 오류 출력\n", 21) != 21) {
    printf("stderr의 partial write\n");
  }
  if (errno != 0) {
    perror("stderr 출력 중 오류 발생\n");
    return false;
  }
  if (!(ft_write(42, "open하지 않은 fd", 20) < 0)) {
    printf("오류 발생하지 않음\n");
    return false;
  }
  if (errno != EBADF) {
    perror("오류 발생하지 않음\n");
    return false;
  }
  return true;
}

bool test_read(void) {
  AUTO_FD dev_urandom = open("/dev/urandom", O_RDONLY);
  unsigned char buf[4096];
  if (ft_read(dev_urandom, buf, sizeof(buf)) != sizeof(buf)) {
    printf("/dev/urandom의 partial read\n");
  }
  printf("/dev/urandom: %x\n", buf[0]);
  AUTO_FD dev_null = open("/dev/null", O_RDONLY);
  if (ft_read(dev_null, buf, sizeof(buf)) != 0) {
    printf("/dev/null에서 읽음\n");
  }
  if (!(ft_read(42, "open하지 않은 fd", 20) < 0)) {
    printf("오류 발생하지 않음\n");
    return false;
  }
  if (errno != EBADF) {
    perror("오류 발생하지 않음\n");
    return false;
  }
  return true;
}

bool compare_strdup(const char *s) {
  size_t size = strlen(s) + 1;
  AUTO_PTR libc = strdup(s);
  AUTO_PTR libasm = ft_strdup(s);

  if (memcmp(libc, libasm, size) != 0) {
    printf("strdup의 각 결과를 memcmp한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  return true;
}

bool test_strdup(void) {
  bool success = true;
  for (const char **sample = sample_vector; *sample; sample++) {
    success &= compare_strdup(*sample);
  }
  return success;
}

bool compare_atoi_base(const char *s) {
  if (ft_atoi_base(s, "0123456789") != (int)strtol(s, NULL, 10) &&
      errno != ERANGE) {
    printf("atoi_base 10의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "0123456789ABCDEF") != (int)strtol(s, NULL, 16) &&
      errno != ERANGE) {
    printf("atoi_base 16의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "01234567") != (int)strtol(s, NULL, 8) &&
      errno != ERANGE) {
    printf("atoi_base 8의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "01") != (int)strtol(s, NULL, 2) && errno != ERANGE) {
    printf("atoi_base 2의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") !=
          (int)strtol(s, NULL, 36) &&
      errno != ERANGE) {
    printf("atoi_base 36의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "012345678") != (int)strtol(s, NULL, 9) &&
      errno != ERANGE) {
    printf("atoi_base 9의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  if (ft_atoi_base(s, "0123456789A") != (int)strtol(s, NULL, 11) &&
      errno != ERANGE) {
    printf("atoi_base 11의 각 결과를 비교한 결과가 다름: \"%s\"\n", s);
    return false;
  }
  return true;
}

bool test_atoi_base(void) {
  bool success = true;
  for (const char **sample = sample_vector; *sample; sample++) {
    success &= compare_atoi_base(*sample);
  }
  if (ft_atoi_base("42", "") != 0) {
    printf("0진수 오류 발생하지 않음\n");
    return false;
  }
  if (ft_atoi_base("42", "0") != 0) {
    printf("1진수 오류 발생하지 않음\n");
    return false;
  }
  if (ft_atoi_base("42", "01234567890") != 0) {
    printf("중복 base 문자 오류 발생하지 않음\n");
    return false;
  }
  if (ft_atoi_base("42", "+123456789") != 0) {
    printf("유효하지 않은 base 문자 오류 발생하지 않음\n");
    return false;
  }
  return success;
}

int uncond_return_equals(const void *data1, const void *data2) {
  (void)data1, (void)data2;
  return 0;
}

void free_print(void *data) { printf("free elem %p\n", data); }

bool test_list(void) {
  t_list *list = NULL;
  ft_list_sort(&list, NULL);
  if (ft_list_remove_if(&list, NULL, &uncond_return_equals, &free_print) != 0) {
    printf("리스트에서 삭제된 노드의 개수가 예상과 다름 (0)\n");
    return false;
  }
  if (ft_list_size(list) != 0) {
    printf("리스트 길이가 예상과 다름 (0)\n");
    return false;
  }
  for (size_t i = 0; i < 42; i++) {
    ft_list_push_front(&list, (void *)i);
  }
  if (ft_list_size(list) != 42) {
    printf("리스트 길이가 예상과 다름 (42)\n");
    return false;
  }
  if (ft_list_remove_if(&list, (void *)21, NULL, &free_print) != 1) {
    printf("리스트에서 삭제된 노드의 개수가 예상과 다름 (1)\n");
    return false;
  }
  if (ft_list_size(list) != 41) {
    printf("리스트 길이가 예상과 다름 (41)\n");
    return false;
  }
  ft_list_sort(&list, NULL);
  if (ft_list_remove_if(&list, (void *)41, NULL, &free_print) != 1) {
    printf("리스트에서 삭제된 노드의 개수가 예상과 다름 (1)\n");
    return false;
  }
  if (ft_list_size(list) != 40) {
    printf("리스트 길이가 예상과 다름 (40)\n");
    return false;
  }
  if (ft_list_remove_if(&list, NULL, &uncond_return_equals, NULL) != 40) {
    printf("리스트에서 삭제된 노드의 개수가 예상과 다름 (40)\n");
    return false;
  }
  if (list != NULL) {
    printf("리스트의 상태가 예상과 다름 (NULL)\n");
    return false;
  }
  return true;
}

int main(int argc, char *argv[]) {
  (void)argc, (void)argv;

  bool success = true;

  success &= test_strlen();
  success &= test_strcpy();
  success &= test_strcmp();
  success &= test_write();
  success &= test_read();
  success &= test_strdup();

  success &= test_atoi_base();
  success &= test_list();

  return success ? EXIT_SUCCESS : EXIT_FAILURE;
}
