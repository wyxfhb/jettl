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

---

Take away “-“ for Pre and Post, etc

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


# Working

