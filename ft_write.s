; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;                       _ _                           :+:      :+:    :+:       ;
;        __      ___ __(_) |_ ___   ___             +:+ +:+         +:+         ;
;        \ \ /\ / / '__| | __/ _ \ / __|          +#+  +:+       +#+            ;
;         \ V  V /| |  | | ||  __/_\__ \        +#+#+#+#+#+   +#+               ;
;     ft_  \_/\_/ |_|  |_|\__\___(_)___/             #+#    #+#                 ;
;                                                  ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "_syscall.inc"

section .text

; ssize_t ft_write(int fd, const void* buf, size_t count);
global ft_write
ft_write:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    ; RDX: 세 번째 인자

    mov rax, SYS_WRITE
    syscall
    test rax, rax
    js .error

.return:
    ; 에필로그
    pop rbp
    ret

.error:
    ; errno
    mov rcx, rax
    neg rcx
    ; call의 push-ret-addr, 프롤로그의 push rbp로 인한 스택 16바이트 align 상태
    call ERRNO_LOCATION
    mov [rax], rcx
    mov rax, -1
    jmp .return

%include "_note.inc"
