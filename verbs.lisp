; The bacteria absorb the resulting components.
; The roots absorb water and minerals from the soil.
; Plants absorb carbon dioxide through their stoma.
; Nitrates are what the plants can then absorb.
; The ground becomes saturated with rain water and cannot absorb anymore.
(defword absorb
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ingest* (actor  ?in-var1)
                       (object ?in-var1)
                       (to     ?in-var2)
                       (from   ?in-var3))
           in-var1 *subject*
           in-var2 nil
           in-var3 nil)
   (next-packet
    ((test (equal *word* 'from))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign in-var3 *cd-form*)))))))

; The clouds travel and accumulate more water.
; Over time, mud and silt accumulate over the bones.
; Dead organic material accumulates on the bottom of oceans, riverbeds or swamps, mixing with mud and sand.
; Water accumulates in the sky.
; Filtered waste accumulates in liquid form (urine).
; The water vapor accumulates.
(defword accumulate
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor  ?pb-var1)
                       (object ?pb-var2)
                       (to     ?pb-var3)
                       (from   ?pb-var4)
                       (prev 1)
                       (after 2))
           pb-var1 *subject*                                                                                                                                                                                                                                                                                                                                    
           pb-var2 nil
           pb-var3 nil
           pb-var4 nil))
  (next-packet
   ((test (equal *part-of-speech* 'noun-phrase))
    (assign pb-var2 *cd-form*)
    (next-packet
     ((test (equal *word* 'over))
      (assign pb-var3 *cd-form))
     ((test (equal *word* 'on))
      (assign pb-var3 *cd-form))))))

; The movement is due to a combination of gravity acting on the sediment,
; and/or the movement of the fluid in which the sediment is entrained.
; And the force of gravity acts to move the particles along the sloping surface on which they are resting.
(defword act
  ((assign *part-of-speech* 'verb
           *cd-form* '(*propel* (actor  ?prop-var1)
                       (object ?prop-var2)
                       (to     ?prop-var2)
                       (from   ?prop-var1))
           prop-var1 *subject*
           prop-var2 nil)
   (next-packet
    ((test (equal *word* 'on))
     (next-packet
      ((test (equal *part-of-speech* noun-phrase))
       (assign prop-var2 *cd-form*)))))))

; The vibrations activate tiny hair cells in your inner ear.
; The grinder is activated.
(defword activate
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev 0)
                       (after 1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; Add dirty laundry to the washing machine.
(defword add
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor  ?j-var1)
                       (object ?j-var2)
                       (to     ?j-var3)
                       (from   ?j-var2)
                       (prev 0)
                       (after 1))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (next-packet
        ((test (equal *part-of-speech* noun-phrase))
         (assign j-var3 *cd-form*)))))))))

; The pollution negatively affects the water quality.
(defword affect
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    0)
                       (after   1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; The pancreas releases enzymes to aid digestion.
(defword aid
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    1)
                       (after   2))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; Fissures allow lava to erupt into volcanoes at the surface.
; Diaphragm and other muscles expand to allow room for your lungs to fill.
; Allow the water vapor to cool.
(defword allow
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    0)
                       (after   1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; The lack of vegetation alters the surrounding environment.
(defword alter
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    nil)
                       (after   nil))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; Bones in your middle ear amplify the vibrations.
(defword amplify
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    1)
                       (after   2))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; Pumpkins will appear where the flowers were.
; Male flowers appear.
(defword appear
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev    0)
                       (after   1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; You apply a bandaid or other covering if needed.
; You apply a stamp to the outside of the envelope.
(defword apply
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor  ?j-var1)
                       (object ?j-var2)
                       (to ?j-var3)
                       (from ?j-var4)
                       (prev    0)
                       (after   1))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var2 *cd-form*)
     (next-packet
      ((test (equal *word* to))
       (assign j-var3 *cd-form*)))))))

; The passenger arrives early at the airport.
; The plane arrives at the destination.
(defword arrive
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var1)
                       (to ?go-var2)
                       (from ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *word* 'at))
     (assign go-var2 *cd-form*)))))

; The mRNA attaches itself to the ribosome.
; The virus attaches to the cell's surface.
(defword attach
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor  ?j-var1)
                       (object ?j-var2)
                       (to ?j-var3)
                       (from ?j-var4)
                       (prev    0)
                       (after   1))
           j-var1 *subject*
           j-var2 *subject*
           j-var3 nil
           j-var4 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var2 *cd-form*)
     (next-packet
      ((test (equal *word* to))
       (assign j-var3 *cd-form*)))))))

