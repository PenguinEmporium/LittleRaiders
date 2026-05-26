extends Node3D
class_name CameraRig

@onready var path_follow_3d: PathFollow3D = $CameraTrack/PathFollow3D

@export var min_distance : float = 20
@export var max_distance : float = 50

@export var players : Array[Node3D]
#Keep track of the avg point of all the players.
#Later on, weight the position towards the player closets to the camera
var avg_players_point : Vector3

var current_distance : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Get all players found in player group into collection.
	#TODO: Make this automatic
	#players = yadda yadda
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for player in players:
		var cur_player_dist : float = (player.global_position - self.global_position).length()
		if cur_player_dist < current_distance:
			current_distance = cur_player_dist
			avg_players_point = player.global_position
	
	#Check if exceeding max or min threshold then move or look at players
	
	pass
