;; JCM: Should we put earmuffs on all of these?
(DEFPARAMETER !GR T)
(DEFPARAMETER TIME T)
(DEFPARAMETER PREPOS T)
(DEFPARAMETER POSTPOS T)
(DEFPARAMETER !MODE T)
(DEFPARAMETER YY T)
(DEFPARAMETER !K! T)
(DEFPARAMETER BREAKING T)
(DEFPARAMETER LPROP T)
(DEFPARAMETER !TYP T)
(DEFPARAMETER !SBJ T)
(DEFPARAMETER !TMP! T)

(DEFUN GEN
    (STRUCLIST)
  (COND ((NULL STRUCLIST) T)
        (T (PROG NIL
                 (SETQ PREPOS NIL)
                 (SETQ POSTPOS NIL)
                 (SETQ !MODE (QUOTE MAIN))
                 (SETQ YY (CAR STRUCLIST))
                 (PUTPROP YY (QUOTE S) (QUOTE LAB))
                 (PRINT (APPEND PREPOS (APPEND (GLKUP (LIST YY)) POSTPOS)))))))

(DEFUN GLKUP ;; grammar lookup?
    (STRUCS)
  (COND (STRUCS (COND (BREAKING (BREAK NIL)) (T NIL))
                (COND ((CDR STRUCS) (APPEND (GLKUP (LIST (CAR STRUCS))) (CONS COMMA (GLKUP (CDR STRUCS)))))
                      (T
                       ((LAMBDA (J)
                         (COND (J (COND ((ATOM J) (PUTPROP (CAR STRUCS) J (QUOTE LAB)) (GLKUP STRUCS))
                                        (T (GLKUPH (CAR STRUCS) J))))
                               (T NIL)))
                        (GET (GET (CAR STRUCS) (QUOTE LAB)) !GR)))))
        (T NIL)))

(DEFUN GLKUPH
  (STRUC JJ)
  (PROG (RES)
        (PROG (&V ?&LST1 J)
              (SETQ ?&LST1 JJ)
         LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
              (SETQ J (CAR ?&LST1))
              (COND
               ((SETQ RES
                      (COND ((NULL (CDR J)) (PUTPROP STRUC (CAR J) (QUOTE LAB)) (GLKUP (LIST STRUC)))
                            ((OR (GET STRUC (CAR J)) (GET (CAR J) (QUOTE RF))) (DIVID STRUC J))
                            (T NIL)))
                (RETURN &V))
               (T NIL))
              (SETQ ?&LST1 (CDR ?&LST1))
              (GO LOOP))
        (RETURN RES)))


(DEFUN DIVID
  (STRUC GRUL)
  (PROG NIL
        (SETQ !K! (GET STRUC (CAR GRUL)))
        (PUTPROP STRUC (CADR GRUL) (QUOTE LAB))
        (RETURN
         (COND
          ((AND (GET (CAR GRUL) (QUOTE TF)) (NULL (APPLY (CAR GRUL) NIL))) (GLKUP (LIST STRUC)))
          ((GET (CAR GRUL) (QUOTE TE)) (APPEND !K! (GLKUP (LIST STRUC))))
          (T (DELET STRUC !K! (GET (CAR GRUL) (QUOTE INV)))
             (APPEND (GLKUP (HET !K! (CAR GRUL) (QUOTE LAB))) (GLKUP (LIST STRUC))))))))


(DEFUN DELET
  (STRUC K RUL)
  (COND (RUL
         (PROG (&V ?&LST1 X)
               (SETQ ?&LST1 K)
          LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
               (SETQ X (CAR ?&LST1))
               (SETQ &V (PUTPROP X (DELET! STRUC (GET X RUL)) RUL))
               (SETQ ?&LST1 (CDR ?&LST1))
               (GO LOOP)))
        (T NIL)))


(DEFUN DELET!
  (STRUC L)
  (COND ((ATOM L) NIL) ((EQ (CAR L) STRUC) (CDR L)) (T (CONS (CAR L) (DELET! STRUC (CDR L))))))


