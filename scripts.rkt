#lang racket

;plan on using this list to interate through the different operations 
(define ops (list (list +)(list -)(list *)(list /)))
(define size 6)
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
(define stack '())

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


;removes all list of size < 2
(define (filter lst [out '()])
  (if (null? (cdr lst))
       out
      (if ( > (length (car lst)) 1 )
          (filter (cdr lst) (append out (list (car lst))))
          (filter (cdr lst) out))))

(define (build-num-list permus [out '()])
  (if (null? permus) out
      (build-num-list (cdr permus) (remove-duplicates (append (combinations (car permus)) out)))))
(define permus (filter(build-num-list (permutations lst))))


;just testing filter against all the combinations in a permutation
;(define fl (filter (combinations (car permus)) temp))

;basically create all strings over an given alphabet of size 5.
;this will create all possible combinations of all the operations i will need
;This should work alongside some polish notation stuff later
;  (define (buildops lst [out '()])
;    (if (equal? (length (last (car lst))) 5)
;        lst
;        (append lst
;        (buildops 
;           (append-map (lambda (lst)
;                (bopsaux lst)) lst)))))
; 
;(define (bopsaux lst) (map (lambda (ops)
;                  (append lst (list ops))) ops))

;or turns out i can do this....
(define opslist (list (list (list +)(list -)(list *)(list /)) (cartesian-product ops ops) (cartesian-product ops ops ops)(cartesian-product ops ops ops ops)(cartesian-product ops ops ops ops ops)))


;ians code from lab, -1 is a placeholder for operator and 1 is for operands
(define (append-rpn l)
  (append (list 1 1) l (list -1)))
(define templt-permus
  (list (list(list 1 1 -1))
        (map append-rpn (remove-duplicates (permutations  (list -1 1 ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 1 1  ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 -1 1 1 1  ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 -1 -1 1 1 1 1 ))))))


;write function to determine if a list is a valid rpn list
;e= element s = stack
(define (valid-rpn? e [s 0])
  (if (null? e)
      (if (= s 1)
          #t #f)
      (if (= (car e) 1)
          (valid-rpn? (cdr e) (+ s 1))
          (if (= (- s 1) 0)
              #f
          (valid-rpn? (cdr e) (- s 1)))
      ))) ;if this returns true, push the e to a list for computation later

(define (dolist nums [ops (list-ref opslist (- (length nums) 2))] [out '()])
;get all ops and call aux then call makerpn
  (if (null? ops) out
      (dolist nums (cdr ops) (aux nums (car ops) out)))
)
(define (aux nums ops [out '()] [templt (list-ref valid-op-perms (- (length nums) 2))] )
    (if (null? templt) out
    (aux nums ops (append out (list(make-rpn nums ops (car templt)))) (cdr templt) )))
;takes a list of numbers, a list of operators, and a valid rpn template and combines them
   
(define (make-rpn nums ops templt [out '()]) 
   (if (null? templt)
      out
      (if (= (car templt) 1)
          (make-rpn (cdr nums) ops (cdr templt) (append out (list(car nums))))
          (make-rpn nums (cdr ops)  (cdr templt)  (append out (list(car ops))))
      )))

;evaluates an rpn list, also checks at every step in the evaluation for fractions and negative numbers, albeit in a VERY longwinded way
(define (eval-rpn in [stack '()])
  (if (null? in)
      stack
      (if (list? (car in))
          (if (and (eq? / (caar in)) (= (cadr stack) 0))
              #f
              (if (or (negative? (apply (caar in) (list(car stack) (cadr stack))))(not (integer? (apply (caar in) (list(car stack) (cadr stack))))))
                  #f
              (eval-rpn (cdr in) (cons (apply (car(car in)) (list(car stack) (cadr stack))) (cddr stack)))))
      (eval-rpn (cdr in) (cons (car in) stack)))
      ))
(define (build-ops-tmplt in [out '()])
  ;if car of in is null return out
  (if (null? in) out (if (valid-rpn? (car in))
      (build-ops-tmplt (cdr in) (cons  (car in) out))
      (build-ops-tmplt (cdr in) out)))
  )

;can either get all elements on the operations list based on size, or just rework the cartesian
;product code to build a list of all the lists at indexes based on their size
;then just grab elements from the index of (length lst)
(define (get-by-len lst len out)
  (map (lambda lst len out
         (cond [(eq? (length lst) len) (cons lst out)]))
       lst))
(define valid-op-perms (map build-ops-tmplt templt-permus))

;test stack for later
;(make-rpn (car valid-op-perms) (list (list +) (list -) (list +) (list *) (list -)) (last permus))

;(define (find-sols nums ops tmplts)
;  (map (lambda (ops tmplts)
;    ()) nums))

;for each element in the combinations of permutations
   ;for each list of operations of length n
       ;for each template of valid rpns
          ;evaluate, if == push to a list for later


;fix valid-rpnp
; (define ohmy (aux (last permus) (seventh (list-ref opslist (- (length (last permus)) 2)))))
; (map eval-rpn omy)





