 -- Pedro Henrique Salmaze - 13783714
 -- Daniela Cristina Bogni - 11218577

 --2)
 -- b)

 CREATE index idx_classificacao 
 ON planeta (classificacao);
 /*
  Escolhemnos indice para acessar direto o atributo classificação e evitar acessso sequancial
 */

-- c)
/*
SEM INDEX
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    59 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     1 |    59 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CLASSIFICACAO"='Confirmed')


COM INDEX
---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |    59 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA           |     1 |    59 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASSIFICACAO |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CLASSIFICACAO"='Confirmed')


    Com o indice o custo de acesso a tabela e o tempo de CPU são menor, pois o acesso não é mais sequêncial
*/

--3)
-- a)
/*

A principal diferença se deve ao fato de que ao utilizar UPPER o sistema precisa percorrer todas os dados da "nação" para
que seja comparados, enquanto sem a utilização da mesma a busca é direta. 
    
*/

-- b)
CREATE INDEX idx_upper_nome ON nacao (UPPER(nome));

/*
Devido ao fato do indice ter sido criado na coluna upper(nome), o banco pode usar esse índice para
localizar rapidamente as linhas que correspondem ao valor especificado.
*/

/*
c)

SEM INDEX
---------------------------------------------------------------------------
| Id  | Operation         | Name  | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |       |   498 | 14940 |    69   (2)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| NACAO |   498 | 14940 |    69   (2)| 00:00:01 |
---------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(UPPER("NOME")='MINUS MAGNI.')

COM INDEX

------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                |   498 | 14940 |    67   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| NACAO          |   498 | 14940 |    67   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_UPPER_NOME |   199 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access(UPPER("NOME")='MINUS MAGNI.')

As principais diferenças estão no uso da CPU e o acesso não é mais na tabela completa. 

*/

--4)
-- a)

/*
PRIMEIRA CONSULTA 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     6 |   354 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     6 |   354 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=10 AND "MASSA">=0.1)

SEGUNDA CONSULTA
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)

COM INDEX
PRIMEIRA CONSULTA
----------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                    |     6 |   354 |     9   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA            |     6 |   354 |     9   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | INDEX_MASS_PLANETA |     6 |       |     2   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("MASSA">=0.1 AND "MASSA"<=10)

SEGUNDA CONSULTA
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)
*/