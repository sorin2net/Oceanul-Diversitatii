Title: ScoalaOnline

=== FILE: creare_tabele.sql ===
CREATE TABLE Studenti (
    id_student INT PRIMARY KEY,
    nume VARCHAR(255),
    prenume VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    data_nastere DATE
);

CREATE TABLE Cursuri (
    id_curs INT PRIMARY KEY,
    nume_curs VARCHAR(255),
    descriere TEXT,
    profesor VARCHAR(255)
);

CREATE TABLE Inscrieri (
    id_inscriere INT PRIMARY KEY,
    id_student INT,
    id_curs INT,
    data_inscriere DATE,
    nota INT,
    FOREIGN KEY (id_student) REFERENCES Studenti(id_student),
    FOREIGN KEY (id_curs) REFERENCES Cursuri(id_curs)
);

CREATE TABLE Note (
  id_nota INT PRIMARY KEY,
  id_student INT,
  id_curs INT,
  nota INT,
  data_evaluare DATE,
  FOREIGN KEY (id_student) REFERENCES Studenti(id_student),
  FOREIGN KEY (id_curs) REFERENCES Cursuri(id_curs)
);


INSERT INTO Studenti (id_student, nume, prenume, email, data_nastere) VALUES
(1, 'Popescu', 'Ion', 'ion.popescu@example.com', '1998-05-10'),
(2, 'Ionescu', 'Maria', 'maria.ionescu@example.com', '1999-11-20'),
(3, 'Georgescu', 'Andrei', 'andrei.georgescu@example.com', '2000-03-15'),
(4, 'Vasilescu', 'Ana', 'ana.vasilescu@example.com', '1997-08-25');

INSERT INTO Cursuri (id_curs, nume_curs, descriere, profesor) VALUES
(1, 'Baze de date', 'Introducere in baze de date relationale', 'Prof. Dr. X'),
(2, 'Programarea orientata pe obiecte', 'Principiile POO', 'Prof. Dr. Y'),
(3, 'Retele de calculatoare', 'Arhitectura si functionarea retelelor', 'Prof. Dr. Z');

INSERT INTO Inscrieri (id_inscriere, id_student, id_curs, data_inscriere) VALUES
(1, 1, 1, '2024-02-15'),
(2, 2, 2, '2024-02-15'),
(3, 3, 1, '2024-02-18'),
(4, 1, 2, '2024-02-20'),
(5, 4, 3, '2024-02-22');

INSERT INTO Note (id_nota, id_student, id_curs, nota, data_evaluare) VALUES
(1,1,1,8,'2024-03-10'),
(2,2,2,9,'2024-03-15'),
(3,3,1,7,'2024-03-20');
=== END FILE ===


=== FILE: proceduri_memorate.sql ===
DELIMITER //

CREATE PROCEDURE AdaugaStudent (
    IN p_nume VARCHAR(255),
    IN p_prenume VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_data_nastere DATE
)
BEGIN
    INSERT INTO Studenti (nume, prenume, email, data_nastere) VALUES (p_nume, p_prenume, p_email, p_data_nastere);
END //

CREATE PROCEDURE ActualizeazaNota (
    IN p_id_student INT,
    IN p_id_curs INT,
    IN p_nota INT
)
BEGIN
    UPDATE Inscrieri SET nota = p_nota WHERE id_student = p_id_student AND id_curs = p_id_curs;
END //

CREATE PROCEDURE GasesteStudentiCuNota (IN p_nota INT)
BEGIN
  SELECT s.nume, s.prenume, c.nume_curs
  FROM Studenti s
  JOIN Inscrieri i ON s.id_student = i.id_student
  JOIN Cursuri c ON i.id_curs = c.id_curs
  WHERE i.nota = p_nota;
END //


DELIMITER ;
=== END FILE ===


=== FILE: interogari.sql ===
-- Selecteaza toti studentii de la cursul "Baze de date"
SELECT s.nume, s.prenume
FROM Studenti s
JOIN Inscrieri i ON s.id_student = i.id_student
JOIN Cursuri c ON i.id_curs = c.id_curs
WHERE c.nume_curs = 'Baze de date';

-- Afiseaza media notelor pentru fiecare student
SELECT s.nume, s.prenume, AVG(i.nota) AS medie_note
FROM Studenti s
JOIN Inscrieri i ON s.id_student = i.id_student
GROUP BY s.id_student;


-- Afiseaza studentii care nu au nicio nota la niciun curs
SELECT s.nume, s.prenume
FROM Studenti s
LEFT JOIN Inscrieri i ON s.id_student = i.id_student
WHERE i.id_inscriere IS NULL;

-- Afiseaza cursurile la care nu s-a inscris niciun student
SELECT c.nume_curs
FROM Cursuri c
LEFT JOIN Inscrieri i ON c.id_curs = i.id_curs
WHERE i.id_inscriere IS NULL;

--Numarul de studenti inscrisi la fiecare curs
SELECT c.nume_curs, COUNT(i.id_student) AS numar_studenti
FROM Cursuri c
JOIN Inscrieri i ON c.id_curs = i.id_curs
GROUP BY c.nume_curs;
=== END FILE ===


=== FILE: main.sql ===
-- Apelarea procedurilor memorate
CALL AdaugaStudent('Pop', 'Andrei', 'andrei.pop@example.com', '2001-07-12');
CALL ActualizeazaNota(1,1,10);
CALL GasesteStudentiCuNota(9);

-- Executarea interogarilor din fisierul interogari.sql
SOURCE interogari.sql;


SELECT * FROM Studenti;
SELECT * FROM Cursuri;
SELECT * FROM Inscrieri;
SELECT * FROM Note;
=== END FILE ===