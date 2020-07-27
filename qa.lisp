(require :micro-eli)

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

(defun express-cd (cd)
  "Express a MicroELI CD form."
  (express (list (list cd))))

(defun paraphrase (s)
  (express-cd (cd-translate (parse s))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Simple Story Question Answering Task
;;;

(setq story1
      '((jack went to the store)
        (jack got a red kite)
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

(setq cd-kite
      (cd-translate (parse red-kite)))

(progn
  (load 'prph)
  (load 'surf)
  (nonet)
  (express-cd (cd-translate (parse (answer q-where-bob story2)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  ProPara Question Answering Task
;;;

(setq acid-rain
      '((acid rain enters the atmosphere and lands)
        (kite enters the atmosphere and lands)))

(setq q-acid-rain
      '(where does acid rain go))

; (write (answer q-acid-rain acid-rain))

;; Acid rain enters the atmosphere and lands.
;; How do greenhouse gases form?
;; Decomposition produces methane.

(provide :qa)