(DEFUN HET
  (A V P)
  (COND (P (COND ((ATOM A) (PUTPROP A V P) (LIST A))
                 (T (PROG (&V ?&LST1 X)
                          (SETQ ?&LST1 A)
                     LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
                          (SETQ X (CAR ?&LST1))
                          (SETQ &V (PUTPROP X V P))
                          (SETQ ?&LST1 (CDR ?&LST1))
                          (GO LOOP))
                    A)))
        (T NIL)))


(DEFUN EARLIEST
  (EVENTS)
  (COND ((ATOM EVENTS) (SETQ YY EVENTS))
        ((NULL (CDR EVENTS)) (SETQ YY (CAR EVENTS)))
        ((AND (*GREAT (CAR (GET (CAR EVENTS) (QUOTE AUX))) (CAR (GET (CADR EVENTS) (QUOTE AUX))))
              (OR (MEMQ (CAR EVENTS) XX) (SETQ XX (CONS (CAR EVENTS) XX))))
         (EARLIEST (CDR EVENTS)))
        ((OR (MEMQ (CADR EVENTS) XX) (SETQ XX (CONS (CADR EVENTS) XX))) (EARLIEST (CONS (CAR X) (CDDR X))))
        (T NIL)))


(DEFUN REMBER
  (A L) (DELET! A L))


(DEFUN ADDPROP
  (I V P) (PUTPROP I (CONS V (GET I P)) P))


(DEFUN RESTORENET
  (L)
  (PROG (&V)
   LOOP (COND (L (SETQ &V
                       (PROG NIL
                             (RPLACD (CAR L) (CONS 'PNAME (CONS (GET (CAR L) 'PNAME) (CADR L))))
                             (SETQ L (CDDR L)))))
              (T (RETURN &V)))
        (GO LOOP)))


(DEFUN TENSE
  NIL
  (PROG (VBSTR)
        (SETQ VBSTR (GET STRUC (QUOTE VS)))
        (SETQ !SBJ (GET STRUC (QUOTE SUBJ)))
        (SETQ !TYP (GET !SBJ (QUOTE TYP)))
        (PUTPROP STRUC
                 (APPEND (APPLY (CAR (GET STRUC (QUOTE TENSE))) (LIST (CAR VBSTR))) (CDR VBSTR))
                 (QUOTE VS))))


(DEFUN PRES
  (V)
  (COND
   ((EQ !TYP (QUOTE SING3))
    (LIST ((LAMBDA (TMP) (COND (TMP TMP) (T (AT (CAT V (QUOTE "S")))))) (GET V (QUOTE SING3)))))
   ((EQ V (QUOTE BE)) (COND ((EQ (GET !SBJ (QUOTE PRON)) (QUOTE I)) (QUOTE (AM))) (T (QUOTE (ARE)))))
   (T (LIST V))))


(DEFUN PAST
  (V)
  (COND
   ((AND (EQ V (QUOTE BE)) (OR (EQ !TYP (QUOTE SING3)) (EQ (GET !SBJ (QUOTE PRON)) (QUOTE I)))) (QUOTE (WAS)))
   (T (LIST ((LAMBDA (TMP) (COND (TMP TMP) (T (AT (CAT V (QUOTE "ED")))))) (GET V (QUOTE PAST)))))))


(DEFUN FUT
  (V) (LIST (QUOTE WILL) V))


(DEFUN PRESPERF
  (V) (CONS (PRES (QUOTE HAVE)) (LIST (PERFECTIFY V))))


(DEFUN PASTPERF
  (V) (CONS (QUOTE HAD) (LIST (PERFECTIFY V))))


(DEFUN FUTPERF
  (V) (CONS (QUOTE WILL) (CONS (QUOTE HAVE) (LIST (PERFECTIFY V)))))


(DEFUN FORM
  NIL
  (PROG (FM VBSTR)
        (SETQ FM (GET STRUC (QUOTE FORM)))
        (COND ((NOT (EQUAL FM (QUOTE (SIM))))
               (SETQ VBSTR (GET STRUC (QUOTE VS)))
               (COND ((EQUAL FM (QUOTE (EMPH))) (PUTPROP STRUC (CONS (QUOTE DO) VBSTR) (QUOTE VS)))
                     (T (PUTPROP STRUC
                                 (CONS (QUOTE BE) (CONS (PRGRSIFY (CAR VBSTR)) (CDR VBSTR)))
                                 (QUOTE VS)))))
              (T NIL))))


