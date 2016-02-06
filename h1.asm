# Compute several Fibonacci numbers and put in array, then print
.data

errorMessage: .asciiz "Invalid size, max size is 250 ints\n"
list: .space 1000 # resevers a block of 1000 bytes, hold up to 250 int values  
promptN: .asciiz "Enter the number of integers you want to sort \n"
promptList: .asciiz "Enter a list of integers separated by a comma \n"
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

     #prompt for list of integers
      la $a0, promptList #ask for list of integers
      li $v0, 4 # load string to print
      syscall
 #############################################
 #  Read User Input into address of list
 #############################################
      li $v0, 8 # read string
      la $a0, list # allocate enough space for a string
      li $a1, 1000 #print string
      move $s1, $a0 # save array to s1
      syscall
      
      jal storeIntegers
      
Lsort:
	j Out
      
   
################################################################################################################
#####   Procedure: Loop string
#####   Info:      Loops through the ten elements of chars gathered from 
#####              user input and if ascii is in range between 97  
#####              and 122, it will subtract 32 and store back
################################################################################################################   
storeIntegers:   
      
      add $t0,$zero, $zero  # Set index i = 0 ($t0)
  L1: add $t1, $s1 ,$t0 #t1 holds address of integer array
      li  $t2, 0($t1) #t2 holds value or array[i]
      beq $t2, 0xa, Out #if we reach a new line char of string break from loop
      #add $a0, $t2, $zero #move character to v0 to print
      #lw  $v0, 11           # service 1 is print integer
      #syscall 
      #Loop body
Lbody: beq $t2, 0x2c, storeInt # if character equals comma (0x2c is HEX for ",") 
#Contatinate current char to temp
	or $t3, $t3, $t2       
inc: addi $t0, $t0, 1  #increase i, (t0)

      j	   L1
storeInt: 
	#Pre: allocate memory for array
	# Store integer T3 into s2[t4]
	# Clear temp, t3
	# Jump back inc
	j inc
	
      
            
                        
Out: #add   $t3, $s2, $t0       # $t3 holds address of x[i]
       #sb   $zero, 0($t3)       # x[i] = 0 (to terminate string)
      jr $ra
exit:
      
      
      
      
      
