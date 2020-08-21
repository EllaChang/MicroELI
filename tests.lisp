(progn
  (load 'prph)
  (load 'surf)
  (load 'cd-functions)
  (load 'question-answering)
  (load 'dict)
  (load 'micro-eli)
  (EXPRESS (cd-translate (parse red-kite))))

(progn
  (load 'prph)
  (load 'surf)
  (nonet)
  ;;(net)
  ;; (trace do_frames do_heads_2 findheads popit token check_matching_syntax)
  ;; One half of Mary choked John...
  (EXPRESS '(((CON ((ACTOR (JOHN) <=> (*INGEST*) TO (*INSIDE* PART (JOHN)) FROM (*MOUTH* PART (JOHN)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2)) <≡ ((ACTOR (JOHN) <≡>T (*HEALTH* VAL (-10))) TIME (T-2))))))
  )

;; Demo 1. Mary choked John...
(EXPRESS '(((CON ((CON ((ACTOR (MARY) <=> (*GRASP*) OBJECT (*NECK* PART (JOHN))) TIME (T-4)) <≡ ((ACTOR (JOHN) <=> (*INGEST*) TO (*INSIDE* PART (JOHN)) FROM (*MOUTH* PART (JOHN)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2)))) ∧ ((CON ((ACTOR (JOHN) <=> (*INGEST*) TO (*INSIDE * PART (JOHN)) FROM (*MOUTH* PART (JOHN)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2)) <≡ ((ACTOR (JOHN) <≡>T (*HEALTH* VAL (-10))) TIME (T-2))))))))

;; Demo 2. Mary and John
(EXPRESS '(((CON
             ((CON
               ((CON
                 ((ACTOR (MARY) <=> (*DO*)) TIME (T-1))
                 <≡
                 ((ACTOR (JOHN) <≡>T (*HEALTH* VAL (-10))) TIME (T-1))
                 ))
               <≡C
               ((ACTOR (MARY) <≡>T (*JOY*) ) INC(+3) TIME(T-1))
               ))
             <≡> (*MLOC* VAL (*LTM* PART (MARY))))
            TIME (T-2))
           )
         )

;; Falstaff bought some wine from Hamlet
(EXPRESS '(((CON
             ((ACTOR (FAL) <=> (*ATRANS*) OBJECT (MONEY REF (INDEF)) TO (HAM)
                     FROM (FAL)) FOCUS ((ACTOR)) TIME (T-1))
             <≡≡>
             ((ACTOR (HAM) <=> (*ATRANS*) OBJECT (WINE1 REF (INDEF)) TO (FAL)
                     FROM (HAM)) TIME (T-1)FOCUS((ACTOR)))
             )FOCUS ((CON  OBJECT)))))

;; Some tracing
(trace do_frames do_heads findheads popit check_matching_syntax)
(untrace do_frames do_heads findheads popit)

;; trying to fix issues with quoted_head infinite loops
(trace qthd token putprop)
(untrace qthd token putprop)

;; These are good for fixing issues with FEXPRs
;; and discrimination nets
(trace aptree tnam smpval pval tval pot_head)
(trace doprp gochk gttree)

(untrace aptree tnam smpval pval tval pot_head)
(untrace doprp gochk gttree)

(trace id prop equ field)
;; don't print syntax nets.
(nonet)
;; print syntax nets.
(net)

(EXPRESS '(((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2))) ))
(EXPRESS '(((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2)) TIME (T-1) ) ))
(EXPRESS '(((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2)) MODE ((*NEG*)) TIME (T-1) ) )) 
(EXPRESS '(((ACTOR (MARY1) <=> (*INGEST*) TO (*INSIDE* PART (MARY1)) FROM (*MOUTH* PART (MARY1))))))

(EXPRESS '(((ACTOR (BOOK1 REF (DEF)) <≡> (*POSS* VAL (MARY1)) TIME (T-1)))))
(EXPRESS '(((ACTOR (BOOK1 REF (DEF)) <≡> (*POSS* VAL (MARY1))))))

;; Othello choked Desdemona (FROM GARB.EX #5)
(EXPRESS '(((CON ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-1)) <≡ ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT(*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-1))))))

;; Another similar one
(EXPRESS '(((CON ((CON ((CON ((ACTOR (DES) <=> (*DO*)) TIME (T-1)) <≡ ((ACTOR (OTH) <≡>T (*HEALTH* VAL (-10))) TIME (T-1)))) <≡C ((ACTOR (DES) <≡>T (*JOY*) ) INC(+3) TIME(T-1) ))) <≡> (*MLOC* VAL (*LTM* PART (DES)))) TIME (T-2))))

; 2 John knew Bill wanted a book
(EXPRESS '(((CON ((CON ((CON ((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1)) TIME (T-2)) <≡C ((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*)) INC (2) TIME (T-1)))) <≡> (*MLOC* VAL (*LTM* PART (BILL1)))) FOCUS ((<≡> VAL PART)) TIME (T-3)) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))) FOCUS  ((<≡> VAL PART))  TIME  (T-3))))

; 3 Hamlet advised Falstaff to drink the wine.
(EXPRESS '(((ACTOR (HAM) <=> (*MTRANS*) TO (*CP* PART (FAL)) FROM (*CP* PART (HAM))
                   MOBJECT  ((CON
                              ((ACTOR (FAL) <=> (*INGEST*) OBJECT (WINE1 REF (DEF))
                                      TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
                               TIME (T-2) FOCUS ((ACTOR)))
                              <≡C
                              ((ACTOR (FAL) <≡>T (*JOY*) <≡>F (*JOY*))
                               TIME (T-1) FOCUS ((ACTOR)) INC (2)))))
            TIME (T-3))))

; 4 John prevented Mary from reading the book
(EXPRESS '(((CON ((ACTOR (JOHN1) <=> (*DO*)) TIME (T-1))
                 <≡
                 ((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
                         FROM(BOOK1 REF (DEF)))
                  FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-1))
                 ))))


; 6 Mary ceased to have the book
(EXPRESS '(((ACTOR (BOOK1 REF (DEF)) <≡> (*POSS* VAL (MARY1))) TIME (T-1))))

; 7 Bill will give (return) a book to Mary
(EXPRESS '(((ACTOR (BILL1) <=> (*ATRANS*) OBJECT (BOOK1 REF (DEF)) TO (MARY1) FROM (BILL1))
            FOCUS ((ACTOR)) TIME (T2))))

; 8 Mary became happy
(EXPRESS '(((ACTOR (MARY1) <≡>T (*JOY* ) <≡>F (*JOY*)) TIME (T-3) INC (2))))

; 9 Mary is dead
(EXPRESS '(((ACTOR (MARY1) <≡> (*HEALTH* VAL (-10))) TIME (T-0) )))

; 10 Falstaff bought some wine from Hamlet
(EXPRESS '(((CON
             ((ACTOR (FAL) <=> (*ATRANS*) OBJECT (MONEY REF (INDEF)) TO (HAM)
                     FROM (FAL)) FOCUS ((ACTOR)) TIME (T-1))
             <≡≡>
             ((ACTOR (HAM) <=> (*ATRANS*) OBJECT (WINE1 REF (INDEF)) TO (FAL)
                     FROM (HAM)) TIME (T-1)FOCUS((ACTOR)))
             )FOCUS ((CON  OBJECT)))))




; This is the same AND structure that was used the generate the examples in Neil's  WRK/STR.TR on Othello choking Desdemona.  As of 11-24-2019 this generates a bug
(EXPRESS '(((CON ((CON ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-4)) <≡ ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2)))) ∧ ((CON ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE * PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2)) <≡ ((ACTOR (DES) <≡>T (*HEALTH* VAL (-10))) TIME (T-2))))))))

; OTHELLO CHOKED DESDEMONA
(EXPRESS '(((CON ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-4)) <≡ ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2))))))

; OTHELLO GRABBED DESDEMONAS NECK
(EXPRESS '(((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-4))))

;DESDEMONA COULD NOT BREATHE (on 12-24-2019 caused stack overflow, but I fixed it!)
(EXPRESS '(((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2))))

;"DESDEMONA BREATHED", "DESDEMONA INHALED AIR" (without *CANNOT*)
(EXPRESS '(((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) TIME (T-2))))

;; BILL POSSIBLY
(EXPRESS '(((CON ((CON
                   ((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1))
                    TIME (T1))
                   <≡C
                   ((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*))
                    INC (2) TIME (T2))))
                 <≡>
                 (*MLOC* VAL (*LTM* PART (BILL1))))
            FOCUS ((<≡> VAL PART)) TIME (T-0) CERTAINTY (.50))))

; JOHN MADE MARY READ THE BOOK
(EXPRESS '(((CON ((ACTOR (JOHN1) <=> (*DO*)) TIME (T-1))
                 <≡
                 ((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
                         FROM(BOOK1 REF (DEF)))
                  FOCUS ((ACTOR))  TIME (T-1))
                 ))))

;; MARY READ THE BOOK
(EXPRESS '(((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
                   FROM (BOOK1 REF (DEF)))
            FOCUS ((ACTOR))  TIME (T-1))))

