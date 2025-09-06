Title: ZooManagement

=== FILE: Animal.cs ===
using System;
using System.Collections.Generic;

public class Animal
{
    public string Name { get; set; }
    public string Species { get; set; }
    public int Age { get; set; }
    public string Diet { get; set; }
    public double Weight { get; set; }

    public Animal(string name, string species, int age, string diet, double weight)
    {
        Name = name;
        Species = species;
        Age = age;
        Diet = diet;
        Weight = weight;
    }

    public virtual string MakeSound()
    {
        return "Generic animal sound";
    }

    public override string ToString()
    {
        return $"Name: {Name}, Species: {Species}, Age: {Age}, Diet: {Diet}, Weight: {Weight}";
    }
}

public class Mammal : Animal
{
    public bool IsNocturnal { get; set; }

    public Mammal(string name, string species, int age, string diet, double weight, bool isNocturnal) : base(name, species, age, diet, weight)
    {
        IsNocturnal = isNocturnal;
    }

    public override string MakeSound()
    {
        return "Mammal sound";
    }
}

public class Bird : Animal
{
    public double Wingspan { get; set; }

    public Bird(string name, string species, int age, string diet, double weight, double wingspan) : base(name, species, age, diet, weight)
    {
        Wingspan = wingspan;
    }

    public override string MakeSound()
    {
        return "Bird sound";
    }
}
=== END FILE ===

=== FILE: Enclosure.cs ===
using System;
using System.Collections.Generic;

public class Enclosure
{
    public string Name { get; set; }
    public string Type { get; set; }
    public double Size { get; set; }
    public List<Animal> Animals { get; set; } = new List<Animal>();

    public Enclosure(string name, string type, double size)
    {
        Name = name;
        Type = type;
        Size = size;
    }

    public void AddAnimal(Animal animal)
    {
        Animals.Add(animal);
    }

    public void RemoveAnimal(Animal animal)
    {
        Animals.Remove(animal);
    }

    public string GetAnimalReport()
    {
        string report = $"Enclosure: {Name}, Type: {Type}, Size: {Size}\nAnimals:\n";
        if (Animals.Count == 0)
        {
            report += "No animals in this enclosure.\n";
        }
        else
        {
            foreach (var animal in Animals)
            {
                report += $"{animal}\n";
            }
        }
        return report;
    }
}
=== END FILE ===

=== FILE: Zoo.cs ===
using System;
using System.Collections.Generic;

public class Zoo
{
    public string Name { get; set; }
    public List<Enclosure> Enclosures { get; set; } = new List<Enclosure>();

    public Zoo(string name)
    {
        Name = name;
    }

    public void AddEnclosure(Enclosure enclosure)
    {
        Enclosures.Add(enclosure);
    }

    public void RemoveEnclosure(Enclosure enclosure)
    {
        Enclosures.Remove(enclosure);
    }

    public string GetZooReport()
    {
        string report = $"Zoo: {Name}\nEnclosures:\n";
        foreach (var enclosure in Enclosures)
        {
            report += enclosure.GetAnimalReport() + "\n";
        }
        return report;
    }

    public void SimulateDay()
    {
        Random random = new Random();
        foreach (var enclosure in Enclosures)
        {
            foreach (var animal in enclosure.Animals)
            {
                Console.WriteLine($"{animal.Name} ({animal.Species}) makes a {animal.MakeSound()}");
                animal.Weight += random.NextDouble() * 2; //Simulate weight change
            }
        }
    }


}
=== END FILE ===

=== FILE: Program.cs ===
using System;

public class Program
{
    public static void Main(string[] args)
    {
        Zoo myZoo = new Zoo("City Zoo");

        Enclosure lionEnclosure = new Enclosure("Lion Enclosure", "Savanna", 1000);
        lionEnclosure.AddAnimal(new Mammal("Leo", "Lion", 5, "Meat", 250, false));
        lionEnclosure.AddAnimal(new Mammal("Nala", "Lion", 4, "Meat", 220, false));
        myZoo.AddEnclosure(lionEnclosure);

        Enclosure birdEnclosure = new Enclosure("Aviary", "Tropical", 500);
        birdEnclosure.AddAnimal(new Bird("Tweety", "Canary", 2, "Seeds", 0.1, 0.2));
        birdEnclosure.AddAnimal(new Bird("Polly", "Parrot", 7, "Fruits", 0.5, 0.7));
        myZoo.AddEnclosure(birdEnclosure);


        Console.WriteLine(myZoo.GetZooReport());

        for(int i = 0; i < 7; i++)
        {
            Console.WriteLine($"\n--- Day {i+1} ---");
            myZoo.SimulateDay();
        }

        Console.WriteLine("\nFinal Zoo Report:");
        Console.WriteLine(myZoo.GetZooReport());
    }
}
=== END FILE ===