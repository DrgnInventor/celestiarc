extends Node
# warning-ignore-all:unused_signal

signal retry
signal next_level # A request to switch to next level
signal switch_level(n) # A request to switch to n-th level
signal switch_tutorial_level # Like switch_level but to tutorial level
signal start_calculation # A request to start Collidix calculation
# A request to change platform at `index` to `value`
# index: int, value: string
# Value is string because it is treated like it came directly from LineEdit
signal change_platform_config(index, value)
signal win # Shown when a level has been won
signal close_overlay
signal close_extra
# Shows whether level has been started and whether physics need to be applied
signal show_level_menu
var level_running = false
const epsilon = 0.0001
var levels = []
var current_level_n = 1
