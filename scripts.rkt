#lang racket

;plan on using this list to interate through the different operations 
(define ops (list + - / *))

;test target number
(define tar 15)
;defining test numbers
(define a 5)
(define b 10)
(define c 15)
;defining a list for later
(define lst (list a b c))

;small check if the operation yields a match to the target
(equal? ((car ops) a b) tar )

;more building blocks, grabs the first operation in the ops list, and applies it to the
;first item in the list argument with the second item in the list argument
(define (doMath lst)
 ((car ops) (car lst) (car (cdr lst))))

(doMath lst)