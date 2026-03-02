.data 
	prompt1: .asciiz "\nEnter the divident: "
	prompt2: .asciiz "\nEnter the divisor: "
	result: .asciiz "\nResult: "
	invalid: .asciiz "\nInvalid input! Numbers cannot be zero."
	
.text
	main:
		ifNotZero:
		
			li $v0, 4
			la $a0, prompt1
			syscall
		
			li $v0, 5
			syscall
		
			# $s0 = divident
			move $s0, $v0
		
			li $v0, 4
			la $a0, prompt2
			syscall
		
			li $v0, 5
			syscall
		
			# $s1 = divisor
			move $s1, $v0
		
			beq $s0, $zero, stop
			beq $s1, $zero, stop
			
			add $a0, $s0, $zero
			add $a1, $s1, $zero
			add $a2, $zero, $zero
			add $v0, $zero, $zero
			jal ReccursiveDivision
			
			# $s2 = quotient
			add $s2, $v0, $zero
			
			li $v0, 4
			la $a0, result
			syscall
			
			li $v0, 1
			move $a0, $s2
			syscall
			
			add $v0, $zero, $zero
			j ifNotZero
		
		stop:
			li $v0, 4
			la $a0, invalid 
			syscall
			
			li $v0, 10
			syscall
		
	ReccursiveDivision:
		# $a0 gives divident, $a1 gives divisor
		
		# store values to stack
		addi $sp, $sp, -16
		sw $ra, 12($sp)	
		sw $s2, 8($sp)
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		
		# $s0 = divident
		add $s0, $a0, $zero
		
		# $a1 = divisor
		add $s1, $a1, $zero
		
		# $s2 = $a2 = quotient
		add $s2, $a2, $zero
		
		canDivisible:
			blt $s0, $s1, quit
			beq $s0, $zero, quit
			sub $s0, $s0, $s1
			addi $v0, $v0, 1
			
			add $a0, $s0, $zero
			add $a1, $s1, $zero
			jal ReccursiveDivision

			add $v0, $v0, $zero
			
		quit:
			
			# restore the values from stack
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			
			jr $ra
			
			