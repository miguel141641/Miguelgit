CREATE OR ALTER PROCEDURE usp_ImportFotoTrabajador (
    @NombreArchivo NVARCHAR(100),
    @RutaCarpeta NVARCHAR(1000),
    @CODTrabajador INT, 
    @NombreTabla NVARCHAR(100) = 'dbo.Trabajador',
    @NombreColumna NVARCHAR(100) = 'Foto'
)
AS
BEGIN
    DECLARE @RutaCompleta NVARCHAR(2000);
    DECLARE @tsql NVARCHAR(MAX);
    SET NOCOUNT ON;

    SET @RutaCompleta = CONCAT(
        @RutaCarpeta,
        '\',
        @NombreArchivo
    );

   SET @tsql = N'UPDATE ' + @NombreTabla + ' SET ' + @NombreColumna + ' = (SELECT * FROM Openrowset(Bulk ''' + @RutaCompleta + ''', Single_Blob) as img) WHERE CODTrabajador = @CODTrabajador';

    EXEC sp_executesql @tsql, N'@CODTrabajador int', @CODTrabajador;
    SET NOCOUNT OFF;
END
GO

EXEC usp_ImportFotoTrabajador 'trabajador.jpg', 'C:\imagenes\entrada\', 3, 'dbo.Trabajador', 'Foto';
