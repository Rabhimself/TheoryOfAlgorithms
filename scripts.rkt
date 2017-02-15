#lang racket

;plan on using this list to interate through the different operations 
(define ops (list + - / *))

;test target number
(define tar 15)
;defining test numbers
(define a 5)
(define b 10)

;
(equal? ((car ops) a b) tar )
 