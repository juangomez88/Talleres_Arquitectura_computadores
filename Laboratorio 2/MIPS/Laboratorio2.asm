.data
	sopa: 		.asciiz "/home/juan/Escritorio/sopa.txt"
	buffer:		.space 2500 		# Espacio de memoria para almacenar los datos leídos del archivo
	mensaje1: 	.asciiz "La cantidad de palabras a buscar: "
	cantidad_buscar: 	.word 0
	mensaje2:         .asciiz "Ingrese las palabras a buscar (una por línea): "
	palabras:	.space 200		# Espacio de memoria para almacenar las palbras que ingrese el usuario
	palabras_base: 	.word 0 			#Direccion base del espacio reservado para las palabras
	
.text
#############################################################################################################
	main:
	
	# Abrir el archivo
	la $a0 sopa			#Cargar la dirección de la cadena de caracteres del nombre del archivo
	li $v0, 13
	syscall
	
	move $s1, $v0
	
	#Leer el contenido del archivo en buffer
	
	li $v0, 14			#Código de servicio 14 para leer archivo
	la $a0, buffer			#Carga la direccion del buffer de lectura
	li $a1, 2500			#Carga la longitud máxima de lectura
	syscall
	
	# Se imprime el mensaje de busqueda de palabras 
	la $a0, mensaje1
	li $v0, 4
	syscall
	
	li $v0, 5			#Solicito servicio para cargar numero entero
	syscall 
	
	move $t0, $v0            		# Guardar la cantidad de palabras a buscar en $t0
	
	sw $t0, cantidad_buscar		# Guardo el valor ingresado en variable cantidad_buscar
	
	
	la $a0, mensaje2
	li $v0, 4
	syscall
	
	
	# Leer las palabras a buscar ingresadas por el usuario
    	la $a0, palabras         		# Cargar la dirección del espacio de memoria para almacenar las palabras
    	li $a1, 200              		# Cargar la longitud máxima de lectura
    	li $t1, 0			# Inicializar contador de palabras leídas en 0

loop_leer_palabras:
        # Leer una palabra ingresada por el usuario
        li $v0, 8
        syscall

        # Almacenar la palabra en memoria
        
        sw $a0, palabras($t1)		# Guardar la palabra en la posición de memoria correspondiente
        addi $t1, $t1, 4       		# Incrementar el contador de palabras leídas en 4 bytes

        addi $t0, $t0, -1			# Decrementar el contador de palabras a buscar en 1
        bnez $t0, loop_leer_palabras  	# Volver a leer otra palabra si quedan más por leer

    sw $t1, palabras_base     		# Guardar la dirección base del espacio reservado para las palabras
	
	

	
	li $v0, 16			#Codigo de servicio 16 para cerrar archivo
	move $a0, $s1			
	syscall 
	
	li $v0, 10			#cierre del programa
	syscall 


#############################################################################################################


#############################################################################################################


#############################################################################################################