(defparameter *FOLIO1.EX*
'(
;1 Othello wanted to kill Desdemona

((CON
    ((CON
	((CON
		((ACTOR (OTH) <=> (*DO*)) TIME (T-1))
	  <≡ 	((ACTOR (DES) <≡>T (*HEALTH* VAL (-10))) TIME (T-1))
	))
      <≡C
	((ACTOR (OTH) <≡>T (*JOY*) ) INC(+3) TIME(T-1) )
    ))
  <≡> (*MLOC* VAL (*LTM* PART (OTH)))
 ) TIME (T-2))


;2 Othello heard from Iago that Cassio had Desdemona's handkerchief
	((ACTOR (IAG) <=> (*MTRANS*) FROM (*CP* PART (IAG)) TO (*CP* PART (OTH))
	  MOBJECT ((ACTOR (HANDKERCHIEF *OWN* (DES)) <≡> (*POSS* VAL (CAS)))
	  	    TIME (T-3))
	  ) TIME (T-3))

;3 Othello wanted to kill Desdemona because he heard from Iago that Cassio had
;her handkerchief
((CON
	((ACTOR (IAG) <=> (*MTRANS*) FROM (*CP* PART (IAG)) TO (*CP* PART (OTH))
	  MOBJECT ((ACTOR (HANDKERCHIEF *OWN* (DES)) <≡> (*POSS* VAL (CAS)))
	  	    TIME (T-3))
	 ) FOCUS ((TO PART)) TIME (T-3))
  <≡
  ((CON
    ((CON
	((CON
		((ACTOR (OTH) <=> (*DO*)) TIME (T-1))
	  <≡ 	((ACTOR (DES) <≡>T (*HEALTH* VAL (-10))) TIME (T-1))
	))
      <≡C
	((ACTOR (OTH) <≡>T (*JOY*) ) INC(+3) TIME(T-1) )
    ))
    <≡> (*MLOC* VAL (*LTM* PART (OTH)))
   ) TIME (T-2))
  ))

;4 Hamlet killed Laertes by stabbing him with his sword
((CON
	((ACTOR (HAM) <=> (*PTRANS*) OBJECT (SWORD *POSS* (HAM))
	  FROM (*SURFACE* PART (LAE)) TO (*INSIDE* PART (LAE))
	 ) TIME (T-1))
  <≡ 	((ACTOR (LAE) <≡>T (*HEALTH* VAL (-10))) TIME (T-1))
))

;5 Falstaff poured some beer into a glass
((ACTOR (FAL) <=> (*PTRANS*) OBJECT (BEER1 REF (INDEF)) FROM(PITCH1 REF (INDEF))
  TO (GLASS1 REF (INDEF))) TIME (T-3))

;6 Falstaff drank the beer
((ACTOR (FAL) <=> (*INGEST*) OBJECT (BEER1 REF (DEF)) FROM (*MOUTH* PART (FAL))
  TO (*INSIDE* PART (FAL)) ) TIME (T-2))

;7 Falstaff choked on the beer
((CON
	((ACTOR (FAL) <=> (*INGEST*) OBJECT (BEER1 REF (DEF))
	  FROM (*MOUTH* PART (FAL))  TO (*INSIDE* PART (FAL)) ) TIME (T-2))
  <≡
	((ACTOR (FAL) <=> (*INGEST*) OBJECT (*AIR*)
	  FROM (*MOUTH* PART (FAL))  TO (*INSIDE* PART (FAL))
	 ) MODE ((*CANNOT*)) TIME (T-2))
))

;8	Othello strangled Desdemona
((CON
   ((CON
     ((ACTOR (OTH) <=> (*GRASP*) OBJECT (*NECK* PART (DES))) TIME (T-4))
     <≡ 
     ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
	     OBJECT(*AIR*))
      FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-3))
   ))
  ∧
   ((CON
     ((ACTOR (DES) <=> (*INGEST*) TO (*INSIDE* PART (DES)) FROM (*MOUTH* PART (DES))
	     OBJECT(*AIR*))
      FOCUS ((ACTOR)) MODE ((*CANNOT*)) TIME (T-3))
     <≡
     ((ACTOR (DES) <≡>T (*HEALTH* VAL (-10))) TIME (T-1))
   ))
))

)
)