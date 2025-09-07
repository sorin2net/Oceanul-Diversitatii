class Game {
  constructor() {
    this.player = new Player();
    this.questions = this.generateQuestions(20);
    this.currentQuestionIndex = 0;
    this.score = 0;
    this.timer = 60;
    this.intervalId = null;
  }

  generateQuestions(numQuestions) {
    const questions = [];
    for (let i = 0; i < numQuestions; i++) {
      const type = Math.floor(Math.random() * 3);
      let question;
      if (type === 0) {
        question = new AdditionQuestion();
      } else if (type === 1) {
        question = new SubtractionQuestion();
      } else {
        question = new MultiplicationQuestion();
      }
      questions.push(question);
    }
    return questions;
  }

  start() {
    this.intervalId = setInterval(() => {
      this.timer--;
      if (this.timer <= 0) {
        this.endGame();
      }
    }, 1000);
    this.askQuestion();
  }

  askQuestion() {
    const question = this.questions[this.currentQuestionIndex];
    const answer = prompt(question.getQuestion());
    if (answer == question.getAnswer()) {
      this.score++;
      console.log("Corect!");
    } else {
      console.log("Incorect!");
    }
    this.currentQuestionIndex++;
    if (this.currentQuestionIndex < this.questions.length) {
      this.askQuestion();
    } else {
      this.endGame();
    }
  }

  endGame() {
    clearInterval(this.intervalId);
    console.log(`Joc terminat! Scor: ${this.score}/${this.questions.length}`);
    console.log(`Timp ramas: ${this.timer} secunde`);

  }
}