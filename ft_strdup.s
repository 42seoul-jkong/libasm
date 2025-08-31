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
    push r12
    push r13

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; R12 = s
    mov r12, rdi
    ; R13 = strlen(s) + 1
    mov rcx, -1
    xor rax, rax
    repne scasb
    not rcx
    mov r13, rcx

    ; malloc(R13)
    mov rdi, r13
    ; call의 push-ret-addr, 프롤로그의 push rbp, push r12, push r13으로 인한 스택 16바이트 align 상태
    call malloc wrt ..plt
    test rax, rax
    jz .error_nomem

    ; cld
    ;  CLear Direction flag (DF = 0)
    cld

    ; CX = R13, SI = R12, DI = malloc의 반환값
    mov rcx, r13
    mov rsi, r12
    mov rdi, rax
    ; RDX = RAX: malloc의 반환값
    mov rdx, rax
    ; movsb
    ;  MOVe String Byte
    ;  mov [RDI++], [RSI++]
    ; rep prefix
    ;  REPeat
    ;  CX: repeat Count
    ;  for (; CX == 0; CX--)
    rep movsb
    ; RAX: 반환값 = RDX: malloc의 반환값
    mov rax, rdx

.return:
    pop r13
    pop r12
    ; 에필로그
    leave
    ret

.error_nomem:
    ; malloc에 의하여, RAX == 0, errno == ENOMEM
    jmp .return

%include "_note.inc"
