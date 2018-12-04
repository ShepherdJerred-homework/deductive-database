(defun isvar (term)
  (if (member term '(u v w x y z))
    T
    NIL))

;;; Takes a DDB query and returns the type of query it is
;;; Possible results
;;; (predicate var)     => LIST
;;; (predicate lit)     => BOOL
;;; (predicate var lit) => LIST
;;; (predicate lit var) => BOOL
(defun typeofquery (query)
  (if (isvar (cadr query))
      'LIST
      'BOOL))

(defun ? (term)
  'YES)
