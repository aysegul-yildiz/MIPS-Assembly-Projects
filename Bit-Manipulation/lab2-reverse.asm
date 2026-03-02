# Lab 2- reverse bits

.data
	askNum: .asciiz "\nEnter a number: "
	continue: .asciiz "\nDo you want to continue with another number? (y/n): "
	originalHex: .asciiz "Hex version of the  original number: "
	reversedVHex: .asciiz "\nOriginal contents reversed bit  by bit: "
	binary: .word 0:32
	gap: .asciiz " "
	hexReps: .word '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	hexVersion: .word ' ':8
	newLine: .asciiz "\n"
	hexsym: .asciiz "0x"
	yes: .word 'y'
	
	
.text
	main:		
		lw $s7, yes
		
		ifContinueLoop:
			beq $s7, 'n', quit
			li $v0, 4
			la $a0, askNum
			syscall
		
			li $v0, 5
			syscall
			add $s0, $v0, $zero
		
			add $a0, $s0, $zero
			la $a1, binary
			jal ConvertToBinary
			
			li $v0, 4
			la $a0, originalHex
			syscall	
			
			la $a0, binary
			la $a1, hexReps
			jal ConvertToHex
			
			addi $a0, $zero, 32
			la $a1, binary
			jal ReverseBits
			
			li $v0, 4
			la $a0, reversedVHex
			syscall	
			
			la $a0, binary
			la $a1, hexReps
			jal ConvertToHex
			
			addi $a0, $zero, 32
			la $a1, binary
			jal ResetArray
			
			addi $a0, $zero, 8
			la $a1, hexVersion
			jal ResetArray
			
			li $v0, 4
			la $a0, continue
			syscall
		
			li $v0,12
			syscall
		
			add $s7, $v0, $zero
			j ifContinueLoop
			
		quit:
			li $v0,10
			syscall
		
		
		
	ConvertToHex:
		# restore values to stack
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
		
		# $s0 = 32
		addi $s0, $zero, 32
		
		# $s1 = array address
		add $s1, $a0, $zero
		
		# $s2 = hex address
		add $s2, $a1, $zero
		
		# $s3 = 0
		add $s3, $zero, $zero
		
		# $s4 = sum
		add $s4, $zero, $zero
		
		# $s6 = 16
		addi $s6, $zero, 16
		
		# $s7 = hex version address
		la $s7, hexVersion
		
		lw $a0, ($s2)
		li $v0, 11
		syscall
		
		hexLoop:
			beq $s0, $s3, exitHexLoop
			
			lw $s5, ($s1)
			sll $s5, $s5,3
			add $s4, $s4, $s5
			addi $s1 $s1, 4
			lw $s5 ($s1)
			sll $s5, $s5,2
			add $s4, $s4, $s5
			addi $s1 $s1, 4
			lw $s5 ($s1)
			sll $s5, $s5,1
			add $s4, $s4, $s5
			addi $s1 $s1, 4
			lw $s5 ($s1)
			sll $s5, $s5,0
			add $s4, $s4, $s5
			addi $s1 $s1, 4
			addi $s3, $s3, 4
			
			sll $s4, $s4, 2
			add $s2, $s2, $s4
			lw $t0, ($s2)
			sw $t0, ($s7)
			addi $s7, $s7, 4
			add $s2, $a1, $zero
			add $s4, $zero, $zero
			j hexLoop		
					
		exitHexLoop:
			li $v0, 4
			la $a0, hexsym
			syscall
			addi $a0, $zero, 8
			la $a1, hexVersion
			jal Print
			
			#restore values from stack
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
	
	
	ConvertToBinary:
		# store s registers and return address into stack
		addi $sp, $sp, -32
		sw $ra, 28($sp)
		sw $s0, 24($sp)
		sw $s1, 20($sp)
		sw $s2, 16($sp)
		sw $s3, 12($sp)
		sw $s4, 8($sp)
		sw $s5, 4($sp)
		sw $s6, 0($sp)
		
		# $s0 = decimal = $a0
		add $s0, $a0, $zero
		
		# $s3 = decimal(set)
		add $s3 , $a0, $zero
		
		# $s1 = count = 0
		add $s1, $zero, $zero
		
		# $s2 = remainder 
		add $s2, $zero, $zero
		
		# $s4 = binary array address
		add $s4, $a1, $zero
		
		# array index
		addi $s5, $zero, 124
		
		
		add $s6, $zero, $s4
		
		# $s7 = 2
		addi $s7, $zero, 2
		
		# loop to keep dividng the number to two 
		add $s4, $s4, $s5
			
		binaryLoop:
			blt $s3, 1, exitBinary
			div $s3, $s7
			mflo $s3
			mfhi $s2
			sw $s2, ($s4)
			subi $s4, $s4, 4
			j binaryLoop
		exitBinary:
				
		addi $a0,$zero, 32
		addi $a1, $s6, 0
			
		#restore values from stack
		lw $s6, 0($sp)
		lw $s5, 4($sp)
		lw $s4, 8($sp)
		lw $s3, 12($sp)
		lw $s2, 16($sp)
		lw $s1, 20($sp)
		lw $s0, 24($sp)
		lw $ra, 28($sp)
		addi $sp, $sp, 32
		jr $ra 
		
		
	
	
	ReverseBits:
		# store s registers, $ra to stack
		addi $sp, $sp, -28
		sw $ra, 28($sp)
		sw $s0, 24($sp)
		sw $s1, 20($sp)
		sw $s2, 16($sp)	
		sw $s3, 12($sp)
		sw $s4, 8($sp)
		sw $s5, 4($sp)
		sw $s6, 0($sp)
		
		# $s0 = 32
		srl $s0, $a0, 1
		# $s1 = binary arr address
		add $s1, $a1, $zero
		# s7 = binary address
		add $s7, $a1, $zero
		# $s2 = count
		add $s2, $zero, $zero
		# $s3 = last place on array
		addi $s3, $s1, 124
		
		reverseLoop:
			beq $s0, $s2, exitReverse
			lw $s4, ($s1)
			lw $s5, ($s3)
			sw $s4, ($s3)
			sw $s5, ($s1)
			addi $s1, $s1, 4
			addi $s3, $s3, -4
			addi $s2, $s2, 1
			j reverseLoop
		exitReverse:
			
			#restore values from stack
			lw $s6, 0($sp)
			lw $s5, 4($sp)
			lw $s4, 8($sp)
			lw $s3, 12($sp)
			lw $s2, 16($sp)
			lw $s1, 20($sp)
			lw $s0, 24($sp)
			lw $ra, 28($sp)
			addi $sp, $sp, 28
			
			jr $ra
			
			
			
			
		
	ResetArray:
		# store s registers
		addi $sp, $sp, -12
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		# $s0 = $a0 = arraysize
		add $s0, $a0, $zero
		
		# $s1 = $a1 = array address
		add $s1, $a1, $zero
		
		# $s2 = count = 0
		add $s2, $zero, $zero
				
		resetLoop:
			beq $s0, $s2, exitReset
			sw $zero, ($s1)
			addi $s1, $s1, 4
			addi $s2, $s2, 1
			j resetLoop
		exitReset:
			lw $s2, 0($sp)
			lw $s1, 4($sp)
			lw $s0, 8($sp)
			addi $sp, $sp, 12
			jr $ra
	
	
	Print:
		# $s0 = array size
		add $s0, $a0, $zero
		# $s1 = binary word address
		add $s1, $a1, $zero
		# $s2 = index = 0
		
		add $s2, $zero, $zero
		
		# loop to print
		printLoop:
			beq $s0, $s2, exitPrint
			lw $a0, ($s1)
			li $v0, 11
			syscall
			addi $s1, $s1, 4
			addi $s2, $s2, 1
			j printLoop
		exitPrint:
			jr $ra
	
