extends Node

# start with title music
# match start with i can feel it coming, or use this for title
# hot pursuit next, then outfoxing.  go back and forth on those until end
# for end do darkling?  consider agressor, kind of too cheesy maybe
# after or as you reach the last fix spot, start destroy the sun


# TODO consider letting i can feel it coming play out?
@onready var iCanFeelItComing: AudioStreamPlayer = $iCanFeelItComing
@onready var outfoxing: AudioStreamPlayer = $outfoxing
@onready var darkling: AudioStreamPlayer = $darkling
@onready var destroyTheSun: AudioStreamPlayer = $destroyTheSun

func _ready():
	title()

func title():
	iCanFeelItComing.play(0.0)
	outfoxing.stop()
	darkling.stop()
	destroyTheSun.stop()

func game_started():
	iCanFeelItComing.stop()
	outfoxing.play(0.0)
	darkling.stop()
	destroyTheSun.stop()

func endgame_started():
	iCanFeelItComing.stop()
	outfoxing.stop()
	darkling.play(0.0)
	destroyTheSun.stop()

func finale_started():
	iCanFeelItComing.stop()
	outfoxing.stop()
	darkling.stop()
	destroyTheSun.play(0.0)
