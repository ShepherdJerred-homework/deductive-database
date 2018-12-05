;;; Takes a term and applies a substitution to it
;;; sub is the form of (X . B) where X is the target and B is the replacement value 
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

;;; Apply subs to a term
;;; subs follows this form ((X . B))
(defun apply-subs
  (term subs)
  (if
    (atom subs)
    (apply-one-sub term (car subs))
    (apply-subs (apply-one-sub term (car subs)) (cdr subs))))

;;; Takes an atom and returns T if it is a variable, NIL otherwise
(defun isvar (term)
  (if (member term '(u v w x y z x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20))
    t
    nil))

;;; Takes a DDB query and returns the type of query it is
;;; query should match one of the below formats
;;; (predicate var)     => LIST
;;; (predicate lit)     => BOOL
;;; (predicate var lit) => LIST
;;; (predicate lit var) => BOOL
(defun type-of-query (query)
  (if (isvar (cadr query))
      'list
      'bool))

;;; Takes a query and a database
;;; Returns T if the query can be proven, NIL otherwise
;;; This function requires a global database 'db' to be defined
(defun prove (query my-db)
  (let* ((db-entry (car my-db))
         (next-db-entry (cdr my-db))
         (antecedent (car db-entry))
         (consequent (cadr db-entry))
         (unify-result (unify query consequent)))
    (if unify-result
      (if (eq antecedent t)
        t
        (let ((new-query (apply-subs antecedent unify-result)))
          (if (prove new-query db)
            t
            (if (null next-db-entry)
              nil
              (prove query next-db-entry)))))
      (if (null next-db-entry)
        nil
        (prove query next-db-entry)))))

(defun query-bool (query)
  (if (prove query db)
    'yes
    'no))

;;; Takes a query and a database
;;; Returns a list of symbols that match a query
;;; This function requires a global database 'db' to be defined
(defun query-list (query my-db)
  (let* ((db-entry (car my-db))
         (next-db-entry (cdr my-db))
         (antecedent (car db-entry))
         (consequent (cadr db-entry))
         (unify-result (unify query consequent)))
    (if unify-result
      (if (eq antecedent t)
        (append (cdr consequent) (query-list query next-db-entry))
        (let ((new-query (apply-subs antecedent unify-result)))
          (append (query-list new-query db) (query-list query next-db-entry))))
      (if (null next-db-entry)
        'nil
        (query-list query next-db-entry)))))

(defun ? (query)
  (if (eq (type-of-query query) 'bool)
    (query-bool query)
    (query-list query db)))

