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

section .rodata

isspace_map:
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

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

    ; RDX = nptr
    mov rdx, rdi

    ; R8 = base
    mov r8, rsi

    ; R9 = strlen(base)
    mov rdi, r8
    mov rcx, -1
    xor rax, rax
    repne scasb
    not rcx
    lea r9, [rcx - 1]

    ; BEGIN assert base
    cmp r9, 1
    jbe .error_return

    xor rsi, rsi
.find_duplicate_base_loop:
    movzx rax, BYTE [r8 + rsi]

    cmp al, 43 ; '+'
    je .error_return

    cmp al, 45 ; '-'
    je .error_return

    ; mov cl, BYTE [rel isspace_map + rax]
    lea rcx, [rel isspace_map]
    mov cl, BYTE [rcx + rax]
    test cl, cl
    jnz .error_return

    lea rdi, [rsi + 1]
.find_duplicate_base_loop.loop:
    cmp al, BYTE [r8 + rdi]
    je .error_return

    inc rdi
    cmp rdi, r9
    jb .find_duplicate_base_loop.loop
; .find_duplicate_base_loop.loop_end:

    inc rsi
    cmp rsi, r9
    jb .find_duplicate_base_loop
; .find_duplicate_base_loop_end:
    ; END assert base

    ; BEGIN parse sign
.skip_space_loop:
    movzx rax, BYTE [rdx]

    ; mov cl, BYTE [rel isspace_map + rax]
    lea rcx, [rel isspace_map]
    mov cl, BYTE [rcx + rax]
    test cl, cl
    jz .skip_space_loop_end

    inc rdx
    jmp .skip_space_loop
.skip_space_loop_end:

    ; R10: sign_bit
    xor r10, r10
.decode_sign_loop:
    movzx rax, BYTE [rdx]

    cmp al, 43 ; '+'
    je .decode_sign_loop.branch_positive

    cmp al, 45 ; '-'
    jne .decode_sign_loop_end

; .decode_sign_loop.branch_negative:
    xor r10, 1

.decode_sign_loop.branch_positive:
    inc rdx
    jmp .decode_sign_loop

.decode_sign_loop_end:
    ; END parse sign

    ; sign = 1 - (sign_bit << 1)
    lea r10, [2 * r10 - 1]
    neg r10

    ; number = 0
    xor r11, r11

.decode_number_loop:
    ; BEGIN RAX = R10 * (index_of(base, [RDX]))
    movzx rax, BYTE [rdx]

    test rax, rax
    jz .decode_number_loop_end

    lea rcx, [r9 + 1]
    mov rdi, r8
    repne scasb

    ; index_of(base, [RDX]) 실패
    test rcx, rcx
    jz .decode_number_loop_end

    mov rax, r9
    sub rax, rcx

    imul rax, r10
    ; END ...

    ; R11 = R9 * R11 + RAX
    imul r11, r9
    add r11, rax

    inc rdx
    jmp .decode_number_loop

.decode_number_loop_end:
    mov rax, r11

.return:
    ; 에필로그
    leave
    ret

.error_return:
    xor rax, rax
    jmp .return

%include "_note.inc"
