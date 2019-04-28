	.text
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
	.data
n:	.word 16
vetor:	.word 9 1 10 2 6 13 15 0 12 5 7 14 4 3 11