Title: TextAdventure

=== FILE: game.py ===
import sys
from character import Player
from world import World
from items import Item, Weapon, Potion

def main():
    player_name = input("Enter your name: ")
    player = Player(player_name)
    world = World()
    world.generate_world()
    world.print_location(player.location)

    while True:
        action = input("> ").lower().split()
        verb = action[0]

        if verb == "quit" or verb == "exit":
            sys.exit()
        elif verb == "go":
            if len(action) > 1:
                direction = action[1]
                if world.move_player(player, direction):
                    world.print_location(player.location)
                else:
                    print("You can't go that way.")
            else:
                print("Go where?")
        elif verb == "look":
            world.describe_location(player.location)
        elif verb == "attack":
            if len(action) > 1:
                enemy_name = action[1]
                enemy = world.find_enemy(player.location, enemy_name)
                if enemy:
                    player.attack(enemy)
                else:
                    print("There's no "+ enemy_name +" here.")
            else:
                print("Attack what?")
        elif verb == "use":
            if len(action)>1:
                item_name = action[1]
                item = player.find_item(item_name)
                if item:
                    item.use(player)
                else:
                    print("You don't have that item.")
            else:
                print("Use what?")
        elif verb == "inventory":
            player.show_inventory()
        elif verb == "take":
            if len(action)>1:
                item_name = action[1]
                item = world.take_item(player.location,item_name)
                if item:
                    player.add_item(item)
                    print(f"You picked up {item_name}.")
                else:
                    print(f"There's no {item_name} here.")
            else:
                print("Take what?")
        else:
            print("I don't understand.")

if __name__ == "__main__":
    main()

=== END FILE ===

=== FILE: character.py ===
class Player:
    def __init__(self, name):
        self.name = name
        self.health = 100
        self.attack = 10
        self.location = "forest"
        self.inventory = []

    def attack(self, enemy):
        damage = self.attack - enemy.defense
        if damage > 0:
            enemy.health -= damage
            print(f"You hit {enemy.name} for {damage} damage!")
            if enemy.health <= 0:
                print(f"You killed {enemy.name}!")
                enemy.on_death(self)
        else:
            print(f"Your attack missed {enemy.name}.")

    def add_item(self, item):
        self.inventory.append(item)

    def find_item(self, item_name):
        for item in self.inventory:
            if item.name.lower() == item_name.lower():
                return item
        return None

    def show_inventory(self):
        if self.inventory:
            print("You have:")
            for item in self.inventory:
                print(f"- {item.name}")
        else:
            print("Your inventory is empty.")


=== END FILE ===

=== FILE: world.py ===
import random
from enemy import Enemy
from items import Potion, Weapon

class World:
    def __init__(self):
        self.locations = {
            "forest": {"north": "cave", "east": "river", "items": [Weapon("Sword",15,5)],"enemies":[Enemy("Wolf",20,5)]},
            "cave": {"south": "forest", "items": [Potion("Healing Potion",30)], "enemies":[]},
            "river": {"west": "forest", "items": [], "enemies":[Enemy("Goblin",15,3)]}
        }

    def generate_world(self):
        pass

    def move_player(self, player, direction):
        if player.location in self.locations and direction in self.locations[player.location]:
            player.location = self.locations[player.location][direction]
            return True
        return False

    def print_location(self, location):
        print(f"\nYou are in the {location}.")
        if location in self.locations and 'items' in self.locations[location] and self.locations[location]['items']:
            print("You see:", end=" ")
            for item in self.locations[location]['items']:
                print(item.name, end=", ")
            print()
        if location in self.locations and 'enemies' in self.locations[location] and self.locations[location]['enemies']:
            print("You see:", end=" ")
            for enemy in self.locations[location]['enemies']:
                print(enemy.name, end=", ")
            print()

    def describe_location(self, location):
        if location == "forest":
            print("A dense forest surrounds you, trees towering above.")
        elif location == "cave":
            print("You're in a dark cave, damp and cool.")
        elif location == "river":
            print("You stand by a rushing river, the water flowing swiftly.")

    def find_enemy(self, location, enemy_name):
        if location in self.locations and 'enemies' in self.locations[location]:
            for enemy in self.locations[location]['enemies']:
                if enemy.name.lower() == enemy_name.lower():
                    return enemy
        return None

    def take_item(self,location, item_name):
        if location in self.locations and 'items' in self.locations[location]:
            for i,item in enumerate(self.locations[location]['items']):
                if item.name.lower() == item_name.lower():
                    return self.locations[location]['items'].pop(i)
        return None

=== END FILE ===

=== FILE: enemy.py ===
class Enemy:
    def __init__(self, name, health, defense):
        self.name = name
        self.health = health
        self.defense = defense

    def on_death(self, player):
        print("Enemy is dead")


=== END FILE ===

=== FILE: items.py ===
class Item:
    def __init__(self, name):
        self.name = name

    def use(self, player):
        print(f"You used the {self.name}, but nothing happened.")


class Weapon(Item):
    def __init__(self, name, attack, durability):
        super().__init__(name)
        self.attack = attack
        self.durability = durability


class Potion(Item):
    def __init__(self, name, heal_amount):
        super().__init__(name)
        self.heal_amount = heal_amount

    def use(self, player):
        player.health += self.heal_amount
        print(f"You drank the {self.name} and recovered {self.heal_amount} health!")
        if player.health > 100:
            player.health = 100


=== END FILE ===