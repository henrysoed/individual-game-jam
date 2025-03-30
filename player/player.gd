extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 85
@onready var animations = $AnimationPlayer

@export var inventory: Inventory

@export var maxHealth = 3
var currentHealth: int = maxHealth

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)
	
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
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
	elif area.has_method("collect"):
		area.collect(inventory)
