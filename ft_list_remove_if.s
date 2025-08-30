; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;    ft_list_                                 .s     :+:      :+:    :+:       ;
;                                 _  __             +:+ +:+         +:+         ;
;     _ _ ___ _ __  _____ _____  (_)/ _|          +#+  +:+       +#+            ;
;    | '_/ -_) '  \/ _ \ V / -_) | |  _|        +#+#+#+#+#+   +#+               ;
;    |_| \___|_|_|_\___/\_/\___|_|_|_|               #+#    #+#                 ;
;                             |___|                 ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "def-list.inc"

extern free

section .text

struc _locals
    .free_data: resq 1 ; t_list_free_data
endstruc

; size_t ft_list_remove_if(t_list** begin_list_ptr, void* data_ref, t_list_cmp_data cmp, t_list_free_data free_data);
global ft_list_remove_if
ft_list_remove_if:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    ; RDX: 세 번째 인자
    ; RCX: 네 번째 인자

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
    lea rax, [rel .default_cmp]
    test rdx, rdx
    cmovz rdx, rax

    ; free_data ??= .default_free_data
    lea rax, [rel .default_free_data]
    test rcx, rcx
    cmovz rcx, rax

    xor rbx, rbx ; local (size_t) remove_count
    mov [rbp - _locals_size + _locals.free_data], rcx ; free_data
    mov r12, rdi ; local (t_list**) prev_next = begin_list_ptr
    ; r13: local (t_list*) curr = *begin_list_ptr
    mov r14, rsi ; data_ref
    mov r15, rdx ; cmp

.loop:
    ; curr = *prev_next
    mov r13, [r12]

    test r13, r13
    jz .loop_end

    ; cmp(R13->data, data_ref)
    mov rdi, [r13 + t_list.data]
    mov rsi, r14
    call r15
    test rax, rax
    jz .equal

    ; prev_next = &curr->next
    lea r12, [r13 + t_list.next]

    jmp .loop

.equal:
    ; free_data(curr->data)
    mov rdi, [r13 + t_list.data]
    mov rax, [rbp - _locals_size + _locals.free_data]
    call rax

    ; *prev_next = curr->next
    mov rax, [r13 + t_list.next]
    mov [r12], rax

    ; free(curr)
    mov rdi, r13
    call free wrt ..plt

    ; remove_count++
    inc rbx
    jmp .loop

.loop_end:
    mov rax, rbx

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
