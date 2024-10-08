-- Pedro Henrique Salmaze 13783714

--1)

-- Tabela Federação

INSERT INTO Federacao (Nome,Data_Fundacao)
    VALUES ('Nova Atlantis', TO_DATE('25/04/2190', 'DD/MM/YYYY'));

INSERT INTO Federacao (Nome,Data_Fundacao)
    VALUES ('Imanis', TO_DATE('10/06/2084', 'DD/MM/YYYY'));

-- Tabela Nacao

INSERT INTO Nacao (Nome, Quantidade_Planetas, Federacao)
    VALUES ('Jemison', 3, 'Nova Atlantis');

INSERT INTO Nacao (Nome, Quantidade_Planetas, Federacao)
    VALUES ('Cordantes', 5, 'Imanis');

-- Tabela Estrela

INSERT INTO Estrela (Id_catalogo, Nome, Classificacao, Massa, Coordenada_X, Coordenada_Y, Coordenada_Z)
    VALUES (318, 'Alpha Centauri', 'O', '12000', -250, 512, 5);

INSERT INTO Estrela (Id_catalogo, Nome, Classificacao, Massa, Coordenada_X, Coordenada_Y, Coordenada_Z)
    VALUES (256, 'G.O.M.E.S.', 'B', '10000', 681, -105, -42);

INSERT INTO Estrela (Id_catalogo, Nome, Classificacao, Massa, Coordenada_X, Coordenada_Y, Coordenada_Z)
    VALUES (64, 'Walter', 'A', '1900', 981, 105, -42);

-- Tablela OrbitaEstrela

INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES (318, 256, '100', '200', '5');

INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES (256, 318, '220', '10', '80');

-- Tabela Planeta

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio)
    VALUES ('Jemison 1', 100, 10);

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio, Composicao, Classicacao)
    VALUES ('Imanis 5', 200, 20, 'Nitrogenio e Amonia', 'Rochosos');

-- Tabela Sistema

INSERT INTO Sistema(Estrela, Nome)
    VALUES (318, 'Janos');

INSERT INTO Sistema(Estrela, Nome)
    VALUES (256, 'Euclido');

-- Tabela Dominancia

INSERT INTO Dominancia(Nacao, Planeta, Data_ini)
    VALUES ('Jemison', 'Jemison 1', TO_DATE('01/01/2200', 'DD/MM/YYYY'));

INSERT INTO Dominancia(Nacao, Planeta, Data_ini, Data_fim)
    VALUES ('Cordantes', 'Imanis 5', TO_DATE('01/01/2200', 'DD/MM/YYYY'), TO_DATE('01/01/2201', 'DD/MM/YYYY'));

-- Tabela Especie

INSERT INTO Especie (Nome_Cientifico, Planeta_Origem, Eh_Inteligente)
    VALUES ('Cachimbus-Cachunbenses', 'Jemison 1', 'nao');

INSERT INTO Especie (Nome_Cientifico, Planeta_Origem, Eh_Inteligente)
    VALUES ('Semi-Humanos', 'Imanis 5', 'sim');

-- Tabela Lider

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('Ajan322', 'Geraldo', 'Presidente', 'Jemison', 'Semi-Humanos');

INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('Bjan322', 'Silvia', 'Presidente', 'Cordantes', 'Semi-Humanos');

-- Tabela Faccao

INSERT INTO Faccao (Nome, Lider, Ideologia, Qnt_Nacoes)
    VALUES ('Culto de Vanklion', 'Ajan322', 'Anarco-Capistalismo', 3);

INSERT INTO Faccao (Nome, Lider, Ideologia, Qnt_Nacoes)
    VALUES ('Vetistas', 'Bjan322', 'Comunismo', 5);

-- Tabela NacaoFaccao

INSERT INTO NacaoFaccao (Nacao, Faccao)
    VALUES ('Jemison', 'Culto de Vanklion');

INSERT INTO NacaoFaccao (Nacao, Faccao)
    VALUES ('Cordantes', 'Vetistas');

-- Tabela OrbitaPlaneta

