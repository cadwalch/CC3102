# Intérprete del Lenguaje L - Tarea 2

Este proyecto implementa un intérprete funcional para un lenguaje de programación simple, denominado **L**, como parte de la Tarea 2 del curso de Teoría de la Computación. Se utilizaron **Flex** para el análisis léxico y **Bison** para el análisis sintáctico (parsing).

## Implementación

La implementación se compone de los siguientes archivos:

- **`tarea2.l`**: Analizador léxico que identifica y extrae los tokens (números, operadores, palabras clave) del código fuente de entrada.
- **`tarea2.y`**: Analizador sintáctico que implementa la gramática BNF del lenguaje L. Verifica que la secuencia de tokens sea sintácticamente correcta y aplica reglas de reducción para evaluar las expresiones y producir un resultado final (entero, booleano o string).
- **Capacidades del lenguaje**: El intérprete soporta:
  - Expresiones numéricas: `+`, `-`, `*`.
  - Expresiones booleanas: `and`, `not`, `<`, `=`.
  - Expresiones de strings: concatenación (`.`), largo (`|`).
  - Condicional `if` aplicable a los tres tipos de datos.

## Instrucciones de ejecución de solución.

Para compilar y ejecutar el intérprete, se deben seguir estos pasos desde la terminal:

### 1. Compilación

```bash
# Generar el analizador léxico
flex tarea2.l

# Generar el analizador sintáctico
bison -d -v tarea2.y

# Compilar los archivos generados y crear el ejecutable
gcc tarea2.tab.c lex.yy.c -o interpreter

```
### 2. Ejecución
Se puede ejecutar el intérprete dando un archivo de prueba como entrada estándar. Por ejemplo, para el archivo test1.in:

```bash

./interpreter < tests/test1.in

```