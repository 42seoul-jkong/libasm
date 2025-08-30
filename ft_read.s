; **************************************************************************** ;
;                                                                              ;
;                                                      :::      ::::::::       ;
;                            _                       :+:      :+:    :+:       ;
;         _ __ ___  __ _  __| |  ___               +:+ +:+         +:+         ;
;        | '__/ _ \/ _` |/ _` | / __|            +#+  +:+       +#+            ;
;        | | |  __/ (_| | (_| |_\__ \          +#+#+#+#+#+   +#+               ;
;     ft_|_|  \___|\__,_|\__,_(_)___/               #+#    #+#                 ;
;                                                  ###   ########   seoul.kr   ;
;                                                                              ;
; **************************************************************************** ;

%include "_syscall.inc"

section .text

; ssize_t ft_read(int fd, void* buf, size_t count);
global ft_read
ft_read:
    ; 프롤로그
    push rbp
    mov rbp, rsp
    ; RDI: 첫 번째 인자
    ; RSI: 두 번째 인자
    ; RDX: 세 번째 인자

    mov rax, SYS_READ
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
    call ERRNO_LOCATION
    mov [rax], rcx
    mov rax, -1
    jmp .return

%include "_note.inc"
