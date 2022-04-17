# The Menu Class!!!

Menu should be a component class (yellow) that handles menus and can seamless, complex, flexible menu trees.

An example of a written down Menu tree:
```
Example Battle Menu [Array]
	Claire [Choice]
		Attack [Choice]
			Weakling Punch [Leaf]
			Bubbles [Leaf]
			Empty Choice [Leaf]
		Skill [Choice]
			Memory Foam [Leaf]
			Memoria Clavem [Leaf]
			Amnesia [Leaf]
		Act [Choice]
			Talk [Leaf]
			Loiter [Leaf]
			Threaten [Leaf]
		Item [Choice]
	Andy [Choice]
		Attack [Choice]
			[...]
		Skill [Choice]
			[...]
		Act [Choice]
			[...]
		Item [Choice]
			[...]
```

Every branch should actually be a completely new Node, instead of items in a fixed tree. This allows branches of the tree to be created dynamically and to not have knowledge of each other apart from the references in runtime.

This class has no actual behaviour on its own, you should use some menu handler to control the selection, and use its signals to handle its behaviour.

(In 4.x, you can use lambdas to create Menus easily, especially throwaway ones!!!)

## Some Code

**Menus in general have these members:**
```
signal on_index_changed(index)
signal on_selected(index)
signal on_updated()
signal on_cancel

var is_active : bool -> Whether this menu is being used (should be visible) at the moment.
var is_current : bool -> Whether this menu is supposed to be interacted with.
var has_open_submenu : bool -> If this menu is waiting for the response of a submenu.

var current_index := 1
var max_index := 3
var choices := [Choice1, Choice2, Choice3]
var _open_submenu : Menu

func select(index) -> [...]
func cancel() -> [...]
func accept() -> [...]
func from_array(array) --> Loads the submenus from an array of option... tries to keep the same item selected if it's a Reference.
func insert(node, position) --> Inserts a node somewhere. If necessary, the current index will be updated and call on_updated, but on_index_changed will not be called.
func remove(index) --> The object at index is removed. If necessary, the current index will be updated and call on_updated, but on_index_changed will not be called.
```
### There should be two types of menus:

**"Choice" menus have a list of choices you can choose.**

Selecting a choice that is not a submenu of courses, trigger a signal, and then once you use that information you can call the function 'accept' on a parent menu.

Selecting a choice that is itself a Menu makes the Menu halt (is_current set to false) and pass its 'current' status to it as it awaits the submenu's completion... the menu keeps is_active just in case its submenu cancels.
It also activates 'has_open_submenu.'

The function 'accept' deactivates the Menu and calls accept on its active submenus.
If this Menu is a submenu of another Menu, it will pass the 'current' status to it (the supermenu), and deactivate 'has_open_submenu' on the supermenu (but not on itself.)
('Accept'ing a menu keeps its selected index intact.)

**"Array" menus have a list of Menu nodes it will call in sequence.**
```
var smenu_index := 1
var max_smenu_index := 3
var smenu_nodes = [BMenuClaire, BMenuAndy] # As references!!!
```
When 'accept' is called on one of its submenus the index increases, unless the index is 'max_smenu_index', which then calls 'accept' on the Array Menu itself.

When 'cancel' is called on one of its submenus the index decreases, unless the index is 0, which then calls 'cancel' on the Array Menu itself.

When a menu is selected that has 'has_open_submenu,' it will immediately select that submenu's selected sub-submenu -- this way you can take things from where you left it.

Example: If you chose "Memoria Clavem" on the example menu on the top of this documentation, accept will be called on the "Claire" menu, moving the cursor to the "Andy" menu. But lets say you suddenly became regretful of your choice for Claire.

Calling 'cancel' on "Andy" will make "Claire" be selected again, which calls "Skill" to be selected, which then highlights "Memoria Clavem" but doesn't select it. From there you can select a different skill -- or call cancel further.
























