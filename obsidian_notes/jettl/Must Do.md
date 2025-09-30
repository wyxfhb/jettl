Have a *private* cluster to jettl.lvlib called **Actor Attributes.ctl**
- Alias
- Msg Event
- Msgs
This replaces the **Created.ctl**

**Set of Actor Attributes.ctl** which is a set of **Actor Attributes.ctl**.


Note that even though the clusters will be unique, the aliases **themselves** will be be check with a new method **Is Unique Alias.vi** which checks if the alias is unique within the **Set** called Created.

Rename *jettl.vi* -> *Actor.vi*
Rename *Relation.ctl* -> *Relative Relation.ctl*


Maybe some kind of central Set of Actor Attributes WITH the *Relative Relation.ctl* also in the **Actor Attributes.ctl**