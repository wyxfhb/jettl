Process.vi
	Execution: check box the close when closed but leave the front panel open when ran UNCHECKED!
	This allows us NOT to need to use the FP.Close invoke node in Destroy method.

---

Comment in Destroy and Post Process
	Process Refs should not be used here since the message handling has completed.

---

delete 
	FP.open stuff in Setup
	FP.close stuff in Destroy

---

replace with execute
sync reply ALSO has execute.

---

TEMPLATE Init (Recommended)

---

