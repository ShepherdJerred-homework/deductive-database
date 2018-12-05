rprogn
  (load "../src/unify.lisp")
  (load "../src/ddb.lisp")
  (trace unify)
  (trace ?)
  (trace prove)
  (trace query-bool)
  (trace query-list))

; DB from Dr. Baird
(load "./db.lisp")

; DB for (mortal fido) test
(setq db '((T (dog fido))
           ((dog x1) (mortal x1))))

; DB for (likes y fido) test
(setq db '((T (dog fido))
           ((dog x5) (likes Pavlov x5))))

; Test ? method
(and
  (equal
    (?
      '(mortal x))
    '(SOCRATES PLATO FIDO LASSIE FELIX LEO))
  (equal
    (?
      '(mortal fido))
    'YES) 
  (equal
    (?
      '(dog socrates))
    'NO)
  (equal
    (?
      '(likes y fido))
    '(PAVLOV))
  (equal
    (?
      '(hates y fido))
    '(FIDO LASSIE JOHN))
  (equal
    (?
      '(hates fido y))
    'YES)
  (equal
    (?
      '(mammal z))
    '(FIDO LASSIE SOCRATES PLATO FELIX LEO))
  (equal
    (?
      '(wb z))
    '(FIDO LASSIE SOCRATES PLATO FELIX LEO))
  (equal
    (?
      '(dog fido))
    'YES))

;; Test supporting functions
(and
  (equal
    (find-vars
      '(mortal x))
    '(x))
  (equal
    (find-vars
      '(mortal fido))
    nil)
  (equal
    (find-vars
      '(likes y fido))
    '(y))
  (equal
    (find-vars
      '(x y z))
    '(x y z))
  (equal
    (isvar 'x)
    T)
  (equal
    (isvar 'a)
    NIL)
  (equal
    (type-of-query '(predicate x))
    'LIST)
  (equal
    (type-of-query '(predicate a))
    'BOOL)
  (equal
    (type-of-query '(predicate x a))
    'LIST)
  (equal
    (type-of-query '(predicate a x))
    'BOOL))

