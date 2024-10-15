# User Made


## Libraries:
  The use of the word **directly** is important.  In this context, directly
  refers to behavior that can happen by merely importing a library. It does
  not mean that a library cannot provide the **means** to achieve said behavior. 
  A library is not responsible for decision making. Its sole responsibility is to 
  provide the code or data, never to execute it. Kind of like a courier who can't 
  peek inside their parcel.

They:
  - Cannot **directly** define or alter ex commands, autocmds, highlights, namespaces, etc.
  - Cannot **directly** alter the state of the editor or any global Vim variables.
    - Can define __new__ global Vim variables however that are not already in use.
  - Can export Lua code and define globally scoped Lua classes/enums/vars/magic numbers, etc.
  - Can be an [Event](../01-prelude/02-event-system.lua) sender.
  - Cannot be an [Event](../01-prelude/02-event-system.lua) receiver.

  In essence, libraries are, for the most part, completely static. Importing them has no effect 
  on the editor unless you invoke what they provide. With the caveat that something else may be
  waiting to react to a library firing a signal, defining new Vim/Lua global variables.
  This strays _slightly_ from the standard definition of a library (`.so`, `.a`, `.dll`, `.lib`, etc),
  yes, but every `README.md` in this repository is meant to provide a contextual description and information 
  to clearly define the intended structure of the config, not be a dictionary on terminology.

## Features
  Features as the name suggests, can introduce new features into Neovim, but unlike commands or tweaks that
  arguably do the same, a feature is more abstract. It can be something the user never directly interacts with,
  such as automatically saving the most recently edited files every so often. It could also be something the
  user always interacts with, such as a launch dashboard or greeter with an interactive menu. One way to put is:
  it resides in the background, but has the ability to manifest itself however which way it wants.

  While features can and do define ex commands, those commands aren't the feature itself, but a way to manage
  the feature, alter its behavior, enable it, disable it, etc. If an ex command **is** the feature, then it
  does not belong in features, it belongs in commands (which is technically a subset of a feature).

## Commands
  Commands, otherwise known as ex commands, or user-commands, fall into this basket not for merely being one,
  but because the command has a direct and independent effect. It's a self-enclosed "binary" of sorts, that
  can perform one or more tasks depending on the arguments.

Examples of what qualifies:
  - A command that creates a new window with an associated buffer, performs a hexdump of the buffer you were
    previously on, and outputs the result to the new buffer, and defines a bunch of buffer-local highlights
    to help visualize repeating patterns of bytes.

  - A command that detects whatever filetype you're currently editing, resolves it to whichever compiler, or
    interpreter or ILVM is necessary to execute the code purely located in the current file, performs the
    compilation, executes it, and splits stdout and stderr output into two horizontal splits, after making
    a vertical split.

Examples of what does not qualify:
  - A command that toggles between setting a bunch of `guibg` highlights to `"none"`, and restore them back.
    Persisting the `"none"` value even after a colorscheme change, due to the command having been called with
    the persist argument, making it replace its old backup of the previous colorscheme highlights with a new
    one of the new colorscheme, before setting `guibg` to `"none"` once again.

    This would be a _feature_ that provides commands in order to manage it. Such a command would merely be a
    an interface that's not self-enclosed. There is background state, which can get updated when events fire,
    and the command arguments are mainly about flipping switches on and off to change the feature's behavior.


## Tweaks 

Tweaks don't focus on introducing features or behavior, although that may be a side effect. They're all about
altering the behavior of features (both usermade and native to Neovim). They can extend it a little, perhaps
change the appearance of floating windows, or change the order in which new window panes are created, maybe
change icons for diagnostic signs, subscribe to future events fired by a plugin loading, which may then tell
it to change something about the buffer highlights in order to increase compatibility with it, you name it.

They're not disallowed from creating new behavior that could be considered a feature, and they are still
allowed to make ex commands, but the scope of a tweak is much smaller. It's well.. tweaking something,
rather than inventing something. If a tweak could function in a vacuum then it's not a tweak, because
it needs _something to tweak_.

#### Tweaks, Tweak what needs Tweaking. Need I say more?



