; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;             _        _                             :+:      :+:    :+:       ;
;         ___| |_ _ __| | ___ _ __    ___          +:+ +:+         +:+         ;
;        / __| __| '__| |/ _ \ '_ \  / __|       +#+  +:+       +#+            ;
;        \__ \ |_| |  | |  __/ | | |_\__ \     +#+#+#+#+#+   +#+               ;
;     ft_|___/\__|_|  |_|\___|_| |_(_)___/          #+#    #+#                 ;
;                                                  ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

section .text

; size_t ft_strlen(const char* s);
global ft_strlen
ft_strlen:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; CX = ~0, AL = 0
    mov rcx, -1
    xor rax, rax
    ; scasb
    ;  SCAn String Byte
    ;  cmp AL, [RDI++]
    ; repne prefix
    ;  REPeat Not Equal
    ;  CX: repeat Count
    ;  while (CX-- == 0 && !ZF)
    repne scasb

    ; RAX: 반환값 = ~RCX - 1 = -(RCX + 1) - 1
    not rcx
    lea rax, [rcx - 1]

    ; 에필로그
    leave
    ret

%include "_note.inc"
