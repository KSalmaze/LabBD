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
