import random
from question import Question

class Quiz:
    def __init__(self, questions):
        self.questions = questions
        self.score = 0
        self.current_question_index = 0


    def start(self):
        random.shuffle(self.questions)
        self.current_question_index = 0
        while self.current_question_index < len(self.questions):
            self.ask_question()
            self.current_question_index += 1
            
        print(f"\nQuiz finished. Your final score is: {self.score}/{len(self.questions)}")


    def ask_question(self):
        question = self.questions[self.current_question_index]
        print(f"\nQuestion {self.current_question_index + 1}:")
        print(question)
        user_answer = input("Your answer: ")
        if question.check_answer(user_answer):
            print("Correct!")
            self.score += 1
        else:
            print(f"Incorrect. The correct answer is: {question.answer}")


    def get_score(self):
        return self.score


    def get_percentage(self):
        if len(self.questions) == 0:
            return 0
        return (self.score / len(self.questions)) * 100


    def get_detailed_results(self):
        results = []
        for i, question in enumerate(self.questions):
            results.append(
                {
                    "question": question.text,
                    "answer": question.answer,
                    "user_answer": "Correct" if question.check_answer(input(f"Enter your answer to question {i+1}: ")) else "Incorrect",
                }
            )
        return results