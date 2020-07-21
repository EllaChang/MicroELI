(defparameter *EKC.EX* '(

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (MARY1) <≡>T (*MSTATE* VAL (*ANGRY*))))))

((CON ((ACTOR (BILL1) <=> (*WRITE*) OBJECT (LETTER1))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*ANGRY*))))))

((CON ((ACTOR (JOHN1) <=> (*DO*) OBJECT (HAMMER1))) <≡ ((ACTOR (GLASS1) <≡>T (*PSTATE* VAL (*BROKEN*))))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (GLASS1) <≡>T (*PSTATE* VAL (*CLEAN*))))))

((CON ((ACTOR (MARY1) <=> (*ATRANS*) OBJECT (BEER1) TO (BILL1))FOCUS(ACTOR)) 
<≡ ((ACTOR (BILL1) <≡>T (*PSTATE* VAL (*COMFORTABLE*))))))

((CON ((ACTOR (BILL1) <=> (*DO*) OBJECT (WINE1))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC (+2))))

((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) INST ((ACTOR (BILL1) <=> (*MOVE* MANNER (*RAPID*)) OBJECT (*FEET*)))))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))) INC(+2))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))) INC(+2))))

((CON ((ACTOR (BILL1) <=> (*INGEST*) OBJECT (ALCOHOL1))) <≡ ((ACTOR (MARY1) <≡>T (*MSTATE* VAL (*JOY*))) INC(-2))))

((CON ((ACTOR (BILL1) <=> (*DO*) OBJECT (WINE1))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))) INC(-2))))
 

((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) INST ((ACTOR (BILL1) <=> (*MOVE* MANNER (*RAPID*)) OBJECT (*FEET*)))))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))) INC(-2))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))) INC(-2))))

((CON ((ACTOR (BILL1) <=> (*INGEST*) OBJECT (ALCOHOL1))) <≡ ((ACTOR (MARY1) <≡>T (*MSTATE* VAL (*JOY*)))INC(-4))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (BILL1) <≡>T (*PSTATE* VAL (*PHURT*))))))

((CON ((ACTOR (BILL1) <=> (*CONC*) MOBJECT (*CON* INVOLV (AUTO1)))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+2))))

((CON ((ACTOR (MARY1) <=> (*DO*) OBJECT (HAMMER1))) <≡ ((ACTOR (BILL1) <≡>T (*HEALTH* VAL (-10))))))

((CON ((ACTOR (*∃ONE*) <=> (*DO*) OBJECT (HAMMER1))) <≡ ((ACTOR (BILL1) <≡>T (*HEALTH* VAL (-10))))))

((CON ((ACTOR (BILL1) <=> (*DO*) OBJECT (WINE1))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*))))))

((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) INST ((ACTOR (BILL1) <=> (*MOVE* MANNER (*RAPID*)) OBJECT (*FEET*)))))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (BILL1) <=> (*INGEST*) OBJECT (ALCOHOL1))) <≡ ((ACTOR (MARY1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+2))))

((CON ((ACTOR (BILL1) <=> (*DO*) OBJECT (WINE1))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) INST ((ACTOR (BILL1) <=> (*MOVE* MANNER (*RAPID*)) OBJECT (*FEET*)))))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (JOHN1) <=> (*DO*))) <≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (BILL1) <=> (*INGEST*) OBJECT (ALCOHOL1))) <≡ ((ACTOR (MARY1) <≡>T (*MSTATE* VAL (*JOY*)))INC(+4))))

((CON ((ACTOR (MARY1) <=> (*ATRANS*) OBJECT (WINE1) TO (BILL1))) <≡ ((ACTOR (BILL1) <≡>T (*PSTATE* VAL (*PHURT*) MODE ((NEG)))))))
)
)
