-- Pedro Henrique Salmaze 13783714
CREATE TABLE Federacao(--Federacao 
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME PRIMARY KEY (Nome),
    Data_Fundacao DATE NOT NULL
);

CREATE TABLE Nacao(--Nacao
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME PRIMARY KEY (Nome),
    Quantidade_Planetas NUMBER(10),
        CONTRAINT CK_QUANTIDADE_PLANETAS CHECK (Quantidade_Planetas > 0),
    Federacao VARCHAR2(256),
        CONSTRAINT FK_FEDERACAO FOREIGN KEY (Federacao) REFERENCES Federacao(Nome)
);

CREATE TABLE Dominacia(
    Nacao VARCHAR2(256),
        CONSTRAINT FK_NACAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome),
    Planeta VARCHAR2(256),
        CONSTRAINT FK_PLANETA FOREIGN KEY (Planeta) REFERENCES Planeta(Designacao_Astronomica),
    Data_ini DATE,
        CONSTRAINT PK_DOMINACIA PRIMARY KEY (Nacao, Planeta, Data_ini) ,
    Data_fim DATE
);

CREATE TABLE Especie(
    Nome_Cientifico VARCHAR2(256),
        CONSTRAINT PK_NOME_CIENTIFICO PRIMARY KEY (Nome_Cientifico),
    Planeta_Origem VARCHAR2(256) NOT NULL,
        CONSTRAINT FK_PLANETA_ORIGEM FOREIGN KEY (Planeta_Origem) REFERENCES Planeta(Designacao_Astronomica),
    Eh_Inteligente VARCHAR2(3) NOT NULL,
        CHECK (LOWER(Eh_Inteligente) IN ('sim', 'nao'))-- Testar se funciona
);

CREATE TABLE Lider(
    CPI VARCHAR2(100),
        CONSTRAINT PK_LIDER PRIMARY KEY (CPI),
    Nome VARCHAR2(256),
    Cargo VARCHAR2(256) NOT UNLL,
    Nacao VARCHAR2(256),
        CONSTRAINT FK_NACAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome),
    Especie VARCHAR2(256) NOT NULL,
        CONTRAINT FK_ESPECIE FOREIGN KEY (Especie) REFERENCES Especie(Nome_Cientifico)
);

CREATE TABLE Faccao(
    Nome VARCHAR2(256),
        CONSTRAINT PK_NOME PRIMARY KEY (Nome),
    Lider VARCHAR2(100),
        CONSTRAINT FK_LIDER FOREIGN KEY (Lider) REFERENCES Lider(CPI),
    Ideologia VARCHAR2(256),
    Qnt_Nacoes NUMBER(10)
);

CREATE TABLE NacaoFaccao(
    Nacao VARCHAR2(256),
        CONSTRAINT FK_NACAO FOREIGN KEY (Nacao) REFERENCES Nacao(Nome),
    Faccao VARCHAR2(256),
        CONSTRAINT FK_FACCAO FOREIGN KEY (Faccao) REFERENCES Faccao(Nome),
        CONSTRAINT PK_NACAO_FACCAO PRIMARY KEY (Nacao, Faccao)
);

CREATE TABLE Sistema(--Sistema
    Estrela NUMBER(10),
        CONSTRAINT FK_ESTRELA FOREIGN KEY (Estrela) REFERENCES Estrela(Id_Catalogo),
        CONSTRAINT PK_ESTRELA PRIMARY KEY (Estrela),
    Nome VARCHAR2(256)
);

CREATE TABLE Estrela(--Estrela
    Id_Catalogo NUMBER(10),
        CONSTRAINT PK_ID_CATALOGO PRIMARY KEY (Id_Catalogo),
    Nome VARCHAR2(256),
    Classificacao VARCHAR2(256),
    Massa VARCHAR2(100), -- VARCHAR porque o numero pode ser muito grande
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

CREATE TABLE OrbitaPlameta(--
    Planeta NUMBER(10),
        CONSTRAINT FK_PLANETA FOREIGN KEY (Planeta) REFERENCES Planeta(Id_Catalogo),
    Estrela NUMBER(10),
        CONSTRAINT FK_ESTRELA FOREIGN KEY (Estrela) REFERENCES Estrela(Id_Catalogo),
        CONSTRAINT PK_ORBITA PRIMARY KEY (Planeta, Estrela),
    Distancia_Min VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Distancia_Max VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
    Periodo VARCHAR2(100) --VARCHAR porque o numero pode ser muito grande e possuir unidades de medida diferentes (ex: anos, dias, etc)
);

CREATE TABLE Planeta(
    Designacao_Astronomica VARCHAR2(256),
        CONSTRAINT PK_DESIGNACAO PRIMARY KEY (Designacao_Astronomica),
    Massa VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
        CONSTRAINT CK_MASSA CHECK (Massa > 0),
    Raio VARCHAR2(100), --VARCHAR porque o numero pode ser muito grande
        CONSTRAINT CK_RAIO CHECK (Raio > 0),
    Composicao VARCHAR2(256),
    Classicacao VARCHAR2(256)
);

CREATE TABLE Comunidade(
    Especie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE FOREIGN KEY (Especie) REFERENCES Especie(Nome_Cientifico),
    Nome VARCHAR2(256),
        CONSTRAINT PK_COMUNIDADE PRIMARY KEY (Especie, Nome),
    Qtd_habitantes NUMBER(10),
);

CREATE TABLE Habitacao(
    Planeta VARCHAR2(256),
        CONSTRAINT FK_PLANETA FOREIGN KEY (Planeta) REFERENCES Planeta(Designacao_Astronomica),
    Especie VARCHAR2(256),
    NomeEspecie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE FOREIGN KEY (Especie, NomeEspecie) REFERENCES Comunidade(Especie, Nome),
    Data_Ini DATE,
        CONSTRAINT PK_HABITACAO PRIMARY KEY (Planeta, Especie, NomeEspecie, Data_Ini),
    Data_Fim DATE
);

CREATE TABLE Participa(
    Faccao VARCHAR2(256),
        CONSTRAINT FK_FACCAO FOREIGN KEY (Faccao) REFERENCES Faccao(Nome),
    Especie VARCHAR2(256),
    NomeEspecie VARCHAR2(256),
        CONSTRAINT FK_ESPECIE FOREIGN KEY (Especie, NomeEspecie) REFERENCES Comunidade(Especie, Nome),
        CONSTRAINT PK_PARTICIPA PRIMARY KEY (Faccao, Especie, NomeEspecie)
);
-- Valores Deafault