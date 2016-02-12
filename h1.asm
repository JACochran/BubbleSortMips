################################################################################################################ 
################################################################################################################
#####   HW #1 CS465 Jenifer Cochran & Renzo Tejada
#####   Due Datte 						02/12/2016  
#####   Description: Program requests the value of N as input and then reads the numbers to be sorted individually
#####	Then, the program should prints "The original list is: .." followed by the list elements before sorting. Then, 
#####	buble sort is applied to the list and  the program prints "The sorted list is: " followed by the elements of 
#####	the sorted list. The sorted list has to overwrite the original list. Your program should count and output the number 
#####	of swaps involved in the sorting process for each input.
#####
################################################################################################################ 
################################################################################################################ 


################################################################################################################
#####   Procedure: Variables are initialized in .data section of memory
#####   Info:     These global variables will be accessed by the different functions of this program
################################################################################################################ 

.data 

errorMessage: .asciiz "Invalid size, max size is 250 ints\n"   #	Warns user that input n is not supported
list: .space 1000 		#	resevers a block of 1000 bytes, hold up to 250 int values  
promptN: .asciiz "Enter the number of integers you want to sort \n"  # Prompts for numbers of integers to be sorted
promptList: .asciiz "Enter the next integer: \n"	#	Prompt used to obtain numbers individually to be sorted
space: .asciiz " " 								 # space
originalListPrompt: .asciiz "\nThe Orignal List: " #	Prompt used to print input list
sortedListPrompt:   .asciiz "\nThe Sorted List: "	#	Prompt used to print sorted input list
switchesPrompt:  .asciiz "\nNumber of Switches: "	#	Prompt used to print number of swaps using Bubble_Sort Alg. list

################################################################################################################
#####   Procedure: Unitialized code, is initialized when calling functions in main.
##### 
################################################################################################################
.text

main:	# Main sequentially calls different functions of the program 
      							# Start of program
      jal getSize	  			# Step1 get n, number of integers to be sorted.
      jal getIntegers   		# Step2 prompts for integers individually until list has n elements.
      jal printOriginalList 	# Step3 Prints input integers in origial order as a String
      jal sortIntegers			# Step5 Sort list using Bubble_Sort Alg.
      jal printSortedList		# Step6 Prints sorted list as a String
      jal printNumberOfSwitches # Step7 Prints number of swaps need to sort input list
      j   exit 					# Exit program

################################################################################################################
#####   Procedure: Get array size
#####   Info:      prompts the user to input a size of the integer array
#####   this value will be stored in $s0
################################################################################################################   
getSize: 
      la   $a0, promptN     # load address of prompt for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the prompt string
      li   $v0, 5           # specify Read Integer service, 5 is to read integers
      syscall               # Read the number. After this instruction, the number read is in $v0.
      add $s0, $v0, $zero   # transfer the number to the desired register 
      j Out                 # Jumsp to Out function, to return register ra, and saved register $s0 holds n.

################################################################################################################
#####   Procedure: get Integers
#####   Info:      Loops through 1 - number of integers the user specified
#####   to store (located in $s0) and asks for an integer.  Which will be stored
#####   into the array ($s2)
################################################################################################################   
getIntegers:  
	la   $s2, list          # $s2 = array address
        add  $t0, $zero, $zero  # Set index i = 0 ($t0)
        add  $t1, $s2, $zero    # temp place holder for array address
prompt: la   $a0, promptList    #ask for list of integers
        li   $v0, 4             # load string to print
        syscall
        li   $v0, 5             #read integer service 5 is to read integers
        syscall
        sw   $v0, ($t1)	        #store value
        addi $t1, $t1, 4        #step to next array cell
        addi $t0, $t0, 1        #increase index i
	beq  $t0, $s0, Out          #break from loop if we got all the numbers requested
	j prompt
	
################################################################################################################
#####   Procedure: Print Integers
#####   Info:      Loops through 1 - number of integers the user specified
#####   to store (located in $s0) and prints the values of the array located in $a0
################################################################################################################   
printIntegers:
	add   $t0, $zero, $zero  #	set index to 0
	add   $t1, $a0, $zero    #	array pointer at $t1
loopbdy:lw    $t2, ($t1)     #	loads the integer into $t2
	li    $v0, 1			 #	asks for print service
        add   $a0, $t2, $zero# load desired value into argument register $a0, using pseudo-op
    	syscall			 
    	la    $a0, space     #	load a space as an argument for printing
	li    $v0, 4             #	ask for print service
	syscall                  #	prints a space   	
        addi  $t1, $t1, 4    #	increment pointer to array
        addi  $t0, $t0, 1    # increment index
        bne   $t0, $s0, loopbdy  # loop if index < number of integers in array
        j     Out      
