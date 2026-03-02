.data
	prompt: .asciiz "\nEnter the array size: "
	element: .asciiz "\nEnter array element: "
	gap: .asciiz " "
	FreqTable: .word 0:11
	originalArray: .asciiz "\nOriginal Array: "
	freq: .asciiz "\nFrequency of integers in the array (printed in ascending order, the last element is the numbers bigger than nine): "
	newLine: .asciiz "\n"

.text
	main:		
		# call createArray
		jal CreateArray 
		
		# $s0 = array size
		add $s0, $v0 , $zero
		# $s1 points to array
		add $s1, $v1, $zero
		
		# give array size, address and address of freq table to findfreg
		lw $a2, FreqTable
		la $a2, FreqTable
		add $a0, $s0 $zero
		add $a1, $s1, $zero
		# call FindFreg
		jal FindFreq
		
		
		# end program
		li $v0, 10
		syscall
		
	CreateArray:
		# allocate space on stack
		addi $sp, $sp, -20
		# store s register values and return adress to stack
		sw $ra, 16($sp)
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		# ask the array size
		li $v0, 4
		la $a0, prompt
		syscall
		
		# get the input
		li $v0, 5
		syscall
		
		#store array size ($s0 = array size)
		add $s0, $v0, $zero
		
		# $s1 = memory space (multiply size with four to have enough space for bytes)
		sll $s1, $s0, 2
		
		# allocate storage space
		add $a0, $s1, $zero
		li $v0, 9
		syscall
		
		add $a0, $v0, $zero
		add $s3, $a0, $zero
		#$a1 has the array size
		add $a1, $s0, $zero
				
		# call InitalizeArray
		jal InitializeArray
		
		# print array
		add $a0, $s3, $zero
		add $a1, $s0, $zero
		jal printArray
		
		add $v0, $s0, $zero
		add $v1, $s3, $zero
		# restore used s registers
		lw $s3, 0($sp)
		lw $s2, 4($sp)
		lw $s1, 8($sp)
		lw $s0, 12($sp)
		lw $ra, 16($sp)
		
		# give back stack space
		addi $sp, $sp, 20
		jr $ra
			
		
		
	InitializeArray:
		addi $sp, $sp, -12
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		# s0 = arraySize
		add $s0, $a1, $zero
		# $s1 = points to array
		add $s1, $a0, $zero
		# $s2 = 0 (index)
		add $s2, $zero, $zero
		
		# loop to get array elements
		getElementsLoop:
			# if index = size exit loop
			beq $s0, $s2, exitElementsLoop
			# print prompt
			li $v0, 4
			la $a0, element
			syscall
			
			# get element
			li $v0, 5
			syscall
			
			# store element in array
			sw $v0, 0($s1)
			
			#increment index
			addi $s2, $s2, 1
			
			# increment last used array space
			addi $s1, $s1, 4
			
			j getElementsLoop
						
		exitElementsLoop:
			lw $s2, 0($sp)
			lw $s1, 4($sp)
			lw $s0, 8($sp)	
			addi $sp, $sp, 12	
			jr $ra
			
	FindFreq: 	
		# make space on stack and store s registers
		addi $sp, $sp, -32
		sw $ra, 28($sp)
		sw $s0, 24($sp)
		sw $s1,20($sp)
		sw $s2, 16($sp)
		sw $s3, 12($sp)
		sw $s4, 8($sp)
		sw $s5, 4($sp)
		sw $s6, 0($sp)
				
		# $s0 = $a0 = arraysize
		add $s0, $a0, $zero
		# $s1 = $a1 = array address
		add $s1, $a1, $zero
		# $s2 = index = 0
		add $s2, $zero, $zero
		# $s3 = initial int = 0
		addi $s3, $zero, 0
		# count = 0
		addi $s4, $zero, 0
		# $s5 = freqtable address
		add $s5, $a2, $zero
		
		# loop through table to get num of every element
		loopForEveryInt:
			beq $s3, 10, exitLoop
			loopElements:
				beq $s2, $s0, skipToNextInt
				lw $s6, 0($s1)
		
				ifEqual:
					bne $s3, $s6, next
					# increment count
					addi $s4, $s4, 1
				next:
					# increment index
					addi $s2, $s2, 1
					# increment array address
					addi $s1, $s1, 4
			
				j loopElements
			skipToNextInt:
				sw $s4, ($s5)
								
				add $s4, $zero, $zero
				add $s2, $zero, $zero
				add $s1, $a1, $zero
				addi $s3, $s3, 1
				addi $s5, $s5, 4
			j loopForEveryInt
		exitLoop:
			addi $s2, $zero,0
			add $s1, $a1, $zero
			addi $s4, $zero, 0
			
			loopForBiggerThanNine:
				beq $s2, $s0, exitBLoop
				lw $s6, 0($s1)
				ifBigger:
					blt $s6, 10, notBigger
					addi $s4, $s4, 1
				notBigger:
					addi $s2, $s2, 1
					addi $s1, $s1, 4
				j loopForBiggerThanNine
			
			exitBLoop:
				
				sw $s4, ($s5)
				
			addi $a0, $zero, 11
			addi $s5, $s5, -40
			add $a1, $s5, $zero
			jal PrintFreqTable
		        lw $s6, 0($sp)
		        lw $s5, 4($sp)
		        lw $s4, 8($sp)
		        lw $s3, 12($sp)
		        lw $s2, 16($sp)
		        lw $s1, 20($sp)
		        lw $s0, 24($sp)
		        lw $ra, 28($sp)
		        addi $sp, $sp 32
		        
		        jr $ra
			
		
			
	printArray:
		addi $sp, $sp, -16
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		# $s0 = $a1 = size
		add $s0, $a1, $zero
		# $s1 = $a0 = array address
		add $s1, $a0, $zero
		# $s2 = index = 0
		add $s2, $zero, $zero
		
		li $v0, 4
		la $a0, originalArray
		syscall
		
		# loop to print array elements
		printLoop:
			beq $s0, $s2, printLoopExit
			lw $s3, 0($s1)
			add $a0, $s3, $zero
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, gap
			syscall
			
			addi $s2, $s2, 1
			addi $s1, $s1, 4
			
			j printLoop
			
		printLoopExit:
			lw $s3, 0($sp)
			lw $s2, 4($sp)
			lw $s1, 8($sp)
			lw $s0, 12($sp)	
			addi $sp, $sp, 16
			jr $ra
			
			
		
		
	PrintFreqTable:
		# $s0 = table size
		add $s0, $a0, $zero
		# $s1 = freqtable address
		add $s1, $a1, $zero
		# $s2 = index = 0
		add $s2, $zero, $zero
		
		#print freq table caption
		li $v0, 4
		la $a0, freq
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		
		# loop to print
		printFreqLoop:
			beq $s0, $s2, exitPrintFreq
			lw $a0, 0($s1)
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, gap
			syscall
			 
			addi $s1, $s1, 4
			addi $s2, $s2, 1
			j printFreqLoop
		exitPrintFreq:
			jr $ra
			
		
		
		
