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

/*
    FORALL

    O FORALL no PL/SQL é uma construção eficiente para executar operações em lote em bancos de dados Oracle,
     reduzindo o tempo de execução e minimizando o número de chamadas ao banco de dados.
*/

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
        JOIN DOMINANCIA D ON D.Nacao = N.Nome AND D.DATA_FIM IS NULL
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

/*  TESTANDO

CONSULTA PARA TESTE:*/
SELECT C.NOME, C.Especie
        FROM NACAO_FACCAO NF
        JOIN NACAO N ON NF.Nacao = N.Nome AND NF.Faccao = 'FoG'
        JOIN DOMINANCIA D ON D.Nacao = N.Nome AND D.DATA_FIM IS NULL
        JOIN HABITACAO H ON H.Planeta = D.Planeta
        JOIN COMUNIDADE C ON C.Especie = H.Especie AND C.Nome = H.Comunidade
        WHERE NOT EXISTS (
            SELECT 1
            FROM PARTICIPA P
            WHERE P.Especie = H.Especie
            AND P.Comunidade = H.Comunidade
        )

/*
Antes de rodar o código PL/SQL a consulta acima retorna a tupla
Comunidade 5	Ad quod

Após rodar o código PL/SQL a consulta anão retorna nenhuma tupla indicando 
que a comunidade foi cadastrada na tabela PARTICIPA
*/

-- 2)

-- Para testar tive que limitar o for com os prints, pois a quantidade de dados era muito grande e
-- estava demorando muito

DECLARE
    TYPE t_planeta_info IS RECORD (
        planeta VARCHAR2(15),
        nacao_dominante VARCHAR2(15),
        data_ini DATE,
        data_fim DATE,
        qtd_comunidades NUMBER,
        qtd_especies NUMBER,
        qtd_habitantes NUMBER,
        qtd_faccoes NUMBER,
        qtd_especies_originarias NUMBER
    );
    TYPE t_planeta_info_tab IS TABLE OF t_planeta_info;
    l_planeta_info_tab t_planeta_info_tab;
    CURSOR c_planeta_info IS
        SELECT 
    p.ID_ASTRO AS planeta, 
    d.NACAO AS nacao_dominante,
    d.DATA_INI AS data_ini,
    d.DATA_FIM AS data_fim,
    COUNT(h.COMUNIDADE) AS qtd_comunidades,
    COUNT(DISTINCT h.ESPECIE) AS qtd_especies,
    SUM(c.QTD_HABITANTES) AS qtd_habitantes,
    COUNT(DISTINCT part.FACCAO) AS qtd_faccoes,
    COUNT(e.NOME) AS qtd_especies_originarias
FROM 
    PLANETA p
    LEFT JOIN DOMINANCIA d ON p.ID_ASTRO = d.PLANETA
    LEFT JOIN HABITACAO h ON p.ID_ASTRO = h.PLANETA
    LEFT JOIN COMUNIDADE c ON c.ESPECIE = h.ESPECIE AND c.NOME = h.COMUNIDADE
    LEFT JOIN PARTICIPA part ON part.ESPECIE = h.ESPECIE AND part.COMUNIDADE = h.COMUNIDADE
    LEFT JOIN ESPECIE e ON p.ID_ASTRO = e.PLANETA_OR
GROUP BY 
    p.ID_ASTRO, 
    d.NACAO,
    d.DATA_INI,
    d.DATA_FIM;
BEGIN
    OPEN c_planeta_info;
    FETCH c_planeta_info BULK COLLECT INTO l_planeta_info_tab;
    CLOSE c_planeta_info;
    
    dbms_output.put_line(l_planeta_info_tab.COUNT);
    
    FOR i IN 1..l_planeta_info_tab.COUNT LOOP
        dbms_output.put_line('Planeta: ' || l_planeta_info_tab(i).planeta);
        dbms_output.put_line('Nação dominante: ' || l_planeta_info_tab(i).nacao_dominante);
        dbms_output.put_line('Data de início da última dominação: ' || l_planeta_info_tab(i).data_ini);
        dbms_output.put_line('Data de fim da última dominação: ' || l_planeta_info_tab(i).data_fim);
        dbms_output.put_line('Quantidade de comunidades: ' || l_planeta_info_tab(i).qtd_comunidades);
        dbms_output.put_line('Quantidade de espécies: ' || l_planeta_info_tab(i).qtd_especies);
        dbms_output.put_line('Quantidade de habitantes: ' || l_planeta_info_tab(i).qtd_habitantes);
        dbms_output.put_line('Quantidade de facções: ' || l_planeta_info_tab(i).qtd_faccoes);
        dbms_output.put_line('Quantidade de espécies originárias: ' || l_planeta_info_tab(i).qtd_especies_originarias);
        dbms_output.put_line('-------------------------');
    END LOOP;
END;