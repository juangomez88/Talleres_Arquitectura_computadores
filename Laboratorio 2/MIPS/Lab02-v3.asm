.data
###########################################################   MENSAJES  #################################################################################################################
mensajeRuta:		.asciiz "\n Ingrese ruta del archivo que desea cargar: \n"
			.align 2
mensajeIngresarPalabra:	.asciiz "\n Ingrese la palabra a buscar en la sopa de letras:\n "
			.align 2
mensajeEncontrada:	.asciiz "La palabra fue encontrada en: "
			.align 2
mensajeNoEncontrada:	.asciiz "\n No se encontró la palabra que busca\n"
			.align 2
mensajeBuscarOtra:	.asciiz "\n ¿Quiere buscar otra Palabra?\n Ingrese (1) para continuar buscando palabras\n Ingrese (2) para no buscar mas palabras\n"
			.align 2
mensajeOpciones:		.asciiz "\nSeleccione una opción valida (y) ó (n)\n"
			.align 2
fila:			.asciiz "\n fila: "
			.align 2
columna:			.asciiz "\n columna: "
			.align 2
mensajeFinalizar:		.asciiz "... Terminando ejecución del programa...\n"
			.align 2
			
#########################################################################################################################################################################################

opc1:			.asciiz "1"				# Opcion que indicar aceptacion
			.align 2
opc2:			.asciiz "2"				# Opcion para indicar negacion
			.align 2
bufferPalabra:		.space 200 				# Dirección de las palabras que escribirá el usuario (aleatoria)
			.align 2
bufferBuscarPalabra:	.space 3					# Dirección luego de la pregunta al usuario de buscar otra palabra
			.align 2
archivo: 		.space 5054				# Dirección de la url del archivo ingresada por el usuario
			.align 2
archivoModificado:	.space 5054				# Dirección del archivo luego de modificar
			.align 2
spaces:			.asciiz ""     				# Se usa para almacenar los caracteres leidos del archivo
			
#########################################################################################################################################################################################
.text
main: 								# Inicio del Programa

# Se inician los registros temporales $t1 -$t6 a cero

solicitarArchivo: 							
	add $t1, $zero, $zero 						
	add $t2, $zero, $zero 						
	add $t3, $zero, $zero 						
	add $t4, $zero, $zero 						
	add $t5, $zero, $zero 						
	add $t6, $zero, $zero 						
	
	li $v0, 4						# Syscall para imprimir string
	la $a0,	mensajeRuta					# Mensaje al usuario solicitando dirección del archivo
	syscall

	li $v0, 8 						# Syscall para leer string
    	la $a0, archivo						# $a0 = dirección del bufer de entrada que apunta al archivo de la direccion ingresada
    	li $a1, 1024						# Espacio maximo de cantidad de caracteres de la ruta del archivo
    	syscall
        
    	la $t1, archivo 						# Se carga en t1 la dirección de la url del archivo sin modificar
    	la $t2, archivoModificado 					# Se carga en t2 la dirección donde se alojará la direccion del archivo modificado
  	add $t3, $t1, $zero 					# Se hacemos una copia de la direccion del archivo sin modificar en $t3
  	add $t4, $t2, $zero 					# Se hacemos una copia de la direccion del archivo modificado en $t4
	addi $t5, $t5, 10  					# Se le lleva al registro $t5 el valor 10 ( nueva linea en ASCII )para saber cuando hemos llegado al final de la cadena ingresada
                             
editarUrl:	 			# Se elimina de la la url o ruta o nombre del archivo el enter \n  	
	lb $t6, 0($t3)						# $t6, almacena el caracter leido de t3, es decir caracter de la url que limpiaremos
	beq $t6, $t5, verificarArchivo 				# Si (caracter == \n, entonces finalizamos la lectura y validaremos si es un archivo correcto
	sb $t6, 0($t4) 						# Se almacena en $t6 el byte de la direccion de memoria de la url del archivo modificado
	addi $t3, $t3, 1 						# Se avanza al siguiente caracter de la url que estamos limpiando
	addi $t4, $t4, 1 						# Se avanza a una posición disponible para guardar el siguiente caracter en archivoModificado
	j editarUrl						# Se entra al ciclo de la subrutina editarUrl	
			
