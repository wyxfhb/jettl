**Introduction to jettl**

**picture of VIPM jettl package, most recent.**
*Download on VIPM, search `jettl`.*

**Resources of Inspiration**
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)
- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)

Please check out the github, VIPM, and youtube for more information.

At the end with further topics, list them with already made videos links for all.






**Style Guidelines**

Have methods be default private
Maybe change LabVIEW .ini files to create methods with a default of private with methods having read text.

Prefer to use read only methods and write only methods to property nodes read and writes

Just a rule, to better see banner encapsulation, do not use property nodes for accessors.
Also, in part since property nodes aren’t supported for interfaces.

Don’t wire things on the top of the connector pane unless function is made for wrapping functionality of an object. REALLY provides for excellent readability for object based method calls to ensure data flow is followed. If there are too many inputs, create a cluster type def.

Only supports 4x2x2x4 conn pane methods and functions for rescripting actions in accordance to conn pane guidelines

Aside from object / error terminals methods / functions should have zero, one, or two inputs.

Readability: Aside from the error wires (which should be moved to the back for all block diagrams), ensure no wires overlap each other for a maximally readable diagram.

Why is there the box in the default class icon? Please delete this, we change the colors of our banners and wires and rarely do we use that different colored cube as a meaningful icon. Yes, we know it is a class already. And yes, it’s distinguished since an interface doesn’t have it. They’re already easy to tell apart






**Idea: Messages with outputs**

Only available in the component. but wired through the interface message.
Application reason: Actors that wrap other actors can use the data output for i.e. logging for that actor itself. So if the method is executed has an output of the analyzed data, then in the next wrapped layer, this output can be used for logging.





**Value in Code decoupling**

The value in decoupling from the framework, then you can test the code without the framework, you can use the code without the framework, don't have coupling (which otherwise slows down load times). Being able to test the code without the framework is the advantage of code decoupling. This is the main reason that methods are public is so that the framework can be used within other frameworks.

**actor methods should be shared clone reentrant by default.**

**Any additional methods / functions created by the developer should be private to the actor. The only methods/functions that should be public are the actor API and messages.**

