Get rid of Is Sync
in messages (two places)
in Sender interface

---

Base Actor.lvclass
Normal.vi (include override error no error)

---

Replace all of the unbundles in Base Actor with
The necessary methods (Self Attributes, etc)

---

is sync and time remove from palettes

reply message in palettes

set error
get error
palettes

---

maybe have the instantiation in the Sender Actor!

---

Have some strategy pattern internal to Sender which gives user the ability to get the info of Sender Interface and log things etc.

This can be an interface called Inspect.lvclass with a DD method called Inspect.vi which takes in and out the Msg (just like inspect)
This way sending messages and receiving messages can be logged accordingly.

extra logging for messages:
Also, the message itself can be used as a unique reference I.e. identifier
class that has functionality in every method?