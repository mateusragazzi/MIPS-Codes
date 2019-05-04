#------------------------------------------------------------------------------
# Programa BubleSort: ordenação pelo método da bolha
#------------------------------------------------------------------------------
# Para visualização correta do programa fonte, configure editor no MARS:
#		Ir em Settings -> Editor
#		Selecionar Tab Size = 3 (dar Apply and Close)
#------------------------------------------------------------------------------
# Para executar programa no MARS:
#		Ir em Settings -> Memory Configuration
#		Selecionar Default (dar Apply and Close)
#		Montar programa
#		Ir em Tools -> Bitmap display
#		Configurar display bitmap com:
#			Unit Width in Pixels: 32
#			Unit Height in Pixels: 32
#			Display Width in Pixels: 512
#			Display Height in Pixels: 64
#			Base address for display: ($gp)
#		Dar "Connect to MIPS"
#		Executar programa
#		Antes de executar de novo, dar "Reset"
#------------------------------------------------------------------------------
		.text	# Área de código
#------------------------------------------------------------------------------
# PROGRAMA PRINCIPAL
#		Ordena vetor pelo método BubbleSort
#		Mostra no dispaly bitmap, cores correspondentes aos elementos do vetor
#		Possui chamadas aninhadas de rotinas
# Algoritmo:
#		Imprime mensagem inicial
#		mostra_vetor()
#		trocou = true
#		limite = n-1
#		while (limite > 0) AND (trocou)
#			trocou = false
#			for (i = 0 ; i < limite ; i++)
#				if vetor[i] > vetor[i+1]
#					troca(&vetor[i], &vetor[i+1]) // Troca elementos vetor[i] e vetor[i+1]
#					trocou = true
#			mostra_vetor()
#			limite--
#		Encerra execução do programa
# Uso dos registradores:
#		$s0: limite
#		$s1: endereco inicial do vetor
#		$s2: trocou (boolean)
#		$s3: i - for
#		$s4: n
#		$t0: end memoria de vet[i]
#		$t1: condicoes
#		$t2: end memoria de vet[i + 1]
#		$t3: vet[i]
#		$t4: vet[i + 1]

		# Inicialização
main:		addi $v0, $zero, 4		# Chamada ao sistema para escrever string na tela
		la $a0, msg1			# $a0 = endereço da string a ser escrita na tela
		syscall
		
		addi $v0, $zero, 4		# Chamada ao sistema para escrever string na tela
		la $a0, msgN			# $a0 = endereço da string a ser escrita na tela
		syscall
		
		li $v0, 5			# chamada do sistema para ler um inteiro
		syscall				
		move $s4, $v0			# lê n - $s4 = n
		
		la $s1, vetor			# $s1 = endereço inicial do vetor
		
		jal ler_vetor

		addi $s0, $s4, -1		# limite = n - 1
		addi $s2, $zero, 1 		# trocou = 1 (true)
	
		jal mostra_vetor
	
	while:  slt $t1, $s0, $zero 		# n($s0) < 0 =  ( true ($t1): 1, false ($t1): 0  )
		bne $t1, $zero, fimloop 	# limite < 0 false,    fimloop
		beq $s2, $zero, fimloop 	# trocou($s2) == zero, fimloop
		add $s2, $zero, $zero		# trocou = false	
		addi $s3, $zero, 0		# i = 0
	for:    slt $t1, $s3, $s0 		# i($s3) < limite($s0)
		beq $t1, $zero, endfor  	# testa condicao
			#vetor[i]
			sll $t3, $s3, 2		# $t3 = 4 * i
			add $t0, $s1, $t3	# $t0 = $s1 + (4 * i)
			lw $t3, 0 ($t0)		# $t3 = vet[$t0] -> $t3 = vet[i]
			#vetor[i+1]
			addi $t4, $s3, 1	# $t4 = i + 1
			sll $t4, $t4, 2		# $t4 = 4 * $t4 (i + 1)
			add $t2, $s1, $t4	# $t2 = $s1 + (4 * (i + 1))
			lw $t4, 0 ($t2)		# $t4 = vet[$t2] -> $t4 = vet[i + 1]
				#if
				slt $t1, $t4, $t3		# vetor[i] > vetor[i+1] # vetor[i+1]  <= vetor[i] 
				beq $t1, $zero, fimif		# testa condicao
				# metodo troca
					add $a0, $zero, $t0	# parametro 1: end memo de vet(i) - $t0
					add $a1, $zero, $t2	# parametro 2: end memo de vet(i + 1) - $t2
					jal troca
					addi $s2, $zero, 1	# trocou = true
				# fim metodo troca
				fimif:
				addi $s3, $s3, 1 		# i++
				j for 				# return to for structure
		endfor: 
			jal mostra_vetor
			subi $s0, $s0, 1 			# limite--
			j while
	fimloop:
		addi $v0, $zero, 10				# Chamada ao sistema para encerrar programa
		syscall
