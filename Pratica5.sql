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

-- 2)

-- Dados para teste
INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('562.987.789-13', 'Jorge', 'OFICIAL', 'Cordantes', 'Id illum fugit');
    
INSERT INTO Faccao (Nome, Lider, Ideologia, QTD_NACOES)
    VALUES ('Jorgistas', '562.987.789-13', 'TRADICIONALISTA', 3);

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('988.987.789-13', 'Mathues', 'OFICIAL', 'Cordantes', 'Id illum fugit');

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('988.142.789-13', 'Oliver', 'OFICIAL', 'Cordantes', 'Id illum fugit');

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('688.142.789-93', 'Jo', 'OFICIAL', 'Cordantes', 'Id illum fugit');

-- a)

-- Criação da View
CREATE VIEW viewa AS
    SELECT Nome, Lider, Ideologia FROM Faccao
        WHERE Ideologia = 'TRADICIONALISTA';

-- inserções
INSERT INTO viewa 
    (Nome, Lider, Ideologia)
        VALUES ('Mad', '988.987.789-13', 'TRADICIONALISTA');

INSERT INTO viewa 
    (Nome, Lider, Ideologia)
        VALUES ('FoG', '988.142.789-13', 'PROGRESSITA');

/*
Consultando a viewa apenas a faccao mad foi mostrada, pois a view filtra por ideologia tradicionalista,
    já na tabela de faccao fog e a mad são mostradas, já que não há nenhum filtro.
*/

-- b)

-- Criação da view
CREATE VIEW viewb AS
    SELECT Nome, Lider, Ideologia FROM Faccao
        WHERE Ideologia = 'TRADICIONALISTA'
            WITH CHECK OPTION;

-- inserções
INSERT INTO viewb 
    (Nome, Lider, Ideologia)
        VALUES ('Ganesh', '688.142.789-93', 'TOTALITARIA');

/*
A tupla não pode ser inserida pois viola a condição WITH CHECK OPTION
*/

