Title: InventoryManager

=== FILE: Product.cs ===
using System;

public class Product
{
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public DateTime DateAdded { get; set; }

    public Product(string name, string description, decimal price, int quantity)
    {
        Name = name;
        Description = description;
        Price = price;
        Quantity = quantity;
        DateAdded = DateTime.Now;
    }

    public override string ToString()
    {
        return $"Name: {Name}, Description: {Description}, Price: {Price:C}, Quantity: {Quantity}, Added: {DateAdded}";
    }

    public void UpdateQuantity(int quantityChange)
    {
        Quantity += quantityChange;
        if (Quantity < 0)
        {
            Quantity = 0;
            Console.WriteLine("Warning: Quantity cannot be negative. Set to 0.");
        }
    }

    public decimal CalculateTotalValue()
    {
        return Price * Quantity;
    }
}
=== END FILE ===

=== FILE: Inventory.cs ===
using System;
using System.Collections.Generic;
using System.Linq;

public class Inventory
{
    private List<Product> products;

    public Inventory()
    {
        products = new List<Product>();
    }

    public void AddProduct(Product product)
    {
        products.Add(product);
    }

    public void RemoveProduct(string productName)
    {
        Product productToRemove = products.FirstOrDefault(p => p.Name == productName);
        if (productToRemove != null)
        {
            products.Remove(productToRemove);
        }
        else
        {
            Console.WriteLine($"Product {productName} not found.");
        }
    }

    public void UpdateProductQuantity(string productName, int quantityChange)
    {
        Product productToUpdate = products.FirstOrDefault(p => p.Name == productName);
        if (productToUpdate != null)
        {
            productToUpdate.UpdateQuantity(quantityChange);
        }
        else
        {
            Console.WriteLine($"Product {productName} not found.");
        }
    }

    public decimal CalculateTotalInventoryValue()
    {
        return products.Sum(p => p.CalculateTotalValue());
    }

    public void DisplayInventory()
    {
        if (products.Count == 0)
        {
            Console.WriteLine("Inventory is empty.");
            return;
        }
        Console.WriteLine("Current Inventory:");
        foreach (Product product in products)
        {
            Console.WriteLine(product);
        }
        Console.WriteLine($"Total Inventory Value: {CalculateTotalInventoryValue():C}");

    }

    public List<Product> GetProductsBelowThreshold(decimal priceThreshold)
    {
        return products.Where(p => p.Price < priceThreshold).ToList();
    }

    public List<Product> GetProductsAddedAfterDate(DateTime date)
    {
        return products.Where(p => p.DateAdded > date).ToList();
    }
}
=== END FILE ===

=== FILE: Program.cs ===
using System;
using System.Collections.Generic;

public class Program
{
    public static void Main(string[] args)
    {
        Inventory inventory = new Inventory();

        inventory.AddProduct(new Product("Laptop", "High-performance laptop", 1200, 10));
        inventory.AddProduct(new Product("Mouse", "Wireless mouse", 25, 50));
        inventory.AddProduct(new Product("Keyboard", "Mechanical keyboard", 80, 20));
        inventory.AddProduct(new Product("Monitor", "27-inch monitor", 300, 15));

        inventory.DisplayInventory();

        inventory.UpdateProductQuantity("Mouse", -10);
        inventory.RemoveProduct("Monitor");

        Console.WriteLine("\nInventory after updates:");
        inventory.DisplayInventory();

        Console.WriteLine("\nProducts below $50:");
        foreach (var product in inventory.GetProductsBelowThreshold(50))
        {
            Console.WriteLine(product);
        }


        Console.WriteLine("\nProducts added after 1/1/2024:");
        foreach(var product in inventory.GetProductsAddedAfterDate(new DateTime(2024,1,1)))
        {
            Console.WriteLine(product);
        }
    }
}
=== END FILE ===

=== FILE: ReportGenerator.cs ===
using System;
using System.IO;

public class ReportGenerator
{
    public static void GenerateInventoryReport(Inventory inventory, string filePath)
    {
        using (StreamWriter writer = new StreamWriter(filePath))
        {
            writer.WriteLine("Inventory Report");
            writer.WriteLine("-----------------");
            writer.WriteLine($"Generated on: {DateTime.Now}");
            writer.WriteLine();
            inventory.DisplayInventory();

            writer.WriteLine();
            writer.WriteLine("Products below $50:");
            foreach(var product in inventory.GetProductsBelowThreshold(50))
            {
                writer.WriteLine(product);
            }
            writer.Close();
        }
    }
}
=== END FILE ===