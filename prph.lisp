;; This file based on PRPH.LSP in the CD directory of Neil Goldman's files.
;; replaced GENSYM with GENTEMP everywhere

(DEFPARAMETER REAL T)
(DEFPARAMETER REAL_SO_FAR T)
(DEFPARAMETER MAXPRPHS T)
(DEFPARAMETER !TMP! T)
(DEFPARAMETER !LPROP T)
(DEFPARAMETER !NETPRINT T)
(DEFPARAMETER !BASETIME T)
(DEFPARAMETER QUOTED_HEAD T)
(DEFPARAMETER INSERTED_HEAD T)
(DEFPARAMETER FORCE_NEW_TOKEN T)

;; will use this to implement OPENI and INC
;; can only open one file at a time
(DEFPARAMETER *GLOBAL-FILE-DESCRIPTOR* T)

;; Unconditionally close the file handler for now
(DEFUN INC (CHANNEL ACTION)
  (CLOSE *GLOBAL-FILE-DESCRIPTOR*))


;; A Bunch of functions that were needed that are part of
;; Either Lisp 1.6 or MLISP
(DEFUN PUTPROP (ID VAL PROP) (SETF (GET ID PROP) VAL))
;; Lisp 1.6 properties are implemented such that
;; Calling Get on something that is not a symbol just returns
;; NIL.  In Common Lisp this is an error, so replacing
;; many calls to GET with my own GETPROP, which checks
(DEFUN GETPROP (ID PROP) (AND (SYMBOLP ID) (GET ID PROP)))
(DEFUN *GREAT (x y) (> x y))
(DEFUN *LESS (x y) (< x y))
(DEFUN ADD1 (x) (1+ x))
(DEFUN SUB1 (x) (1- x))
(DEFUN *PLUS (x y) (+ x y))
(DEFUN *TIMES (x y) (* x y))
(DEFUN LSH (x y) (ASH x y))
(DEFUN ERRSET (X Y) (COND ((NULL X) X) (T (LIST X))))
(DEFUN PRINTSTR (X) (PRINT X))
(DEFUN SUFLIST (LIST INDEX) (NTHCDR INDEX LIST))
(DEFUN NCONS (X) (CONS X NIL))
(DEFUN EXPLODE (X) (COERCE (STRING X) 'list))
(DEFUN MEMQ (x y) (MEMBER X Y))

(DEFUN LISTIFY
  (S) (COND ((NULL S) NIL) ((ATOM S) (LIST S)) (T (*APPEND (LISTIFY (CAR S)) (LISTIFY (CDR S))))))

(DEFUN DEFLIST
  (PAIR_LIS PROP)
  (COND (PAIR_LIS (PUTPROP (CAAR PAIR_LIS) (CADAR PAIR_LIS) PROP) (DEFLIST (CDR PAIR_LIS) PROP))))

;; HAD TO MODIFY THIS SINCE COMMON LISP USES ARRAYS WITH 0-BASED INDICES
;; MADE THE ARRAY ONE ELEMENT LARGER THAN NEEDED
(DEFUN PREDIN
  (FILE)
  (PROG (N1)
        (OPENI FILE)
        (SETQ N1 (READ *GLOBAL-FILE-DESCRIPTOR*))
        (SETQ ALLPS (MAKE-ARRAY (1+ N1)))
        (PROG (&V &L1 &UPPER1 I)
              (SETQ &L1 1)
              (SETQ &UPPER1 N1)
              LOOP (COND ((*GREAT &L1 &UPPER1) (RETURN &V)))
              (SETQ I &L1)
              (SETQ &L1 (ADD1 &L1))
              (SETQ &V (SETF (AREF ALLPS I) (CONS (READ *GLOBAL-FILE-DESCRIPTOR*) NIL)))
              (GO LOOP))
        (INC NIL T)))


(DEFUN TREEIN
  (X) (PROG NIL (OPENI (CONS X (QUOTE TRE))) (SET X (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) (DOPRP X (EVAL X) 1) (INC NIL T)))

(DEFUN SCALESIN
  (FILE)
  (PROG NIL
        (OPENI FILE)
        (PROG (&V)
              LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) T)))
                          (SETQ &V
                                (PROG NIL
                                      (PUTPROP !TMP! (READ *GLOBAL-FILE-DESCRIPTOR*) (QUOTE POSDIR))
                                      (PUTPROP !TMP! (READ *GLOBAL-FILE-DESCRIPTOR*) (QUOTE NEGDIR))
                                      (PUTPROP !TMP! (READ *GLOBAL-FILE-DESCRIPTOR*) (QUOTE SCALE)))))
                         (T (RETURN &V)))
              (GO LOOP))
        (INC NIL T)))

(DEFUN FRAMESIN
  (FILE)
  (PROG (VB)
        (OPENI FILE)
        (PROG (&V)
              LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) T)))
                          (SETQ &V
                                (PROG NIL
                                      (PUTPROP (SETQ VB (CAR !TMP!)) (CADR !TMP!) (QUOTE LEX))
                                      (PUTPROP (CADR !TMP!) (CADR !TMP!) (QUOTE INF))
                                      (PUTPROP VB (CADDR !TMP!) 'EXPECTED_SYNTAX)
                                      (PUTPROP VB (CADDDR !TMP!) (QUOTE FRAME))
                                      (PUTPROP VB (CDDDDR !TMP!) (QUOTE SPEC_ACT)))))
                         (T (RETURN &V)))
              (GO LOOP))
        (INC NIL T)))

(DEFUN DICTIN
  (FILE)
  (PROG NIL
        (OPENI FILE)
        (PROG (&V)
              LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) T)))
                          (SETQ &V
                                (PROG NIL
                                      (PUTPROP (CAR !TMP!) (CADR !TMP!) (QUOTE LEX))
                                      (PUTPROP (CAR !TMP!) (CDDR !TMP!) (QUOTE CPRPS)))))
                         (T (RETURN &V)))
              (GO LOOP))
        (INC NIL T)))

(DEFUN DFCSIN
  (FILE)
  (PROG NIL
        (OPENI FILE)
        (PROG (&V)
              LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) T)))
                          (SETQ &V (PUTPROP (CAR !TMP!) (PREDPOINTS (CDR !TMP!)) (QUOTE DEFCHS))))
                         (T (RETURN &V)))
              (GO LOOP))
        (INC NIL T)))

(DEFUN DOPRP (NAME TREE NODE)
  (COND ((NULL TREE) NIL)
        ((EQ (CAAR TREE) (QUOTE T))
         (RPLACD (CDAR TREE) (PREDPOINTS (CDDAR TREE)))
         (RPLACA (CDR TREE) (GTTREE NAME (CADR TREE))))
        ((EQ (CAAR TREE) (QUOTE G))
         (ERR (PRINT (QUOTE "GO TO FOUL-UP"))))
        (T
         (COND ((NUMBERP (CAAR TREE))
                (RPLACA TREE (PREDPOINTS (CAR TREE)))))
         (GOCHK NAME TREE NODE))))

(DEFUN GOCHK
  (NAME TREE NODE)
  (PROG (&V &L1 INDX)
        (SETQ &L1 2)
        LOOP (COND ((*GREAT &L1 3) (RETURN &V)))
        (SETQ INDX &L1)
        (SETQ &L1 (ADD1 &L1))
        (SETQ &V
              (COND
               ((CAR (SUFLIST TREE (SUB1 INDX)))
                (COND
                 ((EQ (QUOTE G) (CAAR (CAR (SUFLIST TREE (SUB1 INDX)))))
                  (RPLACA (SUFLIST TREE (SUB1 INDX))
                          (GTTREE NAME (CDAR (CAR (SUFLIST TREE (SUB1 INDX)))))))
                 (T
                  (DOPRP NAME
                    (CAR (SUFLIST TREE (SUB1 INDX)))
                    (*PLUS (*TIMES 2 (SUB1 NODE)) INDX)))))))
        (GO LOOP)))



