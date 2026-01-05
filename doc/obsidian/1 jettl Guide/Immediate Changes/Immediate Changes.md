

---

Attributes includes Parent Attributes: That way these static attributes can be shared across actors? By further accessing parents parents, can look at the `Read Root.vi` to find if the parent is the root.

---

how msg forwarding can be implemented to parent:
An actor can recurse through it's parents parents parents, etc at look each parents unified msg set.

---

revisit `listened to msg` boolean to properly set to false at the end at `Can Stop.vi` function.
Maybe listened to msg is a `write listened to msg.vi` which happens only before calling the call method.
that means take away from `inspect.vi` and `call.vi`

---



---

look back into `call.vi`