(EXPRESS '(((ACTOR (JOHN1) <=> (*MTRANS*) TO (*CP* PART (MARY1) REF (DEF)) FROM (*CP* PART (JOHN1) REF (DEF)) MOBJECT ((CON ((ACTOR (BILL1) <=> (*DO*)) TIME (T-2) MODE (NIL)) <≡ ((ACTOR (MARY1) <≡>T (*HEALTH* VAL (-10)) <≡>F (*HEALTH* VAL (NIL))) MODE (NIL) TIME (T-2))))) TIME (T-3) FOCUS ((ACTOR)))))

(EXPRESS '(((ACTOR (JOHN1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) FROM (*CP* PART (JOHN1)) MOBJECT (*CONCEPTS*))) TIME (T-1)))

(EXPRESS '(((ACTOR (JOHN1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) FROM (BOOK1 REF (DEF)) MOBJECT (*CONCEPTS*)))
           FOCUS ((ACTOR))  TIME (T-1)))


(EXPRESS '((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
                  FROM (BOOK1 REF (DEF)))))

(EXPRESS '(((ACTOR (JOHN1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*))
            FOCUS ((ACTOR))  TIME (T-1))))

;; BILL KILLED MARY BY DOING SOMETHING
(EXPRESS '(((CON ((ACTOR (BILL1) <=> (*DO*)) TIME (T-2) MODE (NIL)) <≡ ((ACTOR (MARY1) <≡>T (*HEALTH* VAL (-10)) <≡>F (*HEALTH* VAL (NIL))) MODE (NIL) TIME (T-2))))))

(EXPRESS '( ((ACTOR (IAG) <=> (*MTRANS*) FROM (*CP* PART (IAG)) TO (*CP* PART (OTH))
                    MOBJECT ((ACTOR (HANDKERCHIEF *OWN* (DES)) <≡> (*POSS* VAL (CAS)))
                             TIME (T-3))
                    ) TIME (T-3))))



