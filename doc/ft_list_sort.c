#define NULL 0

typedef struct s_list {
    void* data;
    struct s_list* next;
} t_list;

void ft_list_sort(t_list** begin_list_ptr, int (*cmp)(const void*, const void*)) {
    t_list* sorted_list = NULL; // 스택에 배치
    t_list* unsorted_curr = *begin_list_ptr;

    while (unsorted_curr != NULL) {
        // default value: first of sorted_list
        t_list** sorted_prev_next = &sorted_list;
        if (sorted_list != NULL && cmp(sorted_list->data, unsorted_curr->data) < 0) {
            // find position in sorted_list last less elem
            t_list* sorted_prev = sorted_list;
            while (sorted_prev->next != NULL && cmp(sorted_prev->next->data, unsorted_curr->data) < 0) {
                sorted_prev = sorted_prev->next;
            }
            sorted_prev_next = &sorted_prev->next;
        }

        // currently sorted elem
        t_list* curr = unsorted_curr;
        unsorted_curr = unsorted_curr->next;

        // push_front to sorted_curr (= sorted_prev_next)
        curr->next = *sorted_prev_next;
        *sorted_prev_next = curr;
    }

    *begin_list_ptr = sorted_list;
}

//TODO: iterative merge sort
