(defparameter *FOLIO2.EX*
'(

;1	Falstaff admitted to Hamlet he drank Hamlets beer.
((ACTOR	(FAL) <=> (*MTRANS*) FROM (*CP* PART (FAL)) TO (*CP* PART (HAM))
	MOBJECT	
		    ((ACTOR (FAL) <=> (*INGEST*) OBJECT (BEER1 *OWN* (HAM))
		      TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
		     TIME (T-4) FOCUS ((ACTOR)))
  )TIME (T-3))

;2	Falstaff threatened to drink Hamlets beer.
((ACTOR	(FAL) <=> (*MTRANS*) FROM (*CP* PART (FAL)) TO (*CP* PART (HAM))
	MOBJECT	
		    ((ACTOR (FAL) <=> (*INGEST*) OBJECT (BEER1 *OWN* (HAM))
		      TO (*INSIDE* PART (FAL)) FROM (*MOUTH* PART (FAL)))
		     TIME (T-2) FOCUS ((ACTOR)))
 )TIME (T-3))


;3	Othello killed Desdemona by choking her
((CON
	((CON
	  ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-4))
	  <≡ 
	  ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
		  OBJECT(*AIR*))
	   FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2))
	))
  ∧
	((CON
	  ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
		  OBJECT(*AIR*))
	   FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-2))
	  <≡
	  ((ACTOR (DES) <≡>T (*HEALTH* VAL (-10))) TIME (T-2))
        ))
))


)
)
