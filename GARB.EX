(defparameter *GARB.EX*
'(
;1	Bill wants a book
((CON ((CON
		((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1))
		 TIME (T1))
	      <≡C
		((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*))
		 INC (2) TIME (T2))))
	<≡>
	    (*MLOC* VAL (*LTM* PART (BILL1))))
	FOCUS ((<≡> VAL PART)) TIME (T-0) CERTAINTY (.50))

;2 	John knew Bill wanted a book
((CON ((CON ((CON
		((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BOOK1 REF (INDEF)) TO (BILL1))
		 TIME (T-2))
	      <≡C
		((ACTOR (BILL1) <≡>T (*JOY*) <≡>F (*JOY*))
		 INC (2) TIME (T-1))))
	<≡>
	    (*MLOC* VAL (*LTM* PART (BILL1))))
	FOCUS ((<≡> VAL PART)) TIME (T-3))
  <≡>
       (*MLOC* VAL (*LTM* PART (JOHN1))))
  FOCUS  ((<≡> VAL PART))  TIME  (T-3))

;3	Hamlet advised Falstaff to drink the wine.
((ACTOR	(HAM) <=> (*MTRANS*) TO (*CP* PART (FAL)) FROM (*CP* PART (HAM))
	MOBJECT	((CON
		    ((ACTOR (FAL) <=> (*INGEST*) OBJECT (WINE1 REF (DEF))
		      TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
		     TIME (T-2) FOCUS ((ACTOR)))
		  <≡C
		    ((ACTOR (FAL) <≡>T (*JOY*) <≡>F (*JOY*))
		     TIME (T-1) FOCUS ((ACTOR)) INC (2)))))
 TIME (T-3))

;4	John prevented Mary from reading the book
((CON ((ACTOR (JOHN1) <=> (*DO*)) TIME (T-1))
      <≡
      ((ACTOR (MARY1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) MOBJECT (*CONCEPTS*)
	      FROM(BOOK1 REF (DEF)))
       FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-1))
))


;5	Othello choked Desdemona
((CON
  ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-0))
  <≡ 
  ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
	  OBJECT(*AIR*))
   FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-0))
))

;6	Mary ceased to have the book
((ACTOR (BOOK1 REF (DEF)) <≡> (*POSS* VAL (MARY1))) TF(T-1))

;7 Bill will give (return) a book to Mary
((ACTOR (BILL1) <=> (*ATRANS*) OBJECT (BOOK1 REF (DEF)) TO (MARY1) FROM (BILL1))
 FOCUS ((ACTOR)) TIME (T2))

;8	Mary became happy
((ACTOR (MARY1) <≡>T (*JOY* ) <≡>F (*JOY*)) TIME (T-3) INC (2))

;9	Mary is dead
((ACTOR (MARY1) <≡> (*HEALTH* VAL (-10))) TIME (T-0) )

;10		Falstaff bought some wine from Hamlet
((CON
      ((ACTOR (FAL) <=> (*ATRANS*) OBJECT (MONEY REF (INDEF)) TO (HAM)
	FROM (FAL)) FOCUS ((ACTOR)) TIME (T-1))
  <≡≡>
      ((ACTOR (HAM) <=> (*ATRANS*) OBJECT (WINE1 REF (INDEF)) TO (FAL)
	FROM (HAM)) TIME (T-1)FOCUS((ACTOR)))
)FOCUS ((CON  OBJECT)))
)
)
