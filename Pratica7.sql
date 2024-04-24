-- Pedro Henrique Salmaze - 13783714
-- Daniela Cristina Bogni - 11218577

-- 1)
DECLARE 
    v_istrela estrela.id_estrela%TYPE;
    v_

DECLARE
    v_max_num_estrelas NUMBER;
    v_nome_estrela VARCHAR2(100);
    v_id_estrela NUMBER;
    
    CURSOR c_estrelas IS
        SELECT nome, id, COUNT(*) AS num_estrelas_orbitantes
        FROM estrelas_orbitantes
        GROUP BY nome, id
        ORDER BY COUNT(*) DESC;
BEGIN
    OPEN c_estrelas;
    FETCH c_estrelas INTO v_nome_estrela, v_id_estrela, v_max_num_estrelas;
    
    DBMS_OUTPUT.PUT_LINE('Estrelas com o maior número de estrelas orbitantes:');
    DBMS_OUTPUT.PUT_LINE('Maior número de estrelas orbitantes: ' || v_max_num_estrelas);
    DBMS_OUTPUT.PUT_LINE('------------------------');
    
    WHILE c_estrelas%FOUND AND v_max_num_estrelas = (SELECT MAX(num_estrelas_orbitantes) FROM estrelas_orbitantes) LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome_estrela || ', ID: ' || v_id_estrela);
        FETCH c_estrelas INTO v_nome_estrela, v_id_estrela, v_max_num_estrelas;
    END LOOP;
    
    CLOSE c_estrelas;
END;
