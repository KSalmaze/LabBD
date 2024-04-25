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
        dbms_output.put_line('Nenuma estrela encontrada');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM);
        
END;