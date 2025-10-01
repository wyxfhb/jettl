Add in the Init.vi

---

Process.vi
	Execution: check box the close when closed but leave the front panel open when ran UNCHECKED!
	This allows us NOT to need to use the FP.Close invoke node in Destroy method.

---

Take away sender interface from Merge Error, Override Error, Create

---

Comment in Destroy and Post Process
	Process Refs should not be used here since the message handling has completed.

---

delete 
	FP.open stuff in Setup
	FP.close stuff in Destroy

---

Msg.vi, get rid of Error Structure
and the TSC after the interface.

---

