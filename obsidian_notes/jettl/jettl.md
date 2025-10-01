Delete Address Strategy class / interface stuff
So many DD and accessors going on! Can replace with **Map of Relation to Set of Attributes.ctl** (below)

---

Rename
*jettl.vi* -> *Actor.vi*
*Base jettl.lvclass* -> *jettl Actor.lvclass*
*Msg Strategy* -> *Msg*
*Serialize To Inputs.vi* -> *Serialize*

---

**Attributes.ctl**
- Alias
- Msg Event
- **Set of Msgs.ctl**
*Replace and delete Created.ctl*

**Map of Relation to Set of Attributes.ctl**
- Relation.ctl
- **Set of Attributes.ctl**

**Note**
	Before adding to **Map of Relation and Set of Attributes.ctl**, **Is Unique Alias.vi** checks if the Alias is unique within the Created **Map of Relation to Set of Attributes.ctl** using For Loop.

**Note**
	In Creator.vi, Self.vi, Created.vi:
		Check if in the **Set of Msgs.ctl** before sending Msg.
		Error method called i.e. “Creator has not implemented PLACEHOLDER Msg”

**Find Implemented Msgs.vi** (private)
When an actor is created, the Msgs it can implement will be put into the Base jettl private data, so that:  
1. the created will know the Msgs the creator can receive and  
2. the creator will know the Msgs the created can receive (sent back from Actor.vi to Create.vi).
This allows checks to ensure that the Msg being sent has been implemented in the receiving actor.

---

Actor.vi, in particular Enqueue Element.vi

(Justification for Error NOT being wired)

For the enqueue element, justification why the error is not necessary to wire on the output of the enqueue element.vi. This is because the possible errors that otherwise would occur with the enqueue element.vi are handled
For example,
- Error 1122: Invalid queue reference. This will NEVER occur since the reference will never be released since the creator waits until the dequeue has occurred.
- Queue is full. This will NEVER occur since only a single element will be sent on this queue containing the reference of the *Event Msg*.
- Error 2: Memory is full. This will NEVER occur since only a single element will be sent on this queue containing the reference of the *Event Msg*.
- Error 1: Invalid input parameter. This will never occur since this will occurs when the queue reference is invalid. This will NEVER occur since the reference will never be released since the creator waits until the dequeue has occurred.

This being said, can probably get rid of the *Is Refnum.vi* in the *Error.lvlib*.

---

jettl Actor.lvlib
virtual folders
jettl
	Process
	Reuse
		Msgs
			Private
			Public
		Utilities

---

Msg.vi: take away error structure!

---

**Is Normal** (saved default as **TRUE**)
(delete State enum)

**Is Normal** can only be changed in
- Teardown.vi (to **FALSE**)
- An Error is present in private data in Merge Error and Override Error (to **FALSE**)
- Override To Normal.vi (to **TRUE**)

*Is Nominal State.vi* -> *Get Is Normal.vi*
*Override To Nominal State.vi* -> *Override To Normal.vi*