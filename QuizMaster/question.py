class Question:
    def __init__(self, text, answer, options=None):
        self.text = text
        self.answer = answer
        if options is None:
            self.options = [answer]
        else:
            self.options = options
            if answer not in self.options:
                self.options.append(answer)
            self.options.sort()


    def check_answer(self, user_answer):
        return user_answer.lower() == self.answer.lower()

    def __str__(self):
        options_str = "\n".join([f"{i+1}. {option}" for i, option in enumerate(self.options)])
        return f"{self.text}\n{options_str}"