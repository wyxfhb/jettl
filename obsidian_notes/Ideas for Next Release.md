Delete the
- merge error,
- override error, and
- Setup
MESSAGES
MOVE the methods
- Merge error and override error to utilities
- setup to jettl

Change connector panes of setup, merge error, and override error.

- Delete Setup message in Pre Process
- put setup method in Process (TEMPLATE)

TEMPLATE
- delete FP.open stuff in Setup
- delete FP.close stuff in Destroy



ALSO?
Delete the Teardown message?
Delete the Create message?




Put a comment in each of the utilities saying:
“It is discouraged to append functionality in this method.”

Note in the jettl methods, say that:
“It is discouraged to use this method in any other method, except the Process method.”




In Inspect method, if the message is the periodic message, (equal to with default run time object) send that message to self again right here.



Note message execution #1, #2 etc around where messages are executed to show the flow
In particular, in “Pre Process” this is #1, “Process”/“After Create.vi” these are #2 (interchangeable, note as comment the other method, timing determines since asynchronous)
Note the priority of messages

# public and private distinguish

Have got to find a way to distinguish messages that are private vs public for the naming conventions
OR
just look at their relative path maybe to distinguish, this can be a double check


**I wonder if Setup will still work for calling to the**

### Rename

- *jettl* -> *Actor*
- *Msg Strategy* -> *Msg*

### Msgs

Delete
- Create
- Merge Error
- Override Error

jettl
- Public Msg (vf)
	- Teardown
- Private Msg (vf)
	- Last Ack

TEMPLATE
- Public Msg (vf)
	- 
- Private Msg (vf)
	- Setup

Get rid of the Private jettls (vf)

### TEMPLATE comments

Destroy and Post Process
	Process Refs should not be used here since the message handling has completed.

### Actor.vi, in particular Enqueue Element.vi

(Justification for Error NOT being wired)

For the enqueue element, justification why the error is not necessary to wire on the output of the enqueue element.vi. This is because the possible errors that otherwise would occur with the enqueue element.vi are handled
For example,
- Error 1122: Invalid queue reference. This will NEVER occur since the reference will never be released since the creator waits until the dequeue has occurred.
- Queue is full. This will NEVER occur since only a single element will be sent on this queue containing the reference of the *Event Msg*.
- Error 2: Memory is full. This will NEVER occur since only a single element will be sent on this queue containing the reference of the *Event Msg*.
- Error 1: Invalid input parameter. This will never occur since this will occurs when the queue reference is invalid. This will NEVER occur since the reference will never be released since the creator waits until the dequeue has occurred.

This being said, can probably get rid of the *Is Refnum.vi* in the *Error.lvlib*.