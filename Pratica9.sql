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

-- Programa PL/SQL para testar
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

-- Declaracao do pacote
-- Pacote acessavel por lideres
CREATE OR REPLACE PACKAGE Funcoes_Lider AS
    
    e_Acesso_Negado EXCEPTION;
    
    PROCEDURE Remover_Nacao (
     lider_logado IN lider%ROWTYPE,
        v_nacao_a_ser_removida IN nacao.nome%TYPE);
    
END Funcoes_Lider;

-- Corpo do pacote
CREATE OR REPLACE PACKAGE BODY Funcoes_Lider AS

-- Parametros: Lider logado e a nacao que deseja remover
PROCEDURE Remover_Nacao(
    lider_logado IN lider%ROWTYPE,
    v_nacao_a_ser_removida IN nacao.nome%TYPE) AS
    v_lider_esperado lider.Cpi%TYPE;
    v_faccao_lider faccao.nome%TYPE;
    
BEGIN
    SELECT F.Lider INTO v_lider_esperado FROM 
        Nacao_Faccao NF JOIN Faccao F ON NF.Faccao = F.Nome
        WHERE NF.Nacao = v_nacao_a_ser_removida;
        
    SELECT F.Nome INTO v_faccao_lider FROM
        Faccao F JOIN Lider L ON F.Lider = L.Cpi WHERE L.Nome = lider_logado.Nome;

    IF lider_logado.Cpi = v_lider_esperado THEN
        DELETE FROM NACAO_FACCAO WHERE Nacao = v_nacao_a_ser_removida AND Faccao = v_faccao_lider;
    ELSE
        RAISE e_Acesso_Negado;
    END IF;
END;

END Funcoes_Lider;

-- Programa PL/SQL para testar
DECLARE
    v_lider lider%ROWTYPE;
    v_nacao_para_remocao nacao.nome%TYPE;
BEGIN
    v_nacao_para_remocao := 'Sit id ipsam.';
    
    SELECT * INTO v_lider FROM Lider WHERE Nome = 'Oliver';
    
    Funcoes_Lider.Remover_Nacao(v_lider, v_nacao_para_remocao);
EXCEPTION
    WHEN Funcoes_Lider.e_Acesso_Negado THEN dbms_output.put_line('Acesso negado');
END;

-- 3)
/*
BEFJANDANLJSFHJNLKJNSL




KREWISDNFDLFNKFWDFSESF
*/

CREATE OR REPLACE PACKAGE Funcoes_Lider AS
    
    e_Acesso_Negado EXCEPTION;
    e_Federacao_Repetida EXCEPTION;
    
    PROCEDURE Remover_Nacao (
     lider_logado IN lider%ROWTYPE,
        v_nacao_a_ser_removida IN nacao.nome%TYPE);
        
    PROCEDURE Criar_Federacao(
        lider_logado IN lider%ROWTYPE,
        v_nome_federacao federacao.Nome%TYPE);
    
END Funcoes_Lider;
/

CREATE OR REPLACE PACKAGE BODY Funcoes_Lider AS

PROCEDURE Remover_Nacao(
    lider_logado IN lider%ROWTYPE,
    v_nacao_a_ser_removida IN nacao.nome%TYPE) AS
    v_lider_esperado lider.Cpi%TYPE;
    v_faccao_lider faccao.nome%TYPE;
    
BEGIN
    SELECT F.Lider INTO v_lider_esperado FROM 
        Nacao_Faccao NF JOIN Faccao F ON NF.Faccao = F.Nome
        WHERE NF.Nacao = v_nacao_a_ser_removida;
        
    SELECT F.Nome INTO v_faccao_lider FROM
        Faccao F JOIN Lider L ON F.Lider = L.Cpi WHERE L.Nome = lider_logado.Nome;

    IF lider_logado.Cpi = v_lider_esperado THEN
        DELETE FROM NACAO_FACCAO WHERE Nacao = v_nacao_a_ser_removida AND Faccao = v_faccao_lider;
    ELSE
        RAISE e_Acesso_Negado;
    END IF;
