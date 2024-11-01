 #lang scheme

 ;player
(define player(lambda(id name color wins losses draws remaining-pieces)
               (list id name color wins losses draws remaining-pieces)
  ))

;funcion que devuelve el player que ganó
(define whowon(lambda(player1info player2info wincon)
                (if (member wincon player1info)
                    (elemento player1info 1)
                    (elemento player2info 1)
                    )
                )
  )

  (provide player whowon)

