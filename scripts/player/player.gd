extends KinematicBody2D
class_name Player


var velocity: Vector2
onready var texture: Sprite = $texture
onready var animation: AnimationPlayer = $animation
export(int) var speed


func _physics_process(_delta: float) -> void:
  move()
  verify_direction()
  animate()


func move() -> void:
  var direction: Vector2 = Vector2(
    Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
    Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')  
  ).normalized()
  velocity = direction * speed
  velocity = move_and_slide(velocity)


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
  elif velocity.x < 0:
    texture.flip_h = true
  

func animate() -> void:
  if velocity != Vector2.ZERO:
    animation.play('run')
  else:
    animation.play('idle')
