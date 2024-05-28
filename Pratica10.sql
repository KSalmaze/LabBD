/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
-- a)
/*
    Um problema encontrado é que uma federação sempre vai ser inserida sem estar associada a nenhuma nação.
    para passar por esse problema, podemos fazer algumas verificações como, verificar se há
    pelo menos uma nação que pode ser associada a nova federação, e quando uma nação for 
    deletada / atualizada verificar se não vai deixar nenhuma federação sem nação associada.
*/ 

CREATE OR REPLACE TRIGGER Verficacao_Federacao
BEFORE INSERT ON Federacao

DECLARE
    v_nacoes_sem_federacao NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_nacoes_sem_federacao FROM
        Nacao WHERE Federacao = NULL;
        
    IF v_nacoes_sem_federacao = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'A federacao nao pode ser criada, pois nao existe nenhuma nacao ');
    END IF;
END;




-- b)

-- c)

CREATE OR REPLACE TRIGGER Atualizar_Nrm_Nacoes_em_Faccoes
AFTER INSERT OR UPDATE OR DELETE ON Nacao_Faccao

DECLARE
    v_qntreal_nacoes NUMBER;
    v_qntregistrada_nacoes NUMBER;
BEGIN
    -- foreach
    FOR v_faccao IN (SELECT * FROM Faccao) 
    LOOP
        SELECT COUNT(*) INTO v_qntreal_nacoes 
            FROM Nacao_Faccao WHERE Faccao = v_faccao.Nome;
        
        SELECT Qtd_Nacoes INTO v_qntregistrada_nacoes
            FROM Faccao WHERE Nome = v_faccao.Nome;
            
        IF v_qntreal_nacoes != v_qntregistrada_nacoes THEN
            UPDATE Faccao SET Qtd_Nacoes = v_qntreal_nacoes
                WHERE Nome = v_faccao.Nome;
        END IF;
        
    END LOOP;
    
END Atualizar_Nrm_Nacoes_em_Faccoes;

-- Testando

-- Select para determinar a quantidade de nações associadas a facção 'Vetistas'
-- a saida foi 5, valor dado na inserção de vetistas na tabela facção
SELECT * FROM Faccao WHERE Nome = 'Vetistas';

-- Inserindo uma nova nacao na faccao
INSERT INTO Nacao_Faccao (Faccao, Nacao) VALUES('Vetistas', 'Quis optio.'); 

-- Repetindo o Select agora a quantidade de nacoes é 2, o valor correto considerando que vetistas
-- ja tinha uma nacao associada a ela anteriormente
SELECT * FROM Faccao WHERE Nome = 'Vetistas';

-- Agora deletando uma faccao
DELETE FROM Nacao_Faccao WHERE Nacao = 'Quis optio.';

-- Repetindo o Select agora a quantidade de nacoes é 1, o valor correto

-- Agora só falta testar uma atualização
-- Para isso inserimos novamente a nacao e depois atualizamos a faccao associada
INSERT INTO Nacao_Faccao (Faccao, Nacao) VALUES('Vetistas', 'Quis optio.'); 

-- Agora o select informa 2 nacoes associadas a faccao vetistas

UPDATE Nacao_Faccao SET Faccao = 'Mad' WHERE Nacao = 'Quis optio.';

-- Agora informa apenas uma
-- com isso o trigger funciona corretamente

-- d)