; To bake a cake you first need to gather your ingredients.
(defword bake
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor  ?pb-var1)
                       (object ?pb-var2)
                       (to     ?pb-var3)
                       (from   ?pb-var4)
                       (prev 1)
                       (after 2))
           pb-var1 *subject*                                                            
           pb-var2 nil
           pb-var3 nil
           pb-var4 nil))
  (next-packet
   ((test (equal *part-of-speech* 'noun-phrase))
    (assign pb-var2 *cd-form*))))

; Some trees bear fruit.
(defword bear
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor  ?pb-var1)
                       (object ?pb-var2)
                       (to     ?pb-var3)
                       (from   ?pb-var4)
                       (prev 0)
                       (after 1))
           pb-var1 *subject*                         
           pb-var2 nil
           pb-var3 nil
           pb-var4 nil))
  (next-packet
   ((test (equal *part-of-speech* 'noun-phrase))
    (assign pb-var2 *cd-form*))))

(defword become
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev   ?st-var1)
                       (after  ?st-var2))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; ??? NOT SURE ABOUT "BEGIN TO..."
(defword begin
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev   0)
                       (after  1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

; Bend the tray slightly to get the ice cubes out and into a drink.
(defword bend
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor  ?pb-var1)
                       (object ?pb-var2)
                       (to     ?pb-var2)
                       (from   ?pb-var2)
                       (prev nil)
                       (after nil))
           pb-var1 *subject*                                                            
           pb-var2 nil))
  (next-packet
   ((test (equal *part-of-speech* 'noun-phrase))
    (assign pb-var2 *cd-form*))))

; Ribosomes bind the new DNA molecules.
; TMRNA molecules bind with the ribosome in a sequence defined by the mRNA code.
(defword bind
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor  ?j-var1)
                       (object ?j-var2)
                       (to ?j-var3)
                       (from ?j-var4)
                       (prev    0)
                       (after   1))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign j-var2 *cd-form*)))))

; The sun is totally blocked.
(defword block
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor  ?st-var1)
                       (object ?st-var2)
                       (prev   2)
                       (after  1))
           st-var1 *subject*
           st-var2 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign st-var2 *cd-form*)))))

(defword blow
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor  ?pb-var1)
                       (object '(wind))
                       (to     ?pb-var2)
                       (from   ?pb-var1)
                       (prev nil)
                       (after nil))
           pb-var1 *subject*                                                            
           pb-var2 nil))
  (next-packet
   ((test (equal *part-of-speech* 'noun-phrase))
    (assign pb-var2 *cd-form*))))



;; ================================= REVERSED ========================================

; "256, 5": "The air sacs transfer the oxygen into your blood."
; "1250, 4": "Electricity is transferred through a wire or cable.",
; "132, 4": "The carbon dioxide in the blood stream is transferred to the air sacs.",
; "502, 2": "The energy is transferred from the pistons moving up and down at high speeds.",
(defword transfer 
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                                (object ?go-var2)
                                (to     ?go-var3)
                                (from   ?go-var4))
           go-var1 *subject*
           go-var2 nil  
           go-var3 nil
           go-var4 nil)
   (next-packet
    ; transport sth from somewhere to somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'from))
       (assign go-var4 *cd-form*))
       (next-packet
        ((test (equal *word* 'to))
         (assign go-var3 *cd-form*)))))
        ; transport sth to somewhere from somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (assign go-var3 *cd-form*))
       (next-packet
          ((test (equal *word* 'from))
           (assign go-var4 *cd-form*)))))
    
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'into))
       (assign go-var3 *cd-form*)))))))

; "1155, 3": "The resulting heat and pressure transforms the organic layer into a dark and waxy substance known as kerogen.",
; "409, 5": "The retina transforms this image into electrical impulses."
(defword transform
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor ?pb-var1)
                                (object ?pb-var2)
                                (prev ?pb-var2)
                                (after ?pb-var3))
        
           pb-var1 *subject*
           pb-var2 nil
           pb-var3 nil)
  (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign pb-var2 *cd-form*)
       (next-packet
        ((test (equal *word* 'into))
         (assign pb-var3 *cd-form*)))))))


; "390, 7": "The national grid uses high voltages to transmit electricity through the power lines."
(defword transmit 
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor ?go-var1)
                                (object ?go-var2)
                                (to     ?go-var3)
                                (from   ?go-var4))
           go-var1 *subject*
           go-var2 nil  
           go-var3 nil
           go-var4 nil)
   (next-packet
    ; transport sth from somewhere to somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'from))
       (assign go-var4 *cd-form*))
       (next-packet
        ((test (equal *word* 'to))
         (assign go-var3 *cd-form*)))))
        ; transport sth to somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (assign go-var3 *cd-form*)))))))

