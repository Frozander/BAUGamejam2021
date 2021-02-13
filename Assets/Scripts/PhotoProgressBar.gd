extends Node2D

export var percentage = 25

func _ready():
	set_percentage(percentage)

func set_percentage(percentage):
	self.percentage = percentage
	$ProgressBar.value = percentage
