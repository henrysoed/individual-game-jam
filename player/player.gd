extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 85
@onready var animations = $AnimationPlayer
@onready var hurtEffects = $hurtTimer/hurtEffects
@onready var hurtTimer = $hurtTimer

@export var inventory: Inventory

@export var knockBackPower: int = 750

@export var maxHealth = 3
var currentHealth: int = maxHealth

@export var invulnerabilityDuration: float = 1.5
var lastDamageTime: int = 0

func _ready():
    hurtEffects.play("RESET")
    hurtTimer.wait_time = invulnerabilityDuration

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
        var currentTime = Time.get_ticks_msec()
        var timeSinceLastDamage = currentTime - lastDamageTime
        
        if timeSinceLastDamage < invulnerabilityDuration * 1000:
            return
            
        lastDamageTime = currentTime
        currentHealth -= 1
        if currentHealth < 1:
            get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")
        healthChanged.emit(currentHealth)
        
        knockBack(area.get_parent().global_position)
        
        hurtEffects.play("hurtBlink")
        
        startInvulnerabilityEffect()
        
    elif area.has_method("collect"):
        area.collect(inventory)
        
func knockBack(enemyPosition: Vector2):
    var knockBackDir = (global_position - enemyPosition).normalized()
    
    if knockBackDir.length() < 0.1:
        knockBackDir = Vector2(0, 1)
    
    velocity = knockBackDir * knockBackPower
    
    move_and_slide()
    
    move_and_slide()

func startInvulnerabilityEffect():
    hurtTimer.start()
    await hurtTimer.timeout
    hurtEffects.play("RESET")
