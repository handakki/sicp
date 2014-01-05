; 3.9
; ========================================================================
;; Recursive solution:
;;                         +-------------------+
;;  global env ----------->|factorial          |
;;                         |  +                |<---------------+
;;                         |  |                |<----+          |
;;                         +--|----------------+     |          |
;;                            |     ^                |          |
;;                            |     |           +----+-----+    |
;;                            |     |  E1+----->|n: 6      |    |
;;                   +--------+     |           |          |    |
;;                   |              |           |          |    |
;;                   |              |           +----------+    |
;;                   v              |                           +
;;             +------------+       |                      +----------+
;;             |params: n   |+------+           E2+------->|n: 5      |
;;             |body. . .   |                              |          |
;;             |            |                              |          |
;;             +------------+                              +----------+ ...

;; Iterative solution:
;;                       +------------------------------------+
;;  global env +-------->|factorial            fact-iter      |<--------------------------+
;;                       | + ^                  +    ^        |<---------------+          |
;;                       | | |                  |    |        |<+              |          |
;;                       +-|-|------------------|----|--------+ |              |          |
;;                         | |                  |    |          |              |          |
;;                         | |                  |    |          |              |          |
;;       +-----------------+ |       +----------+    |          |              |          |
;;       |                   |       |               |          |              |          |
;;       v                   |       v               |          +              +          |
;;  +-----------+            |   +----------------+  |       +--------+      +----------+ |
;;  |params: n  |+-----------+   |params: product |+-+  E1+->|n: 6    | E2+->|product: 1| |
;;  |body. . .  |                |counter, max    |          |        |      |counter: 1| |
;;  |           |                |body. . .       |          |        |      |max: 6    | |
;;  |           |                |                |          +--------+      +----------+ |
;;  +-----------+                +----------------+                                       +
;;                                                                               +----------+
;;                                                                          E3+->|product: 1|
;;                                                                               |counter: 2|
;;                                                                               |max: 6    |
;;                                                                               +----------+ ...

; 3.10
; ========================================================================
;; (define W1 (make-withdrawal 100))
;;
;;                 +-------------------------+     +--+    params: initial-amount
;; global-env+---->|         make-withdrawal+----->| +---->body:
;;                 |                         |     |--|     ((lambda (balance)
;;        +--------+W1                       |<-----+ |       (lambda (amount)
;;        |        +-------------------------+     +--+         ...
;;        |                     ^                             ) initial-amount)
;;        |            +--------+----------+
;;        v     E1+--->|initial-amount: 100|
;;      +--+           +-------------------+
;;   +---+ |                     ^
;;   |  |--|             +-------+----+
;;   |  | +----+  E2+--->|balance: 100|
;;   |  +--+   |         +------------+
;;   |         |               ^
;;   |         +---------------+
;;   v
;; params: amount
;; body:
;;   (if (>= balance amount)
;;     ...


;; (W1 50)
;;
;;                 +-------------------------+     +--+    params: initial-amount
;; global-env+---->|         make-withdrawal+----->| +---->body:
;;                 |                         |     |--|     ((lambda (balance)
;;        +--------+W1                       |<-----+ |       (lambda (amount)
;;        |        +-------------------------+     +--+         ...
;;        |                     ^                             ) initial-amount)
;;        |            +--------+----------+
;;        v     E1+--->|initial-amount: 100|
;;      +--+           +-------------------+
;;   +---+ |                     ^           +--------------+
;;   |  |--|             +-------+----+      |          +---+------+
;;   |  | +----+  E2+--->|balance: 100|<-----+   E3+--->|amount: 50|
;;   |  +--+   |         +------------+                 +----------+
;;   |         |               ^                    (if (>= balance amount)
;;   |         +---------------+                      (begin (set! balance (- balance amount))
;;   v                                                  ...
;; params: amount
;; body:
;;   (if (>= balance amount)
;;     ...
;;
;; Then:
;;
;;                 +-------------------------+     +--+    params: initial-amount
;; global-env+---->|         make-withdrawal+----->| +---->body:
;;                 |                         |     |--|     ((lambda (balance)
;;        +--------+W1                       |<-----+ |       (lambda (amount)
;;        |        +-------------------------+     +--+         ...
;;        |                     ^                             ) initial-amount)
;;        |            +--------+----------+
;;        v     E1+--->|initial-amount: 100|
;;      +--+           +-------------------+
;;   +---+ |                     ^
;;   |  |--|             +-------+----+
;;   |  | +----+  E2+--->|balance: 100|
;;   |  +--+   |         +------------+
;;   |         |               ^
;;   |         +---------------+
;;   v
;; params: amount
;; body:
;;   (if (>= balance amount)
;;     ...


;; (define W2 (make-withdrawal 100))
;;
;;                 +-------------------------+     +--+    params: initial-amount
;; global-env+---->|         make-withdrawal+----->| +---->body:
;;                 |                         |     |--|     ((lambda (balance)
;;        +--------+W1                     W2|<-----+ |       (lambda (amount)
;;        |        +------------------------++     +--+         ...
;;        |                     ^           |^                ) initial-amount)
;;        |            +--------+----------+|+--------------------------+
;;        v     E1+--->|initial-amount: 100|+-------+              +----+--------------+
;;      +--+           +-------------------+        |       E3+--->|initial-amount: 100|
;;   +---+ |                     ^                  |              +-------------------+
;;   |  |--|             +-------+----+             |                       ^
;;   |  | +----+  E2+--->|balance: 100|             v                +------+-----+
;;   |  +--+   |         +------------+            +--+       E4+--->|balance: 100|
;;   |         |               ^         +----------+ |              +------------+
;;   |         +---------------+         |         |--|                   ^
;;   v                                   |         | +--------------------+
;; params: amount <----------------------+         +--+
;; body:
;;   (if (>= balance amount)
;;     ...

;; The resultant environment differs from the non-let version of (make-withdraw)
;; in that the double-lambdas cause the resultant code objects to carry
;; around references to an environment containing "initial-amount".
