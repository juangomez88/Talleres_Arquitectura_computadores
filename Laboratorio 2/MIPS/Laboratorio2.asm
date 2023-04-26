.data
file_in:		.asciiz "/home/juan/Escritorio/sopa.txt"
		.align 2
input_buffer:	.space 5052
sopa:		.space 2504
word_count:	.word 0			#Almacena el número de palabras
word_buffer:	.space 1000		#Reserva memoria para almacenar las palabras
		.align 2
message1:	.asciiz "¿Cuantas palabras desea buscar? "
message2:	.asciiz "Ingrese las palabras a buscar: "
message3:	.asciiz "Ingrese la siguiente palabra: "

.text
#########################################################################################
Main:
	
# Preguntar al usuario cuantas palabras desea buscar

	li $v0, 4			#System call para imprimir en pantalla
	la $a0, message1			#Imprime mensaje para el usuario
	syscall
	
# Leer la cantidad de palabras a buscar
	li $v0, 5			#System call para leer un entero
	syscall
	move $t0, $v0			#Guardar la cantidad de palabras a buscaren $t0
	
# Imprimir un mensaje pidiendo al usuario que ingrese las palabras
	li $v0, 4			#System call para imprimir
	la $a0, message2			#Imprime mensaje para el usuario															
	syscall
	
# Leer las palabras ingresadas por el usuario y almacenarlas en memoria
	li $t1,0				#Inicializar contador de palabras
	la $t2, word_buffer		# inicializar puntero al inicio del buffer de palabras
	
loop_words:
#imprimir mensaje pidiendo ingrese la siguiente palabra
	li $v0, 4			# System call para imprimir
	la $a0, message3			# Imprime mensaje para el usuario	
	syscall
	
# Leer la siguiente palabra ingresada por el usuario
	li $v0, 8			# System call para leer una cadena
	la $a0, ($t2)			# Puntero al inicio del buffer de palabras
	li $a1, 256			# Máxima longitud de la cadena
	syscall
	
	addi $t1, $t1, 1			# Incrementar el contador de palabras
	
# Si se ha leido todas las palabras solicitadas, salir del bucle
	bne $t1, $t0, loop_words
	
# Open (for reading)
	li $v0, 13			#System call for open file
	la $a0, file_in			#Input file name
	li $a1, 0			# Open reading (flag = )
	#li $a2,0			#Mode is ignored
	syscall
	move $s0, $v0			#copy file descriptor
# Read from previously opened file
	li $v0, 14
	move $a0, $s0			#System call
	la $a1, input_buffer		
	li $a2, 5052			#Maximum numbre of charecter
	syscall				#Read from file
	move $s1, $v0			#copy number of character

#Close the file
	li $v0, 16			# System call for close file
	move $a0, $s0			# file descriptor to close
	syscall



	la $s2, input_buffer
	la $s3, sopa
clean_loop:
	lbu $s4, 0($s2)
	beq $s4, $zero, End_clean
	beq $s4, 0x20, ptr_updt
	beq $s4, 0x0d, ptr_updt		#0x0d codigo de retorno de carro
	beq $s4, 0x0a, ptr_updt		#0x0a codigo de salto de linea
	sb $s4, 0($s3)
	addi $s3, $s3, 1
	
ptr_updt:
	addi $s2, $s2, 1
	j clean_loop
End_clean:

	
Exit:	li $v0, 10
	syscall 