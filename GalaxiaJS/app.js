import { Question } from './question.js';
import { Quiz } from './quiz.js';
import { UI } from './ui.js';


const questions = [
  new Question("What is the capital of France?", ["London", "Paris", "Berlin", "Rome"], "Paris"),
  new Question("What is the highest mountain in the world?", ["K2", "Kangchenjunga", "Mount Everest", "Lhotse"], "Mount Everest"),
  new Question("What is the largest planet in our solar system?", ["Mars", "Jupiter", "Saturn", "Earth"], "Jupiter"),
  new Question("What is the chemical symbol for water?", ["CO2", "H2O", "O2", "NaCl"], "H2O"),
  new Question("What year did World War II begin?", ["1939", "1914", "1945", "1917"], "1939")
];

const quiz = new Quiz(questions);
const ui = new UI(quiz);

ui.displayQuestion();

document.getElementById('submit').addEventListener('click', () => {
    let selectedAnswer = prompt("Select answer number (1-4)");
    while(isNaN(selectedAnswer) || parseInt(selectedAnswer) < 1 || parseInt(selectedAnswer) > 4){
        selectedAnswer = prompt("Invalid input. Select answer number (1-4):");
    }
    quiz.submitAnswer(questions[quiz.currentQuestionIndex].options[parseInt(selectedAnswer)-1]);
    if (quiz.isQuizOver()){
        ui.displayResult();
    } else {
        ui.displayQuestion();
    }
});

document.getElementById('next').addEventListener('click', ()=>{
    ui.handleNextClick();
})