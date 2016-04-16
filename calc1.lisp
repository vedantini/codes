(defvar A ) 
(defvar B ) 
(defvar C ) 
(defvar D)


(defun :bits (value &optional (size 64))
  (format t "~v,'~B" size value))

(write-line "Welcome To Calculator") 


(write-line "Enter A: ") 
(setq A (read)) 
(:bits A)


(terpri)
(write-line "Enter B: ") 
(setq B (read)) 
(:bits B)

(terpri)

 
(write-line "1.Addition") 
(write-line "2.Substraction") 
(write-line "3.Multiplication") 
(write-line "4.Division") 

 
(sb-thread:make-thread (lambda () (progn (sleep 0)
(setq C (+ A B)) 
(write-line "Addition Of Two Numbers: ") 
(:bits C))))



(sb-thread:make-thread (lambda () (progn (sleep 2)
(setq c (- A B)) 
(write-line "substraction Of Two Numbers: ") 
(:bits C))))

	 
(sb-thread:make-thread (lambda () (progn (sleep 4)
(setq c (* A B)) 
(write-line "MULTIPLICATION Of Two Numbers: ") 
(:bits C))))

(sb-thread:make-thread (lambda () (progn (sleep 6)
(setq c (/ A B)) 
(write-line "DIVISION Of Two Numbers: ") 
(:bits C))))
 
(terpri)
(sb-thread:make-thread (lambda () (progn (sleep 8)
(write-line "Do you want to continue?Y-2/N-1")
(setq D (read))
(if (= D 1)
(exit)))))


