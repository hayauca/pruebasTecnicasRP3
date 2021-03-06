USE [Rp3Test]
GO
/****** Object:  User [rp3test]    Script Date: 23/03/2022 0:48:49 ******/
CREATE USER [rp3test] FOR LOGIN [rp3test] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[tbCategory]    Script Date: 23/03/2022 0:48:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbCategory](
	[CategoryId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_tbCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbTransaction]    Script Date: 23/03/2022 0:48:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbTransaction](
	[TransactionId] [int] NOT NULL,
	[TransactionTypeId] [smallint] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[RegisterDate] [datetime] NOT NULL,
	[ShortDescription] [varchar](100) NOT NULL,
	[Amount] [numeric](18, 6) NOT NULL,
	[Notes] [varchar](max) NULL,
	[DateUpdate] [datetime] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_tbTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbTransactionType]    Script Date: 23/03/2022 0:48:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbTransactionType](
	[TransactionTypeId] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tbTransactionType] PRIMARY KEY CLUSTERED 
(
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbUser]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Password] [varchar](8) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_tbUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_reporte]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_reporte] AS


select b.Name,

CASE
    WHEN a.TransactionTypeId=1 THEN   sum(a.Amount) 
   
 END as saldo

from [dbo].[tbTransaction] a
inner join [dbo].[tbCategory] b on b.categoryid=a.categoryid
where a.TransactionTypeId=1
group by b.Name,a.TransactionTypeId


union 


select b.Name,
CASE
   WHEN a.TransactionTypeId=2 THEN  -sum(a.Amount)  
 END as saldo

from [dbo].[tbTransaction] a
inner join [dbo].[tbCategory] b on b.categoryid=a.categoryid
where a.TransactionTypeId=2
group by b.Name,a.TransactionTypeId


--order by saldo desc


--union 

--select 'Total' as total,SUM(tmp.saldo) as saldo  from 
--(
--select b.Name,a.TransactionTypeId,

--CASE
--    WHEN a.TransactionTypeId=1 THEN   sum(a.Amount) 
--    WHEN a.TransactionTypeId=2 THEN  -sum(a.Amount)
-- END as saldo

--from [dbo].[tbTransaction] a
--inner join [dbo].[tbCategory] b on b.categoryid=a.categoryid

--group by b.Name,a.TransactionTypeId) as tmp


--order by saldo desc









--select * from [dbo].[tbTransactionType]
-- 1 ingresos positivo
--2 gastos negativo


