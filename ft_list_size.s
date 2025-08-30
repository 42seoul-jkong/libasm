; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;    ft_list_                                 .s     :+:      :+:    :+:       ;
;         _                                        +:+ +:+         +:+         ;
;     ___(_)_______                              +#+  +:+       +#+            ;
;    / __| |_  / _ \                           +#+#+#+#+#+   +#+               ;
;    \__ \ |/ /  __/                                #+#    #+#                 ;
;    |___/_/___\___|                               ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "def-list.inc"

section .text

; size_t ft_list_size(const t_list* begin_list);
global ft_list_size
ft_list_size:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자

    xor rax, rax
.loop:
    test rdi, rdi
    jz .return
    mov rdi, [rdi + t_list.next]
    inc rax
    jmp .loop

.return:
    ; 에필로그
    pop rbp
    ret

%include "_note.inc"
