extends KinematicBody2D
class_name Player


var velocity: Vector2
var can_attack: bool = false
var can_die: bool = false
var RunParticles: PackedScene = preload('res://scenes/prefabs/run_particles.tscn')
onready var texture: Sprite = $texture
onready var animation: AnimationPlayer = $animation
onready var attack_area_collision: CollisionShape2D = $attack_area/collision
export(int) var speed


func _physics_process(_delta: float) -> void:
  move()
  attack()
  verify_direction()
  animate()


func move() -> void:
  var direction: Vector2 = Vector2(
    Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
    Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')  
  ).normalized()
  velocity = direction * speed
  velocity = move_and_slide(velocity)


func attack() -> void:
  if Input.is_action_just_pressed('ui_select') and not can_attack:
    can_attack = true


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
    attack_area_collision.position = Vector2(20, 9)
  elif velocity.x < 0:
    texture.flip_h = true
    attack_area_collision.position = Vector2(-20, 9)
  

func animate() -> void:
  if can_die:
    animation.play('dead')
    set_physics_process(false)
  elif can_attack:
    animation.play('attack')
    set_physics_process(false)
  elif velocity != Vector2.ZERO:
    animation.play('run')
  else:
    animation.play('idle')


func instance_particles() -> void:
  var run_particles = RunParticles.instance()
  get_tree().root.call_deferred('add_child', run_particles)
  run_particles.global_position = global_position + Vector2(0, 17)
  run_particles.play_particles()


func kill() -> void:
  can_die = true


func _on_animation_finished(anim_name: String) -> void:
  if anim_name == 'dead':
    var _reload := get_tree().reload_current_scene()
  elif anim_name == 'attack':
    set_physics_process(true)
    can_attack = false
