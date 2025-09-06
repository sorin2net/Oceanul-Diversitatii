Title: InventoryManager

=== FILE: Item.java ===
package inventory;

public class Item {
    private String name;
    private int quantity;
    private double price;
    private String category;

    public Item(String name, int quantity, double price, String category) {
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.category = category;
    }

    public String getName() { return name; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public String getCategory() { return category; }

    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotalValue() { return quantity * price; }

    public String toString() {
        return "Name: " + name + ", Quantity: " + quantity + ", Price: $" + price + ", Category: " + category;
    }


    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Item item = (Item) obj;
        return quantity == item.quantity && Double.compare(item.price, price) == 0 && name.equals(item.name) && category.equals(item.category);
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
        items = new ArrayList<>();
    }

    public void addItem(Item item) {
        items.add(item);
    }

    public void removeItem(Item item) {
        items.remove(item);
    }

    public void updateItemQuantity(String itemName, int newQuantity) {
        for (Item item : items) {
            if (item.getName().equals(itemName)) {
                item.setQuantity(newQuantity);
                return;
            }
        }
    }

    public double getTotalInventoryValue() {
        double totalValue = 0;
        for (Item item : items) {
            totalValue += item.getTotalValue();
        }
        return totalValue;
    }

    public List<Item> getItemsByCategory(String category) {
        List<Item> filteredItems = new ArrayList<>();
        for (Item item : items) {
            if (item.getCategory().equals(category)) {
                filteredItems.add(item);
            }
        }
        return filteredItems;
    }

    public Item findItemByName(String itemName){
        for(Item item : items){
            if(item.getName().equals(itemName)) return item;
        }
        return null;
    }

    public void printInventory() {
        for (Item item : items) {
            System.out.println(item);
        }
    }

    public List<Item> getItems() {return items;}
}
=== END FILE ===

=== FILE: InventoryReport.java ===
package inventory;

import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;

public class InventoryReport {

    public static void generateReport(Inventory inventory, String filePath) {
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write("Inventory Report\n\n");
            DecimalFormat df = new DecimalFormat("#.##");
            for (Item item : inventory.getItems()) {
                writer.write("Item: " + item.getName() + "\n");
                writer.write("Quantity: " + item.getQuantity() + "\n");
                writer.write("Price: $" + df.format(item.getPrice()) + "\n");
                writer.write("Total Value: $" + df.format(item.getTotalValue()) + "\n\n");
            }
            writer.write("Total Inventory Value: $" + df.format(inventory.getTotalInventoryValue()) + "\n");
        } catch (IOException e) {
            System.err.println("Error generating report: " + e.getMessage());
        }
    }

}
=== END FILE ===


=== FILE: Main.java ===
package inventory;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Inventory inventory = new Inventory();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\nInventory Management System");
            System.out.println("1. Add Item");
            System.out.println("2. Remove Item");
            System.out.println("3. Update Item Quantity");
            System.out.println("4. Generate Report");
            System.out.println("5. View Inventory");
            System.out.println("6. View Items by Category");
            System.out.println("7. Exit");

            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    System.out.print("Enter item name: ");
                    String name = scanner.nextLine();
                    System.out.print("Enter quantity: ");
                    int quantity = scanner.nextInt();
                    System.out.print("Enter price: ");
                    double price = scanner.nextDouble();
                    scanner.nextLine();
                    System.out.print("Enter category: ");
                    String category = scanner.nextLine();
                    inventory.addItem(new Item(name, quantity, price, category));
                    break;
                case 2:
                    System.out.print("Enter item name to remove: ");
                    String itemNameToRemove = scanner.nextLine();
                    Item itemToRemove = inventory.findItemByName(itemNameToRemove);
                    if(itemToRemove != null) inventory.removeItem(itemToRemove);
                    else System.out.println("Item not found.");
                    break;
                case 3:
                    System.out.print("Enter item name to update: ");
                    String itemNameToUpdate = scanner.nextLine();
                    System.out.print("Enter new quantity: ");
                    int newQuantity = scanner.nextInt();
                    inventory.updateItemQuantity(itemNameToUpdate, newQuantity);
                    break;
                case 4:
                    InventoryReport.generateReport(inventory, "inventory_report.txt");
                    System.out.println("Report generated successfully.");
                    break;
                case 5:
                    inventory.printInventory();
                    break;
                case 6:
                    System.out.print("Enter category to filter by: ");
                    String categoryToFilter = scanner.nextLine();
                    for(Item item : inventory.getItemsByCategory(categoryToFilter)){
                        System.out.println(item);
                    }
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