################################################################################################################
#####   Procedure: Sort array
#####   Info:      Will use bubble sort to sort the array in $a0 with a size stored in $s0. 
#####   the sorted array will be saved in $s1
#####   $s3 will hold number of switches
#####  					Registers labels:
#####	s0 holds number of ints in array
#####	s2 holds address of initial value of array
#####	t0 counter for OutterLoop_loop
#####	t1 counter for innerLoop
#####	t2 will hold n-1  |  s0-1 is needed for outer loop
#####	t3 is needed for outer loop
#####	t4 holds value of n - c - 1      
#####	t5 A[d]
#####	t6 A[d+1]
################################################################################################################                     

sortIntegers:
			li $t0, 0                 #t0 counter for outer loop initialized to zero
	OutterLoop:
			li  $t1, 0   	          # Initialize ****t1 counter for outer loop
			add $t2, $zero, $zero	  #
			li  $t2, -1 	 
			add $t2, $s0, $t2         # n-1= t2
			slt $t7, $t0, $t2         # check whether t1   < n-1
			beq $t7, $zero Out  	  # if true jump out of loop
	innerLoop:
			sub $t4, $t2, $t0         # t4= n - c - 1
			slt $t3, $t1, $t4         #	check whether counter of innerLoop loop  < n-1-c
			beq $t3, $zero, incT1ctr  #	if t3 is equal to zero means that counter =  n-1-c.  Branches out of loop from innerLoop loop to to outer
			### load values to of unsorted input list to registers $t5 and $t6
			sll $t3, $t1, 2 		  # t3 holds the offset to access input list. Note, t3 is overwritten here, its not connected to line above.
			add $t3, $t3, $s2         # Offset + pointer to list
			lw $t5, 0($t3)  	 	  # $t2 <- A[j]
			lw $t6, 4($t3)            # $t3 <- A[j+1]
			bgt $t6, $t5, no_swap     # A[j] <= A[j-1]?
						 			  # Precondition: t$5 is larger than $t6
			addi $s3, $s3, 1	 	  # Update s3, which tracks number of Swaps used in the sortIntegers funtion
			sw $t6, 0($t3) 	 	 	  # A[j-1] <- $t2  \ move bubble
			sw $t5, 4($t3) 		 	  # A[j] <- $t3    / $t2 upwards
						 			  # Post-Cond: swapping occurs
	no_swap:						  # label is only called when swap is not needed
			add $t1, $t1, 1			  # increment counter of inner loop, t1
			j innerLoop				  # Jump back to inner loop
	incT1ctr:
			add $t0, $t0, 1     	  # increment counter for outer loop
			beq $t3, $zero,OutterLoop # exits outer loop once holds zero. When next element from the last element in list is zero.
			j Out  					  # Jump out of sortIntegers Function
	        
################################################################################################################
#####   Procedure: print sorted list
#####   Info:      prints the sorted list in $s1
################################################################################################################                     
printSortedList:
		la    $a0, sortedListPrompt      #load a prompt as an argument for printing
		li    $v0, 4                     # ask for print service
		syscall                          # prints a "The Sorted List: "
		add $a0, $s2, $zero		 # loads the sorted array to print
		j    printIntegers		 # prints array
		      
################################################################################################################
#####   Procedure: print original list
#####   Info:      prints the unsorted list in $s2 (in the order user gave us)
################################################################################################################                     
printOriginalList:
    		la    $a0, originalListPrompt    # load a prompt as an argument for printing
		li    $v0, 4                     # ask for print service
		syscall                          # prints a "The Original List: "
		add $a0, $s2, $zero		 # loads the original array as argument to print
		j   printIntegers		 # prints array 
################################################################################################################
#####   Procedure: print the number of switches occurred during sorting
#####   Info:      prints the number of times a switch occurred
################################################################################################################                     
printNumberOfSwitches: 
                     la $a0, switchesPrompt      # loads switches prompt to arguement
                     li $v0, 4			 # asks for print service
                     syscall			 # prints
                     add $a0, $s3, $zero	 # moves the number of switches as an argument
                     li    $v0, 1		 # asks for print service
                     syscall			 # prints
      		     j Out
Out: jr $ra
exit:
