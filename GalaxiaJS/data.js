const Question = require('./question');

const questions = [
  new Question("Care este capitala Franței?", ["Berlin", "Paris", "Roma", "Madrid"], "Paris"),
  new Question("Care este cel mai înalt munte din lume?", ["K2", "Kangchenjunga", "Mount Everest", "Lhotse"], "Mount Everest"),
  new Question("Care este cea mai mare planetă din sistemul nostru solar?", ["Venus", "Marte", "Jupiter", "Saturn"], "Jupiter"),
  new Question("Care este simbolul chimic al apei?", ["CO2", "H2O", "NaCl", "O2"], "H2O"),
  new Question("Cine a pictat Mona Lisa?", ["Michelangelo", "Raphael", "Leonardo da Vinci", "Donatello"], "Leonardo da Vinci"),
  new Question("Care este cea mai lungă râul din lume?", ["Amazon", "Nil", "Yangtze", "Mississippi"], "Nil"),
  new Question("Care este capitala Rusiei?", ["Kiev", "Moscova", "Saint Petersburg", "Varșovia"], "Moscova"),
  new Question("Care este moneda oficială a Japoniei?", ["Yuan", "Won", "Yen", "Rupie"], "Yen"),
  new Question("Care este cel mai mare ocean din lume?", ["Atlantic", "Indian", "Arctic", "Pacific"], "Pacific"),
  new Question("Care este cel mai mare deșert din lume?", ["Sahara", "Arabia", "Gobi", "Antarctica"], "Antarctica"),
];

module.exports = questions;