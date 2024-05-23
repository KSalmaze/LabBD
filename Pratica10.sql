/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
-- a)
/*
    A ideia inicial era fazer essa verificação quando uma nova federação fosse inserida,
    porém sempre que uma nova federação é inserida necessáriemte ela não vai estar associana a
    nenhuma nação.

    Explicar pq não vai ser perfeita, não importa a situação
*/
CREATE OR REPLACE TRIGGER Verficacao_Federacao
BEFORE INSERT ON Federacao

BEGIN
    
    DELETE FROM Federacao WHERE Nome IN (SELECT Nome FROM Federacao
                                            MINUS SELECT F.Nome FROM
                                            Federacao F JOIN Nacao N ON
                                            F.Nome = N.Federacao);
    
END;


-- b)
