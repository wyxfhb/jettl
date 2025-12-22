#### Introduction to jettl

**picture of VIPM jettl package, most recent.**
*Download on VIPM, search `jettl`.*

**Resources of Inspiration**
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)
- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)

Please check out the github, VIPM, and youtube for more information.

At the end with advanced topics, list them with already made videos links for all.

#### Rules of Thumb for LabVIEW

A LabVIEW project should only contain one target. When developing with real time targets, these should exist in their own projects.



#### Style guidelines: Have methods be default private
Maybe when jettl is installed, have an add on that changes some .ini to create methods with a default of private for methods with text red.

#### style guidelines: Prefer to use read only methods and write only methods to property nodes read and writes

Just a rule, to better see banner encapsulation, do not use property nodes for accessors.
Also, in part since property nodes aren’t supported for interfaces.
#### style guidelines: Don’t wire things on the top of the connector pane unless function is made for wrapping functionality of an object. REALLY provides for excellent readability for object based method calls to ensure data flow is followed. If there are too many inputs, create a cluster type def.

#### jettl only supports 4x2x2x4 conn pane methods and functions for rescripting actions in accordance to conn pane guidelines

Style guidelines: Aside from object / error terminals methods / functions should have zero, one, or two inputs.

Readability: Aside from the error wires (which should be moved to the back for all block diagrams), ensure no wires overlap each other for a maximally readable diagram.

#### Style guidelines: Why is there the box in the default class icon? Please delete this, we change the colors of our banners and wires and rarely do we use that different colored cube as a meaningful icon. Yes, we know it is a class already. And yes, it’s distinguished since an interface doesn’t have it. They’re already easy to tell apart



#### Idea: Messages can have outputs

Only available in the component. but wired through the interface message.
Application reason: Actors that wrap other actors can use the data output for i.e. logging for that actor itself. So if the method is executed has an output of the analyzed data, then in the next wrapped layer, this output can be used for logging.

