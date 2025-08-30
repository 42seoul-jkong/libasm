; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;    ft_list_                                 .s     :+:      :+:    :+:       ;
;                  _       __             _        +:+ +:+         +:+         ;
;     _ __ _  _ __| |_    / _|_ _ ___ _ _| |_    +#+  +:+       +#+            ;
;    | '_ \ || (_-< ' \  |  _| '_/ _ \ ' \  _| +#+#+#+#+#+   +#+               ;
;    | .__/\_,_/__/_||_|_|_| |_| \___/_||_\__|      #+#    #+#                 ;
;    |_|              |___|                        ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "def-list.inc"

extern malloc

section .text

; t_list* ft_list_push_front(t_list** begin_list_ptr, void* data);
global ft_list_push_front
ft_list_push_front:
    ; 프롤로그
    push rbp
    mov rbp, rsp

    ; begin_list_ptr == nullptr
    xor rax, rax
    test rdi, rdi
    jz .early_return

    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    push r12
    push r13

    mov r12, rdi
    mov r13, rsi

    ; create_elem
    mov rdi, t_list_size
    call malloc wrt ..plt
    test rax, rax
    jz .error_nomem
    mov [rax + t_list.data], r13

    ; link
    mov r13, [r12]
    mov [rax + t_list.next], r13
    mov [r12], rax

.return:
    pop r13
    pop r12
.early_return:
    ; 에필로그
    leave
    ret

.error_nomem:
    jmp .return

%include "_note.inc"
