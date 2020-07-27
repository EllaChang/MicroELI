;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                          
;;;;  Micro SAM
;;;;
;;;;  Common Lisp implementation by:
;;;;
;;;;  Bill Andersen (waander@cs.umd.edu),
;;;;  Department of Computer Science
;;;;  University of Maryland
;;;;  College Park, MD  20742
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require :micro-sam-cd-functions)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Global Variables
;;;

(defvar *current-script* nil
  "The currently active script")

(defvar *possible-next-events* nil
  "Temporally ordered list of events which have not
been seen in the input yet.")

(defvar *data-base* nil
  "Pointer to CD database")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Top Level Functions
;;;

(defun process-story (story)
  "Takes a story (just a list of CDs) and passes each to
PROCESS-CD.  At the end of the story, the current script
is added to the database and the database is pretty-printed."
  (clear-scripts)
  (user-trace "~%")
  (dolist (cd story)
    (user-trace "~&Input is") (print-cd cd)
    (process-cd cd)
    (user-trace "~%"))
  (user-trace "~%Story done - final script header")
  (print-cd (add-cd *current-script*))
  (user-trace "~%Database contains:")
  (print-cd *data-base*))

(defun process-cd (cd)
  "Takes one CD of the story at a time.  Either a
statement is predicted by the current script or it
is in the database or it suggests a new script."
  (or (integrate-into-script cd)
      (suggest-new-script cd)
      (progn (user-trace "~%Adding")
        (print-cd (add-cd cd))
        (user-trace "~%- not linked to any script"))))

(defun clear-scripts ()
  "Resets all globals to NIL"
  (setq *data-base* nil)
  (setf *current-script* nil)
  (setf *possible-next-events* nil))

(defun add-cd (cd)
  "Adds a new CD to the end of the DB list"
  (setq *data-base* (cons-end *data-base* cd))
  cd)

(defun integrate-into-script (cd)
  "Attempts to integrate an incoming statement into the 
currently active script, by finding the first event in 
*possible-next-events* that matches the statement.  If
such an event is found, update the database."
  (do* ((new-bindings nil)
        (events *possible-next-events* (cdr events))
        (event (first events) (first events)))
      ((or (null event) new-bindings)
       new-bindings)
    (setq new-bindings (match event cd *current-script*))
    (when new-bindings
      (setq *current-script* new-bindings)
      (user-trace "~%Matches")
      (print-cd event)
      (add-script-info event))))

(defun add-script-info (position)
  "ADD-SCRIPT-INFO is given an event in a script (the 
one that matched the input in INTEGRATE-INTO-SCRIPT).
Each script event up through position is instantiated
and added to the database."
  (do* ((events *possible-next-events* (cdr events))
        (event (first events) (first events))
        (at-position-p nil))
      ((or (null event) at-position-p)
       (setf *possible-next-events* events))
    (user-trace "~%Adding script CD")
    (print-cd (add-cd (instantiate event *current-script*)))
    (setq at-position-p (equal event position))))

(defun suggest-new-script (cd)
  "Takes a CD form, adds it to the database, and checks 
the predicates of the form and its subforms until a link
to a script is found (if any).  Thus, in (PTRANS (ACTOR 
(PERSON)) (OBJECT (PERSON)) (TO (STORE))), the first 
script is found under STORE.  If there was a previous 
script, add it to the database before switching to another
script, but do not instantiate any events that were left 
in *possible-next-events*."
  (let ((new-script (find-script cd)))
    (when new-script
      (and *current-script* (add-cd *current-script*))
      (user-trace "~%New script ~s" new-script)
      (setq *current-script* (list new-script))
      (setq *possible-next-events* (events-script new-script))
      (integrate-into-script cd))))

(defun find-script (cd)
  (cond ((atom cd) (associated-script cd))
        (t (or (associated-script (header-cd cd))
               (let ((script nil))
                 (some #'(lambda (pair)
                          (setq script (find-script (filler-pair pair))))
                       (roles-cd cd))
                 script)))))

(defun print-cd (cd)
  "Pretty-prints a CD form indented 4 spaces."
  (user-trace "~&~4T~s~%" cd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Data Structures for Scripts
;;;

;; Script names are atoms with the EVENTS property 
;; of the atom pointing to a list of events.

(defun events-script (x)
  "Returns sequence of events stored under a script."
  (get x :events))

(defsetf events-script (script) (events)
  `(setf (get ,script :events) ,events))

(defun associated-script (x)
  "Returns script associated with predicate x."
  (get x :associated-script))

(defsetf associated-script (x) (script)
  `(setf (get ,x :associated-script) ,script))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Example Scripts
;;;

;; $SHOPPING

(defparameter kite-story
  '((*ptrans* (actor (jack))
              (object (jack))
              (to (store)))
    (*atrans* (object (kite))
              (to (jack)))
    (*ptrans* (actor (jack))
              (object (jack))
              (to (house)))))

(setf (events-script '$SHOPPING)
      '((*ptrans* (actor ?shopper) (object ?shopper) (to ?store))
        (*ptrans* (actor ?shopper) (object ?bought) (to ?shopper))
        (*atrans* (actor ?store) (object ?bought) 
                  (from ?store) (to ?shopper))
        (*atrans* (actor ?shopper) (object (money))
                  (from ?shopper) (to ?store))
        (*ptrans* (actor ?shopper) (object ?shopper) 
                  (from ?store) (to ?elsewhere))))

(setf (associated-script 'store) '$shopping)

;; $RESTAURANT

(defparameter restaurant-story
  '((*ptrans* (actor (jack))
              (object (jack))
              (to (restaurant)))
    (*ingest* (actor (jack))
              (object (lobster)))
    (*ptrans* (actor (jack))
              (object (jack))
              (from (restaurant)))))

(setf (events-script '$restaurant)
      '((*ptrans* (actor ?diner)
                  (object ?diner)
                  (to ?restaurant))
        (*mtrans* (actor ?diner)
                  (object (ingest (actor ?diner)
                                  (object ?meal))))
        (*ingest* (actor ?diner)
                  (object ?meal))
        (*atrans* (actor ?diner)
                  (object (money))
                  (from ?diner)
                  (to ?restaurant))
        (*ptrans* (actor ?diner)
                  (object ?diner)
                  (from ?restaurant)
                  (to ?elsewhere))))

(setf (associated-script 'restaurant) '$restaurant)

(process-story kite-story)

(provide :micro-sam)