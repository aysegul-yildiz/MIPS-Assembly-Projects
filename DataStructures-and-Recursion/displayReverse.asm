.data
	prompt: .asciiz "\nEnter the nodes sequentially (first key then data value then next node's key...): "
	numPrompt: .asciiz"\nHow many nodes do you want: "
	p1: .asciiz "("
	comma: .asciiz ","
	p2: .asciiz ")"
	gap: .asciiz " "
	arrow: .asciiz "--->"
	newLine: .asciiz "\n"


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
			
		# give address of list to print
		#move $a0, $s1
		#jal printLinkedList
		 
		move $a0, $s1
		jal ReversePrint
		
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
			
	ReversePrint:
		#store valuesto stack
		addi $sp, $sp, -24
		sw $ra, 20($sp)
		sw $s4, 16($sp)
		sw $s3, 12($sp)
		sw $s2, 8($sp)
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		
		#$s0 = $a0 = point to head of list
		add $s0, $a0, $zero
		add $s4, $s0, $zero
		
		#base case= list is empty or one node
		ifAble:
			bne $s0, $zero, ifBase
		
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20
			jr $ra
			
		
		ifBase:
			lw $s1, 0($s0)
			bne $s1, $zero, reccursive
			
			li $v0, 4
			la $a0, arrow
			syscall
			
			li $v0, 4
			la $a0, p1
			syscall
			
			lw $s2, 4($s0)
			
			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, comma
			syscall
			
			lw $s2, 8($s0)
			
			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, p2
			syscall
			j end
			
			
		reccursive:
			move $a0, $s1
			
			jal ReversePrint
			notZero:
				beq $zero, $s0, end
				
				sw $zero, 0($s0)
				move $a0, $s0
				jal ReversePrint
			end:
			
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
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
		
		