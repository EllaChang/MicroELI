(defparameter *BELIEV.EX*

  '(

  ((CON ((ACTOR (JOHN1) <=> (*INGEST*) OBJECT (BOURBON1))) <≡> (*MLOC* VAL (*LTM* PART (MARY1)))))

  ((CON (*CON* ↔ ((ACTOR (BILL1) <=> (*MTRANS*) MOBJECT (*CON*) FROM (*CP* PART (BILL1)) TO (*CP* PART (JOHN1)))
TIME ((P)))) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((ACTOR (MARY1) <≡> (*MSTATE* VAL (*EVIL*)))) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((ACTOR (JOHN1) <≡> (*SSTATE* VAL (DOCTOR1))) TIME ((FUT))) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) TO (MARY1)) TIME ((FUT))) <≡> (*MLOC* VAL (*LTM* PART (MARY1)))))

  ((CON ((ACTOR (*∃ONE*) <=> (*ATRANS*) OBJECT (BOTTLE1) TO (JOHN1) FROM (*∃ONE*)) TIME ((FUT)))
<≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((CON ((ACTOR (MARY1) <=> (*MTRANS*) MOBJECT (*CON*) FROM (*CP* PART (MARY1)) TO (*CP* PART (JOHN1)))
TIME ((FUT))) <≡ ((ACTOR (BILL1) <≡>T (*PSTATE* VAL (*PHURT*)))))) <≡> (*MLOC* VAL (*LTM* PART (BILL1)))))

  ((CON ((CON ((ACTOR (POLICEMAN1) <=> (*DO*))) <≡ ((ACTOR (JOHN1) <≡>T (*PSTATE* VAL (*PHURT*))))))
<≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((CON ((ACTOR (*∃ONE*) <=> (*DO*) OBJECT (GUN1))) <≡ ((ACTOR (MARY1) <≡>T (*PSTATE* VAL (*PHURT*))))))
<≡> (*MLOC* VAL (*LTM* PART (MARY1)))))

  ((CON ((CON ((ACTOR (JOHN1) <=> (*PTRANS*) OBJECT (BOURBON1) TO (BILL1)) TIME ((P)))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(2)))) <≡> (*MLOC* VAL (*LTM* PART (BILL1)))))

  ((CON ((CON ((ACTOR (JOHN1) <=> (*INGEST*) OBJECT (GIN2))) <≡> (*BAD*))) <≡> (*MLOC* VAL (*LTM* PART (MARY1)))))

  ((CON ((CON ((ACTOR (JOHN1) <=> (*INGEST*) OBJECT (GIN2))) <≡> (*CRED* VAL  (*LO*)))) <≡> (*MLOC* VAL (*LTM* PART (MARY1)))))
 
  ((CON ((CON ((ACTOR (BILL1) <=> (*DO*))) <≡> (*CRED* VAL (*LO*)))) <≡> (*MLOC* VAL (*LTM* PART (MARY1)))))

  ((CON ((CON ((ACTOR (BILL1) <=> (*PTRANS*) OBJECT (BILL1) TO (STORE1)) TIME ((FUT)))
<≡ ((ACTOR (BILL1) <≡>T (*MSTATE* VAL (*JOY*)))INC(2)))) <≡> (*MLOC* VAL (*LTM* PART (BILL1)))))

  ((CON ((CON ((ACTOR (MARY1) <=> (*PTRANS*) OBJECT (MARY1) TO (JOHN1)) TIME (FUT))
<≡ ((ACTOR (JOHN1) <≡>T (*MSTATE* VAL (*JOY*)))INC(2)))) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  ((CON ((CON ((ACTOR (*∃ONE*) <=> (*ATRANS*) OBJECT (BOTTLE1) TO (JOHN1)) TIME (FUT))
<≡ ((ACTOR (JOHN1) <≡>T (*MSTATE* VAL (*JOY*)))INC(2)))) <≡> (*MLOC* VAL (*LTM* PART (JOHN1)))))

  )
)
