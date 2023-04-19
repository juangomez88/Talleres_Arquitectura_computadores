import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class SopaLetras {
    public static void main(String[] args) {
        try {
            // Cambia "sopa.txt" por el nombre de tu archivo de sopa de letras
            File archivo = new File("/home/juan/IdeaProjects/sopaLetras/sopa.txt");
            FileReader lectorArchivo = new FileReader(archivo);
            BufferedReader lectorBuffer = new BufferedReader(lectorArchivo);

            // Guarda la sopa de letras en una matriz
            char[][] sopa = new char[9][9];
            for (int i = 0; i < sopa.length; i++) {
                String linea = lectorBuffer.readLine();
                for (int j = 0; j < sopa.length; j++) {
                    sopa[i][j] = linea.charAt(j);
                }
            }

            // Aquí puedes cambiar "PALABRA" por la palabra que quieras buscar en la sopa de letras
            String palabra = "SOFI";

            // Busca la palabra en horizontal de izquierda a derecha
            for (int i = 0; i < sopa.length; i++) {
                for (int j = 0; j < palabra.length(); j++) {
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

            // Busca la palabra en vertical de arriba abajo
            for (int i = 0; i < palabra.length(); i++) {
                for (int j = 0; j < palabra.length(); j++) {
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
            lectorBuffer.close();
        } catch (IOException e) {
            System.out.println("Hubo un error al leer el archivo: " + e.getMessage());
        }


    }
}
