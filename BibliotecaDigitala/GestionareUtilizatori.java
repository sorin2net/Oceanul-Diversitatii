Title: InventoryManager

=== FILE: Product.java ===
package inventory;

public class Product {
    private String productName;
    private String productID;
    private double price;
    private int quantity;

    public Product(String productName, String productID, double price, int quantity) {
        this.productName = productName;
        this.productID = productID;
        this.price = price;
        this.quantity = quantity;
    }

    public String getProductName() { return productName; }
    public String getProductID() { return productID; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }

    public void setQuantity(int quantity) { this.quantity = quantity; }

    public void updatePrice(double newPrice){
        if(newPrice > 0) this.price = newPrice;
    }

    @Override
    public String toString() {
        return "Product{" +
                "productName='" + productName + '\'' +
                ", productID='" + productID + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}
=== END FILE ===

=== FILE: Inventory.java ===
package inventory;

import java.util.ArrayList;
import java.util.List;

public class Inventory {
    private List<Product> products;

    public Inventory() {
        this.products = new ArrayList<>();
    }

    public void addProduct(Product product) {
        this.products.add(product);
    }

    public void removeProduct(String productID) {
        products.removeIf(p -> p.getProductID().equals(productID));
    }

    public Product findProduct(String productID) {
        for (Product p : products) {
            if (p.getProductID().equals(productID)) {
                return p;
            }
        }
        return null;
    }

    public void updateProductQuantity(String productID, int quantity) {
        Product product = findProduct(productID);
        if (product != null && quantity >=0) {
            product.setQuantity(quantity);
        }
    }


    public double calculateTotalValue() {
        double totalValue = 0;
        for (Product p : products) {
            totalValue += p.getPrice() * p.getQuantity();
        }
        return totalValue;
    }

    public List<Product> getLowStockProducts(int threshold){
        List<Product> lowStock = new ArrayList<>();
        for(Product p : products){
            if(p.getQuantity() < threshold) lowStock.add(p);
        }
        return lowStock;
    }

    public void printInventory(){
        for(Product p : products){
            System.out.println(p);
        }
    }
}
=== END FILE ===


=== FILE: Main.java ===
package inventory;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Inventory inventory = new Inventory();

        while (true) {
            System.out.println("1. Add product");
            System.out.println("2. Remove product");
            System.out.println("3. Update product quantity");
            System.out.println("4. Update product price");
            System.out.println("5. Find product");
            System.out.println("6. Calculate total value");
            System.out.println("7. Get low stock products");
            System.out.println("8. Print inventory");
            System.out.println("9. Exit");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    System.out.print("Enter product name: ");
                    String productName = scanner.nextLine();
                    System.out.print("Enter product ID: ");
                    String productID = scanner.nextLine();
                    System.out.print("Enter price: ");
                    double price = scanner.nextDouble();
                    System.out.print("Enter quantity: ");
                    int quantity = scanner.nextInt();
                    scanner.nextLine();
                    inventory.addProduct(new Product(productName, productID, price, quantity));
                    break;
                case 2:
                    System.out.print("Enter product ID to remove: ");
                    String removeID = scanner.nextLine();
                    inventory.removeProduct(removeID);
                    break;
                case 3:
                    System.out.print("Enter product ID to update: ");
                    String updateID = scanner.nextLine();
                    System.out.print("Enter new quantity: ");
                    int newQuantity = scanner.nextInt();
                    inventory.updateProductQuantity(updateID, newQuantity);
                    scanner.nextLine();
                    break;
                case 4:
                    System.out.print("Enter product ID to update: ");
                    String updatePriceID = scanner.nextLine();
                    System.out.print("Enter new price: ");
                    double newPrice = scanner.nextDouble();
                    Product p = inventory.findProduct(updatePriceID);
                    if(p != null) p.updatePrice(newPrice);
                    scanner.nextLine();
                    break;
                case 5:
                    System.out.print("Enter product ID to find: ");
                    String findID = scanner.nextLine();
                    System.out.println(inventory.findProduct(findID));
                    break;
                case 6:
                    System.out.println("Total value: " + inventory.calculateTotalValue());
                    break;
                case 7:
                    System.out.print("Enter low stock threshold: ");
                    int threshold = scanner.nextInt();
                    System.out.println(inventory.getLowStockProducts(threshold));
                    scanner.nextLine();
                    break;
                case 8:
                    inventory.printInventory();
                    break;
                case 9:
                    System.exit(0);
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
=== END FILE ===