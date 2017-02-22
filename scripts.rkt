#lang racket

;plan on using this list to interate through the different operations 
(define ops (list + - / *))

;test target number
(define tar 100)
;defining test numbers
(define a 5)
(define b 10)
(define c 15)
(define d 20)
(define e 25)
(define f 50)
;defining a list for later
(define lst (list a b c d e f))

;small check if the operation yields a match to the target
;(equal? ((car ops) a b) tar )

;Not sure if this is headed in the right direction, just applying an
;operation to the whole list
(define (applyOpToList op lst)
  (if(null? (cdr lst))
     (car lst)
     (op (car lst)  (applyOpToList op (cdr lst)))))
;if I use the permutations function this would be useless.
;as i'd just end up essentially merging the ordered operations list with every permutation

;considering looping over all different orders of the numbers and printing them
;then maybe change around the operations as an overall algorithm

;loop over list, then loop over the cdr of that list, inside that loop loop over the cdr again, etc etc
;inside that, use all operations using the same structure
(define temp null)

; just pushing to a temp list, plan on using temp to build the different combinations of operations/numbers
(define (doLoop lst)
  (if ( = (length lst) 2)
  (doLoopEnd (car lst) (cadr lst) temp)
  (list* (car lst) (doLoop (cdr lst)))))

(define (doLoopEnd a b temp)
  (list* a b temp))


(define permus (permutations lst))
;not sure if this is kosher, but leaving it for later just in case
;it generates every single permutation of a lists elements w/o repeats
;I still need to get every single permutation WITH repeats on the operations
;then combine the two. Likely easier said than done...
;Serious brute force stuff here



