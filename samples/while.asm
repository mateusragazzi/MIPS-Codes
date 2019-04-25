	.text
	
	addi $t0, $zero, 0 # i = 0
	addi $t7, $zero, 10 # max = 10
	
while:  slt $t1, $t0, $t7
	beq $t1, $zero, fimloop
	# put your code here
	li  $v0, 1           # load service to print an integer
	add $a0, $t0, $zero  # load value to register $a
	syscall
	# end of code	
	addi $t0, $t0, 1 # i++
	j while
fimloop:
	.data
	