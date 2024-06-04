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
FOR EACH ROW
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