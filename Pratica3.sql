/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)

DROP TABLE OrbitaPlaneta;
DROP TABLE Sistema;
DROP TABLE Dominancia;
DROP TABLE NacaoFaccao;
DROP TABLE Habitacao;
DROP TABLE Participa;
DROP TABLE Faccao;
DROP TABLE OrbitaEstrela;
DROP TABLE Comunidade;
DROP TABLE Lider;
DROP TABLE Especie;
DROP TABLE Estrela;
DROP TABLE Planeta;
DROP TABLE Nacao;
DROP TABLE Federacao;

CREATE TABLE Federacao(--Federacao
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME PRIMARY KEY (Nome),
    Data_Fundacao DATE NOT NULL
);

CREATE TABLE Nacao(--Nacao
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME_NACAO PRIMARY KEY (Nome),
    Quantidade_Planetas NUMBER(10),
        CONSTRAINT CK_QUANTIDADE_PLANETAS CHECK (Quantidade_Planetas > 0),
    Federacao VARCHAR2(256),
        CONSTRAINT FK_FEDERACAO FOREIGN KEY (Federacao) REFERENCES Federacao(Nome) ON DELETE CASCADE
);

CREATE TABLE Estrela(--Estrela
    Id_Catalogo NUMBER(10),
        CONSTRAINT PK_ID_CATALOGO PRIMARY KEY (Id_Catalogo),
    Nome VARCHAR2(256),
    Classificacao VARCHAR2(256),
    Massa VARCHAR2(100), -- VARCHAR porque o numero pode ser muito grande
        CONSTRAINT CK_MASSA CHECK (CAST(Massa AS NUMBER) > 0),
    Coordenada_X NUMBER(10) NOT NULL,
    Coordenada_Y NUMBER(10) NOT NULL,
    Coordenada_Z NUMBER(10) NOT NULL,
        CONSTRAINT UK_COORDENADAS UNIQUE (Coordenada_X, Coordenada_Y, Coordenada_Z)
);

CREATE TABLE OrbitaEstrela(--OrbitaEstrela
    Orbitante NUMBER(10),
        CONSTRAINT FK_ORBITANTE FOREIGN KEY (Orbitante) REFERENCES Estrela(Id_Catalogo),
    Orbitada NUMBER(10),
        CONSTRAINT FK_ORBITADA FOREIGN KEY (Orbitada) REFERENCES Estrela(Id_Catalogo),
        CONSTRAINT PK_ORBITA PRIMARY KEY (Orbitante, Orbitada),
    Distancia_Min VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Distancia_Max VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Periodo VARCHAR2(100) --VARCHAR porque o numero pode ser muito grande e possuir unidades de medida diferentes (ex: anos, dias, etc)
);

CREATE TABLE Planeta(
    Designacao_Astronomica VARCHAR2(256),
        CONSTRAINT PK_DESIGNACAO PRIMARY KEY (Designacao_Astronomica),
    Massa VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
        CONSTRAINT CK_MASSA_PLANETA CHECK (CAST(Massa AS NUMBER) > 0),
    Raio VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
        CONSTRAINT CK_RAIO CHECK (CAST(Raio AS NUMBER) > 0),
    Composicao VARCHAR2(256),
    Classicacao VARCHAR2(256)
);

CREATE TABLE Sistema(--Sistema
    Estrela NUMBER(10),
        CONSTRAINT FK_ESTRELA FOREIGN KEY (Estrela) REFERENCES Estrela(Id_Catalogo) ON DELETE CASCADE,
        CONSTRAINT PK_ESTRELA PRIMARY KEY (Estrela),
    Nome VARCHAR2(256)
);

CREATE TABLE Dominancia(
    Nacao VARCHAR2(256),
        CONSTRAINT FK_NACAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome),
    Planeta VARCHAR2(256),
        CONSTRAINT FK_PLANETA_DOMINANCIA FOREIGN KEY (Planeta) REFERENCES Planeta(Designacao_Astronomica),
    Data_ini DATE,
        CONSTRAINT PK_DOMINACIA PRIMARY KEY (Nacao, Planeta, Data_ini),
    Data_fim DATE
);

