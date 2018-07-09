---
layout: post
title: "Solving West of Loathing's Soupstock Lode Puzzle"
date:   2017-08-17
---
West of Loathing is a computer role playing game by Asymmetric Publications. It has a mystical American Wild West setting, but more importantly it also has very clever, funny writing. That cleverness of the writing also extends into some of the game's puzzles. For example, there's a math puzzle in West of Loathing that looks like this:

<img src="https://pauljickling.github.io/assets/img/wol.jpg" alt="You see three different-sized bolts on the side of the elevator which are all very loose. There's a sign that says 3200 lbs. pressure required, and some sort of gauge which currently reads 0, whatever that means. [1] Turn the #3 bolt. [2]Turn the #5 bolt. [3] Turn the #7 bolt. [4] Leave it alone for now">

The three bolts you can manipulate add different quantities of weight. The first option (the #3 bolt) adds 411 lbs., the second option (the #5 bolt) adds 295 lbs., and the final option (the #7 bolt) adds 161 lbs. If you add up enough weight that it exceeds 3200 lbs. then it resets to zero, and crucially you cannot undo weights you have added nor can you reset to zero on your own. This is a disincentive to randomly guessing to try and find a solution because working your way through guesses is very tedious. Instead I tabbed out of the game and wrote a quick script to reach the solution.

The first step I take is to figure out what I'm trying to solve. Luckily, that part is straightforward.

(x * 411) + (y * 295) + (z * 161) = 3200

In solving for x, y, and z it is also helpful to have an idea of the possible range of variables. 3200 divided by 161 is approximately 19.8. Therefore we know that the possible answers for x, y, and z are between 0 and 19, with the lower end of the spectrum being more likely. Finally, we can also observe that x and y have to add up to a number divisible by 5. We know that because it is impossible to arrive at the value of 3200 if the #3 and #7 bolts are combined in such a way that the value of the weight ends with a digit like 3. There are other observations that could be made about the problem, but I felt like that was enough information to tackle the problem.

When writing a function that performs a lot of different things, I first like to articulate in plain English what I'm trying to do so I don't get lost in the weeds. This is what I came up with:

1.    Take a sum of x and z that is divisible by 5.
2.    Evaluate all possible permutations of that sum to x and z (5x, 0z), (4x, 1z), (3x, 2z), etc.
3.    For each instance, perform the (x*411) + (y*295) + (z*161) formula in a loop where y is incrementing.
4.    If it is equal to 3200 print the values of x y and z.

When described that way, writing a function doesn't seem too complicated.

1.    You have a parameter that is the sum of x and y.
2.    There is a loop that assigns different values to x and z.
3.    Nested in that loop is an additional loop that increments y.
4.    There is an if condition that executes when the value of the formula is equal to 3200.

With all of that in mind this is what I came up with:

    function solveProblem(xzSum) {
        for (let i=xzSum; i >= 0; i--) {
          let x = i;
          let z = xzSum - i;
          for (let j=0; j < 11; j++) {
            let y = j;
            let formula = (x*411) + (y * 295) + (z * 161);
            if (formula === 3200) {
              console.log("The answer is: " + x, y, z);
            }
          }
        }
      }

    solveProblem(5);
    solveProblem(10);
    solveProblem(15);


Sure enough, if you run this you get this output:

The answer is: 4 2 6

And if you double check that on a calculator, the math checks out. This is a brute force solution to solving the problem, and there are some inefficiencies involved. For example, in the 2nd loop I let it run 11 times with the reasoning that 295*10.8 is approximately equal to 3200. But that means there will be plenty of instances of checking solutions that clearly exceed scope. If this were a more complex problem that involved evaluating a much larger range for its possibility space that would be a problem, and I would think more carefully about what I'm trying to evaluate. But for finding the solution to a puzzle with a relatively small range of numbers to evaluate for a game that I was looking forward to getting back to, this was an approach that I was happy to live with!
