### Sender Interface

Ability to check out where the message has been sent from.
For a practical example, if a message says to turn on a turbo pump, in the messages method, there can be a conditional check to see if the message came from the creator or self to turn on, depending on if the actor is in an external or internal setpoint state. This could prevent any *miss* messages from actually executing.

---

If a method has an object output terminal, you should wire the output to pass the object wire!

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

Documentation:
**Control Refs**
"Use of value property is generally discouraged in VIs unless you’re having to do it with a control reference inside of a SubVI" -DNatt
@00:12:26
https://forums.ni.com/t5/VI-Analyzer-Enthusiasts/Improving-Your-LabVIEW-Code-with-the-VI-Analyzer/m-p/3415352

In the future, best practice to  have SubVIs with “—[valchg.vi](http://valchg.vi/)”. Of course, this would be scripted and easily findable.

(yes, LabVIEW identifies indicators as controls)
*You may place in sub clusters (make sure they’re type refs) in the Control Refs cluster to differentiate controls, indicators, sub panels, etc.*  

---

PPL Support
Although early in the jettl lifecycle, I am open to building the main jettl library into a PPL.
This may require a jettl Tools rewrite, but might be worth looking into.
I recommend this presentation before considering the use of using PPLs:
[https://youtu.be/HKcEYkksW_o?si=_hSmbd662LdCqNOu](https://youtu.be/HKcEYkksW_o?si=_hSmbd662LdCqNOu)

---

Style banner color
Banner colors, easy to see if interface method is on the class object wire since they’re different colors! And ALWAYS the same colors.
timestamp: 40:34
https://www.youtube.com/watch?v=AHOZ7fiuWCA

---

Virtual Folders for bookkeeping:
Actor:
Extended
Default

Msgs:
If you’re not extending the behavior, you do not need to implement the method. The Msg Handler will take care of this for you.

---

**Be careful**
These are async processes.
If references are created in an actor (Actor A), but used in another actor (Actor B). If Actor A is destroyed (without closing the reference), but the reference is still being used in Actor B.. the reference will be destroyed leading to confusion of the developer since they hadn’t closed the reference in the Actor B.
Takeaway: create and destroy references in the same actor.
This is the exact reason the Self Attributes references are created in the actor being created. Because if the creator is destroyed, the created actor will still have its references alive.
In particular, when initializing the actor, take care to not create references in the init methods, if you expect to destroy the references in the created actor, due to reasons above. Rather, move the creation of these references to the Finish Create method override.

---

**Test Panel (Not Complete)**
Automatically generated test panel providing controls / necessary inputs for all messages the actor expects.
have the test panel display payloads from messages received.
This “Test Panel” is integrated as a part of the actor itself.
This is to design modular Actors without dependencies of other Actors.
Advanced: Potentially which messages the Actor is able to send and to which relative actor.

**Debugging (Not Complete)**
Debug / Unit Test class wrapping.
Some kind of diagram disable in the developed actor `Decorator.vi`, surrounding the (yet to be made) `Debug.lvclass`.
That way debug code does not exist in Base classes, and is held exclusively in the `Base Debug.lvclass` / `Debug.lvclass` interface.

---

bleh, only the actor with the internals of actor populated can be used at the outer layer.

---

Feature
Internal to jettl, there exist NO circular dependencies.

---

`Actor.vi`
Yes. The actor does not need to have an output, but for testing purposes it is nice to have it be an output to look at the object after actor was done executing if ran by itself.
Also, to ensure the object is the same throughout its lifetimes the DD output terminal ensures this to be true.

---

Best practice:
Do t call anything that is not on the palettes.

---

**Important**
Fundamentally, when an object is instantiated, there should not be an error that occurs.

---

