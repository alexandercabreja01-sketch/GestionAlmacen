CREATE DATABASE Almacen;
GO
USE Almacen;
GO

CREATE TABLE Productos (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  NVARCHAR(100)  NOT NULL,
    Precio  DECIMAL(18,2)  NOT NULL CONSTRAINT CK_Productos_Precio CHECK (Precio >= 0),
    Stock   INT            NOT NULL CONSTRAINT CK_Productos_Stock  CHECK (Stock  >= 0),
    Marca   NVARCHAR(100)  NOT NULL
);
GO

CREATE TABLE Usuarios (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
    Contrasena    VARCHAR(64)  NOT NULL,
    Rol           VARCHAR(20)  NOT NULL
        CONSTRAINT CK_Usuarios_Rol CHECK (Rol IN ('Administrador', 'Invitado'))
);
GO

INSERT INTO Usuarios (NombreUsuario, Contrasena, Rol) VALUES
('admin',    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'admin123'),    2), 'Administrador'),
('invitado', CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'invitado123'), 2), 'Invitado');
GO

CREATE PROCEDURE sp_Producto_Insertar
    @Nombre NVARCHAR(100), @Precio DECIMAL(18,2), @Stock INT, @Marca NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Productos (Nombre, Precio, Stock, Marca)
    VALUES (@Nombre, @Precio, @Stock, @Marca);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NuevoId;
END
GO

CREATE PROCEDURE sp_Producto_Actualizar
    @Id INT, @Nombre NVARCHAR(100), @Precio DECIMAL(18,2), @Stock INT, @Marca NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Productos
       SET Nombre = @Nombre, Precio = @Precio, Stock = @Stock, Marca = @Marca
     WHERE Id = @Id;
    SELECT @@ROWCOUNT AS Filas;
END
GO

CREATE PROCEDURE sp_Producto_Eliminar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Productos WHERE Id = @Id;
    SELECT @@ROWCOUNT AS Filas;
END
GO

CREATE PROCEDURE sp_Producto_Buscar
    @Codigo INT = NULL, @Nombre NVARCHAR(100) = NULL, @Marca NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, Precio, Stock, Marca
      FROM Productos
     WHERE (@Codigo IS NULL OR Id = @Codigo)
       AND (@Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%')
       AND (@Marca  IS NULL OR Marca  LIKE '%' + @Marca  + '%')
     ORDER BY Id;
END
GO

CREATE PROCEDURE sp_Usuario_Login
    @NombreUsuario NVARCHAR(50), @Contrasena VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NombreUsuario, Rol
      FROM Usuarios
     WHERE NombreUsuario = @NombreUsuario AND Contrasena = @Contrasena;
END
GO
