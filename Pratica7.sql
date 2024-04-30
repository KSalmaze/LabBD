-- Pedro Henrique Salmaze - 13783714
-- Daniela Cristina Bogni - 11218577

-- 1)
-- Dados para teste
INSERT INTO ORBITA_ESTRELA (orbitante, orbitada) VALUES ('GJ 9798','Zet1Mus'); 
INSERT INTO ORBITA_ESTRELA (orbitante, orbitada) VALUES ('GJ 9798','GJ 2033'); 
INSERT INTO ORBITA_ESTRELA (orbitante, orbitada) VALUES ('GJ 2033','Zet1Mus'); 

set serveroutput on;

DECLARE
    v_max_num_estrelas NUMBER;
    v_numero_orbitantes NUMBER;
    v_nome_estrela orbita_estrela.orbitada%type;
    v_id_estrela estrela.id_estrela%TYPE;
    
    CURSOR c_estrelas IS
        SELECT O.orbitante, E.id_estrela, COUNT(*) AS num_estrelas_orbitantes
        FROM orbita_estrela O LEFT JOIN estrela E
        ON o.orbitada = e.nome
        GROUP BY O.orbitante, E.id_estrela
        ORDER BY COUNT(*) DESC;
BEGIN
    dbms_output.put_line('Hello World!');
    OPEN c_estrelas;
    FETCH c_estrelas INTO v_nome_estrela, v_id_estrela, v_max_num_estrelas;
    
    v_numero_orbitantes := v_max_num_estrelas;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Maior número de estrelas orbitantes: ' || v_max_num_estrelas);
    
    WHILE c_estrelas%FOUND AND v_numero_orbitantes = v_max_num_estrelas LOOP
        dbms_output.put_line(v_nome_estrela);
        FETCH c_estrelas INTO v_nome_estrela, v_id_estrela, v_numero_orbitantes;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    CLOSE c_estrelas;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nenhuma estrela encontrada');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
        
END;

-- 2)

DECLARE
    v_qtd_removidas NUMBER := 0; -- Variável para contar a quantidade de federações removidas
BEGIN

    DELETE FROM Federacao WHERE Nome = 'ICMC';
    
    -- Deleta as federações que não possuem nações associadas
    DELETE FROM Federacao
        WHERE Nome NOT IN (SELECT Federacao FROM Nacao);
        
    -- Obtém a quantidade de linhas afetadas pela operação DELETE
    v_qtd_removidas := SQL%ROWCOUNT;

    -- Imprime a quantidade de federações removidas
    DBMS_OUTPUT.PUT_LINE('Quantidade de federações removidas: ' || v_qtd_removidas);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
END;

-- 3)
-- Dados para teste
INSERT INTO COMUNIDADE VALUES('Ad quod','O baixo',10000);
INSERT INTO COMUNIDADE VALUES('Ad quod','O medio',500);

DECLARE
    -- Dados de planeta
    v_planeta planeta.ID_ASTRO%Type;
    
    -- Dados de comunidade
    v_especie comunidade.ESPECIE%Type;
    v_nome comunidade.NOME%Type;
    v_populacao comunidade.QTD_HABITANTES%Type;
    
    v_data DATE;
    
BEGIN 
    v_planeta := 'A a ex.';
    v_especie := 'Ad quod';
    v_nome := 'O baixo';
    
    v_data := SYSDATE;
    
    SELECT qtd_habitantes INTO v_populacao
    FROM comunidade WHERE 
        ESPECIE = v_especie AND
        NOME = v_nome;
        
    dbms_output.put_line('Quantidade de habitantes = ' || v_populacao);
        
    IF v_populacao <= 1000
        THEN 
        v_data := SYSDATE + INTERVAL '100' YEAR;
    ELSE
        v_data := SYSDATE + INTERVAL '50' YEAR;
    END IF;
    
    INSERT INTO Habitacao VALUES(v_planeta, v_especie, v_nome, SYSDATE, v_data);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Comunidade não encontrada');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
END;

-- Para vefificar se a inserção foi realizada com sucesso
SELECT * FROM Habitacao;

-- 4)
-- Dados para teste
INSERT INTO Estrela (id_estrela, Nome, x, y, z, classificacao) VALUES('OPNG 56', 'Jeta', 12, 15, 78, 'plwa');
INSERT INTO Estrela (id_estrela, Nome, x, y, z, classificacao) VALUES('OYYG 56', 'Roma', 77, 15, 78, 'plwa');
INSERT INTO Estrela (id_estrela, Nome, x, y, z, classificacao) VALUES('OPJU 56', 'Punto', 12, 15, 92, 'plwa');
INSERT INTO Estrela (id_estrela, Nome, x, y, z, classificacao) VALUES('OFDG 56', 'Cor', 12, 56, 78, 'plwa');
INSERT INTO Estrela (id_estrela, Nome, x, y, z, classificacao) VALUES('SSSG 56', 'Uno', 2, 15, 78, 'plwa');

INSERT INTO Orbita_Planeta (Planeta, Estrela, dist_min) VALUES ('XO-5 b', 'OPNG 56', 1500);
INSERT INTO Orbita_Planeta (Planeta, Estrela, dist_min) VALUES ('Wolf 1061 c', 'OYYG 56', 800);
INSERT INTO Orbita_Planeta (Planeta, Estrela, dist_min) VALUES ('WASP-87 A b', 'OPJU 56', 50);
INSERT INTO Orbita_Planeta (Planeta, Estrela, dist_min) VALUES ('WASP-96 b', 'OFDG 56', 6000);
INSERT INTO Orbita_Planeta (Planeta, Estrela, dist_min) VALUES ('WISE0047', 'SSSG 56', 1000);

-- Select para verificar os resultados
SELECT * FROM orbita_planeta Op JOIN Estrela E
    ON op.estrela= E.id_estrela WHERE e.classificacao = 'plwa';

DECLARE
    v_class_estrela estrela.classificacao%Type := 'Am';
    v_distancia_para_remocao NUMBER ;
    v_orbitas_removidas NUMBER := 0;
    CURSOR c_orbitas IS
        SELECT *
        FROM Orbita_Planeta op
        JOIN Estrela e ON op.Estrela = e.Id_Estrela
        WHERE e.classificacao = v_class_estrela
        FOR UPDATE;
    
BEGIN
    v_distancia_para_remocao := 1000;

    FOR r_orbita IN c_orbitas LOOP
        IF r_orbita.Dist_Min > v_distancia_para_remocao THEN
            DELETE FROM Orbita_Planeta
            WHERE CURRENT OF c_orbitas;
            v_orbitas_removidas := v_orbitas_removidas + 1;
        END IF;
    END LOOP;
    
    dbms_output.put_line('Orbitas removidas: ' || v_orbitas_removidas);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nenhuma estrela encontrada');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
END;