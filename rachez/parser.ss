;;;;library for Simple Parser Combinator

(library (rachez parser)
         (export satisfy/p equal/p parser digit/p alpha/p parse-string
                 eof/p)
         (import (chezscheme))

         (define (satisfy/p procedure)
           (lambda (l)
             (cond
               [(null? l) 'parse-fail]
               [(procedure (car l)) (list 'parse-success (car l)
                                          (cdr l))]
               [else 'parse-fail])))

         (define (equal/p v) (satisfy/p (lambda (x) (equal? x v))))
         (define digit/p (satisfy/p (lambda (x) (char<? #\0 x #\9))))
         (define alpha/p (satisfy/p (lambda (x) (char-alphabetic? x))))
         
         (define (eof/p l) (if (null? l) (list 'parse-success #f '())
                               'parse-fail))

         (define-syntax parser
           (syntax-rules ()
             [(_  return-value)  (lambda (l)
                                   (list 'parse-success return-value))]
             [(_ [var val] rest ...)
              (lambda (l)
                (let ([res (val l)])
                  (cond [(eq? 'parse-fail res) 'parse-fail]
                        [(eq? 'parse-success (car res))
                         (let ([var (cadr res)])
                           ((parser rest ...) (caddr res)))]))
                )]))

         (define (parse-string p str)
           (define res (p (string->list str)))
           (cond [(eq? res 'parse-fail) (error 'parser "parse failed")]
                 [(eq? (car res) 'parse-success)
                  (cadr res)]))

         
           
         )