verificarArchivo:							# validamos si la ruta del archivo es correcta			
	add $t3, $zero, $zero					# Se lleva a cero el registro $t3
	add $t4, $zero, $zero					# Se lleva a cero el registro $t4
	add $s4, $t2, $zero					# Se guarda la direccion del archivo de la sopa de letras
	add $t2, $zero, $zero					# Se lleva a cero el registro $t2
        
	li $v0, 13						# Syscall para abrir archivo
	la $a0, archivoModificado					# a0 = dirección del bufer de entrada url modificada
	li $a1, 0						# Modo lectura flag
	syscall
	
	add $s0, $v0, $zero					# guardamos en s0 el descriptor
	slt $t1, $v0, $zero					# si (v0 < 0)? t1=1: t1=0;
	bne $t1, $zero, solicitarArchivo 				# Si no encuentra el archivo, vuelve a preguntar por archivo, si( t1 != 0) solicitarArchivo
	
					# El archivo existe, se copia datos a memoria									
	
	li $v0, 14   						# Syscall para leer datos desde el archivo
	add $a0, $s0, $zero					# Descriptor del archivo $a0 = $s0
	la $a1, spaces						# El búfer de entrada es el área de memoria donde se almacenarán los datos leídos del archivo.
	li $a2, 5054						# Es la cantidad maxima de caracteres que serán volcados del archivo a memoria
	syscall
	
	add $s5, $v0, $zero					# Se lleva a $s5 el valor de $v0 para almacenar la cantidad de caracteres leídos
	add $a0, $s0, $zero					# pasamos el descriptor 
	li $v0, 16						# cerrar archivo
	syscall			
	
	add $s2, $a1, $zero					# Base del buffer del contenido del archivo
	add $t0, $s2, $zero					# Se hace una copia del contenido para recorrer el buffer
	
	addi $t5, $zero, 13  					# Es para saber cuando hemos llegado al final de la fila (decimal 13 en ASCII = retorno de carro)
	
solicitarPalabras:													
	add $t1, $zero, $zero					# Se inica el registro en 0 para volver a leer palabras
	
	li $v0, 4						# Syscall para imprimir string
	la $a0,	mensajeIngresarPalabra				# Mensaje para pedir las palabras
	syscall							

	li $v0, 8 						# Sycall para leer string,  
    	la $a0, bufferPalabra					# $a0 = dirección del bufer de entrada apunta a las palabras
    	li $a1, 100						# $a1 = número máximo de caracteres para leer
    	syscall
       
    	la $t1, bufferPalabra					# Se guarda la dirección la dirección de memoria de la pabra a buscar en el registro $t1	
    	add $s3, $t1, $zero					# Se hacemos copia de la dirección en memoria de la palabra
	
	lb $t4, 0($t1)  						# Se carga el byte de la letra de la palabra a buscar
	addi $s0, $zero, 1					# Identificador filas
	addi $s1, $zero, 1					# Identificador columna

bucleFila:  
	lb $t3, 0($t0)						# $t3, almacena el caracter leido de t0, es decir caracter de la fila de la sopa de letras
	beq $t3, 13, cambiarFila 					# Si $t3 == retorno de carro (13 en ASCII ) entonces pasamos a la fila abajo	
	beq $t3, 10, cambiarFila					# Si $t3 == neva linea (10 en ASCII ) entonces pasamos a la siguiente columna abajo
	beq $t3, 9, cambiarColumna 			 	# Si $t3 == tab horizontal ( 9 en ASCII ) entonces debemos pasar a la fila de abajo	
	beq $t3, $zero, palabraNoEncontrada 			# Si $t3 == null ( cero en ASCII ) se ha recorrido toda la sopa de letras sin encontrar la palabra
	beq $t3, $t4, calcularIndiceMovimiento			
	addi $t0, $t0, 1
	lb $t3, 0($t0)
	beq $t3, 32, bucleFila					# Si $t3 == espacio ( 32 en ASCII ) se reinicia el ciclo
	addi $s1, $s1, 1						# aumentar columna
	j bucleFila
									            