(DEFUN PERFECTIFY
  (V) ((LAMBDA (TMP) (COND (TMP TMP) (T (AT (CAT V (QUOTE "ED")))))) (GET V (QUOTE !EN))))


(DEFUN PRGRSIFY
  (V) ((LAMBDA (TMP) (COND (TMP TMP) (T (AT (CAT V (QUOTE "ING")))))) (GET V (QUOTE !ING))))


(DEFUN VOICE
  NIL
  (PROG (VBSTR VC SBJ)
        (SETQ VBSTR (GET STRUC (QUOTE TOK)))
        (SETQ VC (GET STRUC (QUOTE VOICE)))
        (COND ((EQUAL VC (QUOTE (PAS)))
               (PUTPROP STRUC (LIST (QUOTE BE) (GET (CAR VBSTR) (QUOTE !EN))) (QUOTE VS))
               (PUTPROP STRUC (SETQ SBJ (CAR (GET STRUC (QUOTE OBJ)))) (QUOTE SUBJ))
               (DELET STRUC (GET STRUC (QUOTE OBJ)) (QUOTE OBJ!))
               (REMPROP STRUC (QUOTE OBJ))
               (PUTPROP STRUC
                        (HET (HET (LIST (GENSYM)) (QUOTE (BY)) (QUOTE PREP))
                             (GET STRUC (QUOTE AGT))
                             (QUOTE POBJ))
                        (QUOTE SOBJ))
               (DELET STRUC (GET STRUC (QUOTE AGT)) (QUOTE AGT!)))
              (T (PUTPROP STRUC VBSTR (QUOTE VS))
                 (PUTPROP STRUC (SETQ SBJ (CAR (GET STRUC (QUOTE AGT)))) (QUOTE SUBJ))
                 (DELET STRUC (GET STRUC (QUOTE AGT)) (QUOTE AGT!))))
        (PUTPROP SBJ (GET (CAR (GET SBJ (QUOTE TOK))) (QUOTE TYP)) (QUOTE TYP))))


(DEFUN INF
  NIL ((LAMBDA (GVAL) (PUTPROP GVAL STRUC (QUOTE INFOF))) (CAR (GET STRUC (QUOTE INF)))))


(DEFUN INF2
  NIL
  ((LAMBDA (GVAL) (PUTPROP GVAL (CONS (QUOTE TO) (GET GVAL (QUOTE TOK))) (QUOTE VS)))
   (CAR (GET STRUC (QUOTE INF2)))))


(DEFUN MOOD
  NIL (PROG NIL (PUTPROP STRUC (CAR (GET STRUC (QUOTE MOOD))) (QUOTE LAB))))


(DEFUN DEG
  NIL
  (PROG (GVAL)
        (COND ((EQ (SETQ GVAL (CAR (GET STRUC (QUOTE DEG)))) (QUOTE POS))
               (PUTPROP STRUC (GET STRUC (QUOTE TOK)) (QUOTE MS)))
              (T (PUTPROP STRUC (LIST (GET (CAR (GET STRUC (QUOTE TOK))) GVAL)) (QUOTE MS))))))


(DEFUN NBR
  NIL
  (PROG (TMP NOUN)
        (SETQ NOUN (CAR (GET STRUC (QUOTE TOK))))
        (PUTPROP STRUC (GET NOUN (QUOTE PRON)) (QUOTE PRON))
        (COND
         ((SETQ TMP (AND (GET STRUC (QUOTE NBR)) (SETQ TMP (GET NOUN (CAR TMP))))) (SETQ NOUN TMP))
         (T NIL))
        (COND
         ((AND (EQ (GET STRUC (QUOTE CASE)) (QUOTE POSS)) (SETQ TMP (GET NOUN (QUOTE POSS)))) (SETQ NOUN TMP))
         (T NIL))
        (PUTPROP STRUC (LIST NOUN) (QUOTE NS))))


