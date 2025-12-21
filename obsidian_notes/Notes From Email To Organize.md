#### Introduction to jettl

Download on VIPM:

![[Pasted image 20251213105633.png]]
*VIPM search `jettl`.*

> A note on LabVIEW version: This library is compatible with LV 2020 and beyond. If using LV2020, please consider using LV 2020 SP1 and beyond due to issues resolved here: [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html?srsltid=AfmBOooUbuV9waHiF74KkrteQY7SRCENumzj1XCdQMWldAIuQMDW1sM6)

**Resources of Inspiration**
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)
- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)

Please check out the github, VIPM, and youtube for more information.

At the end with advanced topics, list them with already made videos links for all

#### Decisions Behind the Design

Sender and Attributes libraries that include interfaces and classes, instead of just type def clusters:
Classes encapsulate private data. With the `Init.vi`, the classes private data can be instantiated only once and multiple read only methods are available to read the private data. This is expected behavior. This combats the developer from modifying otherwise type def cluster data.

Keep interfaces methods for read only access enforced, clusters cannot do that.

It is somewhat best practice to NOT use clusters, and rather use objects with accessor methods to easily find accessors.
On this note of accessors, these are not property nodes but rather method calls.

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

In respect to Self, there are five kinds of messages:
- Self -> Self
- Creator -> Self
- Created (with name) -> Self
- ~~Self <- Self (redundant)~~
- Creator <- Self
- Created (with name) <- Self

> For messages, only the two inputs are allowed for scripting. Messages are only scripted using the two left inputs, other inputs are ignored when scripting. If more than two inputs are needed, then either create a type def cluster in the message library or for bundled messages, have messages be inputs for other messages ensuring recursion of calling each others messages does not occur.

#### Scripting which messages go to which created actor
*Here we can use scripting to find where the `Send to Created.vi` is called and find the associated enum by traversing through the `format into string` primitive. This will find the name to properly understand where the message will go at run time, in edit time. If there is something between this string or there is a conditional that uses either of two enums, then the scripting will not understand this. Best to be static with which messages will go where for an easier to understand actor by using the `format into string` and enum.*
#### `Find Created Attributes.vi` not named `Read Created Attributes.vi` since not necessarily a read operation and can produce an error from alias not being found.

#### Style guidelines: Have methods be default private
Maybe when jettl is installed, have an add on that changes some .ini to create methods with a default of private for methods with text red.
![[IMG_7575.png]]

#### style guidelines: Prefer to use read only methods and write only methods to property nodes read and writes

Just a rule, to better see banner encapsulation, do not use property nodes for accessors.
Also, in part since property nodes aren’t supported for interfaces.
#### style guidelines: Don’t wire things on the top of the connector pane unless function is made for wrapping functionality of an object. REALLY provides for excellent readability for object based method calls to ensure data flow is followed. If there are too many inputs, create a cluster type def.

#### jettl only supports 4x2x2x4 conn pane methods and functions for rescripting actions in accordance to conn pane guidelines

#### Style guidelines: Aside from object / error, methods / functions should have zero, one, or two inputs.

Readability: Aside from the error wires (which should be moved to the back for all block diagrams), ensure no wires overlap each other for a maximally readable diagram.

Method: ONLY use the conn pane panels to the side.

Function: CAN use the conn pane panels on the bottom and top if necessary.

Difference between function and method: method has object input (output may not be necessary since this is a return value)

#### Style guidelines: Why is there the box in the default class icon? Please delete this, we change the colors of our banners and wires and rarely do we use that different colored cube as a meaningful icon. Yes, we know it is a class already. And yes, it’s distinguished since an interface doesn’t have it. They’re already easy to tell apart

#### Style Guidelines: Conn Pane
The object in the top left (and top right if it exists) signifies to the developer that this object is the object that is contained in the class / interface of the banner.
Note, library functions cannot be methods and furthermore cannot have objects at the top left / top right since the library function is not contained in an interface / class.
Therefore only the top left and top right conn pane terminals are used for the interface / class that contains that method.

Mutability readability:
If a function / method passes out the same data type as is horizontal to the input, then this is a mutable change to that piece of data.
For example, object comes in is the same object that comes out horizontally means that the object is assumed to have been mutated (whether it has been mutated or not). This is most common for the top left and top right interface / class and the bottom left and bottom right Error. 
To combat this, if the object that comes in is immutable and the same object is passed OUT of the method, this is an antipattern since the object out is the same as the object in. Hence, the object at the output should not be on the connector pane output. If dataflow is required (such as serialization of the error wire), then the flat sequence structure should instead be used instead of wiring the object to the output for serialization. This same principle should carry over for the error wire. The error wire should not be used for serialization, this signifies to the developer NOT serialization but that the object at the output HAS BEEN mutated from the object at the input. Embrace the flat sequence structure for serialization!

#### Future Idea: Messages should have outputs?

