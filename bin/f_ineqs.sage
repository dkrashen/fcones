#!/usr/bin/env sage -python

import sys
from sage.all import *

def fcurves(n):
		"""generate all partitions of n into 4 nonempty subsets.  each
		parition corresponds to the F-curve a spine with 4 moving points,
		and with the subsets of marked points attached to the corresponding
		moving point on the spine"""
	
		return SetPartitions(n, 4).list()

def smallest_non_member(s, n):
		"""find the smallest number not in a subset s of {1..n}. returns 0 if
		no answer!"""
		if s.cardinality == n:
				answer = 0
		else:
				i = 1
				while (i in s):
						i += 1
				answer = i
		return answer

def next_member(s, n, m):
		"""finds the next member of a subset s of {1..n} which is larger
		than m. returns 0 is no member is larger than m"""
		if m >= n:
				answer = 0
		elif m+1 in s:
				answer = m+1
		else:
				answer = next_member(s, n, m+1)

		return answer


def is_legal_nonadjacent(s, n):
		"""here, s is a subset of {1..n}, and we give false if either s has
		fewer than 2 elements, more than n-2 elements, or if all
		the elements are adjacent"""

		c = s.cardinality()

		if (((c < 2) or (c > (n - 2)))):
				answer = False
		else:
				snm = smallest_non_member(s, n)
				nm = next_member(s, n, snm)
				if nm == 0:
						answer = False
				else:
						l = c + nm - snm
						if (l == n):
								# this is the condition for adjacency!
								answer = False
						else:
								answer = True

		return answer

	

def nonadjacent(n):
		"""generates subsets containing the element 1 of {1,..., n} such
		that not all are adjacent. each subset S corresponds to the
		boundary divisor delta_S"""
	
		preallsubs = Subsets(range(2,n+1))
		allsubs = []
		for s in preallsubs:
				allsubs.append(Set(union(s, Set([1]))))

		answer = []
		for s in allsubs:
				if is_legal_nonadjacent(s,n):
						answer.append(s)

		return answer

def flip_for_1(s, n):
		"""takes a subset of {1..n} and returns either itself or
		complement, whichever contains the element 1"""

		if 1 in s:
				answer = s
		else:
				answer = Set(range(1,n+1)).difference(s)
		return answer

def flip_collection_for_1(p, n):
		"""same as flip_for_1, but does it for each member of p, a list of
		sets"""

		answer = []
		for s in p:
				answer.append(flip_for_1(s, n))
		return answer

def fcurve_inequality(b, c, n):
		"""this function takes a basis of boundary divisors b, represented as
		a list of boundary divisors, where each boundary divisor is given
		as a subset s of {1..n} containing 1, and an c curve, represented
		as a partition of n into exactly 4 nonempty parts, and describes
		the inequality which states that the intersection is nonnegative.
		this is given as a list of pairs, each pair having a coefficient
		and a basis element. this corresponds to an linear combination
		which must be nonnegative."""
		
		# these are the subsets indexing boundary divisors which occur with
		# a coefficient of -1. the main point is that if 1 is not included,
		# we need to put it in
		f_neg_coeffs = flip_collection_for_1(c, n)
		
		# pre-flipped positive subsets. these are unions of subsets (1, 2),
		# (1, 3), (1, 4)
		f_pre_pos_coeffs = []
		f_pre_pos_coeffs.append(c[0].union(c[1]))
		f_pre_pos_coeffs.append(c[0].union(c[2]))
		f_pre_pos_coeffs.append(c[0].union(c[3]))

		f_pos_coeffs = flip_collection_for_1(f_pre_pos_coeffs, n)

		# finally, we go through each element of b, get the coefficient,
		# and append it to the list of coefficients!
		
		inequality = []
		for d in b:
				if (d in f_neg_coeffs):
						inequality.append([-1, d])
				elif (d in f_pos_coeffs):
						inequality.append([1, d])
				else:
						inequality.append([0, d])

		return inequality

def all_ineqs(n):
		b = nonadjacent(n)
		f = fcurves(n)
		ineqs = []
		for c in f:
				ineqs.append(fcurve_inequality(b, c, n))
		return ineqs

def display_lrs_ineqs(n):
		b = nonadjacent(n)
		f = fcurves(n)
		ineqs = []
		for c in f:
				ineqs.append(fcurve_inequality(b, c, n))

		print "F-cone for n =",
		print n

		sys.stdout.write("*basis is ordered as: ")
		for d in b:
				print d,
		print
		print "begin"
		print len(ineqs),
		print len(b),
		print "rational"

		for ineq in ineqs:
				for coeff in ineq:
						print coeff[0],
				print

		print "end"



def tester(n):
		b = nonadjacent(n)
		print "nonadjacent basis is: "
		print b
		f = fcurves(n)
		print "f curves are: "
		print f
		for c in f:
				print "For the F-curve"
				print c
				print "the inequality looks like: "
				i = fcurve_inequality(b, c, n)
				print i


if len(sys.argv) != 2:
		print "Usage: %s <n>"%sys.argv[0]
		print "outputs the inequalities for the F-cone of ",
		print '$\overline{M}_{0,n}$ in lrs format'
		sys.exit(1)

display_lrs_ineqs(int(sys.argv[1]))
