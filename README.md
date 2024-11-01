# Lab1Paradigmas

# Conecta4 en Scheme

Este proyecto implementa el juego de Conecta4 en Scheme siguiendo el paradigma funcional. El juego permite partidas entre dos jugadores y verifica automáticamente el estado de victoria o empate.

## Estructura del Proyecto

El código se organiza en varios archivos, cada uno manejando una parte específica del juego:
- **`TDA_Player.scm`**: Define y gestiona la estructura y estadísticas de los jugadores.
- **`TDA_Piece.scm`**: Define y maneja las piezas de juego.
- **`TDA_Board.scm`**: Contiene funciones para inicializar y gestionar el tablero de Conecta4.
- **`main.scm`**: Archivo principal que ejecuta el flujo básico del juego.

## Funcionamiento Básico

1. **Crear Jugadores y Piezas**
   - `(define p1 (player 1 "Juan" "red" 0 0 0 21))`
     Define al jugador 1 con su color y estadísticas iniciales.
   - `(define p2 (player 2 "Maria" "yellow" 0 0 0 21))`
     Define al jugador 2.
   - `(define red-piece (piece "red"))` y `(define yellow-piece (piece "yellow"))`
     Crea las piezas de cada jugador según su color.

2. **Crear el Tablero**
   - `(define empty-board (board))`
     Genera un tablero vacío de 7x6 para el inicio del juego.

3. **Verificar el Estado del Tablero**
   - `(board-can-play? empty-board)`
     Revisa si hay movimientos posibles en el tablero.
   - `(display-board empty-board)`
     Muestra el estado actual del tablero.

4. **Realizar Jugadas**
   - `(define updated-board (board-set-play-piece empty-board columna piece))`
     Coloca una pieza en la columna indicada, bajando hasta la posición disponible más baja.

5. **Verificar Victoria**
   - `(cw-vertical updated-board)`, `(cw-horizontal updated-board)`, `(cw-diagonal updated-board)`
     Verifican si hay una victoria en dirección vertical, horizontal o diagonal, respectivamente.

6. **Determinar Ganador**
   - `(board-who-is-winner updated-board)`
     Usa todas las verificaciones de victoria para determinar si hay un ganador en el estado actual del tablero.


