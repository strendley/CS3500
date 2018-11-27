;Programmer: Skylar Trendley
;Project: HW6 Lisp Assignment
;Professor: Leopold

(defun isPrime (num &optional (iterator 2))
  (if (= iterator (+ (isqrt num) 1))
    t
    (if (= 0 (mod num iterator))
        nil
        (isPrime num (+ iterator 1))
    )
  )  
)

(defun numToList (num &optional end)
  (if (= num 0) ;if the number is 0
    (or end '(0)) ;or the end is 0
    (multiple-value-bind (val rem) ;bind the digit to a list
            (floor num 10) ;go to the next digit
      (numToList val (cons rem end)) ;recurse back to next digit in number
    )
  )
)

(defun rotate (listNums numRotations)
  (append (nthcdr numRotations listNums) ;copy the list's elements according to numRotations
    (butlast listNums (- (length listNums) numRotations)) ;append those elements to the back of the list
  )
)

(defun listToNum (listNums)
  (when listNums ;if it is a list
   (concatenate 'string ;concatenate the digits into a string
          (write-to-string (car listNums)) (listToNum (cdr listNums))
      )
    )
  )
)

(defun rotateNum (num)
  (setq a(numToList num)) ;turn the number into a list
  (setq b(rotate a 1)) ;rotate the number once
  (setq rotatedNum(parse-integer(listToNum b)))
  rotatedNum
)

(defun isSpecialNum (num)
  (if (allRotations num (countDigits num))
    t
    nil
  ) 
)

(defun allRotations (num numDigits)
  (setq numList(numToList num))
      (if (member 0 numList)
        nil
        (if (= numDigits 0)
           t
          (if (isPrime (setq newNum (parse-integer (listToNum numList))))
            (allRotations (rotateNum newNum) (- numDigits 1))
            nil
          )
        )
      )
)

(defun countDigits (specialNum) 
  (setq s (write-to-string specialNum)) ;turn the number into a string
  (length s) ;find the length of the string
)

(defvar counter 0) ;global variable for counting "special numbers"

(defun CountSpecialPrimes (specialNum)
  (if (> specialNum 1) ;if greater than 1, test the number
    (progn
      (if (isSpecialNum specialNum) ;call the testing function
        (setq counter(+ counter 1)) ;if it passes the test, increment the special number count
      )
      (CountSpecialPrimes (- specialNum 1)) ;recursive call to test all numbers <= initial number
    );end prog 
    ;else
    (progn
      (setq countvar counter) ;temporary var for counter
      (setq counter 0) ;reset counter for the next number
      countvar ;return the number of special numbers
    )
  ) ;end if
) ;end function