#### Code decoupling
[Why, When and How to Protect Your Code from the Framework - Dmitry Sagatelyan -GDevCon#5](https://www.youtube.com/watch?v=fVx8PO02fzw)
@31:48, Anton  
> Value in decoupling from the framework, then you can test the code without the framework, you can use the code without the framework, don't have coupling (which otherwise slows down load times)

Being able to test the code without the framework is the advantage of code decoupling. This is the main reason that methods do not have protected scope, so that the framework can be used within other frameworks.

#### Style Guidelines: actor methods should be shared clone reentrant by default.

#### Constructors (`Init.vi`) shouldn't be able to throw errors
[Errors are Values; Please Treat Them That Way - Ethan Stern](https://www.youtube.com/watch?v=8vhYLlaXaQU&list=PLvDxiIkwuMQtiOZ_WWbk6ZCXfeAKxtwo-)
In jettl, this means that the `Init.vi` should not output any errors, and functionality that otherwise puts out errors should go into other methods such as `Setup.vi`.






### Connector Pane Best Practices

Confirm that a VI adheres to `jettl` connector-pane layout matches the expected pattern:
* **Object terminals (class/interface terminals)**: top-left (and top-right, if the framework requires in/out object terminals).
* **Error terminals**: bottom-left (**error in**) and/or bottom-right (**error out**).
* **Typical inputs**: two left middle and/or bottom middle terminals. Place **inputs** on the **left side** (typically two terminals) and **bottom** (typically two terminals).
* **Object Specific Inputs**: top middle inputs for functions/methods specifically designed to wrap functionality of an object.
* **Outputs**: right middle terminals. Place **outputs** on the **right side** (typically two terminals).

Static Analyzer can ensure those reserved terminals contain **only** the expected types (e.g., prevents unrelated controls/indicators from occupying the object/error positions).

### Message Destination Best Practices

Actor messages are only sent to valid recipients:
* Determines where messages are allowed to go for a given actor (e.g., **self**, **parent**, **child**) based on static selection a polymorphic message destination at edit time. Uses that knowledge to prevent invalid message paths if the relationship required by a message is not satisfied, an error will be generated at runtime preventing runtime messaging errors.

A Static Analyzer test can eliminate these runtime errors where a message is sent to an actor that cannot handle it.
##### Defensive implementation recommendation

Even if the framework filters messages correctly at runtime, add a defensive fallback in `Not In Unified Msg Set.vi`: Wrap the message-handling code in a case structure that safely handles “received but not implemented” messages. This should never occur under normal operation, but it provides a clear debugging signal if a framework or configuration defect allows an unexpected message through.








### Child UIDs

The goal is a fully static, deterministic system that still supports dynamic behavior. In practice, that means the *set of child UIDs* is static and predetermined, while the *implementation* can remain flexible as long as it follows the same rules.

> If an actor needs to perform compute on behalf of multiple actors, this can be extended internally using dynamic maps (e.g., mapping a branched enum to strings). Even in that case, the default remains a static enum.

Under the hood, we still store identifiers as strings (e.g., in maps), but the enum is the developer-facing abstraction. The enum represents the different UIDs used for child actors. Because each actor defines its own child UID enum, the runtime mechanism is a string mapping that is validated to ensure it only maps enum entries to their corresponding string values.

This provides two benefits:

* Actor code uses enums exclusively, avoiding the fragility of stringly-typed identifiers.
* The internal string representation remains compatible with serialization/mapping needs.

The child UID enum should not be edited manually. Use the accompanying tool to insert, remove, or rename a child actor UID. The tooling depends on controlling these edits so it can safely rename method names and apply other required refactors.

**Q1:** How should the system handle backward compatibility when a child UID is renamed (e.g., aliases, migration rules, or versioned enums)?
**Q2:** What guarantees do we want around determinism when “dynamic maps” are used—do we require stable ordering, stable hashing, or explicit keys?
**Q3:** Should child UID enums be generated from a single source of truth (schema/config) to prevent drift between enum definitions and the underlying string mapping?







### Lifecycle

Maintain symmetry across the key lifecycle pairs:

* **Start ↔ Finish** (outer boundary of execution)
* **Setup ↔ Teardown** (resource acquisition and release)
* **Create ↔ Stop** (construction/activation and termination)

This gives you a predictable, auditable flow—especially useful when documenting (or implementing) the topology as a LabVIEW-style sequence.

---

#### Procedural topology (LabVIEW-style call flow)

Below is the same content reorganized into a clean call tree, preserving intent while making the execution order explicit.

```text
Top Actor
├─ Init (method)
├─ Decorator (method)
└─ Start (function)
   └─ Start (method)
      └─ Launch Actor (function)
         └─ Actor (function)              ← Bottom Actor entry point
            └─ Actor (method)
               ├─ Create (function)
               │  ├─ Setup (method)
               │  ├─ Create (method)
               │  └─ Teardown (method)    ← pairs with Setup
               ├─ Msg Handler (function)
               ├─ Error Handler (function)
               ├─ Stop (method)           ← pairs with Create
               └─ Teardown (function)
                  └─ Teardown (method)    ← final teardown / shutdown cleanup
```

---

#### Same flow, expressed as “phases” (alternative view)

**Top Actor (bootstrap):**

1. `Init` (method)
2. `Decorator` (method)
3. `Start` (function) → `Start` (method) → `Launch Actor` (function)

**Bottom Actor (run + shutdown):**
4. `Actor` (function) → `Actor` (method)
5. `Create` (function)

* `Setup` (method)
* `Create` (method)
* `Teardown` (method) *(paired with `Setup`)*

6. `Msg Handler` (function)
7. `Error Handler` (function)
8. `Stop` (method) *(paired with `Create`)*
9. `Teardown` (function) → `Teardown` (method) *(final shutdown cleanup)*

---

**Q1:** **Do you want `Teardown (method)` inside `Create (function)` to run only on error, or always (i.e., `finally` semantics)?**
**Q2:** **Should `Finish` be an explicit step mirroring `Start`, and if so, where should it sit relative to `Stop` and the final `Teardown`?**
**Q3:** **Do you want this rendered as a two-lane sequence diagram (Top Actor lane vs Bottom Actor lane) with message arrows, or is the call-tree view sufficient for your documentation?**







### A structured approach for developing layered actors

**Layers:** Top Layer, Intermediate Layer(s), Core

**Local vs. Unified Actor**

- A **local actor** represents a single layer.
    
- A **unified actor** represents the composition (unification) of multiple layers into one logical actor.
    
- This maps cleanly to having both a **local message set** (per layer) and a **unified message set** (across the composed actor).
    

---

#### Decouple UI and event handling from actor functionality

The primary goal is to separate **UI/event handling concerns** from **business logic**.

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





