END;

PROCEDURE Criar_Federacao(
        lider_logado IN lider%ROWTYPE,
        v_nome_federacao federacao.Nome%TYPE) AS
        v_nacao_lider Lider.nacao%TYPE;
        v_contagem_de_federacaoes NUMBER;

BEGIN
    IF lider_logado.Cargo != 'COMANDANTE' THEN
        dbms_output.put_line('Acesso negado');
    END IF;
    
    SELECt COUNT(*) INTO v_contagem_de_federacaoes FROM Federacao WHERE Nome = v_nome_federacao;
    
    IF v_contagem_de_federacaoes != 0 THEN
        dbms_output.put_line('Ja ha uma federacao com esse nome');
    END IF;
    
    INSERT INTO Federacao VALUES(v_nome_federacao, SYSDATE);
    UPDATE Nacao SET federacao = v_nome_federacao WHERE nome = lider_logado.nacao;
END;
        
END Funcoes_Lider;

/

DECLARE
    v_lider lider%ROWTYPE;
    v_federacao_para_adicionar federacao.nome%TYPE;
BEGIN
    v_federacao_para_adicionar := 'Benzoato';
    
    SELECT * INTO v_lider FROM Lider WHERE Nome = 'Mathues';
    
    Funcoes_Lider.Criar_Federacao(v_lider, v_federacao_para_adicionar);
EXCEPTION
    WHEN Funcoes_Lider.e_Acesso_Negado THEN dbms_output.put_line('Acesso negado');
    WHEN Funcoes_Lider.e_Federacao_Repetida THEN dbms_output.put_line('Ja existe um afederação com esse nome');
END;

-- Para testes 

UPDATE Lider SET Cargo = 'COMANDANTE' WHERE Nome = 'Mathues';

SELECT * FROM FEDERACAO WHERE Nome = 'Benzoato';

-- 4)

CREATE OR REPLACE PACKAGE Funcoes_Cientista AS
    
    -- Create
    PROCEDURE Adicioar_Estrela(v_estrela IN estrela%ROWTYPE);
    
    -- Read
    PROCEDURE Ler_Por_Classificacao(v_cursor OUT SYS_REFCURSOR, v_classificacao estrela.classificacao%TYPE);
    
    -- Delete
    PROCEDURE Remover_Estrela_Por_ID(v_id_estrela IN estrela.id_estrela%TYPE);
    PROCEDURE Remover_Estrela_Por_Nome(v_nome_estrela IN estrela.nome%TYPE);
    
    -- Update
    PROCEDURE Atualizat_Massa_Estrela(v_id_estrela IN estrela.id_estrela%TYPE, v_nova_massa IN NUMBER);
    PROCEDURE Atualizat_Classficacao_Estrela(v_id_estrela IN estrela.id_estrela%TYPE, v_nova_classificacao IN estrela.classificacao%TYPE);
    
    -- Relatorios
    PROCEDURE Info_Estrelas_e_seus_Sistemas(c_estrelas OUT SYS_REFCURSOR);
    PROCEDURE Info_Planetas(c_planetas OUT SYS_REFCURSOR);

END Funcoes_Cientista;

/

