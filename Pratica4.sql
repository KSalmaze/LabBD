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
    
*/