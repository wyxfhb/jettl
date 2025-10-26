
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

Delete
- Pre Process
- Post Process 
- Cleanup
- Set Self Attributes
- Set Creator Attributes

---

Set -> Write
Get -> Read

### Best Practice

Not all actors need to be individual. Some Actors are made to couple tightly with other Actors.

Because it is emphasized to not branch the actor objects wire, it is encouraged to create an actor that acts as a helper loop. Note that of course the messaging mechanism between them should still be actor messages, though `Has Destroyed` overrides etc. could contain information for the particular actor that was created. i.e. for a popup configuration box, this can be a private actor which returns its class contents which can be unbundled in `Has Destroyed` to easily get the configuration parameters.

---

Do not release the Event Ref, unless after the loop in Process

---

Always assume you cannot control the order messages execute!

---

Msgs can be sent in `Pre Loop.vi` since register for events before the `Pre Loop.vi` execution

---

If a method has output object, it SHOULD be wired.
VI analyzer test that looks if that terminal has an associated wire connection.

---

Since `Process.vi` is NOT a decorator method, that means only the top level process will be executed!
Get rid of any layer outside of the actor with a process.

---


### Style Best Practice

Only have top two conn panes are Object in / Object out

---

### Key Features

All Boolean logic is positive logic.

---

Justify execution for each method in it's description

---

Base Actor Creates and Destroys all references in the same method call.
In particular, Queue and Event references.

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

Errors signify that
- intended operation could not be performed, otherwise said also that
- Indication that a function could not complete it’s assigned task

[https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk](https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk)

Since each error that can occur in a method is known, an Actor decorator, for example, can override this behavior by clearing errors as necessary. It is the default behavior to put all jettl errors on the error wire to expose the API to the developer, and the developer can decide which errors to ignore for each individual method.
For example, clearing errors that come from the Send methods if an Address is not registered anymore.
expected error list with possible reasons the error was created.
All errors that can happen in jettl are documented in `jettl.lvlib:Error.lvlib`

Errors should be handled with the method that generates that error. For example, when an error occurs in a method, DO NOT handle the error in a global method call after the method has finished executing. Rather, handle the error as necessary during execution of the method call (this means in decorated methods too, think in a decorated layer of actor, handling errors that come out of Create.vi in another layer)

For EVERY method / function call, you SHOULD KNOW EVERY ERROR that will come out of that method / function, and document it for the developer. Otherwise, the error *likely* was passed from a previous method / method. You will know this by the call chain.

[https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189](https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189)

---

https://www.youtube.com/watch?v=AHOZ7fiuWCA
timestamp 42:05
Embrace the flat sequence structure for serialization, NOT error wires.
An error wire input and output tells the developer that the error can be modified in the method!

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

---

Wrapper Actor Logging  
EACH Actor has event logger.

TDMS file is created for EACH Actor in a central application directory, and a time stamp with a call chain / object hierarchy are logged with events etc. This way we can easily stream these values to disk as an internal actor logger.

---

### Palette

Advanced Palette (in Actor)
Includes the Actor.vi, Send.vi, etc.

> Should include otherwise advanced functions, outside of normal use in jettl.

> Maybe this isn't *Advanced*, but some other name for otherwise *discouraged in practical use*.

Advanced palettes for EACH of the libraries exposed to the developer, in case they want to use dangerous functionality.

---

Best practice:
Do not put the Msg methods in the palette since they are never called directly.

---



### Enqueue and Dequeue

Comment
Enqueue: Fundamentally will not output an error since the queue is guaranteed to be open.
Dequeue: Fundamentally will not output an error since the queue is guaranteed to be open.

### Boolean prefixes

Is, Can, Has, Should, Was

### Process.vi

**Process.vi**
Register for Events before **Process.vi** override

> No need for comment about releasing event references

Increase the size

---

Take away decorator. Not a decorator.

---

`Panel Close?` event with default of `Mark For Destroy.vi` function

---

`Process.vi`
After `Write Attributes`
`Was Created.vi`
AND
`Can Proceed.vi`

---

Actor Refs
Placeholder Application Ref in Actor Refs
Wire in default in `Actor.vi`
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
Boolean flag for “Destroy on Creator `Has Destroyed`”
TRUE set as default

---

Wrapper
For the Errors generated in the program..
In some actor layer, can override this default behavior by decorating the actor
This Actor Wrapper can come native as a reuse library.
Error function, and unbundle to get the `code`

---

Unit Testing idea
Other idea about unit testing:
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!

---

The `Read` / `Write` accessors never put out errors. That goes for the decorators as well. They should also not put out errors.

---

Sub Panels
After Create, access to Created Attributes, which has Actor Ref, so can easily put this into a Sub Panel here. And further, can modularize where front panels are in Process front panel of self i.e. changing around panels since you directly have access to the Actor Ref of the Created Attributes.

---

For typical overrides to functionality.
One thing is for `Has Destroyed` where the Error that was in an Actor.. how to handle, well there is default functionality in the Example Internal Actor that appends these errors to the creators object wire AND if from a creator, Destroys itself.
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

messages named by the actor that sent the Msg
i.e.
Final Msg

---
### Destroy

`Mark For Destroy.vi` (Msg)
`Is Marked For Destroy` (Boolean in PD)
`Destroy.vi` (happens right before `Has Destroyed`)

`Marked For Destroy`
- always starts as `False`
- only be changed to `True` in  `Mark For Destroy.vi`
- can never be changed to `False`

### Can Proceed.vi

`Is Marked For Destroy` = TRUE
OR
Error
outputs `Can Proceed`

---

Duality of Destruction!
Either You're moving to Destroy because the `Mark For Destroy.vi` has executed or an unhandled error has occurred and the system cannot continue, hence Destroy will commence.
These currently are two separate entities.