CREATE TABLE Especie(
    Nome_Cientifico VARCHAR2(256),
        CONSTRAINT PK_NOME_CIENTIFICO PRIMARY KEY (Nome_Cientifico),
    Planeta_Origem VARCHAR2(256) NOT NULL,
        CONSTRAINT FK_PLANETA_ORIGEM FOREIGN KEY (Planeta_Origem) REFERENCES Planeta(Designacao_Astronomica),
    Eh_Inteligente VARCHAR2(3) NOT NULL,
        CHECK (LOWER(Eh_Inteligente) IN ('sim', 'nao'))
);

CREATE TABLE Lider(
    CPI VARCHAR2(100),
        CONSTRAINT PK_LIDER PRIMARY KEY (CPI),
    Nome VARCHAR2(256),
    Cargo VARCHAR2(256) NOT NULL,
    Nacao VARCHAR2(256),
        CONSTRAINT FK_LIDER_NACAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome) ON DELETE CASCADE,
    Especie VARCHAR2(256) NOT NULL,
        CONSTRAINT FK_ESPECIE FOREIGN KEY (Especie) REFERENCES Especie(Nome_Cientifico)
);

CREATE TABLE Faccao(
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME_FACCAO PRIMARY KEY (Nome),
    Lider VARCHAR2(100),
        CONSTRAINT FK_LIDER FOREIGN KEY (Lider) REFERENCES Lider(CPI),
    Ideologia VARCHAR2(256),
    Qnt_Nacoes NUMBER(10)
);

CREATE TABLE NacaoFaccao(
    Nacao VARCHAR2(256),
        CONSTRAINT FK_NACAO_DA_FACCAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome),
    Faccao VARCHAR2(256),
        CONSTRAINT FK_FACCAO_DA_NACAO FOREIGN KEY (Faccao) REFERENCES Faccao(Nome),
        CONSTRAINT PK_NACAO_FACCAO PRIMARY KEY (Nacao, Faccao)
);

CREATE TABLE OrbitaPlaneta(
    Planeta VARCHAR2(256),
        CONSTRAINT FK_PLANETA FOREIGN KEY (Planeta) REFERENCES Planeta(Designacao_Astronomica) ON DELETE CASCADE,
    Estrela NUMBER(10),
        CONSTRAINT FK_ESTRELA_ORBITA FOREIGN KEY (Estrela) REFERENCES Estrela(Id_Catalogo),
        CONSTRAINT PK_ORBITA_PLANETA PRIMARY KEY (Planeta, Estrela),
    Distancia_Min VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Distancia_Max VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Periodo VARCHAR2(100)
);

CREATE TABLE Comunidade(
    Especie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE_COMUNIDADE FOREIGN KEY (Especie) REFERENCES Especie(Nome_Cientifico),
    Nome VARCHAR2(256),
        CONSTRAINT PK_COMUNIDADE PRIMARY KEY (Especie, Nome),
    Qtd_habitantes NUMBER(10),
        CONSTRAINT CK_QTD_HABITANTES CHECK (Qtd_habitantes > 0)
);

CREATE TABLE Habitacao(
    Planeta VARCHAR2(256),
        CONSTRAINT FK_PLANETA_HABITACAO FOREIGN KEY (Planeta) REFERENCES Planeta(Designacao_Astronomica),
    Especie VARCHAR2(256),
    NomeEspecie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE_HABITACAO FOREIGN KEY (Especie, NomeEspecie) REFERENCES Comunidade(Especie, Nome),
    Data_Ini DATE,
        CONSTRAINT PK_HABITACAO PRIMARY KEY (Planeta, Especie, NomeEspecie, Data_Ini),
    Data_Fim DATE
);

CREATE TABLE Participa(
    Faccao VARCHAR2(256),
        CONSTRAINT FK_FACCA_PARTICIPANTE FOREIGN KEY (Faccao) REFERENCES Faccao(Nome),
    Especie VARCHAR2(256),
    NomeEspecie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE_PARTICIPANTE FOREIGN KEY (Especie, NomeEspecie) REFERENCES Comunidade(Especie, Nome),
        CONSTRAINT PK_PARTICIPA PRIMARY KEY (Faccao, Especie, NomeEspecie)
);

-- 2)

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
INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES (64,256, '100', '200', '5');
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

-- 3)

