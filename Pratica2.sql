-- Pedro Henrique Salmaze 13783714

--1)

-- Tabela Federação
-- Talvez Dropar essa pra adicional valor default

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

-- Tablela OrbitaEstrela

INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Alpha Centauri', 'G.O.M.E.S.', 100, 200, 5);

INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('G.O.M.E.S.', 'Alpha Centauri', 220, 10, 80);

-- Tabela Planeta

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio)
    VALUES ('Jemison 1', 100, 10);

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio, Composicao, Classicacao)
    VALUES ('Imanis 5', 200, 20, 'Nitrogenio e Amonia', 'Rochosos');

-- Tabela Sistema

INSERT INTO Sistema(Estrela, Nome)
    VALUES ('Alpha Centauri', 'Janos');

INSERT INTO Sistema(Estrela, Nome)
    VALUES ('G.O.M.E.S.', 'Euclido');

-- Tabela Dominancia

INSERT INTO Dominancia(Nacao, Planeta, Data_ini)
    VALUES ('Jemison', 'Jemison 1', TO_DATE('01/01/2200', 'DD/MM/YYYY'));

INSERT INTO Dominancia(Nacao, Planeta, Data_ini, Data_fim)
    VALUES ('Cordantes', 'Imanis 5', TO_DATE('01/01/2200', 'DD/MM/YYYY'), TO_DATE('01/01/2201', 'DD/MM/YYYY'));