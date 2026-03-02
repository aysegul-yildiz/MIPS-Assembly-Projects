

# simple menu program

.data
	myArray: .space 400
	prompt: .asciiz "Enter the number of elements: "
	elementMessage: .asciiz "\nEnter the next element: "
	gap: .asciiz " "
	choice: .asciiz "\nYour choice(a, b, c,d): "
	a: .byte 'a'
	b: .byte 'b' 
	max: .asciiz "\nMax number in array is "
	maxNum: .asciiz "\nThe number of times max number appears in the array is "
	divisibleNum: .asciiz "\nThe number of array elements that the max number can divide without a remainder(excluding itself) is "
	menu: .asciiz "\nmenu: \na.Find the maximum number stored in the array and display that number. \nb.Find the number of times the maximum number appears in that array. \nc.Find how many numbers we have that we can divide the maximum number without a remainder. \nd.Quit"
	
.text
	main:
		li $v0, 4
		la $a0, prompt
		syscall
	
		li $v0, 5
		syscall
	
		# size
		add $s0, $zero, $v0
	
		#index = 0
		add $s1, $zero, $zero
	
		#count = 0
		add $s2, $zero, $zero
	
		while:
			beq $s0, $s2, exit
			li $v0, 4
			la $a0, elementMessage
			syscall
		
			li $v0, 5
			syscall
		
			add $t1, $zero,$v0
		
			sw $t1, myArray($s1)
			addi $s1, $s1, 4
			addi $s2, $s2, 1
		
			j while
							
		exit:	
			add $s1, $zero, $zero
			jal print
			
		
		#loop to ask user what they wanna execute
		menuLoop:
			li $v0,4
			la $a0, menu
			syscall
			
			li $v0, 4
			la $a0, choice
			syscall
			
			li $v0, 12
			syscall
			
			move $s3, $v0
						
			ifA:
				bne $s3, 'a', ifB
				#print result
				li $v0, 4
				la $a0, max
				syscall
				add $a1, $s0, $zero
				add $a2, $s1, $zero
				jal findMax
				
				li $v0, 1
				add $a0, $v1, $zero 
				syscall
				j menuLoop
				
				
			ifB:
				bne $s3, 'b', ifC
				jal findMax
				add $a1, $v1, $zero
				add $a2, $zero, $zero
				add $a3, $s0, $zero
				jal howManyMax
				
				#print
				li $v0, 4
				la $a0, maxNum
				syscall
				li $v0, 1
				add $a0, $v1, $zero
				syscall
				
				j menuLoop
								
			
			ifC:
				bne $s3, 'c', ifD
				jal findMax
				add $a1, $v1, $zero
				add $a2, $s0, $zero
				add $a3, $zero, $zero
				
				#print
				li $v0, 4
				la $a0, divisibleNum
				syscall
				jal canDivideMax
				
				li $v0,1
				add $a0, $v1, $zero
				syscall
				
				
				j menuLoop
				
				
			ifD: 
				beq $s3, 'd', quit
				j menuLoop
		
			
			
		quit:
			li $v0, 10
			syscall
	
	print:
		add $t2, $zero, $zero
		
		printLoop:
			
			beq $s0, $t2, end
			lw $t3, myArray($s1)
			li $v0,1
			add $a0, $zero, $t3
			syscall
			
			addi $s1, $s1, 4
			addi $t2, $t2, 1
			
			
			j printLoop
		end:
			add $s1, $zero, $zero
			jr $ra
		
		
	findMax:
	 	lw $t5, myArray($a2)
		sll $a1, $a1, 2
		maxLoop:
			beq $a2, $a1, done
			addi $a2, $a2, 4
			lw $t6 myArray($a2)
			ifBigger:
				slt $t7, $t6, $t5
				bne $t7, $zero, next
				add $t5, $t6, $zero
				j maxLoop
			next:
				j maxLoop
		done:
			add $v1, $t5, $zero
			jr $ra
			
			
	howManyMax:
		# $t5 = max
		add $t5, $a1, $zero
		#count = 0
		add $t6, $zero, $zero
		# index 
		add $t4, $zero, $zero
		lw $t7, myArray($a2)
		countMax:
			beq $a3, $t4, endCount
			ifEqual:
				bne $t5, $t7, skip
				addi $t6, $t6, 1
				
				 
			skip: 
				addi $t4, $t4, 1
				addi $a2, $a2, 4
				j countMax 
			
		endCount:
			add $v1, $t5, $zero
			jr $ra
		
	canDivideMax:
		#max num
		add $t4, $a1, $zero
		#size
		add $t5, $a2, $zero
		#index
		add $t6, $zero, $zero
		
		
		#count 
		add $v1, $zero, $zero
		
		canDivideMaxLoop:
			beq $t5, $t6, canDivideDone
			lw $t7, myArray($a3)
				ifNotMax:
					beq $t4, $t7, skipToNext
					div $t4, $7
					mfhi $t2
					ifDivides:
						beq $zero, $t2,skipToNext
						addi $v1, $v1, 1
					
				skipToNext:
					addi $a3, $a3, 4
					addi $t6, $t6, 1
					j canDivideMaxLoop	
			
			
		canDivideDone:
			jr $ra
			
