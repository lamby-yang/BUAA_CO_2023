.data
matrix1: .space 256 #int matrix1[8][8]
matrix2: .space 256 #int matrix2[8][8]

str_enter: .asciiz "\n"
str_space: .asciiz " "

.macro get_index(%ans,%i,%j)
    sll %ans,%i,3
    add %ans,%ans,%j
    sll %ans,%ans,2
.end_macro


.text
li $v0,5
syscall
move $s0,$v0 #scanf(n);


li $t0,0 #int i=0;
for_i_1:
    beq $t0,$s0,end_for_i_1
    li $t1,0 #int j=0;
    for_j_1:
	beq $t1,$s0,end_for_j_1
	
	get_index($t8,$t0,$t1)	#t8=matrix1[i][j]'s address
	li,$v0,5
	syscall				
	sw $v0,matrix1($t8)		
	
	addi $t1,$t1,1
	j for_j_1
    end_for_j_1:
    
    addi $t0,$t0,1
    j for_i_1
end_for_i_1:    


li $t0,0 #int i=0;
for_i_2:
    beq $t0,$s0,end_for_i_2
    li $t1,0 #int j=0;
    for_j_2:
	beq $t1,$s0,end_for_j_2
	
	li $t3,256			#matirx2 address 
	get_index($t8,$t0,$t1)	#t8=matrix2[i][j]'s address
	li,$v0,5
	syscall				
	sw $v0,matrix2($t8)		
	
	addi $t1,$t1,1
	j for_j_2
    end_for_j_2:
    
    addi $t0,$t0,1
    j for_i_2
end_for_i_2:    



li $t0,0 #int i=0;
for_i_count:
    beq $t0,$s0,end_for_i_count
    li $t1,0 #int j=0;
    for_j_count:
	beq $t1,$s0,end_for_j_count
	li $t2,0 #int k=0;
	li $s1,0			#int ans=0;
	for_k_count:
	    beq $t2,$s0,end_for_k_count
	    
	   
	    get_index($t3,$t0,$t2)
	    get_index($t4,$t2,$t1)
	    lw $t8,matrix1($t3)
	    lw $t9,matrix2($t4)
	    multu $t8,$t9
	    mflo $t8
	    add $s1,$s1,$t8
	    
	    addi $t2,$t2,1
	    j for_k_count
	end_for_k_count:
	
	move $a0,$s1
	li $v0,1
	syscall
	
	la $a0,str_space
	li $v0,4
	syscall
	
	addi $t1,$t1,1
	j for_j_count
    end_for_j_count:
    
    la $a0,str_enter
    li $v0,4
    syscall
    
    addi $t0,$t0,1
    j for_i_count
end_for_i_count:    

    
li $v0,10
syscall