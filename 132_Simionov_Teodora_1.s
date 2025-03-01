.data
    n: .long 0
    nr: .long 0
    d: .space 1
    pr: .long 0
    i: .long 0
    j: .long 0
    dif: .long 0
    i1: .long 0
    i2: .long 0
    j1: .long 0
    j2: .long 0
    index: .long 64
    jrem: .long 0
    jactual: .long 0
    ult: .long 0
    size: .space 4
    rem_size: .space 4
    instr: .space 4
    memory: .zero 1048576
    formatString: .asciz "%ld"
    byteformatString: .asciz "%d"
    addOutput: .asciz "%d: ((%d, %d), (%d, %d))\n"
    getOutput: .asciz "((%d, %d), (%d, %d))\n"
    noSpaceMsg: .asciz "%d: ((0, 0), (0, 0))\n"
    nothing: .asciz "((0, 0), (0, 0))\n"
    debugMsg2: .asciz "%d "
    newLine: .asciz "\n"

    
.text
    FADD:
        lea memory, %edi 
        ;// citeste nr
        pushl $nr
        pushl $formatString
        call scanf
        addl $8, %esp
        LOOP_ADD:
            movl nr, %eax
            cmpl $0, %eax
            je fexit

            pushl $d
            pushl $byteformatString
            call scanf
            popl %ebx
            popl %ebx

            pushl $size
            pushl $formatString
            call scanf
            popl %ebx
            popl %ebx

            subl $1, nr
            

            xorl %edx, %edx
            movl size, %eax
            addl $7, %eax
            movl $8, %ecx
            divl %ecx

            movl %eax, size

            movl $-1,i
        i_loop:
            addl $1, i
            movl i, %eax
            cmp $1024, %eax
            je afisare_nimic
            movl $0, j1
            movl $0, j2
            movl $-1, j
            j_loop:
                addl $1, j
                movl j,%eax
                cmpl $1024, %eax
                jae i_loop
                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %edx, %edx
                movb (%edi,%eax,1), %dl
                cmp $0, %edx
                jne j_loop
            j1_atr:
                movl j, %eax
                movl %eax, j1
            j2_loop:
                addl $1, j
                movl j,%eax
                cmp $1024, %eax
                je j2_atr

                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %edx, %edx
                movb (%edi,%eax,1), %dl
                cmp $0, %edx
                je j2_loop
            j2_atr:
                subl $1, j
                movl j, %eax
                movl %eax, j2
            space_check:
                addl $1, %eax
                subl j1, %eax
                movl %eax, dif

                cmp %eax, size
                ja j_loop
            
                movl j1, %ecx
                addl size, %ecx
                movl %ecx, ult
                movl j1, %ecx
            add_loop:
                cmp ult, %ecx
                je afisare
                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl %ecx, %eax

                xorl %edx, %edx
                movb d, %dl
                movb %dl, (%edi, %eax, 1)
                addl $1, %ecx
                jmp add_loop    
            afisare:
                subl $1, ult
                pushl ult
                pushl i
                pushl j1
                pushl i
                xorl %eax,%eax
                movb d, %al
                pushl %eax
                pushl $addOutput
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx

                pushl $0
                call fflush
                popl %ebx

                jmp LOOP_ADD
            afisare_nimic:
                pushl d
                pushl $noSpaceMsg
                call printf
                popl %ebx
                popl %ebx

                pushl $0
                call fflush
                popl %ebx
                jmp LOOP_ADD
        fexit:
            ret
    FGET:
        lea memory, %edi 
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx

        xorl %edx, %edx
        movb d, %dl

        movl $-1,i
        movl $0, j1
        movl $0, j2
        line_loop:
            addl $1, i
            movl i, %eax
            cmpl $1024, %eax
            je afisare_nimic_get
            movl $-1,j
            j_loop_get:
                addl $1, j
                movl j, %eax
                cmpl $1024, %eax
                je line_loop
                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %ebx, %ebx
                movb (%edi, %eax, 1),%bl

                xorl %edx, %edx
                movb d, %dl

                cmpl %edx, %ebx
                jne j_loop_get

                movl j, %eax
                movl %eax,j1
            j2_loop_get:
                addl $1, j
                movl j, %eax
                cmpl $1024, %eax
                je afisareget
                movl $1024, %eax
                movl i, %ecx
                mul %ecx
                addl j, %eax

                xorl %ecx, %ecx
                movb (%edi, %eax, 1),%cl

                xorl %edx, %edx
                movb d, %dl

                cmpl %ecx, %edx
                je j2_loop_get 
            afisareget:
                movl j, %eax
                subl $1, %eax
                movl %eax, j2

                pushl j2
                pushl i
                pushl j1
                pushl i
                pushl $getOutput
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx

                jmp getexit
            afisare_nimic_get:
                pushl $nothing
                call printf
                popl %ebx

                pushl $0
                call fflush
                popl %ebx
        getexit:
            ret
    FDELETE:
        lea memory, %edi 
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx
        xorl %edx,%edx
        movb d, %dl
        movl $-1, i
        del_line_loop:
            addl $1, i
            movl i, %ecx
            cmp $1048576, %ecx
            je afisare_mem
            xorl %ebx, %ebx
            movb (%edi, %ecx, 1), %bl
            cmpl %edx, %ebx
            je delete_loop
            jmp del_line_loop
        delete_loop:
            xorl %eax, %eax
            xorl %ebx, %ebx
            movb (%edi, %ecx, 1), %bl
            cmpl %edx, %ebx
            jne afisare_mem
            cmpl $1048576, %ecx
            je afisare_mem
            xorl %ebx, %ebx
            movb $0, (%edi, %ecx, 1)
            addl $1, %ecx
            jmp delete_loop
        afisare_mem:
            movl $-1, i
            mem_loop_i:
                addl $1, i
                movl i, %eax
                cmpl $1024, %eax
                je delexit
                movl $-1,j
                dif_0:
                    addl $1, j
                    movl j, %eax
                    
                    cmpl $1024, %eax
                    je mem_loop_i
                    movl $1024, %eax
                    movl i, %ebx
                    mul %ebx
                    addl j, %eax

                    xorl %ebx, %ebx
                    movb (%edi, %eax, 1),%bl

                    cmpl $0, %ebx
                    je dif_0

                    movl j, %eax
                    movl %eax,j1
                j2_find:
                    addl $1, j
                    movl j, %eax
                    cmpl $1024, %eax
                    je mem_afis
                    movl $1024, %eax
                    movl i, %ecx
                    mul %ecx
                    addl j, %eax

                    xorl %ecx, %ecx
                    movb (%edi, %eax, 1),%cl

                    cmpl %ecx, %ebx
                    je j2_find
                mem_afis:
                    subl $1, j
                    movl j, %eax
                    movl %eax, j2

                    pushl j2
                    pushl i
                    pushl j1
                    pushl i
                    pushl %ebx
                    pushl $addOutput
                    call printf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    popl %ebx

                    lea memory, %edi

                    jmp dif_0
        delexit:
            ret
    FDEFRAGMENTATION:
        movl $-1, i
        defr_i:
            addl $1, i
            movl i, %eax
            cmpl $1024, %eax
            je defafis
            movl $0, %ecx
            movl $0, j
            defr_j:
                cmpl $1024, j
                je rest

                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl j, %eax

                xorl %ebx, %ebx
                movb (%edi,%eax,1), %bl

                cmpl $0, %ebx
                je defr

                movl $1024, %eax
                movl i, %edx
                mul %edx
                addl %ecx, %eax

                movb %bl, (%edi,%eax,1)
                addl $1, %ecx
            defr:
                addl $1, j
                jmp defr_j
            rest:
                cmpl $0, %ecx
                je comp_lines
                cmpl $1024, %ecx
                je comp_lines

                movl $1024, %eax
                movl i, %ebx
                mul %ebx
                addl %ecx, %eax

                movb $0, (%edi,%eax,1)
                addl $1, %ecx
                jmp rest
            comp_lines:
                movl i, %eax
                movl %eax, i1
                multiple_lines:
                    addl $1, i1
                    cmpl $1024,i1
                    je defr_i
                    movl $0, size
                    movl $-1, j
                rest_size:
                    movl $-1,j2
                    j_blocks:
                        addl $1, j2
                        movl j2, %eax
                        cmpl $1024, %eax
                        je defr_i

                        movl $1024, %eax
                        movl i, %ecx
                        mul %ecx
                        addl j2, %eax

                        xorl %edx, %edx
                        movb (%edi, %eax, 1),%dl

                        cmpl $0, %edx
                        jne j_blocks

                        movl j2, %eax
                        movl %eax,j1
                    blocksret:
                        movl $1024, %eax
                        subl j1, %eax
                        movl %eax, rem_size
                        movl j1, %eax
                        movl %eax, jrem
                
                        movl $-1, j
                    c_size:
                        addl $1, j
                        cmpl $1024, j
                        je multiple_lines
                    
                        movl $1024, %eax
                        movl i1, %ebx
                        mul %ebx
                        addl j, %eax

                        xorl %ebx, %ebx
                        movb (%edi, %eax, 1),%bl

                        cmpl $0, %ebx
                        je c_size

                        movl j, %eax
                        movl %eax, j1
                        j2_blocks2:
                            addl $1, j
                            movl j, %eax
                            cmpl $1024, %eax
                            jae blocksret2

                            movl $1024, %eax
                            movl i1, %ecx
                            mul %ecx
                            addl j, %eax

                            cmpl $1048576, %eax       
                            jae blocksret2

                            xorl %ecx, %ecx
                            movb (%edi, %eax, 1),%cl

                            cmpl %ecx, %ebx
                            je j2_blocks2
                        blocksret2:
                            movl j, %eax
                            subl j1, %eax
                            mov j1, %ebx
                            mov %ebx, jactual
                            movl %eax, size

                            cmpl rem_size, %eax
                            jg defr_i
                put_defr:
                    movl $1024, %eax
                    movl i, %ebx
                    mul %ebx
                    addl jrem, %eax
                    movl %eax, j1

                    movl $1024, %eax
                    movl i1, %ebx
                    mul %ebx
                    addl jactual, %eax
                    movl %eax, j2

                    movl j1, %ecx
                    movl j2, %ebx
                move_line:
                    movl size, %eax
                    cmpl $0, %eax
                    je rest_size

                    xorl %edx, %edx
                    movb (%edi,%ebx,1), %dl
                    movb %dl,(%edi,%ecx,1)
                    movb $0,(%edi,%ebx,1)

                    addl $1, %ecx
                    addl $1, %ebx
                    subl $1, size
                    jmp move_line
            defafis:
                movl $0, %ebx
                movl $0, %ecx
                movl $0, j1
                movl $0, j2
                movl $-1, i
                defr_mem_loop_i:
                    addl $1, i
                    movl i, %eax
                    cmpl $1024, %eax
                    je defrexit
                    movl $-1,j
                defr_dif_0:
                    addl $1, j
                    movl j, %eax
                    
                    cmpl $1024, %eax
                    jae defr_mem_loop_i
                    movl $1024, %eax
                    movl i, %ebx
                    mul %ebx
                    addl j, %eax

                    xorl %ebx, %ebx
                    movb (%edi, %eax, 1),%bl

                    cmpl $0, %ebx
                    je defr_dif_0

                    movl j, %eax
                    movl %eax,j1
                defr_j2_find:
                    addl $1, j
                    movl j, %eax
                    cmpl $1024, %eax
                    je defr_mem_afis
                    movl $1024, %eax
                    movl i, %ecx
                    mul %ecx
                    addl j, %eax

                    xorl %ecx, %ecx
                    movb (%edi, %eax, 1),%cl

                    cmpl %ecx, %ebx
                    je defr_j2_find
                defr_mem_afis:
                    subl $1, j
                    movl j, %eax
                    movl %eax, j2

                    pushl j2
                    pushl i
                    pushl j1
                    pushl i
                    pushl %ebx
                    pushl $addOutput
                    call printf
                    addl $24, %esp

                    lea memory, %edi
                    jmp defr_dif_0
        defrexit:
            ret

.global main
main:
    pushl $n
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    lea memory, %edi
instructiuni:
    movl n, %eax
    cmpl $0, %eax
    je  etexit 

    subl $1, n

    pushl $instr
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    cmpl $1, instr 
    je ADD

    cmpl $2, instr
    je GET

    cmpl $3, instr
    je DELETE

    cmpl $4, instr
    je DEFRAGMENTATION

ADD:
    call FADD
    jmp instructiuni
GET:
    call FGET
    jmp instructiuni
DELETE:
    call FDELETE
    jmp instructiuni
DEFRAGMENTATION:
    call FDEFRAGMENTATION
    jmp instructiuni
etexit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
