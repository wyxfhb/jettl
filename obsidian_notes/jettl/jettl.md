**Inspect.vi**
Checks if Msg within current actors **Msgs**, otherwise

---

**Create.vi**
Swap
- Actor
- Alias

(Four places)

---

Three standard Msgs implement on
- **Base Actor.lvclass**
- **TEMPLATE Actor.lvclass**

**Msg Actor Wrapper** DD method called in EVERY Msg, to specifically deal with wrapping of messages.


Given the **Msgs** for an actor, c

Think Panel Actor inheriting Actor.. Actor doesn't have the Show Panel Msg? So are there wrappers for these? I guess not...

So as a default, should we wrap all messages too a a default?

So that if outside doesn't implement, a check says go to the next wrapped layer. if that layer implements it, execute that method. and since the wrapper is in that messages method, calls the next until there are no more to be decorated i.e. you're at the **Base Actor.lvclass**.

if the actor doesn't implement the message, then just pass the object through like it is a no op for that layer.

---

Base Actor.vi (this is Actor library Init method)

Create Base Actor.vi (this has within Base Actor.vi and Create.vi)

  

Need

- Set Self Attributes

- Get Self Attributes


Rename the xxxx Init methods to just xxxxxx

---

Msg added to after. change in scripting