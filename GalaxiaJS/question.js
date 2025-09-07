class Question {
  constructor(text, answers, correctAnswer) {
    this.text = text;
    this.answers = answers;
    this.correctAnswer = correctAnswer;
  }

  checkAnswer(userAnswer) {
    return userAnswer === this.correctAnswer;
  }

  getRandomAnswerOrder() {
    const shuffledAnswers = [...this.answers];
    for (let i = shuffledAnswers.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffledAnswers[i], shuffledAnswers[j]] = [shuffledAnswers[j], shuffledAnswers[i]];
    }
    return shuffledAnswers;
  }

  getFormattedQuestion() {
    const shuffledAnswers = this.getRandomAnswerOrder();
    let formattedQuestion = this.text + '\n';
    shuffledAnswers.forEach((answer, index) => {
      formattedQuestion += `${index + 1}. ${answer}\n`;
    });
    return formattedQuestion;
  }
}

module.exports = Question;