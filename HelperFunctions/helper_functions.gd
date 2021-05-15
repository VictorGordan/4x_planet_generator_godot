extends Node

func erase_duplicates(array: Array) -> Array:
	for i in range(len(array)):
		if not(array.count(array[i]) == 1):
			for _j in range(array.count(array[i]) - 1):
				array.erase(array[i])
	return array

func erase_array_from(array1: Array, array2: Array) -> Array:
	# erases all the elements of array1 from array2
	var array: Array = []
	for i in range(len(array2)):
		if array1.has(array2[i]):
			continue
		else:
			array.append(array2[i])
	return array

func null_array(n: int) -> Array:
	# creates and array of length n with only null
	var array: Array = range(n)
	for i in range(len(array)):
		array[i] = null
	return array
