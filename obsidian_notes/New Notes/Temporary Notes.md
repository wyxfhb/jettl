Advice: The control terminal label signifies how that control terminal is used in the function. NOT how it relates to how the calling code calls that function.

---

Best Practice: Because it is emphasized to not branch the actor object wire, it is encouraged to create an actor that acts as a helper loop instead of a parallel while loop within the actor. Note that of course the messaging mechanism between them should still be actor messages.

---

Advice: Always assume you cannot control the order messages execute.

---

Advice: Msgs can be sent to Self and Parent in `Setup.vi`, only after the decorator method since register for events in the `Setup.vi` Base Actor method.

---

General Best Practice: If a function has output object, it SHOULD be wired.
> VI analyzer test that looks if that terminal has an associated wire connection.

---

Advice: Since `Actor.vi` is NOT a decorator method, that means only the outer local actor 'Actor.vi' will be executed!

---

General Best Practice: Only have top left and top right conn panes as Object in / Object out

---

'jettl': All Boolean logic is positive logic.

---

jettl: 'Actor.vi' Sets up and Tears down all references in the same call.

---

Errors signify that
- intended operation could not be performed, otherwise said also that
- Indication that a function could not complete it’s assigned task

[https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk](https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk)

An example of intermediate actors:
Since each error that can occur in a method is known, an Actor decorator, for example, can override this behavior by clearing errors as necessary. It is the default behavior to put all jettl errors on the error wire to expose the API to the developer, and the developer can decide which errors to ignore for each individual method.
For example, clearing errors that come from the Tell methods if an Address is not registered anymore.

Best Practice: Errors should be handled with the method that generates that error. For example, when an error occurs in a method, it is best to NOT handle the error in 'Error Handler.vi'. Rather, handle the error as necessary during execution of the method call (this means in decorated methods too, think in a decorated layer of actor, handling errors that come out of Create.vi in another layer).
This can be company specific intermediate actors.

'jettl': All know errors that can happen in jettl are documented in `jettl.lvlib:Error.lvlib`

Best Practice: For EVERY method / function call, you SHOULD KNOW EVERY ERROR that will come out of that method / function, and document it for the developer. Otherwise, the error *likely* was passed from a previous method / method. You will know this by the call chain.

[https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189](https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189)

---

https://www.youtube.com/watch?v=AHOZ7fiuWCA
timestamp 42:05
Embrace the flat sequence structure for serialization, NOT error wires.
An error wire input and output tells the developer that the error can be modified in the method!

---


### Hierarchy Monitor Intermediate Actor

Initialization requires:
- Self Attributes
- Parent Attributes
Note: Child information is redundant information since can construct everything with Self and Parent Attributes.

After sending message, logs to file the **Tell Time**
After receiving message, logs to file the **Receive Time**

**Start Time**
This logging should go into **Start.vi** wrapper actor

---

Intermediate Actor Logging  
EACH Actor can have an event logger.

File is created for EACH Actor in a central temp application directory, and a time stamp with a call chain / object hierarchy are logged with events etc. This way we can easily stream these values to disk as an internal actor logger.

Wrapper
For the Errors generated in the program..
In some actor layer, can override this default behavior by decorating the actor
This Actor Wrapper can come native as a reuse library.

### Wrappers

Advice: when decorating actors, they don’t know about each other, but decorated actoes can interact with common method calls between layers, this includes data defined by messages!

---

'jettl': Msgs are decoupled between layers
sending a message defined in an internal layer but not the outer actor or corr actor still means the message will be in the 'Unified Msg Set'.

---

Unit Testing idea
Other idea about unit testing:
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!

---

Sub Panels
After 'Spawn.vi', access to Child Attributes, which has Actor Ref, so can easily put this into a Sub Panel here. And further, can modularize where front panels are in Actor front panel of Self i.e. changing around panels since you directly have access to the Actor Ref of the Child Attributes.

---

`Stop.vi'
- always starts as `False`
- only be changed to `True` in  `Stop.vi`
- can never be changed to `False`

### Can Stop.vi

`Stop` = TRUE
OR
Error (then Stops)
outputs `Can Stop` = True

Note: unhandled error has occurred and the system cannot continue, hence Stop will be directly called.

### jettl Tools

Tool that allows actor to implement message interface AND auto populates that interfaces message method with 'Component.vi' and necessary wiring.
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


'jettl': 'Terminate` Msg sent to both parent and all children

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


Paradigm shift:
Messages aren’t only things you receive..
Messages are objects you can act upon with the Msg Handler. Which is why Msg Handler is everywhere throughout the application, not only in the Msg Event case.


Some methods should discourage extending functionality? which ones?

---

Idea:
Fundamentally, a message cannot be sent to an actor that cannot implement that msg. Also, an actor will not execute a message that it cannot implement.
Only actors around the actor of interest can interact with that actor via messages.
**Instead have three functions for each message with options for `Self`, `Creator`, `Created`**
Could be easier for scripting applications
Can find the libraries in memory for a given actor and find the associated message functions used along with which method they’re wired up to? to determine which messages would go where.
This wiring could be hard because nodes dynamically can determine which of two messages will go where ie select vi or Send X vi wrapped in case structure. Nonetheless, must be a vi analyzer test to determine where messages are to be sent at edit time. All possible statically determined permutations for sending a message. I guess that a message can be bundled into private data so you NEVER would know which message is unbundled and sent..
This would be interesting to determine. This tool would be used for troubleshooting and documentation.
Also, a tool for determining if a message can be sent to sel like if there are multiple actor layers and a message sent to self but can receive locally but can in another layer

---

