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

extern __errno_location

section .text

; ssize_t ft_write(int fd, const void* buf, size_t count);
global ft_write
ft_write:
    ; 프롤로그
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    ; RDX: 세 번째 인자

    ; SYS_WRITE = 1
    mov rax, 1
    syscall
    test rax, rax
    js .error

.return:
    ; 에필로그
    ret

.error:
    ; errno
    mov rcx, rax
    neg rcx
    call __errno_location
    mov [rax], rcx
    mov rax, -1
    jmp .return
