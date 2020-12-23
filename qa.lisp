(require :micro-eli)
(require :micro-sam)
(require :prph)
(require :surf)
(require :dict)

(defun answer (question story)
  "Find the answer to a question given a story."
  (let ((ls (list (list 'dummy 'h)))
        (question-cd (parse-question question)))
    (dolist (sentence story)
      (let ((sentence-cd (parse sentence)))
        (when (and (equal (header-cd sentence-cd) (header-cd question-cd))
                   (or (equal (filler-role 'actor sentence-cd) (filler-role 'actor question-cd))
                       (equal (filler-role 'object sentence-cd) (filler-role 'object question-cd))
                       (equal (filler-role 'to sentence-cd) (filler-role 'to question-cd))))
          (push (list sentence-cd sentence) (cdr (last ls))))))
    (dolist (pair (cdr ls))
      (format t "~%The answer to the given question is:~%")
      (return-from answer (nth 1 pair)))))

(defun answer-cd (question story)
  "Find the answer to a question given a story."
  (let ((ls (list 'dummy)))
    (dolist (sentence story)
      (let ((sentence-cd sentence))
        (when (and (equal (header-cd sentence-cd) (header-cd question))
                   (or (equal (filler-role 'actor sentence-cd) (filler-role 'actor question))
                       (equal (filler-role 'object sentence-cd) (filler-role 'object question))
                       (equal (filler-role 'to sentence-cd) (filler-role 'to question))))
          (push sentence-cd (cdr (last ls))))))
    (dolist (cd (cdr ls))
      (format t "~%The CD answer to the given question is:~%")
      (return-from answer-cd cd))))

(defun express-cd (cd)
  "Express a BABEL CD form (i.e. turn in into natural language)."
  (express (list (list cd))))

(defun paraphrase (s)
  "Generate paraphrases for a given sentence."
  (express-cd (cd-translate (parse s))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Simple Story Question Answering Task
;;;

(setq story1
      '((jack went to the store)
        (jack got a kite)
        (jack went home)))

(setq story2
      '((jack went to the store)
        (bob went to the beach)
        (jack got a kite)
        (bob got a seashell)))

(setq story3
      '((nene went to the beach)
        (ella got a red knife)
        (ella went to Hawaii)))

(setq red-kite
      '(jack got a red kite))

(setq checks
      '((jack paid the check with a check)))

(setq q-who-store
      '(who went to the store))

(setq q-who-beach
      '(who went to the beach))

(setq q-who-kite
      '(who got a kite))

(setq q-who-seashell
      '(who got a seashell))

(setq q-where-jack
      '(where did jack go))

(setq q-where-bob
      '(where did bob go))

(setq q-do
      '(what did jack do))

; (write (answer q-who-store story2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  ProPara Question Answering Task
;;;

; (setq acid-rain
;       '((acid rain enters the atmosphere and lands)
;         (kite enters the atmosphere and lands)))

; (setq q-acid-rain
;       '(where does acid rain go))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Paraphrase Generation Task
;;;

; (write (paraphrase '(bob went to the beach)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Micro SAM Question Answering Task
;;;

; (process-story kite-story)

; (setq shop-story *data-base*)

; (progn
;   (load 'prph)
;   (load 'surf)
;   (nonet)
;   (let ((ls (list 'dummy)))
;     (dolist (cd (reverse (cdr (reverse shop-story))))
;       (push cd (cdr (last ls))))
;     (write (express-cd (cd-translate (answer-cd (parse-question q-where-jack) (cdr ls)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Testing Primitives
;;;

;; STATE
; (write (cd-translate (parse '(jack died))))

;; ATRANS
; (write (parse '(jack gave the knife to bob)))

;; EXPEL
; (write (parse '(the truck unloaded the trash)))

;; Parallel PTRANS & EXPEL
(write (cd-translate (parse '(jack unloaded the trash from the truck))))

;; STATE & PBUILD
; (write (parse '(the truck warmed up the trash)))

;; Testing the incorporated states
;;(write (cd-translate (parse '(the truck warmed up the trash))))
;; (write (cd-translate (parse '(the microwave warmed up the soup))))
; (write (cd-translate (parse '(the microwave warmed up the soup))))
; (write (cd-translate (parse '(jack went to the store))))
; (write (parse '(jack paid the check with a check)))
; (write (cd-translate (parse '(the dead plants join together))))
; (write (parse '(jack got the red kite)))
; (write (cd-translate (parse '(the volcanoes erupt lava))))
; (write (cd-translate (parse '(jack ate a lobster))))
; (write (cd-translate (parse '(gravity acts on the particles))))
; (write (cd-translate (parse '(the owl grabs the rabbit with beak))))
; (write (cd-translate (parse '(jack ordered a lobster))))