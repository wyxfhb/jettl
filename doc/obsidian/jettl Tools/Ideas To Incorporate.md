for actor and msg renaming:
take the library(s) it is contained in and properly put them in a hierarchical map where the names are in fact unique depending on their path/hierarchy of library(s).

---

Tool for moving on disk.
really, the best practice is to create Msgs **IN** a preexisting Library.
This should be another field of entry to put in the Actor Library to put the Msg library into.

---

jettl Tools
Building Tools of your own:

All external jettl Tools belong in the same common location: Tools -> jettl Tools.
Please place them in this common location, helping developers find your tool easily!

Of course, please place company / name specific tools in their own folder as well if further credit should be given to your tool i.e. Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME.

---

Msg Rescripting -> Msg.vi:
Clean Up Wire
invoke node, wire, CleanUpWire

---

Documentation:
For Conn Pane Terminals: Msg Control
Only the left two inputs, possible Error in, and the Teller which is always in 6.

---

Actor Rescript Tool:
could be a actor rescript for rescripting the Init.vi to Init.vi where the inputs are the same.
Only used for the Actor rescript.