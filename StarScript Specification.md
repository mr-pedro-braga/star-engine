# StarScript Specification

## Introduction

StarScript is a Domain-Specific Language used in Star used to interact with the framework's so-called "Shell."

The Shell is a server that contains an abstracted API for interacting with the game's sevearl cores (Dialog, Cutscenes, Data, Items, et cetera).

Usually, calls to the cores involves an access syntax like this:

```gdscript
Game.Audio.sfx("sfx_item_acquired.ogg")
Game.Data.Inventory[Game.Data.party[0]].give_item("pepperoni_pizza", 1)
Game.DC.dialog_write("narrator", "You got a pepperoni pizza!")
```

It's clear and concise, but a bit of a mouthful.

Writing `Game.DC.dialog_write` is necessary to explain what you want to do in GDScript, but it's obvious in the context of a cutscene.



That's why StarScript exists, to make your life easier.

```coffeescript
sfx sfx_item_acquired.ogg
item give $player pepperoni_pizza 1
* You got a pepperoni pizza!
```



## Table of Contents

1. [Introduction](Introduction)

2. Table of Contents (You are Here)

3. Syntax

4. API



## Syntax

The entire language consists of a simple sequential-term syntax.

```
<keyword> [:] [<parameters>]
[    <block-of-code>]

# The command's keyword
# An optional colon symbol separating the keyword from the rest
# An optional set of parameters
# An optional tab-indented block of code.
```

Different commands have different requirements for what part of the syntax should be present.

```
# Some require nothing but the keyword
save
load
exit

# Some use one (or more) parameters
sfx my_sfx.ogg
save "Backup Save" false

# Some use subcommands (parameters that decide how the
# other parameters should be interpreted).

item give claire peperroni_pizza 1
item clear claire
```

If you include the `:` symbol after the keyword, the statement becomes a 'property.'

```
value: 3
othervalue: 5
thirdvalue: "Efficiently destroyed"

# An alternative to using the colon is to precede the keyword by '--'
# Two 'minus' signs.

--value 4
--othervalue 5

# This syntax has identical functionality to the other one but
# offers special syntax highlighting for the purposes of
# distinguishing properties from named blocks of code.
```

Finally, there are code-blocks, which is an idented block of text containing several statements separated by line breaks;

```
value:
    item give claire pizza 1
    item take claire pizza 2   # It can contain a sequence of commands
    value: 5                    # And properties, too!
```

To execute StarScript with the purposes of a dialogue, you should write your dialogue commands as blocks of code under "sections" (which are properties).

```
--dialog1
    item give claire pizza 1

--dialog2
    sfx my_sfx.ogg
    bgm restart

dialog3:
    * The colon notation also works but looks weird.
```

All the commands are executed one after the other in the order they appear.

Most commands will halt the execution of the script until it finishes, but not all of them.



The following section will list and explain all the commands available to use in the default package of StarScript.



## API

### Dialogue and Cutscenes

The `*` keyword does simple narration. Yes, `*` is a _keyword._ The Syntax follows.

```
* <content>

# Examples:

* You found something...
* It makes a strange sound...?
```

The `-` keyword does more advanced dialogue calls. The syntax is the following:

```
- <speaker_name>[, <expression>[, <tone_indicator>]] : <speech>
    [<dialog-properties>]

# Examples

# The simplest form
- Bruno : Hello, I'm Bruno.

# With an expression for the portrait
- Bruno, smiling : I'm happy!!!

# With tone indicator
- Bruno, wink, hj : I could eat a hundred of these right now.

# With special properties
- Bruno : I'm so sad.
    voice : sqr_lower.ogg
    speed_scale : 2
```

The actual content of the dialogue supports BBCode + some typewriting syntax.



The `action` keyword allows the script to do sequential calls to Character actions and motions.

```
action <character>
    <actions>

# Example:

action Bruno
    mvto 0 32
    mvadd 0 64
    face SOUTH
    wait 2.0
    mvadd 0 32
action Claire
    face Bruno
```



The `wait` keyword makes the script wait until an event happens (or for a duration of time).

```
wait   

# Waits for the previous command to finish in case it was an action

wait 2.0

# Waits for 2.0 seconds
```



### Party

Use `party` to modify the characters in the main party.

```
party join <character> # adds <character> to the party
party leave <character># removes <character> from party
party has <character>  # checks if <character> is on the party
party lead <character> # <character> is now the party lead
```



### Item Management

```
item give <character> <item_name> <amount>
item take <character> <item_name> <amount>
item has <character> <item_name>
item clear <character>
```



### Save and Load

```
save
save <file_name>
load
load <file_name>
```



### Audio and Visual Effects

```
sfx <path>
vfx <path>
bgm load <path> <display_title>
bgm play
bgm pause
bgm restart
bgm stop
```

You can set the sound folders using `Shell::set_sfx_path`, `Shell::set_vfx_path`, `Shell::set_bgm_path` so you don't have to use full paths.














