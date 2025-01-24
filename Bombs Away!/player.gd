extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var chargePower := 0
var damage := 0


@export var chargeSpeed := 1
@export var damageMod = 1
@export var rotateSpeed = 1.5
@export var maxCharge = 30
@export var blastCooldown = 0.25

var canBlast = true

func _ready()->void:
	set_motion_mode(MOTION_MODE_FLOATING)

func _physics_process(_delta:float)->void:
	if damage <= 5:
		$bullet.rotation_degrees += Input.get_axis("left","right")*rotateSpeed
	if canBlast:
		if Input.is_action_pressed("charge"):
			if chargePower < maxCharge:
				chargePower += chargeSpeed
		elif chargePower != 0:
			var direction = $bullet/direction.global_position - global_position
			velocity = direction*Vector2(chargePower,chargePower)
			var drainTween = create_tween()
			drainTween.tween_property(self,"chargePower",0,0.1)
			canBlast = false
			$blastTimer.start(blastCooldown)
			$bullet/blastEffect.emitting = true
	$chargeMeter/mask.offset.y = 22 - chargePower*(21.5/maxCharge)
	velocity /= Vector2(1.1,1.1)
	damage = int(sqrt(velocity.x**2+velocity.y**2)/10)
	$damage.text = str(damage)+"  "+str(chargePower)
	move_and_slide()


func _on_blast_timer_timeout():
	canBlast = true