(DEFUN AUX
  NIL
  (PROG (GVAL)
        (COND ((NOT (GET STRUC (QUOTE INFOF)))
               (PUTPROP STRUC
                        (CONS (PRGRSIFY (CAR (SETQ GVAL (GET STRUC (QUOTE VS))))) (CDR GVAL))
                        (QUOTE VS)))
              (T (ADDPROP STRUC (QUOTE TO) (QUOTE VS))))))


(DEFUN FIRN
  NIL
  (PROG (TMP)
        (PUTPROP STRUC (GET (GET STRUC (QUOTE TOK)) (QUOTE PRON)) (QUOTE PRON))
        (PUTPROP (SETQ TMP (GET STRUC (QUOTE FIRN))) (GET STRUC (QUOTE CASE)) (QUOTE CASE))
        (RETURN TMP)))


(DEFUN SECN
  NIL
  (PROG (TMP)
        (PUTPROP (SETQ TMP (GET STRUC (QUOTE SECN))) (GET STRUC (QUOTE CASE)) (QUOTE CASE))
        (RETURN TMP)))


(DEFUN POBJ
  NIL (PUTPROP (CAR (GET STRUC (QUOTE POBJ))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN SUBJ
  NIL
  (PROG (TMP RES)
        (SETQ TMP (GET STRUC (QUOTE INFOF)))
        (COND ((NOT (AND TMP (EQ (GET STRUC (QUOTE SUBJ)) (GET TMP (QUOTE SUBJ)))))
               (SETQ RES (PUTPROP (GET STRUC (QUOTE SUBJ)) (QUOTE NOM) (QUOTE CASE))))
              (T NIL))
        (COND (TMP (REMPROP STRUC (QUOTE INFOF))) (T NIL))
        (RETURN RES)))


(DEFUN PNOM
  NIL (PUTPROP (CAR (GET STRUC (QUOTE PNOM))) (QUOTE NOM) (QUOTE CASE)))


(DEFUN OBJ
  NIL (PUTPROP (CAR (GET STRUC (QUOTE OBJ))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN OBJ2
  NIL (PUTPROP (CAR (GET STRUC (QUOTE OBJ2))) (QUOTE OBJ) (QUOTE CASE)))


(DEFUN POSS
  NIL (PUTPROP (CAR (GET STRUC (QUOTE POSS))) (QUOTE POSS) (QUOTE CASE)))


(DEFUN PRON
  NIL (SETQ !K! (LIST (GET (GET STRUC (QUOTE PRON)) (GET STRUC (QUOTE CASE))))))


(DEFUN OPENS
  (FILE)
  (PROG NIL
        (EVAL (LIST (QUOTE INC) (LIST (QUOTE INPUT) (QUOTE (SIM NMG)) FILE) NIL))
        (PRINT (QUOTE LOADING))
        (PRINC TAB)
        (PRINC FILE)))


(DEFUN DEFLIST
  (PAIR_LIS PROP)
  (PROG (&V ?&LST1 X)
        (SETQ ?&LST1 PAIR_LIS)
   LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
        (SETQ X (CAR ?&LST1))
        (SETQ &V (PUTPROP (CAR X) (CADR X) PROP))
        (SETQ ?&LST1 (CDR ?&LST1))
        (GO LOOP)))


(DEFUN INIT_SURF
  ()
  (SETQ BREAKING NIL)
  (PROG (&V ?&LST1 X)
              (SETQ ?&LST1 (QUOTE (TOK DET PREP VS NS MS PRON AGT! OBJ! INST!)))
         LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
              (SETQ X (CAR ?&LST1))
              (SETQ &V (PUTPROP X T (QUOTE TE)))
              (SETQ ?&LST1 (CDR ?&LST1))
              (GO LOOP))
  (PROG (&V ?&LST1 X)
              (SETQ ?&LST1
                    (QUOTE
                     (VOICE FORM TENSE MOOD INF INF2 FIRN POBJ SUBJ PNOM OBJ
                            POSS SECN NBR DEG OBJ! AGT! INST! PRON AUX OBJ2)))
         LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
              (SETQ X (CAR ?&LST1))
              (SETQ &V (PUTPROP X T (QUOTE TF)))
              (SETQ ?&LST1 (CDR ?&LST1))
              (GO LOOP))
  (SETF (GET 'NBR 'RF) T)
  (PROG (&V ?&LST1 X)
     (SETQ ?&LST1
           (QUOTE ((AGT AGT!) (OBJ OBJ!) (INST INST!) (DAT DAT!) (IOBJ IOBJ!)
                   (MOD MOD!) (LOC LOC!) (MAN MAN!))))
     LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
     (SETQ X (CAR ?&LST1))
     (SETQ &V
           (PROG NIL (PUTPROP (CAR X) (CADR X) (QUOTE INV)) (PUTPROP (CADR X) (CAR X) (QUOTE INV))))
     (SETQ ?&LST1 (CDR ?&LST1))
     (GO LOOP))
  (PROG (&V ?&LST1 X)
     (SETQ ?&LST1 (QUOTE (HE SHE IT THEY)))
     LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
     (SETQ X (CAR ?&LST1))
     (SETQ &V (PUTPROP X X (QUOTE NOM)))
     (SETQ ?&LST1 (CDR ?&LST1))
     (GO LOOP))
  (SETF (GET 'BE 'PL) 'ARE)
  (SETF (GET 'AND 'PRON) 'THEY)
  (DEFLIST (QUOTE ((HE HIM) (SHE HER) (IT IT) (THEY THEM))) (QUOTE OBJ))
  (DEFLIST (QUOTE ((HE HIS) (SHE HER) (IT ITS))) (QUOTE POSS))
  ;; This is now handled by code at the end of this file.
  ;; (SETQ !GR (QUOTE GR1))
  ;; (OPENS !GR)
  ;; (PROG (&V)
  ;;  LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ)))))
  ;;              (SETQ &V (PUTPROP (CAR !TMP!) (CADR !TMP!) !GR)))
  ;;             (T (RETURN &V)))
  ;;  (GO LOOP))
  ;; (INC NIL T)
  ;; (OPENS (QUOTE LEX1))
  ;; (PROG (&V)
  ;;  LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ))))) (SETQ &V (DEFLIST (READ) !TMP!)))
  ;;                   (T (RETURN &V)))
  ;;  (GO LOOP))
  )