cambiarFila:
 	addi $t0, $t0, 2						# aumentamos a la "otra fila", se asume que esta despues del enter
 	addi $s0, $s0, 1						# aumenta fila
 	addi $s1, $zero, 1					# reincia columna
 	j bucleFila
 	
cambiarColumna:
 	addi $t0, $t0, 1						#aumentamos al siguiente caracter de la sopa de letra	
 	j bucleFila
        
calcularIndiceMovimiento: 						 
 	addi $t6, $zero, 201 					# Se asume que es un valor constante desplazamiento vertical
 	addi $t7, $zero, 2 					# desplazameinto horizontal
 	
 	add $t2, $zero, $t0					# Se guarda la dirección de descubrimiento
 
movimiento:
 	
 	jal movimientoDerecha
 	bne $s6, $zero,  terminarMovimiento				# Se encuentra la palabra a la derecha 	
 	jal movimientoIzquierda
 	bne $s6, $zero,  terminarMovimiento				# Se Encuentra la palabra a la izquierda
 	#jal movimientoArriba
 	#bne $s6, $zero,  terminarMovimiento
 	#jal movimientoAbajo
 	#bne $s6, $zero,  terminarMovimiento				
	 	
 	
 	beq $s6, $zero,  cambiarColumna
 	
 	j solicitarPalabras	
 	
terminarMovimiento: 							
 	j buscarOtraPalabra	
 	
movimientoDerecha:
	addi $sp, $sp, -4 					# Reserva 2 palabras en pila (8 bytes)			
	sw $ra, 0($sp) 						# Se guarda la pila
	
	add $t0, $t0, $t7						# Se aumenta indice para avanzar en las letras de la sopaletra
	lbu $t8, 0($t0)						# Se guarda caracter siguiente de la sopaletra
	addi $t1, $t1, 1						# Aumentamos indice para avanzar en el caracter de la palabra a buscar
 	lb $t9, 0($t1)						# Caracter siguiente de la palabra a buscar
 
 	jal comprobarFinal
 	lw $ra, 0($sp) 						# restaurar pila
	addi $sp, $sp, 4
 	
 	bne $s6, $zero, infoPalabra  				# Se ha encontrado toda la palabra por la derecha
 	beq $t8, $t9, movimientoDerecha
 	
	add $a0, $t2, $zero					# Argumento de la funcion para saber desde donde reiniciar
	j reiniciarIndice 
 			
reiniciarIndice:
 	add $t0, $a0, $zero					# Se lleva a cero el indice a la posicion encontrada
 	add $t1, $s3, $zero					# Se lleva a cero el indice a la posición del primer caracter de la palabra buscada

 	jr $ra

movimientoIzquierda: 
	addi $sp, $sp, -4 					# Reserva 2 palabras en pila (8 bytes)			
	sw $ra, 0($sp) 						# Se guarda pila 
	
	sub $t0, $t0, $t7						# Se aumenta el indice para avanzar en las letras de la sopaletra
	lb $t8, 0($t0)						# caracter siguiente de la sopaletra
	addi  $t1, $t1, 1						# aumentamos indece para avanzar en el caracter de la palabra a buscar
	lb $t9, 0($t1)						# caracter siguiente de la palabra a buscar
 	
	jal comprobarFinal					# Se verifica si se recorrio toda la palabra
	lw $ra, 0($sp) 						# Se restaura la pila
	addi $sp, $sp, 4
 
	bne $s6, $zero, infoPalabra  				# Se ha encontrado toda la palabra por la derecha
	beq $t8, $t9, movimientoIzquierda
	addi $t0, $t0, -1   

	add $a0, $t2, $zero					# Argumento de la funcion para saber desde donde reiniciar
	j reiniciarIndice