**Constructors (`Init.vi`) shouldn't be able to throw errors**
[Errors are Values; Please Treat Them That Way - Ethan Stern](https://www.youtube.com/watch?v=8vhYLlaXaQU&list=PLvDxiIkwuMQtiOZ_WWbk6ZCXfeAKxtwo-)
This means that the `Init.vi` should not output any errors, and functionality that otherwise puts out errors should go into other methods such as `Setup.vi`.






**Connector Pane Best Practices**

Confirm that a VI adheres to connector-pane layout matches the expected pattern:
* **Object terminals (class/interface terminals)**: top-left (and top-right, if the framework requires in/out object terminals).
* **Error terminals**: bottom-left (**error in**) and/or bottom-right (**error out**).
* **Typical inputs**: two left middle and/or bottom middle terminals. Place **inputs** on the **left side** (typically two terminals) and **bottom** (typically two terminals).
* **Object Specific Inputs**: top middle inputs for functions/methods specifically designed to wrap functionality of an object.
* **Outputs**: right middle terminals. Place **outputs** on the **right side** (typically two terminals).

A Static Analyzer can ensure those reserved terminals contain **only** the expected types (e.g., prevents unrelated controls/indicators from occupying the object/error positions).

***Message Destination Best Practices***

Actor messages are only sent to valid recipients:
* Determines where messages are allowed to go for a given actor (e.g., **self**, **parent**, **child**) based on static selection a polymorphic message destination at edit time. Uses that knowledge to prevent invalid message paths if the relationship required by a message is not satisfied, an error will be generated at runtime preventing runtime messaging errors.

A Static Analyzer test can eliminate these runtime errors where a message is sent to an actor that cannot handle it.

`Not In Unified Msg Set.vi`: Even if the framework filters messages correctly at runtime, add a defensive fallback by decorating the message-handling code in a case structure that safely handles “received but not implemented” messages. This should never occur under normal operation, but it provides a clear debugging signal if a framework or configuration defect allows an unexpected message through.

**Static Child UIDs**

The goal is a fully static, deterministic system that still supports dynamic behavior. In practice, that means the `Static Child UIDs.ctl` is static.

Under the hood, UIDs are stored as strings in `Child Attributes Map.ctl`, but the `Static Child UIDs.ctl` enum is the developer-facing abstraction. The enum represents the different UIDs used for child actors. Because each actor defines its own private enum, the runtime mechanism is a string mapping that can be validated to ensure it only maps enum elements to their corresponding string values.

This provides two benefits:
* Actor code uses enums exclusively, avoiding the fragility of stringly-typed identifiers.
* The internal string representation remains compatible with mapping needs.

The enum currently is edited manually.


**Lifecycle**

Maintain symmetry across the key lifecycle pairs:
* **Spawn ↔ Stopped**
* **Setup ↔ Teardown**
* **Start ↔ Stop**

This gives you a predictable flow—especially useful when implementing the topology as a procedure.

Procedural topology:

Below is the same content reorganized into a clean call tree, preserving intent while making the execution order explicit.

```text
Top Actor
├─ Init (method)
├─ Decorator (method)
└─ Spawn (function)
   └─ Spawn (method)
	 └─ Actor (function)
		└─ Actor (method)
		   ├─ Setup (function)
		   │  ├─ Setup (method)
		   │  ├─ Start (method) (or Teardown (method) in case of error)
		   ├─ Msg Handler (function)
		   ├─ Error Handler (function)
		   ├─ Stop (method)
		   └─ Teardown (function)
			  └─ Teardown (method)
```

Two-lane sequence diagram (Actor lane and Spawning Actor) with message arrows.
**Actor:**
1. `Init` (method)
2. `Decorate Core Actor` (function)
3. `Spawn` (function)
**Spawning Actor:**
4. `Actor` (function) → `Actor` (method)
5. `Setup` (function)
6. `Msg Handler` (function)
7. `Error Handler` (function)
8. `Teardown` (function)


**Structured approach for developing layered actors**

**Layers:** Top Layer Actor, Intermediate Layer Actor(s), Core Actor

**Local vs. Unified Actor**
- A **local actor** represents a single layer.
- A **unified actor** represents the unification of multiple layers into one logical actor.
- This maps cleanly to having both a **local message set** (per layer) and a **unified message set** (across the unified actor).

#### Decouple UI and event handling from actor functionality

A primary goal is to separate **UI/event handling concerns** from **business logic**.

**Top Layer responsibilities**

- Owns **message handling** and **UI work**.
    
- Does not need to implement messages that belong exclusively to intermediate layers.
    
- Can therefore be implemented as a standard **UI/event loop** that forwards or translates messages as needed.
    

**Intermediate Layer responsibilities**

- Contains the **business logic**.
    
- Is developed independently of any UI surface or front panel concerns.
    

---

#### Two actor types for development

To reinforce separation of concerns, support two kinds of actors:

1. **Intermediate-layer actors**
    
    - Pure business logic.
        
    - No front panel requirement.
        
2. **Outer/top-layer actors**
    
    - UI and event handling wrappers.
        
    - Responsible for user interaction, message routing, and presentation concerns.
        

A reusable **General Outer Layer Actor** can wrap intermediate actors that do not have a front panel, providing a consistent UI/event-handling shell without contaminating the intermediate layer with UI requirements.

---

#### Interface alignment for composability

To enable flexible combinations:

- The **intermediate actor** and **top-layer actor** can implement a shared interface for common functionality.
    
- This makes it easy to compose and swap layers while keeping UI/event handling decoupled from business logic.
    

---

#### Result

Intermediate actors can be designed and iterated on strictly for correctness and domain behavior, while top-layer actors handle UI and event orchestration—allowing both layers to evolve independently.

**Q1:** How would the unified message set be derived from local message sets—union, translation layer, or explicit adapter mapping?  
**Q2:** What rules should determine whether a message belongs to the top layer versus an intermediate layer (e.g., “UI-only,” “domain-only,” “cross-cutting”)?  
**Q3:** Should the shared interface be minimal (e.g., lifecycle + routing) or richer (e.g., state queries, diagnostics, capability discovery), and what tradeoffs come with each?



### Decisions Behind the Design

The Teller and Attributes libraries are implemented as libraries containing interfaces and classes rather than collections of typedef clusters.

- **Encapsulation and controlled initialization**  
    Classes encapsulate private data. Using `Init.vi`, the class private data is instantiated a single time, after which multiple **read-only** methods provide access. This enforces the intended lifecycle and prevents developers from directly modifying the underlying data (a risk that is difficult to avoid with typedef clusters).
    
- **Read-only access can be enforced with interfaces**  
    Interfaces allow us to define and enforce read-only access patterns through method contracts. Typedef clusters do not provide a comparable mechanism to restrict writes—any caller with the cluster can modify it.
    
- **Accessor discoverability and maintainability**  
    A common best practice is to avoid clusters in favor of objects with explicit accessor methods, since access points are easier to locate and reason about. These accessors are implemented as **method calls**, not property nodes.
    
- **Messaging is optional for usage**  
    It is also common to be used without messages, depending on the use case and architecture.
    

**Q1:** How strictly should `Init.vi` enforce one-time initialization (error on re-init vs. no-op vs. replace)?  
**Q2:** Which read-only access patterns are you standardizing on (getters only, snapshot copies, iterators, or query methods)?  
**Q3:** In what cases do you expect running without messaging, and what tradeoffs are acceptable in those scenarios?


### Statically showing relative message destinations

Define, at edit time, which messages are routed to which child actor.

You can do this with scripting by locating calls to `Send to child.vi` and then resolving the target child by tracing the input back through the `Format Into String` primitive to the associated enum. This lets the tooling determine the destination name statically, so it’s clear where the message will be sent at run time.

This approach only works when the destination string is a straightforward `Format Into String` + enum pattern. If the string is modified elsewhere, built dynamically, or selected via conditional logic (for example, choosing between two enums), the script will not be able to reliably infer the destination.

For clarity and maintainability, keep message routing as static as possible: use an enum wired into `Format Into String` to represent the child target, and avoid intermediate string manipulation or conditional destination selection when you want tooling to accurately show message destinations.

**Q1:** How strict should we be about enforcing the `Format Into String` + enum pattern for routing—guideline, lint warning, or hard rule?  
**Q2:** What are the most common cases where we currently build destination strings dynamically, and can those be refactored into explicit enum-based routes?  
**Q3:** Should the scripting tool fail silently when it can’t resolve a destination, or annotate the call site with “dynamic/unknown destination” and why?

### Statically Typed Messages

What is the value of a strongly typed messaging system when the message destination is known at edit time?

A compile-time analyzer (e.g., VI Analyzer tests) can determine which actors are allowed to launch which other actors based on message contracts in both directions:

- What the parent can **send to** and **receive from** its child.
    
- What the child can **send to** and **receive from** its parent.
    

This reduces runtime errors by enforcing the contract between a launching actor and the actor it creates. In other words, if an actor creates another actor, the type system and analyzer checks ensure the creator abides by the child’s message interface—and the child abides by the parent’s interface—before anything runs.

Additionally, documentation tooling can leverage these static contracts to show exactly which messages flow to and from `Self`, and where they are used.

##### Message directions relative to `Self`

With respect to `Self`, there are five meaningful categories of messages:

- `Self → Self`
    
- `Parent → Self`
    
- `Child (with UID) → Self`
    
- `Self → Parent`
    
- `Self → Child (with UID)`
    

(`Self ← Self` is redundant and can be omitted.)

> **Scripting constraint:** Only the two left input terminals are valid for scripting message inputs. Other inputs are ignored during scripting.  
> If more than two inputs are required:
> 
> - Define a typedef cluster in the message library, or
>     
> - Bundle messages by using messages as inputs to other messages—while ensuring you do not introduce recursive message calls (i.e., messages calling each other in a cycle).
>     

**Q1:** **How should the analyzer represent and validate parent/child message contracts when an actor can have multiple child types or multiple child instances?**  
**Q2:** **What rules would you enforce to prevent accidental recursive message bundling, and how would you surface violations to the developer?**  
**Q3:** **What should the generated documentation include to make message flow and ownership (Self/Parent/Child UID) unambiguous in large systems?**





### Philosophical

Start from the abstract. In architecture work, the high-level structure matters more than low-level implementation details. The objective is to define modular components and the relationships between them so they compose into a cohesive system.

A common decomposition includes **acquisition**, **analysis**, **presentation/display**, and **logging**. These concerns are often coordinated as a sequence, but they should remain **decoupled**: each has a distinct responsibility and should be able to function independently of the others. This lets you define system behavior (contracts) before committing to specific implementations.

Design **from interfaces to classes**. Begin by specifying interfaces that capture the required behavior, then implement those interfaces with concrete classes.

Prefer strong, static structure and clear boundaries. Keep components modular and independent wherever possible. Dependencies are inevitable, but they should point to **abstractions** (interfaces), which tend to change less frequently than concrete implementations.

**Q1:** How would you define the core interfaces for acquisition, analysis, presentation, and logging so they stay stable as implementations evolve?  
**Q2:** What are the most common ways decoupling breaks down in practice, and what design patterns help prevent that?  
**Q3:** Where do you draw the line between “architecture-level” interfaces and “implementation-level” interfaces to avoid over-engineering?







### Style Guidelines: Connector Pane

##### 1) Class/Interface ownership terminals

* The **upper-left** terminal (and **upper-right**, if present) indicates the **class/interface wire that owns the banner method**. This signals to the developer that the VI is a **method contained by that class/interface**.
* **Library functions are not methods** and are not contained by a class/interface. As a result, **library functions must not use** the **upper-left/upper-right object terminals**.
* Reserve the **upper-left** and **upper-right** connector pane terminals **only** for the **class/interface wire** for the method that the class/interface contains.

##### 2) Mutability and readability conventions

* If a function/method outputs the **same data type on the same horizontal path** as its input (i.e., “in” and “out” match across the pane), the output should be interpreted as a **mutable handoff**.
* In other words: if the **same object type** comes in and is passed out horizontally, callers should assume **that object may have been mutated** (whether it actually was or not).
* This convention most commonly applies to:

  * The **class/interface wire** (upper-left to upper-right), and
  * The **error cluster** (lower-left to lower-right).

##### 3) Immutable pass-through is an antipattern

* If the input object is **immutable** and you are only wiring it to the output to preserve **dataflow/serialization**, that is an **antipattern** because it falsely implies mutation.
* In this case, **do not wire the immutable object to the connector pane output**.
* If you need sequencing (for example, to serialize operations), use a **Flat Sequence Structure** rather than passing the object through solely for ordering.

##### 4) Apply the same rule to the error wire

* The **error wire should not be used for serialization**.
* Wiring error in → error out should communicate **state propagation where mutation may have occurred**, not “this ran before that.”
* If you need explicit sequencing without implying mutation, **embrace the Flat Sequence Structure** (or another explicit sequencing construct) rather than relying on the error wire.

---

**Q1:** **How should we handle sequencing when we need strict execution order but want to avoid implying mutation on a class/interface wire?**
**Q2:** **What connector pane patterns do you recommend for methods that are logically “queries” (read-only) versus “commands” (mutating) in LabVIEW OOP?**
**Q3:** **Where should we draw the line between using explicit sequencing structures and restructuring code to preserve natural dataflow without serialization wires?**
