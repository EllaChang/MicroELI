(defparameter *GERM.EX*

  '(

;1  John ate a banana
  ((ACTOR (JOHN1) <=> (*INGEST*) OBJECT (BANANA1 REF (INDEF)) FROM (*MOUTH* PART (JOHN1))
    TO (*INSIDE* PART (JOHN1)) ) TIME(T-2))

;2  A monkey ate a banana
  ((ACTOR (MONK1 REF (INDEF)) <=> (*INGEST*) OBJECT (BANANA1 REF (INDEF)) FROM (*MOUTH* PART (JOHN1))
    TO (*INSIDE* PART (JOHN1)) ) TIME(T-2))

;3  John wants to eat a banana
  ((CON
    ((ACTOR (JOHN1) <=> (*INGEST*) OBJECT (BANANA1 REF (INDEF)) FROM (*MOUTH* PART (JOHN1))
      TO (*INSIDE* PART (JOHN1)) ) TIME(T+2))
    <≡> (*MLOC* VAL (*LTM* PART (JOHN1))) )TIME (T-0))

;4 John wants a banana
  ((CON
    ((CON ((ACTOR (*ONE1*) <=> (*ATRANS*) OBJECT (BANANA1 REF (INDEF))
          TO (JOHN1) FROM (*ONE1*)) TIME (T+1))
      <≡C ((ACTOR (JOHN1) <≡>T (*JOY*) <≡>F (*JOY*)) INC (2) TIME (T+1))))
    <≡> (*MLOC* VAL (*LTM* PART (JOHN1))))  TIME (T-0)) 

  )

) 