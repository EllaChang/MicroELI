(defparameter *CRUD.EX* '(

((ACTOR	(JOHN1) <=> (*MTRANS*) TO (*CP* PART (MARY1)) FROM (*CP* PART (JOHN1))
	MOBJECT	((CON
		    ((ACTOR (MARY1) <=> (*INGEST*) OBJECT (WINE1 REF (*A*))
		      TO (*INSIDE* PART (MARY1)) FROM (*MOUTH* PART (MARY1)))
		     TIME (T-1) FOCUS ((ACTOR)))
		  <≡C
		    ((ACTOR (MARY1) <≡>T (*JOY*) <≡>F (*JOY*))
		     TIME (T-1) FOCUS ((ACTOR)) INC (2)))))
 TIME (T-3))

((CON ((CON
	  ((ACTOR (JOHN1) <=> (*GRASP*) OBJECT (*NECK* PART (MARY1)))
	   TIME (T-1) MODE (NIL))
	<≡
	  ((ACTOR (MARY1) <=> (*INGEST*) OBJECT (*AIR*) FROM (*MOUTH* PART (MARY1))
	    TO (*INSIDE* PART (MARY1)))
	   TIME (T-1) MODE ((CANNOT)) FOCUS ((CON ACTOR)))
      ))
  AND ((CON
          ((ACTOR (MARY1) <=> (*INGEST*) OBJECT (*AIR*) FROM (*MOUTH* PART (MARY1))
	    TO  (*INSIDE* PART (MARY1)))
	   TIME (T-1) MODE ((CANNOT)) FOCUS ((CON ACTOR)))
	<≡ ((ACTOR (MARY1) <≡>T (*HEALTH* VAL (-10)))
	    TIME (T-1))
      ))
))

)
)
