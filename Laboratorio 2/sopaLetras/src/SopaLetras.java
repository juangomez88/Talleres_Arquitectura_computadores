import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class SopaLetras {
    public static void main(String[] args) {
        try {
            // Cambia "sopa.txt" por el nombre de tu archivo de sopa de letras
            FileReader lectorArchivo;
            File archivo = new File("/home/juan/Escritorio/sopa.txt");
            lectorArchivo = new FileReader(archivo);
            BufferedReader lectorBuffer = new BufferedReader(lectorArchivo);

            // Guarda la sopa de letras en una matriz
            char[][] sopa = new char[10][10];
            for (int i = 0; i < sopa.length; i++) {
                String linea = lectorBuffer.readLine();
                for (int j = 0; j < sopa.length; j++) {
                    sopa[i][j] = linea.charAt(j);
                }
            }

            // Aquí puedes cambiar "PALABRA" por la palabra que quieras buscar en la sopa de letras
            String palabra = "DIA";

            // Busca la palabra en horizontal de izquierda a derecha
            for (int i = 0; i < sopa.length; i++) {
                for (int j = 0; j < (sopa.length - palabra.length()+1); j++) {
                    boolean encontrado = true;
                    for (int k = 0; k < palabra.length(); k++) {
                        if (sopa[i][j+k] != palabra.charAt(k)) {
                            encontrado = false;
                            break;
                        }
                    }
                    if (encontrado) {
                        System.out.println("La palabra " + palabra + " se encuentra en la fila " + (i+1) + " desde la columna " + (j+1) + " hasta la columna " + (j+palabra.length()));
                    }
                }
            }

            //Buscar palabra en horizontal de derecha a izquierda
            for (int i = 0; i < sopa.length; i++){
                for (int j = 0; j >=palabra.length()-1; j-- ){
                    boolean encontrado = true;
                    for (int k = 0; k < palabra.length(); k++ ){
                        if(sopa[i][j-k] != palabra.charAt(k)){
                            encontrado = false;
                            break;
                        }
                    }
                    if (encontrado) {
                        System.out.println("La palabra " + palabra + " se encuentra en la fila " + (i+1) + " desde la columna " + (j-palabra.length()+2) + " hasta la columna " + (j+1));
                    }
                }
            }

            // Busca la palabra en vertical de arriba abajo
            for (int i = 0; i < (sopa.length - palabra.length()+1); i++) {
                for (int j = 0; j < sopa[i].length; j++) {
                    boolean encontrado = true;
                    for (int k = 0; k < palabra.length(); k++) {
                        if (sopa[i+k][j] != palabra.charAt(k)) {
                            encontrado = false;
                            break;
                        }
                    }
                    if (encontrado) {
                        System.out.println("La palabra " + palabra + " se encuentra en la columna " + (j+1) + " desde la fila " + (i+1) + " hasta la fila " + (i+palabra.length()));
                    }
                }
            }

            //Busca la palabra vertical de abajo hacia arriba
            for(int j = 0; j < sopa.length; j++){
                for (int i = sopa.length-1; i >= 0; i--){
                    boolean encontrado = true;
                    for (int k = 0; k < palabra.length(); k++){
                        if((i-k) < 0 || sopa[i-k][j] != palabra.charAt(k)){
                            encontrado = false;
                            break;
                        }
                    }
                    if(encontrado){
                        System.out.println("La palabra " + palabra + " se encuentra en la columna " + (j+1) + " desde la fila " + (i+1) + " hasta la fila " + (i-palabra.length()+2) + " en sentido inverso");
                    }
                }
            }

            lectorBuffer.close();
        } catch (IOException e) {
            System.out.println("Hubo un error al leer el archivo: " + e.getMessage());
        }


    }
}