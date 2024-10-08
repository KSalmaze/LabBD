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

-- 3)

-- Dados para teste
INSERT INTO Orbita_Planeta (Estrela, Planeta) VALUES ('GJ 9798','Quia eum.');
INSERT INTO Orbita_Planeta (Estrela, Planeta) VALUES ('GJ 9798','14 Her b');
INSERT INTO Orbita_Planeta (Estrela, Planeta) VALUES ('80Pi 1Cyg','Quidem id.');

-- Criação da view
CREATE VIEW viewpe AS
    SELECT E.NOME, E.X, E.Y, E.Z, P.ID_ASTRO, P.CLASSIFICACAO 
        FROM  Estrela E JOIN Orbita_Planeta OP ON
            E.ID_ESTRELA = OP.Estrela JOIN Planeta P ON
                OP.Planeta = P.ID_ASTRO;

-- a)
/*
    Testes
    INSERT INTO viewpe (ID_ASTRO, CLASSIFICACAO) VALUES ('asjidh','ASD');
    INSERT INTO viewpe (Nome, X, Y, Z) VALUES ('Tatois',12,13,14);

    Erro:
    "cannot modify a column which maps to a non key-preserved table"

    Tanto estrela quanto planetas podem se repitir na view, logo nenhuma das duas tem preservação
    de chaves, logo a view é não atualizavel.
*/

-- b)
SELECT E.ID_ESTRELA, COUNT(*) FROM 
    viewpe V JOIN Estrela E ON V.X = E.X AND V.Y = E.Y AND V.Z = E.Z
        GROUP BY E.ID_ESTRELA;

-- 4)
-- Criação da view
CREATE VIEW viewLider AS SELECT L.CPI, L.Nome, L.Cargo, L.Nacao, N.Federacao, L.Especie, E.planeta_or 
    FROM Lider L JOIN Nacao N ON L.Nacao = N.Nome 
        JOIN Especie E ON L.Especie = E.Nome;

-- a)
/*
    Lider possui preservação de chave, então ela é atualizavel, mas adicionando somente dados da tabela lider
*/

-- b)
INSERT INTO viewLider (CPI, Nome, Cargo, Nacao, Especie) 
    VALUES('924.456.789-12','Kelvin','OFICIAL', 'Jemison', 'Id illum fugit');

UPDATE viewLider set nome = 'Celsius' WHERE CPI = '924.456.789-12';

DELETE FROM viewLider WHERE CPI = '924.456.789-12';

/*
    Todas as mudanças em lider também são refletidas na tabela lider, pois a view é atualizável.
*/

-- 5)
-- Criação da view
CREATE VIEW viewFaccao (Noma_Facao, CPI_Lider, Nome_Lider, Ideologia) AS SELECT F.Nome, F.Lider, L.Nome, F.Ideologia 
    FROM Faccao F JOIN Lider L ON F.Lider = L.CPI;

-- a)
/*
    Faccao possui preservação de chave, então ela é atualizavel, mas adicionando somente dados da tabela Faccao, 
        não é possivel adicionar dados de lider.
*/

-- b)
INSERT INTO viewFaccao (Noma_Facao, CPI_Lider, Ideologia) 
    VALUES ('Ganesh', '562.456.789-13', 'TOTALITARIA');

UPDATE viewFaccao SET Noma_Facao = 'PET'
    WHERE Noma_Facao = 'Ganesh';

DELETE FROM viewFaccao WHERE Noma_Facao = 'PET';

/*
    Todas as mudanças em faccao também são refletidas na tabela faccao, pois a view é atualizável.
*/

-- 6)
-- COM JUNÇÃO
-- Juntando facção com lider e sua especie
CREATE MATERIALIZED VIEW viewMatFaccao
  (Nome_Lider, CPI_Lider, Planeta_Or_Espec_Lider, Nome_Faccao, Indeologia_Faccao)
  BUILD IMMEDIATE
  REFRESH COMPLETE ON DEMAND
    AS SELECT L.Nome, F.Lider, E.Planeta_Or,F.Nome, F.Ideologia 
        FROM Faccao F JOIN Lider L ON F.Lider = L.CPI
        JOIN Especie E ON L.Especie = E.Nome;

/*
    BUILD IMMEDIATE: A view é populada imediatamente
    REFRESH COMPLETE ON DEMAND: A view é completamente reescrita, e só é atualizada quando solicitada manualmente
*/

-- COM AGREGAÇÃO
-- Foi necessário criar um log para a a tabela Faccao
CREATE MATERIALIZED VIEW LOG ON Faccao
    WITH ROWID (Ideologia)
    INCLUDING NEW VALUES;

-- Conta quantas facções com cada ideologia existem 
CREATE MATERIALIZED VIEW viewFaccaoPorIdeologia 
    (IDELOGIA, QTD_FACCOES)
    BUILD DEFERRED
    REFRESH FAST ON COMMIT
      AS SELECT Ideologia, COUNT(*) FROM Faccao
        GROUP BY Ideologia;

/*
    BUILD DEFERRED: A view é populada quando solicitada
    REFRESH FAST ON COMMIT: A view é atualizada automaticamente quando um commit é feito
*/

-- COM ANINHADA
-- As estrelas que planetas, que tem são o local de origem de alguma especie, orbitam
CREATE MATERIALIZED VIEW viewMatC (Planeta, Id_Estrela, Nome_Estrela) 
    BUILD IMMEDIATE
    REFRESH FORCE ON DEMAND
    AS SELECT P.ID_ASTRO, e.id_estrela, e.nome FROM
        Orbita_Planeta Op JOIN (SELECT P.ID_ASTRO 
        FROM Planeta P JOIN Especie E ON P.ID_ASTRO = E.Planeta_Or) P
        ON p.id_astro = op.planeta JOIN
    Estrela E ON op.estrela = e.id_estrela;

/*
    BUILD IMMEDIATE: A view é populada imediatamente
    REFRESH FORCE ON DEMAND: Se umaatualização rápida for possível, o Oracle fará uma atualização rápida. 
    Caso contrário, será feita uma atualização completa, e só é atualizada quando solicitada manualmente
*/