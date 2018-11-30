; unify
; Jerred Shepherd

; Takes a term and applies a substitution to it
; sub is the form of (X . B) where X is the target and B is the replacement value 
(defun apply-one-sub
  (term sub)
  (let
    (
      (sub-key (car sub))
      (sub-value (cdr sub)))
    (if
      (eq term sub-key)
      sub-value
      (if
        (atom term)
        term
        (cons (apply-one-sub (car term) sub) (apply-one-sub (cdr term) sub))))))

; Apply subs to a term
; subs follows this form ((X . B))
(defun apply-subs
  (term subs)
  (if
    (atom subs)
    (apply-one-sub term (car subs))
    (apply-subs (apply-one-sub term (car subs)) (cdr subs))))

(defun occurs
  (term sigma)
  (if
    (eq (caar sigma) term)
    T
    (if
      (null (cdr sigma))
      nil
      (occurs term (cdr sigma)))))

(defun do-unify
  (t1 t2 sigma)
  (if
    (eq t1 t2)
    sigma
    (if
      (or
        (atom t1)
        (atom t2))
      (if
        (isvar t1)
        (if
          (equal sigma '(nil))
          (cons (cons t1 t2) nil)
          (if
            (occurs t1 sigma)
            nil
            (let
              (
                (new-rule (cons (cons t1 t2) nil)))
              (append new-rule (apply-subs sigma new-rule)))))
        (if
          (isvar t2)
          (do-unify t2 t1 sigma)
          nil))
      (let*
        (
          (new-sigma (do-unify (car t1) (car t2) sigma))
          (new-t1 (apply-subs t1 new-sigma))
          (new-t2 (apply-subs t2 new-sigma)))
        (if
          (null new-sigma)
          nil
          (do-unify (cdr new-t1) (cdr new-t2) new-sigma))))))

(defun unify
  (t1 t2)
  (do-unify t1 t2 '(nil)))

