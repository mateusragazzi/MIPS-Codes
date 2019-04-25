.text
    addi $t1, $zero, 3 # A
    addi $t2, $zero, 1 # B
    slt $t4, $t1, $t2        # < = 1
    beq $t4, $zero, else
    addi $t3, $zero, 2 
    j endif
else: addi $t3, $zero, 3    
endif:      
    li  $v0, 1           # service 1 is print integer
    add $a0, $t3, $zero  # load desired value into argument register $a0, using pseudo-op
    syscall
.data

