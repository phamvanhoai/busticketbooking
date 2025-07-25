USE [master]
GO
/****** Object:  Database [BusTicket]    Script Date: 15/06/2025 09:09:31 CH ******/
CREATE DATABASE [BusTicket]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'busticket', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\busticket.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'busticket_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\busticket_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BusTicket] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BusTicket].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BusTicket] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BusTicket] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BusTicket] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BusTicket] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BusTicket] SET ARITHABORT OFF 
GO
ALTER DATABASE [BusTicket] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BusTicket] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BusTicket] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BusTicket] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BusTicket] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BusTicket] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BusTicket] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BusTicket] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BusTicket] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BusTicket] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BusTicket] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BusTicket] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BusTicket] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BusTicket] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BusTicket] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BusTicket] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BusTicket] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BusTicket] SET RECOVERY FULL 
GO
ALTER DATABASE [BusTicket] SET  MULTI_USER 
GO
ALTER DATABASE [BusTicket] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BusTicket] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BusTicket] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BusTicket] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BusTicket] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BusTicket] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BusTicket', N'ON'
GO
ALTER DATABASE [BusTicket] SET QUERY_STORE = ON
GO
ALTER DATABASE [BusTicket] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BusTicket]
GO
/****** Object:  Table [dbo].[Bus_Driver]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bus_Driver](
	[bus_driver_id] [int] IDENTITY(1,1) NOT NULL,
	[bus_id] [int] NOT NULL,
	[driver_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[bus_driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bus_Type_Seat_Template]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bus_Type_Seat_Template](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bus_type_id] [int] NOT NULL,
	[seat_template_id] [int] NOT NULL,
	[is_active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bus_Types]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bus_Types](
	[bus_type_id] [int] IDENTITY(1,1) NOT NULL,
	[bus_type_name] [nvarchar](100) NOT NULL,
	[bus_type_description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[bus_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Buses]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Buses](
	[bus_id] [int] IDENTITY(1,1) NOT NULL,
	[plate_number] [nvarchar](20) NOT NULL,
	[capacity] [int] NOT NULL,
	[bus_status] [nvarchar](50) NULL,
	[bus_code] [nvarchar](50) NULL,
	[bus_type_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[bus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver_Trip_Change_Request]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver_Trip_Change_Request](
	[request_id] [int] IDENTITY(1,1) NOT NULL,
	[driver_id] [int] NOT NULL,
	[trip_id] [int] NOT NULL,
	[request_date] [datetime] NULL,
	[change_reason] [nvarchar](255) NULL,
	[request_status] [nvarchar](50) NULL,
	[approved_by_driver_id] [int] NULL,
	[approval_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Drivers]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drivers](
	[driver_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[license_number] [nvarchar](50) NULL,
	[license_class] [nvarchar](20) NULL,
	[hire_date] [date] NULL,
	[driver_status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Items]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Items](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_id] [int] NOT NULL,
	[ticket_id] [int] NOT NULL,
	[invoice_amount] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Taxes]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Taxes](
	[invoice_tax_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_id] [int] NOT NULL,
	[invoice_tax_type] [nvarchar](50) NOT NULL,
	[invoice_tax_percent] [decimal](5, 2) NOT NULL,
	[invoice_tax_amount] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[invoice_tax_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[invoice_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[invoice_total_amount] [float] NOT NULL,
	[payment_method] [nvarchar](50) NOT NULL,
	[paid_at] [datetime] NULL,
	[invoice_code] [varchar](20) NOT NULL,
	[invoice_full_name] [nvarchar](100) NULL,
	[invoice_email] [nvarchar](100) NULL,
	[invoice_phone] [nvarchar](20) NULL,
	[invoice_status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[location_id] [int] IDENTITY(1,1) NOT NULL,
	[location_name] [nvarchar](100) NOT NULL,
	[address] [nvarchar](255) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[location_type] [nvarchar](50) NULL,
	[location_description] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Password_Reset_Tokens]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Password_Reset_Tokens](
	[token_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[token] [varchar](255) NOT NULL,
	[token_created_at] [datetime] NULL,
	[token_expires_at] [datetime] NOT NULL,
	[token_used] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[token_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Route_Pricing]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Route_Pricing](
	[pricing_id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NULL,
	[price] [float] NOT NULL,
	[effective_from] [date] NOT NULL,
	[effective_to] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pricing_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Routes]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Routes](
	[route_id] [int] IDENTITY(1,1) NOT NULL,
	[start_location] [nvarchar](100) NULL,
	[end_location] [nvarchar](100) NULL,
	[distance_km] [float] NULL,
	[estimated_time] [nvarchar](50) NULL,
	[start_location_id] [int] NULL,
	[end_location_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[route_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seat_History]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seat_History](
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[ticket_id] [int] NOT NULL,
	[history_seat_number] [nvarchar](10) NOT NULL,
	[trip_id] [int] NOT NULL,
	[history_previous_status] [nvarchar](20) NOT NULL,
	[history_current_status] [nvarchar](20) NOT NULL,
	[history_changed_at] [datetime] NULL,
	[history_change_reason] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seat_Templates]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seat_Templates](
	[seat_template_id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](10) NOT NULL,
	[level] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[seat_template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ticket_Seat]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ticket_Seat](
	[ticket_seat_id] [int] IDENTITY(1,1) NOT NULL,
	[ticket_id] [int] NOT NULL,
	[seat_number] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_seat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tickets](
	[ticket_id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NULL,
	[user_id] [int] NULL,
	[ticket_status] [nvarchar](20) NULL,
	[check_in] [datetime] NULL,
	[check_out] [datetime] NULL,
	[ticket_code] [varchar](20) NULL,
	[pickup_location_id] [int] NULL,
	[dropoff_location_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trip_Bus]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trip_Bus](
	[trip_bus_id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[bus_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_bus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trip_Driver]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trip_Driver](
	[trip_driver_id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[driver_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trips]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trips](
	[trip_id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NULL,
	[bus_id] [int] NULL,
	[driver_id] [int] NULL,
	[departure_time] [datetime] NULL,
	[trip_status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 15/06/2025 09:09:31 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](100) NULL,
	[user_email] [nvarchar](100) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[user_phone] [nvarchar](20) NULL,
	[role] [nvarchar](20) NOT NULL,
	[birthdate] [date] NULL,
	[gender] [nvarchar](10) NULL,
	[user_address] [nvarchar](255) NULL,
	[user_created_at] [datetime] NULL,
	[user_status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bus_Driver] ON 

INSERT [dbo].[Bus_Driver] ([bus_driver_id], [bus_id], [driver_id]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [dbo].[Bus_Driver] OFF
GO
SET IDENTITY_INSERT [dbo].[Bus_Type_Seat_Template] ON 

INSERT [dbo].[Bus_Type_Seat_Template] ([id], [bus_type_id], [seat_template_id], [is_active]) VALUES (1, 1, 1, 1)
SET IDENTITY_INSERT [dbo].[Bus_Type_Seat_Template] OFF
GO
SET IDENTITY_INSERT [dbo].[Bus_Types] ON 

INSERT [dbo].[Bus_Types] ([bus_type_id], [bus_type_name], [bus_type_description]) VALUES (1, N'Luxury', N'High-end bus with extra amenities')
INSERT [dbo].[Bus_Types] ([bus_type_id], [bus_type_name], [bus_type_description]) VALUES (2, N'Standard', N'Standard bus with basic facilities')
SET IDENTITY_INSERT [dbo].[Bus_Types] OFF
GO
SET IDENTITY_INSERT [dbo].[Buses] ON 

INSERT [dbo].[Buses] ([bus_id], [plate_number], [capacity], [bus_status], [bus_code], [bus_type_id]) VALUES (1, N'51B-12345', 40, N'Active', N'BUS001', 1)
INSERT [dbo].[Buses] ([bus_id], [plate_number], [capacity], [bus_status], [bus_code], [bus_type_id]) VALUES (2, N'51B-54321', 30, N'Inactive', N'BUS002', 2)
SET IDENTITY_INSERT [dbo].[Buses] OFF
GO
SET IDENTITY_INSERT [dbo].[Drivers] ON 

INSERT [dbo].[Drivers] ([driver_id], [user_id], [license_number], [license_class], [hire_date], [driver_status]) VALUES (1, 2, N'DL123456', N'B2', CAST(N'2020-01-10' AS Date), N'Active')
SET IDENTITY_INSERT [dbo].[Drivers] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Items] ON 

INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (1, 1, 1, 500000)
SET IDENTITY_INSERT [dbo].[Invoice_Items] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Taxes] ON 

INSERT [dbo].[Invoice_Taxes] ([invoice_tax_id], [invoice_id], [invoice_tax_type], [invoice_tax_percent], [invoice_tax_amount]) VALUES (1, 1, N'VAT', CAST(10.00 AS Decimal(5, 2)), CAST(50000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Invoice_Taxes] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoices] ON 

INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (1, 1, 500000, N'Credit Card', CAST(N'2025-06-10T17:00:13.640' AS DateTime), N'INV001', N'Nguyen Thi Lan', N'lan@example.com', N'0123456789', N'Paid')
SET IDENTITY_INSERT [dbo].[Invoices] OFF
GO
SET IDENTITY_INSERT [dbo].[Locations] ON 

INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description]) VALUES (1, N'Hanoi', N'Hanoi, Vietnam', 21.0285, 105.8542, N'City', N'Capital city of Vietnam')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description]) VALUES (2, N'Ho Chi Minh City', N'Ho Chi Minh City, Vietnam', 10.8231, 106.6297, N'City', N'Largest city in Vietnam')
SET IDENTITY_INSERT [dbo].[Locations] OFF
GO
SET IDENTITY_INSERT [dbo].[Password_Reset_Tokens] ON 

INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (1, 1, N'abcdef123456', CAST(N'2025-06-10T17:04:39.847' AS DateTime), CAST(N'2025-06-15T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (2, 6, N'fadd138e-564b-4dac-a0b6-446e9b0ef29f', CAST(N'2025-06-12T01:28:27.537' AS DateTime), CAST(N'2025-06-12T02:28:27.537' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (3, 6, N'db10297d-79ff-42c3-a824-70ef5bc34633', CAST(N'2025-06-12T01:31:41.893' AS DateTime), CAST(N'2025-06-12T02:31:41.893' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (4, 6, N'ebbb6804-94c3-415d-a687-0e821b643e08', CAST(N'2025-06-12T01:43:06.243' AS DateTime), CAST(N'2025-06-12T02:43:06.243' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (5, 6, N'602f33a9-8408-4bab-b9a0-70120811c664', CAST(N'2025-06-12T01:44:31.773' AS DateTime), CAST(N'2025-06-12T02:44:31.773' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (6, 6, N'55ceee12-0618-47cf-9446-5649a3083727', CAST(N'2025-06-12T01:46:50.797' AS DateTime), CAST(N'2025-06-12T02:46:50.797' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (7, 6, N'0fa2bd6b-8d2a-49c0-b9c3-c27e51b620ae', CAST(N'2025-06-12T02:14:37.263' AS DateTime), CAST(N'2025-06-12T03:14:37.263' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (8, 6, N'14ce07ee-28d8-4c14-a074-c64fbed35c0d', CAST(N'2025-06-12T02:22:55.053' AS DateTime), CAST(N'2025-06-12T03:22:55.053' AS DateTime), 1)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (9, 6, N'048b2dce-98b8-45b1-8a1e-399eaa7b3a5d', CAST(N'2025-06-12T13:55:39.423' AS DateTime), CAST(N'2025-06-12T14:55:39.423' AS DateTime), 1)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (10, 6, N'd55cbb46-721e-47c7-b88b-05af7ef6f87c', CAST(N'2025-06-12T14:28:46.907' AS DateTime), CAST(N'2025-06-12T15:28:46.907' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (11, 6, N'6456f522-6f2d-4c58-941f-c2d4c704e409', CAST(N'2025-06-12T14:31:02.920' AS DateTime), CAST(N'2025-06-12T15:31:02.920' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (12, 6, N'c88e2b32-7ebc-4fae-b8f9-77ffae6b1de9', CAST(N'2025-06-12T14:33:12.883' AS DateTime), CAST(N'2025-06-12T15:33:12.883' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (13, 6, N'da63e33b-38f5-42b7-8d3c-164734258212', CAST(N'2025-06-12T14:33:40.950' AS DateTime), CAST(N'2025-06-12T15:33:40.950' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (14, 6, N'a549557e-98c7-4ced-951d-2f9c377dc3f4', CAST(N'2025-06-12T14:35:06.197' AS DateTime), CAST(N'2025-06-12T15:35:06.197' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (15, 6, N'93fa8ac8-0b68-4a6c-b50e-ee4562002810', CAST(N'2025-06-12T14:40:23.617' AS DateTime), CAST(N'2025-06-12T15:40:23.617' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (16, 6, N'abec3bdc-c230-47ae-ba13-90239d9af3b8', CAST(N'2025-06-12T14:40:48.827' AS DateTime), CAST(N'2025-06-12T15:40:48.827' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (17, 6, N'825f1beb-dc87-4429-ba58-84a29c742b42', CAST(N'2025-06-12T14:52:18.927' AS DateTime), CAST(N'2025-06-12T15:52:18.927' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (18, 6, N'595113a6-4a37-4117-8a1d-d11be5a13846', CAST(N'2025-06-12T23:52:47.013' AS DateTime), CAST(N'2025-06-13T00:52:47.013' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (19, 6, N'7a727387-5735-48b9-866c-55111861a9cc', CAST(N'2025-06-13T21:07:34.970' AS DateTime), CAST(N'2025-06-13T22:07:34.970' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Password_Reset_Tokens] OFF
GO
SET IDENTITY_INSERT [dbo].[Route_Pricing] ON 

INSERT [dbo].[Route_Pricing] ([pricing_id], [route_id], [price], [effective_from], [effective_to]) VALUES (1, 1, 500000, CAST(N'2025-06-01' AS Date), CAST(N'2025-06-30' AS Date))
SET IDENTITY_INSERT [dbo].[Route_Pricing] OFF
GO
SET IDENTITY_INSERT [dbo].[Routes] ON 

INSERT [dbo].[Routes] ([route_id], [start_location], [end_location], [distance_km], [estimated_time], [start_location_id], [end_location_id]) VALUES (1, N'Hanoi', N'Ho Chi Minh City', 1700, N'24 hours', 1, 2)
SET IDENTITY_INSERT [dbo].[Routes] OFF
GO
SET IDENTITY_INSERT [dbo].[Seat_Templates] ON 

INSERT [dbo].[Seat_Templates] ([seat_template_id], [code], [level]) VALUES (1, N'STD', N'Lower')
INSERT [dbo].[Seat_Templates] ([seat_template_id], [code], [level]) VALUES (2, N'VIP', N'Upper')
SET IDENTITY_INSERT [dbo].[Seat_Templates] OFF
GO
SET IDENTITY_INSERT [dbo].[Ticket_Seat] ON 

INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (1, 1, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (2, 1, N'A2')
SET IDENTITY_INSERT [dbo].[Ticket_Seat] OFF
GO
SET IDENTITY_INSERT [dbo].[Tickets] ON 

INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (1, 1, 1, N'Booked', CAST(N'2025-06-10T07:30:00.000' AS DateTime), CAST(N'2025-06-10T18:00:00.000' AS DateTime), N'TICKET001', 1, 2)
SET IDENTITY_INSERT [dbo].[Tickets] OFF
GO
SET IDENTITY_INSERT [dbo].[Trip_Bus] ON 

INSERT [dbo].[Trip_Bus] ([trip_bus_id], [trip_id], [bus_id]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [dbo].[Trip_Bus] OFF
GO
SET IDENTITY_INSERT [dbo].[Trip_Driver] ON 

INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [dbo].[Trip_Driver] OFF
GO
SET IDENTITY_INSERT [dbo].[Trips] ON 

INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [driver_id], [departure_time], [trip_status]) VALUES (1, 1, 1, 1, CAST(N'2025-06-10T08:00:00.000' AS DateTime), N'Scheduled')
SET IDENTITY_INSERT [dbo].[Trips] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (1, N'Nguyen Thi Lan', N'lan@example.com', N'password123', N'0123456789', N'Customer', CAST(N'1990-05-15' AS Date), N'Female', N'123 ABC Street, Hanoi', CAST(N'2025-06-10T16:44:44.483' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (2, N'Tran Minh Tu', N'tu@example.com', N'password456', N'0987654321', N'Customer', CAST(N'1985-08-25' AS Date), N'Male', N'456 XYZ Avenue, Ho Chi Minh City', CAST(N'2025-06-10T16:44:44.483' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (3, N'Le Dang Khoa', N'KhoaLOL@fpt.edu.vn', N'123', N'011111111', N'Customer', CAST(N'2005-05-11' AS Date), N'Female', N'Vinh Chau, ST', CAST(N'2025-06-10T23:25:01.420' AS DateTime), N'Inactive')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (4, N'KHOA', N'khoald@gmail.com', N'123', N'0987654321', N'Customer', CAST(N'2025-06-14' AS Date), N'Male', N'1', CAST(N'2025-06-11T00:47:22.630' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (5, N'ADMIN', N'admin@gmail.com', N'$2a$12$oCiLAP4xXcXCISA/u5O0HupabDG7bA3yRN1HHFpXyg.gVEZIo/d2W', N'1234', N'Admin', CAST(N'2025-06-08' AS Date), N'Female', N'st', CAST(N'2025-06-11T23:27:45.573' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (6, N'HOAIPV', N'phamvanhoai600@gmail.com', N'$2a$12$53ucJaVZgJ0qbd57R0lSlOSce95rrnjIIoNEZgiDpTmUEJDLzX4OO', N'0987654321', N'Admin', CAST(N'2025-06-01' AS Date), N'Male', N'1', CAST(N'2025-06-12T00:37:25.880' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (7, N'HOAIPV', N'H@gmail.com', N'$2a$12$O5NnFYq2KnRI4vCfV5Wbqe3x9.mjaY04plBdpNYkdHlIvVPNKDKEW', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:16:43.390' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (8, N'A', N'D@gmail.com', N'$2a$12$miYXfk5aS9MUZmHzdOpsMe2vfQ4ldqGmuMJ6md.60wdppivN5Ymrm', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:17:42.130' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (9, N'SFDFSD', N'SDFDSF@gmail.com', N'$2a$12$aZGikAQ43TDNiMbq8sGsc./pSf8mPzwOqFVP0D7dYr3wNyOAvFlAO', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:19:08.997' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (10, N'CXZ', N'ZXCXZC@gmail.com', N'$2a$12$ltTqIk9fY5rAsH5ml58OBeIytEt9PCJLBptM0uTkB/2eWGhL..swa', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:19:50.887' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (11, N'SFÀA', N'XCBXCB@gmail.com', N'$2a$12$BiztC7YDu.rL/B/fA1F6Veqeu0Z.oKaoaMT0CzldW1enBx.dTuvPK', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:20:17.710' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (12, N'aZXVZXVXZ', N'XZVVXZ@gmail.com', N'$2a$12$glOJDuIYuWWQ4PzKXea9YeQeLG3IWi3owDWtAntjj6xAyPFSJYddm', N'', N'Customer', NULL, N'Male', N'', CAST(N'2025-06-12T03:20:38.687' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (13, N'Hoai Dep Jai', N'hoaiaz@gmail.com', N'$2a$12$XPViVuPdypWTXEzlKTd.7uaxXnnPFKJwbfS5lBpFodMg6DtUUnnpy', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T13:55:09.947' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (32, N'HOAI18', N'hoai18@gmail.com', N'$2a$12$fjwZEDubKbr66B16Wb/4aOPTF4cukSt21YgdGQ/p1khbIN3FiP4Fu', NULL, N'Admin', NULL, NULL, NULL, CAST(N'2025-06-14T14:39:41.917' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (33, N'KHOA KHUNG KHI ', N'aidi@gma-il.com', N'$2a$12$BPl.kKDQ1mie6zn1E0FX6.ngSvxJfTwzCd6p8wCPN5/Q51A.oxBiS', N'', N'Admin', CAST(N'2025-06-10' AS Date), N'Male', N'', CAST(N'2025-06-14T21:33:14.383' AS DateTime), N'Active')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [UQ__bus_driv__A08FE4B7F1FE932B]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Bus_Driver] ADD UNIQUE NONCLUSTERED 
(
	[bus_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__bus_type__F851B9B286C5F557]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD UNIQUE NONCLUSTERED 
(
	[bus_type_id] ASC,
	[seat_template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__bus_type__72E12F1BD3B7151F]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Bus_Types] ADD UNIQUE NONCLUSTERED 
(
	[bus_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__buses__87EF9F59A0ED9CC6]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Buses] ADD UNIQUE NONCLUSTERED 
(
	[plate_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__drivers__B9BE370EF9A1F126]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Drivers] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__invoice___D596F96AA9F0E7AD]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Invoice_Items] ADD UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__invoices__5ED70A35FEE3E556]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED 
(
	[invoice_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__password__CA90DA7AFE0B5EF0]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD UNIQUE NONCLUSTERED 
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ticket_s__CA9A40B1426FA802]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Ticket_Seat] ADD UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC,
	[seat_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tickets__628DB75F50293CAF]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Tickets] ADD UNIQUE NONCLUSTERED 
(
	[ticket_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__trip_bus__F686B211A807E2B9]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Trip_Bus] ADD UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[bus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__trip_dri__FA6B41C43EF47B92]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Trip_Driver] ADD UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E616406FE8407]    Script Date: 15/06/2025 09:09:31 CH ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[user_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] ADD  DEFAULT (getdate()) FOR [request_date]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] ADD  DEFAULT ('Pending') FOR [request_status]
GO
ALTER TABLE [dbo].[Drivers] ADD  DEFAULT ('Active') FOR [driver_status]
GO
ALTER TABLE [dbo].[Invoices] ADD  DEFAULT (getdate()) FOR [paid_at]
GO
ALTER TABLE [dbo].[Invoices] ADD  DEFAULT (N'Thanh toán thành công') FOR [invoice_status]
GO
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD  DEFAULT (getdate()) FOR [token_created_at]
GO
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD  DEFAULT ((0)) FOR [token_used]
GO
ALTER TABLE [dbo].[Seat_History] ADD  DEFAULT (getdate()) FOR [history_changed_at]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (left(CONVERT([varchar](36),newid()),(6))) FOR [ticket_code]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [user_created_at]
GO
ALTER TABLE [dbo].[Bus_Driver]  WITH CHECK ADD  CONSTRAINT [FK_bus_driver_bus] FOREIGN KEY([bus_id])
REFERENCES [dbo].[Buses] ([bus_id])
GO
ALTER TABLE [dbo].[Bus_Driver] CHECK CONSTRAINT [FK_bus_driver_bus]
GO
ALTER TABLE [dbo].[Bus_Driver]  WITH CHECK ADD  CONSTRAINT [FK_bus_driver_driver] FOREIGN KEY([driver_id])
REFERENCES [dbo].[Drivers] ([driver_id])
GO
ALTER TABLE [dbo].[Bus_Driver] CHECK CONSTRAINT [FK_bus_driver_driver]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template]  WITH CHECK ADD  CONSTRAINT [FK_btst_bus_type] FOREIGN KEY([bus_type_id])
REFERENCES [dbo].[Bus_Types] ([bus_type_id])
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] CHECK CONSTRAINT [FK_btst_bus_type]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template]  WITH CHECK ADD  CONSTRAINT [FK_btst_seat_template] FOREIGN KEY([seat_template_id])
REFERENCES [dbo].[Seat_Templates] ([seat_template_id])
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] CHECK CONSTRAINT [FK_btst_seat_template]
GO
ALTER TABLE [dbo].[Buses]  WITH CHECK ADD  CONSTRAINT [FK_buses_bus_type] FOREIGN KEY([bus_type_id])
REFERENCES [dbo].[Bus_Types] ([bus_type_id])
GO
ALTER TABLE [dbo].[Buses] CHECK CONSTRAINT [FK_buses_bus_type]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Trip_Change_Request_Driver] FOREIGN KEY([driver_id])
REFERENCES [dbo].[Drivers] ([driver_id])
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] CHECK CONSTRAINT [FK_Driver_Trip_Change_Request_Driver]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Trip_Change_Request_Trip] FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] CHECK CONSTRAINT [FK_Driver_Trip_Change_Request_Trip]
GO
ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Invoice_Items]  WITH CHECK ADD FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoices] ([invoice_id])
GO
ALTER TABLE [dbo].[Invoice_Items]  WITH CHECK ADD FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Invoice_Taxes]  WITH CHECK ADD  CONSTRAINT [FK_invoice_taxes_invoice] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoices] ([invoice_id])
GO
ALTER TABLE [dbo].[Invoice_Taxes] CHECK CONSTRAINT [FK_invoice_taxes_invoice]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Password_Reset_Tokens]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Route_Pricing]  WITH CHECK ADD FOREIGN KEY([route_id])
REFERENCES [dbo].[Routes] ([route_id])
GO
ALTER TABLE [dbo].[Routes]  WITH CHECK ADD  CONSTRAINT [FK_routes_end_location_id_locations] FOREIGN KEY([end_location_id])
REFERENCES [dbo].[Locations] ([location_id])
GO
ALTER TABLE [dbo].[Routes] CHECK CONSTRAINT [FK_routes_end_location_id_locations]
GO
ALTER TABLE [dbo].[Routes]  WITH CHECK ADD  CONSTRAINT [FK_routes_start_location_id_locations] FOREIGN KEY([start_location_id])
REFERENCES [dbo].[Locations] ([location_id])
GO
ALTER TABLE [dbo].[Routes] CHECK CONSTRAINT [FK_routes_start_location_id_locations]
GO
ALTER TABLE [dbo].[Seat_History]  WITH CHECK ADD  CONSTRAINT [FK_Seat_History_Ticket_Seat] FOREIGN KEY([ticket_id], [history_seat_number])
REFERENCES [dbo].[Ticket_Seat] ([ticket_id], [seat_number])
GO
ALTER TABLE [dbo].[Seat_History] CHECK CONSTRAINT [FK_Seat_History_Ticket_Seat]
GO
ALTER TABLE [dbo].[Seat_History]  WITH CHECK ADD  CONSTRAINT [FK_Seat_History_Tickets] FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Seat_History] CHECK CONSTRAINT [FK_Seat_History_Tickets]
GO
ALTER TABLE [dbo].[Seat_History]  WITH CHECK ADD  CONSTRAINT [FK_Seat_History_Trips] FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Seat_History] CHECK CONSTRAINT [FK_Seat_History_Trips]
GO
ALTER TABLE [dbo].[Ticket_Seat]  WITH CHECK ADD  CONSTRAINT [FK_ticket_seat_ticket] FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Ticket_Seat] CHECK CONSTRAINT [FK_ticket_seat_ticket]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_tickets_dropoff_location_id_locations] FOREIGN KEY([dropoff_location_id])
REFERENCES [dbo].[Locations] ([location_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_tickets_dropoff_location_id_locations]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_tickets_pickup_location_id_locations] FOREIGN KEY([pickup_location_id])
REFERENCES [dbo].[Locations] ([location_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_tickets_pickup_location_id_locations]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Trips] FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_Trips]
GO
ALTER TABLE [dbo].[Trip_Bus]  WITH CHECK ADD  CONSTRAINT [FK_trip_bus_bus] FOREIGN KEY([bus_id])
REFERENCES [dbo].[Buses] ([bus_id])
GO
ALTER TABLE [dbo].[Trip_Bus] CHECK CONSTRAINT [FK_trip_bus_bus]
GO
ALTER TABLE [dbo].[Trip_Bus]  WITH CHECK ADD  CONSTRAINT [FK_trip_bus_trip] FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Trip_Bus] CHECK CONSTRAINT [FK_trip_bus_trip]
GO
ALTER TABLE [dbo].[Trip_Driver]  WITH CHECK ADD  CONSTRAINT [FK_trip_driver_driver] FOREIGN KEY([driver_id])
REFERENCES [dbo].[Drivers] ([driver_id])
GO
ALTER TABLE [dbo].[Trip_Driver] CHECK CONSTRAINT [FK_trip_driver_driver]
GO
ALTER TABLE [dbo].[Trip_Driver]  WITH CHECK ADD  CONSTRAINT [FK_trip_driver_trip] FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Trip_Driver] CHECK CONSTRAINT [FK_trip_driver_trip]
GO
ALTER TABLE [dbo].[Trips]  WITH CHECK ADD FOREIGN KEY([route_id])
REFERENCES [dbo].[Routes] ([route_id])
GO
ALTER TABLE [dbo].[Seat_Templates]  WITH CHECK ADD CHECK  (([level]='Lower' OR [level]='Upper'))
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [CK__tickets__ticket_status] CHECK  (([ticket_status]='Completed' OR [ticket_status]='Cancelled' OR [ticket_status]='Booked'))
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [CK__tickets__ticket_status]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([gender]='Other' OR [gender]='Female' OR [gender]='Male'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([role]='Guest' OR [role]='Customer' OR [role]='Driver' OR [role]='Admin'))
GO
USE [master]
GO
ALTER DATABASE [BusTicket] SET  READ_WRITE 
GO
