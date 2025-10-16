### VI Analyzer

Run VI Analyzer tests on NIAF and jettl
This can give an idea for benefits for jettl as compared to NIAF

---

VI Analyzer Test approval

### Rename / Replace

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


### Best Practice

Not all actors need to be individual. Some Actors are made to couple tightly with other Actors.

Because it is emphasized to not branch the actor objects wire, it is encouraged to create an actor that acts as a helper loop. Note that of course the messaging mechanism between them should still be actor messages, though Last Ack overrides etc. could contain information for the particular actor that was created. i.e. for a popup configuration box, this can be a private actor which returns its class contents which can be unbundled in Last Ack to easily get the configuration parameters.

---

Do not release the Register reference, unless after the loop in Process

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




jettl framework: decrease the places where the developer can *alter* the values of internal data.

Minimize use of `Write xxxx.vi`
Maximize use of `Read xxxx.vi`

