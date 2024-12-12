class_name Command
extends Node2D

enum Status {
	ACTIVE,
	DONE,
	ERROR,
}

func execute(_character: Character) -> Status:
	return Status.DONE
