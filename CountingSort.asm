	.globl main
	.text

main:
	# initializing array = {2, 10, 6, 8, 4, 5, 1, 4, 10, 9}
	li $t1, 2 # tmp = 2
	sw $t1, array # array[0] = tmp = 2
	li $t1, 10 # tmp
	sw $t1, array + 4 # array[1] = tmp
	li $t1, 6 # tmp
	sw $t1, array + 8 # array[2] = tmp
	li $t1, 8 # tmp
	sw $t1, array + 12 # array[3] = tmp
	li $t1, 4 # tmp
	sw $t1, array + 16 # array[4] = tmp
	li $t1, 5 # tmp
	sw $t1, array + 20 # array[5] = tmp
	li $t1, 1 # tmp
	sw $t1, array + 24 # array[6] = tmp
	li $t1, 4 # tmp
	sw $t1, array + 28 # array[7] = tmp
	li $t1, 10 # tmp
	sw $t1, array + 32 # array[8] = tmp
	li $t1, 9 # tmp
	sw $t1, array + 36 # array[9] = tmp

	li $s0, 10 # int n = 10
	lw $s1, array # int max = array[0]

	# for loop 1
	li $t0, 1 # int i = 1
	li $t1, 4 # for finding addr of array[1]
loop1:
	lw $t2, array($t1) # val of current array elem
	bgt $t2, $s1, update_max # array[i] > max
	
	addi $t0, $t0, 1 # i++
	addi $t1, $t1, 4 # addr of array += 1
	blt $t0, $s0, loop1
	j end_loop1
update_max:
	move $s1, $t2
	addi $t0, $t0, 1 # i++
	addi $t1, $t1, 4 # addr of array += 1
	blt $t0, $s0, loop1
end_loop1:
	addi $t0, $s1, 1 # max + 1
	sll $t0, $t0, 2 # (max + 1) * 4
	li $v0, 9
	move $a0, $t0
	syscall # allocate memory for count
	move $s2, $v0 # addr of count[max + 1]
	add $t2, $s2, $zero # copy of addr count
initialize:
	sw $zero, ($t2) # count[i] = 0
	addi $t2, $t2, 4
	blt $t2, $t0, initialize
	
	li $t0, 0 # int i = 0
	li $t1, 0 # for finding addr of array[0]
	# add $t2, $s2, $zero # copy of addr count
loop2:
	lw $t3, array($t1) # val of current array elem
	sll $t3, $t3, 2 # array[i] * 4
	
	add $t2, $s2, $t3 # addr of count + (array[i] * 4)
	lw $t4, ($t2) # val count[array[i]]
	addi $t4, $t4, 1 # count[array[i]]++
	sw $t4, ($t2) # initialize count[array[i]]++
	
	addi $t0, $t0, 1 # i++
	addi $t1, $t1, 4 # addr of array += 1
	blt $t0, $s0, loop2

	# third loop
	li $t0, 0 # int i = 0
	li $t1, 0 # int j = 0
final_loop:
	sll $t2, $t0, 2 # i * 4
	add $t2, $t2, $s2 # addr of count[i]
	lw $t3, ($t2) # val count[i]
	beqz $t3, next
	
	# if bigger than zero
	#sll $t4, $t3, 2
	#lw $t5, array($t1)
	#add $t4, $t4, $t5
	#sw $t0, array($t4)
	sw $t0, array($t1)
	# 2 final instructions
	addi $t1, $t1, 4 # j, index of output array
	addi $t3, $t3, -1
	sw $t3, ($t2) # count[i]--
	
	j final_loop
next:
	addi $t0, $t0, 1 # i++
   	ble $t0, $s1, final_loop
   	
   	
   	# Writing the median of 10 elements array in register $s0
   	lw $t5, array + 16 # 5th elem
   	lw $t6, array + 20 # 6th elem
   	add $t7, $t5, $t6
   	srl $s0, $t7, 1 # (array[4] + array[5]) / 2

	.data
array:
	.space 40 # 10-element integer array