; Try to test the EKE tree?  Doesn't look like this should give us anything?  Wait ... why isn't the word "because" in here
(step (APTREE 'EKE
              '((CON ((ACTOR (JOHN1) <=> (*DO*)) TIME (T-1)) <≡
                     ((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
                             FROM (BOOK1 REF (DEF)))
                      FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-1))))))


; Try to test the EVT tree to see if I can get an UNABLE out of it
(step (APTREE 'EVT
              '((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM
                       (*MOUTH* PART (DES)) OBJECT (*AIR*))
                FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-1))))


(FINDHEADS '((CON ((CON
                    ((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1))
                     TIME (T1))
                    <≡C
                    ((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*))
                     INC (2) TIME (T2))))
                  <≡>
                  (*MLOC* VAL (*LTM* PART (BILL1))))
             FOCUS ((<≡> VAL PART)) TIME (T-0) CERTAINTY (.50)))



(EXPRESS '(((ACTOR (BILL1) <=> (*ATRANS*) OBJECT (BOOK1 REF (DEF)) TO (MARY1) FROM (BILL1))
            FOCUS ((ACTOR)) TIME (T2))))

(EXPRESS '(((ACTOR  (HAM) <=> (*MTRANS*) TO (*CP* PART (FAL)) FROM (*CP* PART (HAM))
                    MOBJECT  ((CON
                               ((ACTOR (FAL) <=> (*INGEST*) OBJECT (WINE1 REF (DEF))
                                       TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
                                TIME (T-2) FOCUS ((ACTOR)))
                               <≡C
                               ((ACTOR (FAL) <≡>T (*JOY*) <≡>F (*JOY*))
                                TIME (T-1) FOCUS ((ACTOR)) INC (2)))))
            TIME (T-3))))




