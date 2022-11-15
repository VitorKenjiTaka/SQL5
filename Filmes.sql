CREATE DATABASE filmes
GO
USE filmes

GO
CREATE TABLE filme(
id			INT									NOT NULL,
titulo		VARCHAR(40)							NOT NULL,
ano			INT				CHECK(ano <= 2021)		NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE estrela(
id			INT					NOT NULL,
nome		VARCHAR(50)			NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE filmestrela(
idFilme		INT					NOT NULL,
idEstrela	INT					NOT NULL
FOREIGN KEY (idFilme)
	REFERENCES filme,
FOREIGN KEY (idEstrela)
	REFERENCES estrela
)
GO
CREATE TABLE dvd(
num					INT											NOT NULL,
dataFabricacao		DATE	CHECK(dataFabricacao < GETDATE())	NOT NULL,
idFilme				INT											NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (idFilme)
	REFERENCES filme
)
GO
CREATE TABLE cliente(
numCadastro		INT									NOT NULL,
nome			VARCHAR(70)							NOT NULL,
num				INT				CHECK(num > 0)		NOT NULL,
logradouro		VARCHAR(150)						NOT NULL,
cep				CHAR(8)			CHECK(LEN(cep) = 8)		NULL
PRIMARY KEY (numCadastro)
)
GO
CREATE TABLE locacao(
dataLocacao		DATE			DEFAULT(GETDATE())	NOT NULL,
dataDevolucao	DATE								NOT NULL,
valor			DECIMAL(7, 2)	CHECK(valor > 0)	NOT NULL,
numCliente		INT									NOT NULL,
numDvd			INT									NOT NULL
PRIMARY KEY (dataLocacao)
FOREIGN KEY (numDvd)
	REFERENCES dvd,
FOREIGN KEY (numCliente)
	REFERENCES cliente
)

GO
ALTER TABLE estrela
ADD		nomeReal		VARCHAR(50)			NULL

GO
ALTER TABLE filme
ALTER COLUMN	titulo			VARCHAR(80)		NOT NULL

SELECT * FROM filme
SELECT * FROM estrela
SELECT * FROM filmestrela
SELECT * FROM locacao
SELECT * FROM dvd
SELECT * FROM cliente


GO
INSERT INTO filme(id, titulo, ano)
VALUES	(1001, 'Whiplash', 2015),
		(1002, 'Birdman', 2015),
		(1003, 'Interestelar', 2014),
		(1004, 'A culpa é das estrelas', 2014),
		(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
		(1006, 'Sing', 2016)

GO
INSERT INTO estrela(id, nome, nomeReal)
VALUES	(9901, 'Michael Keaton', 'Michael John Douglas'),
		(9902, 'Emma Stone', 'Emily JEan Stone'),
		(9903, 'Miles Teller', null),
		(9904, 'Steve Carell', 'Steven John Carell'),
		(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

GO
INSERT INTO filmestrela(idFilme, idEstrela)
VALUES	(1002, 9901),
		(1002, 9902),
		(1001, 9903),
		(1005, 9904),
		(1005, 9905)

GO
INSERT INTO dvd(num, dataFabricacao, idFilme)
VALUES	(10001, '2020-12-02', 1001),
		(10002, '2020-12-02', 1002),
		(10003, '2020-12-02', 1003),
		(10004, '2020-12-02', 1001),
		(10005, '2020-12-02', 1004),
		(10006, '2020-12-02', 1002),
		(10007, '2020-12-02', 1005),
		(10008, '2020-12-02', 1002),
		(10009, '2020-12-02', 1003)

GO
INSERT INTO cliente(numCadastro, nome, logradouro, num, cep)
VALUES	(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
		(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
		(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, null),
		(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, null),
		(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

GO
INSERT INTO locacao(numDvd, numCliente, dataLocacao, dataDevolucao, valor)
VALUES	(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
		(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
		(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
		(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
		(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE numCadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE numCadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE dataLocacao = '2021-02-18'

UPDATE locacao
SET valor = 3.10
WHERE dataLocacao = '2021-02-24'

UPDATE dvd
SET dataFabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela
SET nomeReal = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

SELECT cl.numCadastro, cl.nome As Nome_Cliente, fi.titulo As Titulo_Filme, dv.dataFabricacao, 
		lo.valor As Valor_Locacao
FROM filme fi, cliente cl, dvd dv,locacao lo
WHERE fi.id = dv.idFilme
	AND dv.num = lo.numDvd
	AND cl.numCadastro = lo.numCliente
	AND dv.dataFabricacao = MAX(dv.dataFabricacao)

SELECT cl.numCadastro, cl.nome As Nome_Cliente, COUNT(cl.numCadastro)
FROM cliente cl, locacao lo, dvd dv
WHERE cl.numCadastro = lo.numCliente
	AND dv.num = lo.numDvd
GROUP BY cl.numCadastro

SELECT cl.numCadastro, cl.nome As Nome_Cliente, SUM(lo.valor) As Valor_Total
FROM cliente cl, locacao lo, dvd dv
WHERE cl.numCadastro = lo.numCliente
	AND dv.num = lo.numDvd
GROUP BY lo.dataLocacao

SELECT cl.numCadastro, cl.nome As Nome_Cliente, cl.logradouro + cl.num As Endereço, lo.dataLocacao
FROM cliente cl, locacao lo
WHERE cl.numCadastro =  lo.numCliente
	AND COUNT(lo.dataLocacao) > 2
GROUP BY cl.numCadastro