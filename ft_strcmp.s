; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;             _                                      :+:      :+:    :+:       ;
;         ___| |_ _ __ ___ _ __  _   _   ___       +:+ +:+         +:+         ;
;        / __| __| '__/ __| '_ \| | | | / __|    +#+  +:+       +#+            ;
;        \__ \ |_| | | (__| |_) | |_| |_\__ \  +#+#+#+#+#+   +#+               ;
;     ft_|___/\__|_|  \___| .__/ \__, (_)___/       #+#    #+#                 ;
;                         |_|    |___/             ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

section .text

; int ft_strcmp(const char* s1, const char* s2);
global ft_strcmp
ft_strcmp:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

.loop:
    mov cl, BYTE [rsi]
    mov dl, BYTE [rdi]
    ; cmpsb
    ;  CoMPare String Byte
    ;  if (DF == 0) cmp [RSI++], [RDI++]
    ;  else cmp [RSI--], [RDI--]
    cmpsb
    jne .not_equal
    test cl, cl
    jnz .loop

    ; RAX: 반환값 = 0
    xor rax, rax
    jmp .return

.not_equal:
    ; RAX: 반환값 = DL - CL
    movzx rax, dl
    movzx rcx, cl
    sub rax, rcx

.return:
    ; 에필로그
    leave
    ret

%include "_note.inc"
