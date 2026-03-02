

# part1.2
# arithmetic operations program

.data 
	B: .asciiz "first integer value(B): "
	C: .asciiz "\nsecond integer value(C): "
	D: .asciiz "\nthird integer value(D): "
	message: .asciiz "\nComputing A = (B /C + D Mod B - C) / B ..."
	result: .asciiz "\nResult: "
	
.text
	main:
		#ask and get the first value
		li $v0, 4
		la $a0, B
		syscall
		
		li $v0, 5
		syscall
		
		# $a1 = B
		add $a1, $zero,$v0
		
		#ask and get the second value
		li $v0,4
		la $a0, C
		syscall
		
		li $v0, 5
		syscall
		
		# $a2 = C
		add $a2, $zero, $v0
		
		#ask and get the third value
		li $v0, 4
		la $a0, D
		syscall
		
		li $v0, 5
		syscall
		
		# $a3 = D
		add $a3, $zero, $v0
		
		
		jal compute
		add $s2, $v1, $zero
		
		li $v0, 4
		la $a0, message
		syscall
		
		li $v0, 4
		la $a0, result
		syscall
		
		li $v0, 1
		add $a0, $s2, $zero
		syscall
		
		li $v0,10
		syscall
	
	compute:
		#store the return address
		add $t2, $ra, $zero
		# $t3 = B
		add $t3, $a1, $zero
		# $t4 = C
		add $t4, $a2, $zero
		# $t5 = D
		add $t5, $a3, $zero
		
		jal divisionBySubtraction
		# $s0 = B / C
		add $s0, $v0, $zero
		
		add $a1, $t5, $zero
		add $a2, $t3, $zero
		jal divisionBySubtraction
		# $s1 = d mod b
		add $s1, $v1, $zero
		
		# $s0 = B/C + D MOD B
		add $s0, $s0, $s1
		
		# $s0 = B/C + D MOD B - C
		sub $s0, $s0, $t4
		
		# $a1 = $s0
		add $a1, $s0, $zero
		# $a2 = B
		add $a2, $t3, $zero
		jal divisionBySubtraction
		# $s0 = (B/C + D MOD B - C) / B
		add $s0, $v0, $zero
		
		add $v1, $s0, $zero
		add $ra, $t2, $zero
		jr $ra
			
	divisionBySubtraction:
		# count = 0
		add $t0, $zero, $zero
		
		divLoop: 
			slt $t1, $a1, $a2
			bne $t1, $zero, done
			sub $a1, $a1, $a2
			addi $t0, $t0, 1
			j divLoop
		done:
			#quotient = $t0
			add $v0, $t0, $zero
			add $v1, $a1, $zero
			jr $ra
			
			
			
			