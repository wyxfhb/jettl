### Teller Interface

Ability to check out where the message has been sent from.
For a practical example, if a message says to turn on a turbo pump, in the messages method, there can be a conditional check to see if the message came from the creator or self to turn on, depending on if the actor is in an external or internal setpoint state. This could prevent any *miss* messages from actually executing.

---

Advice: Before Setup of an actor, cannot send itself or parent messages.

---

Actor layers where actors decorate each other:
- Implementing a Msg means you will extend functionality to it
- otherwise not implementing a Msg means you won’t add functionality to the Msg when it is called.

---

Best Practice: read and write methods should not do anything else but read and write.

---

Best practice: Always develop in your own library and develop actor code that depends on that library. That way the code used is decoupled from the Actor and can be tested independent of the actor.

---

Best practice: Tend to NOT use Priority boolean.

---

Best practice when naming Msgs: somewhat detailed names ~3-4 words.
This is due to mitigating naming issues when overriding the method names.

For example, a message called “Begin Msg” is fine, whereas a Msg of the same name could lead to naming conflicts for overrides. A better name, depending on context would be, “Begin Pump Sequence Msg” would be more suitable.

---

Best Practice:
object wire must never be split unless:
- directly going to a read only method or
- unbundle

---

jettl features
- No dependencies outside of native LV
- No Password Protection  
- No malleable VIs
- No XNodes
- RT Compatible
- No PLLS
- No Circular Dependencies

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
*You may place in clusters (make sure they’re type defs) in the Control Refs cluster to differentiate controls, indicators, sub panels, etc.*

Only use when these control refs are used in message methods OR methods constrained in message methods. Otherwise, if there is a method call in the event structure, do you best to wire in the VI Server control reference to the method as an input instead of passing the entire object wire into the method.

Takeaway, minimize the use of references put into the Control Refs cluster. Instead maximize their use in the event structure for better readability.
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:45:46

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

------------------------------------------------------

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

![[Messaging Scheme.png]]
*Event Ref.*

---

Actor.vi
Output terminals are available primarily for testing purposes, when one wants to unit test this actor and directly get its state / error.

dynamic terminal output is not wired to release events, on purpose, to defer to after unexecuted messages have been handled.

---

Example with hot swappable front panels
Where you have two created actors, and ability to toggle front panel displays.
Think justACS AF presentation State of the Art.

![[statepatternactors.png]]
*!(The State of the Art for Actor Framework)[https://www.youtube.com/watch?v=gz_6FTE1__8&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19] @timestamp 21:33.*

---

[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:00:00-00:12:18

![[clean propagation.png]]
*Minimal bend wiring philosophy = Write code for maximum readability. Notice error wire and object verticality has plenty of room between. Object wires through for IO methods. Input only methods are a couple spaces beneath. And errors follow the method calls. All wires have minimal bends. Note even this isn't great, should instead reorganize and **please** use flat sequence structure!*

---

Outline Object in / out and Error in / out terminals are restricted. Therefore, only use the other 8 terminals for input / output.
Also, follow this rule that an object in MUST be an object passed out for the same color wire horizontally across the method / function call.
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:45:21

---

Yes, it is one thing to do class inheritance, another to do decorator pattern, and another to do layered intermediate checks for decorator pattern. This is how the `Msg Handler.vi` works.

Show the dropping of a NES with method.
Now what messages use with the Msg Handler to deviate to checking if in Local Msg Set and determines where to call the messages method or defer to the next decorator, and reiterating until the core conditional is called.

Could have a tree of execution for this. With pictures of block diagrams with arrows

---

[Large LabVIEW Project Development Techniques](https://youtu.be/7zS3Q_K71XY?si=VZXcWRaCqc0C4tWh)@00:14:08
Note on organizing virtual folder contents, very helpful with keeping name spacing consistent!!

---

PPLs
I avoid PPLs because DNatt told me to.
[GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc)
[LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022](https://www.youtube.com/watch?v=HKcEYkksW_o)

---

**Rule: Framework will not WORK if you have Go To Destroy function or method call anywhere before messaging handling loop!**
**DO NOT execute `Go To Destroy` before event structure.**

---

#### **Executable**
[Confirm "Find Local Msg Set.vi" can function properly in the executable. #10](https://github.com/natev51/jettl/issues/10)
Try putting an application into an exe AND with different calling of messages, display on the front panel the Local Msgs and Unified Msgs.
This would confirm how they’re loaded into memory or not.

Building executables:

[GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc) @00:37:52-00:43:43.
[NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)

![[BEFORE you play checkbox roulette.png]]

Build an exe and note the time taken to do so WITH ONE ACTOR in project.
write about exe build time in readme.

[Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY)@00:32:13.
All pictures come from the above linked presentation:

![[LargeDevTech-PPLs.png]]
![[LargeDevTech-Problem.png]]
![[LargeDevTech-add.png]]
![[LargeDevTech-debug.png]]

---

Testing Documentation:
Can use Actor.vi on its own in other modules

---

Object IO justification
[An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k)@00:23:59

---

Unhandled Msgs:
Panel Close? Event, have Go To Destroy and then a Msg. See if that Msg, in Destroy was an Unhandled Msg ie 1bd with list of Msgs

---

