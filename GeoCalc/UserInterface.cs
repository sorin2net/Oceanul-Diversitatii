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

            bool running = true;
            while (running)
            {
                Console.WriteLine("\nInventory Management System");
                Console.WriteLine("1. Add Product");
                Console.WriteLine("2. Update Product");
                Console.WriteLine("3. Remove Product");
                Console.WriteLine("4. View Inventory");
                Console.WriteLine("5. Create Order");
                Console.WriteLine("6. View Orders");
                Console.WriteLine("7. Exit");

                Console.Write("Enter your choice: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1": productManager.AddProduct(); break;
                    case "2": productManager.UpdateProduct(); break;
                    case "3": productManager.RemoveProduct(); break;
                    case "4": inventory.DisplayInventory(); break;
                    case "5": orderManager.CreateOrder(); break;
                    case "6": orderManager.ViewOrders(); break;
                    case "7": running = false; break;
                    default: Console.WriteLine("Invalid choice."); break;
                }
            }
        }
    }
}
=== END FILE ===

=== FILE: Inventory.cs ===
using System;
using System.Collections.Generic;

namespace InventoryManager
{
    public class Inventory
    {
        private Dictionary<int, Product> products = new Dictionary<int, Product>();
        private List<Order> orders = new List<Order>();
        private int nextProductId = 1;

        public void AddProduct(Product product)
        {
            product.ProductId = nextProductId++;
            products.Add(product.ProductId, product);
        }

        public void UpdateProduct(int productId, Product updatedProduct)
        {
            if (products.ContainsKey(productId))
            {
                products[productId] = updatedProduct;
            }
            else
            {
                Console.WriteLine("Product not found.");
            }
        }

        public void RemoveProduct(int productId)
        {
            if (products.ContainsKey(productId))
            {
                products.Remove(productId);
            }
            else
            {
                Console.WriteLine("Product not found.");
            }
        }

        public Product GetProduct(int productId)
        {
            if (products.ContainsKey(productId))
            {
                return products[productId];
            }
            else
            {
                return null;
            }
        }

        public void AddOrder(Order order)
        {
            orders.Add(order);
        }

        public void DisplayInventory()
        {
            if (products.Count == 0)
            {
                Console.WriteLine("Inventory is empty.");
                return;
            }

            Console.WriteLine("\nCurrent Inventory:");
            foreach (var kvp in products)
            {
                Console.WriteLine(kvp.Value);
            }
        }

        public void DisplayOrders()
        {
            if (orders.Count == 0)
            {
                Console.WriteLine("No orders placed yet.");
                return;
            }

            Console.WriteLine("\nOrders:");
            foreach (var order in orders)
            {
                Console.WriteLine(order);
            }
        }
    }
}
=== END FILE ===

=== FILE: Product.cs ===
using System;

namespace InventoryManager
{
    public class Product
    {
        public int ProductId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public int Quantity { get; set; }

        public override string ToString()
        {
            return $"ID: {ProductId}, Name: {Name}, Description: {Description}, Price: {Price:C}, Quantity: {Quantity}";
        }
    }
}
=== END FILE ===

=== FILE: ProductManager.cs ===
using System;

namespace InventoryManager
{
    public class ProductManager
    {
        private Inventory inventory;

        public ProductManager(Inventory inventory)
        {
            this.inventory = inventory;
        }

        public void AddProduct()
        {
            Console.Write("Enter product name: ");
            string name = Console.ReadLine();
            Console.Write("Enter product description: ");
            string description = Console.ReadLine();
            Console.Write("Enter product price: ");
            double price = double.Parse(Console.ReadLine());
            Console.Write("Enter product quantity: ");
            int quantity = int.Parse(Console.ReadLine());

            Product product = new Product { Name = name, Description = description, Price = price, Quantity = quantity };
            inventory.AddProduct(product);
            Console.WriteLine("Product added successfully.");
        }


        public void UpdateProduct()
        {
            Console.Write("Enter product ID to update: ");
            int productId = int.Parse(Console.ReadLine());
            if (inventory.GetProduct(productId) == null)
            {
                Console.WriteLine("Product not found.");
                return;
            }
            Console.Write("Enter new product name: ");
            string name = Console.ReadLine();
            Console.Write("Enter new product description: ");
            string description = Console.ReadLine();
            Console.Write("Enter new product price: ");
            double price = double.Parse(Console.ReadLine());
            Console.Write("Enter new product quantity: ");
            int quantity = int.Parse(Console.ReadLine());

            Product updatedProduct = new Product { Name = name, Description = description, Price = price, Quantity = quantity };
            inventory.UpdateProduct(productId, updatedProduct);
            Console.WriteLine("Product updated successfully.");
        }

        public void RemoveProduct()
        {
            Console.Write("Enter product ID to remove: ");
            int productId = int.Parse(Console.ReadLine());
            inventory.RemoveProduct(productId);
            Console.WriteLine("Product removed successfully.");
        }
    }
}
=== END FILE ===

=== FILE: Order.cs ===
using System;
using System.Collections.Generic;
namespace InventoryManager
{
    public class Order
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public List<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

        public override string ToString()
        {
            string orderDetails = $"Order ID: {OrderId}, Order Date: {OrderDate}\n";
            foreach (var item in OrderItems)
            {
                orderDetails += item + "\n";
            }
            return orderDetails;
        }
    }

    public class OrderItem
    {
        public int ProductId { get; set; }
        public int Quantity { get; set; }

        public override string ToString()
        {
            return $"Product ID: {ProductId}, Quantity: {Quantity}";
        }
    }
}
=== END FILE ===

=== FILE: OrderManager.cs ===
using System;
using System.Collections.Generic;

namespace InventoryManager
{
    public class OrderManager
    {
        private Inventory inventory;
        private int nextOrderId = 1;

        public OrderManager(Inventory inventory)
        {
            this.inventory = inventory;
        }

        public void CreateOrder()
        {
            Order order = new Order { OrderId = nextOrderId++, OrderDate = DateTime.Now };
            bool addingItems = true;
            while (addingItems)
            {
                Console.Write("Enter product ID to add to order (or 0 to finish): ");
                int productId = int.Parse(Console.ReadLine());
                if (productId == 0)
                {
                    addingItems = false;
                    break;
                }
                if (inventory.GetProduct(productId) == null)
                {
                    Console.WriteLine("Product not found.");
                    continue;
                }
                Console.Write("Enter quantity: ");
                int quantity = int.Parse(Console.ReadLine());
                order.OrderItems.Add(new OrderItem { ProductId = productId, Quantity = quantity });
            }
            inventory.AddOrder(order);
            Console.WriteLine("Order created successfully.");
        }

        public void ViewOrders()
        {
            inventory.DisplayOrders();
        }
    }
}
=== END FILE ===