

CREATE TABLE Livro(
    ISBN    CHAR(17),
    Titulo  VARCHAR(50) NOT NULL,
    Ed_Num  INTEGER     NOT NULL DEFAULT 1,
    Ed_Data DATETIME    NOT NULL,
    Ed_Ex   INTEGER     NOT NULL,
    Preco_Venda MONEY   NOT NULL,
    PRIMARY KEY (ISBN),
    CHECK(Ed_Num > 0),
    CHECK(Ed_Ex > 0),
    CHECK(Preco_Venda > 0),
    CHECK(ISBN LIKE '[0-9][0-9][0-9]-[0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]')
);

CREATE TABLE Livreiro(
    Cod_Livreiro INTEGER IDENTITY(1,1),
    Nome         VARCHAR(50)    NOT NULL,
    Endereco     VARCHAR(50)    NOT NULL,
    PRIMARY KEY(Cod_Livreiro),
);

CREATE TABLE Autor(
    Cod_Autor  INTEGER     IDENTITY(1,1),
    Nome       VARCHAR(30) NOT NULL,
    Apelido    VARCHAR(30) NOT NULL,
    Pseudonimo VARCHAR(50),
    PRIMARY KEY(Cod_Autor)
);

CREATE TABLE Comprar(
    Cod_Livreiro INTEGER, 
    ISBN         CHAR(17),
    Data_Compra  DATETIME           DEFAULT GETDATE(),
    Quantidade   INTEGER NOT NULL   DEFAULT 1,
    CHECK (Quantidade > 0),
    PRIMARY KEY(Cod_Livreiro, ISBN, Data_Compra),
    FOREIGN KEY(Cod_Livreiro) REFERENCES Livreiro(Cod_Livreiro),
    FOREIGN KEY(ISBN) REFERENCES Livro(ISBN),
);

CREATE TABLE Escrever(
    Cod_Autor INTEGER,
    ISBN      CHAR(17), 
    Royalty   FLOAT NOT NULL DEFAULT 0.1,
    CHECK (Royalty >= 0 AND Royalty <= 1),
    PRIMARY KEY(Cod_Autor, ISBN),
    FOREIGN KEY(Cod_Autor) REFERENCES Autor(Cod_Autor),
    FOREIGN KEY(ISBN)      REFERENCES Livro(ISBN)
);

INSERT INTO Escrever(Cod_Autor, ISBN, Royalty)
VALUES
(1, '000-0-00-000000-0', 0.2),
(2, '000-0-00-000000-0', 0.3),
(3, '000-0-00-000000-0', 0.01);

INSERT INTO Livro(ISBN, Titulo, Ed_Data, Ed_Ex, Preco_Venda)
VALUES('000-0-00-000000-0', 'abc', GETDATE(), 100, 10.95);

INSERT INTO Livro(ISBN, Titulo, Ed_Data, Ed_Ex, Preco_Venda)
VALUES('000-0-00-000001-0', 'Bases de Dados', '2021-04-03', 50, 20),
('000-0-00-000002-0', 'Novas Bases de Dados', '2020-05-02', 250, 15),
('000-0-00-000003-0', 'Alice no País das Maravilhas', '2021-01-03', 500, 40),
('100-0-00-000004-0', 'Aulas em Casa', '2021-04-03', 300, 20);

INSERT INTO Livreiro(Nome, Endereco)
VALUES
('Diogo M', 'Rua XYZ'),
('Joao H', 'Localidade ABC'),
('Pedro S', '1234-567');

INSERT INTO Autor(Nome, Apelido, Pseudonimo)
VALUES
('Manuel', 'António', 'Man'),
('Jorge Jesus', 'Matos', 'JJ'),
('Mariana', 'Antunes', 'Manita');


INSERT INTO Comprar(Cod_Livreiro, ISBN, Data_Compra, Quantidade)
VALUES
(1, '000-0-00-000000-0', DEFAULT, 12),
(2, '000-0-00-000000-0', '2021/04/09', 55);

SELECT * FROM Autor;

SELECT * FROM Livro;

SELECT * FROM Livreiro;

SELECT * FROM Comprar;

SELECT * FROM Escrever;

/********************************/

INSERT INTO Livreiro(nome, endereco)
VALUES
('O meu Livreiro', 'Rua dos Livros - Porto'),
('Setentrião', 'Rua Direita n1 - Vila Real'),
('Papelaria Branco', 'Rua Direita n50 - Vila Real');


INSERT INTO Comprar(cod_livreiro, ISBN,data_compra,quantidade)
VALUES
(4, '000-0-00-000001-0','2021-02-28', 12),
(4, '000-0-00-000003-0','2021/04/12', 60),
(6, '100-0-00-000004-0','2021-03-01', 25);