#lang scheme

(require "TDA_Player.scm"
         "TDA_Piece.scm"
         "TDA_Board.scm")
;fallido
(define test-board (board))
(define test-board (board-set-play-piece test-board 0 red-piece))
(define test-board (board-set-play-piece test-board 1 yellow-piece))
(define test-board (board-set-play-piece test-board 1 red-piece))
(define test-board (board-set-play-piece test-board 2 yellow-piece))
(define test-board (board-set-play-piece test-board 2 yellow-piece))
(define test-board (board-set-play-piece test-board 2 red-piece))
(define test-board (board-set-play-piece test-board 3 yellow-piece))
(define test-board (board-set-play-piece test-board 3 yellow-piece))
(define test-board (board-set-play-piece test-board 3 yellow-piece))
(define test-board (board-set-play-piece test-board 3 red-piece))
(cw-diagonal test-board)
