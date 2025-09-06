Title: LibrarieOnline

=== FILE: create_tables.sql ===
CREATE TABLE Autori (
    ID_Autor INT PRIMARY KEY,
    Nume VARCHAR(255),
    Prenume VARCHAR(255)
);

CREATE TABLE Categorii (
    ID_Categorie INT PRIMARY KEY,
    NumeCategorie VARCHAR(255)
);

CREATE TABLE Carti (
    ID_Carte INT PRIMARY KEY,
    Titlu VARCHAR(255),
    ID_Autor INT,
    ID_Categorie INT,
    Pret DECIMAL(10, 2),
    Stoc INT,
    DataPublicare DATE,
    FOREIGN KEY (ID_Autor) REFERENCES Autori(ID_Autor),
    FOREIGN KEY (ID_Categorie) REFERENCES Categorii(ID_Categorie)
);

CREATE TABLE Clienti (
    ID_Client INT PRIMARY KEY,
    Nume VARCHAR(255),
    Prenume VARCHAR(255),
    Email VARCHAR(255),
    Adresa VARCHAR(255)
);

CREATE TABLE Comenzi (
    ID_Comanda INT PRIMARY KEY,
    ID_Client INT,
    DataComanda DATE,
    FOREIGN KEY (ID_Client) REFERENCES Clienti(ID_Client)
);

CREATE TABLE DetaliiComenzi (
    ID_DetaliuComanda INT PRIMARY KEY,
    ID_Comanda INT,
    ID_Carte INT,
    Cantitate INT,
    PretUnitar DECIMAL(10, 2),
    FOREIGN KEY (ID_Comanda) REFERENCES Comenzi(ID_Comanda),
    FOREIGN KEY (ID_Carte) REFERENCES Carti(ID_Carte)
);
=== END FILE ===


=== FILE: populate_data.sql ===
INSERT INTO Autori (ID_Autor, Nume, Prenume) VALUES
(1, 'King', 'Stephen'),
(2, 'Rowling', 'J. K.'),
(3, 'Austen', 'Jane');

INSERT INTO Categorii (ID_Categorie, NumeCategorie) VALUES
(1, 'Fictiune'),
(2, 'Fantasy'),
(3, 'Clasica');

INSERT INTO Carti (ID_Carte, Titlu, ID_Autor, ID_Categorie, Pret, Stoc, DataPublicare) VALUES
(1, 'IT', 1, 1, 25.99, 100, '1986-01-01'),
(2, 'Harry Potter si Piatra Filosofala', 2, 2, 19.99, 150, '1997-01-01'),
(3, 'Mandrie si Prejudecata', 3, 3, 15.99, 75, '1813-01-01');

INSERT INTO Clienti (ID_Client, Nume, Prenume, Email, Adresa) VALUES
(1, 'Popescu', 'Ion', 'ion.popescu@email.com', 'Str. Unirii 1'),
(2, 'Ionescu', 'Maria', 'maria.ionescu@email.com', 'Str. Libertatii 10');

INSERT INTO Comenzi (ID_Comanda, ID_Client, DataComanda) VALUES
(1, 1, '2024-03-08'),
(2, 2, '2024-03-10');

INSERT INTO DetaliiComenzi (ID_DetaliuComanda, ID_Comanda, ID_Carte, Cantitate, PretUnitar) VALUES
(1, 1, 1, 2, 25.99),
(2, 2, 2, 1, 19.99);
=== END FILE ===


=== FILE: queries.sql ===
-- Afiseaza toate cartile cu pretul mai mare de 20
SELECT * FROM Carti WHERE Pret > 20;

-- Afiseaza autorii si cartile lor
SELECT A.Nume, A.Prenume, C.Titlu
FROM Autori A
JOIN Carti C ON A.ID_Autor = C.ID_Autor;

-- Afiseaza clientii si comenzile lor
SELECT CL.Nume, CL.Prenume, CO.DataComanda
FROM Clienti CL
JOIN Comenzi CO ON CL.ID_Client = CO.ID_Client;

-- Afiseaza cartile dintr-o anumita categorie (ex: Fictiune)
SELECT * FROM Carti WHERE ID_Categorie = (SELECT ID_Categorie FROM Categorii WHERE NumeCategorie = 'Fictiune');

-- Afiseaza comenzile cu detaliile lor
SELECT CO.ID_Comanda, C.Titlu, DC.Cantitate, DC.PretUnitar
FROM Comenzi CO
JOIN DetaliiComenzi DC ON CO.ID_Comanda = DC.ID_Comanda
JOIN Carti C ON DC.ID_Carte = C.ID_Carte;


--Procedura stocata pentru adaugarea unei noi carti
CREATE PROCEDURE AdaugaCarte (@Titlu VARCHAR(255), @ID_Autor INT, @ID_Categorie INT, @Pret DECIMAL(10,2), @Stoc INT, @DataPublicare DATE)
AS
BEGIN
    IF EXISTS (SELECT * FROM Carti WHERE Titlu = @Titlu)
        BEGIN
            PRINT 'Carte existenta!'
            RETURN
        END
    INSERT INTO Carti (Titlu, ID_Autor, ID_Categorie, Pret, Stoc, DataPublicare) VALUES (@Titlu, @ID_Autor, @ID_Categorie, @Pret, @Stoc, @DataPublicare)
END;

-- Apel procedura stocata
EXEC AdaugaCarte 'Noua Carte', 1,1, 20.00, 50, GETDATE();

--Afiseaza toate cartile dupa apelarea procedurii
SELECT * FROM Carti;

=== END FILE ===


=== FILE: main.sql ===
-- Acest fisier contine apeluri la proceduri si interogari pentru demonstrare.
-- Se poate extinde cu o interfata mai complexa pentru utilizatori.


-- Apel procedura stocata pentru adaugarea unei noi carti
EXEC AdaugaCarte 'Carte Test', 2, 2, 30.50, 25, '2024-04-15';

-- Verificare daca cartea a fost adaugata
SELECT * FROM Carti WHERE Titlu = 'Carte Test';

-- Interogare complexa:  Afiseaza cartile cu stoc sub 10 si care apartin autorilor cu numele "King"
SELECT c.Titlu
FROM Carti c
JOIN Autori a ON c.ID_Autor = a.ID_Autor
WHERE c.Stoc < 10 AND a.Nume = 'King';

--Afisarea tuturor datelor din tabela Carti
SELECT * FROM Carti;
=== END FILE ===