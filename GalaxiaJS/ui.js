class UI {
  constructor(quiz) {
    this.quiz = quiz;
    this.questionElement = document.getElementById('question');
    this.optionsElement = document.getElementById('options');
    this.submitBtn = document.getElementById('submit');
    this.resultElement = document.getElementById('result');
    this.reportElement = document.getElementById('report');
    this.nextButton = document.getElementById('next');
  }

  displayQuestion() {
    const currentQuestion = this.quiz.getCurrentQuestion();
    this.questionElement.textContent = currentQuestion.text;
    currentQuestion.shuffleOptions();
    this.optionsElement.innerHTML = currentQuestion.getFormattedOptions().map(option => `<li>${option}</li>`).join('');
    this.nextButton.style.display = 'none';
    this.submitBtn.style.display = 'inline-block';
  }

  displayResult() {
    this.resultElement.textContent = this.quiz.getResults();
    this.reportElement.textContent = this.quiz.generateReport();
    this.questionElement.textContent = "";
    this.optionsElement.innerHTML = "";
    this.submitBtn.style.display = 'none';
    this.nextButton.style.display = 'none';
  }


  handleNextClick(){
    if(this.quiz.isQuizOver()){
        this.displayResult();
    } else {
        this.displayQuestion();
    }

  }

}