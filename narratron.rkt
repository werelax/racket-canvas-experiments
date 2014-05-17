#lang racket

(require racket/gui/base)

;; just some experimentation before coding the actual thing

(define (make-frame)
  (new frame%
       [label "Testing"]
       [width 640]
       [height 480]))

(define my-canvas%
  (class canvas%
    (define/override (on-event event)
      null)
    (define/override (on-char event)
      null)
    (super-new)))

(define (make-canvas frame)
  (new my-canvas% [parent frame] [style '(no-autoclear)]))

(define (init-canvas canvas)
  (define last-stamp (current-milliseconds))
  (define buffer (make-screen-bitmap 320 240))
  (define buffer-dc (send buffer make-dc))
  (define (refresh-canvas)
    (send canvas refresh-now (lambda (dc)
                               (let* ([now (current-milliseconds)]
                                      [delta (quotient 1000 (- now last-stamp))])
                                 (set! last-stamp now)
                                 (send buffer-dc set-brush
                                       (make-color (random 255) (random 255) (random 255))
                                       'solid)
                                 (send buffer-dc draw-rectangle 0 0 320 240)
                                 (send buffer-dc draw-text (number->string delta) 10 10)
                                       ;(/ (send canvas get-width) 320)
                                       ;(/ (send canvas get-height) 240))
                                 (send dc draw-bitmap buffer 0 0)))
          #:flush? #f))
  (thread (lambda ()
            (new timer%
                 [notify-callback refresh-canvas]
                 [interval (quotient 1000 60)]
                 [just-once? #f]))))

(define (show-window)
  (define cust (make-custodian))
  (parameterize ([current-custodian cust])
    (thread (lambda ()
              (let* ([frame (make-frame)]
                     [canvas (make-canvas frame)]
                     [dc (send canvas get-dc)])
                (send dc set-scale 2 2)
                (send dc set-smoothing 'unsmoothed)
                (send frame show #t)
                (init-canvas canvas))))))

(show-window)
