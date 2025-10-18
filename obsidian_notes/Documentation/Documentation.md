### Sender Interface

Ability to check out where the message has been sent from.
For a practical example, if a message says to turn on a turbo pump, in the messages method, there can be a conditional check to see if the message came from the creator or self to turn on, depending on if the actor is in an external or internal setpoint state. This could prevent any *miss* messages from actually executing.

---

If a method has an object output terminal, you should wire the output to pass the object wire!

---

Revisit the priority stuff

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

**Is From Actor** boolean flag to tell whether a Msg has come from an Actor or has been executed as a normal method.

---

Best practice?

Messages should not be reused / forwarded.

Rather, messages should be contained within an actor.
That way actors use messages either alone OR

Utilities (virtual folder) for type defs

---

creating an actor should ONLY occur in the process method and methods within

---

Documentation

  

By knowing what messages an actor can implement,

AND

knowing what messages an actor uses (which ones are in memory?)

Then by process of elimination, we know which messages would otherwise be sent to external actors (creator / created)

---

No Op Msg

In case we don’t want to unconditionally execute a msg.. in the inspect method, an incoming msg can be overridden by instead putting the Null Msg on the object wire.

---

The inner layers for wrapping SHOULD NOT have Progress overridden? Way to enforce this?  

---

Best practice:  
Before creating an actor, cannot send it messages.

---

best practice:
for an actor, do not decorate after creating actor.

---

Actor layers where actors decorate each other.

- Implementing a Msg means you will extend functionality to it
- otherwise not implementing a Msg means you won’t add functionality to the Msg when it is called.
- If none of the layers implement the Msg, then an error is created in Base Actor.

---

best practice:
fundamentally, get and set methods should not do anything else but get and set WITHOUT and additional functionality.

---

Best practice:
Always develop in your own library and compose that library into a jettl actor. That way the code used is decoupled from the Actor.

---

Best practice to NOT use Is Priority flag in developer application

---

Best practice when naming Msgs

For private messages, the names can be fairly simple
Whereas for public messages, care should be taken to give them somewhat detailed names ~3-4 words.
This is due to name spacing issues when overriding the method names.

For example, a private message called “Begin Msg” is fine, whereas a public Msg of the same name could lead to naming conflicts for overrides. A better name, depending on context would be, “Begin Pump Sequence Msg” would be more suitable.

---

reason to public and private are used without protected or community scope

it is easier tot test actor because its methods are public so easier to test

---

not recommended to append functionality to methods with the Set and Get prefixes.

---

object wire must never be split unless:
- directly going to a read only method or
- unbundle

---

Through enforcing DD in and DD out for the Actor methods, actors always have the same object throughout its lifetime. Furthermore, the object is always contained within the event structure.

---

Key concepts:
- No Password Protection  
- No malleable VIs
- No xnodes
- RT Compatible
- No PLLS

---

best practice:
maybe it is best practice to NOT use the priority on messages. the direct use case is to send yourself a message again if not in the correct state.

---

Documentation:
"Finally, Actors are multi-instanceable, ....... will behave erratically or crash entirely."
https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Framework-Sometimes-I-get-lost/m-p/3425143#M3122

---

