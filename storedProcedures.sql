USE [BD2]
GO
/****** Object:  StoredProcedure [dbo].[RegistroUsuario]    Script Date: 5/03/2022 22:08:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RegistroUsuario]
	-- Add the parameters for the stored procedure here
	@Firstname NVARCHAR(MAX),
	@Lastname NVARCHAR(MAX),
	@Email NVARCHAR(MAX),
	@Password NVARCHAR(MAX),
	@Credits int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY 
		BEGIN TRAN 
		--************AQUÍ COMIENZA LA TRANSACCION*************
		--INI REGISTRO DE USUARIO--
		DECLARE @emailExist int
		--declare @id UNIQUEIDENTIFIER 
		--SET @id=NEWID()
		SET @emailExist= IIF((SELECT Email FROM practica1.Usuarios WHERE Email=@Email) IS NULL,0,1)
		
		IF (@emailExist<>0)
		BEGIN 
			GOTO ExisteEmail
		END 
		INSERT INTO practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password,LastChanges, EmailConfirmed)
		VALUES (NEWID(),@Firstname,@Lastname,@Email,GETDATE(),@Password,GETDATE(),0)
		--END REGISTRO DE USUARIO--
		--INI REGISTRO DE CREDITOS--
		INSERT INTO practica1.ProfileStudent(Id, UserId, Credits)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.ProfileStudent) IS NULL,1, (SELECT MAX(Id) FROM practica1.ProfileStudent)+1),(SELECT id FROM practica1.Usuarios WHERE Email=@Email), @Credits)
		--FIN REGISTRO DE CREDITOS--
		--INI REGISTRO DE ROL--
		INSERT INTO practica1.UsuarioRole(Id,RoleId,UserId,IsLatestVersion)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.UsuarioRole) IS NULL,1, (SELECT MAX(Id) FROM practica1.UsuarioRole)+1),
		(SELECT id FROM practica1.Roles WHERE RoleName='Student'), 
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		1)
		--FIN REGISTRO DE ROL--
		--INI REGISTRO DE TFA--
		INSERT INTO practica1.TFA(Id,UserId,Status,LastUpdate)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.TFA) IS NULL,1, (SELECT MAX(Id) FROM practica1.TFA)+1),
		(SELECT id FROM practica1.Roles WHERE RoleName='Student'), 
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		1)
		--FIN REGISTRO DE TFA--
		--INI REGISTRO DE NOTIFICACION--
		INSERT INTO practica1.Notification(Id,UserId,Message,Date)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.Notification) IS NULL,1, (SELECT MAX(Id) FROM practica1.Notification)+1),
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		'Nuevo registro, por favor confirmar el correo',
		GETDATE())
		--FIN REGISTRO DE NOTIFICACION--
		COMMIT TRAN	
	END TRY 

	BEGIN CATCH
		--*********HISTORY LOG**********--
		--********INI ERROR AL HISTORY LOG*****--
		
		--********END ERROR AL HISTORY LOG*****--

		ROLLBACK TRAN 
	END CATCH

	ExisteEmail: 
	BEGIN 
		ROLLBACK TRAN
		--**TODO: AGREGAR ACCIÓN A HISTORYLOG****---
		--INI REGISTRO DE NOTIFICACION--
		INSERT INTO practica1.Notification(Id,UserId,Message,Date)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.Notification) IS NULL,1, (SELECT MAX(Id) FROM practica1.Notification)+1),
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		'Nuevo intento de registro con correo existente',
		GETDATE())
		--FIN REGISTRO DE NOTIFICACION--
		PRINT 'Error, el email ya existe'
	END
END


--EXEC [dbo].[RegistroUsuario] 'DIEGO', 'NOJ', 'DIEGO@GMAIL.COM', '123', 25

USE [BD2]
GO
/****** Object:  StoredProcedure [dbo].[RegistroUsuario]    Script Date: 5/03/2022 22:08:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RegistroUsuario]
	-- Add the parameters for the stored procedure here
	@Firstname NVARCHAR(MAX),
	@Lastname NVARCHAR(MAX),
	@Email NVARCHAR(MAX),
	@Password NVARCHAR(MAX),
	@Credits int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY 
		BEGIN TRAN 
		--************AQUÍ COMIENZA LA TRANSACCION*************
		--INI REGISTRO DE USUARIO--
		DECLARE @emailExist int
		--declare @id UNIQUEIDENTIFIER 
		--SET @id=NEWID()
		SET @emailExist= IIF((SELECT Email FROM practica1.Usuarios WHERE Email=@Email) IS NULL,0,1)
		
		IF (@emailExist<>0)
		BEGIN 
			GOTO ExisteEmail
		END 
		INSERT INTO practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password,LastChanges, EmailConfirmed)
		VALUES (NEWID(),@Firstname,@Lastname,@Email,GETDATE(),@Password,GETDATE(),0)
		--END REGISTRO DE USUARIO--
		--INI REGISTRO DE CREDITOS--
		INSERT INTO practica1.ProfileStudent(Id, UserId, Credits)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.ProfileStudent) IS NULL,1, (SELECT MAX(Id) FROM practica1.ProfileStudent)+1),(SELECT id FROM practica1.Usuarios WHERE Email=@Email), @Credits)
		--FIN REGISTRO DE CREDITOS--
		--INI REGISTRO DE ROL--
		INSERT INTO practica1.UsuarioRole(Id,RoleId,UserId,IsLatestVersion)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.UsuarioRole) IS NULL,1, (SELECT MAX(Id) FROM practica1.UsuarioRole)+1),
		(SELECT id FROM practica1.Roles WHERE RoleName='Student'), 
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		1)
		--FIN REGISTRO DE ROL--
		--INI REGISTRO DE TFA--
		INSERT INTO practica1.TFA(Id,UserId,Status,LastUpdate)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.TFA) IS NULL,1, (SELECT MAX(Id) FROM practica1.TFA)+1),
		(SELECT id FROM practica1.Roles WHERE RoleName='Student'), 
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		1)
		--FIN REGISTRO DE TFA--
		--INI REGISTRO DE NOTIFICACION--
		INSERT INTO practica1.Notification(Id,UserId,Message,Date)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.Notification) IS NULL,1, (SELECT MAX(Id) FROM practica1.Notification)+1),
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		'Nuevo registro, por favor confirmar el correo',
		GETDATE())
		--FIN REGISTRO DE NOTIFICACION--
		COMMIT TRAN	
	END TRY 

	BEGIN CATCH
		--*********HISTORY LOG**********--
		--********INI ERROR AL HISTORY LOG*****--
		
		--********END ERROR AL HISTORY LOG*****--

		ROLLBACK TRAN 
	END CATCH

	ExisteEmail: 
	BEGIN 
		ROLLBACK TRAN
		--**TODO: AGREGAR ACCIÓN A HISTORYLOG****---
		--INI REGISTRO DE NOTIFICACION--
		INSERT INTO practica1.Notification(Id,UserId,Message,Date)
		VALUES (IIF((SELECT MAX(Id) FROM practica1.Notification) IS NULL,1, (SELECT MAX(Id) FROM practica1.Notification)+1),
		(SELECT id FROM practica1.Usuarios WHERE Email=@Email),
		'Nuevo intento de registro con correo existente',
		GETDATE())
		--FIN REGISTRO DE NOTIFICACION--
		PRINT 'Error, el email ya existe'
	END
END


--EXEC [dbo].[RegistroUsuario] 'DIEGO', 'NOJ', 'DIEGO@GMAIL.COM', '123', 25