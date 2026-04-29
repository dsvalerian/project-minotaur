class_name CharacterQueue

var characters: Array[Character]
var index: int = 0

func current() -> Character:
	return characters[index]

func append(character: Character) -> void:
	characters.append(character)
	
func advance() -> void:
	index += 1
	
func is_exhausted() -> bool:
	return index >= characters.size()
	
func reset() -> void:
	index = 0

func size() -> int:
	return characters.size()
