" Minimal syntax file for Star Trek Online keybind scripts
" Place this at: ~/.config/nvim/syntax/sto.vim

if exists('b:current_syntax')
  finish
endif

syn case match

syntax keyword stoCommand STOTrayExecByTray BindLoadFile alias bind say HoldCommand AdjustCamDistance ThrottleAdjust TrayElemMove Combatlog Target_Friend_Next Target_Friend_Near Target_Enemy_Near
hi def link stoCommand Function


"
" syntax match stoQuotedCommand /^\S+\s+\zs"\ze[^"]*"\s*$\$/
" syntax region stoQuotedCommand start=/\s"\S/ end=/""/
"
"
" deos the quoted string have whitespace? no? it's green? yes? it's preproc
" cyan individually
"
" The inverse, quotes where the end quote, must meet whitespace along the way
" to the start quote, or the start quote must meet whitespace on its way to 
" the end quote, but only match the individual quotes not the contents in
" between
syntax match stoQuotedCommand /\v\zs"\ze(([^"]*\s*)*")*/
hi def link stoQuotedCommand PreProc

" Quotes where no whitespace is present in between
syntax match stoQuotedParameter /\zs"\S*"\ze/
hi def link stoQuotedParameter String
"

" Simplest solution: all quotes are strings:
" syntax region stoQuotedCommand start=+"+ skip=+\\\\\|\\"+ end=+"+
hi def link stoQuotedCommand String
" syntax match stoQuotedCommand /"\\v\\s*\%(' . s:alts . ')\\>/

" Build the alternation string by calling the function with the list
" syntax match stoCommand /\vSTOTrayExecByTray|BindLoadFile|alias|bind|say|HoldCommand|AdjustCamDistance|ThrottleAdjust|TrayElemMove|Combatlog/

" STO Commands are Functions that can take parameters
" There is a very long list of commands, but let's start with the
" common ones, such as STOTrayExecByTray, BindLoadFile, alias, bind, say,
" HoldCommand, AdjustCamDistance, ThrottleAdjust, TrayElemMove, Combatlog

" Parameters to commands should be highlighted differently,
" and other commands are valid as parameters too, but they
" should not be highlighted as commands, nor typical parameters either,
" there shouold be a visual clue that the function is being passed
" as a parameter.
syntax match stoParamNumber /\v\s*\zs(-\d*\.?|\d*\.|-\.)?\d+\ze/
hi def link stoParamNumber Number

" Keywords / commands (small curated list, expand as you like)
" syntax keyword stoKeyword alias bind say HoldCommand AdjustCamDistance TrayElemMove Combatlog BindLoadFile STOTrayExecByTray
"
" 
" syntax match stoKeyModCombinator /[a-fA-F0-9]\s*\zs+\s*\ze0x/ -- Hex only

" Modifier Combinator:
" The `+` sign used to combine a modifier key with a regular key. This has
" its own highlight as opposed to the regular use of `+` and `++` which are
" ordinarily boolean toggle/hold operators prefixed before a command.
syntax match stoKeyModCombinator /^\S\+\zs+\ze\S/
hi def link stoKeyModCombinator Operator

" Keybind Declarations:
" These are at the very start of each line, and can either be in hexadecimal
" or the corresponding key in plain English. A maximum of one modifier can be
" used together with `+`, however there must be no whitespace in  between the
" modifier and the key -- this applies to both hex and regular key names.
syntax match stoKeyDecl /^\v\zs(0x[a-fA-F0-9]+(\s*\+\s*0x[a-fA-F0-9]+)?)\ze/
      \ contains=stoKeyModCombinator
syntax match stoKeyDecl /^\zs[a-zA-Z0-9][a-zA-Z0-9_\-]*\(+[a-zA-Z0-9_][a-zA-Z0-9_\-]*\)\?\ze/
      \ contains=stoKeyModCombinator
  
hi def link stoKeyDecl Constant 


" Comments: lines starting with | "
syntax region stoComment start=/^\s*|/ end=/$/
hi def link stoComment Comment

" Gontrol Operators:
" Primarily $$ is used for chaining multiple commands into one keybind.
" Also includes {} for interpolation, and <& &> for alias blocks.
syntax match stoOperator /$\$/
syntax match stoOperator /<&/
syntax match stoOperator /&>/
syntax match stoOperator /{}/
hi def link stoOperator Operator

" Boolean Operators: 
" These are prefixed before commands -- effectively just passes `1` as the
" first argument to the command in the case of `+` indicating a toggle, or
" `++` indicating a hold (passes `2` as the first argument?).
syntax match stoBooleanOp /\zs++\ze\S/
syntax match stoBooleanOp /\zs+\ze\S/
hi def link stoBooleanOp Boolean

" Let's make some clusters for numbers, strings, floats, etc,
syntax cluster stoParameterCluster contains=stoCommand,stoParamNumber


" Identifier Rules for non-hexadecimal keys: 
" For non-hexadecimal keys of with optional + modifier combination, cannot
" contain any spaces, cannot start with numbers, cannot start with '0x' or '0X'.
" otherwise the same. Example: "ctrl+a", "a", "-", "1", "alt+1" 
" there are only one modifier combinations allowed in STO keybinds.
" Also, some keys must be written out fully, these keys include:
" Alt: alt
" Ctrl: control
" End: end
" F1_F12: f1-f12
"
" Arrows:
" right
" left
" up
" down
"
" Other:
" esc - Escape key
" tab - Tab key
" backspace - Backspace key
" enter - Enter/Return key
"
" Aliases:
" grave - The ` key and tilde ~ key (both share the same name)
" subtract - Numpad minus key
" add - Numpad plus key
" decimal - Numpad decimal key
" multiply - Numpad multiply key
" divide - Numpad divide key
"
" Numpad:
" numpad<N> (where <N> is 0-9)
" pagedown
" pageup
" scroll
" numlock
" insert
" home
" end
"
"
" Modifiers:
" shift
" lshift
" rshift
" alt
" control
" lcontrol
"
"
" Mouse:
" lbutton          - Left click
" rbutton          - Right click
" mbutton          - Middle mouuse click
" button4          - Typically the back button
" leftdrag         - Left click drag
" rightdrag        - Right click drag
" mousechord       - Left+Right Click Together
" leftdoubleclick  - Left Double Click
" rightdoubleclick - Right Double Click
" middleclick      - Scroll Wheel Click
" wheelplus        - Scroll Wheel Up 
" wheelminus       - Scroll Wheel Down 





" Decimal and floating numbers (covers -.25, .25, 0.1, -1 etc.)
" syntax match stoNumber /\v-?\d+(\.\d+)?|-?\.\d+/
" hi def link stoNumber Number

"
" " Alias block: <& ... &>
" syntax region stoAlias start=+\<&+ end=+&>+ contains=stoKeyword,stoNumber,stoHex,stoOperator,stoString,stoInterpolation,stoKey
" hi def link stoAlias Macro
"
" " Strings supporting interpolation and escaped quotes
" syntax region stoString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=stoInterpolation
" hi def link stoString String
"
" " Interpolation - only highlighted inside strings
" syntax match stoInterpolation /{[^}]*\}/ contained
" hi def link stoInterpolation Special
"
" " Operators. Escape special chars so they match literally.
" syntax match stoOperator /\$\$/
" syntax match stoOperator /\+\+/
" syntax match stoOperator /\+/
" hi def link stoOperator Operator
"
"
" " Standalone 'alias' keyword (helps in contexts where it isn't matched above)
" syntax match stoAliasKeyword /\balias\b/
" hi def link stoAliasKeyword Keyword
"
let b:current_syntax = 'sto'
