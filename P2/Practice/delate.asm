.data 
s: .space 100

.macro return_0
	li $v0,10
	syscall
.end_macro

.macro scanf_s(%n)
	la $a0,s
	move $a1,%n
	li $v0,8
	syscall
.end_macro

.macro printf_c(%i)
	lb $a0,s(%i)
	li $v0,11
	syscall
.end_macro

.macro scanf_d(%ans)
	li $v0,5
	syscall
	move %ans,$v0
.end_macro

.eqv i $t0
.eqv n $t1
.eqv N $t2
.eqv k $t3
.eqv l $t4

.text
main:
	scanf_d(n)
	addi n,n,1
	scanf_d(N)
	scanf_s(n)
	
	li,i,0
	for_i:
		beq i,N,for_i_end
		#
		li,k,0
		for_k:
			beq k,n,for_k_end
			#
			lb $t8,s(k)
			addi $t7,k,1
			lb $t9,s($t7)
			bgt $t8,$t9,if_ak_bigger
			nop
			j if_ak_bigger_end
			if_ak_bigger:
				#
				move l,k
				for_l:
				beq l,n,for_l_end
				addi $t9 l 1
				lb $t8,s($t9)
				sb $t8,s(l)
				addi l,l,1
				j for_l
				for_l_end:
				addi n,n,-1
				j for_k_end
				#
			if_ak_bigger_end:
			#
			addi k,k,1
			j for_k
		for_k_end:
		#
		addi i,i,1
		j for_i
	for_i_end:
	
	li i,0
	
	while:
		lb $t8,s(i)
		bnez $t8,while_end
		addi $t9,n,-2
		beq i,$t9,while_end
		
		addi i,i,1
		j while
	while_end:
	
	for:
		beq i,n,for_end
		printf_c(i)
		addi,i,i,1
		j for
	for_end:
	
	return_0