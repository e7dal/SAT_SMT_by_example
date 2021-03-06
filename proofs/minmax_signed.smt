; tested with MK85 and Z3

; signed version
(set-logic QF_BV)
(set-info :smt-lib-version 2.0)

(declare-fun x () (_ BitVec 32))
(declare-fun y () (_ BitVec 32))

(declare-fun min1 () (_ BitVec 32))
(declare-fun max1 () (_ BitVec 32))

; this is our min/max functions, "reference" ones:
(assert (= min1 (ite (bvsle x y) x y)))
(assert (= max1 (ite (bvsge x y) x y)))

(declare-fun min2 () (_ BitVec 32))
(declare-fun max2 () (_ BitVec 32))

; functions we will "compare" against:

; y ^ ((x ^ y) & -(x < y)); // min(x, y)
(assert (= min2
	(bvxor
		y
		(bvand
			(bvxor x y)
			(bvneg (ite (bvslt x y) #x00000001 #x00000000))
		)
	)
))

; x ^ ((x ^ y) & -(x < y)); // max(x, y)
(assert (= max2
	(bvxor
		x
		(bvand
			(bvxor x y)
			(bvneg (ite (bvslt x y) #x00000001 #x00000000))
		)
	)
))

; find any set of variables for which min1!=min2 or max1!=max2
(assert (or
	(not (= min1 min2))
	(not (= max1 max2))
))

; must be unsat (no counterexample)
(check-sat)