CREATE OR REPLACE PACKAGE BODY Funcoes_Cientista AS

    PROCEDURE Adicioar_Estrela(v_estrela IN estrela%ROWTYPE) AS
    
    BEGIN 
        INSERT INTO Estrela VALUES v_estrela;
        -- Execao se ja houver uma estrela com esse nome
    END;
    
    PROCEDURE Ler_Por_Classificacao(v_cursor OUT SYS_REFCURSOR, v_classificacao estrela.classificacao%TYPE) AS
    BEGIN
        OPEN v_cursor FOR SELECT *
            FROM Estrela WHERE Classificacao = v_classificacao;
    END;
    
    PROCEDURE Remover_Estrela_Por_ID(v_id_estrela IN estrela.id_estrela%TYPE) AS
    BEGIN
        DELETE FROM Estrela WHERE id_estrela = v_id_estrela;
    END;
    
    PROCEDURE Remover_Estrela_Por_Nome(v_nome_estrela IN estrela.nome%TYPE) AS
    BEGIN
        DELETE FROM Estrela WHERE Nome = v_nome_estrela;
    END;
    
    PROCEDURE Atualizat_Massa_Estrela(v_id_estrela IN estrela.id_estrela%TYPE, v_nova_massa IN NUMBER) AS
    BEGIN
        UPDATE Estrela SET Massa = v_nova_massa WHERE Id_Estrela = v_id_estrela;
    END;
    
    PROCEDURE Atualizat_Classficacao_Estrela(v_id_estrela IN estrela.id_estrela%TYPE, v_nova_classificacao IN estrela.classificacao%TYPE) AS
    BEGIN
        UPDATE Estrela SET Classificacao = v_nova_classificacao WHERE Id_Estrela = v_id_estrela;
    END;

    PROCEDURE Info_Estrelas_e_seus_Sistemas(c_estrelas OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_estrelas FOR
            SELECT E.Id_Estrela AS ID, E.Nome, E.Classificacao, E.Massa, S.Nome AS Sistema, E.X, E.Y, E.Z
            FROM Estrela E
                LEFT JOIN Sistema S ON E.Id_Estrela = S.Estrela;
    END;
    
    PROCEDURE Info_Planetas(c_planetas OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_planetas FOR
            SELECT * FROM Planeta;
    END;

END Funcoes_Cientista;

/

-- PL/SQL simples apenas para testes

DECLARE
    v_estrela Estrela%ROWTYPE;
    v_planeta Planeta%ROWTYPE;
    v_cursor SYS_REFCURSOR;
    v_id_estrela Estrela.id_estrela%TYPE;
    v_nova_massa NUMBER;
    v_nova_classificacao Estrela.classificacao%TYPE;
BEGIN
    -- Definindo valores para a estrela
    v_estrela.id_estrela := 1;
    v_estrela.nome := 'Estrela Teste';
    v_estrela.classificacao := 'G';
    v_estrela.massa := 1.0;
    v_estrela.X := 1;
    v_estrela.Y := 34;
    v_estrela.Z := 16;
    
    -- Adicionando uma nova estrela
    Funcoes_Cientista.Adicioar_Estrela(v_estrela);
    
    -- Lendo estrelas por classificação
    Funcoes_Cientista.Ler_Por_Classificacao(v_cursor, 'G');
    -- Aqui você pode processar os resultados do cursor v_cursor
    
    -- Atualizando a massa de uma estrela
    v_id_estrela := 1;
    v_nova_massa := 2.0;
    Funcoes_Cientista.Atualizat_Massa_Estrela(v_id_estrela, v_nova_massa);
    
    -- Atualizando a classificação de uma estrela
    v_nova_classificacao := 'K';
    Funcoes_Cientista.Atualizat_Classficacao_Estrela(v_id_estrela, v_nova_classificacao);
    
    -- Removendo uma estrela por ID
    Funcoes_Cientista.Remover_Estrela_Por_ID(v_id_estrela);
    
    -- Removendo uma estrela por nome
    Funcoes_Cientista.Remover_Estrela_Por_Nome('Estrela Teste');
    
    -- Obtendo informações sobre estrelas e seus sistemas
    Funcoes_Cientista.Info_Estrelas_e_seus_Sistemas(v_cursor);
    -- Aqui você pode processar os resultados do cursor v_cursor
    
    CLOSE v_cursor;
    
    -- Obtendo informações sobre planetas
    Funcoes_Cientista.Info_Planetas(v_cursor);
    LOOP
        FETCH v_cursor INTO v_planeta;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_planeta.ID_Astro || ' ' || v_planeta.Massa);
    END LOOP;
    
    -- Aqui você pode processar os resultados do cursor v_cursor
END;