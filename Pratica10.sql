/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
-- a)
CREATE OR REPLACE TRIGGER Verficacao_Federacao
AFTER DELETE OR UPDATE ON Nacao

BEGIN
    
    DELETE FROM Federacao WHERE Nome IN (SELECT Nome FROM Federacao
                                            MINUS SELECT F.Nome FROM
                                            Federacao F JOIN Nacao N ON
                                            F.Nome = N.Federacao);
    
END; 