

# calculations program


.data
	a: .asciiz "first integer(a): "
	b: .asciiz "second integer(b): "
	c: .asciiz "third integer(c): "



.text
	main: 
		li $v0, 4
		la $a0, a
		syscall
		
		li $v0, 5
		syscall
		
		# $s0 = a
		add $s0, $v0, $zero
		
		li $v0, 4
		la $a0, b
		syscall
		
		li $v0, 5
		syscall
		
		# $s1 = b
		add $s1, $v0, $zero
		
		li $v0, 4
		la $a0, c
		syscall
		
		li $v0, 5
		syscall
		
		# $s2 = c
		add $s2, $v0, $zero
		
		# $s3 = 2*a
		addi $t0, $zero, 2
		mult $s0, $t0
		mflo $s3
		
		# $s3 = 2*a -b
		sub $s3, $s3, $s1
		
		# $s4 = a + b
		add $s4, $s0, $s1
		
		# $s3 = $s3 / $s4
		div $s3, $s4
		mflo $s3
		
		li $v0, 1
		move $a0, $s3
		syscall
		
		
		
		li $v0, 10
		syscall
