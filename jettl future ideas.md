# These are in order of thought:

# Package available >= LV2020

Maps introduced?
Interfaces introduced?

# Debug

look into the actor framework for debugging library and where the methods are used.

incorporate the ping message and the debug / base debug libraries.

Compile time:
Actor knows
- messages it implements
- messages you send (block diagram search)
AND
where they go (note created not known alias though)

Runtime:
messages can be logged in their respective "send" overrides, logged to file and timestamped to show the system while it is executing.

Since an actor knows what messages it can accept through its interface implementation, at edit time, it can send this information to its created actors so that they know if a message they want to send to their creator can be accepted or not.


# clean up wire

invoke node, wire, CleanUpWire
for Msg.vi

# add Init.vi to TEMPLATE

# 

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

# Sender Interface

Reason for use:
Can check out where the message has been sent from.
i.e. if a message says to turn on a turbo pump, in the messages method, there can be a conditional check to see if the message came from the creator or self to turn on, depending on if the actor is in an external or internal setpoint state. This could prevent any *miss* messages from actually executing.

# for tools, is it necessary for the save all project? will otherwise speedup the scripting.

# rename refactor

Rename
jettl -> Actor
Msg Strategy -> Msg

# refactor

In the jettl.lvlib:
Put in the Private / Public Msgs folder just like TEMPLATE.

Keep only Teardown Msg, put in Public Folder.

# TEMPLATE comment

process Refs should not be used here since the message handling has completed.

# reason for globals:

Global variables hold constant values
Localizations