#------------------------------------------------------------------------------
# ROTINA troca($a0, $a1)
#		Troca valores dos elementos do vetor na memória
# Parâmetros:
#		$a0: endereço de vetor[i] na memória
#		$a1: endereço de vetor[i+1] na memória
# Uso dos registradores:
#		$t0: vet[i]
#		$t1: vet[i + 1]

troca:	lw $t0, 0 ($a0)		# $t0 = vet[$a0] -> $t0 = vet[i]
	lw $t1, 0 ($a1)		# $t1 = vet[$a1] -> $t1 = vet[i + 1]
	
	sw $t1, ($a0)		# vet[i] = $t1
	sw $t0, ($a1)		# vet[i + 1] = $t0
	jr $ra

#------------------------------------------------------------------------------
# ROTINA ler_vetor
#		Ler vetor com a entrada do usuário
# Algoritmo:
#		for j = 0 ; j < n ; j++
#			vet[j] = numero_do_usuario
# Uso dos registradores:
#		#s1: endereco de memoria de vetor
#		$s4: n
#		$s5: i
#		$t1: condicoes
#		$t2: inteiro lido

ler_vetor:	addi $sp, $sp, -4		# adiciona mais um nivel na pilha
		sw $ra, 0, ($sp)		# salvo o retorno para a main na pilha
		addi $s5, $zero, 0		# i = 0
	for_ler:  slt $t1, $s5, $s4		# $t1 = i($s5) < n($s4)
		  beq $t1, $zero, endfor_ler  	# condicao (i < n)

		  addi $v0, $zero, 4		# Chamada ao sistema para escrever string na tela
		  la $a0, msgLerI		# $a0 = endereço da string a ser escrita na tela
		  syscall
		  
		  li $v0, 5			# chamada do sistema para ler um inteiro
		  syscall				
		  move $t2, $v0			# lê inteiro
		  
	  	  sll $t3, $s5, 2		# $t3 = 4 * i
		  add $t3, $s1, $t3		# $t3 = $s1 + (4 * i)
		  sw $t2, 0 ($t3)
      
		  addi $s5, $s5, 1		# i++
		  j for_ler 			# retorna loop
	endfor_ler:	lw $ra, 0, ($sp)	# lê o retorno para a main da pilha
			addi $sp, $sp, 4	# limpa pilha 
			jr $ra			# retorna para a main

#------------------------------------------------------------------------------
# ROTINA mostra_vetor
#		Mostra no display bitmap cor correspondente a todos os elementos de vetor
#		Possui chamada aninhada de rotina
# Algoritmo:
#		for j = 0 ; j < n ; j++
#			mostra_elemento_vetor(j)
# Uso dos registradores:
#		$s4: n
#		$s5: i
#		$t1: condicoes
#		$t2 = vet[i]
#		$t3 = n - 1

mostra_vetor:	addi $v0, $zero, 4		# Chamada ao sistema para escrever string na tela
		la $a0, msgMostrarVet		# $a0 = endereço da string a ser escrita na tela
		syscall
		addi $sp, $sp, -4		# adiciona mais um nivel na pilha
		sw $ra, 0, ($sp)		# salvo o retorno para a main na pilha
		addi $s5, $zero, 0		# i = 0
	for_vet:  slt $t1, $s5, $s4		# $t1 = i($s5) < n($s4)
		  beq $t1, $zero, endfor_vet  	# condicao (i < n)
       		  addi $a0, $s5, 0		# adiciona como parâmetro (i)
		  jal mostra_elemento_vetor
		  
  		  sll $t2, $s5, 2		# $t2 = 4 * i
		  add $t2, $s1, $t2		# $t2 = $s1 + (4 * i)
		  lw $t2, 0 ($t2)		# $t2 = vet[i]
		  li  $v0, 1          		# serviço para printar um integer
		  add $a0, $t2, $zero  		# carrega inteiro em $a
		  syscall

		  subi $t3, $s4, 1		# $t3 = n - 1
		  slt $t1, $s5, $t3		# $t1 = i($s5) < n - 1($t3)
		  beq $t1, $zero, endSeparar  	# condicao (i < (n - 1))
		  addi $v0, $zero, 4		# Chamada ao sistema para escrever string na tela
		  la $a0, separar		# $a0 = endereço da string a ser escrita na tela
		  syscall
	endSeparar:
		  addi $s5, $s5, 1		# i++
		  j for_vet 			# retorna loop
	endfor_vet:	addi $v0, $zero, 4	# Chamada ao sistema para escrever string na tela
			la $a0, pularLinha	# $a0 = endereço da string a ser escrita na tela
			syscall
			lw $ra, 0, ($sp)	# lê o retorno para a main da pilha
			addi $sp, $sp, 4	# limpa pilha 
			jr $ra			# retorna para a main
