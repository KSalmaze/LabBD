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
    
INSERT INTO Faccao (Nome, Lider, Ideologia, QTD_NACOES)
    VALUES ('Vanklion', '132.456.789-12', 'TOTALITARIA', 3);

INSERT INTO Faccao (Nome, Lider, Ideologia, QTD_NACOES)
    VALUES ('Vetistas', '132.456.789-13', 'PROGRESSITA', 5);


-- Criação da View

CREATE VIEW FaccoesProgressistas AS
    SELECT Nome, Lider FROM FACCAO 
        WHERE Ideologia = 'Progressista'
            WITH READ ONLY;