Reason: Actors that wrap other actors can use the data output for i.e. logging for that actor itself. So if the method is executed has an output of the analyzed data, then in the next wrapped layer, this output can be used for logging.

#### Code decoupling
[Why, When and How to Protect Your Code from the Framework - Dmitry Sagatelyan -GDevCon#5](https://www.youtube.com/watch?v=fVx8PO02fzw)
@31:48, Anton  
> Value in decoupling from the framework, then you can test the code without the framework, you can use the code without the framework, don't have coupling (which otherwise slows down load times)

Being able to test the code without the framework is the advantage of code decoupling. This is the main reason that methods do not have protected scope, so that the framework can be used within other frameworks.
#### Created Aliases

Ideally, we want a fully static deterministic system with dynamic capabilities. For example, some things are static and predetermined, whereas the implementations can be dynamic if these static things follow the same rules.

> If there is some actor that needs to perform compute of multiple actors, then this can be extended internally to be dynamic with maps mapping a branched enum with strings. Nonetheless, the default will be a static enum.

Under the hood we still use strings in the map, etc. but nonetheless, the enum is the higher level shown to the developer of the actor. Enum is for the different aliases used for created actors, but since the enum is different from actor to actor, the mechanism under the hood is a string mapping, which is internally checked to only map Enum entries to their string counterparts. This ensures only enums are used in the implemented actors code without depending on the fragility of strings.
Note, the created enum should not be altered by the developer, instead use the accompanying tool to insert, remove, or rename a created actor alias. This is due to the scripting tool requiring renaming method names, etc.
#### Style Guidelines: actor methods should be shared clone reentrant by default.

#### Naming
Symmetry in:
- Start and Finish,
- Setup and Teardown, and
- Create and Destroy.
Topology for the procedural execution of methods in a LabVIEW style sequence diagram. Could even write this in LabVIEW where the methods used on top for top actor and bottom for bottom actor showing which methods are being executed such as:
`Init` method
`Decorator` method
`Start` function
	`Start` method
		`Launch Actor` function
			`Actor` function
				`Actor` method
					`Create` function
						`Setup` method
							`Teardown` method
						`Create` method
					`Msg Handler` function
					`Error Handler` function
					`Destroy` method
					`Destroy` function
						`Teardown`
#### Style Guidelines: Boolean prefixes
is_
has_
can_
should_
enable_
#### Periodic Messaging
An actor should not have in its own timeout way to do something periodically such as send itself a message every 100 ms.
Instead it must create a periodic messaging actor which in its timeout sends the message to the actor that requires the periodic message. Separate the concerns.

#### VI Analyzer

Checks if the connector pane is correct. i.e. objects on top left and maybe right for containing class / interface.
errors on maybe bottom left and maybe bottom right.
Discriminates other types from existing in these conn pane terminals.
Best practice too: nothing wired on top, outputs only on right side (two terms), inputs only on left side (two) and bottom (two).

For looking at where messages can go in an application i.e. for a given actor, the analyzer knows where messages go i.e. creator, self, created since statically dropping the polymorphic function at edit time. Therefore, this analysis can ensure that applications will not run if the relationship of two actor messages is not satisfied. This prevents messaging runtime bugs since messages cannot be sent to an actor that cannot accept them.
> Maybe just be sure, have a case structure around the code in the `Msg.vi` in case a message is received but not implemented. This should be prevented by the framework since filtering is done upon every message execution, but in case of a bug, this will be useful for debugging.

#### constructors shouldn't be able to throw errors
[Errors are Values; Please Treat Them That Way - Ethan Stern](https://www.youtube.com/watch?v=8vhYLlaXaQU&list=PLvDxiIkwuMQtiOZ_WWbk6ZCXfeAKxtwo-)
In jettl, this means that the `Init.vi` should not output any errors, and functionality that otherwise puts out errors should go into other methods such as `Setup.vi`.

#### Unique way to develop layered actors
Note: Top Layer, Intermediate Layer(s), Core.
Local Actor and Unified Actor Definition: A local actor is a single layer whereas the unified actor is the unification of layered actors. This translated well to the local msg set and the unified msg set.
**Decoupling the UI and event handling from the actors functionality!**
Top layer is only for the message handling and UI work, whereas the intermediate layer is where the business logic exists. Since the top level doesn't need to implement the messages the intermediate layers have, then the top layer can just be a typical UI / event handling loop. For example, have two kinds of actors that developers can develop i.e. intermediate layer actors and outer layer actors. That way, some `General Outer Layer Actor` can be used to wrap intermediate actors that do not have front panels.
The intermediate actor and the top level actor can implement the same interface for common functionality between them so that different combinations can be made effectively decoupling the UI / event handling from the business logic.
This way the intermediate actors are the ones being developed for their logic, independent of the UI element.



Finish message method private?



Have a conditional Boolean to disable the checking in the mass handler
In case this is necessary for Network Streams later?
Default is True: “Check Within Unified Msg Set”







Tell.vi, replace places to not have input be where error in is.