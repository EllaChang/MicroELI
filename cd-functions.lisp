;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                          
;;;;  CD Functions
;;;;
;;;;  Common Lisp implementation by:
;;;;
;;;;  Bill Andersen (waander@cs.umd.edu),
;;;;  Department of Computer Science
;;;;  University of Maryland
;;;;  College Park, MD  20742
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Purpose:
;;;;
;;;;   This file contains macros and functions used to manipulate
;;;; data structures used for encoding conceptual dependency (CD)
;;;; assertions. In addition, there is a simple pattern matcher 
;;;; used to compare CD forms.
;;;;
;;;; Notes:
;;;;
;;;;   CD's are represented as a list of the form:
;;;;
;;;;       (<predicate> (<role-1> <filler-1>) ... (role-n filler-n))
;;;;
;;;; where <predicate> is a primitive CD act, <role-i> is an appropriate 
;;;; slot for that predicate, and <filler-i> an associated value.
;;;;
;;;;   The functions below manipulate this data structure.  A function 
;;;; name of the form "x-y" denotes a function applies to a data 
;;;; structure of type "y" and returns a data stucture of type "x".

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Global Variables
;;;

(defconstant *cd-acts*
  '(*atrans* *ptrans* *propel* *move* *grasp* *ingest*
    *expel* *mtrans* *conc* *mbuild* *attend* *speak* *state* *strans*)
  "List of valid CD predicates")

