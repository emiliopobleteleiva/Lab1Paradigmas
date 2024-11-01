#lang scheme


;board

(define (board)
  (make-list 7 (make-list 6 'empty))
  );lista de 7 listas con 6 elementos cada una // apoyo: gpt codecopilot

;modificar board

(define (empty-board board)
                     (define (empty-column column) ;modificar una lista dada, de forma que todos sus elementos serán cambiados por 0
                                           (map (lambda (x) 0) column))
                     (map empty-column board)) ;ejecutar (map funcion board), de esta manera se ejecuta "empty-column" en cada columna del tablero
;//apoyo: gpt codecopilot

;board / otros

;board board-can-play?

(define board-can-play?(lambda(board) ;return bool #t o #f
                         (cond ((null? board) #f) ;comprobar si la lista actual es nula
                               ((member 0 (car board)) #t);comprobar que 0 exista dentro de la sublista, funcion member implementada con apoyo de gpt codepilot
                               (else (board-can-play? (cdr board))) ;caso else, se realiza una recursión eliminando la primera sublista
                               )
                         )
  )

;board set piece (preparaciones)

;debería llegar abajo y subir para ver si este elemento esta disponible, lo voy a hacer primero definiendo funciones similares a car o cdr pero alreves

;funcion anticar, similar a car, pero devuelve el ultimo elemento de la lista
(define anticar (lambda(lista)
                  (if (null? (cdr lista)) (car lista)
                      (anticar (cdr lista))
                      )
                  )
  )

;funcion anticdr, similar a cdr pero alrevez, devuelve toda la lista menos el ultimo elemento
(define anticdr(lambda(lista)
                 (define recursiva(lambda(lista listout)
                                    (if (null? (cdr lista)) listout
                                        (recursiva (cdr lista) (append listout (list (car lista)))) ;error1: le di 5 en lugar de '(5), resolver cambiando el (car lista) por (list (car lista))
                                        ;error2: se está tratando de asignar valor a listout, deberia hacerse esto en la ejecucion de la funcion recursiva
                                        )
                                    )
                   )
                 (recursiva lista '())
                 )
  )

;funcion elementoN(lista n) que devuelva el elemento situadio en la posicion n de la lista

(define elemento(lambda(lista n)
                  (define recursiva(lambda(lista n aux)
                                     (if (null? lista) "out or range"
                                         (if (= aux n) (car lista)
                                             (recursiva (cdr lista) n (+ aux 1))
                                             )
                                         )
                                     )
                    )
                  (recursiva lista n 1)
                  )
  )

;funcion de si es ultimo elemento de una lista
(define isLast?(lambda(lista elemento)
                 (if (null? (cdr lista))
                     (if(= elemento (car lista)) #t
                        (isLast? (cdr lista) elemento)
                        )
                     (#f)
                     )
                 )
  )
; funcion que reemplaza elemento especifico de una lista por otro
(define replace-with(lambda(lista pos elemento)
                      (define recursiva(lambda(lista pos elemento listout aux)
                                         (if (null? lista) listout ;si se esta en la ultima posicion +1 de la lista, devolver listout
                                             (if (= aux pos) (recursiva (cdr lista) pos elemento (append listout (list elemento)) (+ aux 1))
                                                 (recursiva (cdr lista) pos elemento (append listout (list (car lista))) (+ aux 1))
                                                 )
                                             )
                                         )
                        )
                      (recursiva lista pos elemento '() 1)
                      )
  )

;quizás hacer la misma funcion pero aux = len-1?
(define largo-lista(lambda(lista)
                     (define recursiva(lambda(lista aux)
                                        (if (null? lista) aux
                                            (recursiva (cdr lista) (+ aux 1))
                                            )
                                        )
                       )
                     (recursiva lista 1)
                     )
  )

;definir inverse replace with
(define inverse-replace-with(lambda(lista pos elemento)
                              (replace-with lista (- (largo-lista lista) pos) elemento)
                              )
  )
;definir display-board
(define display-board(lambda(board)
                       (newline)
                       (if (null? (cdr board))
                           (begin (display (car board)) (display "done"))
                           (begin (display (car board)) (display-board (cdr board)))
                           )
                       )
  ) ;apoyo gpt codecopilot / aplicar "begin"

;funcion board-set-play-piece, comprueba si la jugada es posible, y la realiza
(define board-set-play-piece(lambda(board column piece)
                              (define recursiva(lambda(board boardaux column fila fila-actual piece)
                                                 (if (equal? (elemento fila-actual column) 0);abrir if principal / si elemento señalado es 0, entonces
                                                     (inverse-replace-with board fila (replace-with fila-actual column piece));then principal
                                                     (if (null? boardaux);if interno, comprobar si la siguiente fila es nula
                                                         (begin (display "Columna completa, probar con otro valor") board);then / failsafe
                                                         (recursiva board (anticdr boardaux) column (+ fila 1) (anticar boardaux) piece)
                                                         );else principal
                                                         );cierre if principal
                                                       )
                                                 )
                              (recursiva board (anticdr board) column 1 (anticar board) piece)
                              )
  )



;checkwin universal

(define checkwin(lambda(lista)
                  (define recursiva(lambda(lista cant piece)
                                     (if (= cant 4) piece ;se devuelve la pieza ganadora
                                         (if (null? lista) "continuar"
                                             (if (not (equal? (car lista) 0))
                                                 (if (equal? (car lista) piece)
                                                     (recursiva (cdr lista) (+ cant 1) piece);then
                                                     (recursiva (cdr lista) 1 (car lista))
                                                     )
                                                 (recursiva (cdr lista) 1 "piece")
                                                 )
                                             )
                                         )
                                     )
                    )
                  (recursiva lista 1 "piece")
                  )
  )

;aplicar checkwin vertical

;funciones de ayuda

(define obtener-lista-vertical(lambda(board column)
                        (define recursiva(lambda(boardaux column lista)
                                           (if (null? boardaux) lista
                                               (recursiva (anticdr boardaux) column (append lista (list (elemento (anticar boardaux) column))))
                                               )
                                           )
                          )
                        (recursiva board column '())
                        )
  )

;A TODOS LOS CHECKWIN, CAMBIAR RECORRIDO, DEVOLER 1 SI PLAYER 1 GANA, 2 SI PLAYER 2 GANA, 0 SI NADIE GANA
;definir checkwin vertical
(define cw-vertical(lambda(board)
                     (define recursiva(lambda(board columna lista-vertical listaux)
                                        (if (equal? (checkwin lista-vertical) "continuar")
                                            (if (null? listaux) 0
                                                (recursiva board (+ columna 1) (obtener-lista-vertical board columna) (cdr listaux))
                                                );then
                                            (whowon p1 (checkwin lista-vertical))
                                            )
                                        )
                       )
                     (recursiva board 1 (obtener-lista-vertical board 1) (car board))
                     )
  );funciona correctamente, datos de más: board, listaux? (se usa para el caso de que board sea de tamaño variable, en este caso es solo de 6)
;aplicar checkwin horizontal

(define cw-horizontal(lambda(board)
                       (define recursiva(lambda(board boardaux fila)
                                          (if (equal? (checkwin fila) "continuar")
                                              (if (null? boardaux) 0
                                               (recursiva board (anticdr boardaux) (anticar boardaux)))
                                              (whowon p1 (checkwin fila))
                                              )
                                          )
                         )
                       (recursiva board (anticdr board) (anticar board))
                       )
  );funciona correctamente


;aplicar checkwin diagonal

(define lista-diagonal(lambda(board x y direccion); board list, x int, y int, direccion string
                        (define recursiva(lambda(board x y direccion listout)
                                           (if (or (or (= x 0) (= x 7)) (or (= y 0) (= y 8))) listout ;si x no esta entre 1 y 6 (incluyendo) e y no esta entre 1 y 7, devolver lista
                                               (if (equal? direccion "derecha")
                                                   (recursiva board (+ x 1) (+ y 1) direccion (append listout (list (elemento (elemento board y) x))));then
                                                   (recursiva board (- x 1) (+ y 1) direccion (append listout (list (elemento (elemento board y) x))));else
                                                   );else
                                               )
                                           )
                          )
                        (recursiva board x y direccion '())
                        )
  )

;check todas las diagonales
(define cw-diagonal(lambda(board)
                     (define recursiva(lambda(board x y direccion wincon)
                                        (if (equal? wincon "continuar");esto está de más
                                            (if (equal? direccion "derecha")
                                                (if (and (= x 3) (= y 1))
                                                    (if (equal? wincon "continuar")
                                                        (recursiva board 6 4 "izquierda" (checkwin (lista-diagonal board 6 4 "izquierda")))
                                                        (whowon p1 wincon)
                                                        );terminar
                                                    (if (= y 1)
                                                        (recursiva board (+ x 1) y direccion (checkwin (lista-diagonal board (+ x 1) y direccion)))
                                                        (recursiva board x (- y 1) direccion (checkwin (lista-diagonal board x (- y 1) direccion)))
                                                        )
                                                    );con listadiagonal a derecha
                                                (if (and (= x 4) (= y 1))
                                                    (if (equal? wincon "continuar")
                                                        0
                                                        (whowon p1 wincon)
                                                        );
                                                    (if (= y 1)
                                                        (recursiva board (- x 1) y direccion (checkwin (lista-diagonal board (- x 1) y direccion)))
                                                        (recursiva board x (- y 1) direccion (checkwin (lista-diagonal board x (- y 1) direccion)))
                                                        )
                                                    );a la izquierda
                                                );recursion
                                            (whowon p1 wincon) ;else devolver wincon ACTUAL // está de más probablemente
                                            )
                                        )
                       ); mala ejecucion, encontrar una lógica más acertada
                     (recursiva board 1 4 "derecha" (checkwin (lista-diagonal board 1 4 "derecha")))
                     )
  )

(provide board empty-board board-can-play? board-set-play-piece checkwin cw-vertical cw-horizontal cw-diagonal display-board)
