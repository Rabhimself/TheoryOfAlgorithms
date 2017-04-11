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

;takes one item and gets all combinations with a list, pushes them to another list
(define (pairup i lst bckt)
  (if (null? lst) 
      bckt
  (pairup i  (cdr lst) (cons (list i (car lst)) bckt))))

;all gets all possible pairs of two lists
(define (cart alst blst bckt)
  (if (null? blst)
      bckt
      (cart (cdr alst) (cdr blst) (append (pairup (car alst)  (cdr blst) '()) bckt))))


;this is sort of what i want to do, but without all the index garbage. do this for every combination of every permutation would be overkill maybe, lots of redundancy and no accounting for the whole no negative numbers thing
;not to mention the trouble division can/will cause
;(define (domath lst ops)
; ((fifth ops) ((fourth ops) ((third ops) ((second ops) ((first ops) (first lst) (second lst)) (third lst)) (fourth lst)) (fifth lst)) (sixth lst)))


;(domath (car permus) ops)

;removes all list of size < 2
(define (filter lst out)
  (if (null? (cdr lst))
       out
      (if ( > (length (car lst)) 1 )
          (filter (cdr lst) (append out (list (car lst))))
          (filter (cdr lst) out))))

;just testing filter against all the combinations in a permutation
;(define fl (filter (combinations (car permus)) temp))

;basically create all strings over an given alphabet of size 5.
;this will create all possible combinations of all the operations i will need
;This should work alongside some polish notation stuff later
  (define (buildops lst)
    (if (equal? (length (last lst)) 5)
        lst
        (append lst
        (buildops 
           (append-map (lambda (lst)
                (bopsaux lst)) lst)))))
 
(define (bopsaux lst) (map (lambda (ops)
                  (append lst (list ops))) ops))

(define 5ops (cartesian-product ops ops ops ops ops))


;ians code from lab, -1 is a placeholder for operator and 1 is for operands
(define (append-rpn l)
  (append (list 1 1) l (list -1)))
(define op-perms (map append-rpn (remove-duplicates (permutations  (list -1 -1 -1 -1 1 1 1 1 )))))

;write function to determine if a list is a valid rpn list
;e= element s = stack
(define (valid-rpn? e [s 0])
  (if (null? e)
      (if (= s 1)
          #t #f)
      (if (= (car e) 1)
          (valid-rpn? (cdr e) (+ 1 s))
          (valid-rpn? (cdr e) (- 1 s))
      ))) ;if this returns true, push the e to a list for computation later
(define (make-rpn templt ops nums [out '()])
   (if (null? templt)
      out
      (if (= (car templt) 1)
          (make-rpn (cdr templt) ops (cdr nums) (append out (list(car nums))))
          (make-rpn (cdr templt) (cdr ops) nums (append out (car ops)))
      )))
(define (eval-rpn in [stack '()])
  (if (null? in)
      stack
      (if (procedure? (car in))
          (eval-rpn (cdr in) (cons (apply (car in) (list(car stack) (cadr stack))) (cddr stack)))
          (eval-rpn (cdr in) (cons (car in) stack))
      )))
(define (build-ops-tmplt in out)
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
(define valid-op-perms (build-ops-tmplt op-perms '()))

;test stack for later
(make-rpn (car valid-op-perms) (list (list +) (list -) (list +) (list *) (list -)) (last permus))

;(define (find-sols nums ops tmplts)
;  (map (lambda (ops tmplts)
;    ()) nums))

;for each element in the combinations of permutations
   ;for each list of operations of length n
       ;for each template of valid rpns
           ;evaluate, if == push to a list for later

