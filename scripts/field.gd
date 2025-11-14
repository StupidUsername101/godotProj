extends Node3D
class_name Crop_Field

@export var digging_epsilon := 0.5

var planted_crops: Array[Node3D]

@onready var mesh_inst: MeshInstance3D = $field_mesh
@onready var coll_shape: CollisionShape3D = $CollisionShape3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(Group.FIELD)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func digg(digg_pos: Vector3):
	var local_digg_pos = mesh_inst.to_local(digg_pos)
	var mesh = mesh_inst.mesh
	if mesh == null:
		return

	var arrs = mesh.surface_get_arrays(0)
	var mat0 := mesh.surface_get_material(0)
	var verts : PackedVector3Array = arrs[Mesh.ARRAY_VERTEX]
	
	for i in range(verts.size()):
		var v = verts[i]
		# e.g. move vertex downward if near some point
		var dist2 = local_digg_pos.distance_squared_to(v)
		if (dist2 < digging_epsilon):
			var ammount = 1 -sqrt(dist2)
			v.y -= ammount
			
		verts[i] = v

	# Assign the modified array back
	arrs[Mesh.ARRAY_VERTEX] = verts
	
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_TRIANGLES,
		arrs
	)
	
	new_mesh.surface_set_material(0, mat0)
	var new_shape = new_mesh.create_trimesh_shape()
	mesh_inst.mesh = new_mesh
	coll_shape.shape = new_shape

func add_crop(crop_position: Vector3):
	var mdt = MeshDataTool.new()
	for i in range(mdt.get_vertex_count()):
		
		var vertex = mdt.get_vertex(i)
		
	#make new crop and add to list
	#planted_crops.append(crop)
	#add_child(crop)
