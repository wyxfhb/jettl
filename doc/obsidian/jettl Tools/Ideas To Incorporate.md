for actor and msg renaming:
take the library(s) it is contained in and properly put them in a hierarchical map where the names are in fact unique depending on their path/hierarchy of library(s).

---

Tool for moving on disk.
really, the best practice is to create Msgs **IN** a preexisting Library.
This should be another field of entry to put in the Actor Library to put the Msg library into.

---

For implemented message methods that class doesn't implement the interface i.e. a message that cannot ever be executed.
When a interface message is implemented, but messages method is not implemented.

---

Building more jettl Tools:
All external jettl Tools belong in the same common location: Tools -> jettl Tools.
Please place them in this common location, helping developers find your tool easily!

Of course, please place company / name specific tools in their own folder as well if further credit should be given to your tool i.e. Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME.

---

Necessary to use the save all project function call? This will otherwise speed up the scripting.

---

Have target drop down menu for project:
![[target_names.png]]

---

Msg Rescripting -> Msg.vi:
Clean Up Wire
invoke node, wire, CleanUpWire

---

public and private distinguish name space

Have got to find a way to distinguish messages that are private vs public for the naming conventions
- maybe with holding library as prefix?
- maybe just look at their relative path maybe to distinguish, this can be a double check.
- checking privacy for the containing library?

---

TEMPLATE: change the type to be an enum selection