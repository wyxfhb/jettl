Init.vi Inputs:  
- Msg Strategy
- Period

Process.vi
- unbundle Period
- timeout case: unbundle Msg to send to Creator.vi


#### Periodic Messaging
An actor should not have in its own timeout way to do something periodically such as send itself a message every 100 ms.
Instead it must create a periodic messaging actor which in its timeout sends the message to the actor that requires the periodic message. Separate the concerns.