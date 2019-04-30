	.text
	
	bubble_sort:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $5,44($fp)
        li      $2,1                        # 0x1
        sw      $2,24($fp)
        b       aaa
        nop
	
	la $t1, vetor		# $t1 = endereço inicial de vetor na memória
	la $t7, n		# $t7 = endereço de n
	
	addi $t0, $zero, 0	# i = 0
	lw $t7, ($t7) 		# lê o tamanho do vetor
	subi $t7, $t7, 1	# n = n - 1
			
for:    slt $t2, $t0, $t7	# condition (step 1)
	beq $t2, $zero, endfor  # condition (step 2)
	# put your code here

	sll $t3, $t0, 2		# $t3 = 4 * i
	add $t3, $t1, $t3	# $t3 = $t1 + (4 * i)
	lw $t4, 0 ($t3)		# $t3 = vet[$t1]
			
	li  $v0, 1          	# load service to print an integer
	add $a0, $t4, $zero  	# load value to register $a
	syscall
	# end of code	
	addi $t0, $t0, 1 # i++
	j for # return to loop structure
endfor: # end of program
	
bbb:
        sw      $0,28($fp)
        b       ccc
        nop

ddd:
        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        lw      $3,40($fp)
        nop
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sll     $2,$2,2
        lw      $4,40($fp)
        nop
        addu    $2,$4,$2
        lw      $2,0($2)
        nop
        slt     $2,$2,$3
        beq     $2,$0,eee
        nop

        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        lw      $3,40($fp)
        nop
        addu    $2,$3,$2
        lw      $4,0($2)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sll     $2,$2,2
        lw      $3,40($fp)
        nop
        addu    $2,$3,$2
        lw      $2,0($2)
        nop
        move    $5,$2
        jal     troca
        nop

eee:
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
ccc:
        lw      $2,44($fp)
        nop
        addiu   $3,$2,-1
        lw      $2,28($fp)
        nop
        slt     $2,$2,$3
        bne     $2,$0,ddd
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
aaa:
        lw      $3,24($fp)
        lw      $2,44($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,bbb
        nop

        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr       $ra
        nop

troca:
        addiu   $sp,$sp,-24
        sw      $fp,20($sp)
        move    $fp,$sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        lw      $2,24($fp)
        nop
        sw      $2,8($fp)
        lw      $2,28($fp)
        nop
        sw      $2,24($fp)
        lw      $2,8($fp)
        nop
        sw      $2,28($fp)
        nop
        move    $sp,$fp
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr       $ra
        nop
	
	
	
	.data
n: 	.word 16
vetor:	.word 9 1 10 2 6 13 15 0 12 5 7 14 4 3 11 8
#vetor:	.word 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