; "157, 2": "Your town or a private company collect and transport the aluminum to a recycling facility.",
; "377, 4": "The oxygen is transported by hemoglobin.",
; "846, 6": "The carbon dioxide by product is transported back to the lungs.",
(defword transport 
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var3)
                       (from   ?go-var4))
           go-var1 *subject*
           go-var2 nil  
           go-var3 nil
           go-var4 nil)
   (next-packet
    ; transport sth from somewhere to somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'from))
       (assign go-var4 *cd-form*))
       (next-packet
        ((test (equal *word* 'to))
         (assign go-var3 *cd-form*)))))
    ; transport sth to somewhere from somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'to))
       (assign go-var3 *cd-form*)))
       (next-packet
          ((test (equal *word* 'form))
           (assign go-var4 *cd-form*))))
    ; transport sth from somewhere back to somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'back))
       (next-packet
        ((test (equal *word* 'to))
         (assign go-var3 *cd-form*))))))
    ; transport sth from somewhere into somewhere
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'into))
       (assign go-var3 *cd-form*)))))))

;; trap

; "1061, 2": "You must draw up a plan to what kind of orbit the satellite will travel.",
; "1061, 3": "You make preparations for the rocket that will travel into space.",
; "135, 3": "The sound waves travel away from the bat.",
; "207, 1": "Electrical signals in the brain travel through nerves to muscles.",
; "409, 6": "The impulses travel along the optic nerve to the brain.",
; "627, 4": "The enzymes travel from the pancreas to the small intestine through tubes.",
; "879, 4": "The clouds travel over areas on land.",
; "882, 3": "The recyclable items travel to a recycling plant.",
; "99, 1": "Rain clouds travel across the sky."
(defword travel 
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var3)
                       (from   ?go-var4))
           go-var1 *subject*
           go-var2 *subject*  
           go-var3 nil
           go-var4 nil)
   (next-packet
    ((test (equal *word* 'to))
     (assign go-var3 *cd-form*))
    
    ((test (equal *word* 'into))
     (assign go-var3 *cd-form*))

    ((test (equal *word* 'away))
     (next-packet
        ((test (equal *word* 'from))
         (assign go-var4 *cd-form*))))

    ((test (equal *word* 'from))
     (assign go-var4 *cd-form*)))))

;; type

; "430, 8": "The trash is unloaded." = something unloads the trash from somewhere to somewhere
(defword unload
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor ?j-var1)
                       (object ?j-var2)
                       (to j-var3)
                       (from j-var4)
                       (prev 2)
                       (after 1))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil)
	(next-packet
	    ((test (equal *part-of-speech* 'noun-phrase))
	     (assign j-var2 *cd-form*)
	     (next-packet
      		((test (equal *word* 'from))
       		 (assign j-var4 *cd-form*)
       		 (next-packet
       		 	((test (equal *word* 'to))
       		 	 (assign j-var3 *cd-form*)))))))))


;; unuse

; "1203, 2": "DNA is unwound partially so that it can be transcribed." = something unwind dna
(defword unwind
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor ?j-var1)
                      (object ?j-var2)
                      (to ?j-var3)
                      (from ?j-var4)
                      (prev ?j-var5) 
                      (after ?j-var6))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil
           j-var5 2
           j-var6 0)
  (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
	 (assign j-var2 *cd-form*)))))

; "693, 3": "This upsets the balance of the carbon cycle."
(defword upset
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor ?st-var1)
           			   (object ?st-var2)
           			   (prev 2)
           			   (after 1))
           st-var1 *subject*
           st-var2 nil) 
	(next-packet
	    ((test (equal *part-of-speech* 'noun-phrase))
	     (assign st-var2 *cd-form*)))))

; "1208, 7": "Exhaust valve opens to vent exhaust out tail pipe."
(defword vent 
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var3)
                       (from   ?go-var4))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil
           go-var4 nil)
   (next-packet
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)
     (next-packet
      ((test (equal *word* 'out))
       (assign go-var3 *cd-form*)))))))

;; venture

