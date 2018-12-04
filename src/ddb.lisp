;;; Takes an atom and returns T if it is a variable, NIL otherwise
(defun isvar (term)
  (if (member term '(u v w x y z x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20))
    T
    NIL))

;;; Takes a DDB query and returns the type of query it is
;;; query should match one of the below formats
;;; (predicate var)     => LIST
;;; (predicate lit)     => BOOL
;;; (predicate var lit) => LIST
;;; (predicate lit var) => BOOL
(defun type-of-query (query)
  (if (isvar (cadr query))
      'LIST
      'BOOL))

(defun query-bool (query db origdb)
  (let* ((db-entry (car db))
         (antecedent (car db-entry))
         (consequent (cadr db-entry))
         (unify-result (unify query consequent)))
    (if unify-result
      (if (eq antecedent T)
        'YES
        (let ((new-query (apply-subs antecedent unify-result)))
          (if (eq (query-bool new-query origdb origdb) 'YES)
            'YES
            (if (null (cdr db))
              'NO
              (query-bool query (cdr db) origdb)))))
      (if (null (cdr db))
        'NO
        (query-bool query (cdr db) origdb)))))

(defun query-list (query db origdb)
 nil) 

(defun ? (query)
  (if (eq (type-of-query query) 'BOOL)
    (query-bool query db db)
    (query-list query)))

