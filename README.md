# jettl

*Dedicated to Stephen Loftus-Mercer for his pioneering work in introducing interfaces to LabVIEW development.*

*Please message me with your suggestions on how I should demonstrate more clear explanations, what I can do to improve the codebase for the developers needs, and examples you'd like to see. Especially this.*

`jettl` is a lightweight library used for decorating developed classes with either the `Queue jettl` interface or `Event jettl` interface via composition and implementation of the methods from either of the implemented interfaces. Included here are crucial design patterns including Strategy Pattern, Decorator Pattern, State Pattern, and Observer Pattern. SOLID principles, especially dependency inversion/injection, hence strategy pattern for dynamic dispatch messaging.

## Motivation

For a little over a year (currently 2025), I have had success designing applications to interface instruments to our nuclear fusion experiments, control XY stage motors to correlate and display 3D images via a topological scanning laser readout, and perform PID autotune algorithms for high efficiency RF antenna matching circuits. I wrote all of these applications using the [National Instruments Actor Framework](https://education.ni.com/badges/resources/984/actor-framework). Along the way, having learned about the [SOLID Design Principles](https://en.wikipedia.org/wiki/SOLID) and [Design Patterns](https://en.wikipedia.org/wiki/Software_design_pattern), I had been eager to apply these principles and design patterns. Being intimately involved with the source code of the [Actor Framework](https://education.ni.com/badges/resources/984/actor-framework), I ventured to build a library that uses common elements from the Actor Framework, Derrick Bommarito's [lv-artifex](https://github.com/illuminated-g/lv-artifex), and the many talks given by [Dmitry Sagatelyan](https://forums.ni.com/t5/LabVIEW-Champions-Directory/LabVIEW-Champion-Dmitry-Sagatelyan/ta-p/3536802) on the Agile Software Design Principles, SOLID principles, and Context-Agnostic Actors. `jettl` was born.

## Advantage

- **Composition over inheritance**. More specifically, interface composition. Interface composition allows for dynamic wrapping of classes via their common interface. In particular, debugging, unit testing, swapping panels, etc.
- **Separation of Concerns**. Actors are split into `Queue Actors` (following the tree messaging hierarchy) and `Event Actors` (which can only be created by `Queue Actors`). Dynamic creation of `Event Actors` can occur leading to `Event Actors` being able to enqueue messages to a `Queue Actors` Caller, Self, and Nested Actors, dynamically.
- **Messaging**. Both `Queue Actors` and `Event Actors` use DVR queues and DVR events to send messages. These messages are exclusively interface driven messages, fully abstracted. Simple methods (`Queue Caller`, `Queue Self`, `Queue Nested`, `Event Self`, `Event Nested`) are used to send a message to the respective DVR.
- **Reference Abstaction**. The `Queue Actors` DVR Queues are fully abstracted away. The `Event Actors` have their DVR Event available to the developer, giving rise to a observer pattern, allowing cross tree messaging via the Event Actors.

## Examples

A Hello World Example is here in the project in `jettl\scr\jettl.proj`. Run the `Main Hello World.vi` to spawn a `Queue Actor` and an `Event Actor` (acting as the front panel). This is where you should start when learning `jettl`, by example.

# Things Necessary To Become Successful

- Script messages
- Script right click menu for creating template for `Queue Actor`, creating the decorator override methods with necessary functionality
- Script right click menu for creating template for `Event Actor`, creating the decorator override methods with necessary functionality
- For `Panel Event Actors`, dedicate message methods for `Show Panel`, `Hide Panel`, `Change Panel`
- Interchanging panels example using the interface composition based State Pattern
- Subpanel example
- `Notifier Actor`
- `Periodic Message Notifier Actor` example
- `Channel Wire Actor`
- Debug / Unit Test class wrapping. Some kind of diagram disable in the developed actor `Decorator.vi`, surrounding the (yet to be made) `Base Debug.lvclass`. That way debug code does not exist in Base classes, and is held exclusively in the `Base Debug.lvclass`.

## Documentation

look in the `doc` folder, and older documentation in the `doc_old` folder

![](images-readme/hierarchy.png)
![](images-readme/queue-actor-method.png)
![](images-readme/event-actor-method.png)

## What I'm Woring On

### Speak on design pattern used for Messaging in jettl


### jettl is the alias for Actor.


### Avoidance of virtual folders


### Emphasis of encapsulated classes are classes marked private.
Class encapsulation. Any class should be marked as private to the library containing them.
That way, it is not encouraged to use the classes in other projects, leading to use of dependency inversion.
Or, stipulation, classes that are held in libraries, the library should be marked as private.

### Event jettl
Controls and indicators are updated with property nodes.
Note an excellent idea: https://www.youtube.com/watch?v=RJ7FHrzIu68&t=270s: 13:29
For functionality of `Add Reference to Class Data`
These can be in message methods.


### Errors are built into jettl.
For every actor being wrapped, there is an error cluster within their private data.
The errors are abstracted away from you, but if there does exist an error you may handle it in the Handle.vi override.


### Queue jettl not enforced, but encouraged to use a double layer for the Queue jettl i.e. a single Queue jettl top layer and infinite Queue jettls in the second layer.
This provides very easy to understand messaging from self up to caller, and back down to a nested.
The Queue jettls are for:
- creating the Event, Notifier, Channel Wire jettls,
- *mainly* for transporting the necessary references to other jettls, and
- communicating with other application instances / executables.
This transporting of references leads to the observer pattern distributed system.
This change in thinking of a distributed model is easier to understand as well.
Note: The Event jettls are inherently a single layer since they cannot create Queue jettls or Event jettls


### Make sure there do not exist any xnodes OR malleable vis


### Refactor Decorator Pattern:
Requires one context class for decorating multiple times.
Is there a way to use the **four** videos to refactor the decorator pattern without class inheritance?
This should be applied to jettl for multiple wrappings of objects inheriting from the same interface.


### Message method execution: shared clone
A shift in the developers' mindset: Develop message methods at the interface level.
Things that can change for the message:
1. `Rename jettl Message`: right click library
2. `Change Inputs For jettl Message`: right click interface method (change connector pane in interface method first)

jettl Name.lvlib
Msg.lvclass
-Name.vi
Concrete Msg.lvclass (private)
-Init.vi (public) (initializes the class object)
-Msg.vi
Msg.vi (library banner color)




(Within jettl)
Base.lvlib
Queue jettl.lvclass (private)

Queue Script
Required: Name.
Checks if folder exists, saved to directory where the project resides.
Name.lvlib
Queue jettl.lvclass (private)


Event Script
Required: Name.
Checks if folder exists, saved to directory where the project resides.


Message Script
Required: Name.
Checks if folder exists, saved to directory where the project resides.