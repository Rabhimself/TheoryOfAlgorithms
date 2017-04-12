#lang racket



;test target number
(define tar '())
(define permus '())

;plan on using this list to interate through the different operations 
(define ops (list (list +)(list -)(list *)(list /)))

(define opslist (list (list (list +)(list -)(list *)(list /)) (cartesian-product ops ops) (cartesian-product ops ops ops)(cartesian-product ops ops ops ops)(cartesian-product ops ops ops ops ops)))
;originally did this instead of using cartesian-product
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

;appends the the numbers and an operator to the front and end of the list, respectively.
(define (append-rpn l)
  (append (list 1 1) l (list -1)))
(define templt-permus
  (list (list(list 1 1 -1))
        (map append-rpn (remove-duplicates (permutations  (list -1 1 ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 1 1  ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 -1 1 1 1  ))))
        (map append-rpn (remove-duplicates (permutations  (list -1 -1 -1 -1 1 1 1 1 ))))))

;removes all list of size < 2
(define (twofilter lst [out '()])
  (if (null? (cdr lst))
       out
      (if ( > (length (car lst)) 1 )
          (twofilter (cdr lst) (append out (list (car lst))))
          (twofilter (cdr lst) out))))

(define (build-num-list permus [out '()])
  (if (null? permus) out
      (build-num-list (cdr permus) (remove-duplicates (append (combinations (car permus)) out)))))

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
      (car stack)
      (if (procedure? (car in))
          (if (and (eq? / (car in)) (= (cadr stack) 0))
              #f
              (if (or (negative? (apply (car in) (list(car stack) (cadr stack))))(not (integer? (apply (car in) (list(car stack) (cadr stack))))))
                  #f
              (eval-rpn (cdr in) (cons (apply (car in) (list(car stack) (cadr stack))) (cddr stack)))))
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

;takes a list of numbers and builds all rpn combinations using all strings of an alphabet(operators) of size n (length of numbers -1)
(define (find-sols nums [ops (list-ref opslist (- (length nums) 2))] [out '()])
;get all ops and call aux then call makerpn
  (if (null? ops) out
      (find-sols nums (cdr ops) (aux nums (car ops) out)))
)
(define (aux nums ops [out '()] [templt (list-ref valid-op-perms (- (length nums) 2))] )
    (if (null? templt) out
        (if (eq? tar (eval-rpn (make-rpn nums ops (car templt))))
            (aux nums ops (append out (list(make-rpn nums ops (car templt)))) (cdr templt) )
            (aux nums ops out (cdr templt)))))

(define (countdown nums target)
  (set! tar target)
  (set! permus (twofilter(build-num-list (permutations nums))))
  (remove '()(remove-duplicates (map find-sols permus))))
;test stack for later
;(make-rpn (car valid-op-perms) (list (list +) (list -) (list +) (list *) (list -)) (last permus))

;for each element in the combinations of permutations
   ;for each list of operations of length n
       ;for each template of valid rpns
          ;evaluate, if == push to a list for later
