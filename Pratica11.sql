/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1
-- Os comandos usados foram os seguintes:
DELETE FROM Faccao WHERE Lider = '596.425.888-26';
DELETE FROM Lider WHERE Nome = 'Nilton';

INSERT INTO Lider (Cpi, Nome, Cargo, Nacao, Especie) 
    VALUES ('596.425.888-26', 'Nilton', 'COMANDANTE', 'Ut minima.', 'A ab et');
    
INSERT INTO Faccao (Nome, Lider, Ideologia, Qtd_nacoes) 
    VALUES ('Corvus', '596.425.888-26', 'TRADICIONALISTA', 5);

-- Consulta
SELECT * FROM Lider L JOIN 
    Faccao F ON F.Lider = L.Cpi;    

/* READ COMMITTED
    Quando a consulta é feita pelo usuário 2 no passo VI, nenhuma mudança é vista, 
    porém após o passo VII onde o usuário executa 1 o COMMIT as mudanças podem ser vistas,
    isso se deve ao fato do READ COMMIT ler qualquer dado que já tenha sido commitado.
    Após o passo IX, nada se alterou na consulta
*/

/* SERIALIZABLE
    Quando a consulta é feita pelo usuário 2 no passo VI, nenhuma mudança é vista, 
    após o passo VII onde o usuário 1 executa o COMMIT as mudanças também não são 
    vistas, as mundaças só podem ser vistas após o passo IX, isso se deve ao fato do
    nivel de isolamento SERIALIZABLE, que não permite que a consulta veja dados que
    foram modificados por transações que não terminaram antes dela começar
*/

-- 2
-- a)
-- Tabela
CREATE TABLE Log_Sistema(
    usuario VARCHAR(100),
    data_operacao TIMESTAMP,
    operacao VARCHAR(50),
    PRIMARY KEY (usuario, data_operacao, operacao)
);

-- Trigger
CREATE OR REPLACE TRIGGER log_de_Sistema
AFTER INSERT OR UPDATE OR DELETE ON Sistema
BEGIN
    IF INSERTING THEN
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'UPDATE');
    ELSE
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'DELETE');
    END IF;
END;

-- Testando
INSERT INTO Sistema (Estrela, Nome) VALUES('Gam1Sgr','Manjaro');

DELETE FROM Sistema WHERE Nome = 'Manjaro';

INSERT INTO Sistema (Estrela, Nome) VALUES('Gam1Sgr','Kali');

UPDATE Sistema SET Nome = 'Manjaro' WHERE Nome = 'Kali';

SELECT * FROM Log_Sistema;

-- b)

-- Primeiro vamos executar uma operação que dispare o trigger

INSERT INTO Sistema (Estrela, Nome) VALUES('GJ 9119B','Manjaro');

-- Vamos verificar o log

SELECT * FROM Log_Sistema;
/*
    A13783714	04/06/24 17:55:50,107000000	INSERT
*/

-- Executar uma rollback e verificar o log novamente
ROLLBACK;
SELECT * FROM Log_Sistema;
-- Agora a o log aparece vazio

/*
    A operação de inserção não está mais no log, porque o rollback 
    da transação também desfez a operação de inserção realizada pelo trigger.
*/

-- Agora novamente vamos executar uma operação que dispare o trigger
INSERT INTO Sistema (Estrela, Nome) VALUES('GJ 9119B','Manjaro');

-- Vamos verificar o log

SELECT * FROM Log_Sistema;
/*
    A13783714	04/06/24 17:57:58,232000000	INSERT
*/

-- Executar um commit e verificar o log novamente
COMMIT;
SELECT * FROM Log_Sistema;
/*
    A13783714	04/06/24 17:57:58,232000000	INSERT
*/

/*
    a operação de inserção ainda está no log, porque o commit da transação 
    também confirmou a operação de inserção realizada pelo trigger.
*/

-- c)
-- Novo trigger
CREATE OR REPLACE TRIGGER log_de_Sistema
AFTER INSERT OR UPDATE OR DELETE ON Sistema
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    IF INSERTING THEN
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'UPDATE');
    ELSE
        INSERT INTO Log_Sistema (usuario, data_operacao, operacao)
        VALUES (USER, CURRENT_TIMESTAMP, 'DELETE');
    END IF;
    
    COMMIT;
