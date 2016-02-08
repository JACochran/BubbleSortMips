# Compute several Fibonacci numbers and put in array, then print
.data

errorMessage: .asciiz "Invalid size, max size is 250 ints\n"
list: .space 1000 # resevers a block of 1000 bytes, hold up to 250 int values  
promptN: .asciiz "Enter the number of integers you want to sort \n"
promptList: .asciiz "Enter the next integer: \n"
maxSize: .word 250

.text
# Prompt user to input  the number of Integers in list 
main: 
      la   $a0, promptN     # load address of prompt for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the prompt string
      li   $v0, 5           # specify Read Integer service, 5 is to read integers
      syscall               # Read the number. After this instruction, the number read is in $v0.
      add $s0, $v0, $zero   # transfer the number to the desired register  
      #prompt for each integer
      jal getIntegers
      j   exit
      
################################################################################################################
#####   Procedure: Loop Integer
#####   Info:      Loops through 1 - number of integers the user specified
#####   to store (located in $s0) and asks for an integer.  Which will be stored
#####   into the array ($s2)
################################################################################################################   
getIntegers:  
	la   $s2, list          # $s2 = array address
        add  $t0,$zero, $zero   # Set index i = 0 ($t0)
prompt: la   $a0, promptList    #ask for list of integers
        li   $v0, 4             # load string to print
        syscall
        li   $v0, 5             #read integer service 5 is to read integers
        syscall
        sw   $v0, ($s2)	        #store value
        addi $s2, $s2, 4        #step to next array cell
        addi $t0, $t0, 1        #increase index i
	beq  $t0, $s0, Out      #break from loop if we got all the numbers requested
	j prompt
                            
Out: jr $ra
exit: