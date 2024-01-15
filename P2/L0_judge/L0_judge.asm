.data
str: .space 20

.text
li $v0,5
syscall
move $s0,$v0	#int n=s0

li $t0,0
for_i_1:
    beq $s0,$t0,for_i_end_1
    
    li $v0,12
    syscall
    
    
    sb $v0,str($t0)
	
	addi $t0,$t0,1
    j for_i_1
for_i_end_1:

li $a0,1
li $t0,0
div $s1,$s0,2
for_i_2:
    beq $s1,$t0,for_i_end_2
    
    sub $t1,$s0,$t0 	#$t1=n-i-1
    subi $t1,$t1,1		#$t0=i
    
    lb $t8,($t1)
    lb $t9,($t0)
    
    beq $t9,$t8,if_a_equ_b
	nop
	j else
	if_a_equ_b:
		
	j if_end
	else:
		li $a0,0
		
	if_end:
	addi $t0,$t0,1
    j for_i_2
for_i_end_2:


li $v0,1
syscall



li $v0,10
syscall
