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

## Future Scripting

- Creating template for `Queue Actors` / `Event Actors`
- Creating Messages

## documentation

look in the `doc` folder, and older documentation in the `doc_old` folder

![](README-images/hierarchy.png)
![](README-images/queue-actor-method.png)
![](README-images/event-actor-method.png)
