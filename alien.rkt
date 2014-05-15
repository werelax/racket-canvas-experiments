#lang racket

(require racket/gui/base)

;; just some experimentation before coding the actual thing

(define (make-frame)
  (new frame%
       [label "Testing"]
       [width 800]
       [height 600]))


(define my-canvas%
  (class canvas%
    (define/override (on-event event)
      null)
    (define/override (on-char event)
      null)
    (super-new)))

(define (make-canvas frame)
  (new my-canvas% [parent frame]))

(define (show-window)
  (define cust (make-custodian))
  (parameterize ([current-custodian cust])
    (thread (lambda ()
              (let* ([frame (make-frame)]
                     [canvas (make-canvas frame)]
                     [dc (send canvas get-dc)])
                (send frame show #t))))))

(show-window)
