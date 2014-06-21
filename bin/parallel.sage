#!/usr/bin/env sage -python

import sys
import re
from sage.all import *

def first_nonzero(a):
		"""takes a list of integers, and finds the index of the first
		nonzero entry, or returns -1 if no such entry exists"""
		i = 0
		while ((a[i] == 0) and (i < len(a))):
				i += 1
		if i < len(a):
				answer = i
		else:
				answer = -1

		return answer

def is_multiple(a, b, r):
		"""takes two lists of rational numbers and decides if a = rb
		will assume they have the same length!!"""

		answer_sofar = True
		i = 0
		while (answer_sofar and i < len(a)):
				if (a[i] != r*b[i]):
						answer_sofar = False
				i += 1
		return answer_sofar

def parallel(a, b):
		"""takes two lists of rational numbers, and decides if they are
		parallel"""
		
		if len(a) != len(b):
				answer = False
		elif (len(a) == 0) or (len(a) == 1):
				answer = True
		else:
				first_index_a = first_nonzero(a)
				first_index_b = first_nonzero(b)
				if first_index_a != first_index_b:
						answer = False
				else:
						ratio = a[first_index_a]/b[first_index_b]
						answer = is_multiple(a, b, ratio)

		return answer

def string_to_rationals(s):
		"""takes a string, and makes it into a list of rational numbers
		using spaces to separate items on list"""

		output = []
		for e in s.split():
				output.append(Rational(e))
		return output

def parallel_in_file(v,filename):
		"""searches through the file and sees if the vector v of rational
		numbers is parallel to any vector in the file. the assumption is
		that the file has been generated as the rays of a cone from lrs.
		therefore we look for a "begin" line, followed by a "****" line,
		followed by the actual rays, and ending with an "end" line!"""

		f = open(filename, 'r')

		# first, find the "begin" line:
		line = f.readline()
		while (not line.startswith("begin")):
				line = f.readline()
		# line is now equal to begin....so read the next one instead
		line = f.readline()
		# now, this should be a junk line with some ***'s. if it is, throw
		# it out and continue!
		if line.startswith("*"):
				line = f.readline()

		# now we should be at the beginning of the datafile proper. we
		# check:

		done = False
		answer = False
		while ((not done) and (not line.startswith("end"))):
				rline = string_to_rationals(line)
				if (parallel(rline, v)):
						done = True
						answer = True
				else:
						line = f.readline()
		return answer

if len(sys.argv) != 3:
		print "Usage: %s \"v1 v2 ... vn\" <filename>"%sys.argv[0]
		print "checks to see if the rational vector described by the v's is parallel to any in the lrs formatted file given"
		sys.exit(1)

v = string_to_rationals(sys.argv[1])
filename = sys.argv[2]

answer = parallel_in_file(v, filename)
if answer:
		print "found it!"
else:
		print "it's not in there..."

