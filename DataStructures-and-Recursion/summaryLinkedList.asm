.data
	numPrompt: .asciiz"\nHow many nodes do you want: "
	prompt: .asciiz"Enter your values one by one(key number then data then next key...): "
	original: .asciiz "\nOriginal linked list: "
	summary: .asciiz "\nSummary linked list: "
	p1: .asciiz "("
	comma: .asciiz ","
	p2: .asciiz ")"
	gap: .asciiz " "
	arrow: .asciiz "--->"
	newLine: .asciiz "\n"
	sumNumNode: .asciiz "\nThe number of nodes in the summary linked list: "
.text
	main:
		li $v0, 4
		la $a0, numPrompt
		syscall
		
		li $v0, 5
		syscall
		
		# $s0 = num of nodes
		add $s0, $v0, $zero
		
		li $v0, 4
		la $a0, prompt
		syscall
		
		add $a0, $s0, $zero
		jal createLinkedList
		# $s1 points to linked list
		move $s1, $v0
		
		li $v0, 4
		la $a0, original
		syscall
		
		
		# give address of list to print
		move $a0, $s1
		jal printLinkedList
		
		move $a0, $s1
		jal generateSummary
		
		move $s4, $v1
		
		move $s3, $v0
		li $v0, 4
		la $a0, summary
		syscall
		move $a0, $s3
		jal printLinkedList
		
		li $v0, 4
		la $a0, sumNumNode
		syscall
		
		li $v0,1
		move $a0, $s4
		syscall
		
		
		
		
	li $v0, 10
	syscall
		
		
	createLinkedList:
		# $a0= num of nodes
		# $v0 returns list head
		
		# store values to stack
		addi $sp, $sp, -24
		sw $ra, 20($sp)
		sw $s0, 16($sp)
		sw $s1, 12($sp)
		sw $s2, 8($sp)
		sw $s3, 4($sp)
		sw $s4, 0($sp)
		
		# $s0 = num of nodes
		add $s0, $a0, $zero
		# $s1 = node counter
		li $s1, 1
		
		#create head(every node 12 bytes, link then data)
		li $a0, 12
		li $v0, 9 
		syscall
		
		#save list head pointer
		add $s2, $v0, $zero #points to first and last node
		add $s3, $v0, $zero #points to the list head
		
		li $v0, 5
		syscall
		sw $v0, 4($s2)
		li $v0, 5
		syscall
		sw $v0, 8($s2)
		
		addNodeLoop:
			beq $s1, $s0, done
			addi $s1, $s1, 1  # increment node counter
			li $a0, 12
			li $v0, 9
			syscall
			
			#connect node to list
			sw $v0, 0($s2)
			
			move $s2, $v0 # $s2 points to the new node now
			
			li $v0, 5
			syscall
			
			sw $v0, 4($s2)
			
			li $v0, 5
			syscall
			sw $v0, 8($s2)
			
			j addNodeLoop
			
		done:
			sw $zero, 0($s2) # last pointer is null
			move $v0, $s3 # $s3 points to list head and will be returned
			
			# restore values
			lw $s4, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $ra, 20($sp)
			addi $sp, $sp, 24
			
			jr $ra
			
	printLinkedList:
		#store values to stack
		addi $sp, $sp, -24
		sw $ra, 20($sp)
		sw $s0, 16($sp)
		sw $s1, 12($sp)
		sw $s2, 8($sp)
		sw $s3, 4($sp)
		sw $s4, 0($sp)
		
		
		# $a0 points to the linked list
		move $s0, $a0	# $s0 points to the current node
		li $s3, 0	# $s3 = node counter
		
		li $v0, 4
		la $a0, arrow
		syscall
		printNext:
			beq $s0, $zero, printed
			# $s1= address of next node
			lw $s1, 0($s0)
			lw $s2, 4($s0)
			lw $s4, 8($s0)
			
			addi $s3, $s3, 1
			
			li $v0, 4
			la $a0, p1
			syscall
			
			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, comma
			syscall
			
			li $v0, 1
			move $a0, $s4
			syscall
			
			li $v0, 4
			la $a0, p2
			syscall
			
			#move to next node
			move $s0, $s1
			
			ifEnd:
				beq $s0, $zero, printed
				li $v0, 4
				la $a0, arrow
				syscall
			
			j printNext
			
		printed:
			
			#restore values from stack
			lw $s4, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $ra, 20($sp)
			addi $sp, $sp, 24
			
			jr $ra
		
		
	generateSummary:
		#store values to stack
		addi $sp, $sp, -32
		sw $ra, 28($sp)
		sw $s0, 24($sp)
		sw $s1, 20($sp)
		sw $s2, 16($sp)
		sw $s3, 12($sp)
		sw $s4, 8($sp)
		sw $s5, 4($sp)
		sw $s6, 0($sp)
		
		# $s0 = a0 points to original array
		move $s0, $a0
		
		add $v1, $zero, $zero
		
		#create summary array
		li $a0, 12
		li $v0, 9
		syscall
		addi $v1, $v1, 1
		# save list head pointer
		move $s1, $v0	#points to last and first
		move $s2, $v0	#points to head
		
		fillSummary:
			beq $s0, $zero, endFill
			# take first key of original and put it in summary $s3
			lw $s3, 4($s0)
			sw $s3, 4($s1)
			
			#$s4 = data value of key
			lw $s4, 8($s0)
			#put it in summary we will add other values if there are
			sw $s4, 8($s1)
			#move to next node in original array
			lw $s5, 0($s0)
			move $s0, $s5
			
			# now we will check if there are nodes with the same key and add them together and put in summary array
			isSame:
				beq $s0, $zero, endFill
				
				lw $s6, 4($s0)
				bne $s6, $s3, notSame
				
				lw $s7, 8($s0)
				add $s4, $s4, $s7
				sw $s4, 8($s1)
				lw $s5, 0($s0)
				move $s0, $s5
				
				j isSame
				
			notSame:
				li $a0, 12
				li $v0, 9
				syscall
				addi $v1, $v1, 1
				sw $v0, 0($s1)
				lw $s5, 0($s1)
				move $s1, $s5
				j fillSummary
				
			
			
		endFill:
			sw $zero, 0($s1)
			move $v0, $s2
			# restore the valuues
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
		
		
			
		
			