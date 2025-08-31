; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;    ft_                                      .s     :+:      :+:    :+:       ;
;           _       _   _                          +:+ +:+         +:+         ;
;      __ _| |_ ___(_) | |__  __ _ ___ ___       +#+  +:+       +#+            ;
;     / _` |  _/ _ \ | | '_ \/ _` (_-</ -_)    +#+#+#+#+#+   +#+               ;
;     \__,_|\__\___/_|_|_.__/\__,_/__/\___|         #+#    #+#                 ;
;                   |___|                          ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

;TODO: Not implemented yet

section .text

; int ft_atoi_base(const char* nptr, const char* base);
global ft_atoi_base
ft_atoi_base:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; R8 = s
    mov r8, rdi
    ; R9 = strlen(s) + 1
    mov rcx, -1
    xor rax, rax
    repne scasb
    not rcx
    mov r9, rcx

.return:
    ; 에필로그
    leave
    ret

%include "_note.inc"
