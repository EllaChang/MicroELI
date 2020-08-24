;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Dictionary Functions
;;;

(defmacro defword (&body def)
  `(progn (setf (get ',(car def) 'defintion) ',(cdr def))
    ',(car def)))

;; Vocabulary items.

(defword *start*
  ((assign *part-of-speech* nil
           *cd-form* nil
           *subject* nil
           *predicates* nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *subject* *cd-form*)
     (next-packet
      ((test (equal *part-of-speech* 'verb))
       (assign *concept* *cd-form*)))))))

(defword *start-question*
  ((assign *part-of-speech* nil
           *cd-form* nil
           *subject* nil
           *predicates* nil)
   (next-packet
    ((test (equal *part-of-speech* 'verb))
     (assign *concept* *cd-form*))
    ((test (equal *word* 'who))
     (assign *subject* '(*?*))
     (next-packet
      ((test (equal *part-of-speech* 'verb))
       (assign *concept* *cd-form*)))))))

(defword jack
  ((assign *cd-form* '(jack)
           *part-of-speech* 'noun-phrase)))

(defword bob
  ((assign *cd-form* '(bob)
           *part-of-speech* 'noun-phrase)))

(defword nene
  ((assign *cd-form* '(nene)
           *part-of-speech* 'noun-phrase)))

(defword ella
  ((assign *cd-form* '(ella)
           *part-of-speech* 'noun-phrase)))

(defword went
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var1)
                       (to     ?go-var2)
                       (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *word* 'to))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var2 *cd-form*))))
    ((test (equal *word* 'home))
     (assign go-var2 '(house))))))

(defword to
  ((assign *part-of-speech* 'preposition
           *cd-form* '(to))))

(defword a
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'noun-phrase
           *predicates* nil))
  ((test (equal *part-of-speech* 'adjective))
   (assign *part-of-speech* 'noun-phrase
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil)))

(defword a2
  ((assign *part-of-speech* nil
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
           *predicted* (get-np-prediction))))

(defword restaurant
  ((assign *part-of-speech* 'noun
           *cd-form '(restaurant))))

(defword he
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(person))))

(defword ordered
  ((assign *part-of-speech* 'verb
           *cd-form* '(atrans (actor ?get-var3)
                       (object ?get-var2)
                       (to ?get-var1)
                       (from ?get-var3))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)))

(defword ate
  ((assign *part-of-speech* 'verb
           *cd-form* '(ingest (actor ?get-var1)
                       (object ?get-var2)
                       (to ?get-var3)
                       (from ?get-var3))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var2 *cd-form*)))))

(defword lobster
  ((assign *part-of-speech* 'noun
           *cd-form* '(lobster))))

(defword left
  ((assign *part-of-speech* 'verb
           *cd-form* '(ptrans (actor  ?go-var1)
                       (object ?go-var1)
                       (to     ?go-var2)
                       (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)))

(defword got
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor  ?get-var1)
                       (object ?get-var2)
                       (to     ?get-var1)
                       (from   ?get-var3))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var2 *cd-form*)))))

(defword the
  ((assign *part-of-speech* nil
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
           *predicted* (get-np-prediction))))

(defword get
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor  ?get-var1)
                       (object ?get-var2)
                       (to     ?get-var1)
                       (from   ?get-var3))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var2 *cd-form*)))))

(defword the2
  ((assign *part-of-speech* nil
           *cd-form* (append *cd-form* *predicates*)
           *predicates* nil
           *predicted* (get-np-prediction))))

(defword the
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'noun-phrase
           *predicates* nil
           *predicted* (get-np-prediction))))

(defword red
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'adjective
           *predicates* '((color(red))))))

(defword kite
  ((assign *part-of-speech* 'noun
           *cd-form* '(kite))))

(defword hawaii
  ((assign *part-of-speech* 'noun
           *cd-form* '(place-us))))

(defword knife
  ((assign *part-of-speech* 'noun
           *cd-form* '(knife))))

(defword beach
  ((assign *part-of-speech* 'noun
           *cd-form* '(beach))))


(defword store
  ((assign *part-of-speech* 'noun
           *cd-form* '(store))))

(defword paid
  ((assign *part-of-speech* 'verb
           *cd-form* '(atrans (actor ?get-var1)
                       (object ?get-var2)
                       (to ?get-var3)
                       (from ?get-var1))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (and (equal *part-of-speech* 'noun)
                (feature *cd-form* 'cost-form)))
     (assign *cd-form* '((amount (cost-form))))
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (and (equal *part-of-speech* 'noun)
                    (feature *cd-form* 'money)))
         (assign get-var2 *cd-form*)))))))))

(defword pay
  ((assign *part-of-speech* 'verb
           *cd-form* '(atrans (actor ?get-var1)
                       (object ?get-var2)
                       (to ?get-var3)
                       (from ?get-var1))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil)
   (next-packet
    ((test (and (equal *part-of-speech* 'noun)
                (feature *cd-form* 'cost-form)))
     (assign *cd-form* '((amount (cost-form))))
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (and (equal *part-of-speech* 'noun)
                    (feature *cd-form* 'money)))
         (assign get-var2 *cd-form*)))))))))

(defword bill
  ((assign *part-of-speech* 'noun
           *cd-form* '(cost-form)
           *predicates* '((amount (cost-form))))))

(defword seashell
  ((assign *part-of-speech* 'noun
           *cd-form* '(seashell))))

(defword with
  ((assign *part-of-speech* 'preposition)))

(defword check
  ((assign *part-of-speech* 'noun
           *cd-form* '(money)))
  ((assign *part-of-speech* 'noun
           *cd-form* '(cost-form)
           *predicates* '((amount (cost-form))))))

(defword go
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var1)
                       (to     ?go-var2)
                       (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *word* 'to))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var2 *cd-form*))))
    ((test (equal *word* 'home))
     (assign go-var2 '(house))))))

(defword do
  ((assign *part-of-speech* 'verb
           *cd-form* '(*do* (actor  ?do-var1)
                       (object ?do-var2))
           do-var1 *subject*
           do-var2 nil)))

(defword who
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(*?*))))

(defword where
  ((assign *part-of-speech 'adverb)
   (next-packet
    ((test (equal *word* 'go))
     (assign go-var2 '(*?*))))))

(defword what
  ((assign *part-of-speech 'adverb)
   (next-packet
    ((test (equal *word* 'get))
     (assign get-var2 '(*?*)))
    ((test (equal *word* 'do))
     (assign do-var2 '(*?*)))
    ((test (equal *word* 'pay))
     (assign get-var2 '(*?*))))))

(defword did
  ((assign *part-of-speech* 'helping-verb)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *subject* *cd-form*)))))

(defword does
  ((assign *part-of-speech* 'helping-verb)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *subject* *cd-form*)))))

(defword acid
  ((test (equal *part-of-speech* 'noun))
   (assign *part-of-speech* 'noun-phrase
           *predicates* '((type(acid))))))

(defword rain
  ((assign *part-of-speech* 'noun
           *cd-form* '(rain))))

(defword atmosphere
  ((assign *part-of-speech* 'noun
           *cd-form* '(atmosphere))))

(defword lands
  ((assign *part-of-speech* 'noun
           *cd-form* '(lands))))

(defword enters
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var2)
                       (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)))))

(defword and
  ((next-packet
    ((test (equal *part-of-speech* 'noun))
     (assign go-var2 (append (list go-var2) (list *cd-form*)))))))

(defword died
  ((assign *part-of-speech* 'verb
           *cd-form* '(*state* (actor ?s-var1)
                       (attr ?s-var2)
                       (value ?s-var3))
           s-var1 *subject*
           s-var2 '(*health*)
           s-var3 '(-10))))

(defword gave
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (object ?get-var2)
                       (to ?get-var3)
                       (from ?get-var4)
                       (thru ?get-var5))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (next-packet
        ((test (equal *part-of-speech* 'noun-phrase))
         (assign get-var3 *cd-form*)))))))))

(defword trash
  ((assign *part-of-speech* 'noun
           *cd-form* '(trash))))

(defword truck
  ((assign *part-of-speech* 'noun
           *cd-form* '(truck))))

(defword unloaded
  ((assign *part-of-speech* 'verb
           *cd-form* '((*expel* (actor ?j-var1)
                                (object ?j-var2))
                       (*ptrans* (actor ?go-var1)
                                 (object ?go-var2)
                                 (to go-var3)
                                 (from go-var4)))
           j-var1 nil
           j-var2 nil
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var2 *cd-form*
             go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'from))
       (next-packet
        ((test *part-of-speech* 'noun-phrase)
         (assign j-var1 *cd-form*
                 go-var4 *cd-form*)
         (next-packet
          ((test (equal *word* 'to))
           (next-packet
            ((test *part-of-speech* 'noun-phrase)
             (assign go-var3 *cd-form*))))))))
      ((test (equal *word* 'to))
       (next-packet
        ((test *part-of-speech* 'noun-phrase)
         (assign go-var3 *cd-form*)
         (next-packet
          ((test (equal *word* 'from))
           (next-packet
            ((test *part-of-speech* 'noun-phrase)
             (assign j-var1 *cd-form*
                     go-var4 *cd-form*)))))))))))))

(defword warmed
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor ?pb-var1)
                       (a-attr ?pb-var2)
                       (a-val ?pb-var3)
                       (object ?pb-var4)
                       (o-attr ?pb-var5)
                       (o-val ?pb-var6))
           pb-var1 *subject*
           pb-var2 '*TEMP*
           pb-var3 '(1)
           pb-var4 nil
           pb-var5 nil
           pb-var6 nil)
   (next-packet
    ((test (equal *word* 'up))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign pb-var2 nil
               pb-var3 nil
               pb-var4 *cd-form*
               pb-var5 '*TEMP*
               pb-var6 '(1)))))
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign pb-var2 nil
             pb-var3 nil
             pb-var4 *cd-form*
             pb-var5 '*TEMP*
             pb-var6 '(1))))))


(provide :dict)