#------------------------------------------------------------------------------
# ROTINA mostra_elemento_vetor(índice)
#		Mostra no display bitmap cor correspondente ao elemento vetor[índice]
# Algoritmo:
#		Salva registradores na pilha
#		Lê vetor[índice] da memória
#		Lê escala_ azul[vetor[índice]] da memória (cor com que elemento deve ser desenhado)
#		Calcula endereço no display onde elemento do vetor deve ser desenhado: endereço inicial do display + índice * 4
#		Escreve cor nessa posição do display
#		Restaura registradores da pilha
# Parâmetros:
#		$a0: índice  do elemento do vetor (entre 0 e n - 1, corresponde à coluna no display em que elemento é desenhado)
# Uso dos registradores:
#		$t0: endereço inicial de vetor na memória
#		$t1: endereço de vetor[índice] na memória
#		$t2: vetor[índice] (entre 0 e n - 1, corresponde ao índice da cor com que elemento é desenhado)
#		$t3: endereço inicial do vetor escala_ azul na memória
#		$t4: endereço de escala_ azul[vetor[índice]] na memória
#		$t5: escala_ azul[vetor[índice]] (cor com que elemento deve ser desenhado)
#		$t6: endereço no display onde elemento do vetor deve ser desenhado
#		$gp: endereço inicial do display

			# Prólogo
mostra_elemento_vetor:	addi 	$sp, $sp, -4		# aloca espaço na pilha
			sw 	$ra, 0, ($sp)		# salva o retorno para a mostra_vetor na pilha
			addi	$sp, $sp, -28		# Aloca espaço para 7 palavras na pilha
			sw	$t0, 0 ($sp)		# Salva $t0, $t1, $t2, $t3, $t4, $t5, $t6 na pilha
			sw	$t1, 4 ($sp)
			sw	$t2, 8 ($sp)
			sw	$t3, 12 ($sp)
			sw	$t4, 16 ($sp)
			sw	$t5, 20 ($sp)
			sw	$t6, 24 ($sp)
			# Lê vetor[índice] da memória
			la	$t0, vetor		# $t0 = endereço inicial de vetor na memória
			sll	$t1, $a0, 2		# $t1 = índice * 4
			add	$t1, $t0, $t1		# $t1 = endereço de vetor[índice] na memória
			lw	$t2, 0 ($t1)		# $t2 = vetor[índice] (índice da cor com que elemento é desenhado)
			# Lê escala_ azul[vetor[índice]] da memória
			la	$t3, escala_azul	# $t3 = endereço inicial do vetor escala_ azul na memória
			sll	$t4, $t2, 2		# $t4 = vetor[índice] * 4
			add	$t4, $t3, $t4		# $t4 = endereço de escala_ azul[vetor[índice]] na memória
			lw	$t5, 0 ($t4)		# $t5 = escala_ azul[vetor[índice]] (cor com que elemento é desenhado)
			# Calcula endereço no display onde elemento do vetor deve ser desenhado
			sll	$t6, $a0, 2		# $t6 = índice * 4
			add	$t6, $gp, $t6		# $t6 = endereço inicial do display + índice * 4
			sw	$t5, 0 ($t6)		# Escreve cor do elemento do vetor na área de memória do display bitmap: mostrado no display
			# Epílogo
			lw	$t0, 0 ($sp)		# Restaura $t0, $t1, $t2, $t3, $t4, $t5, $t6 da pilha
			lw	$t1, 4 ($sp)
			lw	$t2, 8 ($sp)
			lw	$t3, 12 ($sp)
			lw	$t4, 16 ($sp)
			lw	$t5, 20 ($sp)
			lw	$t6, 24 ($sp)
			addi	$sp, $sp, 28		# Libera espaço de 7 palavras na pilha
			lw	$ra, 0 ($sp)		# leio o retorno para mostra_vetor
			addi	$sp, $sp, 4		# retira mostra_vetor da pilha
			jr	$ra			# Retorna da rotina
#------------------------------------------------------------------------------
			.data				# Área de dados
#------------------------------------------------------------------------------
			# Variáveis e estruturas de dados do programa
n:			.word 16			# Número de elementos do vetor (no máximo 16)
			# Vetor a ser ordenado (com 16 valores entre 0 e 15)
vetor:			.word 9 1 10 2 6 13 15 0 12 5 7 14 4 3 11 8
#vetor:			.word 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
#vetor:			.word 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
#vetor:			.word 9 1 10 2 9 6 13 15 13 0 12 5 6 0 5 7
			# Strings para impressão de mensagens
msg1:			.asciiz "\nOrdenação\n"
msgN:			.asciiz "\nDigite um N para o vetor:\n"
msgLerI:		.asciiz "\nDigite um valor:\n"
msgMostrarVet:		.asciiz "\nMostrando vetor:\n"
pularLinha:		.asciiz "\n"
separar:		.asciiz ", "
msg2:			.asciiz "Tecle enter"
			# Escala de 16 cores em azul
escala_azul:		.word 0x00CCFFFF, 0x00BEEEFB, 0x00B0DDF8, 0x00A3CCF4, 0x0095BBF1, 0x0088AAEE, 0x007A99EA, 0x006C88E7, 0x005F77E3, 0x005166E0, 0x004455DD, 0x003644D9, 0x002833D6, 0x001B22D2, 0x000D11CF, 0x000000CC
#------------------------------------------------------------------------------
