extends Control

@onready var label2 = $VBoxContainer/Label2
@onready var progressBar = $VBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressBar.value = Stats.progress_current
	if Stats.repairs_needed >= 1:
		Stats.progress_current += Stats.progress_blocked_rate * delta
		label2.text = str(Stats.repairs_needed) + " Repairs Needed! (" + str(Stats.progress_blocked_rate * 0.01) + "% / s)"
		label2.self_modulate = Color.DARK_RED
	else:
		Stats.progress_current += Stats.progress_normal_rate * delta
		label2.text = "(" + str(Stats.progress_normal_rate * 0.01) + "% / s)"
		label2.self_modulate = Color.WHITE
