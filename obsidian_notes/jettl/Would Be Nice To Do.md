Debugging

Actor framework for debugging library and where the methods are used.

incorporate the ping message and the debug / base debug libraries.

Compile time:
Actor knows
- messages it implements
- messages you send (block diagram search)
AND
where they go (note created not known alias though)

Runtime:
messages can be logged in their respective "send" overrides, logged to file and timestamped to show the system while it is executing.

Since an actor knows what messages it can accept through its interface implementation, at edit time, it can send this information to its created actors so that they know if a message they want to send to their creator can be accepted or not.

---

Future advanced Msg static checking

For a given actor:
Maybe some kind of static checking where the messages you want to send to
- Creator must be in a set in actors private data?
- Self must be in a set in actors private data?
- Created must be in a set in actors private data?

---