; "412, 3": "Eardrum vibrates with the incoming sound.",
; "900, 7": "The cochlea vibrates."
(defword vibrate
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var3)
                       (from   ?go-var4))
           go-var1 *subject*
           go-var2 *subject* 
           go-var3 nil
           go-var4 nil)
   (next-packet
    ((test (equal *word* 'in))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var3 *cd-form*)))))))

;; visit

;; wait

; "1087, 8": "Wake up and enjoy nature."
(defword wake
  ((assign *part-of-speech* 'verb
           *cd-form* '(*strans* (actor ?st-var1)
                                (object ?st-var2)
                                (prev ?st-var3)
                                (after ?st-var4))
           st-var1 *subject*
           st-var2 *subject*
           st-var3 1
           st-var4 2) ;; wake up oneself
	(next-packet
	    ((test (equal *word* 'up))
	     (next-packet
	      ((test (equal *part-of-speech* 'noun-phrase))
	       (assign st-var2 *cd-form*))))
	    ((test (equal *part-of-speech* 'noun-phrase))  
	       (assign st-var2 *cd-form*)))))


; "784, 3": "The animal wanders to another area."
(defword wander
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var3)
                       (from   ?go-var4))
           go-var1 *subject*
           go-var2 *subject* 
           go-var3 nil
           go-var4 nil)
   (next-packet
    ((test (equal *word* 'to))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var3 *cd-form*))))
    ((test (equal *word* 'in))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var3 *cd-form*)))))))


; "1053, 8": "The colder air is then warmed by the floor and the plants." = the floor and plants warmed the air
(defword warm
  ((assign *part-of-speech* 'verb
           *cd-form* '((*pbuild* (actor ?pb-var1)
                                 (object ?pb-var2)
                                 (prev ?pb-var3)
                                 (after ?pb-var4))
               			   (*strans* (actor ?st-var1)
                         			   (object ?st-var2)
                         			   (prev st-var3)
                         			   (after st-var4)))
           pb-var1 *subject*
           pb-var2 '(heat)
           pb-var3 2
           pb-var4 1
           st-var1 *subject*
           st-var2 *subject*
           st-var3 1
           st-var4 2)
	(next-packet
	    ((test (equal *word* 'up))
	     (next-packet
	      ((test (equal *part-of-speech* 'noun-phrase))
	       (assign st-var2 *cd-form*))))
	    ((test (equal *part-of-speech* 'noun-phrase))
	     (assign st-var2 *cd-form*)))))

;; wash


; "1084, 4": "Don't water directly on the leaves.",
; "435, 2": "You water the seeds."
(defword water
  ((assign *part-of-speech* 'verb
           *cd-form* '(*ptrans* (actor  ?go-var1)
                       (object ?go-var2)
                       (to     ?go-var2)
                       (from   ?go-var3))
           go-var1 *subject*
           go-var2 nil
           go-var3 nil)
   (next-packet
    ((test (equal *word* 'on))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign go-var2 *cd-form*))))
    ((test (equal *part-of-speech* 'noun-phrase))
     (assign go-var2 *cd-form*)))))

;; weaken

; "Water and wind erosion wear away the layers of soil on top of the fossil."
(defword wear
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor ?pb-var1)
                                (object ?pb-var2) ;; something wears away 
                                (prev ?pb-var3)
                                (after ?pb-var4))
           pb-var1 *subject*
           pb-var2 *subject*
           pb-var3 1
           pb-var4 0)
  (next-packet
  	;; wedge apart something
    ((test (equal *word* 'away))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign pb-var2 *cd-form*)))))))

; "1007, 1": "A plant dies and withers."
(defword weather
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor ?pb-var1)
                                (object ?pb-var2)
                                (prev ?pb-var3)
                                (after ?pb-var4))
           pb-var1 *subject*
           pb-var2 *subject*
           pb-var3 2
           pb-var4 1)))

; "908, 3": "The force of the pressure exerted on the rock surrounding it is enough to wedge the walls of the crack farther apart, thus expanding and deepening the crack."
(defword wedge
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor ?j-var1)
                              (object ?j-var2)
                              (to ?j-var3)
                              (from ?j-var4)
                              (prev ?j-var5) 
                              (after ?j-var6))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil
           j-var5 2
           j-var6 1)
  (next-packet
  	;; wedge apart something
    ((test (equal *word* 'apart))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign j-var2 *cd-form*))))
    ;; wedge soomething apart
    ((test (equal *part-of-speech* 'noun-phrase))
	 (assign j-var2 *cd-form*)))))

; "1007, 1": "A plant dies and withers."
(defword wither
  ((assign *part-of-speech* 'verb
           *cd-form* '(*pbuild* (actor ?pb-var1)
                                (object ?pb-var2)
                                (prev ?pb-var3)
                                (after ?pb-var4))
           pb-var1 *subject*
           pb-var2 *subject*
           pb-var3 2
           pb-var4 1)))


; "Wire is wrapped around a piece of metal." = nil wrapped wire around a piece of metal
(defword wrap
  ((assign *part-of-speech* 'verb
           *cd-form* '(*join* (actor ?j-var1)
                      (object ?j-var2)
                      (to ?j-var3)
                      (from ?j-var4)
                      (prev ?j-var5) 
                      (after ?j-var6))
           j-var1 *subject*
           j-var2 nil
           j-var3 nil
           j-var4 nil
           j-var5 0
           j-var6 1)
  (next-packet
    ((test (equal *word* 'around))
     (next-packet
      ((test (equal *part-of-speech* 'noun-phrase))
       (assign j-var3 *cd-form*)))))))
;; write
;; zip

