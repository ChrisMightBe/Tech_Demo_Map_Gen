extends Node2D

@onready var path: TileMapLayer = $TileMapPath


var rng = RandomNumberGenerator.new()

const CellSize = Vector2i(16, 16)
const width = int(1120 / CellSize.x)
const height = int(608 / CellSize.y)

var grid: Array = []

enum Tiles  {
	empty = -1,
	floor = 1
}

func _init_grid():
	grid.clear()
	for x in range(width):
		grid.append([])
		for y in range(height):
			grid[x].append(Tiles.empty);

func GetRandomDirection() -> Vector2i:
	var directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	var direction = directions[rng.randi()%4]
	return Vector2i(direction[0], direction[1])

func _create_random_path():
	var max_iterations = 1000
	var walker = Vector2i(int(width / 2), int(height / 2))
	
	for i in range(max_iterations):
		var dir = GetRandomDirection()
		var new_pos = walker + dir
		if new_pos.x >= 0 and new_pos.x < width and new_pos.y >= 0 and new_pos.y < height:
			walker = new_pos
			grid[walker.x][walker.y] = Tiles.floor
		

func _spawn_tiles():
	path.clear()
	for x in range(width):
		for y in range(height):
			if grid[x][y] == Tiles.floor:
				# TileMapLayer signature: set_cell(coords: Vector2i, source_id: int, atlas_coords: Vector2i = Vector2i(-1, -1))
				path.set_cell(Vector2i(x, y), 0)
				path.set_cells_terrain_path([Vector2i(x, y)], 0, 0)
				path.set_cells_terrain_connect([Vector2i(x, y)], 0, 0)


func _clear_tilemaps():
	for x in range(width):
		for y in range(height):
			path.clear()

func _ready():
	rng.randomize()
	_init_grid()
	_clear_tilemaps()
	_create_random_path()
	_spawn_tiles()
	
func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		_init_grid()
		_clear_tilemaps()
		_create_random_path()
		_spawn_tiles()
