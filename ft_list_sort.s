; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;    ft_list_                                 .s     :+:      :+:    :+:       ;
;                    _                             +:+ +:+         +:+         ;
;     ___  ___  _ __| |_                         +#+  +:+       +#+            ;
;    / __|/ _ \| '__| __|                      +#+#+#+#+#+   +#+               ;
;    \__ \ (_) | |  | |_                            #+#    #+#                 ;
;    |___/\___/|_|   \__|                          ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "def-list.inc"

section .text

struc _locals
    .sorted_list: resq 1 ; t_list*
endstruc

; void ft_list_sort(t_list** begin_list_ptr, t_list_cmp_data cmp);
global ft_list_sort
ft_list_sort:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자

    ; begin_list_ptr == nullptr
    xor rax, rax
    test rdi, rdi
    jz .early_return

    sub rsp, _locals_size
    push rbx
    push r12
    push r13
    push r14
    push r15
    ; 16바이트 align 상태

    ; cmp ??= .default_cmp
    lea rdx, [rel .default_cmp]
    test rsi, rsi
    cmovz rsi, rdx

    ; RAX == 0 상태
    mov [rbp - _locals_size + _locals.sorted_list], rax ; local (t_list*) sorted_list = nullptr
    ; rbx:  [[temporary]] (t_list*) sorted_prev_next
    mov r12, rdi ; begin_list_ptr
    mov r13, rsi ; cmp
    mov r14, [rdi] ; local (t_list*) unsorted_curr = *begin_list_ptr
    ; r15: [[temporary]] (t_list*) sorted_prev

    ; R14 != nullptr
    test r14, r14
    jz .loop_end

.loop_content:
    ;NOTE: R14가 변경되었을 수 있음
    ; sorted_prev_next = &sorted_list
    lea rax, [rbp - _locals_size + _locals.sorted_list]

    ; R15 = sorted_prev
    mov r15, [rax]
    ; R15 != nullptr
    test r15, r15
    jz .loop.branch_end
    ; cmp(R15->data, R14->data) < 0
    mov rdi, [r15 + t_list.data]
    mov rsi, [r14 + t_list.data]
    call r13
    test rax, rax
    jns .loop.branch_end

; .loop.branch_if:
    ;NOTE: sorted_list의 less 위치 탐색

.loop.branch_if.loop:
    ; RBX = R15->next
    mov rbx, [r15 + t_list.next]
    ; RBX != nullptr
    test rbx, rbx
    jz .loop.branch_if.loop_end
    ; cmp(RBX->data, R14->data) < 0
    mov rdi, [rbx + t_list.data]
    mov rsi, [r14 + t_list.data]
    call r13
    test rax, rax
    jns .loop.branch_if.loop_end

    mov r15, [r15 + t_list.next]
    jmp .loop.branch_if.loop

.loop.branch_if.loop_end:
    ; sorted_prev_next = &sorted_prev->next
    lea rax, [r15 + t_list.next]

.loop.branch_end:
    ; RAX == sorted_prev_next

    ; RCX = unsorted_curr
    mov rcx, r14
    ; unsorted_curr = RCX->next
    mov r14, [rcx + t_list.next]

    mov rdx, [rax]
    ; RCX->next = *sorted_prev_next
    mov [rcx + t_list.next], rdx
    ; *sorted_prev_next = RCX
    mov [rax], rcx

    test r14, r14
    jnz .loop_content

.loop_end:
    ; *begin_list_ptr = sorted_list
    mov rax, [rbp - _locals_size + _locals.sorted_list]
    mov [r12], rax

.return:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
.early_return:
    ; 에필로그
    leave
    ret

.default_cmp:
    mov rax, rdi
    sub rax, rsi
.default_free_data:
    ret

%include "_note.inc"
