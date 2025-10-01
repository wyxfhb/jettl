Delete Address Strategy class / interface stuff
So many DD and accessors going on! Can replace with **Map of Relation to Set of Attributes.ctl** (below)

---

**Implemented Msgs.ctl** (Set)

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


When an actor is created, the Msgs it can implement will be put into the Base jettl private data, so that:  
1. the created will know the Msgs the creator can receive and  
2. the creator will know the Msgs the created can receive (sent back from Actor.vi to Create.vi).
This allows checks to ensure that the Msg being sent has been implemented in the receiving actor.

---

**Is Normal** (saved default as **TRUE**)
(delete State enum)

**Is Normal** can only be changed in
- Teardown.vi (to **FALSE**)
- An Error is present in private data in Merge Error and Override Error (to **FALSE**)
- Override To Normal.vi (to **TRUE**)

*Is Nominal State.vi* -> *Get Is Normal.vi*
*Override To Nominal State.vi* -> *Override To Normal.vi*

---

Move the Path into the **Attributes.ctl**?

---

nxg error

---

replace strategy with Addresses and Base Addresses (other some other name)