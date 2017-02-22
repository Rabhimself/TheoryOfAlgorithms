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
;(equal? ((car ops) a b) tar )

;Not sure if this is headed in the right direction, just applying an
;operation to the whole list
(define (applyOpToList op lst)
  (if(null? (cdr lst))
     (car lst)
     (op (car lst)  (applyOpToList op (cdr lst)))))

;considering looping over all different orders of the numbers and printing them
;then maybe change around the operations as an overall algorithm

;loop over list, then loop over the cdr of that list, inside that loop loop over the cdr again, etc etc
;inside that, use all operations using the same structure