INSERT INTO OrbitaPlaneta (Planeta, Estrela, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Jemison 1', 318, '100', '200', '5');

INSERT INTO OrbitaPlaneta (Planeta, Estrela, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Imanis 5', 256, '220', '10', '80');

-- Tabela Comunidade

INSERT INTO Comunidade (Especie, Nome, Qtd_habitantes)
    VALUES ('Cachimbus-Cachunbenses', 'Rio de Janeiro', 10520);

INSERT INTO Comunidade (Especie, Nome, Qtd_habitantes)
    VALUES ('Semi-Humanos', 'O Alto', 10000);

-- Tabela Habitacao

INSERT INTO Habitacao (Planeta, Especie, NomeEspecie, Data_Ini, Data_Fim)
    VALUES ('Jemison 1', 'Cachimbus-Cachunbenses', 'Rio de Janeiro', TO_DATE('01/01/2200', 'DD/MM/YYYY'), TO_DATE('01/01/2201', 'DD/MM/YYYY'));

INSERT INTO Habitacao (Planeta, Especie, NomeEspecie, Data_Ini)
    VALUES ('Imanis 5', 'Semi-Humanos', 'O Alto', TO_DATE('01/01/2200', 'DD/MM/YYYY'));

-- Tabela Participa

INSERT INTO Participa (Faccao, Especie, NomeEspecie)
    VALUES ('Culto de Vanklion', 'Cachimbus-Cachunbenses', 'Rio de Janeiro');

INSERT INTO Participa (Faccao, Especie, NomeEspecie)
    VALUES ('Vetistas', 'Semi-Humanos', 'O Alto');


-- 2)
    -- a)

UPDATE Federacao SET Data_Fundacao = TO_DATE('25/04/2190', 'DD/MM/YYYY') 
    WHERE Nome = 'Nova Atlantis';

    --b)

UPDATE Planeta SET Massa = 140, Raio = 12
    WHERE Designacao_Astronomica = 'Jemison 1';

    --c)

UPDATE Dominancia SET Data_fim = NULL;


-- 3)
    -- a)

DELETE FROM Sistema
    WHERE Estrela = 256;

    -- b)

DELETE FROM Estrela
    WHERE Id_catalogo = 64;

    -- c)

INSERT INTO Federacao (Nome,Data_Fundacao)
    VALUES ('Raum', TO_DATE('10/06/2114', 'DD/MM/YYYY'));
    
INSERT INTO Nacao (Nome, Quantidade_Planetas, Federacao)
    VALUES ('Pompeia', 5, 'Raum');
    
DELETE FROM Federacao
    WHERE Nome = 'Raum';

-- As nações que refereciam essa federação serão excluidas

-- 4)
    -- a)
ALTER TABLE Sistema
    ADD (Tamanho VARCHAR2(256));

-- As tuplas já existentes ficam com o valor NULL


    -- b)
ALTER TABLE Sistema
    ADD (Populacao NUMBER(10) DEFAULT 0);

-- As tuplas já existentes ficam com o valor Default

    -- c)

ALTER TABLE Planeta DROP CONSTRAINT CK_MASSA_PLANETA;

    -- d)

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio)
    VALUES ('Jemison 2', -100, 10);

/*
ALTER TABLE Planeta ADD CONSTRAINT 
    CK_MASSA_PLANETA CHECK (Massa > 0);

  Erro ao ser inserida, pois uma das tuplas não satisfaz a condição
*/

ALTER TABLE Planeta ADD CONSTRAINT 
    CK_MASSA_PLANETA CHECK (Massa > 0)  NOVALIDATE;

-- Sucesso ao ser inserida

    -- e)

ALTER TABLE Federacao MODIFY Data_Fundacao NULL;

ALTER TABLE Nacao MODIFY Quantidade_Planetas DEFAULT 1;

    -- f)

/* 
Não foi possivel remover o atributo da tabela pois ele 
fazia parte da chave primaria, mas caso isso fosse possivel resultaria em 
inconsistencia nos dados da tabela que a referenciava.
*/

    -- g)

/*
    Para que a tabela seja excluida, é necessári que as chaves estrangeiras
que a referenciam sejam removidas. O que acarretaria em perda de consistencia dos
dados.
*/