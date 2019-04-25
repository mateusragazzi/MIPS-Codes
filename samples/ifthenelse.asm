	.text	
	addi $t0, $zero, 3 # A = 3
	addi $t1, $zero, 2 # B = 2	
	addi $t2, $zero, 1 # C = 1
	
	slt $t3, $t0, $t1
	beq $t3, $zero, elseif
	addi $t5, $zero, 3
	j endif
	
elseif: 	
	slt $t3, $t1, $t2 # B < C = C > B
	beq $t3, $zero, else # condition
	# code
	addi $t5, $zero, 1
	# end code
	j endif
else:
	# code
	addi $t5, $zero, 0
	# end code
endif:
	li  $v0, 1           # service 1 is print integer
	add $a0, $t5, $zero  # load desired value into argument register $a0, using pseudo-op
	syscall
	.data