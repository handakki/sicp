; 4.45
; ========================================================================
(define (require p) (if (not p) (amb)))
(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))

(define *unparsed* '())

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence
         (parse-noun-phrase)
         (parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend (list 'verb-phrase
                             verb-phrase
                             (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend (list 'noun-phrase
                             noun-phrase
                             (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))
;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
(parse '(the professor lectures to the student in the class with the cat))

;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:

;;; Starting a new problem
;;; Amb-Eval value:
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase
  (verb-phrase
   (verb-phrase (verb lectures)
		(prep-phrase (prep to)
			     (simple-noun-phrase (article the) (noun student))))
   (prep-phrase (prep in)
		(simple-noun-phrase (article the) (noun class))))
  (prep-phrase (prep with)
	       (simple-noun-phrase (article the) (noun cat)))))

;; This version means the professor is lecturing to the student and the professor has a cat.

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase
  (verb-phrase (verb lectures) (prep-phrase (prep to)
					    (simple-noun-phrase (article the) (noun student))))
  (prep-phrase (prep in)
	       (noun-phrase
		(simple-noun-phrase (article the) (noun class))
		(prep-phrase (prep with)
			     (simple-noun-phrase (article the) (noun cat)))))))

;; The professor is giving a lecture to the student and the student is in the class that has the cat.

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase (verb-phrase (verb lectures)
			   (prep-phrase (prep to)
					(noun-phrase
					 (simple-noun-phrase (article the) (noun student))
					 (prep-phrase (prep in)
						      (simple-noun-phrase (article the) (noun class))))))
	      (prep-phrase (prep with)
			   (simple-noun-phrase (article the) (noun cat)))))

;; The professor lectures to the student in the class, and the professor is lecturing with the cat.

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase (verb lectures)
	      (prep-phrase (prep to)
			   (noun-phrase
			    (noun-phrase (simple-noun-phrase (article the) (noun student))
					 (prep-phrase (prep in)
						      (simple-noun-phrase (article the) (noun class))))
			    (prep-phrase (prep with)
					 (simple-noun-phrase (article the) (noun cat)))))))

;; the professor lectures to the student who is in the class and the student has a cat.

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase (verb lectures)
	      (prep-phrase (prep to)
			   (noun-phrase (simple-noun-phrase (article the) (noun student))
					(prep-phrase (prep in)
						     (noun-phrase
						      (simple-noun-phrase (article the) (noun class))
						      (prep-phrase (prep with)
								   (simple-noun-phrase (article the) (noun cat)))))))))

;; The professor lectures to the student in the classroom and the classroom has a cat.

;;; Amb-Eval input:
try-again

;;; There are no more values of
(parse (quote (the professor lectures to the student in the class with the cat)))

; 4.46
; ========================================================================
;; All of our parsing methods are written assuming left-to-right!
;; If we parsed right-to-left our noun phrases would go noun -> article, or
;; 'cat the'.

; 4.47
; ========================================================================
(define (parse-verb-phrase)
  (amb (parse-word verbs)
       (list 'verb-phrase
             (parse-verb-phrase)
             (parse-prepositional-phrase))))

;; This works so long as (parse-word) succeeds - as soon as it doesn't,
;; we get an infinite loop.  If we change the order of the arguments,
;; we immediately get an infinite loop.  It is because we are calling
;; parse-verb-phrase without a base case to terminate recursion!

;;; Amb-Eval input:
(define (parse-verb-phrase)
  (amb (list 'verb-phrase
	     (parse-verb-phrase)
	     (parse-prepositional-phrase))
       (parse-word verbs)))


;;; Starting a new problem
;;; Amb-Eval value:
ok

;;; Amb-Eval input:
(parse '(the professor lectures to the student in the class with the cat))

;;; Starting a new problem
;; (this goes on forever and doesn't terminate).

; 4.48
; ========================================================================
(define adjectives '(adjective sleepy cranky stoned))

(define (parse-adjective-phrase)
  (list 'adjective-phrase
	(parse-word articles)
	(parse-word adjectives)
	(parse-word nouns)))

(define (parse-simple-noun-phrase)
  (amb
   (list 'simple-noun-phrase
	 (parse-word articles)
	 (parse-word adjectives)
	 (parse-word nouns))
   (list 'simple-noun-phrase
	 (parse-word articles)
	 (parse-word nouns))))

(parse '(the cranky professor lectures to the stoned student in the class with the sleepy cat))

;;; Starting a new problem
;;; Amb-Eval value:
;; (sentence
;;  (simple-noun-phrase (article the) (adjective cranky) (noun professor))
;;  (verb-phrase
;;   (verb-phrase
;;    (verb-phrase (verb lectures)
;; 		(prep-phrase (prep to)
;; 			     (simple-noun-phrase (article the) (adjective stoned) (noun student))))
;;    (prep-phrase (prep in)
;; 		(simple-noun-phrase (article the) (noun class))))
;;   (prep-phrase (prep with)
;; 	       (simple-noun-phrase (article the) (adjective sleepy) (noun cat)))))

; 4.49
; ========================================================================
(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (set! *unparsed* (cdr *unparsed*))
  (list (car word-list) (an-element-of (cdr word-list))))


;;; Amb-Eval input:
(parse '(the professor lectures to the student))

;;; Starting a new problem
;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun professor)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun class)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun student)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun cat)))))

;;; Amb-Eval input:
