Title: TextAdventure

=== FILE: game.py ===
import items
import rooms

class Game:
    def __init__(self):
        self.current_room = rooms.Room("Start", "You are in a dark forest.", {"north": rooms.Room("Forest Path", "A narrow path leads north.", {"north": rooms.Room("Clearing", "A sunny clearing. You see a cave to the west.", {"west": rooms.Room("Cave", "A dark cave. You find a key.", {"south": rooms.Room("Forest Path", "A narrow path leads south.", {"south": rooms.Room("Start", "You are back in the dark forest.", {})})}), "south": rooms.Room("Forest Path", "A narrow path leads south.", {"south": rooms.Room("Start", "You are back in the dark forest.", {})})})})})


        self.inventory = []

    def play(self):
        while True:
            print("\n" + self.current_room.description)
            print("Inventory:", self.inventory)
            exits = self.current_room.exits
            if exits:
                print("Exits:", ", ".join(exits.keys()))
            
            command = input("> ").lower().split()

            if command[0] == "go":
                if len(command) > 1:
                    direction = command[1]
                    if direction in self.current_room.exits:
                        self.current_room = self.current_room.exits[direction]
                    else:
                        print("You can't go that way.")
                else:
                    print("Go where?")

            elif command[0] == "get":
                if len(command) > 1:
                  item_name = command[1]
                  if item_name in self.current_room.items:
                      item = items.Item.create_item(item_name)
                      self.inventory.append(item)
                      self.current_room.items.remove(item_name)
                      print(f"You picked up the {item_name}.")
                  else:
                      print("That item isn't here.")
                else:
                    print("Get what?")
            elif command[0] == "use":
                if len(command) > 1:
                    item_name = command[1]
                    found = False
                    for item in self.inventory:
                        if item.name == item_name:
                            item.use(self)
                            found = True
                            break
                    if not found:
                        print("You don't have that item.")
                else:
                    print("Use what?")

            elif command[0] == "quit":
                break
            else:
                print("I don't understand that command.")

            if self.current_room.is_winning_room():
              print("You win!")
              break


=== END FILE ===

=== FILE: items.py ===
class Item:
    @staticmethod
    def create_item(name):
        if name == "key":
            return Key()
        else:
            return Item(name)

    def __init__(self, name):
        self.name = name

    def use(self, game):
        print(f"You used the {self.name}. Nothing happens.")

class Key(Item):
    def use(self, game):
        if game.current_room.name == "Cave":
            print("You used the key to unlock the cave exit!")
            game.current_room.exits["south"] = rooms.Room("Forest Path", "A narrow path leads south.", {"south": rooms.Room("Start", "You are back in the dark forest.", {})})
        else:
            print("The key is useless here.")


=== END FILE ===

=== FILE: rooms.py ===
class Room:
    def __init__(self, name, description, exits={}, items = []):
        self.name = name
        self.description = description
        self.exits = exits
        self.items = items

    def is_winning_room(self):
        return self.name == "Start"


=== END FILE ===

=== FILE: main.py ===
import game

if __name__ == "__main__":
    game_instance = game.Game()
    game_instance.play()

=== END FILE ===