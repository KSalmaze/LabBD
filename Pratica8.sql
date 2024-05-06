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

/*
    FOR r_comunidade IN c_comunidades LOOP
        BEGIN
            SELECT COMUNIDADE INTO v_dummy FROM PARTICIPA P WHERE 
                r_comunidade.NOME = P.comunidade AND
                v_faccao = p.faccao AND 
                r_comunidade.especie = p.especie;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                comunidades.EXTEND;
                comunidades(comunidades.LAST) := r_comunidade.NOME;
        END;
    END LOOP;
*/

DECLARE
    -- Declare uma variável para armazenar a entrada do usuário (nome da facção).
    v_faccao FACCAO.NOME%TYPE := 'FoG'; -- substitua 'NomeDaFaccao' pelo nome da facção desejada

    -- Declare um tipo de tabela aninhada para armazenar as comunidades que serão inseridas.
    TYPE ComunidadesTab IS TABLE OF VARCHAR2(100);
    comunidades ComunidadesTab;
    
    -- Declare um cursor para selecionar as comunidades que habitam planetas dominados por nações onde a facção está presente,
    -- mas que ainda não participam da facção.
    CURSOR c_comunidades IS
        SELECT C.NOME, C.Especie
        FROM FACCAO F
        JOIN NACAO_FACCAO NF ON F.NOME = NF.FACCAO AND F.NOME = v_faccao
        JOIN NACAO N ON NF.NACAO = N.NOME
        JOIN DOMINANCIA D ON D.NACAO = N.NOME
        JOIN HABITACAO H ON H.PLANETA = D.PLANETA
        JOIN COMUNIDADE C ON C.ESPECIE = H.ESPECIE AND C.NOME = H.COMUNIDADE
        LEFT JOIN PARTICIPA P ON P.FACCAO = F.NOME AND P.ESPECIE = C.ESPECIE AND P.COMUNIDADE = C.NOME
        WHERE P.FACCAO IS NULL;
BEGIN
    -- Use um cursor FOR LOOP para adicionar cada comunidade à coleção.
    FOR r_comunidade IN c_comunidades LOOP
        comunidades.EXTEND;
        comunidades(comunidades.LAST) := r_comunidade.NOME;
    END LOOP;

    -- Use FORALL para inserir todas as comunidades da coleção na tabela `Participa`.
    FORALL i IN comunidades.FIRST..comunidades.LAST
        SELECT * FROM PARTICIPA P WHERE 
            comunidades(i) = P.comunidade AND
            v_faccao = p.faccao AND 
            c_comunidades(i).especie = p.especie;
        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('Vai');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Não vai');
        END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        ROLLBACK;
END;