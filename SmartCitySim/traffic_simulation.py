Title: TextAdventure

=== FILE: game_data.py ===
class Room:
    def __init__(self, name, description, items, exits):
        self.name = name
        self.description = description
        self.items = items
        self.exits = exits

    def __str__(self):
        return f"Room: {self.name}\nDescription: {self.description}\nItems: {', '.join(self.items) or 'None'}\nExits: {', '.join(self.exits.keys()) or 'None'}"

class Item:
    def __init__(self, name, description, usable=False):
        self.name = name
        self.description = description
        self.usable = usable

    def __str__(self):
        return f"Item: {self.name}\nDescription: {self.description}"

rooms = {
    "start": Room("Start Room", "You are in a dimly lit room.", ["key"], {"north": "corridor"}),
    "corridor": Room("Corridor", "A long corridor stretches before you.", ["potion"], {"south": "start", "north": "treasure_room"}),
    "treasure_room": Room("Treasure Room", "You found a treasure room! A chest sits in the middle.", ["chest"], {"south": "corridor"})
}

items = {
    "key": Item("Key", "A rusty key."),
    "potion": Item("Potion", "A mysterious potion.", usable=True),
    "chest": Item("Chest", "A locked chest.", usable=True)
}

=== END FILE ===


=== FILE: player.py ===
class Player:
    def __init__(self, name, current_room="start", inventory=[]):
        self.name = name
        self.current_room = current_room
        self.inventory = inventory

    def move(self, direction):
        if direction in game_data.rooms[self.current_room].exits:
            self.current_room = game_data.rooms[self.current_room].exits[direction]
            return True
        return False

    def get_item(self, item_name):
        if item_name in game_data.rooms[self.current_room].items:
            self.inventory.append(item_name)
            game_data.rooms[self.current_room].items.remove(item_name)
            return True
        return False

    def use_item(self, item_name):
        if item_name in self.inventory:
            item = next((item for item in game_data.items.values() if item.name == item_name), None)
            if item and item.usable:
                if item_name == "key" and self.current_room == "treasure_room" and "chest" in game_data.rooms["treasure_room"].items:
                    print("You unlocked the chest!")
                    game_data.rooms["treasure_room"].items.remove("chest")
                    self.inventory.append("gold")
                    return True
                elif item_name == "potion":
                    print("You drank the potion. Nothing happened.")
                    return True
            return False
        return False


    def __str__(self):
        return f"Player: {self.name}\nCurrent Room: {self.current_room}\nInventory: {', '.join(self.inventory) or 'None'}"

=== END FILE ===


=== FILE: game.py ===
import game_data
import player

def play():
    name = input("Enter your name: ")
    p = player.Player(name)
    while True:
        print(game_data.rooms[p.current_room])
        print(p)
        command = input("> ").lower().split()
        verb = command[0]
        if verb == "go":
            if len(command) > 1:
                direction = command[1]
                if p.move(direction):
                    print(f"You moved {direction}.")
                else:
                    print("You can't go that way.")
            else:
                print("Go where?")
        elif verb == "get":
            if len(command) > 1:
                item_name = command[1]
                if p.get_item(item_name):
                    print(f"You picked up {item_name}.")
                else:
                    print(f"There's no {item_name} here.")
            else:
                print("Get what?")
        elif verb == "use":
            if len(command) > 1:
                item_name = command[1]
                if p.use_item(item_name):
                    print(f"You used {item_name}.")
                else:
                    print(f"You can't use {item_name}.")
            else:
                print("Use what?")
        elif verb == "quit":
            break
        elif verb == "look":
            print(game_data.rooms[p.current_room].description)
        else:
            print("Invalid command.")
        if "gold" in p.inventory:
            print("You won!")
            break

if __name__ == "__main__":
    play()

=== END FILE ===