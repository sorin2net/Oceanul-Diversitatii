import tkinter as tk
from quiz import Quiz
from question import Question

class QuizManager:
    def __init__(self, master, questions):
        self.master = master
        master.title("QuizMaster")
        self.quiz = Quiz(questions)
        self.create_widgets()

    def create_widgets(self):
        self.label = tk.Label(self.master, text=self.quiz.questions[self.quiz.current_question_index].text)
        self.label.pack(pady=10)
        
        self.options = []
        for i, option in enumerate(self.quiz.questions[self.quiz.current_question_index].options):
            button = tk.Button(self.master, text=option, command=lambda option=option: self.check_answer(option))
            button.pack(pady=5)
            self.options.append(button)


        self.next_button = tk.Button(self.master, text="Next", command=self.next_question, state=tk.DISABLED)
        self.next_button.pack(pady=10)
        self.result_label = tk.Label(self.master, text="")
        self.result_label.pack(pady=10)



    def check_answer(self, selected_option):
        is_correct = self.quiz.questions[self.quiz.current_question_index].check_answer(selected_option)
        if is_correct:
            self.result_label.config(text="Correct!")
        else:
            self.result_label.config(text=f"Incorrect. The correct answer was: {self.quiz.questions[self.quiz.current_question_index].answer}")
        self.next_button.config(state=tk.NORMAL)
        for button in self.options:
            button.config(state=tk.DISABLED)

    def next_question(self):
        self.quiz.current_question_index +=1
        if self.quiz.current_question_index < len(self.quiz.questions):
            self.label.config(text=self.quiz.questions[self.quiz.current_question_index].text)
            for i, button in enumerate(self.options):
              button.config(text=self.quiz.questions[self.quiz.current_question_index].options[i],state=tk.NORMAL)
            self.result_label.config(text="")
            self.next_button.config(state=tk.DISABLED)

        else:
            self.label.config(text=f"Quiz finished. Your score: {self.quiz.score}/{len(self.quiz.questions)}")
            for button in self.options:
                button.config(state=tk.DISABLED)
            self.next_button.config(state=tk.DISABLED)