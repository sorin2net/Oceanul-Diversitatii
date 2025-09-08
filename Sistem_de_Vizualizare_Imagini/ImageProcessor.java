```java
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ImageProcessor {

    private static final Logger LOGGER = Logger.getLogger(ImageProcessor.class.getName());
    private static ImageProcessor instance;

    private ImageProcessor() {
    }

    public static ImageProcessor getInstance() {
        if (instance == null) {
            synchronized (ImageProcessor.class) {
                if (instance == null) {
                    instance = new ImageProcessor();
                }
            }
        }
        return instance;
    }


    public List<BufferedImage> processImages(String directory) {
        File folder = new File(directory);
        if (!folder.exists() || !folder.isDirectory()) {
            throw new IllegalArgumentException("Invalid directory: " + directory);
        }


        List<BufferedImage> images = new ArrayList<>();
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".png"));


        if(files==null || files.length==0){
            throw new IllegalArgumentException("No valid image files found in the specified directory.");
        }

        for (File file : files) {
            try {
                BufferedImage image = ImageIO.read(file);
                if(image!=null){
                    images.add(image);
                } else {
                   LOGGER.log(Level.WARNING,"Error loading image: " + file.getAbsolutePath()); 
                }


            } catch (IOException ex) {
                LOGGER.log(Level.SEVERE, "Error processing image: " + file.getAbsolutePath(), ex);
                //throw new RuntimeException("Error processing image", ex);  // Consider more specific exception handling
            }
        }
        return images;
    }

   
    // Example usage (you would likely integrate this into a GUI)
    public static void main(String[] args) {

        try {

             String imageDirectory = "path/to/your/images"; // Replace with your directory
             ImageProcessor processor = ImageProcessor.getInstance();

             List<BufferedImage> processedImages = processor.processImages(imageDirectory);

             // Implement image display logic here (e.g., using Swing, JavaFX)

             System.out.println("Successfully processed images.");

        } catch (IllegalArgumentException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}

```

**Explicații și îmbunătățiri:**

* **Singleton:**  `ImageProcessor` este acum un singleton, asigurând accesul global la un singur obiect `ImageProcessor`.
* **Gestionarea erorilor:**  Folosește `IllegalArgumentException` pentru erori de intrare invalidă și  `RuntimeException` pentru erori severe.  Folosește `java.util.logging` pentru înregistrarea evenimentelor, ajutând la depanare.  Este esențial să gestionezi erorile de citire a imaginilor.
* **Validare:** Verifică dacă directorul este valid și dacă conține fișiere de imagine.
* **Logging:**  Utilizează `Logger` pentru a înregistra evenimentele, mesaje de avertizare, și erori. Aceasta te ajută la depanare.  Logger-ul este configurat pentru `ImageProcessor.class`
* **Compatibilitate:**  Codul prelucrează imagini .jpg și .png.
* **Clarificări:** Codul este mai clar și structurat.
* **Main method:**  A fost adăugat un `main` pentru demonstrație.


**Cum să folosești:**

1. **Creează un director:**  Creează un director cu imaginile tale.
2. **Înlocuiește calea:** Schimbă `imageDirectory` cu calea absolută sau relativă către directorul tău.
3. **Integrare GUI:**  Implementă logica pentru afișarea imaginilor într-o interfață grafică (de exemplu, folosind Swing sau JavaFX).
4. **Rulează:** Compilează și rulează codul.

**Următorii pași:**

* **GUI (JavaFX sau Swing):**  Creează o interfață grafică pentru a permite utilizatorilor să navigheze prin imagini.
* **Prelucrare Imagine:**  Adaugă funcționalități de prelucrare a imaginilor (de exemplu, redimensionare, rotire, filtrare).
* **HTML, CSS, JavaScript:**  Dezvoltă o interfață web pentru vizualizarea imaginilor (poate utiliza un backend Java).


**Importanți:**

* Adaugă gestionarea excepțiilor pentru a evita oprirea bruscă a aplicației.
* Adaugă validări mai complexe și logice.
* Folosește un framework GUI adecvat pentru a construi o interfață utilizator robustă.


Acest cod extins oferă un punct de plecare solid pentru dezvoltarea proiectului tău. Reține că dezvoltarea unui sistem complet de vizualizare a imaginilor necesită mai multe module și un design mai sofisticat. Acestea trebuie implementate pe baza cerințelor specifice ale proiectului tău.

