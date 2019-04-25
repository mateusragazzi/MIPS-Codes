	.text
	addi $t0, $zero, 0 # i = 0
	addi $t7, $zero, 10 # max = 10
	
for:    slt $t1, $t0, $t7 # condition (step 1)
	beq $t1, $zero, endfor  # condition (step 2)
	# put your code here
	li  $v0, 1           # load service to print an integer
	add $a0, $t0, $zero  # load value to register $a
	syscall
	# end of code	
	addi $t0, $t0, 1 # i++
	j for # return to loop structure
endfor: # end of program
	.data