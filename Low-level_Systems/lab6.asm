.data
prompt: .asciiz "\nEnter matrix dimension: "
successful: .asciiz "\nSquare matrix created!\n"
menuMsg: .asciiz "\nMenu: \n1.Display desired element \n2.Obtain summation of matrix elements row-major summation \n3.Obtain summation of matrix elements column-major summation\n4.quit"
choice: .asciiz "\nEnter your choice: "
row: .asciiz "Enter row number of the location to be displayed: " 
column: .asciiz "Enter column number of the location to be displayed: " 
element: .asciiz "\nDesired element: "
RowResult: .asciiz "\nRow-major summation result: "
ColumnResult: .asciiz "\nColumn-major result:"
exitMsg: .asciiz "\ngoodbye"

.text
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5  
	syscall
	
	add $s0, $v0, $zero  # $s0 = matrix dimension
	
	mul $s1, $s0, $s0	 # dimension * dimension 
	addi $s2, $zero, 4
	mul $s2, $s1, $s2	# total bytes = $s2
	
	# allocate memory
	add $a0, $s2, $zero
	li $v0, 9
	syscall
	
	add $s3, $v0, $zero	# $s3 = base address 
	
	la $a0, successful
	li $v0, 4
	syscall
	
	# fill the matrix loop
	addi $s4, $zero, 1
	add $s5, $s3, $zero	# base address copy
	addi $s6, $zero, 0	# count
	loopToFill:
		beq $s1, $s6, menu
		sw $s4, 0($s5)
		
		addi $s4, $s4, 1
		addi $s5, $s5, 4
		addi $s6, $s6, 1
		j loopToFill
	menu:
		la $a0, menuMsg
		li $v0, 4
		syscall
		
		la $a0, choice
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		add $s6, $v0, $zero
		
		display:
			bne $s6, 1, rowS
			add $a0, $s3, $zero
			add $a1, $s0, $zero
			jal displayDesired
			
	
		rowS:
			bne $s6, 2, columns
			add $a0, $s3, $zero
			add $a1, $s1, $zero
			jal rowSummation
			
			
		columns:
			bne $s6, 3, error
			add $a0, $s3, $zero
			add $a1, $s0, $zero
			jal ColumnSummation
				
		
		error:	
			la $a0, exitMsg
			li $v0, 4
			syscall
			li $v0, 10
			syscall
		
	
displayDesired:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	
	add $s0, $a0, $zero	# s0 = base address
	add $s1, $a1, $zero	# s1 = dimension
	
	la $a0, row
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s2, $v0, $zero	# s2 = row 
	
	la $a0, column
	li $v0, 4
	syscall 
	
	li $v0, 5
	syscall
	
	add $s3, $v0, $zero	# s3 = column
	
	#calculate displacement
	addi $s4, $zero, 4
	addi $s2, $s2, -1
	mul $s2, $s2, $s1
	mul $s2, $s2, $s4
	
	addi $s3, $s3, -1
	mul $s3, $s3, $s4
	
	add $s2, $s2, $s3
	
	add $s2, $s2, $s0
	
	lw $s4, 0($s2)
	
	la $a0, element
	li $v0, 4
	syscall
	
	add $a0, $s4, $zero
	li $v0, 1
	syscall
	
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
	
rowSummation:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	
	add $s0, $a0, $zero	# s0 = base address
	add $s1, $a1, $zero	# s1 = dimension*dimension
	
	addi $s2, $zero, 0	#counter
	addi $s3, $zero, 0	# sum
	rowSumLoop:
		beq $s2, $s1, rowSummed
		lw $s4, 0($s0)
		add $s3, $s3, $s4 
		
		addi $s0, $s0, 4
		addi $s2, $s2, 1 
		
		j rowSumLoop
		
	rowSummed:
		la $a0, RowResult
		li $v0, 4
		syscall
		
		add $a0, $s3, $zero
		li $v0, 1
		syscall
		
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
	
ColumnSummation:
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
	
	add $s0, $a0, $zero	# s0 = base address
	add $s1, $a1, $zero	# s1 = dimension
	
	addi $s2, $zero, 0 	# count
	addi $s3, $zero, 0	# sum
	li $t1, 4
	columnSum:
		beq $s2, $s1, ColSummed
		mul $s5, $s2, $t1
		add $s7, $s0, $s5
		addi $s4, $zero, 0
		nestedLoop:
			beq $s4, $s1, colEnd
			lw $s6, 0($s7)
			add $s3, $s3, $s6
			mul $t0, $s1, $t1
			add $s7, $s7, $t0
			addi $s4, $s4, 1
			 j nestedLoop
		colEnd:
			addi $s2, $s2, 1
			j columnSum
	ColSummed:
		la $a0, ColumnResult
		li $v0, 4
		syscall
		
		add $a0, $s3, $zero
		li $v0, 1
		syscall
	
	lw $s7, 0($sp)
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp)
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	jr $ra
	
	
