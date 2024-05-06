/*
    Pedro Henrique Salmaze - 13783714
    Daniela Cristina Bogni - 11218577
*/

-- 1)
SELECT Comunidade.*
    FROM Comunidade
    JOIN Habitacao ON Comunidade.Especie = Habitacao.Especie AND Comunidade.Nome = Habitacao.NomeEspecie
    JOIN Dominancia ON Habitacao.Planeta = Dominancia.Planeta
    JOIN NacaoFaccao ON Dominancia.Nacao = NacaoFaccao.Nacao
    WHERE NacaoFaccao.Faccao = v_faccao
      AND NOT EXISTS (
        SELECT 1
        FROM Participa
        WHERE Participa.Especie = Comunidade.Especie AND Participa.NomeEspecie = Comunidade.Nome AND Participa.Faccao = v_faccao
      );
