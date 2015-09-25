/****** Object:  Table [dbo].[Custs]  ******/
SET ANSI_NULLS ON
;
SET QUOTED_IDENTIFIER ON
;
SET ANSI_PADDING ON
;
CREATE TABLE [dbo].[Custs](
    [ID] [int] NULL,
    [Name] [varchar](100) NULL,
    [Phone] [varchar](10) NULL
) ON [PRIMARY]
;
SET ANSI_PADDING OFF
;
/****** Object:  Table [dbo].[cust]  ******/
SET ANSI_NULLS ON
;
SET QUOTED_IDENTIFIER ON
;
CREATE TABLE [dbo].[cust](
    [id] [int] NOT NULL,
    [name] [nvarchar](50) NULL,
    [phone] [nvarchar](20) NULL,
    [using] [int] NULL,
 CONSTRAINT [PK_cust] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
;
/****** Object:  Table [dbo].[Orders] ******/
SET ANSI_NULLS ON
;
SET QUOTED_IDENTIFIER ON
;
CREATE TABLE [dbo].[Orders](
    [ID] [int] NULL,
    [CustID] [int] NULL,
    [OrderDate] [datetime] NULL
) ON [PRIMARY]
;
/****** Object:  Table [dbo].[Employee_Demo_Audit]  ******/
SET ANSI_NULLS ON
;
SET QUOTED_IDENTIFIER ON
;
SET ANSI_PADDING ON
;
CREATE TABLE [dbo].[Employee_Demo_Audit](
    [Emp_ID] [int] NULL,
    [Emp_Name] [varchar](55) NULL,
    [Emp_Sal] [decimal](10, 2) NULL,
    [Audit_Action] [varchar](100) NULL,
    [Audit_Timestamp] [datetime] NULL
) ON [PRIMARY]
;
SET ANSI_PADDING OFF
;
/****** Object:  Table [dbo].[Employee_Demo]  ******/
SET ANSI_NULLS ON
;
SET QUOTED_IDENTIFIER ON
;
SET ANSI_PADDING ON
;
CREATE TABLE [dbo].[Employee_Demo](
    [Emp_ID] [int] IDENTITY(1,1) NOT NULL,
    [Emp_Name] [varchar](55) NULL,
    [Emp_Sal] [decimal](10, 2) NULL,
    [audit_status] [bit] NULL
) ON [PRIMARY]
;
SET ANSI_PADDING OFF
;
