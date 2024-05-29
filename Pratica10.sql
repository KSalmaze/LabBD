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

-- Testando
-- Apenas tantando inserir uma federacao sem nenhuma nacao associada o erro acontece e não permite a insercao
INSERT INTO Federacao VALUES('Bom dia', TO_DATE('25/04/2190', 'DD/MM/YYYY'));

-- Porém após inserirmos uma nacao sem federacao a insercao da federacao é permitida
INSERT INTO Nacao(Nome) VALUES('Frost');
INSERT INTO Federacao VALUES('Bom dia', TO_DATE('25/04/2190', 'DD/MM/YYYY'));


-- b)
CREATE OR REPLACE TRIGGER LIDER_NACAO_FACCAO
BEFORE INSERT OR UPDATE ON NACAO_FACCAO
FOR EACH ROW
DECLARE
    v_contador NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_contador FROM 
        Lider L JOIN Faccao F ON L.Cpi = F.Lider
        WHERE :NEW.Nacao = L.Nacao;

    IF v_contador = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'O lider da facção nao esta associado a uma nação onde sua facção está presente.');
    END IF;
END;

-- Testando
-- Primeiro vamos criar um lider e uma faccao
INSERT INTO Lider (Cpi, Nome, Cargo, Nacao, Especie) 
    VALUES ('596.425.888-26', 'Nilton', 'COMANDANTE', 'Ut minima.', 'A ab et');
    
INSERT INTO Faccao (Nome, Lider, Ideologia, Qtd_nacoes) 
    VALUES ('Corvus', '596.425.888-26', 'TRADICIONALISTA', 5);

-- Agora vamos tentar associar uma nacao em que a faccao não está presente
INSERT INTO Nacao_Faccao (Nacao, Faccao) 
    VALUES ('Dolores quis.', 'Corvus');
-- Isso resulta no erro -20002, como esperado   

-- Agora quando colocamos uma nação válida
INSERT INTO Nacao_Faccao (Nacao, Faccao) 
    VALUES ('Ut minima.', 'Corvus');
-- Nenhum erro é encontrado

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
CREATE OR REPLACE TRIGGER Atualizar_Nrm_Planetas_em_Nacao
AFTER INSERT OR UPDATE OR DELETE ON Dominancia

DECLARE
    v_qnt_planetas NUMBER;
BEGIN
    -- foreach
    FOR v_nacao IN (SELECT * FROM Nacao) 
    LOOP
        SELECT COUNT(*) INTO v_qnt_planetas 
            FROM Dominancia WHERE Nacao = v_nacao.Nome 
                AND DATA_INI <= TRUNC(SYSDATE) AND
                    (DATA_FIM >= TRUNC(SYSDATE) OR DATA_FIM IS NULL);
        
        UPDATE Nacao SET Qtd_Planetas = v_qnt_planetas WHERE Nome = v_nacao.Nome;
        
    END LOOP;
    
END Atualizar_Nrm_Nacoes_em_Faccoes;

-- Testando
-- Para facilitar os testes eu Dropei o trigger da letra a
-- apenas para acelar as alterações em nacao

-- Inicialmente vamos criar um planeta e uma nacao novas
INSERT INTO Nacao (Nome) VALUES ('Icmc');

INSERT INTO Planeta (Id_Astro) VALUES ('Laurian');

-- Agora vamos inserilos na tabela de dominancia 

INSERT INTO Dominancia (Planeta, Nacao, Data_Ini) 
    VALUES ('Laurian', 'Icmc', TO_DATE('25/04/2016', 'DD/MM/YYYY'));

-- Agora fazendo um Select na tabela de nacao, a quantidade de planetas associados a nacao Icmc é 1
SELECT * FROM Nacao WHERE Nome = 'Icmc';
-- Aparentemente tudo funcionou corretamente, mas para ter certeza vamos adicionar mais um planeta

INSERT INTO Planeta (Id_Astro) VALUES ('Lucien');
    
INSERT INTO Dominancia (Planeta, Nacao, Data_Ini) 
    VALUES ('Lucien', 'Icmc', TO_DATE('25/04/2016', 'DD/MM/YYYY'));


SELECT * FROM Nacao WHERE Nome = 'Icmc';
-- Repetindo o Select o resultado agora é 2, ou seja o trigger funcionou corretamente

-- 2)
