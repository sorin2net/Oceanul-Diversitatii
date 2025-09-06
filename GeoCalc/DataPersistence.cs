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
            ProductManager productManager = new ProductManager(inventory);
            OrderManager orderManager = new OrderManager(inventory);

            //Populate inventory with sample data
            productManager.AddProduct(new Product("Laptop", 1000, 10));
            productManager.AddProduct(new Product("Mouse", 25, 50));
            productManager.AddProduct(new Product("Keyboard", 75, 20));

            //Simulate order processing
            orderManager.CreateOrder(new Order(new List<OrderItem> { 
                new OrderItem(inventory.FindProduct("Laptop"), 2),
                new OrderItem(inventory.FindProduct("Mouse"), 5)
            }));
            
            orderManager.ProcessOrders();
            inventory.DisplayInventory();
            Console.ReadKey();
        }
    }
}
=== END FILE ===

=== FILE: Inventory.cs ===
using System;
using System.Collections.Generic;
using System.Linq;

namespace InventoryManager
{
    public class Inventory
    {
        private Dictionary<string, Product> products;

        public Inventory()
        {
            products = new Dictionary<string, Product>();
        }

        public void AddProduct(Product product)
        {
            products.Add(product.Name, product);
        }

        public Product FindProduct(string productName)
        {
            if (products.ContainsKey(productName))
            {
                return products[productName];
            }
            return null;
        }

        public void UpdateProductQuantity(string productName, int quantity)
        {
            if (products.ContainsKey(productName))
            {
                products[productName].Quantity += quantity;
            }
        }

        public void RemoveProduct(string productName)
        {
            if (products.ContainsKey(productName))
            {
                products.Remove(productName);
            }
        }

        public void DisplayInventory()
        {
            Console.WriteLine("\nCurrent Inventory:");
            if (products.Count == 0)
            {
                Console.WriteLine("Inventory is empty.");
                return;
            }
            foreach (var product in products.Values)
            {
                Console.WriteLine($"{product.Name} - Quantity: {product.Quantity}, Price: {product.Price}");
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
        public double Price { get; set; }
        public int Quantity { get; set; }

        public Product(string name, double price, int quantity)
        {
            Name = name;
            Price = price;
            Quantity = quantity;
        }
    }
}
=== END FILE ===

=== FILE: Order.cs ===
using System.Collections.Generic;

namespace InventoryManager
{
    public class Order
    {
        public List<OrderItem> OrderItems { get; set; }

        public Order(List<OrderItem> orderItems)
        {
            OrderItems = orderItems;
        }
    }
}
=== END FILE ===

=== FILE: OrderItem.cs ===
namespace InventoryManager
{
    public class OrderItem
    {
        public Product Product { get; set; }
        public int Quantity { get; set; }

        public OrderItem(Product product, int quantity)
        {
            Product = product;
            Quantity = quantity;
        }
    }
}
=== END FILE ===

=== FILE: ProductManager.cs ===
namespace InventoryManager
{
    public class ProductManager
    {
        private Inventory inventory;

        public ProductManager(Inventory inventory)
        {
            this.inventory = inventory;
        }

        public void AddProduct(Product product)
        {
            inventory.AddProduct(product);
        }

        public void RemoveProduct(string productName)
        {
            inventory.RemoveProduct(productName);
        }

        public void UpdateProduct(string productName, double newPrice, int newQuantity)
        {
            Product product = inventory.FindProduct(productName);
            if (product != null)
            {
                product.Price = newPrice;
                product.Quantity = newQuantity;
            }
        }
    }
}
=== END FILE ===


=== FILE: OrderManager.cs ===
using System;
using System.Collections.Generic;
using System.Linq;

namespace InventoryManager
{
    public class OrderManager
    {
        private Inventory inventory;

        public OrderManager(Inventory inventory)
        {
            this.inventory = inventory;
        }

        public void CreateOrder(Order order)
        {
            foreach (OrderItem orderItem in order.OrderItems)
            {
                if (orderItem.Product.Quantity >= orderItem.Quantity)
                {
                    inventory.UpdateProductQuantity(orderItem.Product.Name, -orderItem.Quantity);
                    Console.WriteLine($"Order created for {orderItem.Product.Name} - Quantity: {orderItem.Quantity}");
                }
                else
                {
                    Console.WriteLine($"Not enough stock for {orderItem.Product.Name}. Order cannot be completed.");
                }
            }
        }

        public void ProcessOrders()
        {
            //Simulate order processing -  in a real application this would involve more complex logic.
            Console.WriteLine("\nOrders processed successfully.");
        }
    }
}
=== END FILE ===