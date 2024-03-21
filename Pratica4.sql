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
-- b)
CREATE INDEX index_mass_planeta ON planeta (massa); 
-- Escolhemos esse índice porque as consultas envolvem uma faixa de valores na coluna "massa" 
-- e, assim, o banco pode rapidamente identificar quais linhas na tabela "planeta" possuem valores de massa dentro do intervalo requisitado

-- c)
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

   Podemos observar que o index só é utilizado com o range de intervalo é menor, pois, com o intervalo muito grande
   vale mais a pena percorrer a tabela toda. 
   Foi possível observer, através das tabelas, a redução de custo/cpu apenas para o intervalo de 0.1 e 10 justamente pelo
   fato explicitado.
*/

--5)
-- a)

--b)
CREATE BITMAP INDEX index_inteligente ON especie(inteligente);
/*
COM INDEX
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='F')

SEM INDEX
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')


O index não foi usado pois, a quantidade de V e F é são basicamente iguais, e não valeria a pena utiliza-lo, e sim 
fazer a consulta na tabela toda. 
V = 24940
F = 25054

Diante o cenário encontrado, as vantagens de utilizarmos o index é que há flexibilidade para consultas futuras, 
ou seja, se em algum momento o número de V ou F aumentar. Outro ponto que podemos citar como vantagem é a eficiencia
para consultas combinadas, uma vez que o bitmap pode fazer a interseção entre esses filtros, mesmo que a consulta
de V e F não seja otimizada. 

Em contrapartida, temos que entre as desvantagens temos: custo de inserção, atualização e manutenção e, também, 
o uso ineficiente de recursos.
*/

--6)
--a)

CREATE INDEX index_classificacao_massa ON estrela(classificacao, massa);
/*
SEM INDEX
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     6 |   276 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     6 |   276 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CLASSIFICACAO"='M3' OR "MASSA"<1)

COM INDEX
-----------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name                      | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                           |     1 |    46 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ESTRELA                   |     1 |    46 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | INDEX_CLASSIFICACAO_MASSA |     1 |       |     2   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CLASSIFICACAO"='M3' AND "MASSA"<1)
*/

-- b)

/*
b.1) select * from estrela where classificacao = 'M3' or massa < 1
o indice não é utilizado pois o "OR" implica que terá que ser acessada toda a base de dados de qualquer forma.

b.2)select * from estrela where classificacao = 'M3'
O indice é utilzado pois classificação é o atributo principal do index.

b.3)select * from estrela where massa < 1;
O indice não é utilizado pois teria que acessar cada classificação e suas respectivas massas,
e, portanto, acessa a tabela toda e dessa forma não vale a pena utilizar o index.


*/

