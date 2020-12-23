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
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)
   (next-packet
    ((test (equal *word* 'to))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var9 *cd-form*))))
    ((test (equal *word* 'home))
     (assign go-var9 '(house))))))

(defword to
  ((assign *part-of-speech* 'preposition
           *cd-form* '(to))))

(defword restaurant
  ((assign *part-of-speech* 'noun-phrase
           *cd-form '(restaurant))))

(defword he
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(person))))

(defword ordered
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 *subject*)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var4 *cd-form*)
     (next-packet
      ((test (equal *word* 'for))
       (next-packet
        ((test (equal *part-of-speech* 'noun-phrase)
               (assign get-var9 *cd-form*))))))))))

(defword ate
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ingest* (actor ?in-var1)
                       (a-attr ?in-var2)
                       (a-val ?in-var3)
                       (object ?in-var4)
                       (o-attr ?in-var5)
                       (o-val ?in-var6)
                       (from ?in-var7)
                       (to ?in-var8))
           in-var1 *subject*
           in-var2 '*STATE-JOIN*
           in-var3 '(+2)
           in-var4 nil
           in-var5 '*STATE-JOIN*
           in-var6 '(+2)
           in-var7 nil
           in-var8 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign in-var4 *cd-form*)))))

(defword lobster
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(lobster))))

(defword left
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)))

(defword got
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var4 *cd-form*)))))

(defword get
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var4 *cd-form*)))))

(defword the
  ((assign *predicates* nil *predicted* (get-np-prediction))
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *part-of-speech* 'noun-phrase
             *cd-form* (append *cd-form* *predicates*)
             *predicates* nil
             *predicted* (get-np-prediction)))
    ((test (equal *part-of-speech* 'adjective))
     (assign *part-of-speech* 'noun-phrase
             *cd-form* (append *cd-form* *predicates*)
             *predicates* nil)))))

(defword a
  ((assign *predicates* nil *predicted* (get-np-prediction))
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign *part-of-speech* 'noun-phrase
             *cd-form* (append *cd-form* *predicates*)
             *predicates* nil
             *predicted* (get-np-prediction)))
    ((test (equal *part-of-speech* 'adjective))
     (assign *part-of-speech* 'noun-phrase
             *cd-form* (append *cd-form* *predicates*)
             *predicates* nil)))))

(defword red
  ((test (equal *part-of-speech* 'noun-phrase))
   (assign *part-of-speech* 'adjective
           *predicates* '((color(red))))))

(defword kite
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(kite))))

(defword hawaii
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(place-us))))

(defword knife
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(knife))))

(defword beach
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(beach))))


(defword store
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(store))))

(defword paid
  ((assign *part-of-speech* 'verb
           *cd-form* '(atrans (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 '*WEALTH*
           get-var3 '(-1)
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 nil)
   (next-packet
    ((test (and (equal *part-of-speech* 'noun-phrase)
                (feature *cd-form* 'cost-form)))
     (assign get-var4 *cd-form*)
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (and (equal *part-of-speech* 'noun-phrase)
                    (feature *cd-form* 'money)))
         (assign get-var8 *cd-form*)))))))))

(defword pay
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 nil)
   (next-packet
    ((test (and (equal *part-of-speech* 'noun-phrase)
                (feature *cd-form* 'cost-form)))
     (assign *cd-form* '((amount (cost-form))))
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (and (equal *part-of-speech* 'noun-phrase)
                    (feature *cd-form* 'money)))
         (assign get-var4 *cd-form*)))))))))

(defword bill
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(cost-form)
           *predicates* '((amount (cost-form))))))

(defword seashell
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(seashell))))

(defword with
  ((assign *part-of-speech* 'preposition)))

(defword check
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(money)))
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(cost-form))))

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
  ((test (equal *part-of-speech* 'noun-phrase))
   (assign *part-of-speech* 'noun-phrase
           *predicates* '((type(acid))))))

(defword rain
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(rain))))

(defword atmosphere
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(atmosphere))))

(defword lands
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(lands))))

(defword enters
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var4 *cd-form*
             go-var9 *cd-form*)))))

(defword and
  ((next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 (append (list go-var2) (list *cd-form*)))))))

(defword gave
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?get-var1)
                       (a-attr ?get-var2)
                       (a-val ?get-var3)
                       (object ?get-var4)
                       (o-attr ?get-var5)
                       (o-val ?get-var6)
                       (from ?get-var7)
                       (with ?get-var8)
                       (to ?get-var9))
           get-var1 *subject*
           get-var2 nil
           get-var3 nil
           get-var4 nil
           get-var5 nil
           get-var6 nil
           get-var7 nil
           get-var8 nil
           get-var9 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign get-var4 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (next-packet
        ((test (equal *part-of-speech* 'noun-phrase))
         (assign get-var9 *cd-form*)))))))))

(defword soup
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(soup))))

(defword microwave
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(microwave))))

(defword truck
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(truck))))

(defword trash
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(trash))))

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
           pb-var3 '(+1)
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
               pb-var6 '(+1)))))
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign pb-var2 nil
             pb-var3 nil
             pb-var4 *cd-form*
             pb-var5 '*TEMP*
             pb-var6 '(+1))))))

