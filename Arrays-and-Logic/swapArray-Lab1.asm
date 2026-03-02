

# part1.1
# swap array elements program

.data
	myArray: .space 80  #size of 20 elements
	prompt: .asciiz "The number of elememts: "
	originalArray: .asciiz "\nOrignal array :"
	swapped: .asciiz "\nArray swapped from middle: "
	gap: .asciiz " "

.text
	main:
		li $v0, 4
		la $a0, prompt
		syscall
		
		#getting user integer input
		li $v0, 5
		syscall
		
		#store the input
		add $s0, $zero, $v0
		#store array size 
		add $t3, $zero, $s0
		#multiply with 4 to align with memory space
		sll $s0, $s0, 2
		
		#i = 1
		addi $s1, $zero, 1
		
		#index = 0
		addi $s2, $zero, 0
		
		#loop to fill the array
		while: 
			beq $s2, $s0, exit
			sw $s1, myArray($s2)
			addi $s2, $s2, 4
			addi $s1, $s1, 1
			j while
		exit:
			addi $s2, $zero, 0
		
			#print original array
			li $v0, 4
			la $a0, originalArray
			syscall
			
			#loop to print array elements
			jal print
			# find the middle index
			addi $t1, $zero, 2
			div $t3, $t1
			mflo $t2
				
			#loop to swap
			#count = 0
			add $t4, $zero, $zero
			addi $t3, $s0, -4
			swap: 
				beq $t2, $t4, end
				lw $t0, myArray($s2)
				
				lw $t1, myArray($t3)
				
				sw $t1, myArray($s2)
				sw $t0, myArray($t3)
				
				addi $t4, $t4, 1
				addi $s2, $s2, 4
				addi $t3, $t3, -4
				j swap
					
			end:
				addi $s2, $zero, 0
				li $v0, 4
				la $a0, swapped
				syscall
				jal print
			
			li $v0, 10
			syscall
			
		print:
			printLoop:
				beq $s2, $s0, finish
				lw $t0, myArray($s2)
				addi $s2 , $s2, 4
				li $v0, 1
				add $a0, $t0, $zero
				syscall
				
				#print comma and gap 
				li $v0, 4
				la $a0, gap
				syscall
				
				j printLoop
				
			finish:
			
				addi $s2, $zero, 0
				jr $ra
		
