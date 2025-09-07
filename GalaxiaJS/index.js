const Quiz = require('./quiz');
const questions = require('./data');
const express = require('express');
const app = express();
const port = 3000;


app.use(express.static('public'));
app.use(express.urlencoded({extended: true}));

app.get('/', (req, res) => {
  const quiz = new Quiz(questions);
  res.send(`<!DOCTYPE html>
<html>
<head>
<title>GeoQuiz</title>
</head>
<body>
  <div id="quiz-container"></div>
  <script>
  const quiz = new Quiz(${JSON.stringify(questions)});
    function renderQuestion(){
      document.getElementById('quiz-container').innerHTML = quiz.generateQuizHTML();
      document.getElementById('answerForm').addEventListener('submit', function(e){
        e.preventDefault();
        const selectedAnswer = parseInt(document.querySelector('input[name="answer"]:checked').value);
        quiz.answerQuestion(selectedAnswer);
        if(quiz.isQuizOver()){
          document.getElementById('quiz-container').innerHTML = quiz.getResults();
        } else {
          renderQuestion();
        }
      });
    }
    renderQuestion();
  </script>
</body>
</html>`);
});


app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});