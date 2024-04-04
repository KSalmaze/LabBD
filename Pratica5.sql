/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)

-- Dados para teste

INSERT INTO Nacao (Nome, QTD_PLANETAS)
    VALUES ('Jemison', 3);

INSERT INTO Nacao (Nome, QTD_PLANETAS)
    VALUES ('Cordantes', 5);

INSERT INTO Lider (CPI, Nome    , Cargo, Nacao, Especie)
    VALUES ('132.456.789-12', 'Geraldo', 'OFICIAL', 'Jemison', 'Id illum fugit');

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('132.456.789-13', 'Silvia', 'OFICIAL', 'Cordantes', 'Id illum fugit');
INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('562.456.789-13', 'Pedro', 'OFICIAL', 'Cordantes', 'Id illum fugit');
INSERT INTO Faccao (Nome, Lider, Ideologia, QTD_NACOES)
    VALUES ('Vanklion', '132.456.789-12', 'TOTALITARIA', 3);

INSERT INTO Faccao (Nome, Lider, Ideologia, QTD_NACOES)
    VALUES ('Vetistas', '132.456.789-13', 'PROGRESSITA', 5);


-- Criação da View

CREATE VIEW FaccoesProgressistas AS
    SELECT Nome, Lider FROM FACCAO 
        WHERE Ideologia = 'PROGRESSITA'
            WITH READ ONLY;


-- a)
SELECT COUNT(*) FROM
    FaccoesProgressistas;

-- b)
INSERT INTO FaccoesProgressistas 
    (Nome, Lider)
    VALUES ('Pedrinos', '562.456.789-13');

-- Erro dado:
/*
Relatório de erros -
Erro de SQL: ORA-42399: não é possível efetuar uma operação de DML em uma view somente para leitura
42399.0000 - "cannot perform a DML operation on a read-only view"


Esse erro ocorre pois a view foi criada com a cláusula WITH READ ONLY, 
que impede a realização de operações de DML (Data Manipulation Language) como INSERT, UPDATE e DELETE.
*/
--