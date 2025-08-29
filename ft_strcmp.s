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
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    push rdi
    push rsi

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

.loop:
    mov cl, [rsi]
    mov dl, [rdi]
    ; cmpsb
    ;  CoMPare String Byte
    ;  if (DF == 0) cmp [RSI++], [RDI++]
    ;  else cmp [RSI--], [RDI--]
    cmpsb
    jne .not_equals
    test cl, cl
    jnz .loop

    ; RAX: 반환값 = 0
    xor rax, rax
    jmp .return

.not_equals:
    ; RAX: 반환값 = DL - CL
    movzx rax, dl
    sub rax, cl

.return:
    ; 에필로그
    pop rsi
    pop rdi
    ret
