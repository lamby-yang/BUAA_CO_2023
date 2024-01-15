.data

charA:.byte 'A'
charB:.byte 'B'
charC:.byte 'C'
Space:.byte ' '
Enter:.byte '\n'


.macro return_0
	li $v0 10
	syscall
.end_macro

.macro scanf_d(%ans)
	li $v0 5
	syscall
	move %ans $v0
.end_macro

.macro printf_d(%n)
	move $a0,%n
	li $v0 1
	syscall
.end_macro

.macro printf_c(%char)
	move $a0,%char
	li,$v0,11
	syscall
.end_macro

.macro push(%scr)
	sw %scr,0($sp)
	addi $sp,$sp,-4
.end_macro

.macro pop(%des)
	addi $sp,$sp,4
	lw %des, 0($sp)
.end_macro

.eqv n $t0
.eqv from $t1
.eqv tmp $t2
.eqv to $t3
.eqv space $t4
.eqv enter $t5
 /////////////\
.text
main:
	lb from,charA
	lb tmp,charB
	lb to,charC
	lb space,Space
	lb enter,Enter
	
	scanf_d(n)
	
	move $s0,n
	move $s1,from
	move $s2,tmp
	move $s3,to
	
	jal dfs
	nop
	return_0
	
dfs:
	push($ra)
	push(n)
	push(from)
	push(tmp)
	push(to)
	
	move n,$s0
	move from,$s1
	move tmp,$s2
	move to,$s3
	
	beq n,1,if_n_1
	nop
	j if_n_1_end
	
	if_n_1:
		printf_d(n)
		printf_c(space)
		printf_c(from)
		printf_c(space)
		printf_c(to)
		printf_c(enter)
		
		j dfs_end
	if_n_1_end:
	
	addi $s0,n,-1
	move $s1,from
	move $s2,to
	move $s3,tmp
	jal dfs
	nop
	
		printf_d(n)
		printf_c(space)
		printf_c(from)
		printf_c(space)
		printf_c(to)
		printf_c(enter)
	
	addi $s0,n,-1
	move $s1,tmp
	move $s2,from
	move $s3,to
	jal dfs
	nop
	
	

dfs_end:
	pop(to)
	pop(tmp)
	pop(from)
	pop(n)
	pop($ra)
	jr $ra
