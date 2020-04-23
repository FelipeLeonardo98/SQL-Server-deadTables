-- Opening database 'imperio'
use imperio;
-- Creating Table 'usuario'
	CREATE TABLE usuario(
		id int PRIMARY KEY IDENTITY (1,1),
		nome varchar(100) not null,
		email varchar(100) not null UNIQUE,
		senha varchar(100) not null,
		permissao char(1) CHECK(permissao='P' OR permissao='A') DEFAULT 'P' NOT NULL
	);

-- Creating Procedure for Insert
	GO
	CREATE PROCEDURE sp_insertUsuarioCriptografado
		@nome varchar(100),
		@email varchar(100),
		@senha varchar(100),
		@permissao char(1)
	AS
		BEGIN TRY
			INSERT INTO usuario (nome, email, senha, permissao)
			VALUES				(@nome, @email,HASHBYTES('MD5', @senha), @permissao);
			-- function hashBytes for Criptography
			PRINT  'REGISTERED WITH SUCESS !';
		END TRY
		BEGIN CATCH
			PRINT 'AN ERROR HAs BEEN OCURRED!';
			PRINT CONCAT('CONTACT SUPPORT, ERROR: ', ' ' , ERROR_NUMBER(), ' ' , ERROR_PROCEDURE());
		END CATCH;
	

-- Creating Table 'usuarioDesativado'
	CREATE TABLE usuarioDesativado(
		id_antigo int PRIMARY KEY,
		nome varchar(100) not null,
		email varchar(100) not null UNIQUE,
		permissao char(1) CHECK(permissao='P' OR permissao='A') DEFAULT 'P' NOT NULL
	);

	
-- Creating Trigger trg_insertUsuarioDesativado
	GO
	CREATE TRIGGER trg_insertUsuarioDesativado
	ON usuario
	AFTER DELETE
	AS
		BEGIN
			INSERT into usuarioDesativado (id_antigo, nome, email, permissao)
			SELECT id, nome , email , permissao from deleted;
		END

-- Inserting into usuario
	GO
	EXEC sp_insertUsuarioCriptografado 'Bethania','bet@gmail.com','senhaaqui','P';
	EXEC sp_insertUsuarioCriptografado 'Beatriz','bia@gmail.com','senhaaqui','P';
	EXEC sp_insertUsuarioCriptografado 'Stefanie','ste@bool.com','passwordhere','A';
	EXEC sp_insertUsuarioCriptografado 'Junior','jr@dominio.com','password','P';
	EXEC sp_insertUsuarioCriptografado 'Juliana Ferreira','juferreira@gmail.com','senha','P';
	EXEC sp_insertUsuarioCriptografado 'Felipe','felipe@google.com','password','A';
	EXEC sp_insertUsuarioCriptografado 'Felipe Ferraz','ferraz@amazon.com','password','A';
	EXEC sp_insertUsuarioCriptografado 'Felipe Ferraz Leonardo','ferrazLeonardo@dominio.com','password','P';
	
	select * from usuario;
-- Deleting for test
	delete from usuario where nome = 'Juliana Ferreira';
-- Select the table 'usuarioDesativo'
	select * from usuarioDesativado;
-- 'Juliana Ferreira' into table usuarioDesativado

--Now, to return for table usuario
	GO
	CREATE TRIGGER trg_deleteDesativado
	ON usuarioDesativado
	AFTER DELETE
	AS
		BEGIN
			set identity_insert usuario on;
			-- turn on identity_insert from usuario for insert on primary key

			insert into usuario (id, nome, email, senha, permissao)
			SELECT id_antigo, nome, email,'senhaGenerica',permissao from deleted;
			
			set identity_insert usuario off;
			--turn off for return auto_increment automatically
		END

-- So, just test and test !

-- Deleting of usuario
	delete from usuario where nome = 'Felipe';

	select * from usuario;
	select * from usuarioDesativado;

-- Deleting of usuarioDesativado
	delete from usuarioDesativado where nome = 'Juliana Ferreira';

	select * from usuario;
	select * from usuarioDesativado;