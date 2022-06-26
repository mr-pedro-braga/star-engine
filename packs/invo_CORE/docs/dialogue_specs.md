# Inner Voices Dialogue Specification

Inner Voices uses StarScript for its dialogues.

```coffeescript
--MyDialog
    - claire : Hello there
    - bruno  : Oh, hello, Claire!
    -   ||   : How has it been?
        "Great", positive:
            - claire, smiling : It was great, honestly.
            - bruno, shocked : Oh, who would have thought?
        "Terrible", negative:
            - claire : It sucked lots.
            - bruno, calledit : Called it. 
    await action bruno
        mvto wastebin
        wait 2.0
        sfx "Throw.ogg"
        await animation throwtrashatbin
        sfx "EpicFail.ogg"
    - claire : Epic fail!
    item give 1 trash to claire
```

Here follows the list of all usable commands.

# List of all usable commands.

```yaml
# You can create comments by preceding a line with a # symbol.

# Each line follows the following construction.
<name> <parameterss>
    <sequence of commands or properties>

# A line can be a COMMAND, in which case it DOES something.
log Printing a message!

# A line can be a property, in which case it defines a property in the current block.
value: 10
--value2 30

# Your dialogue must be organized into sections.
# That means a file contains several dialogues.
# You can create a dialogue section by using '--'
# Anything idented under it belongs to it.

--section
    command1
    command2
    value: 10
    value2: 30

# Commands get evaluated sequentially, while properties are simply values of the current block;

# In Dialogues, your writing will be played from sections, sequentially.

# You can create a simple narration by using *

* There appears to be a snake in the trash can.

# In any Inner Voices dialogue, formatting rules will apply.

# Dynamic Value Insertion / Interpolation
* You currently have $DATA_STAT_MONEY_claire dollars!

# Mid-writing pause
* I think¢¢ we can thing more.

# BBCode + some special tags
* I think he must be waiting at [important]the grocery store[/important].
* Maybe it was [evil]Oscar[/evil].

# Waiting for input mid-text.
* I think it's true.@ I wouldn't risk it, though.

# Toggle typewritting mid-text.
* I did not drink ^*burp*^ the soda.

# To create a dialogue spoken by a character, use (-) instead.
- claire : Hello there.

# To add expressions, use a , plus your parameters
- claire, smiling : What a beautiful day today, isn't it?

# You can use properties to edit qualities of the dialogue
- claire : This is strange...
    voice: higher

# You can create choices under dialogues.
- claire : What should I eat today?
    choice "Banana" item_banana:
        - claire : I guess it's banana.
    choice "Avocado" item_avocado:
        - claire : Gotta go make some guacamole, yeah!

# You can manipulate the inventory.
# The syntax tries to look a lot like natural language.
item give claire peperoni_pizza 1
item take claire guacamole 1
item clear claire
item has claire peperoni_pizza # If claire has a certain item, returns true

# You can interact with the audio API
sfx Boom.ogg
bgm load mus_hearts_in_sync.mp3
bgm play
bgm pause
bgm play
    from: 2.3

# You can interact with the battle API
battle trigger battle1 # Battles are Nodes which exist in the scene tree.
battle finish # Finishes a battle if you're currently in one.
stat claire HP damage 3
stat claire SP heal 2
stat claire MHP get # Returns the stat
stfx claire apply Freeze # Applys a status effect
stfx claire clear
stfx claire clear Freeze
stfx ARENA  apply Incandescence
stfx ARENA  clear Fasting
```