(DEFUN SURFSTART
  NIL
  (PROG (&V)
   LOOP (COND (T (SETQ &V
                       (PROG (STRUCTURES)
                             (TERPRI NIL)
                             (PRINC (QUOTE "STRUCTURE FILE?"))
                             (SETQ STRUCTURES (READ (OPEN (READ))))
                             (RESTORENET STRUCTURES)
                             (BREAK NIL))))
              (T (RETURN &V)))
        (GO LOOP)))



(DEFUN SURFEXP
  (X) (COND ((ATOM X) (LIST X))
            (T        (GEN (LIST (SIMSTR X))))))

;; FORM is an element from SEM_LEV.
;; SIMSTR converts it to property list form and returns a pointer to the `governing' semantic structure

(DEFUN SIMSTR
    (FORM)
  (PROG (C)
     (SETQ LPROP NIL)
     (GSTRUCT1 FORM (SETQ C (GENTEMP)))
     (RETURN C)))

;; %FORM=(head .  <list of case-case_filler pairs>)
;; CV= structure (a gensym) to be filled out  %
;; putprop i v p -> (setf (get 'i 'p) 'v)

(DEFUN GSTRUCT1
  (FORM CV)
  (COND (FORM (SETF (GET CV 'TOK) (LIST (CAR FORM)))
              (SETQ LPROP (CONS (CONS CV (CAR FORM)) LPROP))
              (GSTRUCT2 (CDR FORM) CV))
        (T NIL)))




;; %FORM= <list of case-case_filler pairs>
;; CV= structure (a gensym) to be filled out  %

(DEFUN GSTRUCT2 (FORM CV)
  (PROG (&V)
   LOOP (COND (FORM
               (SETQ &V
                     (PROG NIL
                           (COND ((NULL (CDAR FORM)) (VCASE (CAAR FORM) (CADR FORM) CV))
                                 (T (SCASE (CAR FORM) (CADR FORM) CV)))
                           (SETQ FORM (CDDR FORM)))))
              (T (RETURN &V)))
        (GO LOOP)))


(DEFUN TOKEN
  (X)
  (PROG (FLG)
        (PROG (&V ?&LST1 PAIR)
              (SETQ ?&LST1 LPROP)
         LOOP (COND ((NULL ?&LST1) (RETURN &V)) (T NIL))
              (SETQ PAIR (CAR ?&LST1))
              (SETQ &V (COND ((EQUAL X (CDR PAIR)) (SETQ FLG (CAR PAIR))) (T NIL)))
              (COND (FLG (RETURN &V)) (T NIL))
              (SETQ ?&LST1 (CDR ?&LST1))
              (GO LOOP))
        (RETURN FLG)))

      
(DEFUN VCASE
  (CASE FILLER CV)
  (PROG (C)
     (COND
       ((MEMBER CASE (QUOTE (AGT OBJ OBJ2 POBJ INF INF2 S2 PNOM DAT LOC IOBJ INST)))
        (COND ((NULL (SETQ C (TOKEN (LIST (CAR FILLER))))) (SETQ C (GENTEMP)) (GSTRUCT1 FILLER C))
              (T NIL))
          (PUTPROP CV (LIST C) CASE))
       (T (PUTPROP CV FILLER CASE)))))

;; CV is the new symbol that's being filled out (it has been generated by gensym in
;; SIMSTR.  Filler is 

(DEFUN SCASE
  (CASE FILLER CV)
  (PROG (C)
        (SETQ C (GENTEMP))
        (PUTPROP CV (LIST C) (CAR CASE))
        (PUTPROP C (CDADR CASE) (QUOTE PREP))
        (VCASE (QUOTE POBJ) FILLER C)))


(DEFUN PUTPROP (ID VAL PROP) (SETF (GET ID PROP) VAL))

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


;; Set the !GR to be GR1.  In the old code we would read this from a
;; separate file.  (See commented code in INIT_SURF above
(SETQ !GR (QUOTE GR1))
;; The AFSTN grammar, from file GR1 (not AFSTN !!)
;; This code populates the property list with it
(mapcar #'(lambda (x) (PUTPROP (CAR x) (CADR x) !GR))
        '(
          (S	((VOICE TFM) (TFM)))
          (TFM	((FORM TENSE) (TENSE)))
          (TENSE	((TENSE PROP) (PROP)))
          (PROP	((MOOD T)))
          (INDIC ((INF3 SBJ) (SBJ)))
          (SBJ  	((SUBJ PRED)))
          (INTERROG	((FIRVS INDIC) (INDIC)))
          (IMPER	((TOK VP1)))
          (SUBJUNC	((IF INDIC)))
          (FIRVS	((INP V1) (V1)))
          (V1	((V1 NIL)))
          (PRED	((MAN VP0) (FIR VP10) (VP0)))
          (VP10	((TOK VP11) (VP11)))
          (VP11	((SEC NIL)))
          (FIR	PRED)
          (SEC	PRED)
          (VP0	((VS VP1)))
          (VP1	((SOBJ VP2) (VP2)))
          (VP2	((OBJ2 VP2_1) (VP2_1)))
          (VP2_1	((MAN2 VP3) (VP3)))
          (VP3	((PNOM VP4) (VP4)))
          (VP4	((DAT VP5) (VP5)))
          (VP5	((LOC VP6) (VP6)))
          (VP6	((INF VP7) (INF2 VP7)(S2 VP7)(S3 VP7)(VP7)))
          (VP7	((OBJ VP8) (VP8)))
          (VP8	((IOBJ VP9) (VP9)))
          (VP9	((INST NIL)))
          (INF	QNP)
          (INF2   VP0)
          (S2	S)
          (S3	S)
          (NP1	((NBR NP2) (NP2)))
          (NP2	((MOD NP3) (NP3)))
          (NP3	((NS NP4)))
          (NP4	((PMOD NP5) (NP5)))
          (NP5	((OBJ! NP6) (NP6)))
          (NP6	((AGT! NP7) (NP7)))
          (NP7	((INST! NIL)))
          (PNP	((TOK PNP1) (PNP1)))
          (PNP1	((PREP PNP2) (INF NIL) (PNP2)))
          (PNP2	((POBJ NIL)))
          (QNP	((PRON NP4) (DET NP1) (POSS NP1) (FIRN NP8) (VOICE G) (NP1)))
          (POSS	((PRON NIL) (DET NP10) (NP10)))
          (NP10	((NBR NP11) (NP11)))
          (NP11	((NS NIL)))
          (FIRN	QNP)
          (SECN	QNP)
          (SUBJ	QNP)
          (OBJ	QNP)
          (POBJ	QNP)
          (OBJ2 QNP)
          (PNOM	QNPC)
          (AGT	QNP)
          (NP8	((TOK NP9) (NP9)))
          (NP9	((SECN NIL)))
          (FIRM	MOD)
          (SECM	MOD)
          (MAN	PNP)
          (MAN2	PNP)
          (SOBJ	PNP)
          (DAT	PNP)
          (INST	PNP)
          (IOBJ	PNP)
          (PMOD	PNP)
          (LOC	PNP)
          (MOD	((DEG MOD1) (MOD1)))
          (MOD1	((FIRM MOD2) (MS NIL)))
          (MOD2	((TOK MOD3) (MOD3)))
          (MOD3	((SECM NIL)))
          (G	((AUX GP)))
          (GP	((SUBJ VP0)))
          )
        )


;; Code for handling the lexicon.
;; In the old code we would read this from a
;; separate file.  And the file was formatted a bit differently
;; (See commented code in INIT_SURF above)
;; This code populates the property list with it
;; This time by just setf-ing symbol-plist
(mapcar #'(lambda (x) (setf (symbol-plist (first x)) (copy-list (second x))))
        '(
          (SING3 (BE IS GO GOES HAVE HAS DO DOES CAN CAN))

          (PAST (BE WERE BECOME BECAME BUY BOUGHT CAN COULD
                 COME CAME DO DID DRINK DRANK EAT ATE GET GOT
                 GIVE GAVE GO WENT GRAB GRABBED HEAR HEARD
                 HAVE HAD HIT HIT KNOW KNEW MAKE MADE READ READ
                 STAB STABBED SEE SAW SELL SOLD TAKE TOOK
                 TELL TOLD THINK THOUGHT))

          (!ING (BE BEING HAVE HAVING GRAB GRABBING STAB STABBING))

          (!EN (BE BEEN BUY BOUGHT COME COME CAN BEEN-ABLE-TO
                DO DONE DRINK DRUNK EAT EATEN GET GOTTEN
                GIVE GIVEN GO GONE HAVE HAD HIT HIT HEAR HEARD
                KNOW KNOWN MAKE MADE READ READ SEE SEEN SELL SOLD
                TAKE TAKEN TELL TOLD THINK THOUGHT))

          (PRON (JOHN HE BILL HE MARY SHE FRED HE HAMLET HE
                 LAERTES HE OTHELLO HE IAGO HE CASSIO HE
                 DESDEMONA SHE FALSTAFF HE SOMEONE HE))

          (CONJ (AND T BECAUSE T))
          
          (OBJ (HE HIM SHE HER IT IT THEY THEM I ME YOU YOU WE US))

          (POSS (HE HIS SHE HER IT ITS THEY THEIR I MY YOU YOUR WE OUR))

          (INF (CAN BE_ABLE_TO IS BE WAS BE HAD HAVE HAS HAVE))

          ) ;; ends big quoted s-exp
        ) ;; ends mapcar

(setf (symbol-plist 'E1) '(TOK (SEE) AUX ((1 2)) VOICE (ACT) FORM (SIM) TENSE (PAST) MOOD (INDIC) ))

(gen (list 'E1))

;; Some tests to make sure it worked
;; (SYMBOL-PLIST 'E1)
;; (GET 'QNP 'GR1)