END;

-- Testando

-- Primeiro vamos executar uma operação que dispare o trigger
INSERT INTO Sistema (Estrela, Nome) VALUES('Tonatiuh','Arch');

-- Vamos verificar o log
SELECT * FROM Log_Sistema;
/*
    A13783714	04/06/24 17:57:58,232000000	INSERT
    A13783714	04/06/24 20:00:35,972000000	INSERT
*/

-- Executar uma rollback e verificar o log novamente
ROLLBACK;
SELECT * FROM Log_Sistema;
/*
    A13783714	04/06/24 17:57:58,232000000	INSERT
    A13783714	04/06/24 20:00:35,972000000	INSERT
*/

/*
    O log agora é mantido mesmo após o rollback.
*/

-- 3)
/* TRANSACAO QUE DEVERA SER IMPLEMENTADA NO PROJETO FINAL:
 * Lider de uma faccao remover faccao de nacao (Gerenciamento: item 1.b) */


-- LETRA A: OPERACOES QUE ESTAO INCLUIDAS NA TRANSACAO
/* Operacao de SELECT na tabela NACAO para verificar se a nacao em questao existe;
 * Operacao de SELECT na tabela FACCAO para verificar se a faccao que sera removida existe;
 *
 * -------------------------------- TRIGGER Verificar_Associacoes_Faccao --------------------------------
 * * (Impede o DELETE em NACAO_FACCAO quando isso causa a dissociacao da faccao com a nacao de seu lider)
 * Operacao de SELECT na tabela FACCAO para obter o CPI do lider da faccao que sera removida;
 * Operacao de SELECT na tabela LIDER para obter a nacao a qual o lider da faccao pertence;
 * ------------------------------------------------------------------------------------------------------
 *
 * Operacao de DELETE na tabela NACAO_FACCAO para remover a faccao da nacao;
 *
 * -------------------------------- TRIGGER Atualizar_Faccao_Qtd_Nacoes --------------------------------
 * * (Atualiza a quantidade de nacoes da tabela FACCAO depois de um DELETE em NACAO_FACCAO)
 * Operacao de SELECT na tabela FACCAO para obter todas as faccoes existentes na tabela;
 * Operacoes de SELECT na tabela NACAO_FACCAO para contar quantas nacoes estao associadas a cada faccao;
 * Operacoes de UPDATE na tabela FACCAO para atualizar a quantidade de nacoes de cada faccao.
 * -----------------------------------------------------------------------------------------------------
 * */


-- LETRA B: NIVEL DE ISOLAMENTO DA TRANSACAO
/* A transacao definida deve ter nivel de isolamento 'SERIALIZABLE'.
 * Isso porque, principalmente devido aos triggers que serao implementados para garantir a consistencia da base de dados, ela inclui muitas operacoes em varias tabelas diferentes, que podem acabar sofrendo anomalias.
 * Dessa forma, eh essencial que o nivel de isolamento 'SERIALIZABLE' seja usado para que as anomalias de leitura invalida, leitura nao repetivel e leitura fantasma sejam evitadas.
 * */


-- LETRA C: SAVEPOINTS E TRANSACOES AUTONOMAS
/* Nao sera necessario utilizar nenhuma transacao autonoma, pois todas as operacoes DML incluidas na transacao, incluindo as operacoes DML dos triggers, devem ser desfeitas caso a transacao em questao sofra ROLLBACK.
 * Por exemplo, nao faz sentido que o trigger que atualiza a quantidade de nacoes na tabela FACCAO seja efetivado se o DELETE da tabela NACAO_FACCAO sofrer ROLLBACK.
 * Tambem nao sera necessario utilizar nenhum savepoint, pois se a transacao sofrer um ROLLBACK, todas as operacoes incluidas nela deverao ser desfeitas.
 * Isso porque, apesar de a transacao em questao incluir muitas operacoes em varias tabelas diferentes, a maioria delas nao sao operacoes DML, pois elas sao usadas para atingir um unico objetivo: remover a faccao de uma nacao de forma consistente.
 * Assim, se esse objetivo nao for concluido, todas as operacoes deverao ser desfeitas, dispensando a necessidade da utilizacao de savepoints.
 * */