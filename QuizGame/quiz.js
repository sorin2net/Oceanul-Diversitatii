const Question = require('./question');

class Quiz {
  constructor(questions) {
    this.questions = questions;
    this.score = 0;
    this.currentQuestionIndex = 0;
  }

  get currentQuestion() {
    return this.questions[this.currentQuestionIndex];
  }

  isOver() {
    return this.currentQuestionIndex >= this.questions.length;
  }

  guess(answer) {
    if (answer === this.currentQuestion.correctAnswer) {
      this.score++;
    }
    this.currentQuestionIndex++;
  }
}

module.exports = Quiz;