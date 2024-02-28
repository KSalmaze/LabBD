CREATE TABLE Federacao(
    Nome VARCHAR2(256) PRIMARY KEY,
    Data_Fundacao DATE NOT NULL
);

CREATE TABLE Nacao(
    Nome VARCHAR2(256) PRIMARY KEY,
    Quantidade_Planetas NUMBER(10),
    Federacao VARCHAR2(256),
        CONSTRAINT fk_federacao FOREIGN KEY (Federacao) REFERENCES Federacao(Nome)
);

CREATE TABLE Nacao_Facao(

);

CREATE TABLE Lider(
    CPI VARCHAR2(100) PRIMARY KEY,
    Nome VARCHAR2(256),
    Cargo VARCHAR2(256) NOT NULL,
    Nacao VARCHAR2(256),
        CONSTRAINT fk_nacao FOREIGN KEY (Nacao) REFERENCES Nacao(Nome)
    Especie VARCHAR2(256),
);