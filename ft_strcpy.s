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

; char* ft_strcpy(char* dst, const char* src);
global ft_strcpy
ft_strcpy:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자

    ; 아래 String 명령에서 RAX와 RDI를 destructive하게 사용하므로 RDX에 보존
    mov rdx, rdi

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

.loop:
    ; lodsb
    ;  LOaD String Byte
    ;  if (DF == 0) AL = [RSI++]
    ;  else AL = [RSI--]
    lodsb
    ; stosb
    ;  STOre String Byte
    ;  if (DF == 0) [RDI++] = AL
    ;  else [RDI--] = AL
    stosb
    test al, al
    jnz .loop

    ; RAX: 반환값 = RDX (첫 번째 인자)
    mov rax, rdx

    ; 에필로그
    leave
    ret

%include "_note.inc"
