Title: InventoryManager

=== FILE: inventory.py ===
class InventoryItem:
    def __init__(self, item_id, name, quantity, price):
        self.item_id = item_id
        self.name = name
        self.quantity = quantity
        self.price = price

    def update_quantity(self, quantity_change):
        self.quantity += quantity_change
        if self.quantity < 0:
            self.quantity = 0

    def __str__(self):
        return f"ID: {self.item_id}, Name: {self.name}, Quantity: {self.quantity}, Price: {self.price}"

class Inventory:
    def __init__(self):
        self.items = {}

    def add_item(self, item):
        self.items[item.item_id] = item

    def remove_item(self, item_id):
        if item_id in self.items:
            del self.items[item_id]

    def update_item_quantity(self, item_id, quantity_change):
        if item_id in self.items:
            self.items[item_id].update_quantity(quantity_change)

    def search_item(self, search_term):
        results = []
        for item in self.items.values():
            if search_term.lower() in item.name.lower():
                results.append(item)
        return results

    def generate_report(self):
        report = "Inventory Report:\n"
        total_value = 0
        for item in self.items.values():
            report += str(item) + "\n"
            total_value += item.quantity * item.price
        report += f"\nTotal Inventory Value: ${total_value:.2f}"
        return report

=== END FILE ===

=== FILE: ui.py ===
import tkinter as tk
from inventory import Inventory, InventoryItem

class InventoryUI:
    def __init__(self, master, inventory):
        self.master = master
        master.title("Inventory Manager")
        self.inventory = inventory

        self.item_id_label = tk.Label(master, text="Item ID:")
        self.item_id_label.grid(row=0, column=0)
        self.item_id_entry = tk.Entry(master)
        self.item_id_entry.grid(row=0, column=1)

        self.name_label = tk.Label(master, text="Name:")
        self.name_label.grid(row=1, column=0)
        self.name_entry = tk.Entry(master)
        self.name_entry.grid(row=1, column=1)

        self.quantity_label = tk.Label(master, text="Quantity:")
        self.quantity_label.grid(row=2, column=0)
        self.quantity_entry = tk.Entry(master)
        self.quantity_entry.grid(row=2, column=1)

        self.price_label = tk.Label(master, text="Price:")
        self.price_label.grid(row=3, column=0)
        self.price_entry = tk.Entry(master)
        self.price_entry.grid(row=3, column=1)

        self.add_button = tk.Button(master, text="Add Item", command=self.add_item)
        self.add_button.grid(row=4, column=0, columnspan=2)

        self.search_label = tk.Label(master, text="Search:")
        self.search_label.grid(row=5, column=0)
        self.search_entry = tk.Entry(master)
        self.search_entry.grid(row=5, column=1)
        self.search_button = tk.Button(master, text="Search", command=self.search_item)
        self.search_button.grid(row=6, column=0, columnspan=2)

        self.report_button = tk.Button(master, text="Generate Report", command=self.generate_report)
        self.report_button.grid(row=7, column=0, columnspan=2)

        self.output_text = tk.Text(master, height=10, width=30)
        self.output_text.grid(row=8, column=0, columnspan=2)


    def add_item(self):
        try:
            item_id = int(self.item_id_entry.get())
            name = self.name_entry.get()
            quantity = int(self.quantity_entry.get())
            price = float(self.price_entry.get())
            item = InventoryItem(item_id, name, quantity, price)
            self.inventory.add_item(item)
            self.output_text.insert(tk.END, "Item added successfully!\n")
        except ValueError:
            self.output_text.insert(tk.END, "Invalid input. Please use numbers for quantity and price.\n")

    def search_item(self):
        search_term = self.search_entry.get()
        results = self.inventory.search_item(search_term)
        self.output_text.delete("1.0", tk.END)
        for item in results:
            self.output_text.insert(tk.END, str(item) + "\n")


    def generate_report(self):
        report = self.inventory.generate_report()
        self.output_text.delete("1.0", tk.END)
        self.output_text.insert(tk.END, report)


=== END FILE ===

=== FILE: main.py ===
from inventory import Inventory
from ui import InventoryUI
import tkinter as tk

inventory = Inventory()
root = tk.Tk()
ui = InventoryUI(root, inventory)
root.mainloop()
=== END FILE ===