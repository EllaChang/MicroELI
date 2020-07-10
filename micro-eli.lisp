;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                          
;;;;  Micro ELI
;;;;
;;;;  Common Lisp implementation and
;;;;  modifications by:
;;;;
;;;;  Bill Andersen (waander@cs.umd.edu)
;;;;  Department of Computer Science
;;;;  University of Maryland
;;;;  College Park, MD  20742
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require :cd-functions)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Global Variables
;;;

(defvar *stack* nil)      ;request packet stack

(defvar *concept*)        ;globals set by request assignments
(defvar *sentence*)
(defvar *cd-form*)
(defvar *word*)
(defvar *part-of-speech*)
(defvar *predicted*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Data Structures
;;;

(defun top-stack () (car *stack*))

(defun add-stack (packet)
  (and packet (push packet *stack*))
  packet)

(defun pop-stack () (pop *stack*))

(defun init-stack () (setq *stack* nil))

(defun empty-stack-p () (null *stack*))

(defun load-def ()
  "Adds a word's request packet to the stack. 
Word definitions are stored under the property
DEFINITION."
  (let ((packet (get *word* 'defintion)))
    (cond (packet (add-stack packet))
          (t (user-trace " - not in dictionary~%")))))

(defun req-clause (key l)
  "Extracts clauses from requests of the form:
((test ...) (assign ...) (next-packet ...))"
  (let ((x (assoc key l)))
    (and x (cdr x))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Top Level Functions
;;;

(defun process-text (text)
  "Process a list of sentences, parsing each one,
and printing the result."
  (dolist (sentence text)
    (user-trace "~2%Input is ~s~%" sentence)
    (let ((cd (parse sentence)))
      (user-trace "~2%CD form is ~s" cd)))
  (values))

(defun parse (sentence)
  "Takes a sentence in list form and returns the
conceptual analysis for it."
  (setq *concept* nil)
  (init-stack)
  (do ((*word* nil)
       (*sentence* (cons '*start* sentence)))
      ((null (setq *word* (pop *sentence*)))
       (remove-variables *concept*))
    (user-trace "~2%Processing word ~s" *word*)
    (load-def)
    (run-stack)))

(defun run-stack ()
  "If some request in the packet on the top of the stack
can be triggered, that packet is removed from the stack,
and the request is saved and executed.  When the top packet
contains no triggerable requests, the packets in the
requests which were triggered and saved are added to the
stack."
  (do ((request (check-top) (check-top))
       (triggered nil))
      ((null request) (add-packets triggered))
    (pop-stack)
    (do-assigns request)
    (push request triggered)))

(defun check-top ()
  "Looks through all requests on top of stack and picks
the ones that can be triggered. If more than one can be
triggered, use RESOLVE-CONFLICT to pick one."
  (unless (empty-stack-p)
    (let ((ls (list 'dummy)))
      (dolist (request (top-stack))
	(when (is-triggered request)
	  (push request (cdr (last ls)))))
      (let ((reqs (cdr ls)))
	(when (> (list-length reqs) 1)
	  (resolve-conflict reqs)))
      (nth 1 ls))))

(defun is-triggered (request)
  "Returns T if a request has no test or if the test
evaluates to T."
  (let ((test (req-clause 'test request)))
    (or (null test) (eval (car test)))))

(defun do-assigns (request)
  "Sets the global variables given in the ASSIGN clause
of a request."
  (do ((assignments (req-clause 'assign request)
                    (cddr assignments)))
      ((null assignments))
    (reassign (first assignments) 
              (second assignments))))

(defun reassign (var val)
  "Reassigns var to val and prints a message."
  (when (set var (eval val))
    (user-trace "~&  ~s = ~s~%" var (eval var))))

(defun add-packets (requests)
  "Takes a list of requests and add their NEXT-PACKETs
to the stack."
  (dolist (request requests)
    (add-stack (req-clause 'next-packet request))))

(defun feature (cd-form predicate)
  "Tests whether the CD is of the form (predicate...)."
  (equal predicate (header-cd cd-form)))

(defun rec-search (lst elt)
  "Recursively searches for a list starting with elt."
  (cond ((null lst) nil)
	((atom (car lst))
	 (if (equal (car lst) elt)
	     lst
	     (rec-search (cdr lst) elt)))
	(t (or (rec-search (car lst) elt)
	       (rec-search (cdr lst) elt)))))

(defun get-np-prediction ()
  "Looks for a request in the top packet of the stack with a test
looks for a noun phrase generating a particular type of CD. If it
finds one, it returns the predicate that FEATURE is looking for."
  (unless (empty-stack-p)
    (dolist (request (top-stack))
      (when (and (req-clause 'test request)
		 (rec-search (req-clause 'test request) 'feature))
	(write (rec-search (req-clause 'test request) 'feature))
	(return (list (nth 2 (rec-search (req-clause 'test request) 'feature))))))))

(defun get-cd-form (request)
  "Takes a request and returns the structure the request would
assign to *CD-FORM* if executed."
  (let ((assign-clause (req-clause 'assign request)))
    (let ((n (position '*CD-FORM* assign-clause)))
      (nth (+ n 1) assign-clause))))

(defun resolve-conflict (req-list)
  "Applies GET-CD-FORM to a list of requests, picking the first one
that assigns to *CD-FORM* a structure matching *PREDICTED*."
  (write "Resolving conflict.")
  (loop for req in req-list
	do (when (equal *predicted* (get-cd-form req)) req)))

;; NOTE: 
;;   This function has been modified to handle a list of CD forms
;; instead of a single form.  The reason for this is that some
;; concepts cannot be expressed with a single CD.  For example, 
;; "buying" is an ATRANS of something to the actor *and* and
;; ATRANS of money from the actor to the seller.
;;   The parser is not affected since all it does is control the
;; request firing which in turn makes variable assignments.

(defun remove-variables (cd-form)
  "Takes a parsed CD from Micro-ELI and returns a copy
of the pattern with the variables replaced by values.
Roles with NIL fillers are left out of the result.  This
works like INSTANTIATE in Micro-SAM and Micro-POLITICS
except that the values are derived from global variables
rather than binding lists."
  (cond ((symbolp cd-form) cd-form)
        ((is-var cd-form)
         (remove-variables (eval (name-var cd-form))))
        (t (replace-list cd-form))))

;; REPLACE-LIST is just an auxiliary function for 
;; REMOVE-VARIABLES.
(defun replace-list (cd-form)
  (cond ((null cd-form) nil)
        ((atom (header-cd cd-form))
         (cons (header-cd cd-form)
               (let (result)
                 (dolist (pair (roles-cd cd-form))
                   (let ((val (remove-variables (filler-pair pair))))
                     (when val (push `(,(role-pair pair) ,val)
                      result))))
                 (nreverse result))))
        (t (cons (replace-list (car cd-form))
                 (replace-list (cdr cd-form))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Dictionary Functions
;;;

(defmacro defword (&body def)
  `(progn (setf (get ',(car def) 'defintion) ',(cdr def))
          ',(car def)))

;; Example vocabulary items...

(defword jack
  ((assign *cd-form* '(person (name (jack)))
           *part-of-speech* 'noun-phrase)))

(defword went
  ((assign *part-of-speech* 'verb
           *cd-form* '(ptrans (actor  ?go-var1)
                              (object ?go-var1)
                              (to     ?go-var2)
                              (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *word* 'to))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var2 *cd-form*))))
    ((test (equal *word* 'home))
     (assign go-var2 '(house))))))

(defword to
 ((assign *part-of-speech* 'preposition
          *cd-form* '(to))))

(defword a
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'noun-phrase
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
	   *predicted* (get-np-prediction))))

(defword aaa
  ((assign *part-of-speech* nil
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
	   *predicted* (get-np-prediction))))

(defword restaurant
 ((assign *part-of-speech* 'noun
          *cd-form '(restaurant))))

(defword he
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(person))))

(defword ordered
 ((assign *part-of-speech* 'verb
          *cd-form* '(atrans (actor ?get-var3)
                             (object ?get-var2)
                             (to ?get-var1)
                             (from ?get-var3))
          get-var1 *subject*
          get-var2 nil
          get-var3 nil)))

(defword ate
  ((assign *part-of-speech* 'verb
	   *cd-form* '(ingest (actor ?get-var1)
                              (object ?get-var2)
                              (to ?get-var3)
                              (from ?get-var3))
	   get-var1 *subject*
           get-var2 nil
           get-var3 nil)
  (next-packet
   ((test (eq *part-of-speech* 'noun-phrase))
    (assign get-var2 *cd-form*)))))

(defword lobster
 ((assign *part-of-speech* 'noun
          *cd-form* '(lobster))))

(defword left
 ((assign *part-of-speech* 'verb
          *cd-form* '(ptrans (actor  ?go-var1)
                              (object ?go-var1)
                              (to     ?go-var2)
                              (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)))

(defword got
  ((assign *part-of-speech* 'verb
           *cd-form* '(atrans (actor  ?get-var1)
                              (object ?get-var2)
                              (to     ?get-var1)
                              (from   ?get-var3))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (eq *part-of-speech* 'noun-phrase))
     (assign get-var2 *cd-form*)))))

(defword thea
  ((assign *part-of-speech* nil
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
	   *predicted* (get-np-prediction))))

(defword the
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'noun-phrase
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
	   *predicted* (get-np-prediction))))

(defword red
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'adjective
	   *predicates* '((color(red))))))

(defword kite
  ((assign *part-of-speech* 'noun
           *cd-form* '(kite))))

(defword store
  ((assign *part-of-speech* 'noun
           *cd-form* '(store))))

(defword paid
  ((assign *part-of-speech* 'verb
	   *cd-form* '(atrans (actor ?get-var1)
				(object ?get-var2)
				(to ?get-var3)
				(from ?get-var1))
	   get-var1 *subject*
	   get-var2 nil
	   get-var3 nil)
   (next-packet
    ((test (and (equal *part-of-speech* 'noun-phrase)
		(feature *cd-form* 'cost-form))
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (and (equal *part-of-speech* 'noun-phrase)
		    (feature *cd-form* 'money))
         (assign get-var2 *cd-form*)))))))))))

(defword bill
  ((assign *part-of-speech* 'noun
	   *cd-form* '(cost-form)
	   *predicates* '((amount (cost-form))))))

(defword with
  ((assign *part-of-speech* 'preposition)))

(defword check
  ((assign *part-of-speech* 'noun
	   *cd-form* '(money)))
  ((assign *part-of-speech* 'noun
	   *cd-form* '(cost-form))))

(defword *start*
  ((assign *part-of-speech* nil
           *cd-form* nil
           *subject* nil
           *predicates* nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *subject* *cd-form*)
     (next-packet
      ((test (equal *part-of-speech* 'verb))
       (assign *concept* *cd-form*)))))))

(setq text
      '((jack paid the check with a check)))

(provide :micro-eli)
