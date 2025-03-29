extends CharacterBody2D

@export var speed: int = 85
@onready var animations = $AnimationPlayer

@export var inventory: Inventory

var currentHealth: int = 3

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	
func updateAnimation():
	if velocity.length() == 0:
		animations.play("idle")
	else:
		var direction = "Down"
		if velocity.x < 0:
			direction = "Left"
		elif velocity.x > 0:
			direction = "Right"
		elif velocity.y < 0:
			direction = "Up"
		animations.play("walk"+direction)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		currentHealth -= 1
		print_debug(currentHealth)
	elif area.has_method("collect"):
		area.collect(inventory)
