Title: TextAdventure

=== FILE: game_engine.py ===
import random
from characters import Player, Enemy
from items import Item, Weapon, Potion

class GameEngine:
    def __init__(self):
        self.player = Player()
        self.enemies = []
        self.items = []
        self.current_room = None
        self.game_over = False

    def create_room(self, name, description, items=[], enemies=[]):
        room = {"name": name, "description": description, "items": items, "enemies": enemies}
        return room

    def start_game(self):
        self.generate_game()
        self.print_room_description()
        self.game_loop()

    def generate_game(self):
        self.rooms = [
            self.create_room("Start", "You are in a dark forest.", [Item("Key", "A rusty key.")], [Enemy("Goblin", 10, 5)]),
            self.create_room("Cave", "A damp cave.", [Potion("Healing Potion", 20)], [Enemy("Spider", 15, 7)]),
            self.create_room("Treasure Room", "A room filled with treasure!", [Item("Gold", "A pile of gold coins.")]),
        ]
        self.current_room = self.rooms[0]

    def print_room_description(self):
        print(self.current_room["name"])
        print(self.current_room["description"])
        print("Items:", [item.name for item in self.current_room["items"]])
        if self.current_room["enemies"]:
            print("Enemies present!")

    def handle_input(self, command):
        if command == "go north" and self.current_room == self.rooms[0]:
            self.current_room = self.rooms[1]
        elif command == "go south" and self.current_room == self.rooms[1]:
            self.current_room = self.rooms[0]
        elif command == "go east" and self.current_room == self.rooms[1]:
            self.current_room = self.rooms[2]
        elif command == "examine":
            self.examine_room()
        elif command == "attack" and self.current_room["enemies"]:
            self.combat()
        elif command == "get":
            self.collect_items()
        elif command == "inventory":
            self.player.show_inventory()
        else:
            print("Invalid command.")

    def examine_room(self):
        for item in self.current_room["items"]:
            print(f"{item.name}: {item.description}")

    def combat(self):
        enemy = random.choice(self.current_room["enemies"])
        print(f"You are fighting a {enemy.name}!")
        while enemy.health > 0 and self.player.health > 0:
            action = input("Attack or use potion? ")
            if action == "attack":
                enemy.health -= self.player.attack()
                print(f"You hit the {enemy.name} for {self.player.attack()} damage!")
                if enemy.health <= 0:
                    print(f"You defeated the {enemy.name}!")
                    self.current_room["enemies"].remove(enemy)
                    break
                self.player.health -= enemy.attack()
                print(f"The {enemy.name} hit you for {enemy.attack()} damage!")
            elif action == "use potion":
                self.player.use_potion()
            else:
                print("Invalid action.")

    def collect_items(self):
        item = input("Which item do you want to collect? ")
        for i in self.current_room["items"]:
            if i.name == item:
                self.player.add_item(i)
                self.current_room["items"].remove(i)
                print(f"You collected {item}.")
                break
        else:
            print("Item not found.")


    def game_loop(self):
        while not self.game_over:
            command = input("> ")
            self.handle_input(command)
            self.print_room_description()
            if self.player.health <= 0:
                print("Game Over!")
                self.game_over = True

=== END FILE ===

=== FILE: characters.py ===
import random

class Character:
    def __init__(self, name, health, attack):
        self.name = name
        self.health = health
        self.attack = attack
        self.inventory = []

    def attack(self):
        return random.randint(1, self.attack)

class Player(Character):
    def __init__(self):
        super().__init__("Player", 100, 10)
        self.potions = []

    def add_item(self, item):
        self.inventory.append(item)

    def use_potion(self):
        if self.potions:
            potion = self.potions.pop()
            self.health += potion.heal_amount
            print(f"You used a {potion.name}, restoring {potion.heal_amount} health.")
        else:
            print("You have no potions.")
    def show_inventory(self):
        print("Inventory:")
        if self.inventory:
            for item in self.inventory:
                print(f"- {item.name}")
        else:
            print("Your inventory is empty.")

class Enemy(Character):
    pass

=== END FILE ===

=== FILE: items.py ===
class Item:
    def __init__(self, name, description):
        self.name = name
        self.description = description

class Weapon(Item):
    def __init__(self, name, description, damage):
        super().__init__(name, description)
        self.damage = damage

class Potion(Item):
    def __init__(self, name, heal_amount):
        super().__init__(name, f"A potion that heals {heal_amount} health.")
        self.heal_amount = heal_amount

=== END FILE ===

=== FILE: main.py ===
from game_engine import GameEngine

if __name__ == "__main__":
    game = GameEngine()
    game.start_game()

=== END FILE ===