CREATE OR ALTER PROCEDURE usp_ExportFotoTrabajador (
    @CODTrabajador INT,
    @ImageFolderPath NVARCHAR(1000),
    @Filename NVARCHAR(1000),
    @FormatoSalida NVARCHAR(10) = 'jpg' 
)
AS
BEGIN
    DECLARE @ImageData VARBINARY(MAX);
    DECLARE @Path2OutFile NVARCHAR(2000);
    DECLARE @Obj INT

    SET NOCOUNT ON

    SELECT @ImageData = Foto
    FROM Trabajador
    WHERE CODTrabajador = @CODTrabajador;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún trabajador con el ID especificado.', 16, 1);
        RETURN;
    END

    SET @Path2OutFile = CONCAT(@ImageFolderPath, '\', @Filename, '.', @FormatoSalida);

    BEGIN TRY
        EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
        EXEC sp_OASetProperty @Obj ,'Type',1;
        EXEC sp_OAMethod @Obj,'Open';
        EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
        EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
        EXEC sp_OAMethod @Obj,'Close';
        EXEC sp_OADestroy @Obj;
        PRINT 'Foto exportada correctamente.';
    END TRY
    BEGIN CATCH
        EXEC sp_OADestroy @Obj;
        PRINT 'Error al exportar la foto: ' + ERROR_MESSAGE();
    END CATCH

    SET NOCOUNT OFF
END
GO

EXEC usp_ExportFotoTrabajador 3, 'C:\imagenes\salida\', 'trabajador3', 'jpg';










USE Acuamar