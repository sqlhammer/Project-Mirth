extends Node

var player_info = {}
var player_instances = {}
var queued_info = {}

const SERVER_PORT = 49001
const MAX_CLIENTS = 100
const MAX_PLAYERS = 2
const SERVER_IPV4 = "127.0.0.1"

var level
var lobby
