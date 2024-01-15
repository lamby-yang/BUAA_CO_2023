.data
matrix_f: .space 484
matrix_h: .space 484

str_enter: .asciiz "\n"
str_space: .asciiz " "

.macro get_index(%ans,%i,%j)
	mul %ans,%i,11
	add %ans,%ans,%j
	sll %ans,%ans,2
.end_macro 

.text
	li $v0,5
	syscall
	move $s0,$v0	# $s0=m1
	li $v0,5
	syscall
	move $s1,$v0	# $s1=n1
	li $v0,5
	syscall
	move $s2,$v0	# $s2=m2
	li $v0,5
	syscall
	move $s3,$v0	# $s3=n2

	li $t0,0						# $t0 = i
	for_i_1:						# for (int i = 0; i < m1; i++)
		beq $s0,$t0,for_i_1_end
		#
		li $t1,0					# $t1 = j
		for_j_1:					# for (int j = 0; j < n1; j++)
			beq $s1,$t1,for_j_1_end
			#
			get_index($t8,$t0,$t1) # get address [i][j]
			li $v0,5
			syscall 				
			sw $v0,matrix_f($t8) 	#save v0 to matrix_f[$t8]
			#
			addi $t1,$t1,1
			j for_j_1
		for_j_1_end:
		#
		addi $t0,$t0,1
		j for_i_1
	for_i_1_end:
	
	
	li $t0,0
	for_i_2:
		beq $s2,$t0,for_i_2_end
		#
		li $t1,0
		for_j_2:
			beq $s3,$t1,for_j_2_end
			#
			get_index($t8,$t0,$t1)
			li $v0,5
			syscall 
			sw $v0,matrix_h($t8)
			#
			addi $t1,$t1,1
			j for_j_2
		for_j_2_end:
		#
		addi $t0,$t0,1
		j for_i_2
	for_i_2_end:
	
	
	li $t0,0
	sub $s0,$s0,$s2
	sub $s1,$s1,$s3
	addi $s0,$s0,1
	addi $s1,$s1,1	
	for_i_3:
		beq $s0,$t0,for_i_3_end
		#
		li $t1,0
		for_j_3:
			beq $s1,$t1,for_j_3_end
			#
			li $a0,0
			#
			li $t2,0
			for_k:
				beq $s2,$t2,for_k_end
				#
				li $t3,0
				for_l:
					beq $s3,$t3,for_l_end
					#
					add $t6,$t0,$t2
					add $t7,$t1,$t3
					get_index($t8,$t6,$t7)
					get_index($t9,$t2,$t3)
					lw $t6,matrix_f($t8)
					lw $t7,matrix_h($t9)
					
					mul $t5,$t6,$t7
					add $a0,$a0,$t5
					
					#
					addi $t3,$t3,1
					j for_l
				for_l_end:
				#
				addi $t2,$t2,1
				j for_k
			for_k_end:
			
			#
			li $v0,1
			syscall
			la $a0,str_space
			li $v0,4
			syscall
			#
			addi $t1,$t1,1
			j for_j_3
		for_j_3_end:
		la $a0,str_enter
		li $v0,4
		syscall
		#
		addi $t0,$t0,1
		j for_i_3
	for_i_3_end:

li $v0,10
syscall
