#### Introduction to jettl

Download on VIPM:

![[Pasted image 20251213105633.png]]
*VIPM search `jettl`.*

> A note on LabVIEW version: This library is compatible with LV 2020 and beyond. If using LV2020, please consider using LV 2020 SP1 and beyond due to issues resolved here: [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html?srsltid=AfmBOooUbuV9waHiF74KkrteQY7SRCENumzj1XCdQMWldAIuQMDW1sM6)

**Resources of Inspiration**
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)
- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)

#### Decisions Behind the Design

Sender and Attributes libraries that include interfaces and classes, instead of just type def clusters:
Classes encapsulate private data. With the `Init.vi`, the classes private data can be instantiated only once and multiple read only methods are available to read the private data. This is expected behavior. This combats the developer from modifying otherwise type def cluster data.

It is common that `jettl` can be used without messages.

#### Rules of Thumb for LabVIEW

A LabVIEW project should only contain one target. When developing with real time targets, these should exist in their own projects.

#### Philosophical

Start from an abstract perspective. During architecture work, high-level structure matters more than low-level implementation details. The goal is to define modular components and how they fit together into a cohesive system.

A common design decomposition includes **acquisition**, **analysis**, **presentation/display**, and **logging**. These concerns are often orchestrated in a sequence, but they should remain **decoupled**: each has a distinct responsibility and should not require the others to function. This allows you to define system behavior (contracts) before committing to specific implementations.

Design **from interfaces to classes**. Begin by specifying interfaces that capture the required behavior, then implement those interfaces with concrete classes.

Favor strong, static structure and clear boundaries. Keep components modular and independent wherever possible. Dependencies between objects are inevitable, but you should make those dependencies point to **abstractions** (interfaces), since abstractions are less likely to change than concrete implementations.

#### Static Typed Messages

What is the point to having a strongly typed messaging system where at edit time the message destination is known?
compile time VI analyzer tests can tell which actors can launch which actors, dependent on which messages the creator can accept and send to it's created actor and also the messages the created actor can accept and send to it's creator actor. This will cut down on run time errors, ensuring that an actor that creates another actor will abide by the contract of messages of it's created actor and vice versa.
Further, documentation tools can be used to know exactly where what messages are passed to and from the Self.

In `Name Msg.lvclass`, include
`Name.vi`
`Msg Polymorphic.vi`
`Self.vi`
`Creator.vi`
`Created.vi`

In Actor Class:
`Name.vi` (Created DAQ) (private?)
`Name Created.vi` (private?)


**should we avoid the -- flag?**

In respect to Self, there are five kind of messages:
- Self -> Self
- Creator -> Self
- Created (with name) -> Self
- ~~Self <- Self (redundant)~~
- Creator <- Self
- Created (with name) <- Self

#### Change the function calls to have object inputs at the top if the function is intended to wrap functionality of an object specifically.


