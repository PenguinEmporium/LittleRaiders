extends Node3D
class_name door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var start_open : bool = false

var is_open : bool = false

func _ready() -> void:
	await get_tree().process_frame
	if start_open:
		open()

func slow_open(duration:float = 10):
	if is_open:
		return
	is_open = true
	animation_player.play("open",-1,1/duration)

func slam_open():
	if is_open:
		return
	is_open = true
	animation_player.play("slam_open")

func open():
	if is_open:
		return
	is_open = true
	animation_player.play("open")

func slow_close(duration:float = 10):
	if !is_open:
		return
	is_open = false
	animation_player.play("close",-1,1/duration)

func slam_close():
	if !is_open:
		return
	is_open = false
	animation_player.play("slam_close")

func close():
	if !is_open:
		return
	is_open = false
	animation_player.play("close")
