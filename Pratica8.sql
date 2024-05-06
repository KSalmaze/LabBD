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

SELECT F.Nome, D.Planeta, C.nome FROM
    Faccao F JOIN Nacao_Faccao NF ON f.nome = nf.faccao
    JOIN NACAO N ON nf.nacao = n.nome
    JOIN DOMINANCIA D ON d.nacao = n.nome
    JOIN Habitacao H ON h.planeta = d.planeta
    JOIN Comunidade C ON c.especie = h.especie AND c.nome = h.comunidade;