(EXPRESS '(((ACTOR  (HAM) <=> (*MTRANS*) TO (*CP* PART (FAL)) FROM (*CP* PART (HAM))
                    MOBJECT  ((CON
                               ((ACTOR (FAL) <=> (*INGEST*) OBJECT (WINE1 REF (DEF))
                                       TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
                                TIME (T-2) FOCUS ((ACTOR)))
                               <≡C
                               ((ACTOR (FAL) <≡>T (*JOY*) <≡>F (*JOY*))
                                TIME (T-1) FOCUS ((ACTOR)) INC (2)))))
            TIME (T-3))))


(EXPRESS '((((CON ((CON
                    ((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1))
                     TIME (T1))
                    <≡C
                    ((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*))
                     INC (2) TIME (T2))))
                  <≡>
                  (*MLOC* VAL (*LTM* PART (BILL1))))
             FOCUS ((<≡> VAL PART)) TIME (T-0) CERTAINTY (.50)))))

(setq CD '((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2))))

(step (TNAM '((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2)))))

;;;;;;;;;;;; ======================
;; FROM EKC.EX
;;;;;;;;;;;; ======================

(EXPRESS (list (nth 2 ekc.ex)))

(EXPRESS (list (nth 2 atrans.ex)))

(load 'atrans.ex)
(load 'believ.ex) ;; these need work
(load 'crud.ex)
(load 'ekc.ex)
(load 'germ.ex)
(load 'go.ex) ;; These should probably be PTRANS
(load 'ingest.ex) ;; fourth one needs work
(load 'loan.ex) ;; Only one, but it works

(load 'mtrans.ex) ;; these need work

(load 'pay.ex) ;; first (and only) entry is good
(load 'perc.ex) ;; needs bugfixing
(load 'ptrans.ex) ;; these need a lot of work!
(load 'rand.ex) ;; all are OK
(load 'stat.ex) ;; all are OK
(load 'tst.ex) ;; first entry is OK but needs some fixing 
(load 'warn.ex) ; identical to tst.ex

(progn (load 'believ.ex)
  (EXPRESS (list (nth 2 *BELIEV.EX*)))
  )

(EXPRESS '(  ((ACTOR (*ONE*) <=> (*PTRANS*) OBJECT (DOG1) FROM ((NY1)) TO (SF1) 
                     INST ((ACTOR ((PLANE1) CONT (DOG1)) <=> (*PTRANS*) OBJECT (PLANE1) FROM (NY1) TO (SF1) VIA (*AIR*))))) ))

;;;;;;;;;;;; =======================

;; some generations straight to surf.lisp

;; This should generate "John saw"
(setf (symbol-plist 'E1) '(LEX (SEE) AUX ((1 2)) SUBJ E2 VOICE (ACT) FORM (SIM) TENSE (PAST) MOOD (INDIC)) )
(setf (symbol-plist 'E2) '(LEX (JOHN) NBR (S) TYP (SING3)) )

(INIT_SURF)
(gen 'E1)

;; This should generate "John is going to see"
(setf (symbol-plist 'E1) '(LEX (SEE) AUX ((1 2)) SUBJ E2 VOICE (ACT) FORM (SIM) TENSE (FUT) MOOD (INDIC)) )
(setf (symbol-plist 'E2) '(LEX (JOHN) NBR (S) TYP (SING3)) )

(INIT_SURF)
(gen 'E1)

;; Some other test code
;; (SYMBOL-PLIST 'E1)
;; (GET 'NP 'AFSTN)
;; (GET 'SING3 'GO)
;; (equal #\C (first (last (EXPLODE 'ABC))))
;; (intern (concatenate 'string "A" "B"))
;; (treein 'and)
;; (FINDHEADS '((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (JOHN1) TO (STORE2))) )
;; (TNAM '((CON
;;   ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-0))
;;   <≡ 
;;   ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
;;    OBJECT(*AIR*))
;;    FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-0))
;;          )))

;;  (step (APTREE 'EKE '((CON ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-0)) <≡ ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES)) OBJECT (*AIR*)) FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-0))))))

(foo bar)
(step (foo x y z))