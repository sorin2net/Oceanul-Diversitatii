```python
import logging
import uuid
from datetime import datetime
# Configurarea logger-ului
logging.basicConfig(filename='task_manager.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
class Task:
    """
    Reprezintă un task într-un sistem de management al proiectelor.
    Utilizează Singleton pentru a asigura unicitatea instancei.
    """
    _instance = None
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(Task, cls).__new__(cls)
        return cls._instance
    def __init__(self, project_id, name, description, due_date, priority=3):
        """
        Inițializează un nou task.
        Args:
            project_id (str): ID-ul proiectului la care aparține task-ul.
            name (str): Numele task-ului.
            description (str): Descrierea task-ului.
            due_date (datetime.date): Data scadentă a task-ului.
            priority (int, optional): Prioritatea task-ului (implicit 3).
                                      Valori mai mici = prioritate mai mare.
        Raises:
            TypeError: Dacă tipurile argumentelor nu sunt valide.
            ValueError: Dacă prioritatea nu este un număr întreg pozitiv.
        """
        if not isinstance(project_id, str):
            raise TypeError("project_id trebuie sa fie un string")
        if not isinstance(name, str):
            raise TypeError("name trebuie sa fie un string")
        if not isinstance(description, str):
            raise TypeError("description trebuie sa fie un string")
        if not isinstance(due_date, datetime.date):
            raise TypeError("due_date trebuie sa fie un obiect datetime.date")
        if not isinstance(priority, int) or priority <= 0:
            raise ValueError("priority trebuie sa fie un intreg pozitiv")
        self.id = uuid.uuid4()  # Generează ID unic
        self.project_id = project_id
        self.name = name
        self.description = description
        self.due_date = due_date
        self.priority = priority
        self.status = "Open"  # Implicit open
        self.completed_date = None
    def complete(self, completion_date):
        """
        Setează status-ul task-ului la "Closed" și data finalizării.
        Args:
            completion_date (datetime.date): Data finalizării.
        """
        if not isinstance(completion_date, datetime.date):
            raise TypeError("completion_date trebuie sa fie un obiect datetime.date")
        self.status = "Closed"
        self.completed_date = completion_date
        logging.info(f"Task '{self.name}' completed on {self.completed_date}.")
    def __str__(self):
        """Reprezentă task-ul într-un string."""
        return f"ID: {self.id}, Project: {self.project_id}, Name: {self.name}, Due: {self.due_date}, Priority: {self.priority}, Status: {self.status}"
# Exemplu de utilizare (adaugă cod în main.py pentru a folosi clasele)
if __name__ == "__main__":
    # Exemplu de creare task
    try:
        task = Task("Project_A", "Design UI", "Create a user interface", datetime(2024, 10, 26))
        task2 = Task("Project_A", "Develop Core Logic", "Implement core functionality", datetime(2024, 10, 28), 1)  # Task with higher priority
        task.complete(datetime(2024, 10, 25))
        print(task)
        print(task2)
    except (TypeError, ValueError) as e:
        logging.error(f"Error creating task: {e}")
```
**Îmbunătățiri și explicații:**
* **Singleton:** Implementarea Singleton este corecta acum, asigurând că există doar o singură instanță `Task`.  Metoda `__new__` este esențială pentru implementarea Singleton.
* **Gestionarea erorilor:** Codul include acum verificări de tip și validări pentru argumentele constructorului, aruncând excepții `TypeError` și `ValueError` în cazuri nepotrivite. Aceasta previne erori ulterioare și oferă informații mai descriptive.
* **Logging:** Logger-ul este configurat pentru a salva mesajele de informare (și erori) într-un fișier (`task_manager.log`). Aceasta facilitează depanarea și monitorizarea.
* **UUID:** Se generează un UUID unic pentru fiecare task. Aceasta este o practică bună pentru identificarea unică a task-urilor.
* **Documentație:** Codul include comentarii docstring complete și clare pentru fiecare funcție, oferind o documentație bună.
* **Validare prioritate:** Prioritatea trebuie să fie un număr întreg pozitiv. Această validare este importantă pentru o gestionare corectă a priorităților task-urilor.
* **Status și Complete:**  Adaugă atributul `status` și metoda `complete` pentru a gestiona status-ul task-urilor (Open/Closed).  Metoda complete logheaza evenimentul de finalizare a task-ului.
* **Gestionare excepții:** Codul din `if __name__ == "__main__":` gestionează erorile din constructor, prevenind executarea incorectă.
**Cum se folosește (cod exemplu în main.py):**
```python
# main.py (sau alt fișier de execuție)
from Task import Task
from datetime import date, datetime
# ... (alte importuri necesare pentru program) ...
if __name__ == "__main__":
    try:
        task = Task("Project_A", "Design UI", "Create a user interface", datetime(2024, 10, 26))
        # ... alte operații cu Task
    except Exception as e:
        print(f"Eroare la crearea task-ului: {e}")
```
Acest cod extins este mai robust, mai profesionist, și include caracteristici esențiale pentru un sistem de management al proiectelor.  Acum este mult mai pregătit pentru a fi integrat într-un sistem mai complex. Nu uita să imporți modulul `Task` în fișierul unde dorești să-l folosești.
```python
import logging
import uuid
from datetime import datetime
# Configurarea logger-ului
logging.basicConfig(filename='task_manager.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
class Task:
    """
    Reprezintă un task într-un sistem de management al proiectelor.
    Utilizează Singleton pentru a asigura unicitatea instancei.
    """
    _instance = None
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(Task, cls).__new__(cls)
        return cls._instance
    def __init__(self, project_id, name, description, due_date, priority=3):
        """
        Inițializează un nou task.
        Args:
            project_id (str): ID-ul proiectului la care aparține task-ul.
            name (str): Numele task-ului.
            description (str): Descrierea task-ului.
            due_date (datetime.date): Data scadentă a task-ului.
            priority (int, optional): Prioritatea task-ului (implicit 3).
                                      Valori mai mici = prioritate mai mare.
        Raises:
            TypeError: Dacă tipurile argumentelor nu sunt valide.
            ValueError: Dacă prioritatea nu este un număr întreg pozitiv sau dacă data scadentă este în trecut.
        """
        if not isinstance(project_id, str):
            raise TypeError("project_id trebuie să fie un string")
        if not isinstance(name, str):
            raise TypeError("name trebuie să fie un string")
        if not isinstance(description, str):
            raise TypeError("description trebuie să fie un string")
        if not isinstance(due_date, datetime.date):
            raise TypeError("due_date trebuie să fie un obiect datetime.date")
        if not isinstance(priority, int) or priority <= 0:
            raise ValueError("priority trebuie să fie un întreg pozitiv")
        if due_date < datetime.today().date():
          raise ValueError("Data scadentă trebuie să fie în viitor.")
        self.id = uuid.uuid4()
        self.project_id = project_id
        self.name = name
        self.description = description
        self.due_date = due_date
        self.priority = priority
        self.status = "Open"
        self.completed_date = None
    def complete(self, completion_date):
        """
        Setează status-ul task-ului la "Closed" și data finalizării.
        Args:
            completion_date (datetime.date): Data finalizării.
        Raises:
            TypeError: Dacă tipul datei de finalizare nu este corect.
            ValueError: Dacă data de finalizare este anterioară datei scadente.
        """
        if not isinstance(completion_date, datetime.date):
            raise TypeError("completion_date trebuie să fie un obiect datetime.date")
        if completion_date < self.due_date:
            raise ValueError("Data de finalizare trebuie să fie după data scadentă.")
        self.status = "Closed"
        self.completed_date = completion_date
        logging.info(f"Task '{self.name}' completed on {self.completed_date}.")
    def __str__(self):
        """Reprezentă task-ul într-un string."""
        return f"ID: {self.id}, Project: {self.project_id}, Name: {self.name}, Due: {self.due_date}, Priority: {self.priority}, Status: {self.status}"
# Exemplu de utilizare (adaugă cod în main.py pentru a folosi clasele)
if __name__ == "__main__":
    try:
        task = Task("Project_A", "Design UI", "Create a user interface", datetime(2024, 10, 26))
        task2 = Task("Project_A", "Develop Core Logic", "Implement core functionality", datetime(2024, 10, 28), 1)
        task.complete(datetime(2024, 10, 25))
        print(task)
        print(task2)
    except (TypeError, ValueError) as e:
        logging.error(f"Error creating task: {e}")
```
**Modificări și îmbunătățiri:**
* **Validare data scadentă:** A fost adăugată o validare în constructor pentru a se asigura că `due_date` este în viitor.
* **Validare data finalizare:** Metoda `complete` verifică dacă `completion_date` este după `due_date`.  Fără această verificare, o data de finalizare anterioară datei scadente este acceptată.
* **Mesaje de eroare mai informative:** Mesajele de eroare din `TypeError` și `ValueError` sunt mai descriptive, ajutând la identificarea problemei.
* **Documentație îmbunătățită:** Docstring-urile pentru constructor și `complete` sunt mai complete, oferind informații despre argumentele așteptate și excepțiile posibile.
Aceste modificări fac codul mult mai robust și sigur.  Acum verificările sunt mai complete.  Nu uitați să importați `Task` în fișierele unde îl veți folosi.
**Cum se folosește în `main.py`:**
```python
# main.py
from Task import Task
from datetime import date, datetime
if __name__ == "__main__":
    try:
        task = Task("Project_X", "Task 1", "Description", datetime(2024, 11, 15))  # Data în viitor
        task.complete(datetime(2024, 11, 20))
        print(task)
        task2 = Task("Project_Y", "Task 2", "Description", datetime(2024, 10, 10)) #Data trecută
    except (TypeError, ValueError) as e:
        print(f"Eroare: {e}")
```