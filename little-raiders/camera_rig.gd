extends Node3D
class_name CameraRig

@onready var path_follow_3d: PathFollow3D = $CameraTrack/PathFollow3D
@onready var camera_3d: Camera3D = $CameraTrack/PathFollow3D/Camera3D

@export var desired_distance : float = 10
@export var distance_margin : float = 2
@export var margin_speed : float = 3
@export var catch_up_speed : float = 10
@export var stop_margin : float = 0.1

var current_speed : float = 1

@export var players : Array[Node3D]
#Keep track of the avg point of all the players.
#Later on, weight the position towards the player closets to the camera
var avg_players_point : Vector3

var current_distance : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_speed = margin_speed
	
	#Get all players found in player group into collection.
	#TODO: Make this automatic
	#players = yadda yadda
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#for player in players:
		#var cur_player_dist : float = (player.global_position - self.global_position).length()
		#if cur_player_dist < current_distance:
			#current_distance = cur_player_dist
			#avg_players_point = player.global_position
	
	current_distance = (players[0].global_position - path_follow_3d.global_position).length()
	
	var go_forward : bool = current_distance > desired_distance
	var within_margin : bool = current_distance < (desired_distance + distance_margin)
	
	print_debug(current_distance)
	
	if within_margin:
		current_speed = margin_speed
	else:
		current_speed = catch_up_speed
	
	if !go_forward:
		current_speed = current_speed * -1
	
	#Make sure we don't surpras the beginning of the track
	if(go_forward || (!go_forward && path_follow_3d.progress + current_speed * delta > 0)):
		path_follow_3d.progress += current_speed * delta
	
	camera_3d.look_at(players[0].global_position)
	
	pass