```java
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class ImageProcessor {

    private static final Logger LOGGER = Logger.getLogger(ImageProcessor.class.getName());
    private static ImageProcessor instance;

    private ImageProcessor() {
    }

    public static ImageProcessor getInstance() {
        if (instance == null) {
            synchronized (ImageProcessor.class) {
                if (instance == null) {
                    instance = new ImageProcessor();
                }
            }
        }
        return instance;
    }

    public List<ImageInfo> processImages(String directory) {
        Path dirPath = Paths.get(directory);
		if (!Files.isDirectory(dirPath)) {
			throw new IllegalArgumentException("Invalid directory: " + directory);
		}

        List<ImageInfo> images = new ArrayList<>();
        try {
            Files.list(dirPath)
                    .filter(Files::isRegularFile)
                    .filter(path -> path.toString().toLowerCase().endsWith(".jpg") || path.toString().toLowerCase().endsWith(".png"))
                    .forEach(path -> {
                        try {
                            BufferedImage image = ImageIO.read(path.toFile());
                            if (image != null) {
                                images.add(new ImageInfo(path.toString(), image.getWidth(), image.getHeight()));
                            } else {
                                LOGGER.log(Level.WARNING, "Error loading image: " + path.toString());
                            }
                        } catch (IOException ex) {
                            LOGGER.log(Level.SEVERE, "Error processing image: " + path.toString(), ex);
                        }
                    });
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error listing files in directory: " + directory, e);
            throw new RuntimeException("Error processing directory", e);
        }

		if(images.isEmpty()) {
			throw new IllegalArgumentException("No valid image files found in the specified directory.");
		}
        return images;
    }


    //  Inner class to hold image information
    public static class ImageInfo {
        public String filePath;
        public int width;
        public int height;

        public ImageInfo(String filePath, int width, int height) {
            this.filePath = filePath;
            this.width = width;
            this.height = height;
        }
    }

    // Example usage -  Illustrative,  replace with GUI integration
    public static void main(String[] args) {
        try {
            String imageDirectory = "path/to/your/images"; // Replace with your directory
            ImageProcessor processor = ImageProcessor.getInstance();
            List<ImageInfo> imageInfos = processor.processImages(imageDirectory);

            //  Illustrative output -  replace with GUI rendering logic
            for (ImageInfo imageInfo : imageInfos) {
                System.out.println("Image: " + imageInfo.filePath + ", width: " + imageInfo.width + ", height: " + imageInfo.height);
            }

        } catch (IllegalArgumentException e) {
            System.err.println("Error: " + e.getMessage());
        } catch (RuntimeException e) {
            System.err.println("Critical Error: " + e.getMessage());
            e.printStackTrace(); // Log the full stack trace for debugging
        }
    }
}
```

**Explicații și îmbunătățiri cheie:**

* **`ImageInfo` class:**  Acum stochează informații despre imagini (cale, lățime, înălțime).  Aceasta este o abordare mai curată și mai organizată decât să returnezi direct `BufferedImage`-uri.
* **`Files.list`:** Folosește `java.nio.file` pentru listarea fișierelor. Aceasta este o modalitate mai modernă și mai robustă pentru interacțiunea cu fișiere.
* **Lambda Expressions and Streams:** Codul utilizează expresii Lambda și streams pentru un stil de cod mai compact și mai elegant.
* **`RuntimeException` pentru erori critice:**  Folosește `RuntimeException` pentru erori care ar trebui să oprească execuția.
* **Gestionarea erorilor îmbunătățită:**  Codul este mult mai robust acum, prin gestionarea erorilor în mai multe puncte critice și oferind un mesaj de eroare mai informativ.
* **Fără `null` checks inutile:**  Elimină verificările inutile `if (files != null)`.  Codul este mai curat și mai eficient.


**Pentru a integra într-un GUI:**

* **JavaFX sau Swing:**  Folosește JavaFX sau Swing pentru a afișa imaginile și a gestiona interfața utilizator.
* **ImageViews:**  Poți crea un `ImageView` (Swing sau JavaFX) pentru fiecare imagine și să-i setezi calea.
* **Controlul utilizatorului:**  Folosește elemente de control, cum ar fi liste de imagini sau panouri, pentru a gestiona vizualizarea imaginilor.

**Important:**

* Configurarea jurnalizării (Logger) pentru a înregistra evenimentele.
* Gestionarea unor scenarii suplimentare (ex: imagini mari, diverse tipuri de imagini).
* Adăugați validări suplimentare pe cale de a primi fișierul pentru a rezolva probleme legate de fișierele ilegale.



Aceste modificări fac codul mult mai robust, mai ușor de menținut și pregatit pentru integrarea într-o interfață grafică.