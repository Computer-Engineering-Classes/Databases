USE master
GO

CREATE DATABASE bd_banco_transacao
GO

USE bd_banco_transacao
GO

CREATE TABLE Contas(
   cod_conta INTEGER     NOT NULL,
   cliente   VARCHAR(50) NOT NULL,
   saldo     INTEGER     NOT NULL CHECK(saldo >= 0),
   PRIMARY KEY (cod_conta)
)

INSERT INTO Contas(cod_conta, cliente, saldo)
VALUES (1, 'António', 20)

INSERT INTO Contas(cod_conta, cliente, saldo)
VALUES (2, 'José', 0)

SELECT * FROM Contas
-- 1 com saldo=20; 2 com saldo=0

--###########################################################
--Errada

CREATE PROCEDURE transferencia
AS
   SET IMPLICIT_TRANSACTIONS OFF

   BEGIN TRANSACTION transfere

   UPDATE Contas
   SET saldo = saldo - 15
   WHERE cod_conta = 1

   IF (@@ERROR <> 0)
   BEGIN
      ROLLBACK TRANSACTION
   END

   UPDATE Contas
   SET saldo = saldo + 15
   WHERE cod_conta = 2

   IF (@@ERROR <> 0)
   BEGIN
      ROLLBACK TRANSACTION
   END

   COMMIT TRANSACTION
   
   RETURN 0

--###########################################################
--Correta

CREATE PROCEDURE transferencia2
AS
   SET IMPLICIT_TRANSACTIONS OFF

   BEGIN TRANSACTION transfere

   UPDATE Contas
   SET saldo = saldo - 15
   WHERE cod_conta = 1

   IF (@@ERROR <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      RETURN -1
   END

   UPDATE Contas
   SET saldo = saldo + 15
   WHERE cod_conta = 2

   IF (@@ERROR <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      RETURN -1
   END

   COMMIT TRANSACTION

   RETURN 0

--###########################################################

EXECUTE transferencia
SELECT * FROM Contas
-- 1 com saldo=5; 2 com saldo=15

EXECUTE transferencia
SELECT * FROM Contas
-- 1 com saldo=5; 2 com saldo=30

--###########################################################

DELETE FROM Contas

INSERT INTO Contas(cod_conta, cliente, saldo)
VALUES (1, 'António', 20)

INSERT INTO Contas(cod_conta, cliente, saldo)
VALUES (2, 'José', 0)

SELECT * FROM Contas
-- 1 com saldo=20; 2 com saldo=0

EXECUTE transferencia2
SELECT * FROM Contas
-- 1 com saldo=5; 2 com saldo=15

EXECUTE transferencia2
SELECT * FROM Contas
-- 1 com saldo=5; 2 com saldo=15