--select *from [dbo].[tbCategory]
GO
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tbCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbCategory]
GO
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbTransactionType] FOREIGN KEY([TransactionTypeId])
REFERENCES [dbo].[tbTransactionType] ([TransactionTypeId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbTransactionType]
GO
ALTER TABLE [dbo].[tbTransaction]  WITH CHECK ADD  CONSTRAINT [FK_tbTransaction_tbUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[tbUser] ([UserId])
GO
ALTER TABLE [dbo].[tbTransaction] CHECK CONSTRAINT [FK_tbTransaction_tbUser]
GO
/****** Object:  StoredProcedure [dbo].[FillRandomData]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FillRandomData]
AS

TRUNCATE TABLE dbo.tbTransaction;

DECLARE @FechaInicial DATETIME;
DECLARE @FechaFinal DATETIME;

DECLARE @FechaProceso DATETIME;
DECLARE @CategoryId INT;
DECLARE @TypeId INT;
DECLARE @Description VARCHAR(500);

SET @FechaInicial = DATEADD(DAY, -30, GETDATE());
SET @FechaFinal = GETDATE() - 1;

SET @FechaProceso = @FechaInicial;

DECLARE @Amount MONEY;

DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT;

DECLARE @Id INT;
SET @Id = 1;

DECLARE @Contador INT;
DECLARE @Limite INT;

SET @Contador = 0;
SET @Limite = 30;

WHILE (@Contador < @Limite)
BEGIN

    ---- This will create a random number between 1 and 999
    SET @Lower = 1; ---- The lowest random number
    SET @Upper = 10; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower), 0);

    SET @CategoryId = @Random;

    SELECT @Description = Name + ' del ' + CONVERT(VARCHAR, GETDATE(), 103)
    FROM dbo.tbCategory
    WHERE CategoryId = @CategoryId;

    SET @Lower = 100; ---- The lowest random number
    SET @Upper = 200; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower) / 100, 0);

    SET @TypeId = @Random;


    SET @Lower = 2; ---- The lowest random number
    SET @Upper = 100; ---- The highest random number
    SELECT @Random = ROUND(((@Upper - @Lower - 1) * RAND() + @Lower), 0);

    SET @Amount = @Random;

    DECLARE @Seconds INT = DATEDIFF(SECOND, @FechaInicial, @FechaFinal);
    SET @Random = ROUND(((@Seconds - 1) * RAND()), 0);

    SELECT @FechaProceso = DATEADD(SECOND, @Random, @FechaInicial);


	IF @CategoryId = 6
	BEGIN
		SET @TypeId = 1
		SET @Amount = @Amount * 5
	END
	ELSE
		SET @TypeId = 2


    INSERT INTO dbo.tbTransaction
    (
        TransactionId,
        TransactionTypeId,
        CategoryId,
        RegisterDate,
        ShortDescription,
        Amount,
        Notes
    )
    VALUES
    (   @Id,           -- TransactionId - int
        @TypeId,       -- TransactionTypeId - smallint
        @CategoryId,   -- CategoryId - int
        @FechaProceso, -- RegisterDate - datetime
        @Description,  -- ShortDescription - varchar(100)
        @Amount,       -- Amount - numeric(18, 6)
        NULL);

    SET @Id = @Id + 1;
    SET @Contador = @Contador + 1;

END;

GO
/****** Object:  StoredProcedure [dbo].[GetBalance]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetBalance]
(
@userId int
)
AS


select b.Name,

CASE
    WHEN a.TransactionTypeId=1 THEN   sum(a.Amount) 
   
 END as saldo

from [dbo].[tbTransaction] a
inner join [dbo].[tbCategory] b on b.categoryid=a.categoryid
where a.TransactionTypeId=1
and a.UserId=@userId
group by b.Name,a.TransactionTypeId


union 


select b.Name,
CASE
   WHEN a.TransactionTypeId=2 THEN  -sum(a.Amount)  
 END as saldo

from [dbo].[tbTransaction] a
inner join [dbo].[tbCategory] b on b.categoryid=a.categoryid
where a.TransactionTypeId=2
and a.UserId=@userId
group by b.Name,a.TransactionTypeId

order by saldo desc







GO
/****** Object:  StoredProcedure [dbo].[spTransactionInsert]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTransactionInsert]
--@infoXml XML

 (@TransactionTypeId    int,
 @CategoryId     int,
 @RegisterDate        datetime,
 @ShortDescription          VARCHAR(100),
 @Amount numeric(18,6),
 @Notes varchar(max),
 @UserId int )
AS
BEGIN


INSERT INTO tbTransaction
                        (
						 TransactionTypeId ,   
                         CategoryId ,
                         RegisterDate        ,
                         ShortDescription  ,
                         Amount ,
                         Notes ,
                         UserId 						 
						 )
            VALUES     ( 
			              @TransactionTypeId  ,
                          @CategoryId  ,
                          @RegisterDate  ,
                          @ShortDescription  ,
                          @Amount ,
                          @Notes ,
                          @UserId  
						 
						 )
	/*
	Complete the code for Insert to dbo.tbTransaction Table

	Code XML SELECT EXAMPLE:

	SELECT 
	TransactionId = T.info.value('@ TransactionId','int'),
	TransactionTypeId = T.info.value('@ TransactionTypeId','smallint'),
	CategoryId = T.info.value('@ CategoryId','int'),
	RegisterDate = T.info.value('@ RegisterDate','datetime'),
	ShortDescription = T.info.value('@ ShortDescription','varchar(100)'),
	Notes = T.info.value('@ Notes','varchar(max)')
    FROM    @infoXml.nodes('Transaction')
                        AS T ( info ); 
	*/

	--RETURN 0;

END

GO
/****** Object:  StoredProcedure [dbo].[spTransactionUpdate]    Script Date: 23/03/2022 0:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTransactionUpdate]
--@infoXml XML
(
 @TransactionId    int,
 @TransactionTypeId    int,
 @CategoryId     int,
 @RegisterDate        datetime,
 @ShortDescription          VARCHAR(100),
 @Amount numeric(18,6),
 @Notes varchar(max),
 @UserId int 
 )
AS
BEGIN


UPDATE tbTransaction
            SET    TransactionTypeId = @TransactionTypeId,
                   CategoryId = @CategoryId,
                   RegisterDate = @RegisterDate,
                   ShortDescription = @ShortDescription,
				   Amount=@Amount,
				   Notes=@Notes,
				   UserId=@UserId
            WHERE  @TransactionId = @TransactionId
	
	/*
	Complete the code for Update to dbo.tbTransaction Table

	Code XML SELECT EXAMPLE:

	SELECT 
	TransactionId = T.info.value('@ TransactionId','int'),
	TransactionTypeId = T.info.value('@ TransactionTypeId','smallint'),
	CategoryId = T.info.value('@ CategoryId','int'),
	RegisterDate = T.info.value('@ RegisterDate','datetime'),
	ShortDescription = T.info.value('@ ShortDescription','varchar(100)'),
	Notes = T.info.value('@ Notes','varchar(max)')
    FROM    @infoXml.nodes('Transaction')
                        AS T ( info ); 
	*/
	
END

GO
