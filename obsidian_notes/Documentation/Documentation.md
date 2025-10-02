### Sender Interface

Ability to check out where the message has been sent from.
For a practical example, if a message says to turn on a turbo pump, in the messages method, there can be a conditional check to see if the message came from the creator or self to turn on, depending on if the actor is in an external or internal setpoint state. This could prevent any *miss* messages from actually executing.

---

If a method has an object output terminal, you should wire the output to pass the object wire!

---

Execution of Msgs determined BEFORE While Loop:
By definition, nothing should be overridden in Decorator
First
- *Pre Process*
Second (note order not guaranteed here)
- *Process*
- after *Create.vi*

**Note**
	The priority of messages

---

Put comments that are misc into the documentation

---

### Msg.vi

NIAF. This comment is taken directly and possibly modified from the Actor Framework.
"The use of two To More Specific nodes, one with the output object unwired and the other with the error unwired, is a trick to avoid creating a copy of the Actor object while still preserving the original Actor object if the To More Specific fails."

NIAF. This comment is taken directly and possibly modified from the Actor Framework.
"The case structure is intended to handle instances where the target method has no error input and to handle methods that do not check for error before executing.  It both prevents the operation and protects error throughput back to the actor core."

---

