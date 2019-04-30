	.text
	# $s0 (limite), $s1 (end incial vet), $s2 (var trocou), $s3 (i - for)
	# $t0 (end memo vet(i)), $t1 (condicoes (limite e vetores)), $t2 (end memo vet(i+1)), $t3 (vet[i]), $t4 (vet[i + 1])

	la $s1, vetor			# $s1 = endereço inicial de vetor na memória
	la $s0, n			# $t7 = endereço de n
	lw $s0, 0 ($s0)	 		# lê o tamanho do vetor
	subi $s0, $s0, 1		# limite = n - 1

	#while
	addi $s2, $zero, 1 		 # trocou = 1 (true)
while:  slt $t1, $s0, $zero 		 # limite($s0) < 0 =  ( true ($t1): 1, false ($t1): 0  )
	bne $t1, $zero, fimloop 	 # limite < 0 false,    fimloop
	beq $s2, $zero, fimloop 	 # trocou($s2) == zero, fimloop
	
	add $s2, $zero, $zero		 # trocou = false	
	
	#for
	addi $s3, $zero, 0 # i = 0
for:    slt $t3, $s3, $s0 # i($s3) < limite($s0)
	beq $t3, $zero, endfor  # testa condicao
		#vetor[i]
		sll $t3, $s3, 2		# $t3 = 4 * i
		add $t0, $s1, $t3	# $t0 = $t1 + (4 * i)
		lw $t3, 0 ($t0)		# $t3 = vet[$t0] -> $t3 = vet[i]
		#vetor[i+1]
		addi $t7, $s3, 1
		sll $t4, $t7, 2		# $t4 = 4 * (i + 1)
		add $t2, $s1, $t4	# $t4 = $t1 + (4 * i)
		lw $t4, 0 ($t2)		# $t4 = vet[$t2] -> $t4 = vet[i]
			#if
			slt $t1, $t4, $t3	# vetor[i] > vetor[i+1] # vetor[i+1]  <= vetor[i] 
			beq $t1, $zero, fimif	#
				#metodo troca
				#add $a0, $zero, $t0	# parametro 1: end memo de vet(i)
				#add $a1, $zero, $t2	# parametro 2: end memo de vet(i + 1)
				#j troca
				######## Dentro de troca  ########
				#substituir $t0 por $a0
				lw $t3, 0 ($t0)		# $t3 = vet[$t0] -> $t3 = vet[i]
				#substituir $t2 por $a1
				lw $t4, 0 ($t2)		# $t4 = vet[$t2] -> $t4 = vet[i + 1]
	
				sw $t4, ($t0)		# vet[i] = $t4
				sw $t3, ($t2)		# vet[i + 1] = $t3	

				addi $s2, $zero, 1	# trocou = true
				######## fim de troca  ########
		
			fimif:
			addi $s3, $s3, 1 # i++
			j for # return to for structure
	endfor: 
		subi $s0, $s0, 1 # limite--
	j while
fimloop:
        la $t1, vetor		# $t1 = endereço inicial de vetor na memória
	la $t7, n		# $t7 = endereço de n
	
	addi $t0, $zero, 0	# i = 0
	lw $t7, ($t7) 		# lê o tamanho do vetor			
for2:    slt $t2, $t0, $t7	# condition (step 1)
	beq $t2, $zero, endfor2  # condition (step 2)
	# put your code here

	sll $t3, $t0, 2		# $t3 = 4 * i
	add $t3, $t1, $t3	# $t3 = $t1 + (4 * i)
	lw $t4, 0 ($t3)		# $t3 = vet[$t1]
			
	li  $v0, 1          	# load service to print an integer
	add $a0, $t4, $zero  	# load value to register $a
	syscall
	# end of code	
	addi $t0, $t0, 1 # i++
	j for2 # return to loop structure
endfor2: # end of program
	.data
n:	.word 16
vetor:	.word 9 1 10 2 9 6 13 15 13 0 12 5 6 0 5 7
