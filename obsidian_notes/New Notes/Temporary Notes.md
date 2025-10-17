### VI Analyzer

Run VI Analyzer tests on NIAF and jettl
This can give an idea for benefits for jettl as compared to NIAF

---

VI Analyzer Test approval

### Rename / Replace

Minimize use of `Write xxxx.vi`
Maximize use of `Read xxxx.vi`

---

`Start.vi`
Input change to `Created Alias`

`Actor.vi`
Input change to `Self Alias`

**Be explicit about all of the places Alias is written.**

Comment:
> The control terminal label signifies how that control terminal is used in the function. NOT how it relates to how the calling code calls that function.

---


Delete all places where Is From Actor shows up.
`Is From Actor` -> `Has Valid Sender.vi`
Input: `Sender.lvclass`
Compares if NOT equal to `Sender.lvclass`
Output: `Has Valid Sender`

Reply.vi
`Has Valid Sender.vi`
Error for “Not a Valid Sender for Reply”

---

Replace most
“Get Error.vi” with “Can Continue.vi”

---

Delete
- Pre Process
- Post Process  

---

Base Actor : Msg Execute
Take away the set error in error case

---

Get RID
Of Insert and Remove private methods, just replace back.

---

Last Ack
Take out
- Destroy
- Set Error
Leave comment in Last Ack about wrapper override

---

Map of Created Attributes -> Created Attributes Map

---



### Best Practice

Not all actors need to be individual. Some Actors are made to couple tightly with other Actors.

Because it is emphasized to not branch the actor objects wire, it is encouraged to create an actor that acts as a helper loop. Note that of course the messaging mechanism between them should still be actor messages, though Last Ack overrides etc. could contain information for the particular actor that was created. i.e. for a popup configuration box, this can be a private actor which returns its class contents which can be unbundled in Last Ack to easily get the configuration parameters.

---

Do not release the Register reference, unless after the loop in Process

---

Always assume you cannot control the order messages execute!

---

Msgs can be sent in `Pre Loop.vi` since register for events before the `Pre Loop.vi` execution

---


### Style Best Practice

Only have top two conn panes are Object in / Object out

---

### Key Features

All Boolean logic is positive logic.

---

### Edits

`Actor.vi`
Delete
- Set Self Attributes
- Set Creator Attributes
Instead wire in the inputs to Process

`Write VI Server.vi` -> `Write Attibutes.vi`

---

### Error

`Create.vi`
Only returns jettl defined Errors.

All errors that can happen in jettl are documented in `jettl.lvlib:Error.lvlib`
Outside of messages methods, the core decorator methods in jettl should only output errors defined in the `jettl.lvlib:Error.lvlib`

---

Error:
Indication that a function could not complete it’s assigned task. This is justification why Destroy is not an error.

[https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk](https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk)

---

NO Error outputs for jettl  
Why?

jettl has build in error propagation where the Error is within the Base Actor private data.
Therefore, all errors within the framework that are generated will immediately be put into the Actor object.
Since each error that can occur in a method is known, an Actor decorator, for example, can override this behavior by clearing errors as necessary. It is the default behavior to put all jettl errors on the error wire to expose the API to the developer, and the developer can decide which errors to ignore for each individual method.

For example, clearing errors that come from the Send methods if an Address is not registered anymore.

---


### Logging Wrapper

Initialization for Actor tdms Logger.
Requires:
- Self Attributes
- Creator Attributes
**Note**
	Created is redundant information, since can construct everything with Self and Creator Attributes

**Cleanup Time** can be wrapper addition for.. logging

After sending message, logs to file the **Send Time**
After receiving message, logs to file the **Receive Time**

**Create Time**
This logging should go into **Create.vi** wrapper actor

### Palette

Advanced Palette (in Actor)
Includes the Actor.vi, Send.vi, etc.

> Should include otherwise advanced functions, outside of normal use in jettl.

> Maybe this isn't *Advanced*, but some other name for otherwise *discouraged in practical use*.

Advanced palettes for EACH of the libraries exposed to the developer, in case they want to use dangerous functionality.

### Enqueue and Dequeue

Comment
Enqueue: Fundamentally will not output an error since the queue is guaranteed to be open.
Dequeue: Fundamentally will not output an error since the queue is guaranteed to be open.

### Transport.lvclass

Transport.lvclass
Event Transport.lvclass


### Boolean prefixes

Is, Can, Has, Should, Was

### Process

**Process.vi**
Register for Events before **Process.vi** override

> No need for comment about releasing event references

> Take out register from Self Attributes

Increase the size

### Wrappers

Inner Actor  
Middle Actors
Outer Actor

---

There is some beatify here in wrapping actors
A blanket statement: You are always separating concerns when designing an actor!
Remember, when wrapping actors, they don’t know about each other, but wrappers can interact with common method calls between layers this includes data defined by messages! In particular.. logging. When a message is received to an actor, one of the layers can be logging which implements a message that logs the same message to file.

---

Best practice:
Decoupling Msgs between layers
sending a message defined in an internal layer but not decorating the base actor with this internal actor means the message may not be implemented in the “Unified Msg Set”.. throwing an error..
This is a coupling issue that makes unit testing actors difficult if there are messages defined on internal layers.

---

For the internal wrapping actors, do not include messages within them? Of course you can, but leads to subtle coupling of actor not being able to execute messages if the outer actor does not implement that functionality.

---

- Core Actor
- Non-Process Actor
- Process Actor
- Non-Process Actor (MHL wouldn’t wrap messages on the outer layer, or it can, but be careful because messages in that layer will not be able to execute)

---


Wrapper can have
Init.vi
Boolean flag for “Destroy on Creator Last Ack”
TRUE set as default

---


### Msg methods

1. Drop messages method
2. Wire to Msg Input
3. Wire in Sender
4. Wire in inputs

---

All Msg methods have DD out since some of the common method calls in jettl have DD out and it is heavily encouraged to wire all outputs of a function, especially the DD out

---

Msg methods have DD out because more often than not, they’re generating errors within

---

### Destroy

Documentation
“Marked For Destroy”
- always starts as FALSE
- only be changed to TRUE in  “Destroy.vi”
- can never be changed to FALSE

---

### Init.vi (Actor)

Init.vi
“Can Continue.vi”
Has a case structure which internally has uninit code or not.

---


### Project Style

Move to Actor Utilities!  
- Msg Execute.vi
- Msg Layer Checker.vi (change name?)

---


### jettl Tools

Tool that allows actor to implement message interface AND auto populates that interfaces message method with Msg Execute.vi, the function, and necessary wiring.

---

### Msg Set

“Msgs” -> “Msg Set”

---

Msg Execute.vi
“Element of Unified Msg Set.vi” (boolean output)
cs
“Msg Recurse Layers.vi”

---

Replace the Msgs Unbundle with the proper accessor method!

---

Msgs -> Msg Set  
Unified Msg Set
Layer Msg Set

---


### Process Refs

Placeholder Application Ref in Process Refs
Wire in default in Process

### jettl Feature  

Last Ack sent to both creator and created

---

Distinguishes messages in different layers

---

# Working

Error
Documentation
expected error list with possible reasons the error was created.

Process.vi
Enqueue Errors immediately Set Error.vi

Error Best Practice
Errors should be handled with the method that generates that error. For example, when an error occurs in a method, DO NOT handle the error in a global method call after the method has finished executing. Rather, handle the error as necessary during execution of the method call (this means in decorated methods too, think in a decorated layer of actor, handling errors that come out of Create.vi in another layer)

Error Library turned Public







  

  

  



  


  





  


  



  

