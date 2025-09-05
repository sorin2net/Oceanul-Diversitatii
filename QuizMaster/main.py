import tkinter as tk
from quiz_manager import QuizManager
from question import Question

questions = [
    Question("What is the capital of France?", "Paris", ["London", "Berlin", "Rome"]),
    Question("What is the highest mountain in the world?", "Mount Everest", ["K2", "Kangchenjunga", "Lhotse"]),
    Question("What is the largest planet in our solar system?", "Jupiter", ["Saturn", "Neptune", "Mars"]),
    Question("What is the chemical symbol for water?", "H2O", ["CO2", "NaCl", "O2"]),
    Question("In what year did World War II begin?", "1939", ["1914", "1945", "1917"])
]

root = tk.Tk()
quiz_manager = QuizManager(root, questions)
root.mainloop()