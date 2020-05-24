extends Node

#fifo = first in, first out
var fifo_array = []
#fifo = first in, last out
var filo_array = []

# enums translate to ints not nulls
# Always start your list of enums with an unknown or error value
# so that missing values don't get treated as valid values
enum Sort {Unknown, Ascending, Descending}

func _ready():
	# Random letter prefixes to establish non-alphabetical ordering
	push_array(fifo_array,[1,"A_Name1","String1"])
	push_array(fifo_array,[2,"S_Name2","String2"])
	push_array(fifo_array,[3,"P_Name3","String3"])
	print(fifo_array)
	
	push_array(filo_array,[1,"A_Name1","String1"])
	push_array(filo_array,[2,"S_Name2","String2"])
	push_array(filo_array,[3,"P_Name3","String3"])
	print(filo_array)
	
	print ("****** FIFO Demo *******")
	pop_array(fifo_array,Sort.Ascending)
	print ("****** FILO Demo *******")
	pop_array(filo_array,Sort.Descending)

func push_array (arr, item):
	arr.append(item)

func pop_array (arr, sort = Sort.Ascending):
	for i in range(0,arr.size(),1):
		if sort == Sort.Ascending:
			print(arr.pop_front())
		else:
			print(arr.pop_back())