-- a)
SELECT F.Nome, F.Ideologia, F.Lider, L.Especie, L.Nacao
    FROM Faccao F
    JOIN Lider L ON F.Lider = L.CPI;

-- b)
INSERT INTO Lider (CPI, Nome, Cargo, Nacao, Especie)
    VALUES ('44412', 'Ricardo', 'Vice', 'Jemison', 'Semi-Humanos');

SELECT L.CPI, L.Nome, L.Nacao, L.Especie, E.Planeta_Origem, F.Nome
    FROM Lider L
    JOIN Especie E ON L.Especie = E.Nome_Cientifico 
    LEFT JOIN Faccao F ON L.CPI = F.Lider;

-- c)

INSERT INTO OrbitaEstrela (Orbitante, Orbitada, Distancia_Min, Distancia_Max, Periodo)
    VALUES (64,256, '100', '200', '5');

SELECT O.Nome, O.Classificacao, E.Nome, E.Classificacao
    FROM Estrela E
    JOIN OrbitaEstrela OE ON E.Id_Catalogo = OE.Orbitante
    JOIN Estrela O ON OE.Orbitada = O.Id_Catalogo
    ORDER BY O.Nome;

-- d)

INSERT INTO Habitacao (Planeta, Especie, NomeEspecie, Data_Ini)
    VALUES ('Tormenta', 'Cachimbus-Cachunbenses', 'Rio de Janeiro', TO_DATE('01/01/2200', 'DD/MM/YYYY'));

INSERT INTO Habitacao (Planeta, Especie, NomeEspecie, Data_Ini)
    VALUES ('Tormenta', 'Semi-Humanos', 'O Alto', TO_DATE('01/01/2200', 'DD/MM/YYYY'));

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio, Composicao, Classicacao)
    VALUES ('Tormenta', 200, 20, 'Nitrogenio e Amonia', 'Rochosos');


SELECT 
    p.designacao_astronomica AS planeta,
    COUNT(CASE WHEN e.eh_inteligente = 'sim' THEN 1 END) AS qtd_comunidades_inteligentes
  FROM 
    PLANETA p
    LEFT JOIN HABITACAO h ON p.designacao_astronomica = h.planeta AND h.data_fim IS NULL
    LEFT JOIN COMUNIDADE c ON h.especie = c.especie AND h.NomeEspecie = c.nome
    LEFT JOIN ESPECIE e ON c.especie = e.nome_cientifico
  GROUP BY p.designacao_astronomica;

-- e)

SELECT P.Designacao_Astronomica, E.Nome_Cientifico, COUNT(*)
    FROM Planeta P
    JOIN Habitacao H 
        ON P.Designacao_Astronomica = H.Planeta AND 
        H.Data_Fim IS NULL
    JOIN Especie E
        ON H.Especie = E.Nome_Cientifico
    join Comunidade C 
        ON E.Nome_Cientifico = C.Especie
    GROUP BY P.Designacao_Astronomica, E.Nome_Cientifico;

-- f)

INSERT INTO Planeta (Designacao_Astronomica, Massa, Raio, Composicao, Classicacao)
    VALUES ('Nebuloso', 200, 20, 'Nitrogenio e Amonia', 'Rochosos');

INSERT INTO OrbitaPlaneta (Planeta, Estrela, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Tormenta', 64, '220', '10', '80');
    
INSERT INTO OrbitaPlaneta (Planeta, Estrela, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Nebuloso', 64, '220', '10', '80');

-- A estrela 318 (Alpha Centauri) não deve aparecer na consulta
INSERT INTO OrbitaPlaneta (Planeta, Estrela, Distancia_Min, Distancia_Max, Periodo)
    VALUES ('Nebuloso', 318, '220', '10', '80');

SELECT E.Nome, E.Classificacao
FROM Estrela E
WHERE NOT EXISTS (
    SELECT OP1.Planeta
    FROM OrbitaPlaneta OP1
    WHERE OP1.Estrela = (
        SELECT E2.Id_Catalogo
        FROM Estrela E2
        WHERE E2.Nome = 'Walter'
    )
    AND NOT EXISTS (
        SELECT OP2.Planeta
        FROM OrbitaPlaneta OP2
        WHERE OP2.Planeta = OP1.Planeta
        AND OP2.Estrela = E.Id_Catalogo
    )
);
