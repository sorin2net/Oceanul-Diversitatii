Title: InventoryManager

=== FILE: Item.java ===
package inventory;

public class Item {
    private String name;
    private String description;
    private double price;
    private int quantity;

    public Item(String name, String description, double price, int quantity) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity >= 0) {
            this.quantity = quantity;
        } else {
            System.out.println("Quantity cannot be negative.");
        }
    }

    public void updatePrice(double newPrice) {
      if(newPrice > 0) {
        this.price = newPrice;
      } else {
        System.out.println("Price cannot be negative or zero.");
      }
    }

    public String toString() {
        return "Name: " + name + ", Description: " + description + ", Price: $" + price + ", Quantity: " + quantity;
    }
}
=== END FILE ===

=== FILE: Inventory.java ===
package inventory;

import java.util.ArrayList;
import java.util.List;

public class Inventory {
    private List<Item> items;

    public Inventory() {
        this.items = new ArrayList<>();
    }

    public void addItem(Item item) {
        items.add(item);
    }

    public void removeItem(String itemName) {
        items.removeIf(item -> item.getName().equals(itemName));
    }

    public Item findItem(String itemName) {
        for (Item item : items) {
            if (item.getName().equals(itemName)) {
                return item;
            }
        }
        return null;
    }

    public double calculateTotalValue() {
        double totalValue = 0;
        for (Item item : items) {
            totalValue += item.getPrice() * item.getQuantity();
        }
        return totalValue;
    }


    public void displayInventory() {
        if (items.isEmpty()) {
            System.out.println("Inventory is empty.");
            return;
        }
        for (Item item : items) {
            System.out.println(item);
        }
        System.out.println("Total Inventory Value: $" + calculateTotalValue());
    }

    public void updateItemQuantity(String itemName, int newQuantity) {
        Item item = findItem(itemName);
        if (item != null) {
            item.setQuantity(newQuantity);
        } else {
            System.out.println("Item not found in inventory.");
        }
    }

    public void updateItemPrice(String itemName, double newPrice){
        Item item = findItem(itemName);
        if(item != null){
            item.updatePrice(newPrice);
        } else {
            System.out.println("Item not found in inventory.");
        }
    }
}
=== END FILE ===

=== FILE: InventoryManager.java ===
package inventory;

import java.util.Scanner;

public class InventoryManager {
    public static void main(String[] args) {
        Inventory inventory = new Inventory();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\nInventory Management System");
            System.out.println("1. Add Item");
            System.out.println("2. Remove Item");
            System.out.println("3. Find Item");
            System.out.println("4. Display Inventory");
            System.out.println("5. Update Item Quantity");
            System.out.println("6. Update Item Price");
            System.out.println("7. Exit");

            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    System.out.print("Enter item name: ");
                    String name = scanner.nextLine();
                    System.out.print("Enter description: ");
                    String description = scanner.nextLine();
                    System.out.print("Enter price: ");
                    double price = scanner.nextDouble();
                    System.out.print("Enter quantity: ");
                    int quantity = scanner.nextInt();
                    scanner.nextLine();
                    inventory.addItem(new Item(name, description, price, quantity));
                    break;
                case 2:
                    System.out.print("Enter item name to remove: ");
                    String itemNameToRemove = scanner.nextLine();
                    inventory.removeItem(itemNameToRemove);
                    break;
                case 3:
                    System.out.print("Enter item name to find: ");
                    String itemNameToFind = scanner.nextLine();
                    Item item = inventory.findItem(itemNameToFind);
                    if (item != null) {
                        System.out.println(item);
                    } else {
                        System.out.println("Item not found.");
                    }
                    break;
                case 4:
                    inventory.displayInventory();
                    break;
                case 5:
                    System.out.print("Enter item name to update quantity: ");
                    String itemNameToUpdateQuantity = scanner.nextLine();
                    System.out.print("Enter new quantity: ");
                    int newQuantity = scanner.nextInt();
                    inventory.updateItemQuantity(itemNameToUpdateQuantity, newQuantity);
                    break;
                case 6:
                    System.out.print("Enter item name to update price: ");
                    String itemNameToUpdatePrice = scanner.nextLine();
                    System.out.print("Enter new price: ");
                    double newPrice = scanner.nextDouble();
                    inventory.updateItemPrice(itemNameToUpdatePrice, newPrice);
                    break;
                case 7:
                    System.out.println("Exiting...");
                    scanner.close();
                    return;
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
=== END FILE ===