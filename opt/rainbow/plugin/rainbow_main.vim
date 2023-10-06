" Copyright 2013 LuoChen (luochen1990@gmail.com). Licensed under the Apache License 2.0.

command! RainbowToggle call rainbow_main#toggle()
command! RainbowToggleOn call rainbow_main#load()
command! RainbowToggleOff call rainbow_main#clear()

autocmd Syntax,ColorScheme * RainbowToggleOn
