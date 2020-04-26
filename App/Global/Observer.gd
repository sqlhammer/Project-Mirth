extends Node

var Subscribers = {}

func trigger():
	for key in Subscribers:
		if not is_instance_valid(Subscribers[key]["instance"]):
			misfire(key)
			continue
		Subscribers[key]["instance"].call(Subscribers[key]["method"],Subscribers[key]["args"])

func subscribe(instance, method, args):
	Subscribers[instance.get_instance_id()] = {"instance":instance, "method":method, "args":args}

func misfire(key):
	unsubscribe(key)

func unsubscribe(key):
	Subscribers.erase(key)
