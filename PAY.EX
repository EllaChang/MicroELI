(defparameter *PAY.EX*

 '(
 
  ((CON
      ((ACTOR (JOHN) <=> (*ATRANS*) OBJECT (*DOL* QUANTITY (2)) TO (*BAR* REF (DEF))
	FROM (JOHN)) FOCUS ((ACTOR)) TIME (T-1))
  <≡≡>
      ((ACTOR (*BAR* REF (DEF)) <=> (*ATRANS*) OBJECT (WINE1 REF (INDEF)) TO (JOHN)
	FROM (*BAR* REF (DEF))) TIME (T-1)FOCUS((ACTOR)))
  )FOCUS ((CON  OBJECT)))

  )

)
