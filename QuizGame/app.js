const Quiz = require('./quiz');
const Question = require('./question');

const questions = [
  new Question("Ce este JavaScript?", ["Un limbaj de programare", "Un fel de cafea", "Un fel de brânză"], "Un limbaj de programare"),
  new Question("Cine a creat JavaScript?", ["Bill Gates", "Brendan Eich", "Steve Jobs"], "Brendan Eich"),
  new Question("Care este tipul de date al lui 'true'?", ["string", "boolean", "number"], "boolean")
];

const quiz = new Quiz(questions);

let currentQuestion = quiz.currentQuestion;

function displayQuestion() {
  document.getElementById('question').textContent = currentQuestion.text;
  let answers = document.getElementById('answers');
  answers.innerHTML = '';
  currentQuestion.answers.forEach(answer => {
    let button = document.createElement('button');
    button.textContent = answer;
    button.addEventListener('click', () => {
      quiz.guess(answer);
      if (quiz.isOver()){
        displayResult();
      } else {
        currentQuestion = quiz.currentQuestion;
        displayQuestion();
      }
    });
    answers.appendChild(button);
  });
}

function displayResult(){
  document.getElementById('question').textContent = `Scor final: ${quiz.score} din ${questions.length}`;
  document.getElementById('answers').innerHTML = '';
}

displayQuestion();