---



### Has Destroyed (Msg)

At end of Actor, DO
Have two Actor objects going to flat sequence.

---

**Was Created** boolean, this tells if the **Has Destroyed** should be sent or not.

---

Don’t need checker in front, but comment, could execute zero times.  

Use flat sequence for Has Destroyed and Release Address?

---


### Was Created

Only TRUE when no errors AND marked for destroy = false

---

### Write Attributes.vi

(mirror the connector pane for Process)
Inputs of
- `Queue of Actor` (unbundle the Actor for it's contents)
- `Creator Attributes`
- `All individual Self Attributes`
`Init.vi` (Attributes)
`Was Created` = True
Enqueue Self Attributes to creator.
### Project Style

Move to Actor Utilities!  
- Msg Execute.vi
- Msg Layer Checker.vi (change name?)

---


### jettl Tools

Tool that allows actor to implement message interface AND auto populates that interfaces message method with Msg Execute.vi, the function, and necessary wiring.
https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580

---

TEMPLATE
PD: open refs array

---

Actor / Msg Enum
Replace ALL string types with this one.

---

Target combo box:
- Rescript
- Template
- Rename

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
Local Msg Set

---

`Msg Output.vi` -> `Add To Msg Sets.vi`

`Find Local Msg Set.vi`, then
- Bundle into `Local Msg Set`
- Union into `Unified Msg Set`

Delete
- `Write Local Msg Set`
- `Read Local Msg Set`

---

### Contains Msg.vi

output `Contains Msg` Boolean
Inputs
- Msg Set
- Msg
(Unified Sets Error in case structure)

# Miscellaneous

### jettl Feature  

`Has Destroyed` Msg sent to both creator and created

---

Distinguishes messages in different layers

---

jettl does not require ever modifying class inheritance since class inheritance is not recommended. Recommended practice is using interface implementation for all classes mixed with dependency inversion.



# Need to Sort

`Init.vi` (TEMPLATE Actor)
`Has Error.vi`
You have not even created yet, so don’t ever call `Go To Destroy.vi` here.

`Uninit.vi` (outside `Init.vi`)

`Decorator.vi`

`Create.vi`
Checks if the Actor input `Must Destroy.vi`, otherwise, throw an error that operation could not continue.

`Actor SD.vi` (SD IO) Comment to say this is only used since async start doesn't allow starting DD methods, no a SD method is used.
Panel Stuff:
Include the `Count.vi` T and F with fss
To insert into a sub panel, need to first have standard front panel displayed?
*Can have hidden FP on RT?*
Can just run Hidden FP for all actors, then don’t need the `Count.vi`?

`Actor.vi` (replaces `Actor.vi`) (DD IO)
Documentation:
`Actor.vi` has output for potential debugging done outside of the scope of the framework ie for testing, running the `Actor.vi` on its own.
Delete `Process.vi`
Comment:
In part, it is fine to have `Actor SD.vi` for our case because we want to ensure the actor object wire is never changed throughout it's lifetime. So having a DD output terminal on the `Actor.vi` minimizes runtime errors preventing the object wire from changing AND for testing, by running the `Actor.vi` in isolation to gain insights to an actor without starting it up asynchronously.

`Write Attributes.vi`
Create Address
Creates Event Ref
Creates Unified Msg Set
Fundamentally should not put out an error. This error will be sent back to the Creator via the enqueue.
Execute `Must Destroy.vi` after this method to check if the `Write Attributes.vi` internally creates an error (framework error). It sends the error back to the creator and puts the error on the object wire. These are only framework errors.
*Write Attributes may only signal errors related to the structural identity of the Actor. Behavioral errors belong to message handling.*

`Pre Loop.vi`
Output
	Event Ref
(release events if an error / destroy after `Pre Loop.vi`

`Pre Handle.vi`

`Handle.vi`

`Post Handle.vi`
`Was Msg` (True ONLY for Message Case)

`Post Loop.vi`
This is where the drop messages can be handled

`Destroy.vi`
unconditionally called.
Release Address unconditionally, in case Post Loop has not been called since not created.
This is the only place the `Event Ref` is released.
Internally, checks `Has Created` flag to see if `Has Destroyed should be sent`

`Read Unhandled Msgs.vi` (Function)
Note
	Should be used after override of Post Loop, this is because `Destroy` includes the release of references.

`Is Marked For Destroy` (boolean internal)

`Must Destroy.vi`
	`Error` or `Is Marked For Destroy`


Read methods for all private data!
`Has Error.vi`


create references in Actor.vi since other wise they would be released from memory is the creator is destroyed.


Error on IO
Don’t have terminals on error IO unless they are errors.
This is the same philosophy used for the object IO terminals.
- Edit the scripting tools to not include Error in OR, BUT ALWAYS includes Error out
- outline in message creating that only four inputs are allowed. Two on the side, and two on the bottom.


# Finished


Think more about wrapping common tasks into FUNCTIONS instead of all objects.

Rule:
Before, don’t execute `Go To Destroy` before `Create.vi`. You can, but the framework will not function correctly. There are no checks to see if the Booleans are correct.

Paradigm shift:
Messages aren’t only things you receive..
Messages are objects you can act upon with the Msg Handler. Which is why Msg Handler is everywhere throughout the application, not only in the Msg Event case.

Come back to this..
kindof rule of thumb.. only append functionality AFTER the override method..?
Also, some methods should discourage extending functionality? which ones?






called `Msg Case`?



Add in Time to Sender!
take away the library calls in palette

---

Msg Handler function  
Input: From Msg Event
(Also done for Msg Inspect)

  

Error Handler
Input: From Msg Event
(Both)