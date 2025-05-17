class_name upgrade_data
extends Object

var description: String = ""
var stat: String = ""
var magnitude: int = 0

func _init(d: String, s: String, m: int):
	description = d
	stat = s
	magnitude = m
