/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
-- Dados para teste
INSERT INTO NACAO_FACCAO VALUES('Sit id ipsam.','Vanklion');
INSERT INTO NACAO_FACCAO VALUES('Aut explicabo.','Vetistas');
INSERT INTO NACAO_FACCAO VALUES('Natus ut rem.','Jorgistas');
INSERT INTO NACAO_FACCAO VALUES('Ad iure libero.','Mad');
INSERT INTO NACAO_FACCAO VALUES('Ut minima.','FoG');

INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI) VALUES('K2-290 b', 'Sit id ipsam.', TO_DATE('25/04/2190', 'DD/MM/YYYY'));
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI) VALUES('Kepler-696 b', 'Aut explicabo.', TO_DATE('25/04/2090', 'DD/MM/YYYY'));
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI) VALUES('Kepler-220 b', 'Natus ut rem.', TO_DATE('29/04/2190', 'DD/MM/YYYY'));
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI) VALUES('HD 96992 b', 'Ad iure libero.', TO_DATE('25/04/2600', 'DD/MM/YYYY'));
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI) VALUES('K2-62 c', 'Ut minima.', TO_DATE('25/06/2140', 'DD/MM/YYYY'));

INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Quam aut', 'Comunidade 1', 15);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Ipsa illo', 'Comunidade 2', 60);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Fuga id', 'Comunidade 3', 12);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Ad ab iure', 'Comunidade 4', 13);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Ad quod', 'Comunidade 5', 22);

INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('K2-290 b', 'Quam aut', 'Comunidade 1', TO_DATE('25/04/2190', 'DD/MM/YYYY'));
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Kepler-696 b', 'Ipsa illo', 'Comunidade 2', TO_DATE('25/04/2090', 'DD/MM/YYYY'));
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Kepler-220 b','Fuga id', 'Comunidade 3', TO_DATE('29/04/2190', 'DD/MM/YYYY'));
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('HD 96992 b','Ad ab iure', 'Comunidade 4', TO_DATE('25/04/2600', 'DD/MM/YYYY'));
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('K2-62 c','Ad quod', 'Comunidade 5', TO_DATE('25/06/2140', 'DD/MM/YYYY'));

SELECT F.Nome, D.Planeta, C.nome FROM
    Faccao F JOIN Nacao_Faccao NF ON f.nome = nf.faccao
    JOIN NACAO N ON nf.nacao = n.nome
    JOIN DOMINANCIA D ON d.nacao = n.nome
    JOIN Habitacao H ON h.planeta = d.planeta
    JOIN Comunidade C ON c.especie = h.especie AND c.nome = h.comunidade;

DECLARE
    v_faccao faccao.nome%TYPE;
    TYPE Comunidades_Table IS TABLE OF comunidade%ROWTYPE;
    v_comunidades Comunidades_Table;
BEGIN
    v_faccao := 'FoG'; 
    v_comunidades := Comunidades_Table();
    
    -- Preencher a tabela aninhada com os resultados da consulta
    FOR c_row IN (
        SELECT C.NOME, C.Especie
        FROM NACAO_FACCAO NF
        JOIN NACAO N ON NF.Nacao = N.Nome AND NF.Faccao = v_faccao
        JOIN DOMINANCIA D ON D.Nacao = N.Nome
        JOIN HABITACAO H ON H.Planeta = D.Planeta
        JOIN COMUNIDADE C ON C.Especie = H.Especie AND C.Nome = H.Comunidade
        WHERE NOT EXISTS (
            SELECT 1
            FROM PARTICIPA P
            WHERE P.Especie = H.Especie
            AND P.Comunidade = H.Comunidade
        )
    ) LOOP
        v_comunidades.EXTEND;
        v_comunidades(v_comunidades.LAST).Nome := c_row.Nome;
        v_comunidades(v_comunidades.LAST).Especie := c_row.Especie;
    END LOOP;
    
    FORALL i IN 1..v_comunidades.COUNT
        INSERT INTO Participa (Faccao, Especie, Comunidade) VALUES (v_faccao, v_comunidades(i).Especie ,v_comunidades(i).Nome);
    
    -- Exibir mensagem de sucesso
    DBMS_OUTPUT.PUT_LINE('Comunidades cadastradas como novas participantes da facção.');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma comunidade encontrada para cadastro.');
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
END;

-- Mostrar as saidas e verificar as data e tb outras exceptions
-- Falar sobre forall

-- 2)