(defword flows
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)
   (next-packet
    ((test (equal *word* 'into))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var9 *cd-form*)))))))

(defword water
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(water))))

(defword streams
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(streams))))

(defword join
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor ?j-var1)
                       (a-attr ?j-var2)
                       (a-val ?j-var3)
                       (object ?j-var4)
                       (o-attr ?j-var5)
                       (o-val ?j-var6)
                       (from ?j-var7)
                       (to ?j-var8))
           j-var1 *subject*
           j-var2 '*STATE-JOIN*
           j-var3 '(+2)
           j-var4 *subject*
           j-var5 '*STATE-JOIN*
           j-var6 '(+2)
           j-var7 *subject*
           j-var8 *subject*)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var4 *cd-form*
             j-var8 *cd-form*))
    ((test (equal *word* 'with))
     (next-packet
      ((text (equal *part-of-speech* 'noun-phrase))
       (assign j-var4 *cd-form*
               j-var8 *cd-form*))))
    ((test (equal *word* 'in))
     (next-packet
      ((text (equal *part-of-speech* 'noun-phrase))
       (assign j-var4 *cd-form*
               j-var8 *cd-form*)))))))

(defword plants
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(plants))))

(defword dead
  ((test (equal *part-of-speech* 'noun-phrase))
   (assign *part-of-speech* 'adjective
           *predicates* '((health(dead))))))

(defword erupt
  ((assign *part-of-speech* 'verb
           *cd-form* '(*expel* (actor ?exp-var1)
                       (a-attr ?exp-var2)
                       (a-val ?exp-var3)
                       (object ?exp-var4)
                       (o-attr ?exp-var5)
                       (o-val ?exp-var6)
                       (from ?exp-var7)
                       (to ?exp-var8))
           exp-var1 *subject*
           exp-var2 '*STATE-JOIN*
           exp-var3 '(-2)
           exp-var4 nil
           exp-var5 '*STATE-JOIN*
           exp-var6 '(-2)
           exp-var7 *subject*
           exp-var8 nil)
   (next-packet
    ((test (equal *cd-form* 'noun-phrase))
     (assign exp-var4 *cd-form*)))))

(defword volcanoes
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(valcanoes))))

(defword lava
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(lava))))

(defword acts
  ((assign *part-of-speech* 'verb
           *cd-form* '(*propel* (actor ?prop-var1)
                       (a-attr ?prop-var2)
                       (a-val ?prop-var3)
                       (object ?prop-var4)
                       (o-attr ?prop-var5)
                       (o-val ?prop-var6)
                       (from ?prop-var7)
                       (to ?prop-var8))
           prop-var1 *subject*
           prop-var2 nil
           prop-var3 nil
           prop-var4 nil
           prop-var5 nil
           prop-var6 nil
           prop-var7 nil
           prop-var8 nil)
   (next-packet
    ((test (equal *word* 'on))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign prop-var4 *cd-form*)))))))

(defword gravity
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(gravity))))

(defword particles
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(particles))))

(defword grabs
  ((assign *part-of-speech* 'verb
           *cd-form* '(*atrans* (actor ?gs-var1)
                       (a-attr ?gs-var2)
                       (a-val ?gs-var3)
                       (object ?gs-var4)
                       (o-attr ?gs-var5)
                       (o-val ?gs-var6)
                       (with ?gs-var7))
           gs-var1 *subject*
           gs-var2 nil
           gs-var3 nil
           gs-var4 nil
           gs-var5 nil
           gs-var6 nil
           gs-var7 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign gs-var4 *cd-form*)
     (next-packet
      ((test (equal *word* 'with))
       (next-packet
        ((test (equal *part-of-speech* 'noun-phrase))
         (assign gs-var7 *cd-form*)))))))))

(defword owl
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(owl))))

(defword rabbit
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(rabbit))))

(defword beak
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(beak))))

(defword moved
  ((assign *part-of-speech* 'verb
           *cd-form* '(*move* (actor ?mov-var1)
                       (a-attr ?mov-var2)
                       (a-val ?mov-var3)
                       (object ?mov-var4)
                       (o-attr ?mov-var5)
                       (o-val ?mov-var6)
                       (from ?mov-var7)
                       (to ?mov-var8))
           mov-var1 *subject*
           mov-var2 nil
           mov-var3 nil
           mov-var4 nil
           mov-var5 nil
           mov-var6 nil
           mov-var7 nil
           mov-var8 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign mov-var4 *cd-form*)))))

(defword arms
  ((assign *part-of-speech* 'noun-phrase
           *cd-form* '(arms))))

(defword wander
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)))

(defword visit
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                       (a-attr ?go-var2)
                       (a-val ?go-var3)
                       (object ?go-var4)
                       (o-attr ?go-var5)
                       (o-val ?go-var6)
                       (from ?go-var7)
                       (thru ?go-var8)
                       (to ?go-var9))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil
           go-var5 nil
           go-var6 nil
           go-var7 nil
           go-var8 nil
           go-var9 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var4 'cd-form
             go-var9 'cd-form)))))


(provide :dict)