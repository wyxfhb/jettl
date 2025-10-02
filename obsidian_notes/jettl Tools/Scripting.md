### Clean Up Wire

invoke node, wire, CleanUpWire
for Msg.vi

---

public and private distinguish name space

Have got to find a way to distinguish messages that are private vs public for the naming conventions
- maybe with holding library as prefix?
- maybe just look at their relative path maybe to distinguish, this can be a double check

---

edit things that deal with Msg Strategy in favor for Msg

---

really, the best practice is to create Msgs **IN** an Actor Library.
This should be another field of entry to put in the Actor Library to put the Msg library into.