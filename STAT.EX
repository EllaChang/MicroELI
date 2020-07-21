;; had to change POSS to *POSS*
;; OWN to *OWN, BOOKP to BOOK1
(defparameter *STAT.EX*

  '(

  ((ACTOR (BOOK1 REF (DEF)) <≡> (*POSS* VAL (JOHN1))))

  ((ACTOR (BOOK1 REF (DEF))  <≡> (*OWN* VAL (JOHN1))))

  ((ACTOR (BOOK1 REF (DEF)) <≡> (*OWN* VAL (JOHN1))) FOCUS(ACTOR))

  ((ACTOR (JOHN1) <≡> (*HEALTH* VAL (-10))))

  )

)