######################################################################### 
movimientoArriba:
 	addi $sp, $sp, -4 								
	sw $ra, 0($sp) 							 
	
	sub $t0, $t0, $t6							
 	lbu $t8, 0($t0)							
 	add $t1, $t1, 1							
 	lb $t9, 0($t1)							
 	
 	jal comprobarFinal
 	lw $ra, 0($sp) 							
	addi $sp, $sp, 4
 	
 	bne $s6, $zero, infoPalabra  					 	
 	beq $t8, $t9, movimientoArriba					

	add $a0, $t2, $zero						
 	j reiniciarIndice
 	
movimientoAbajo:
 	addi $sp, $sp, -4 									
	sw $ra, 0($sp) 							
	
	add $t0, $t0, $t6
	lb $t8, 0($t0)
	addi $t1, $t1, 100
	lb $t9, 0($t1)
	
	jal comprobarFinal
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	bne $s6, $zero, infoPalabra
	beq $t8, $t9, movimientoAbajo
	
	j reiniciarIndice
	

#########################################################################
				
finMovimientoAbajo:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
 
comprobarFinal:
	bne $t9, 10, noFinalPalabraBuscada				# si t9 != 10, entonces no se ha llegado al final de la palabra buscada					
	addi $s6, $zero, 1					# Bandera para saber si hemos encontrado la palabra, 1 = encontrada, 0 = no encontrada					
	jr $ra							# retornar la pila
	
infoPalabra:
 	li $v0, 4
 	la $a0, mensajeEncontrada
 	syscall
 	
 	li $v0, 4
 	la $a0, fila
 	syscall
 	
 	li $v0, 1
 	la $a0, ($s0)
 	syscall
 	
 	li $v0, 4
 	la $a0, columna
 	syscall
 	
 	li $v0, 1
 	la $a0, ($s1)
 	syscall

 	add $a0, $s2, $zero					# argumento de la funcion para saber desde donde reiniciar
 	j reiniciarIndice
     
noFinalPalabraBuscada:
	addi $s6, $zero, 0					# hacemos esto 0 dado que no hemos llegado al final
	jr $ra
                      
palabraNoEncontrada:		
	li $v0, 4
 	la $a0, mensajeNoEncontrada
 	syscall
 		
buscarOtraPalabra:	
	addi $sp, $sp, -20 				# Reserva 2 palabras en pila (8 bytes)			
	sw $s3, 0($sp) 
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t6, 16($sp)
		
	li $v0, 4					# pregunta si quiere buscar otra palabra
 	la $a0, mensajeBuscarOtra
 	syscall
 		
 	li $v0, 8 					# Syscall de lectura de String,  
    	la $a0, bufferBuscarPalabra			# $a0 = dirección del bufer de entrada (la dirección de "buffer" apuntará a las respuesta)
    	li $a1, 3					# $a1 = número máximo de caracteres para leer
    	syscall
       
    	la $t1, bufferBuscarPalabra			# guardamos la dirección la dirección de memoria en el cpu, en el registro $t1	
    	add $s3, $t1, $zero
    	lb $t6, 0($t1)

    		
    	lb $t2, opc1					# Cargo el valor de y en la variable temporal $t2
	lb $t3, opc2					# Cargo el valor de n en la variable temporal $t3
		
	beq $t6, $t2, continuarBuscando
	bne $t6, $t3, opcionInvalida
		
	li $v0, 4
 	la $a0, mensajeFinalizar
 	syscall
 		
 	j exit
 	
continuarBuscando:	
    	lw $s3, 0($sp) 					# restaurar la pila
    	lw $t1, 4($sp) 
    	lw $t2, 8($sp) 
    	lw $t3, 12($sp) 
    	lw $t6, 16($sp) 						
	addi $sp, $sp, 20  
	add $t0, $s2, $zero
	j solicitarPalabras  	
 
opcionInvalida:
 	li $v0, 4					# Syscall para imprimir un String
	la $a0, mensajeOpciones
	syscall
 		
 	lw $s3, 0($sp) 					# restaurar la pila
    	lw $t1, 4($sp) 
    	lw $t2, 8($sp) 
    	lw $t3, 12($sp) 
    	lw $t6, 16($sp) 					
	addi $sp, $sp, 20  
 		
 	j buscarOtraPalabra
				
		
        
exit: 	li $v0, 10					#Syscall para terminar el programa
	syscall       
        
