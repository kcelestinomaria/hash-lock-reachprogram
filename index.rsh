'reach 0.1';
/*Hash Lock Contract Problem Analysis
Who is involved in this application?
What information do they know at the start of the program?
What information are they going to discover and use in the program?
What funds change ownership during the application and how?
*/

/*Hash Lock Contract Problem Analysis Answers
Alice sends the funds
Bob receives those funds
Alice starts off knowing the amount she wants to send and the secret password
Bob starts off like Jon Snow and knows nothing
Alice doesn't learn anything during the execution of the program, but Bob
learns the password
Alice transfers funds at the beginning of the program and Bob receives those
funds at the end, after he learns the password
*/

/* 
Programs encode automatic solutions to problems
we've already solved
*/

/*
After problem analysis, we know what info
our program will deal with, but next
we need to decide how to translate that info
into concrete data

So:
What data type will represent the amount Alice transfers?
What data type will represent Alice's password?
*/

/*
After deciding on the types
we should think about how the program will be
provided these values. In other words:
What participant interact interface will each participant use?
*/

/*
Whenever a participant starts off knowing something, then
it is a field in the interact object. If they learn something,
then it will be an argument to a function. If they provide
something later, then it will be the result of a function
*/

/*
We're going to represent the amount Alice transfers as an unsigned integer(UInt)
named amt
We will represent the password as another unsigned integger(UInt) named pass
These two above values are the only fields of Alice's interface, but Bob
will have a function named getPass that will return the password
that he knows
*/

/*COMMUNICATION PATTERN
Alice publishes a digest of the password and pays the amount
Bob publishes the password
The consensus ensures it's the right password and pays Bob
*/

export const main = Reach.App(() => {
  const A = Participant('Alice', {
    // Specify Alice's interact interface here
  });
  const B = Participant('Bob', {
    // Specify Bob's interact interface here
  });
  deploy();
  // write your program here
});

// ALice publishes a digest of the password and pays the amount
Alice.publish(passDigest, amt)
     .pay(amt)
commit();

// Bob publishes the password
Bob.publish(pass);

// The consensus ensures it's the right password and pays Bob
transfer(amt).to(Bob);
commit();

/* Assertion Insertion
Encoding what is true about the various values in the program
*/

//First,
// We assert that Bob can't know Alice's password, based on what
// the Reach program does
unknowable(Bob, Alice(_pass));

/* Second, 
we assert that Bob believes his password is correct ( and that an honest
Bob will check it */
Bob.only(() => {
 // Second
 assume( passDigest == digest(pass) ); });
Bob.publish(pass);

 // Third,
/* Finally, we assert that the consensus can only continue
if this is the case */
 require( passDigest == digest(pass) );
 transfer(amt).to(Bob);
 commit();
