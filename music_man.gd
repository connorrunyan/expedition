extends Node

# start with title music
# match start with i can feel it coming, or use this for title
# hot pursuit next, then outfoxing.  go back and forth on those until end
# for end do darkling?  consider agressor, kind of too cheesy maybe
# after or as you reach the last fix spot, start destroy the sun


# TODO consider letting i can feel it coming play out?
@onready var iCanFeelItComing: AudioStreamPlayer = $iCanFeelItComing
@onready var hotPursuit: AudioStreamPlayer = $hotPursuit
@onready var outfoxing: AudioStreamPlayer = $outfoxing
@onready var darkling: AudioStreamPlayer = $darkling
@onready var destroyTheSun: AudioStreamPlayer = $destroyTheSun

func _ready():
	iCanFeelItComing.play(0.0)

func game_started():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.play(0.0)
	darkling.stop()
	destroyTheSun.stop()

func endgame_started():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.stop()
	darkling.play(0.0)
	destroyTheSun.stop()

func finale_started():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.stop()
	darkling.stop()
	destroyTheSun.play(0.0)

func _on_i_can_feel_it_coming_finished():
	iCanFeelItComing.play(0.0)
	hotPursuit.stop()
	outfoxing.stop()
	darkling.stop()
	destroyTheSun.stop()

func _on_hot_pursuit_finished():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.play(0.0)
	darkling.stop()
	destroyTheSun.stop()

func _on_outfoxing_finished():
	iCanFeelItComing.stop()
	hotPursuit.play(0.0)
	outfoxing.stop()
	darkling.stop()
	destroyTheSun.stop()

func _on_darkling_finished():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.stop()
	darkling.play(0.0)
	destroyTheSun.stop()


func _on_destroy_the_sun_finished():
	iCanFeelItComing.stop()
	hotPursuit.stop()
	outfoxing.stop()
	darkling.stop()
	#destroyTheSun.stop() think this guy loops already
