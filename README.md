# Theory Of Algorithms
### Module Project

#### Finding all possible solutions to a game of Countdown

From the project specification:
```
In the Countdown Numbers game contestants are given six random numbers
and a target number. The target number is a randomly generated three digit
integer between 101 and 999 inclusive. The six random numbers are selected
from the following list of numbers:

[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100]

Contestants must use the four basic operations – add, subtract, multiply
and divide – with the six random numbers to calculate the target number
(if possible). They don’t have to use all six of the numbers, however each of
the six random numbers can only be used once. If the same number appears
twice in the list of six then it may be used twice. At each intermediate
step of the calculation, negative numbers and fractions are not allowed. For
instance, you can’t subtract a 7 from a 2, as that would give -5, and likewise
you can’t divide 2 by 7 as that gives a fraction.

As an example, suppose the target number is 424 and the six random
numbers are [100, 25, 10, 2, 2, 1].

 Then the following calculation works: (100×(2+2))+25−1. 
 
The steps in this calculation are broken down into individual
operations as follows. First add 2 and 2, to give 4. Then multiply this by
100, to give 400. Then add 25 to give 425. Finally subtract 1 to give 424.
```

The script itself should find every possible solution, while filtering out any invalid ones. Solutions are considered invalid if at any step in its evaulation, a non natural number is found (anything negative or not whole).

## Running the script

To run the script, call (solvecount target-number list-of-numbers)
```scheme
  (solvecount 424 (list 100 25 10 2 2 1))
```
The basic algorithm of the script is as follows:

- Generate the cartesian product of the operators in groups of size 2,3,4,5.
  - (( + ) ( - ) ( * ) ( / )), ( ( + + ) ( - + ))..., ( ( + + + ) ( - + + ) )... 
- Generate all combinations of all permuations of the 6 numbers
  - Filter out all combinations with a length of 1
- Map the following to each combination of permutations:
  - For each list of operations of length n
    - For each template of valid Reverse Polish Notations using the numbers and operators 
      - Evaluate the result of using the template to build an equation
      At each step of the evaluation:
        - If the result of the evaluation step is not a natural number, return false, else continue.  
        - If the final evaluation is equal to the target number return the list eg: ( 5 10 + 100 * )
- Format the list of solutions and return them



### There are a few run time complexities to consider

#### When given eleven elements, there are 11! or 39,916,800 total possible permutations
The script itself uses a brute force approach to finding all of the solutions to the problem. It must find every possible equation that can be made using the six numbers and 5 operators given. To make things easier, it generates every valid permutation of the numbers and operators. This is done by using templates of valid orderings (eg (# # O # O # O # # O O)), the template determines which stack (numbers and operators) it grabs its next element from. Then, by using [Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation)(RPN), or Postfix notation, they can be evaluated.

There is a very important requirement that drastically lessens the number of permutations. At a minimum, there must be two numbers and an operator in order to...  well, do math. Short of any theoretical insanity, at least. Which means the script only needs to generate permutations of eight elements. That brings the total number of permutations down to 40,320. Which is a pretty significant difference, obviously. Without this, the space complexity quickly gets out of hand.


