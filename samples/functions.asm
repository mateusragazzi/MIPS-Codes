	.text
	
function_a: 	addi $sp, $sp, -8	# allocate 3 word in stack
		jal function_b
		addi $sp, $sp, 4	# free memory, deleting function_a from stack
		addi $v0, $zero, 10	# Chamada ao sistema para encerrar programa
		syscall	

function_c:	sw $ra, 4 ($sp)		# save function_b return
		lw $ra, 4 ($sp)		# read function_b return
		jr $ra			# return to B
		
function_b:	sw $ra, 0 ($sp)		# save function_a return
		jal function_c
		
		lw $ra, 0 ($sp)		# get return addres
		addi $sp, $sp, 4	# free memory, deleting function_b from stack
		jr $ra			# return to A

	.data
		
