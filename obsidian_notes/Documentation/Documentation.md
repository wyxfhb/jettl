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

go back to the main release and grab the comments from Msg in Create.

---

Put comments that are misc into the documentation