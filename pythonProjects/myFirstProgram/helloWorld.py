print("hello world")

intVal = 50
floatVal = 3.5
boolVal = True
print("boolVal = ", boolVal)
boolVal = False
print("intVal = ", intVal)
print("floatVal = ", floatVal)
print("boolVal = ", boolVal)

# comment
"""
multi-line comment
"""

addition = 4 + 5
subtraction = 5 - 2
division = 7 / 2
multiplication = 3 * 8 # 24
exponentiation = 3**3 # 81 weird.. I' m used to ^
floorDiv = 16 // 3 # 5
modulo = 16 % 3 # = 1
addAssignment = 3
addAssignment += 5 # 8

subAssign = 10
subAssign -= 5 # 5

multAssign = 10
multAssign *= 5 # 50

divAssign = 10
divAssign /= 5 # 2

expAssign = 10
expAssign **= 5 # 100000

floorAssign = 12
floorAssign //= 5 # 2

modAssign = 10
modAssign %= 5 # 0

# order of operations
original = (9-7)*2**3+10%6//-1*2-1
step1 = 2*2**3+10%6//-1*2-1
step2 = 2*8+10%6//-1*2-1 # tricky since * % and // all have the  same level.  You get 2*8 then 10%6 = 4.  Then 4//-1 = -4.  Then -4 * 2 = -8.
step3 = 16+-8-1
step4 = 7



#### strinsg and escape sequences

# strings can be quoted with either ' or "
str1 = "!@#$%^&*()_+/.,?><:;'~`|][}{"
print(str1)
str2 = '!@#$%^&*()_+/.,?><:;"~`|][}{'
print(str2)

str3 = "This string \"escapes\" double quotes."
print(str3)
str4 = 'This string \'escapes\' single quotes.'
print(str4)

# access strings by index...
str5 = 'example'
ex1 = str5[0] # 'e'

ex2 = "tape"[2] # 'p'

# slicing strings
example = 'apples'
ex1 = example[:3] # 'app' note that it does not INCLUDE 3, it stops just before it
ex2 = example[2:5] # 'ple'
ex3 = example[3:] # 'les'

ex4 = 'apples'[2:5] # 'ple'
ex5 = 'apples'[1:3] # 'pp'

print(ex1, ' ', ex2, ' ', ex3, ' ', ex4, ' ', ex5)


#  string methods
string = 'Yoda'
length = len(string)
print('length = ', length)

num = 9
string = str(num) # note: don't NAME any variable 'str' or else it'll overload this str() function!
print('string-to-num conversion: ', string)

str1 = 'LOWER'
print('lowercase: ', str1.lower())

str2 = 'upper'
print('uppercase: ', str2.upper())


# print() stuff

#concatenation
print('stuff1' + 'stuff2')
mystr = 'mystring'
print(mystr + 'is being concatenated')

# %s Format Operator
city = 'Seattle'
state = 'Washington'
print('The Seahawks are from %s, %s.' % (city, state))

# user input
#occupation = input('What is your occupation?')
#city = input('In what city do you live?')
#age = input('How old are you? (years)')
#print('So you are a %s, you live in %s, and you are %s years old.' % (occupation, city, age))

# Flow Control

ex1 = 3 > 1 # True
ex2 = 5 >= 5 # True

ex3 = 3 < 3 # False
ex4 = 7 <= 6 # False

ex5 = 1 == 7 # False
ex6 = 8 != 8 # False

# Boolean operators ('and')
ex1 = True and True # True
ex2 = True and False # False

ex3 = True or False # True
ex4 = False or False # False

ex5 = not True # False

# order of operations: and before or
ex6 = not False and not True or False
step1 = True and False or False
step2 = False or False
result = False

# if-else

if 5!=6:
    print('5 does not equal 6') # this needs to be indented 4 spaces (or some multiple of 4 spaces) for this to run without error

if 1==2:
    print('1 equals 2.')
else:
    print('1 does not equal 2.')


if 1 == 2:
    print("Don't print this.")
elif 1 != 2:
    print('Print this.')
elif 1 < 2:
    print("This is true, but won't be reached.")
else:
    print("Don't print this either.")


# Functions

# Function Definition (like variables, function names cannot start with a number or any special character other than _underscore
def ex():
    print('Hello world.')

# Function Call
ex()

def _withParameters(a):
    print(a)

_withParameters(9)

def mult(a, b, c):
    d = a * b
    print(d + c)

mult(2, 3, 4) # 2 * 3 = 6 + 4 = 10


# functions inside functions
def giver(a, b):
    c = a + b
    return c

def taker(d, e):
    output = giver(d, e)
    return output

print(taker(1,5)) # 1 + 5 = 6

# importing modules

import random

print(random.randint(1,10))




