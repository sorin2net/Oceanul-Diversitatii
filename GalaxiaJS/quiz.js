const Question = require('./question');

class Quiz {
  constructor(questions) {
    this.questions = questions;
    this.currentQuestionIndex = 0;
    this.score = 0;
  }

  getCurrentQuestion() {
    return this.questions[this.currentQuestionIndex];
  }

  isQuizOver() {
    return this.currentQuestionIndex >= this.questions.length;
  }


  answerQuestion(userAnswer) {
    const currentQuestion = this.getCurrentQuestion();
    if (currentQuestion.checkAnswer(userAnswer)) {
      this.score++;
    }
    this.currentQuestionIndex++;
  }

  getResults() {
    const percentage = (this.score / this.questions.length) * 100;
    return `You scored ${this.score} out of ${this.questions.length} (${percentage.toFixed(2)}%).`;
  }

  generateQuizHTML(){
    const currentQuestion = this.getCurrentQuestion();
    let html = `<h2>${currentQuestion.getFormattedQuestion()}</h2>`;
    html += `<form id="answerForm">`;
    currentQuestion.getRandomAnswerOrder().forEach((answer, index) => {
      html += `<label><input type="radio" name="answer" value="${index +1}"> ${answer}</label><br>`;
    });
    html += `<button type="submit">Submit Answer</button></form>`;
    return html;
  }
}

module.exports = Quiz;