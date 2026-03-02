.data
userInput: .asciiz "\nEnter the register number (0-31): "
errorMsg: .asciiz "Error: Invalid input. Please enter a number between 0 and 31."
newLine: .asciiz "\n"

.text

main:
mainLoop:
    # Get user input
    li $v0, 4
    la $a0, userInput
    syscall

    li $v0, 5
    syscall

    # Check if input is within range
    blt $v0, 0, inputError
    bgt $v0, 31, inputError

    # If input is valid, jump to subprogram
    move $a0, $v0  # Pass the register number to registerCount
    jal registerCount

    # Print result and exit
    move $a0, $v0
    li $v0, 1
    syscall

    j mainLoop

inputError:
    # Print error message and exit
    li $v0, 4
    la $a0, errorMsg
    syscall

    li $v0, 10
    syscall

registerCount:
    addi $sp, $sp, -32
    sw $s6, 28($sp)
    sw $s5, 24($sp)
    sw $ra, 20($sp)
    sw $s0, 16($sp)
    sw $s1, 12($sp)
    sw $s2, 8($sp)
    sw $s3, 4($sp)
    sw $s4, 0($sp)

    add $s0, $a0, $zero
    add $s1, $zero, $zero  # Initialize the count to 0

    la $s2, registerCount # Load address of instruction_start

loop:
    lw $s3, 0($s2)  # Load the instruction
    beq $s3, $zero, done  # If the instruction is 0, we are done

    # Check the instruction type (R or I)
    andi $s4, $s3, 0xFC000000  # Extract the opcode field
    beq $s4, $zero, check_r_type  # If opcode is zero, it's an rtype instruction
    
check_i_type:
    # Check source register (rs) and target register (rt) for I-type instructions
    andi $s4, $s3, 0x03E00000  # Extract the rs field
    srl $s4, $s4, 21  # Shift rs field to the rightmost 5 bits
    andi $s5, $s3, 0x001F0000  # Extract the rt field
    srl $s5, $s5, 16  # Shift rt field to the rightmost 5 bits
    # Check if the source or target register matches $s0
    bne $s4, $s0, n3
    addi $s1, $s1, 1
    n3:
    bne $s5, $s0, donecount
    addi $s1, $s1, 1
   
    j donecount


check_r_type:
    # Check source register (rs), target register (rt), and destination register (rd) for R-type instructions
    andi $s4, $s3, 0x03E00000  # Extract the rs field
    srl $s4, $s4, 21  # Shift rs field to the rightmost 5 bits
    andi $s5, $s3, 0x001F0000  # Extract the rt field
    srl $s5, $s5, 16  # Shift rt field to the rightmost 5 bits
    andi $s6, $s3, 0x0000F800  # Extract the rd field
    srl $s6, $s6, 11  # Shift rd field to the rightmost 5 bits
    # Check if the source, target, or destination register matches $s0
    bne $s4, $s0, n1
    addi $s1, $s1, 1
    n1:
    bne $s5, $s0, n2
    addi $s1, $s1, 1
    n2:
    bne $s6, $s0, donecount
    addi $s1, $s1, 1
    j donecount
    
donecount:
    addi $s2, $s2, 4  # Move to the next instruction
    j loop  # Repeat the loop

done:
    # Return the count in $s1
    add $v0, $s1, $zero

    # Restore values from stack
    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    addi $sp, $sp, 32
    jr $ra
               