(defparameter *user-trace* t
  "Controls output from USER-TRACE function.  If T,
message to USER-TRACE is printed.  If NIL, no output
occurs.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Data Structures
;;;

;; HEADER-CD gets the head act of a CD form.
;; ROLES-CD gets the list of role-pairs of a CD form.

(defun header-cd (x)
  "Returns predicate of a CD form"
  (car x))

(defun roles-cd (x)
  "Returns list of (role value) pairs for
a CD form."
  (cdr x))

;; Role-pairs have the form (role filler) - ROLE-PAIR returns the
;; role and FILLER-PAIR returns the filler.

(defun role-pair (x)
  "Returns the role of a (role filler) pair."
  (car x))

(defun filler-pair (x)
  "Returns the filler of a (role filler) pair."
  (cadr x))

;; A filler for a role is found by looking for the role name
;; in the CD, and returning the filler if a pair is found.

(defun filler-role (role cd)
  "Returns the filler for a given role in CD, or
NIL if there is no filler for role."
  (let ((pair (assoc role (roles-cd cd))))
    (and pair (filler-pair pair))))

;; SETROLE makes a new CD form with (role filler) added or
;; replacing the old (role ...) pair.

(defun setrole (role filler cd)
  "Adds (role filler) pair to CD or changes the filler
for role if the role already is present/"
  (cons (header-cd cd)
        (cons (list role filler)
              (remove role (roles-cd cd) :key #'role-pair))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  CD Pattern Matcher
;;;

;; NOTE: I reimplemented variables as defstructs so we
;;       can have a print-function print the variable
;;       the same way it is read, i.e. % ?X => ?X

(defstruct (cd-var (:print-function print-cd-var)
                   (:predicate is-var))
  name)

(defun print-cd-var (struct stream depth)
  (declare (ignore depth))
  (format stream "?~s" (cd-var-name struct)))

(defun name-var (x) 
  (assert (is-var x) () "~s is not a CD variable." x)
  (cd-var-name x))

;; Read macro to convert variables of the form ?x to
;; a structure representing the variable.

(set-macro-character #\?
                     #'(lambda (stream char)
                        (make-cd-var :name (read stream t nil t)))
                     t)

;;; MATCH takes three (predicate role-pair ...) forms as arguments.
;;; 1) a CD pattern which may contain variables;
;;; 2) a CD constant which contains no variables;
;;; 3) an optional binding form which specifies any bindings that
;;;    the variables in the pattern may already have.
;;;    The predicate of the binding form doesn't matter,
;;;    so T is used.  For convenience, MATCH also takes
;;;    NIL as a binding form and converts it to (T), which
;;;    is a binding form with no variables bound.  If no binding
;;;    form is specified, NIL is the default value.
;;; MATCH returns NIL only if the match failed. A match that
;;; succeeds but which involved no variables returns (T).

;;; For example, if the arguments were
;;; pattern = (PTRANS (ACTOR (*VAR* SHOPPER)) (TO (*VAR* STORE)))
;;; constant = (PTRANS (ACTOR (PERSON)) (TO (STORE)))
;;; binding = (T (SHOPPER (PERSON)) (STORE (STORE)))
;;; then the variables in the pattern are SHOPPER and STORE and
;;; the binding form says that these variables are bound to
;;; PERSON and STORE.
;;; The pattern matches the constant if the predicates are equal
;;; and if all of the roles in the pattern are matched by roles
;;; in the constant
;;; - a variable matches if its binding matches;
;;; - roles in the constant that are not in the pattern are ignored.

;;; MATCH returns either NIL if the match failed or an updated binding
;;; form that includes any new variable bindings that may have been
;;; produced.

;;; A NIL constant always matches - this means that the pattern
;;; (PERSON (NAME (JACK))) matches the constant (PERSON) even though
;;; the (NAME) is missing.

(defun match (pattern constant bindings)
  "Matches CD pattern to CD constant given bindings.
Returns (T (var val)*) if a match results, or NIL if
the pattern did not match the constant."
  (let ((binding-form (or bindings (list t))))
    (cond ((or (null constant) (equal pattern constant))
           binding-form)
          ((is-var pattern)
           (match-var pattern constant binding-form))
          ((or (atom constant) (atom pattern))
           nil)
          ((eq (header-cd pattern) (header-cd constant))
           (match-args (roles-cd pattern) constant binding-form)))))

;;; MATCH-ARGS takes a list of role pairs (a role pair has the form
;;; (role filler)), a constant CD form, and a binding form.
;;; It goes through the list of pairs and matches each pair against
;;; the corresponding role pair in the constant form - all of these
;;; must match.

(defun match-args (pattern-args constant bindings)
  (dolist (pattern-arg pattern-args)
    (let ((const (filler-role (role-pair pattern-arg) constant))
          (var (filler-pair pattern-arg)))
      (setq bindings (match var const bindings))
      (if (null bindings) 
        (return nil))))
  bindings)

;;; MATCH-VAR takes a variable, a constant, and a binding form -
;;; if the variable has a binding then the binding must match the
;;; constant - otherwise the binding form is updated to bind the
;;; variable to the constant.

(defun match-var (pattern constant bindings)
  (let ((var-value (filler-role (name-var pattern) bindings)))
    (if var-value
        (match var-value constant bindings)
      (cons-end bindings (list (name-var pattern) constant)))))

;;; Instantiating Patterns
;;; The function INSTANTIATE takes a CD pattern and a binding 
;;; list, such as the one produced by MATCH, and returns a CD
;;; form with the variables in the pattern replaced by their 
;;; bindings.

(defun instantiate (cd-form bindings)
  "Replaces a CD with variables by a new CD with the
variables replaced by their corresponding values from
bindings."
  (cond ((symbolp cd-form) cd-form)
        ((is-var cd-form)
         (instantiate (filler-role (name-var cd-form) bindings)
                      bindings))
        (t (cons (header-cd cd-form)
                 (mapcar #'(lambda (pair)
                            (list (role-pair pair)
                                  (instantiate (filler-pair pair)
                                               bindings)))
                         (roles-cd cd-form))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Translation Function
;;;

(defun cd-translate (cd)
  "Translates an ELI CD form into a BABEL CD form."
  (if (equal (header-cd cd) '*state*)
      (list 'ACTOR
            (filler-role 'ACTOR cd)
            '<==> 'T
            (list 
             (nth 0 (filler-role 'ATTR cd))
             'VAL
             (nth 0 (list (filler-role 'VALUE cd)))))
    (remove 'NIL (list 'ACTOR
                       (filler-role 'ACTOR cd)
                       '<=>
                       (list (header-cd cd))
          
                       (when (filler-role 'OBJECT cd)
                         'OBJECT)
                       (when (filler-role 'OBJECT cd)
                         (filler-role 'OBJECT cd))
          
                       (when (filler-role 'TO cd)
                         'TO)
                       (when (filler-role 'TO cd)
                         (filler-role 'TO cd))
          
                       (when (filler-role 'THRU cd)
                         'THRU)
                       (when (filler-role 'THRU cd)
                         (filler-role 'THRU cd))
          
                       (when (filler-role 'PREV cd)
                         'PREV)
                       (when (filler-role 'PREV cd)
                         (filler-role 'PREV cd))
          
                       (when (filler-role 'AFTER cd)
                         'AFTER)
                       (when (filler-role 'AFTER cd)
                         'AFTER
                         (filler-role 'AFTER cd))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Utility Functions
;;;

;; CONS-END is really inefficient!  Problem is some algorithms 
;; count on it being non-destructive.

  (defun cons-end (l x)
    "Adds x to the end of list l"
    (append l (list x)))

  (defun user-trace (str &rest args)
    (let ((*print-pretty* t))
      (when *user-trace*
        (apply #'format t str args))))

  (provide :cd-functions)
