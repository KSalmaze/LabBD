/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
-- Dados para teste
INSERT INTO Estrela(id_estrela, Nome, X, Y, Z) VALUES('HBNJK1345', 'Junior', 26, 6, 12);
INSERT INTO Estrela(id_estrela, Nome, X, Y, Z) VALUES('HBNJK1346', 'Delamaro', -2, 5, 0);

-- Função para calcular a distância entre duas estrelas
CREATE OR REPLACE FUNCTION Distancia_entre_estrelas(
    estrela1 IN estrela%ROWTYPE,
    estrela2 IN estrela%ROWTYPE
) RETURN NUMBER IS
    v_distancia NUMBER;

BEGIN
    v_distancia := SQRT(
        POWER(estrela1.x - estrela2.x, 2) +
        POWER(estrela1.y - estrela2.y, 2) +
        POWER(estrela1.z - estrela2.z, 2)
    );

    RETURN v_distancia;
END;



CREATE OR REPLACE FUNCTION Distancia_entre_estrelas(
    estrela1 IN estrela%ROWTYPE,
    estrela2 IN estrela%ROWTYPE
) RETURN NUMBER IS
    v_distancia NUMBER;

BEGIN
    v_distancia := SQRT(
        POWER(estrela1.x - estrela2.x, 2) +
        POWER(estrela1.y - estrela2.y, 2) +
        POWER(estrela1.z - estrela2.z, 2)
    );

    RETURN v_distancia;
END;

-- Programa PL/SQL
DECLARE 
    v_estrela1 estrela%ROWTYPE;
    v_estrela2 estrela%ROWTYPE;
    v_nome_estrela1 estrela.Nome%TYPE;
    v_nome_estrela2 estrela.Nome%TYPE;
    v_resultado NUMBER;
BEGIN
    v_nome_estrela1 := 'Junior';
    v_nome_estrela2 := 'Delamaro';
    
    SELECT * INTO v_estrela1 FROM ESTRELA WHERE Nome = v_nome_estrela1;
    SELECT * INTO v_estrela2 FROM ESTRELA WHERE Nome = v_nome_estrela2;
    
    v_resultado := Distancia_entre_estrelas(v_estrela1, v_estrela2);
    dbms_output.put_line(v_resultado);
END;

-- 2)