(DEFUN PREDPOINTS
  (L)
  (PROG (&V &VV &L1 X)
        (SETQ &L1 L)
        (SETQ &V (SETQ &VV (LIST NIL)))
        LOOP (COND ((NULL &L1) (RETURN (CDR &V))))
        (SETQ X (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (NCONC &VV
               (SETQ &VV
                     (LIST
                      ((LAMBDA (Z) (COND ((NULL Z) (PRINTSTR (QUOTE "NULL PREDICATE =")) (PRINC X)) (T Z)))
                       (AREF ALLPS X)))))
        (GO LOOP)))

;; the big idea of this function is to transform the node number into a bit sequence, and then

(DEFUN GTTREE
  (NAME NODE)
  (COND ((NULL NODE) NIL)
        (T (PROG (TREE BLIST)
                 (SETQ TREE (EVAL NAME))
                 (SETQ NODE (LSH NODE 1))
                 (PROG (&V)
                       LOOP (COND ((NOT (EQ (SETQ NODE (LSH NODE -1)) 1))
                                   ;; according to the Stanford Lisp 1.6 manual
                                   ;; BOOLE is supposed to be a bitwise and operation
                                   ;; They want to get the lowest bit out, but that doesn't work well here.
                                   ;; using mod 2 instead
                                   (SETQ &V (SETQ BLIST (CONS (MOD NODE 2) BLIST))))
                                  (T (RETURN &V)))
                       (GO LOOP))
                 (PROG (&V &L1 X)
                       (SETQ &L1 BLIST)
                       LOOP (COND ((NULL &L1) (RETURN &V)))
                       (SETQ X (CAR &L1))
                       (SETQ &L1 (CDR &L1))
                       (SETQ &V (SETQ TREE (COND ((ZEROP X) (CADR TREE)) (T (CADDR TREE)))))
                       (GO LOOP))
                 (RETURN TREE)))))

(DEFUN OPENI
  (FILE)
  (PROG NIL
        (DEFPARAMETER *GLOBAL-FILE-DESCRIPTOR*
          (OPEN (COND ((LISTP FILE) (CONCATENATE 'STRING (STRING (CAR FILE)) "." (STRING (CDR FILE))))
                      (T (STRING FILE)))
                :DIRECTION :INPUT))
        (PRINT (QUOTE LOADING))
        (PRINC #\TAB)
        (PRINC FILE)))


(DEFUN FIELD
  (FIELD_SPEC C)
  (COND ((ATOM FIELD_SPEC)
         (COND ((EQ FIELD_SPEC (QUOTE ALL)) C)
               ((EQ FIELD_SPEC (QUOTE MAIN)) (CAR C))
               ((EQ FIELD_SPEC (QUOTE MODS)) (CDR C))))
        (T (PROG (&V &L1 ROLE_NAME)
                 (SETQ &L1 FIELD_SPEC)
                 LOOP (COND ((NULL &L1) (RETURN &V)))
                 (SETQ ROLE_NAME (CAR &L1))
                 (SETQ &L1 (CDR &L1))
                 (SETQ &V (SETQ C (NEXT ROLE_NAME C)))
                 (COND ((NULL C) (RETURN &V)))
                 (GO LOOP)))))

(DEFUN NEXT
  (ROLE_NAME L)
  (PROG (L2)
        (COND
         ((SETQ L2 (COND ((GETPROP ROLE_NAME (QUOTE MOD_LINK)) (CDR L)) (T (CAR L))))
          (PROG NIL
                LOOP (COND
                      ((NOT (OR (EQ ROLE_NAME (CAR L2)) (MTCH ROLE_NAME (CAR L2)) (NULL (SETQ L2 (CDDR L2)))))
                       (GO LOOP))))))
        (RETURN
         (COND (L2 (CADR L2)) ((EQ (MAINLNKC L) (QUOTE K)) (NEXT ROLE_NAME (NEXT (QUOTE CON) L))) (T NIL)))))

(DEFUN MTCH
  (X Y) (MEMQ Y (GETPROP X (QUOTE MATCHES))))

(DEFUN APTREE
  ;; % APTREE = APPLYTREE?  The value of TREE is a discrimination net. CON_REP is the c-diag
  ;;   Applies the discrimination net to CON_REP; finds ALL responses,
  ;;   even when not in paraphrase mode.
  ;; %
  ;; main purpose of this function is to take the discrimination net TREE and
  ;; a CD structure, and enumerate the "matches" as HEADS, which are the lexical
  ;; entries that could be used as part of constructing a sentence 
  (TREE CON_REP)
  (PROG (CLST CTREE PRED TMP HEADS TFLAG FFLAG)
        (COND
         ;; if it's the AND tree ...
         ;; Conjunctions are placed in a `canonical' form; the element with earliest time is made the first
         ((EQ TREE (QUOTE AND))
          (SETQ CLST
                ((LAMBDA (T1 T2)
                   (COND
                    ;; tried to fix the calls below so that BEFORE and AFTER are called properly
                    ;; More elegant solution needed.
                    ((EVAL (LIST (QUOTE TIM_REL) `'(NIL NIL NIL (LIST (QUOTE BEFORE) '(,T1 ,T2))))) (NCONS CON_REP))
                    ((EVAL (LIST (QUOTE TIM_REL) `'(NIL NIL NIL (LIST (QUOTE AFTER) '(,T1 ,T2)))))
                     (NCONS (MAKSYM CON_REP)))))
                 (CAR (FIELD (QUOTE (CON TIME)) CON_REP))
                 (CAR (FIELD (QUOTE (∧ TIME)) CON_REP))))))
        ;; Wasn't AND.  make CLST the CON_REP and if TREE is marked SYMM, then also stick on ... MAKSYM?
        (COND
         ((NULL CLST) (SETQ CLST (CONS CON_REP (COND ((GETPROP TREE (QUOTE SYMM)) (NCONS (MAKSYM CON_REP))))))))
        (PROG (&V &L1 CD)
              (SETQ &L1 CLST)
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ CD (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V
                    (PROG NIL
                          ; A predicate is marked with TFLAG if it evaluates TRUE, and with FFLAG
                          ; if it evaluates NIL.  By using GENSYMs, (non-INTERNed, of course), we
                          ; needn't go through predicates erasing flags before each generation
                          (SETQ TFLAG (GENTEMP))
                          (SETQ FFLAG (GENTEMP))
                          ; CTREE is the discrimination-net
                          (SETQ CTREE (EVAL TREE))
                          (PROG (&V)
                                LOOP (COND (CTREE
                                            ; while we haven't run out of TREE 
                                            (SETQ &V
                                                  (COND
                                                   ;; set PRED to the predicates and see 
                                                   ;; if this is a terminal node in the tree
                                                   ((EQ (CAR (SETQ PRED (CAR CTREE))) (QUOTE T))
                                                    (COND
                                                     ; this is a terminal node
                                                     ; are terminal predicates satisfied?
                                                     ((SETQ TMP (TVAL (CDR PRED) CD TFLAG FFLAG))
                                                      ; if so, append entries to HEADS,
                                                      ; one for each lexical item in the list
                                                      (SETQ HEADS
                                                            (APPEND HEADS
                                                                    (PROG (&V &VV &L1 X)
                                                                          (SETQ &L1 TMP)
                                                                          (SETQ &V (SETQ &VV (LIST NIL)))
                                                                          LOOP (COND ((NULL &L1) (RETURN (CDR &V))))
                                                                          (SETQ X (CAR &L1))
                                                                          (SETQ &L1 (CDR &L1))
                                                                          (NCONC &VV (SETQ &VV (LIST (CONS X CD))))
                                                                          (GO LOOP))))))
                                                    ; But terminal nodes have `go-to' pointers
                                                    ; follow `go-to' pointer (if it exists ... other
                                                    ; CTREE will be assigned to NIL
                                                    (SETQ CTREE (CADR CTREE)))
                                                   ; not a terminal node in the tree
                                                   ; follow either true or false path
                                                   (T (SETQ CTREE
                                                            (CAR
                                                             (SUFLIST CTREE
                                                                      (SUB1
                                                                       (*PLUS 2 (PVAL PRED CD TFLAG FFLAG))))))))))
                                           (T (RETURN &V)))
                                (GO LOOP))))
              (GO LOOP))
    
        (RETURN HEADS)))


;; %  PREDLIST has the form (P1,P2, ... ,Pn)  
;;    return 1 if all Pi are satisfied, else 0   %
(DEFUN PVAL
  (PREDLIST CD TFLAG FFLAG)
  (PROG (FLG)
        (SETQ FLG T)
        (PROG (&V &L1 P)
              (SETQ &L1 PREDLIST)
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ P (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (COND ((NOT (SETQ FLG (SMPVAL P CD TFLAG FFLAG))) (RETURN &V)))
              (GO LOOP))
        (RETURN (COND (FLG 1) (T 0)))))

(DEFUN TVAL
  (TNODE CD TFLAG FFLAG) (COND ((ZEROP (PVAL (CDR TNODE) CD TFLAG FFLAG)) NIL) (T (CAR TNODE))))



(DEFUN SMPVAL
  (PRED_WITH_FLAG CD TFLAG FFLAG)
  (COND ((EQ (CDR PRED_WITH_FLAG) FFLAG) NIL)
        ((EQ (CDR PRED_WITH_FLAG) TFLAG) T)
        ;;  PRED has the form (< function, field (of CD), 2nd arg > . FLAG) 
        ;;  This is the basic predicate eval function. First it checks
        ;;  to see if The flag field has already been set, indicating previous
        ;;  evaluation of this predicate w.r.t. this Con.Dep. structure
        (T
         ((LAMBDA (PRED)
            (COND
             ((FUNCALL (CAR PRED) (LIST CD (FIELD (CADR PRED) CD) (THIRD PRED))) 
              ; (EVAL (CONS (CAR PRED) (CONS CD (CONS (FIELD (CADR PRED) CD) (CDDR PRED)))))
              (RPLACD PRED_WITH_FLAG TFLAG)
              T)
             (T (RPLACD PRED_WITH_FLAG FFLAG) NIL)))
          (CAR PRED_WITH_FLAG)))))

(DEFUN MAKSYM
  (CON_REP)
  (CONS (LIST (CAAR CON_REP) (CAR (CDDDAR CON_REP)) (CADDAR CON_REP) (CADAR CON_REP))
        ((LAMBDA (FCS) (SUBST (SWITCH (CAAR CON_REP) (CADDAR CON_REP) FCS) FCS (CDR CON_REP)))
         (FIELD (QUOTE (FOCUS)) CON_REP) )))

(DEFUN SWITCH
  (A B S_EXP)
  (COND ((ATOM S_EXP) (COND ((EQ S_EXP A) B) ((EQ S_EXP B) A) (T S_EXP)))
        (T (CONS (SWITCH A B (CAR S_EXP)) (SWITCH A B (CDR S_EXP))))))


;; Former FEXPRs.  These seem to be fixed.

(DEFUN EQU
  (X) (COND ((NULL (CADR X)) (NULL (CADDR X))) (T (EQUAL (CAR (CADR X)) (CADDR X)))))

(DEFUN ID
  (X) (EQUAL (CAR (CADR X)) (CAR (FIELD (CADDR X) (CAR X)))))

(DEFUN DIF
  ;; Avoiding evaluating args, need a better fix
  ;; (X) (NULL (EVAL (CONS (QUOTE ID) `',X))))
  (X) (NULL (ID X)))

(DEFUN POSM
  (X)
  (OR (NULL (CADR X)) (NOT (OR (MEMQ (QUOTE *NEG*) (CAR (CADR X))) (MEMQ (QUOTE *CANNOT*) (CAR (CADR X)))))))

(DEFUN MMQ
  (X) (COND ((CADR X) (MEMQ (CADDR X) (CAR (CADR X))))))

(DEFUN PROP
  (X) (COND ((NULL (CADR X)) NIL) (T (SATF (CADDR X) (GETPROP (CAR (CADR X)) (QUOTE CPRPS))))))

(DEFUN POT_HEAD
  (X) (AND (CADR X) (NOT (ZEROP (PVAL (GETPROP (CADDR X) (QUOTE DEFCHS)) (CADR X) (GENTEMP) (GENTEMP))))))

(DEFUN SKEL
  (X) (EQ (CADDR X) (CTYP (CADR X))))

(DEFUN MNLK
  (X) (EQ (CADDR X) (MAINLNK (CADR X))))

(DEFUN MNLKC
  (X) (EQ (CADDR X) (MAINLNKC (CADR X))))

(DEFUN GRREAT
  (X) (AND (NUMBERP (CAR (CADR X))) (NUMBERP (CADDR X)) (*GREAT (CAR (CADR X)) (CADDR X))))

(DEFUN LESSS
  (X) (AND (NUMBERP (CAR (CADR X))) (NUMBERP (CADDR X)) (*LESS (CAR (CADR X)) (CADDR X))))

(DEFUN MEM_QUERY
  (X)
  ((LAMBDA (BIND_LIST) (COND (BIND_LIST (PROVE (FILLPAT BIND_LIST (CADDDR X))))))
   (GET_BINDINGS (CAR X) (CADDR X))))

(DEFUN MEM_QUERY2
  (X)
  ((LAMBDA (BIND_LIST) (COND (BIND_LIST (PROVE2 (FILLPAT BIND_LIST (CADDDR X))))))
   (GET_BINDINGS (CAR X) (CADDR X))))

(DEFUN TIM_REL
  (X)
  ((LAMBDA (BIND_LIST) (COND (BIND_LIST (TIMPROVE (FILLPAT BIND_LIST (CADDDR X))))))
   (GET_BINDINGS (CAR X) (CADDR X))))

(DEFUN BEFORE
  ;; changed the MAKNAM construction to change things to integers here
  (X) (*LESS (PARSE-INTEGER (COERCE (CDR (EXPLODE (CAR X))) 'STRING))
             (PARSE-INTEGER (COERCE (CDR (EXPLODE (CADR X))) 'STRING))))


(DEFUN AFTER
  ;; Another fixed eval of an FEXPR below
  (X) (EVAL (LIST (QUOTE BEFORE) `'(,(CADR X) ,(CAR X)))))

;; end of FEXPRs

(DEFUN TIMPROVE
  (X) (EVAL X))

(DEFUN FILLPAT
  (BIND_LIST PAT)
  (COND ((OR (ATOM PAT) (NULL BIND_LIST)) PAT)
        ((EQ (CAR PAT) (QUOTE $)) (CAR (SUFLIST BIND_LIST (SUB1 (CADR PAT)))))
        ((EQ (CAR PAT) (QUOTE ↑)) (CAR (CAR (SUFLIST BIND_LIST (SUB1 (CADR PAT))))))
        (T (CONS (FILLPAT BIND_LIST (CAR PAT)) (FILLPAT BIND_LIST (CDR PAT))))))

(DEFUN GET_BINDINGS
  (C_LEV FIELD_LIST)
  (COND (FIELD_LIST
         (PROG (TMP RES)
               (SETQ RES
                     (PROG (&V &L1 FIELD_SPEC)
                           (SETQ &L1 FIELD_LIST)
                           LOOP (COND ((NULL &L1) (RETURN &V)))
                           (SETQ FIELD_SPEC (CAR &L1))
                           (SETQ &L1 (CDR &L1))
                           (SETQ &V (APPEND &V (COND ((SETQ TMP (FIELD FIELD_SPEC C_LEV)) (LIST TMP)))))
                           (COND ((NULL TMP) (RETURN &V)))
                           (GO LOOP)))
               (COND (TMP (RETURN RES)))))
        (T T)))

(DEFUN MAIN_LINK
  (CPT)
  (PROG (CODE)
        (SETQ CPT (CAR CPT))
        (PROG NIL
              LOOP (COND
                    ((NOT (OR (SETQ CODE (GETPROP (CAR CPT) (QUOTE LNKCODE))) (NULL (SETQ CPT (CDDR CPT)))))
                     (GO LOOP))))
        (RETURN (COND (CODE (CONS (CAR CPT) CODE)) (T (QUOTE (NIL)))))))

(DEFUN MAINLNKC
  (CPT) (COND ((NOT (ATOM (CAR CPT))) (CDR (MAIN_LINK CPT)))))

(DEFUN MAINLNK
  (CPT) (COND ((NOT (ATOM (CAR CPT))) (CAR (MAIN_LINK CPT)))))

(DEFUN CTYP
  (CD)
  (PROG (CONTP)
        (SETQ CONTP (MAINLNKC CD))
        (RETURN
         (COND ((EQ CONTP (QUOTE K))
                (INTERN (CONCATENATE 'STRING (STRING (MAINLNKC (CADAR CD)))
                                     (STRING CONTP)
                                     (STRING (MAINLNKC (CAR (CDDDAR CD)))))))
               (T CONTP)))))


(DEFUN TNAM
  (CD)
  (PROG (SKEL TMP2)
        ;; had to change the line below, because in Common Lisp, attempting to GET a property list
        ;; off of something that is not a symbol throws an error.
        (SETQ SKEL (COND ((GETPROP (CAR CD) (QUOTE SCALE)) (QUOTE L)) (T (CTYP CD))))
        (RETURN
         (COND ((EQUAL SKEL (QUOTE E)) (CONS (QUOTE EVT) (GETPROP (CAR (FIELD (QUOTE (<=>)) CD)) (QUOTE TREES))))
               ((EQUAL SKEL (QUOTE S))
                (COND ((SETQ TMP2 (GETPROP (CAR (FIELD (QUOTE (<≡>)) CD)) (QUOTE TREES))) TMP2)
                      (T (QUOTE (STAT)))))
               (T
                ((LAMBDA (X) (COND (X X) ((EQ (CADR (EXPLODE SKEL)) (QUOTE K)) (NCONS (QUOTE KAUS)))))
                 (GETPROP SKEL (QUOTE TREES))))))))



;; % these are the functions which perform the `and-or' search thru the
;;   paraphrase space.  DO_HEADS iterates thru the disjuncts (alternate
;;   verb choices);  DO_FRAMES processes the `first' frame for a given
;;   choice, stacking the rest.  POPIT pops it (the stack)      %


(DEFUN DO_HEADS (SNODE SCASE HEADLIST STACK)
  ;; % SNODE is a node of the syntax net being created.
  ;;   SCASE is a syntax relation (like ACTSBJ)
  ;;   HEADLIST is the result from FINDHEADS
  ;;

  ;; %  STACK = < <Ai Bi  Ci Di> >
  ;;  Ai= list of case frames (frameworks) not yet expanded
  ;;  Bi= conceptual rep   
  ;;  Ci= syntax net node to which frames must attach  
  ;;  Di= !BASETIME when entry was put on stack
  ;; %
  
  (COND ((NULL HEADLIST) (POPIT STACK))    
        (T (PROG (C_LEVEL LEX_HEAD HEAD TNODE LPNT TMP)
                 (SETQ LPNT (LAST !LPROP))
                 (PROG (&V &L1 HC)
                       (SETQ &L1 HEADLIST)
                       LOOP (COND ((NULL &L1) (RETURN &V)))
                       (SETQ HC (CAR &L1)) ;; HC is the HEADLIST entry
                       (SETQ &L1 (CDR &L1))
                       (SETQ &V ;; &V is set to the return value of the PROG
                             ;; the return value of the 
                             (PROG NIL
                                   (SETQ HEAD (CAR HC)) ; HEAD is the lexical pointer to a CXCN entry
                                   ; don't create a new syntax net node unless necessary
                                   (COND ((NOT (SETQ TMP (TOKEN (CDR HC))))
                                          ; create a new syntax net node
                                          (PROG NIL
                                                (PUTPROP SNODE (LIST (SETQ TNODE (GENTEMP))) SCASE)
                                                (PUTPROP TNODE T (QUOTE GSYM))
                                                (PUTPROP TNODE
                                                         (LIST (SETQ LEX_HEAD (LEX_ENT HEAD)))
                                                         (QUOTE LEX))
                                                (RPLACD LPNT (NCONS (CONS TNODE (CDR HC))))
                                                ; Changed to make a copy of the CD structure just
                                                ; before doing special actions that may mangle it
                                                ; (SETQ C_LEVEL (SUBST 0 0 (CDR HC)))
                                                (SETQ C_LEVEL (COPY-TREE (SUBST 0 0 (CDR HC))))
                                                (DOSPECIAL (GETPROP HEAD (QUOTE SPEC_ACT)) TNODE C_LEVEL)
                                                (COND (C_LEVEL (PROCESS_MODS TNODE LEX_HEAD C_LEVEL)))
                                                ; Generate from the framework for this HEAD/CXCN entry
                                                ; This will recursively call DO_HEADS
                                                (DO_FRAMES C_LEVEL TNODE (GETPROP HEAD (QUOTE FRAME)) STACK)
                                                (RPLACD LPNT NIL)))
                                         ; if we already have a syntax net node for this
                                         ; don't call DO_FRAMES, just connect to that node, POP off the stack
                                         (T (PUTPROP SNODE TMP SCASE) (POPIT STACK)))))
                       (COND ((EQ REAL REAL_SO_FAR) (RETURN &V)))
                       (GO LOOP))))))

;; JCM: new functionality!  checks to see that the syntax node
;; that we will be generating from is the syntax node expected
;; by the HEAD.  Now we can have frameworks for nouns!!!
;; One trick is that lots of syntax nodes transition to S, so
;; need to check for matching them all.
(DEFUN CHECK_MATCHING_SYNTAX (SCASE HEAD)
  (LET ((EXP_SYNTAX (GETPROP HEAD 'EXPECTED_SYNTAX)))
    (OR (NULL EXP_SYNTAX)
        (AND (EQ EXP_SYNTAX 'S) (MEMBER SCASE '(INF2 S2 FIRS SPRG INST2 GSBJ PRSNT SECS INF GOBJ)))
        (EQ EXP_SYNTAX SCASE))))


;; % SNODE is a node of the syntax net being created.
;;   SCASE is a syntax relation (like ACTSBJ)
;;   HEADLIST is the result from FINDHEADS
;;

;; %  STACK = < <Ai Bi  Ci Di> >
;;  Ai= list of case frames (frameworks) not yet expanded
;;  Bi= conceptual rep   
;;  Ci= syntax net node to which frames must attach  
;;  Di= !BASETIME when entry was put on stack
;; %


;; JCM: removed some unnecessary progs from this version and switched it
;; to dolist

(DEFUN DO_HEADS_2 (SNODE SCASE HEADLIST STACK)
  (COND
   ((NULL HEADLIST) (POPIT STACK))    
   (T (PROG (C_LEVEL LEXICAL_HEAD HEAD FRAMEWORK TNODE LPNT TMP)
            (SETQ LPNT (LAST !LPROP))
            (dolist (HC HEADLIST)
              (SETQ HEAD (CAR HC)) ;; HEAD is the lexical pointer to a CXCN entry
              (SETQ FRAMEWORK (GETPROP HEAD 'FRAME)) ;; need FRAMEWORK earlier now
              (WHEN (CHECK_MATCHING_SYNTAX SCASE HEAD)
                (COND
                 (
                  ;; don't create a new syntax net node unless necessary
                  ;; JCM: FORCE_NEW_TOKEN forces it to happen in certain circumstances
                  ;; Particularly when ALL is used as a field specifier
                  (OR (NOT (SETQ TMP (TOKEN (CDR HC) FRAMEWORK))) FORCE_NEW_TOKEN)
                  ;; create a new syntax net node
                  (PUTPROP SNODE (LIST (SETQ TNODE (GENTEMP))) SCASE)
                  (PUTPROP TNODE T 'GSYM)
                  (PUTPROP TNODE (LIST (SETQ LEX_HEAD (LEX_ENT HEAD))) 'LEX)
                  (RPLACD LPNT (NCONS (LIST TNODE (CDR HC) FRAMEWORK)))
                  ; Changed to make a copy of the CD structure just
                  ; before doing special actions that may mangle it
                  ; (SETQ C_LEVEL (SUBST 0 0 (CDR HC)))
                  (SETQ C_LEVEL (COPY-TREE (SUBST 0 0 (CDR HC))))
                  (DOSPECIAL (GETPROP HEAD (QUOTE SPEC_ACT)) TNODE C_LEVEL)
                  (COND (C_LEVEL (PROCESS_MODS TNODE LEX_HEAD C_LEVEL)))
                  ; Generate from the framework for this HEAD/CXCN entry
                  ; This will recursively call DO_HEADS
                  (DO_FRAMES C_LEVEL TNODE FRAMEWORK STACK)
                  (RPLACD LPNT NIL))
                 ; if we already have a syntax net node for this
                 ; don't call DO_FRAMES, just connect to that node, POP off the stack
                 (T (PUTPROP SNODE TMP SCASE) (POPIT STACK)))
                (COND ((EQ REAL REAL_SO_FAR) (RETURN NIL))))) ;; return if we have generated enough paraphrases
            ))))


;; C_LEVEL is a conceptual structure
;; SNODE is a syntax net node
;; FRAMEWORK is a list of unprocessed FRAMEs from a concexicon entry

(DEFUN DO_FRAMES
  (C_LEVEL SNODE FRAMEWORK STACK)
  (COND
   ((NULL FRAMEWORK) (POPIT STACK))
   (T (PROG (TCASE DIRECS FIELDSPEC REQS TNODE)
            (SETQ QUOTED_HEAD NIL) ;; QTHD assigns QUOTED_HEAD
            (SETQ INSERTED_HEAD NIL) ;; INSHD assigns INSERTED_HEAD
            (SETQ FORCE_NEW_TOKEN NIL) ;; NTK assigns FORCE_NEW_TOKEN
            (SETQ TNODE SNODE)
            ;; Getting the frame item
            (SETQ TCASE (CAAR FRAMEWORK))
            (SETQ DIRECS (CDAR FRAMEWORK))
            (COND
             ((AND DIRECS (OR (ATOM (CAR DIRECS)) (GETPROP (CAAR DIRECS) (QUOTE FIELD))))
              (SETQ FIELDSPEC (CAR DIRECS))
              (SETQ REQS (CDR DIRECS)))
             (T (SETQ FIELDSPEC (GETPROP TCASE (QUOTE FRAM_STDS))) (SETQ REQS DIRECS)))
            ;; TCASE is the syntax relation specified in the FRAME
            ;; FIELDSPEC is the field-specification specified, or the default
            ;; for TCASE if none was specified
            ;; REQS is the special requirements field
            (PROG (&V &L1 REQ)
                  (SETQ &L1 REQS)
                  LOOP (COND ((NULL &L1) (RETURN &V)))
                  (SETQ REQ (CAR &L1))
                  (SETQ &L1 (CDR &L1))
                  ;; process next special requirement %
                  (SETQ &V
                        ((LAMBDA (NEWNC)
                           (COND
                            (NEWNC (PUTPROP (SETQ TNODE (CAR NEWNC)) T (QUOTE GSYM))
                                   (SETQ TCASE (CDR NEWNC)))))
                         (APPLY (CAR REQ) (LIST (CDR REQ) TCASE SNODE C_LEVEL))))
                  (GO LOOP))
            ;; one of special requirements specified a `literal' head for
            ;; the relation TCASE. Basically this code is equivalent to a call to
            ;; DO_HEADS, but it doesn't do the embedded call to FINDHEADS, since our quoted
            ;; head is the only one we want, and since our quoted head doesn't have
            ;; a concexicon entry.
            (COND
             (QUOTED_HEAD (COND ((GETPROP TCASE 'NSTRUC)
                                 (PUTPROP TNODE (LIST (SETQ TNODE (GENTEMP))) TCASE)
                                 (PUTPROP TNODE QUOTED_HEAD 'LEX)
                                 (PUTPROP TNODE T 'GSYM))
                                (T (PUTPROP TNODE QUOTED_HEAD TCASE)))
                          ;; we can now process the next FRAME in FRAMEWORK %
                          (DO_FRAMES C_LEVEL SNODE (CDR FRAMEWORK) STACK))
             ;; JCM: new functionality!  INSERTED_HEAD actually has a concexicon entry, so
             ;; this will be like a call to DO_HEADS but without the call to FINDHEADS, just
             ;; the structure needed to do our INSERTED_HEAD
             (INSERTED_HEAD
              (DO_HEADS_2
                TNODE
                TCASE
                `((,(FIRST INSERTED_HEAD) ,(FIRST (FIELD FIELDSPEC C_LEVEL))))
                (CONS (LIST (CDR FRAMEWORK) C_LEVEL SNODE !BASETIME) STACK)))

             (T (DO_HEADS_2
                  TNODE
                  TCASE
                  (FINDHEADS (FIELD FIELDSPEC C_LEVEL))
                  (CONS (LIST (CDR FRAMEWORK) C_LEVEL SNODE !BASETIME) STACK))))))))


(DEFUN POPIT
  (STACK)
  (COND (
         (NULL STACK) ;; nothing left on the stack, so we'll generate a realization!
         (SETQ REAL_SO_FAR (ADD1 REAL_SO_FAR)) ;; add to our count of realizations
         ((LAMBDA (H)
            (PROG (SAV)
                  ;; save the semantic/syntax net 
                  (SETQ SAV (NETCOPY (NETPRINT (CAR H) NIL NIL !NETPRINT)))
                  ;; generate.  Just need the semantic net.
                  ;; SURFEXP defined in surf.lisp, and the grammar is there
                  (SURFEXP H) 
                  (RESTORENET SAV) ;; restore
                  (SETQ !BASETIME (QUOTE (T-0 . PRES))))) ;; reset !BASETIME
          (GETPROP (QUOTE TOP_NODE) (QUOTE S)))) ;; this will end up being H
        ;; Default: if stack is not empty, set !BASETIME
        ;; call DO_FRAMES with the next item on the stack (CADR is the second item)  
        (T (SETQ !BASETIME (CAR (CDDDAR STACK)))
           (WHEN (NULL (CAR !BASETIME))
             (FORMAT T "CAR OF !BASETIME WAS NULL.  WHY?  STACK WAS THIS:")
             (PRINT STACK))
           (DO_FRAMES (CADAR STACK) (CADDAR STACK) (CAAR STACK) (CDR STACK)))))

;; JCM: new functionality now checks to see that both the CD structure
;; and the FRAMEWORK that it was generated under match to determine
;; whether to reuse a particular syntax node
(DEFUN TOKEN
  (CD FRAMEWORK)
  (PROG (FLG)
        (PROG (&V &L1 TUPLE)
              (SETQ &L1 (CDR !LPROP))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ TUPLE (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (COND ((AND (EQUAL (LIST CD FRAMEWORK) (CDR TUPLE)) (SETQ FLG (NCONS (CAR TUPLE)))) (RETURN &V)))
              (GO LOOP))
        (RETURN FLG)))


;; either apply the disc nets for C_LEVEL or get the English-name for the `head'

(DEFUN FINDHEADS
  (C_LEVEL)
  (COND
   (C_LEVEL
    (COND ((ATOM C_LEVEL) (LIST (CONS C_LEVEL C_LEVEL)))
          (T
           ((LAMBDA (TRE_LIS)
              (COND (TRE_LIS
                     (PROG (&V &L1 TRE)
                           (SETQ &L1 TRE_LIS)
                           LOOP (COND ((NULL &L1) (RETURN &V)))
                           (SETQ TRE (CAR &L1))
                           (SETQ &L1 (CDR &L1))
                           (SETQ &V
                                 (APPEND &V
                                         (COND
                                          ((EQ TRE (QUOTE SCALE)) (LIST (CONS (ANSCALE C_LEVEL) C_LEVEL)))
                                          (T (APTREE TRE C_LEVEL)))))
                           (GO LOOP)))
                    (T (LIST (CONS (GETNAME (CAR C_LEVEL)) C_LEVEL)))))
            (TNAM C_LEVEL)))))))

(DEFUN ANSCALE
  (C_LEVEL)
  (PROG (SCALNAM INC SCALPT)
        (SETQ SCALNAM (CAR C_LEVEL))
        (COND
         ((AND (SETQ SCALPT (FIELD (QUOTE (VAL)) C_LEVEL)) (NUMBERP (CAR SCALPT)))
          (RETURN (RUN_SCALE (GETPROP SCALNAM (QUOTE SCALE)) (CAR SCALPT))))
         ((AND (SETQ INC (FIELD (QUOTE (INC)) C_LEVEL)) (NUMBERP (CAR INC)))
          (RETURN (GETPROP SCALNAM (COND ((MINUSP (CAR INC)) (QUOTE NEGDIR)) (T (QUOTE POSDIR))))))
         (T (RETURN (GETPROP SCALNAM (QUOTE POSDIR)))))))

(DEFUN RUN_SCALE
  (SCALE POINT)
  (PROG (CUR_CHOICE)
        (SETQ CUR_CHOICE (CAR SCALE))
        (COND
         ((SETQ SCALE (CDR SCALE))
          (PROG NIL
                LOOP (COND
                      ((NOT
                        (OR (*LESS POINT (CAR SCALE))
                            (AND (SETQ CUR_CHOICE (CADR SCALE)) (NULL (SETQ SCALE (CDDR SCALE))))))
                       (GO LOOP))))))
        (RETURN CUR_CHOICE)))

(DEFUN LEX_ENT
  (SENSE) ((LAMBDA (LE) (COND (LE LE) (T SENSE))) (GETPROP SENSE (QUOTE LEX))))

(DEFUN MAKPREP
  (REQ CASE NODE C_LEVEL)
  (PROG (NNODE)
        (PUTPROP NODE (LIST (SETQ NNODE (GENTEMP))) CASE)
        (PUTPROP NNODE T (QUOTE GSYM))
        (PUTPROP NNODE REQ (QUOTE PREP))
        (RETURN (CONS NNODE (QUOTE POBJ)))))

(DEFUN QTHD
  (HEAD CASE NODE C_LEVEL) (PROG NIL (SETQ QUOTED_HEAD HEAD)))

(DEFUN INSHD
  (HEAD CASE NODE C_LEVEL) (PROG NIL (SETQ INSERTED_HEAD HEAD)))

(DEFUN NTK
  (HEAD CASE NODE C_LEVEL) (PROG NIL (SETQ FORCE_NEW_TOKEN T)))


;; (DEFUN MAKE_ARTICLE
;;   (HEAD CASE NODE C_LEVEL) (PROG NIL (SETQ FORCE_NEW_TOKEN T)))

(DEFUN ADDINC
  (NIL1 CASE NODE C_LEVEL)
  (PROG NIL
        (SETQ QUOTED_HEAD
              (LIST
               (ANSCALE
                (APPEND (FIELD (QUOTE (<≡>T)) C_LEVEL)
                        ((LAMBDA (INC) (COND (INC (LIST (QUOTE INC) INC))))
                         (FIELD (QUOTE (INC)) C_LEVEL))))))))

(DEFUN DOSPECIAL
  (SLIST TNODE C_LEV)
  (PROG (&V)
        LOOP (COND (SLIST
                    (SETQ &V (PROG2 (APPLY (CAR SLIST) (LIST (CADR SLIST) C_LEV TNODE)) (SETQ SLIST (CDDR SLIST)))))
                   (T (RETURN &V)))
        (GO LOOP)))

;  runs through the `modifiers' of a conceptualization
;   making appropriate changes to the syntax net
;
(DEFUN PROCESS_MODS
  (NODE LEXHEAD C_L)
  (PROG (MODLIST CACL NEWBASETIME)
        (COND
         ((SETQ MODLIST (CDR C_L))
          (SETQ CACL (CAR C_L))
          (PROG (&V)
                LOOP (SETQ &V (MODHANDLER NODE CACL (CAR MODLIST) (CADR MODLIST)))
                (COND ((NULL (SETQ MODLIST (CDDR MODLIST))) (RETURN &V)) (T (GO LOOP))))))
        (COND
         ((AND (GETPROP LEXHEAD 'INF) (NOT (GETPROP LEXHEAD 'CONJ)))
          (SETQ NEWBASETIME (TENSER NODE C_L))
          (IF (CAR NEWBASETIME) (SETQ !BASETIME NEWBASETIME))
          (WHEN (NULL (CAR !BASETIME))
            (FORMAT T "**CAR OF !BASETIME WAS NULL.  WHY?  Just called TENSER in Process mods:")
            (FORMAT T "**C_L was")
            (PRINT C_L)
            (FORMAT T "**LEX_HEAD was")
            (PRINT LEXHEAD))
          (PUTPROP NODE (CHOOSE_FORM NODE C_L) (QUOTE FORM))
          (PUTPROP NODE (QUOTE (ACT)) (QUOTE VOICE))
          (COND ((NOT (GETPROP NODE (QUOTE MOOD))) (PUTPROP NODE (CHOOSE_MOOD C_L) (QUOTE MOOD))))))))

;; MODTYP is one of the modifying conceptual relations, such as POSS, PART, MANNER, etc 
(DEFUN MODHANDLER
  (NODE CON_GOV MODTYP VAL)
  ((LAMBDA (FN) (COND (FN (APPLY FN (LIST NODE CON_GOV VAL)))))
   (GETPROP MODTYP (QUOTE PROC))))

(DEFUN GET_DET
  (NODE CON_GOV REF)
  (PUTPROP NODE (COND ((EQ (CAR REF) (QUOTE DEF)) (QUOTE (THE))) (T (CHOOSE_INDEF CON_GOV))) (QUOTE DET)))

(DEFUN CHOOSE_INDEF
  (CON_GOV)
  ;; another fixed eval of an FEXPR
  (COND ((EVAL (LIST (QUOTE PROP) `'(NIL ,(LIST CON_GOV) ,(QUOTE MASS)))) (QUOTE (SOME))) (T (QUOTE (A)))))

(DEFUN GET_NBR
  (NODE CON_GOV QUANT) (PUTPROP NODE QUANT (QUOTE QUANT)))

(DEFUN GET_MODE
  (NODE CON_GOV ML)
  (PROG (&V &L1 X)
        (SETQ &L1 (CAR ML))
        LOOP (COND ((NULL &L1) (RETURN &V)))
        (SETQ X (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (SETQ &V
              (PROG (TMP)
                    (SETQ TMP (GETPROP X (QUOTE MODE)))
                    (PROG (&V)
                          LOOP (COND (TMP
                                      (SETQ &V
                                            (PROG NIL (PUTPROP NODE (CADR TMP) (CAAR TMP)) (SETQ TMP (CDDR TMP)))))
                                     (T (RETURN &V)))
                          (GO LOOP))))
        (GO LOOP)))

(DEFUN GET_PART
  (NODE CON_GOV PRT)
  (PROG (NEWNODE)
        (COND
         ;; Not sure how this is used, but now TOKEN also checks the
         ;; framework for a match.  Assuming framework is NIL here
         ((NULL (SETQ NEWNODE (TOKEN PRT NIL)))
          (SETQ NEWNODE (LIST (GENTEMP)))
          (PUTPROP (CAR NEWNODE) T (QUOTE GSYM))
          (PUTPROP (CAR NEWNODE) (LIST (LEX_ENT (CAR PRT))) (QUOTE LEX))
          (NCONC !LPROP (NCONS (CONS (CAR NEWNODE) PRT)))))
        (PUTPROP NODE NEWNODE (QUOTE POSS))))

(DEFUN GET_OWN
  (NODE CON_GOV PRT) (GET_PART NODE CON_GOV PRT))

(DEFUN GET_POSS
  (NODE CON_GOV PRT) (GET_PART NODE CON_GOV PRT))

(DEFUN GET_CERT
  (NODE CON_GOV VAL)
  (COND
   ((*LESS (CAR VAL) 0.96000000)
    (PUTPROP NODE (NCONS (RUN_SCALE (GETPROP (QUOTE CERTAINTY) (QUOTE SCALE)) (CAR VAL))) (QUOTE MAN)))))

(DEFUN TENSER
  (NODE CONCEPT)
  (COND ((MEMQ (MAINLNKC CONCEPT) (QUOTE (K A D))) (TENSER NODE (FIELD (QUOTE (CON)) CONCEPT)))
        (T
         ((LAMBDA (TIM) (PROG2 (PUTPROP NODE (NCONS (GET_TNS TIM)) (QUOTE TENSE)) (CONS (CAR TIM) !NEWTENSE)))
          (FIELD (QUOTE (TIME)) CONCEPT)))))

(DEFUN GET_TNS
  (TIM) (COND (TIM (T_REL_BASE (CAR TIM))) (T (SETQ !NEWTENSE (QUOTE PRES)))))

(DEFUN T_REL_BASE
  (T1)
  (NTIM (SETQ !NEWTENSE
              (COND
               ((FUNCALL 'TIM_REL (LIST NIL NIL NIL (BEFORE `(,T1 ,(CAR !BASETIME)))))
                (QUOTE PAST))
               ((FUNCALL 'TIM_REL (LIST NIL NIL NIL (AFTER `(,T1 ,(CAR !BASETIME)))))
                (QUOTE FUT))
               (T (QUOTE PRES))))
        (CDR !BASETIME)))

(DEFUN NTIM
  ;; this had been AT and CAT... fixed ...
  (T1 T2) (COND ((NOT (MEMQ T2 (QUOTE (PAST FUT)))) T1) (T (INTERN (CONCATENATE 'STRING (STRING T1) (STRING T2))))))

(DEFUN CHOOSE_FORM
  (NODE C_L)
  (COND
   ((AND (EQUAL (GETPROP NODE (QUOTE TENSE)) (QUOTE (PRES))) (NOT (EQ (CTYP C_L) (QUOTE S)))) (QUOTE (PROG)))
   (T (QUOTE (SIM)))))

(DEFUN CHOOSE_MOOD
  (C_L)
  (COND ((QUESTP C_L) (QUOTE (INTERROG))) ((MEMQ (QUOTE <≡C) (CAR C_L)) (QUOTE (COND))) (T (QUOTE (INDIC)))))

(DEFUN QUESTP
  (C_L)
  (PROG (TMP FLG)
        (COND ((SETQ TMP (AND (FIELD (QUOTE (MODE)) C_L) (MEMQ (QUOTE *?*) TMP))) (RETURN T)))
        (PROG (&V &L1 X)
              (SETQ &L1 (LIST (CAR C_L) (CDR C_L)))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V
                    (PROG (&V)
                          LOOP (COND ((AND X (NULL FLG))
                                      (SETQ &V (PROG2 (SETQ FLG (EQ (CAADR X) (QUOTE *?*))) (SETQ X (CDDR X)))))
                                     (T (RETURN &V)))
                          (GO LOOP)))
              (COND (FLG (RETURN &V)))
              (GO LOOP))
        (RETURN FLG)))

(DEFUN ADDITIONS
  (ADDS C_LEV NODE)
  (PROG (&V &L1 ADDD)
        (SETQ &L1 ADDS)
        LOOP (COND ((NULL &L1) (RETURN &V)))
        (SETQ ADDD (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (SETQ &V
              ((LAMBDA (Z)
                 (COND
                  (Z (NCONC (COND ((GETPROP (CAR ADDD) (QUOTE MOD_LINK)) C_LEV) (T (CAR C_LEV)))
                            (LIST (CAR ADDD) (SUBST 0 0 Z))))))
               (FIELD (CADR ADDD) C_LEV)))
        (GO LOOP)))

(DEFUN DELETIONS
  (DELS C_LEV NODE)
  (PROG (&V &L1 DEL)
        (SETQ &L1 DELS)
        LOOP (COND ((NULL &L1) (RETURN &V)))
        (SETQ DEL (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (SETQ &V
              ((LAMBDA (CPART ROLE)
                 (COND ((GETPROP ROLE (QUOTE MOD_LINK)) (REMOVE_ROLE (CDR CPART) ROLE))
                       (T (REMOVE_ROLE (CAR CPART) ROLE))))
               (FIELD (ALL_BUT_LAST DEL) C_LEV)
               (CAR (LAST DEL))))
        (GO LOOP)))

(DEFUN ALL_BUT_LAST
  (L)
  (COND ((NULL (CDR L)) (QUOTE ALL))
        (T (PROG (&V &VV)
                 (SETQ &V (SETQ &VV (LIST NIL)))
                 LOOP (NCONC &VV (SETQ &VV (LIST (CAR L))))
                 (COND ((NULL (CDR (SETQ L (CDR L)))) (RETURN (CDR &V))) (T (GO LOOP)))))))

(DEFUN REMOVE_ROLE
  (L ROLE)
  (COND (L (COND ((EQ (CAR L) ROLE) (RPLACA L NIL) (RPLACA (CDR L) NIL)) (T (REMOVE_ROLE (CDDR L) ROLE))))))

(DEFUN GETNAME
  (SENSE) (LEX_ENT SENSE))

(DEFUN SATF
  (PRP PLIST)
  (OR (MEMQ PRP PLIST)
      (PROG (TMP)
            (RETURN
             (PROG (&V &L1 X)
                   (SETQ &L1 PLIST)
                   LOOP (COND ((NULL &L1) (RETURN &V)))
                   (SETQ X (CAR &L1))
                   (SETQ &L1 (CDR &L1))
                   (SETQ &V (SETQ TMP (TSCH PRP X)))
                   (COND (TMP (RETURN &V)))
                   (GO LOOP))))))

(DEFUN TSCH
  (PRP1 PRP2)
  (OR (EQ PRP1 PRP2)
      ((LAMBDA (TMP) (AND (EQ TMP (GETPROP PRP2 (QUOTE PTREE))) (ANC PRP1 PRP2 (EVAL TMP))))
       (GETPROP PRP1 (QUOTE PTREE)))))

(DEFUN ANC
  (S1 S2 TREE)
  (COND
   ((AND TREE (NOT (EQ S2 (CAR TREE))))
    (COND ((EQ S1 (CAR TREE)) (MEMQ S2 (LISTIFY (CDR TREE))))
          (T (PROG (TMP)
                   (RETURN
                    (PROG (&V &L1 SBTR)
                          (SETQ &L1 (CDR TREE))
                          LOOP (COND ((NULL &L1) (RETURN &V)))
                          (SETQ SBTR (CAR &L1))
                          (SETQ &L1 (CDR &L1))
                          (SETQ &V (SETQ TMP (ANC S1 S2 SBTR)))
                          (COND (TMP (RETURN &V)))
                          (GO LOOP)))))))))

(DEFUN PROVE22
  (C_D)
  (PROG NIL
        ;;        (TERPRI NIL)
        ;;        (PRINTSTR (QUOTE "TIME TO PLAY GOD -- IS THIS TRUE?"))
        ;;        (TERPRI NIL)
        ;;        (PRINC C_D)
        (RETURN T)))
;;        (RETURN (READ))))

(DEFUN PROVE
  (C_D) (PROVE22 C_D))

(DEFUN PROVE2
  (C_D) (PROVE22 C_D))

(DEFUN TIMPROVE
  (X) (EVAL X))

;; asks for a .EX file and an index into the file, then calls EXPRESS on that structure
;; Just to get started, I'm going to ignore this and I'm going to just call EXPRESS directly.
;; See just below EXPRESS
(DEFUN STARTUP
  NIL
  (PROG (&V)
        LOOP (COND (T (SETQ &V
                            (PROG (TMP SOURCE C_LEVEL)
                                  (PRINTSTR (TERPRI (QUOTE "WHAT SOURCE FILE?")))
                                  (OPENI (CONS (READ) (QUOTE EX)))
                                  (SETQ SOURCE (READ))
                                  (INC NIL T)
                                  (BREAK (QUOTE "LISP READ-EVAL LOOP TYPE P TO EXIT") NIL)
                                  (SETQ REAL MAXPRPHS)
                                  (PRINTSTR (QUOTE "INDEX OF C-DIAGRAM?"))
                                  (PROG (&V)
                                        LOOP (COND ((SETQ TMP (READ))
                                                    (SETQ &V
                                                          (PROG NIL
                                                                (COND
                                                                 ((NUMBERP TMP)
                                                                  (PRINT
                                                                   (SETQ C_LEVEL (CAR (SUFLIST SOURCE (SUB1 TMP)))))))
                                                                (EXPRESS (NCONS C_LEVEL))
                                                                (PRINTSTR
                                                                 (CAT CR (CAT LF (QUOTE "INDEX OF C-DIAGRAM?")))))))
                                                   (T (RETURN &V)))
                                        (GO LOOP)))))
                   (T (RETURN &V)))
        (GO LOOP)))




(DEFUN EXPRESS
  (C_L_LIST)
  (PROG (&V &L1 C_LEVEL)
        (SETQ &L1 C_L_LIST)
        LOOP (COND ((NULL &L1) (RETURN &V)))
        (SETQ C_LEVEL (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (SETQ &V
              (PROG (TMP)
                    (SETQ REAL_SO_FAR 0)
                    (SETQ TMP (GENTEMP))
                    ;; (CSYM N0001) don't care about initializing the counter
                    (REMPROP (QUOTE TOP_NODE) (QUOTE S))
                    ;; (GC) triggers garbage collection
                    (SETQ !LPROP (CONS NIL NIL))
                    (SETQ !BASETIME (QUOTE (T-0 . PRES)))
                    (DO_HEADS_2 (QUOTE TOP_NODE) (QUOTE S) (FINDHEADS C_LEVEL) NIL)
                    (TERPRI NIL)
                    ;; Code below meant to update the generated symbol counter
                    ;; gentemp is deprecated ... need to fix all of this
                    ;; (EVAL (LIST (QUOTE CSYM) TMP))
                    ))
        (GO LOOP)))



(DEFUN NETPRINT
  (NEWNODE YET2PRINT PRINTED PRINTING)
  (PROG2 (COND
          ((NOT (MEMQ NEWNODE PRINTED))
           (PROG (PRPLIST TMP)
                 (SETQ PRINTED (CONS NEWNODE PRINTED))
                 ;; had to fix the line below ... in Lisp 1.6 you can CDR a symbol
                 ;; to get at its property list.
                 (SETQ PRPLIST (SYMBOL-PLIST NEWNODE))
                 (COND (PRINTING (TERPRI NIL) (TERPRI NIL) (PRINC NEWNODE) (PRINC #\:)))
                 (PROG (&V)
                       LOOP (COND (PRPLIST
                                   (SETQ &V
                                         (PROG NIL
                                               (COND
                                                ;; While it's not the printname, or GSYM
                                                ;; GSYMs are added to YET2PRINT
                                                ((NOT (MEMQ (CAR PRPLIST) (QUOTE (PNAME GSYM))))
                                                 (SETQ TMP (CADR PRPLIST))
                                                 (COND
                                                  (PRINTING (PRINC #\TAB)
                                                            (PRINC (CAR PRPLIST))
                                                            (PRINC #\TAB)
                                                            (PRINC TMP)
                                                            (TERPRI NIL)))
                                                 (COND
                                                  ((AND (NOT (NUMBERP (CAR TMP))) (GETPROP (CAR TMP) (QUOTE GSYM)))
                                                   (SETQ YET2PRINT (CONS (CAR TMP) YET2PRINT))))))
                                               (SETQ PRPLIST (CDDR PRPLIST)))))
                                  (T (RETURN &V)))
                       (GO LOOP)))))
         (COND (YET2PRINT (NETPRINT (CAR YET2PRINT) (CDR YET2PRINT) PRINTED PRINTING)) (T PRINTED))))

; save the current property list of each node in NODELIST
(DEFUN NETCOPY
  (NODELIST)
  (PROG (&V &VV &L1 X)
        (SETQ &L1 NODELIST)
        (SETQ &V (SETQ &VV (LIST NIL)))
        LOOP (COND ((NULL &L1) (RETURN (CDR &V))))
        (SETQ X (CAR &L1))
        (SETQ &L1 (CDR &L1))
        (NCONC &VV (SETQ &VV (LIST (CONS X (SYMBOL-PLIST X)))))
        (GO LOOP)))

(DEFUN RESTORENET
  (L)
  (PROG (&V &L1 PR)
        (SETQ &L1 L)
        LOOP (COND ((NULL &L1) (RETURN &V)))
        (SETQ PR (CAR &L1))
        (SETQ &L1 (CDR &L1))
        ;; I think the line below is trying to set the property list
        ;; so, will do that the way Common Lisp does it
        ;; Former code (SETQ &V (RPLACD (CAR PR) (CDR PR)))
        (SETQ &V  (SETF (SYMBOL-PLIST (CAR PR)) (CDR PR))) 
        (GO LOOP)))

;; Now defined in surf.lisp
;; (DEFUN SURFEXP (X) NIL)

(DEFUN NET NIL (SETQ !NETPRINT T))

(DEFUN NONET
  NIL (SETQ !NETPRINT NIL))

(DEFUN MEM
  NIL (PUTPROP (QUOTE PROVE2) (GETPROP (QUOTE PROVE2) (QUOTE SUBR2)) (QUOTE SUBR)))

(DEFUN NOMEM
  NIL (PUTPROP (QUOTE PROVE2) (GETPROP (QUOTE PROVE22) (QUOTE SUBR)) (QUOTE SUBR)))

;; From INBAB.LSP
;; This function initializes the Conceptual Dependency --> Syntax net part of the system 

(DEFPARAMETER !TMP! T)

(DEFUN INIT_GEN
  NIL
  (PROG NIL
      
        ;; Unneeded LISP 1.6 debugging features (NOUUO T) (*RSET T) (BAKGAG 17)

        ;; all of these work
        (SETQ MAXPRPHS 16) ;; max paraphrases
        ;; (NET) ;; print syntax nets
        (NONET) ;; don't print syntax nets
        ;; (PUTPROP (QUOTE PROVE2) (GETPROP (QUOTE PROVE2) (QUOTE SUBR)) (QUOTE SUBR2))

        ;; adds a property called FIELD to each of these conceptual roles
        ;; works, check!
        (PROG (&V &L1 X)
              (SETQ &L1
                    (QUOTE (<=> <≡> <≡ <≡>T <≡>F <≡H <≡C ∧ <≡≡> OBJECT MOBJECT
                                TO FROM CON INST ACTOR FOCUS VAL POSS PART)))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X T (QUOTE FIELD))) ; internal names for conceptual roles
              (GO LOOP))

        ;; associations between conceptual modification types and LANGUAGE-SPECIFIC functions of BABEL
        ;; this works, check!
        (PROG (&V &L1 X)
              (SETQ &L1
                    (QUOTE
                     ((*POSS* . GET_POSS) (VAL) (TIME) (MODE . GET_MODE) (TF) (TS)
                      (PART) (MANNER) (QUANTITY . GET_NBR) (FOCUS) (INC)
                      (REF . GET_DET) (PART . GET_PART) (*OWN* . GET_OWN)
                      (CERTAINTY . GET_CERT))))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V
                    (PROG NIL
                          (PUTPROP (CAR X) T (QUOTE MOD_LINK))
                          ;; found a bug in the file here ... was CON@
                          ;; changed it to COND!!!
                          (COND ((CDR X) (PUTPROP (CAR X) (CDR X) (QUOTE PROC)))))) 
                
              (GO LOOP))

        ;; Associate codes with conceptual relation links
        
        (DEFLIST (QUOTE ((<=> E) (<≡> S) (∧ A) (<≡ K) (<≡H K) (<≡C K) (<≡>T C)
                         (<≡>F C) (<≡≡> D)))
          (QUOTE LNKCODE))
        
        ;; syntax relations whose values are other syntax net nodes have the
        ;; property NSTRUC on their property lists
        ;; seems ok, check!
        (PROG (&V &L1 X)
              (SETQ &L1
                    (QUOTE
                     (ACTSBJ OBJ OBJ2 POBJ PP1 LOC IOBJ INST GSBJ FIRS SECS
                             POSS P_ADJ INF INF2 INF3 S2 INST2 SPRG PRSNT)))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP X T (QUOTE NSTRUC)))
              (GO LOOP))

        ;; syntax net correspondence to conceptual MODEs
        ;; These seem to work, check!
        (DEFLIST (QUOTE ((*NEG* ((NGT) (NOT))) (*CAN* ((MODAL) (CAN))) (*CANNOT* ((NGT) (NOT) (MODAL) (CAN)))))
          (QUOTE MODE))
        (DEFLIST (QUOTE ((<≡ (<≡C <≡H)) (TIME (TF TS)))) (QUOTE MATCHES))
        (DEFLIST (QUOTE ((DK T) (AND T))) (QUOTE SYMM))


        ;; read in default syntax case - conceptual role associations
        ;; works, check!
        (OPENI (QUOTE FMSTDS))
        (PROG (&V)
              LOOP (COND ((NOT (ATOM (ERRSET (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR* NIL)) T)))
                          (SETQ &V (PUTPROP (CAR !TMP!) (CDR !TMP!) (QUOTE FRAM_STDS))))
                         (T (RETURN &V)))
              (GO LOOP))
        (INC NIL T)
        
        ;; Read in state scales
        ;; works! check!
        (SCALESIN (QUOTE SCALES))

        ;; Read in predicates referenced at tree nodes
        ;; works! check!
        (PREDIN 'ALLPS)
        
        ;; Bring in discrimination nets
        ;; works! check!
        (OPENI (QUOTE (TREES . NAM)))
        (SETQ !TMP! (READ *GLOBAL-FILE-DESCRIPTOR*))
        (PROG (&V &L1 X)
              (SETQ &L1 (READ *GLOBAL-FILE-DESCRIPTOR*))
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (PUTPROP (CAR X) (CDR X) (QUOTE TREES)))
              (GO LOOP))
        (INC NIL T)

        ;; initialize the nets
        ;; works! check!
        (PROG (&V &L1 X)
              (SETQ &L1 !TMP!)
              LOOP (COND ((NULL &L1) (RETURN &V)))
              (SETQ X (CAR &L1))
              (SETQ &L1 (CDR &L1))
              (SETQ &V (TREEIN X))
              (GO LOOP))

        ;; Read in conceptual dictionary -- word sense-property associations
        ;; (DICTIN (QUOTE CPRPS.BIG))
        ;; There is a larger CPRPS, but format is not compatible
        (DICTIN (QUOTE CPRPS))


        ;; Read in CONCEXICON
        ;; works, check!
        (FRAMESIN (QUOTE CXCN))
        
        ;; Read in DEFining CHaracteristicS
        ;; works, check
        (DFCSIN (QUOTE DEFCHS))

        ;; No need for INIT_GEN to  REMPROP itself
        ;; (REMPROP (QUOTE INIT_GEN) (QUOTE EXPR))
        ))



(INIT_GEN)
(provide :prph)