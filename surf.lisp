;; JCM: Should we put earmuffs on all of these?
(DEFPARAMETER !GR 'AFSTN)
(DEFPARAMETER !BREAKING T)
(DEFPARAMETER !TYP T)
(DEFPARAMETER !TMP! T)
(DEFPARAMETER !NODE T)


(DEFUN GEN
  (NODE) (PROG2 (PUTPROP NODE (QUOTE S) (QUOTE LAB)) (PRINT (FINDPATHS NODE))))


(DEFUN FINDPATHS
  (NODE) (PROG2 (COND (!BREAKING (BREAK NIL))) (CHOOSEPATH NODE (GET (GET NODE (QUOTE LAB)) !GR))))


(DEFUN CHOOSEPATH
  (NODE RHS)
  (PROG (RES)
        (PROG (&V &L1 ALT)
              (SETQ &L1 RHS)
         LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ ALT (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (COND
               ((SETQ RES
                      (COND ((ATOM ALT) (PUTPROP NODE ALT (QUOTE LAB)) (FINDPATHS NODE))
                            ((OR (GET NODE (CAR ALT)) (GET (CAR ALT) (QUOTE DF))) (FOLLOWPATH NODE ALT))))
                (RETURN &V)))
              (GO LOOP))
        (RETURN RES)))


(DEFUN FOLLOWPATH
  (NODE GRUL)
  (PROG (K)
        (COND ((ATOM (SETQ K (GET NODE (CAR GRUL)))) (SETQ K (NCONS K))))
        (PUTPROP NODE (CADR GRUL) (QUOTE LAB))
        (RETURN
         (COND
           ((AND (GET (CAR GRUL) (QUOTE SF)) (NULL (APPLY (CAR GRUL) (NCONS NODE)))) (FINDPATHS NODE))
           ((GET (CAR GRUL) (QUOTE TE)) (APPEND K (FINDPATHS NODE)))
           (T (PUTPROP (CAR K) (CAR GRUL) (QUOTE LAB)) (APPEND (FINDPATHS (CAR K)) (FINDPATHS NODE)))))))


(DEFUN VOICE
  (NODE)
  (PROG (VBSTR SBJ TMP)
        (SETQ VBSTR (GET NODE (QUOTE LEX)))
        (COND ((NOT (GET NODE (QUOTE VS_MADE))) (PUTPROP NODE VBSTR (QUOTE VS))))
        (COND ((SETQ TMP (GET NODE (QUOTE ACTSBJ))) (PUTPROP NODE (SETQ SBJ (CAR TMP)) (QUOTE SUBJ))))
        (PUTPROP NODE
                 (COND ((AND TMP (SETQ TMP (GET (CAR (GET SBJ (QUOTE LEX))) (QUOTE TYP)))) TMP)
                       (T (QUOTE SING3)))
                 (QUOTE TYP))))


(DEFUN FORM
  (NODE)
  (COND
   ((NOT (GET NODE (QUOTE VS_MADE)))
    (PROG (VBSTR)
          (COND
           ((EQUAL (GET NODE (QUOTE FORM)) (QUOTE (PROG)))
            (SETQ VBSTR (GET NODE (QUOTE VS)))
            (PUTPROP NODE (CONS (QUOTE BE) (CONS (PRGRSIFY (CAR VBSTR)) (CDR VBSTR))) (QUOTE VS))))))))


(DEFUN PRGRSIFY
  (V)
  ((LAMBDA (TMP)
    (COND (TMP TMP)
          (T
           ((LAMBDA (X)
              (INTERN
               ;; JCM: made plenty of changes to code below for Common Lisp strings.
              (CONCATENATE 'STRING (COND ((EQ (CAR (LAST X)) #\E) (SUBSEQ X 0 (SUB1 (LENGTH X)))) (T (STRING V))) "ING")))
            (EXPLODE V)))))
   (GET V (QUOTE !ING))))


(DEFUN MODAL
  (NODE) (PROG NIL (PUTPROP NODE (APPEND (GET NODE (QUOTE MODAL)) (GET NODE (QUOTE VS))) (QUOTE VS))))


(DEFUN TENSE
  (NODE)
  (COND
   ((NOT (GET NODE (QUOTE VS_MADE)))
    (PROG (VBSTR)
          (SETQ VBSTR (GET NODE (QUOTE VS)))
          (SETQ !TYP (GET NODE (QUOTE TYP)))
          (SETQ !NODE NODE)
          (PUTPROP NODE
                   (APPEND (APPLY (CAR (GET NODE (QUOTE TENSE))) (LIST (CAR VBSTR))) (CDR VBSTR))
                   (QUOTE VS))))))


(DEFUN PRES
  (V)
  (NCONS
   (COND
    ((EQ !TYP (QUOTE SING3))
     ((LAMBDA (TMP) (COND (TMP TMP)
                          (T (INTERN (CONCATENATE 'STRING (STRING V) "S")))))
      (GET V (QUOTE SING3))))
    ((EQ V (QUOTE BE)) (COND ((EQ !TYP (QUOTE SING1)) (QUOTE AM)) (T (QUOTE ARE))))
    (T V))))


(DEFUN PAST
  (V)
  (NCONS
   (COND
    ((AND (EQ V (QUOTE BE)) (OR (EQ !TYP (QUOTE SING3)) (EQ !TYP (QUOTE SING1)))) (QUOTE WAS))
    (T
     ((LAMBDA (TMP)
       (COND (TMP TMP)
             ((EQ (CAR (LAST (EXPLODE V))) #\E) (INTERN (CONCATENATE 'STRING (STRING V) "D")))
             (T (INTERN (CONCATENATE 'STRING (STRING V) "ED")) )))
      (GET V (QUOTE PAST)))))))



(DEFUN FUT
  (V) (CONS (CAR (PRES (QUOTE BE))) (LIST (QUOTE GOING) (QUOTE TO) (INFIN V))))


(DEFUN FUTPAST
  (V) (CONS (CAR (PAST (QUOTE BE))) (LIST (QUOTE GOING) (QUOTE TO) (INFIN V))))


(DEFUN PRESPAST
  (V) (PAST V))


(DEFUN PASTPAST
  (V) (PASTPERF V))


(DEFUN FUTFUT
  (V) (FUT V))


(DEFUN PRESFUT
  (V) (PRES V))


(DEFUN PASTFUT
  (V) (PAST V))


(DEFUN PASTPERF
  (V) (CONS (QUOTE HAD) (NCONS (PERFECTIFY V))))


(DEFUN PERFECTIFY
  (V) ((LAMBDA (TMP) (COND (TMP TMP) (T (INTERN (CONCATENATE (STRING V) "ED"))))) (GET V (QUOTE !EN))))


(DEFUN INFIN
  (V) ((LAMBDA (TMP) (COND (TMP TMP) (T (CAR (GET !NODE (QUOTE LEX)))))) (GET V (QUOTE INF))))


(DEFUN MOOD
  (NODE) (PROG2 (PUTPROP NODE (CAR (GET NODE (QUOTE MOOD))) (QUOTE LAB)) NIL))


(DEFUN CNDIT
  (NODE)
  (COND
   ((NOT (GET NODE (QUOTE VS_MADE)))
    (PROG (VBSTR)
          (SETQ VBSTR (GET NODE (QUOTE VS)))
          (SETQ !NODE NODE)
          (PUTPROP NODE (CONS (QUOTE WOULD) (CONS (INFIN (CAR VBSTR)) (CDR VBSTR))) (QUOTE VS))))))


(DEFUN IVT
  (NODE)
  (PROG (VBSTR)
        (COND
         ((OR (CDR (SETQ VBSTR (GET NODE (QUOTE VS)))) (EQUAL (GET NODE (QUOTE LEX)) (QUOTE (BE))))
          (PUTPROP NODE (PRELIST VBSTR 1) (QUOTE VS1))
          (PUTPROP NODE (CDR VBSTR) (QUOTE VS)))
         (T (SETQ !NODE NODE)
            (PUTPROP NODE (INFIN (CAR VBSTR)) (QUOTE VS))
            (SETQ !TYP (COND ((GET NODE (QUOTE SUBJ)) (GET NODE (QUOTE TYP))) (T (QUOTE SING3))))
            (PUTPROP NODE (APPLY (CAR (GET NODE (QUOTE TENSE))) (LIST (QUOTE DO))) (QUOTE VS1))))))


(DEFUN PRON
  (NODE)
  (PROG2 (PUTPROP NODE (LIST (GET (GET NODE (QUOTE PRON)) (GET NODE (QUOTE CASE)))) (QUOTE NS)) NIL))


(DEFUN POSS
  (NODE) (PUTPROP (CAR (GET NODE (QUOTE POSS))) (QUOTE POSS) (QUOTE CASE)))


(DEFUN DET
  (NODE) (PROG2 (PUTPROP NODE (GET NODE (QUOTE DET)) (QUOTE NS)) NIL))


(DEFUN QUANT
  (NODE)
  (PROG (TMP)
        (SETQ TMP (CAR (GET NODE (QUOTE QUANT))))
        (PUTPROP NODE (APPEND (GET NODE (QUOTE NS)) (NCONS TMP)) (QUOTE NS))
        (COND ((AND (NUMBERP TMP) (*GREAT TMP 1)) (PUTPROP NODE (QUOTE PL) (QUOTE NBR))))))


(DEFUN NBR
  (NODE)
  (PROG (NOUN)
        (SETQ NOUN (CAR (GET NODE (QUOTE LEX))))
        (PUTPROP NODE ((LAMBDA (PRN) (COND (PRN PRN) (T (QUOTE IT)))) (GET NOUN (QUOTE PRON))) (QUOTE PRON))
        (COND ((EQ (GET NODE (QUOTE NBR)) (QUOTE PL)) (SETQ NOUN (PLUR NOUN))))
        (COND ((EQ (GET NODE (QUOTE CASE)) (QUOTE POSS)) (SETQ NOUN (INTERN (CONCATENATE 'STRING (STRING NOUN) "S")))))
        (PUTPROP NODE (APPEND (GET NODE (QUOTE NS)) (NCONS NOUN)) (QUOTE NS))))


(DEFUN PLUR
  (NOUN) (INTERN (CONCATENATE 'STRING (STRING NOUN) "S")))


(DEFUN DEG
  (NODE)
  (PROG (DEGREE ADJ)
        (SETQ ADJ (CAR (GET NODE (QUOTE LEX))))
        (COND ((SETQ DEGREE (GET NODE (QUOTE DEG))) (SETQ DEGREE (CAR DEGREE))) (T (SETQ DEGREE (QUOTE POS))))
        (PUTPROP NODE
                 (LIST (COND ((EQ DEGREE (QUOTE POS)) ADJ) ((EQ DEGREE (QUOTE REL)) (RELATIVEIZE ADJ))))
                 (QUOTE MS))))


(DEFUN RELATIVEIZE
  (ADJ) ((LAMBDA (TMP) (COND (TMP TMP) (T (INTERN (CONCATENATE 'STRING (STRING ADJ) "ER"))))) (GET ADJ (QUOTE REL))))


(DEFUN POBJ
  (NODE) (PUTPROP (CAR (GET NODE (QUOTE POBJ))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN OBJ
  (NODE) (PUTPROP (CAR (GET NODE (QUOTE OBJ))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN OBJ2
  (NODE) (PUTPROP (CAR (GET NODE (QUOTE OBJ2))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN SUBJ
  (NODE)
  (COND
   ((NOT (GET NODE (QUOTE DEL_SUBJ)))
    (PROG (TMP)
          (COND
           ((NOT (AND (SETQ TMP (GET NODE (QUOTE INFOF))) (EQ (GET NODE (QUOTE SUBJ)) (GET TMP (QUOTE SUBJ)))))
            (RETURN
             (PUTPROP (GET NODE (QUOTE SUBJ))
                      (COND ((GET NODE (QUOTE OBJSUBJ)) (QUOTE OBJ)) (T (QUOTE NOM)))
                      (QUOTE CASE)))))))))


(DEFUN NGT
  (NODE)
  (PROG (VBSTR)
        (COND
          ((NOT (OR (CDR (SETQ VBSTR (GET NODE 'VS))) (EQUAL (GET NODE 'LEX) '(BE))))
          (SETQ !NODE NODE)
          (SETQ !TYP (COND ((GET NODE 'SUBJ) (GET NODE 'TYP)) (T 'SING3)))
          (SETQ VBSTR (APPEND (APPLY (CAR (GET NODE 'TENSE)) (LIST 'DO)) (INFIN (CAR VBSTR))))))
    (PUTPROP NODE (CONS (CAR VBSTR) (APPEND (GET NODE 'NGT) (SUFLIST VBSTR 1))) 'VS)))


(DEFUN INF
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE INF))))
        (PUTPROP VNODE (CONS (QUOTE TO) (GET VNODE (QUOTE LEX))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (PUTPROP VNODE NODE (QUOTE INFOF))
        (PUTPROP VNODE T (QUOTE OBJSUBJ))
        (RETURN T)))


(DEFUN INF2
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE INF2))))
        (PUTPROP VNODE (CONS (QUOTE TO) (GET VNODE (QUOTE LEX))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE DEL_SUBJ))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (RETURN T)))


(DEFUN PRSNT
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE PRSNT))))
        (PUTPROP VNODE (GET VNODE (QUOTE LEX)) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (PUTPROP VNODE T (QUOTE OBJSUBJ))
        (RETURN T)))


(DEFUN INST2
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE INST2))))
        (PUTPROP VNODE (CONS (QUOTE BY) (NCONS (PRGRSIFY (CAR (GET VNODE (QUOTE LEX)))))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE DEL_SUBJ))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (RETURN T)))


(DEFUN SPRG
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE SPRG))))
        (PUTPROP VNODE (CONS (QUOTE FROM) (NCONS (PRGRSIFY (CAR (GET VNODE (QUOTE LEX)))))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (PUTPROP VNODE T (QUOTE OBJSUBJ))
        (RETURN T)))


(DEFUN GSBJ
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE GSBJ))))
        (PUTPROP VNODE (NCONS (PRGRSIFY (CAR (GET VNODE (QUOTE LEX))))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (PUTPROP VNODE T (QUOTE DEL_SUBJ))
    (RETURN T)))

;; JCM new function, is basically a copy of GSBJ
;; except for OBJSUBJ instead of DEL_SUBJ
(DEFUN GOBJ
  (NODE)
  (PROG (VNODE)
        (SETQ VNODE (CAR (GET NODE (QUOTE GOBJ))))
        (PUTPROP VNODE (NCONS (PRGRSIFY (CAR (GET VNODE (QUOTE LEX))))) (QUOTE VS))
        (PUTPROP VNODE T (QUOTE VS_MADE))
        (PUTPROP VNODE T (QUOTE OBJSUBJ)) 
    (RETURN T)))



(DEFUN INF3
  (NODE)
  (PROG NIL
        (PUTPROP NODE (GET (CAR (GET NODE (QUOTE INF3))) (QUOTE ACTSBJ)) (QUOTE ACTSBJ))
        (PUTPROP NODE (GET NODE (QUOTE INF3)) (QUOTE INF2))
        (REMPROP NODE (QUOTE INF3))))


(DEFUN OPENS
  (FILE)
  (PROG NIL
        (EVAL (LIST (QUOTE INC) (LIST (QUOTE INPUT) (QUOTE (SIM NMG)) FILE) NIL))
        (PRINT (QUOTE LOADING))
        (PRINC TAB)
        (PRINC FILE)))


(DEFUN SURFEXP
  (X) (COND ((ATOM X) (PRINT (NCONS X))) (T (GEN (CAR X)))))




(DEFUN INIT_SURF
    NIL
  (PROG NIL
        (SETQ !BREAKING NIL)
        (PROG (&V &L1 X)
              (SETQ &L1 (QUOTE (LEX PREP VS VS1 NS MS PART1 PART2 MAN)))
         LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X T (QUOTE TE)))
              (GO LOOP))
        (PROG (&V &L1 X)
              (SETQ &L1
                    (QUOTE
                     (VOICE FORM TENSE MOOD INF INF2 INF3 POBJ
                            SUBJ PNOM OBJ POSS DEG PRON OBJ2 MODAL
                            GSBJ IVT CNDIT NBR INST2 SPRG GOBJ QUANT DET
                            NGT PRSNT)))
         LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X T (QUOTE SF)))
              (GO LOOP))
        (PROG (&V &L1 X)
              (SETQ &L1 (QUOTE (NBR IVT CNDIT DEG)))
         LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X T (QUOTE DF)))
              (GO LOOP))
        (PROG (&V &L1 X)
              (SETQ &L1 (QUOTE (HE SHE IT THEY)))
         LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X X (QUOTE NOM)))
              (GO LOOP))
        (SETF (GET 'BE 'PL) 'ARE)
        ;; This is now handled by code at the end of this file.
        ;; (SETQ !GR (QUOTE AFSTN))
        ;; (OPENS !GR)
        ;; (PROG (&V)
        ;;  LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ))))) (SETQ &V (PUTPROP (CAR !TMP!) (CDR !TMP!) !GR)))
        ;;             (T (RETURN &V)))
        ;;       (GO LOOP))
        ;; (INC NIL T)
        ;; (OPENS (QUOTE LEX1))
        ;; (PROG (&V)
        ;;  LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ))))) (SETQ &V (DEFLIST (READ) !TMP!)))
        ;;             (T (RETURN &V)))
        ;;       (GO LOOP))
        ;; (INC NIL T)
        )
  )

(DEFUN DEFLIST
  (PAIR_LIS PROP)
  (PROG (&V ?&LST1 X)
        (SETQ ?&LST1 PAIR_LIS)
   LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
        (SETQ X (CAR ?&LST1))
        (SETQ &V (PUTPROP (CAR X) (CADR X) PROP))
        (SETQ ?&LST1 (CDR ?&LST1))
        (GO LOOP)))

(DEFUN PUTPROP (ID VAL PROP) (SETF (GET ID PROP) VAL))
(DEFUN NCONS (X) (CONS X NIL))
(DEFUN EXPLODE (X) (COERCE (STRING X) 'list))


(SETQ FORM '(
             E1 ( TOK (SEE) AUX ((1 2)) AGT (E2) OBJ (E3) VOICE (ACT) FORM (SIM) TENSE (PAST) MOOD (INDIC) )
             E2 ( TOK (JOHN) NBR (S) TYP (SING3))
             E3 ( TOK (WRESTLE) AUX ((0 3)) AGT (E4) DAT (E5) VOICE (ACT) FORM (PROG) TENSE (PAST) MOOD (INDIC) )
             E4 ( TOK (MARY) NBR (S) TYP (SING3))
             E5 ( PREP (WITH) POBJ (E6) )
             E6 ( TOK (BOTTLE) NBR (S) TYP (SING3) DET (A))
             )
      )

(SETQ FORM '(TOK (SEE) AUX ((1 2)) AGT (E2) OBJ (E3) VOICE (ACT) FORM (SIM) TENSE (PAST) MOOD (INDIC) ))


;; Set the !GR to be AFSTN.  In the old code we would read this from a
;; separate file.  (See commented code in INIT_SURF above
(SETQ !GR (QUOTE AFSTN))
;; The AFSTN grammar, from file AFSTN (not GR1 !!)
;; This code populates the property list with it
;; (note, format is different from that in GR1)
(mapcar #'(lambda (x) (PUTPROP (CAR x) (CDR x) !GR))
        '(
          (S	(FIRS SNT1) (INF3 V0) V0)
          (V0	(VOICE V1))
          (SNT1	(LEX SNT2))
          (SNT2   (SECS T))
          (V1 	(FORM V2))
          (V2   (MODAL V3) V3)
          (V3	(TENSE V4))
          (V4  	(MOOD T))
          (COND   (CNDIT INDIC))
          (INTERROG (IVT INDIC))
          (SUBJUNC INDIC)
          (INDIC  (VS1 SBJ) SBJ)
          (SBJ  	(SUBJ PRED) (GSBJ PRED))
          (PRED	(MAN PRED1) PRED1)
          (PRED1	(NGT VP0) VP0)
          (VP0	(VS VP1))
          (VP1	(PART1 VP2) VP2)
          (VP2	(OBJ2 VP3) VP3)
          (VP3	(PP1 VP4) VP4)
          (VP4	(P_ADJ VP5) VP5)
          (VP5	(LOC VP6) VP6)
          (VP6    (OBJ VP7) VP7)
          (VP7	(PART2 VP8) VP8)
           (VP8	(IOBJ VP9) VP9)
           ;; JCM added GOBJ to the below
          (VP9	(INF VP10) (INF2 VP10)(S2 VP10)(S3 VP10)(SPRG VP10)(PRSNT VP10) (GOBJ VP10) VP10)
          (VP10	(INST T)(INST2 T))
          (INST2  S)
          (SPRG   S)
          (INF	S)
          (INF2   S)
          (S2	S)
          (FIRS	S)
          (SECS	S)
          (GSBJ	S)
           (PRSNT S)
           (GOBJ S) ;; JCM new addition
          (PP1	PNP)
          (INST	PNP)
          (IOBJ	PNP)
          (LOC	PNP)
          (PNP	(PREP PNP1))
          (PNP1	(POBJ T))
          (SUBJ	NP)
          (OBJ	NP)
          (POBJ	NP)
          (OBJ2   NP)
          (NP	(PRON NP3)(POSS NP1)(DET NP1) NP1)
          (NP1	(QUANT NP2) NP2)
          (NP2    (NBR NP3))
           (NP3	(NS NP4))
           (NP4	(PP1 NP5) NP5)
           (NP5 (INF2 T) T);; JCM new addition
          (POSS	(PRON NP3) (DET NP1) NP1)
          (P_ADJ  MOD)
          (MOD	(DEG MOD1))
          (MOD1	 (MS T))
          )
        )

;; Code for handling the lexicon.
;; In the old code we would read this from a
;; separate file.  And the file was formatted a bit differently
;; (See commented code in INIT_SURF above)
;; This code populates the property list with it
;; This time by just setf-ing symbol-plist  (DEFLIST (READ) !TMP!)))
(mapcar #'(lambda (x) (DEFLIST (CADR X) (CAR X)) )
                  '(
                    (SING3
                     ((BE IS)(GO GOES)(HAVE HAS)(DO DOES)(CAN CAN))
                     )
                    (PAST
                     ((BE WERE)(BECOME BECAME)(BUY BOUGHT) (CAN COULD)(COME CAME) (DO DID)(DRINK DRANK)(EAT ATE) (GET GOT)(GIVE GAVE)(GO WENT)(GRAB GRABBED) (HEAR HEARD)(HAVE HAD)(HIT HIT)(KNOW KNEW)(MAKE MADE)(READ READ) (STAB STABBED)(SEE SAW)(SELL SOLD)(TAKE TOOK)(TELL TOLD)(THINK THOUGHT) (LOSE LOST))
                     )
                    (!ING
                     ((BE BEING) (HAVE HAVING) (GRAB GRABBING) (STAB STABBING) (DIE DYING))
                     )
                    (!EN
                     ((BE BEEN)(BUY BOUGHT)(COME COME)(CAN BEEN-ABLE-TO) (DO DONE)(DRINK DRUNK)(EAT EATEN) (GET GOTTEN)(GIVE GIVEN)(GO GONE) (HAVE HAD)(HIT HIT)(HEAR HEARD) (KNOW KNOWN)(MAKE MADE)(READ READ) (SEE SEEN)(SELL SOLD)(TAKE TAKEN)(TELL TOLD)(THINK THOUGHT))
                     )
                    (PRON
                     ((JOHN HE) (BILL HE) (MARY SHE) (FRED HE) (HAMLET HE) (LAERTES HE) (OTHELLO HE) (IAGO HE) (CASSIO HE) (DESDEMONA SHE) (FALSTAFF HE)(SOMEONE HE))
                     )
                    (CONJ
                     ((AND T) (BECAUSE T))
                     )
                    (OBJ
                     ((HE HIM) (SHE HER) (IT IT) (THEY THEM) (I ME) (YOU YOU) (WE US))
                     )
                    (POSS
                     ((HE HIS) (SHE HER) (IT ITS) (THEY THEIR) (I MY) (YOU YOUR) (WE OUR))
                     )
                    (INF
                     ((CAN BE_ABLE_TO) (IS BE)(WAS BE)(HAD HAVE)(HAS HAVE))
                     )
          ) ;; ends big quoted s-exp
        ) ;; ends mapcar


(INIT_SURF)

(provide :surf)