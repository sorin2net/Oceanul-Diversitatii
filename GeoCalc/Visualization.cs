Title: InventoryManager

=== FILE: Program.cs ===
using System;
using System.Collections.Generic;

namespace InventoryManager
{
    class Program
    {
        static void Main(string[] args)
        {
            Inventory inventory = new Inventory();
            Product product1 = new Product("Laptop", "Dell XPS 13", 1200, 5);
            Product product2 = new Product("Tablet", "iPad Pro", 800, 10);
            Product product3 = new Product("Mouse", "Logitech MX Master", 100, 20);

            inventory.AddProduct(product1);
            inventory.AddProduct(product2);
            inventory.AddProduct(product3);

            inventory.DisplayInventory();

            Console.WriteLine("\nSearching for 'iPad':");
            inventory.SearchProduct("iPad");

            Console.WriteLine("\nRemoving 3 Laptops:");
            inventory.RemoveProduct("Laptop", 3);
            inventory.DisplayInventory();


            Console.WriteLine("\nAdding 5 more Tablets:");
            inventory.AddProduct(product2, 5);
            inventory.DisplayInventory();

            Console.WriteLine("\nGenerating report:");
            inventory.GenerateReport("inventory_report.txt");
            Console.WriteLine("Report generated to inventory_report.txt");

            Console.ReadKey();
        }
    }
}
=== END FILE ===

=== FILE: Inventory.cs ===
using System;
using System.Collections.Generic;
using System.IO;

namespace InventoryManager
{
    public class Inventory
    {
        private List<Product> products;

        public Inventory()
        {
            products = new List<Product>();
        }

        public void AddProduct(Product product, int quantity = 1)
        {
            bool found = false;
            foreach (Product p in products)
            {
                if (p.Name == product.Name && p.Model == product.Model)
                {
                    p.Quantity += quantity;
                    found = true;
                    break;
                }
            }
            if (!found)
            {
                products.Add(product);
            }
        }

        public void RemoveProduct(string name, int quantity)
        {
            foreach (Product p in products)
            {
                if (p.Name == name && p.Quantity >= quantity)
                {
                    p.Quantity -= quantity;
                    if (p.Quantity == 0)
                    {
                        products.Remove(p);
                    }
                    return;
                }
            }
            Console.WriteLine($"Not enough {name} in stock to remove {quantity}.");
        }

        public void DisplayInventory()
        {
            Console.WriteLine("Current Inventory:");
            foreach (Product p in products)
            {
                Console.WriteLine($"{p.Name} - {p.Model}: {p.Quantity} units, Price: ${p.Price}");
            }
        }

        public void SearchProduct(string keyword)
        {
            bool found = false;
            foreach (Product p in products)
            {
                if (p.Name.ToLower().Contains(keyword.ToLower()) || p.Model.ToLower().Contains(keyword.ToLower()))
                {
                    Console.WriteLine($"{p.Name} - {p.Model}: {p.Quantity} units, Price: ${p.Price}");
                    found = true;
                }
            }
            if (!found)
            {
                Console.WriteLine("No products found matching the keyword.");
            }
        }


        public void GenerateReport(string filename)
        {
            using (StreamWriter writer = new StreamWriter(filename))
            {
                writer.WriteLine("Inventory Report:");
                writer.WriteLine("------------------");
                foreach (Product p in products)
                {
                    writer.WriteLine($"{p.Name} - {p.Model}: {p.Quantity} units, Price: ${p.Price}");
                }
            }
        }
    }
}
=== END FILE ===

=== FILE: Product.cs ===
namespace InventoryManager
{
    public class Product
    {
        public string Name { get; set; }
        public string Model { get; set; }
        public double Price { get; set; }
        public int Quantity { get; set; }

        public Product(string name, string model, double price, int quantity)
        {
            Name = name;
            Model = model;
            Price = price;
            Quantity = quantity;
        }
    }
}
=== END FILE ===