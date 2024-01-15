.data
symbol: .space 200	# int symbol[7];
array: .space 200		# int array[7];
# $s0 = n;			# int n;

str_space: .asciiz " "
str_enter: .asciiz "\n"

.macro printf_d(%num)
	move $a0,%num
	li $v0,1
	syscall
.end_macro 

.macro scanf_d(%num)
	li $v0,5
	syscall
	move %num,$v0
.end_macro

.macro printf_s(%str)
	la $a0,%str
	li $v0,4
	syscall
.end_macro

.macro get_index_a(%ans,%i)
	li $t1,4
	mul $t1,%i,$t1
	lw %ans,array($t1)
.end_macro

.macro get_index_sy(%ans,%i)
	li $t1,4
	mul $t1,%i,$t1
	lw %ans,symbol($t1)
.end_macro

.macro push(%src)
	sw %src,0($sp)
	addi $sp,$sp,-4
.end_macro

.macro pop(%des)
	addi $sp,$sp,4
	lw %des,0($sp)
.end_macro


.text
main:
	#scanf_d($s0)		# n (const)
	li $v0,5
	syscall
	move $s0,$v0

	li $a0,0

	jal full_array
	nop

	li $v0,10
	syscall

full_array:
	push($ra)
	push($t5)	# $t5 = index
	push($t0)
	move $t5,$a0	# t5=index_new=a0
	
	begin:
	li $t0,0		# int i=0;
	bge $t5,$s0,if_index_n
	nop
	j 	if_index_n_end
	nop
	if_index_n:
		li $t0,0
		for_i_1:
			beq $t0,$s0,for_i_1_end
			
			get_index_a($t2,$t0)
			printf_d($t2)
			printf_s(str_space)
		
			addi $t0,$t0,1
			j for_i_1
		for_i_1_end:
		printf_s(str_enter)
		j full_array_end
		nop
	if_index_n_end:
	
	li $t0,0
	for_i_2:
		beq $t0,$s0,for_i_2_end
		
		get_index_sy($t2,$t0)
		beqz $t2,if_symbol_is_0	# if (symbol[i] == 0)
		nop
		j symbol_end
		if_symbol_is_0:
			mul $t2,$t5,4		# array[index] = i + 1;
			addi $t3,$t0,1
			
			sw $t3,array($t2)
			
			
			li $t4,1
			mul $t2,$t0,4		# symbol[i] = 1;
			sw $t4,symbol($t2)
			
			addi $t6,$t5,1		# $t6=index+1
			move $a0,$t6			# a0=index+1
			jal full_array
			nop
			
			
			li $t4,0
			mul $t2,$t0,4		# symbol[i] = 0;
			sw $t4,symbol($t2)
		
		symbol_end:
		
		addi $t0,$t0,1
		j for_i_2
	for_i_2_end:
	


full_array_end:
	pop($t0)
	pop($t5)
	pop($ra)
	
	jr $ra
	
	

