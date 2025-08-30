; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;             _           _                          :+:      :+:    :+:       ;
;         ___| |_ _ __ __| |_   _ _ __   ___       +:+ +:+         +:+         ;
;        / __| __| '__/ _` | | | | '_ \ / __|    +#+  +:+       +#+            ;
;        \__ \ |_| | | (_| | |_| | |_) |\__ \  +#+#+#+#+#+   +#+               ;
;     ft_|___/\__|_|  \__,_|\__,_| .__(_)___/       #+#    #+#                 ;
;                                |_|               ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

extern malloc

section .text

; char* ft_strdup(const char* s);
global ft_strdup
ft_strdup:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; RBX = RDI
    mov rbx, rdi
    ; RCX = strlen(RDI) + 1
    mov rcx, -1
    xor rax, rax
    repne scasb
    not rcx

    ; malloc(RCX)
    mov rdi, rcx
    call malloc
    test rax, rax
    jz .error_nomem

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; CX = strlen + 1, SI = 첫 번째 인자, DI = malloc의 반환값
    mov rcx, rdi
    mov rsi, rbx
    mov rdi, rax
    ; RBX = RAX: malloc의 반환값
    mov rbx, rax
    ; movsb
    ;  MOVe String Byte
    ;  mov [RDI++], [RSI++]
    ; rep prefix
    ;  REPeat
    ;  CX: repeat Count
    ;  while (CX-- == 0)
    rep movsb
    ; RAX: 반환값 = RBX: malloc의 반환값
    mov rax, rbx

.return:
    ; 에필로그
    pop rbp
    ret

.error_nomem:
    ; malloc에 의하여, RAX == 0, errno == ENOMEM
    jmp .return

%include "_note.inc"
