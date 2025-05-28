extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

@export var sceneName: String = "WinScreen"

func _on_body_entered(body):
    if body.get_name() == "Player":
        get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
