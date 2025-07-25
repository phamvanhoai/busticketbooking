USE [master]
GO
/****** Object:  Database [BusTicket]    Script Date: 24/07/2025 03:47:59 SA ******/
CREATE DATABASE [BusTicket]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BusTicket', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BusTicket.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BusTicket_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BusTicket_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  Table [dbo].[Bus_Driver]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Bus_Type_Seat_Template]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bus_Type_Seat_Template](
	[bus_type_seat_template_id] [int] IDENTITY(1,1) NOT NULL,
	[bus_type_id] [int] NOT NULL,
	[bus_type_seat_template_is_active] [bit] NULL,
	[bus_type_seat_template_zone] [nvarchar](5) NOT NULL,
	[bus_type_seat_template_row] [int] NOT NULL,
	[bus_type_seat_template_col] [int] NOT NULL,
	[bus_type_seat_template_order] [int] NOT NULL,
	[bus_type_seat_code] [nvarchar](10) NULL,
 CONSTRAINT [PK_BusTypeSeatTemplate] PRIMARY KEY CLUSTERED 
(
	[bus_type_seat_template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bus_Types]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bus_Types](
	[bus_type_id] [int] IDENTITY(1,1) NOT NULL,
	[bus_type_name] [nvarchar](100) NOT NULL,
	[bus_type_description] [nvarchar](255) NULL,
	[rowsDown] [int] NULL,
	[colsDown] [int] NULL,
	[prefixDown] [nvarchar](2) NULL,
	[rowsUp] [int] NULL,
	[colsUp] [int] NULL,
	[prefixUp] [nvarchar](2) NULL,
	[bus_type_seat_type] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[bus_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Buses]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Driver_Incidents]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver_Incidents](
	[incident_id] [int] IDENTITY(1,1) NOT NULL,
	[driver_id] [int] NOT NULL,
	[trip_id] [int] NULL,
	[incident_description] [nvarchar](500) NOT NULL,
	[incident_location] [nvarchar](255) NULL,
	[incident_photo_url] [nvarchar](255) NULL,
	[incident_type] [nvarchar](50) NULL,
	[incident_status] [nvarchar](50) NULL,
	[incident_created_at] [datetime] NULL,
	[incident_updated_at] [datetime] NULL,
	[incident_note] [nvarchar](max) NULL,
	[incident_support_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver_License_History]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver_License_History](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[old_license_class] [varchar](10) NOT NULL,
	[new_license_class] [varchar](10) NOT NULL,
	[changed_by] [int] NOT NULL,
	[changed_at] [datetime] NULL,
	[reason] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver_Trip_Change_Request]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Drivers]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Favorite_Routes]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favorite_Routes](
	[favorite_routes_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[route_id] [int] NOT NULL,
	[favorite_routes_created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[favorite_routes_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Cancel_Requests]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Cancel_Requests](
	[request_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[request_date] [datetime] NOT NULL,
	[cancel_reason] [nvarchar](255) NULL,
	[request_status] [nvarchar](20) NOT NULL,
	[approved_by_staff_id] [int] NULL,
	[approval_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Items]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Invoice_Reviews]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Reviews](
	[review_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_id] [int] NOT NULL,
	[review_rating] [tinyint] NOT NULL,
	[review_text] [nvarchar](1000) NULL,
	[review_created_at] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Taxes]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Invoices]    Script Date: 24/07/2025 03:47:59 SA ******/
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
	[invoice_phone] [varchar](255) NULL,
	[invoice_status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 24/07/2025 03:47:59 SA ******/
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
	[location_created_at] [datetime] NOT NULL,
	[location_status] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Password_Reset_Tokens]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Route_Prices]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Route_Prices](
	[route_price_id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NOT NULL,
	[bus_type_id] [int] NOT NULL,
	[route_price] [decimal](18, 2) NOT NULL,
	[route_price_effective_from] [date] NOT NULL,
	[route_price_effective_to] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[route_price_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Route_Stops]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Route_Stops](
	[route_stop_id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NOT NULL,
	[route_stop_number] [int] NOT NULL,
	[location_id] [int] NOT NULL,
	[route_stop_dwell_minutes] [int] NOT NULL,
	[travel_minutes] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[route_stop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Routes]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Routes](
	[route_id] [int] IDENTITY(1,1) NOT NULL,
	[distance_km] [float] NULL,
	[start_location_id] [int] NULL,
	[end_location_id] [int] NULL,
	[route_status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[route_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seat_History]    Script Date: 24/07/2025 03:47:59 SA ******/
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
	[invoice_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ticket_Seat]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Tickets]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Trip_Bus]    Script Date: 24/07/2025 03:47:59 SA ******/
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
/****** Object:  Table [dbo].[Trip_Driver]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trip_Driver](
	[trip_driver_id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[driver_id] [int] NOT NULL,
	[assigned_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trips]    Script Date: 24/07/2025 03:47:59 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trips](
	[trip_id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NULL,
	[bus_id] [int] NULL,
	[departure_time] [datetime] NULL,
	[trip_status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24/07/2025 03:47:59 SA ******/
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

INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (210, 13, 1, N'down', 1, 1, 1, N'A1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (211, 13, 1, N'down', 2, 1, 2, N'A3')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (212, 13, 1, N'down', 1, 3, 3, N'A2')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (213, 13, 1, N'down', 2, 2, 4, N'A4')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (214, 13, 1, N'down', 2, 3, 5, N'A5')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (215, 13, 1, N'down', 3, 1, 6, N'A6')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (216, 13, 1, N'down', 3, 2, 7, N'A7')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (217, 13, 1, N'down', 3, 3, 8, N'A8')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (218, 13, 1, N'down', 4, 1, 9, N'A9')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (219, 13, 1, N'down', 4, 2, 10, N'A10')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (220, 13, 1, N'down', 4, 3, 11, N'A11')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (221, 13, 1, N'down', 5, 1, 12, N'A12')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (222, 13, 1, N'down', 5, 2, 13, N'A13')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (223, 13, 1, N'down', 5, 3, 14, N'A14')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (224, 13, 1, N'down', 6, 1, 15, N'A15')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (225, 13, 1, N'down', 6, 2, 16, N'A16')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (226, 13, 1, N'down', 6, 3, 17, N'A17')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (227, 13, 1, N'up', 2, 2, 1, N'B4')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (228, 13, 1, N'up', 1, 1, 2, N'B1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (229, 13, 1, N'up', 1, 3, 3, N'B2')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (230, 13, 1, N'up', 2, 1, 4, N'B3')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (231, 13, 1, N'up', 2, 3, 5, N'B5')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (232, 13, 1, N'up', 3, 1, 6, N'B6')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (233, 13, 1, N'up', 3, 2, 7, N'B7')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (234, 13, 1, N'up', 3, 3, 8, N'B8')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (235, 13, 1, N'up', 4, 1, 9, N'B9')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (236, 13, 1, N'up', 4, 2, 10, N'B10')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (237, 13, 1, N'up', 4, 3, 11, N'B11')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (238, 13, 1, N'up', 5, 1, 12, N'B12')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (239, 13, 1, N'up', 5, 2, 13, N'B13')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (240, 13, 1, N'up', 5, 3, 14, N'B14')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (241, 13, 1, N'up', 6, 1, 15, N'B15')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (242, 13, 1, N'up', 6, 2, 16, N'B16')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (243, 13, 1, N'up', 6, 3, 17, N'B17')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (244, 2, 1, N'down', 1, 1, 1, N'A1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (245, 2, 1, N'down', 1, 2, 2, N'A2')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (246, 2, 1, N'down', 1, 3, 3, N'A3')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (247, 2, 1, N'down', 1, 4, 4, N'A4')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (248, 2, 1, N'down', 2, 1, 5, N'A5')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (249, 2, 1, N'down', 2, 2, 6, N'A6')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (250, 2, 1, N'down', 2, 3, 7, N'A7')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (251, 2, 1, N'down', 2, 4, 8, N'A8')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (252, 2, 1, N'down', 3, 1, 9, N'A9')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (253, 2, 1, N'down', 3, 2, 10, N'A10')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (254, 2, 1, N'down', 3, 3, 11, N'A11')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (255, 2, 1, N'down', 3, 4, 12, N'A12')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (256, 2, 1, N'down', 4, 1, 13, N'A13')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (257, 2, 1, N'down', 4, 2, 14, N'A14')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (258, 2, 1, N'down', 4, 3, 15, N'A15')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (259, 2, 1, N'down', 4, 4, 16, N'A16')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (260, 2, 1, N'down', 5, 1, 17, N'A17')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (261, 2, 1, N'down', 5, 2, 18, N'A18')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (262, 2, 1, N'down', 5, 3, 19, N'A19')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (263, 2, 1, N'down', 5, 4, 20, N'A20')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (264, 2, 1, N'down', 6, 1, 21, N'A21')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (265, 2, 1, N'down', 6, 2, 22, N'A22')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (266, 2, 1, N'down', 6, 3, 23, N'A23')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (267, 2, 1, N'down', 6, 4, 24, N'A24')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (268, 2, 1, N'down', 7, 1, 25, N'A25')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (269, 2, 1, N'down', 7, 2, 26, N'A26')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (270, 2, 1, N'down', 7, 3, 27, N'A27')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (271, 2, 1, N'down', 7, 4, 28, N'A28')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (272, 2, 1, N'up', 1, 1, 1, N'B1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (273, 1, 1, N'down', 1, 1, 1, N'A1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (274, 1, 1, N'down', 2, 1, 2, N'A3')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (275, 1, 1, N'down', 1, 2, 3, N'A2')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (276, 1, 1, N'down', 3, 1, 4, N'A5')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (277, 1, 1, N'down', 2, 2, 5, N'A4')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (278, 1, 1, N'down', 3, 2, 6, N'A6')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (279, 1, 1, N'down', 4, 1, 7, N'A7')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (280, 1, 1, N'down', 4, 2, 8, N'A8')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (281, 1, 1, N'down', 5, 1, 9, N'A9')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (282, 1, 1, N'down', 5, 2, 10, N'A10')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (283, 1, 1, N'down', 6, 1, 11, N'A11')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (284, 1, 1, N'down', 6, 2, 12, N'A12')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (285, 1, 1, N'up', 1, 1, 1, N'B1')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (286, 1, 1, N'up', 1, 2, 2, N'B2')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (287, 1, 1, N'up', 2, 1, 3, N'B3')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (288, 1, 1, N'up', 2, 2, 4, N'B4')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (289, 1, 1, N'up', 3, 1, 5, N'B5')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (290, 1, 1, N'up', 3, 2, 6, N'B6')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (291, 1, 1, N'up', 4, 1, 7, N'B7')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (292, 1, 1, N'up', 4, 2, 8, N'B8')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (293, 1, 1, N'up', 5, 1, 9, N'B9')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (294, 1, 1, N'up', 5, 2, 10, N'B10')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (295, 1, 1, N'up', 6, 1, 11, N'B11')
INSERT [dbo].[Bus_Type_Seat_Template] ([bus_type_seat_template_id], [bus_type_id], [bus_type_seat_template_is_active], [bus_type_seat_template_zone], [bus_type_seat_template_row], [bus_type_seat_template_col], [bus_type_seat_template_order], [bus_type_seat_code]) VALUES (296, 1, 1, N'up', 6, 2, 12, N'B12')
SET IDENTITY_INSERT [dbo].[Bus_Type_Seat_Template] OFF
GO
SET IDENTITY_INSERT [dbo].[Bus_Types] ON 

INSERT [dbo].[Bus_Types] ([bus_type_id], [bus_type_name], [bus_type_description], [rowsDown], [colsDown], [prefixDown], [rowsUp], [colsUp], [prefixUp], [bus_type_seat_type]) VALUES (1, N'Luxury 24', N'High-end bus with extra amenities', 6, 2, N'A', 6, 2, N'B', N'Limousine')
INSERT [dbo].[Bus_Types] ([bus_type_id], [bus_type_name], [bus_type_description], [rowsDown], [colsDown], [prefixDown], [rowsUp], [colsUp], [prefixUp], [bus_type_seat_type]) VALUES (2, N'Standard', N'Standard bus with basic facilities', 7, 4, N'A', 0, 0, N'', N'Seat')
INSERT [dbo].[Bus_Types] ([bus_type_id], [bus_type_name], [bus_type_description], [rowsDown], [colsDown], [prefixDown], [rowsUp], [colsUp], [prefixUp], [bus_type_seat_type]) VALUES (13, N'Limousine 34', N'123', 6, 3, N'A', 6, 3, N'B', N'Limousine')
SET IDENTITY_INSERT [dbo].[Bus_Types] OFF
GO
SET IDENTITY_INSERT [dbo].[Buses] ON 

INSERT [dbo].[Buses] ([bus_id], [plate_number], [capacity], [bus_status], [bus_code], [bus_type_id]) VALUES (1, N'51B-12345', 24, N'Active', N'BUS001', 1)
INSERT [dbo].[Buses] ([bus_id], [plate_number], [capacity], [bus_status], [bus_code], [bus_type_id]) VALUES (2, N'51B-54321', 29, N'Active', N'BUS002', 2)
INSERT [dbo].[Buses] ([bus_id], [plate_number], [capacity], [bus_status], [bus_code], [bus_type_id]) VALUES (3, N'65B-1231', 34, N'Active', N'CT051', 13)
SET IDENTITY_INSERT [dbo].[Buses] OFF
GO
SET IDENTITY_INSERT [dbo].[Driver_Incidents] ON 

INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (1, 1, 13, N'cvx', N'4234532', NULL, N'Accident', N'Resolved', CAST(N'2025-07-24T00:58:38.937' AS DateTime), CAST(N'2025-07-24T02:16:20.883' AS DateTime), N'f', 1)
INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (2, 1, 13, N'fdsfds', N'4234532', N'/assets/images/uploads/6257642d-ff25-4584-bef0-97b34ece942a_6107413443482074756.jpg', N'Passenger Issue', N'Pending', CAST(N'2025-07-24T01:01:32.320' AS DateTime), CAST(N'2025-07-24T01:01:32.320' AS DateTime), NULL, NULL)
INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (3, 1, 13, N'test png', N'4234532', N'/assets/images/uploads/c1636dcb-c4f7-40b0-98f2-65b3ebb87a59_H2 REMIX.png', N'Passenger Issue', N'Pending', CAST(N'2025-07-24T01:04:12.267' AS DateTime), CAST(N'2025-07-24T01:04:12.267' AS DateTime), NULL, NULL)
INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (4, 1, 13, N'Test jpg', N'dssdf', N'/assets/images/uploads/516ecbeb-207d-4e93-b7eb-08bb518647cf__3911261f-c1f7-43c7-8c63-1cf813795905.jpg', N'Other', N'Pending', CAST(N'2025-07-24T01:21:31.643' AS DateTime), CAST(N'2025-07-24T01:21:31.643' AS DateTime), NULL, NULL)
INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (5, 1, 13, N'test cuối nè', N'cần thơ', N'/assets/images/uploads/bb4b5c1d-2ed2-44d1-b067-9d4bc3c5ef02_a9cac716ff72562c0f63.jpg', N'Breakdown', N'Pending', CAST(N'2025-07-24T02:52:59.233' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Driver_Incidents] ([incident_id], [driver_id], [trip_id], [incident_description], [incident_location], [incident_photo_url], [incident_type], [incident_status], [incident_created_at], [incident_updated_at], [incident_note], [incident_support_by]) VALUES (6, 1, 1, N'lỗi', N'cần thơ', N'/assets/images/uploads/ff76cb8b-bd9e-47a8-b54c-6f6e55524087_47a00f5337379e69c726.jpg', N'Breakdown', N'Escalated', CAST(N'2025-07-24T03:36:25.577' AS DateTime), CAST(N'2025-07-24T03:38:38.380' AS DateTime), N'ok', 5)
SET IDENTITY_INSERT [dbo].[Driver_Incidents] OFF
GO
SET IDENTITY_INSERT [dbo].[Driver_License_History] ON 

INSERT [dbo].[Driver_License_History] ([id], [user_id], [old_license_class], [new_license_class], [changed_by], [changed_at], [reason]) VALUES (1, 3, N'D', N'D2', 1, CAST(N'2025-07-14T18:02:44.417' AS DateTime), N'Update')
INSERT [dbo].[Driver_License_History] ([id], [user_id], [old_license_class], [new_license_class], [changed_by], [changed_at], [reason]) VALUES (3, 2, N'D2', N'D', 1, CAST(N'2025-07-17T00:37:24.540' AS DateTime), N'update')
SET IDENTITY_INSERT [dbo].[Driver_License_History] OFF
GO
SET IDENTITY_INSERT [dbo].[Driver_Trip_Change_Request] ON 

INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (1, 1, 1, CAST(N'2025-06-22T00:00:00.000' AS DateTime), N'benh', N'Rejected', NULL, CAST(N'2025-07-14T00:18:07.203' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (5, 1, 7, CAST(N'2025-07-14T01:30:16.190' AS DateTime), N'thích', N'Approved', NULL, CAST(N'2025-07-14T01:47:45.830' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (6, 1, 10, CAST(N'2025-07-14T01:48:49.380' AS DateTime), N'xcvxc', N'Rejected', NULL, CAST(N'2025-07-14T01:48:59.267' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (7, 1, 7, CAST(N'2025-07-14T01:55:35.393' AS DateTime), N'fxvnvncxncv', N'Approved', NULL, CAST(N'2025-07-14T01:55:52.793' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (8, 1, 10, CAST(N'2025-07-24T03:23:21.200' AS DateTime), N'bận', N'Rejected', NULL, CAST(N'2025-07-24T03:23:40.177' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (9, 1, 10, CAST(N'2025-07-24T03:27:04.193' AS DateTime), N'xvcxnb', N'Approved', NULL, CAST(N'2025-07-24T03:27:08.670' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (10, 1, 10, CAST(N'2025-07-24T03:34:13.590' AS DateTime), N',', N'Rejected', 5, CAST(N'2025-07-24T03:34:32.487' AS DateTime))
INSERT [dbo].[Driver_Trip_Change_Request] ([request_id], [driver_id], [trip_id], [request_date], [change_reason], [request_status], [approved_by_driver_id], [approval_date]) VALUES (11, 1, 10, CAST(N'2025-07-24T03:34:52.483' AS DateTime), N'ok', N'Approved', 5, CAST(N'2025-07-24T03:34:58.527' AS DateTime))
SET IDENTITY_INSERT [dbo].[Driver_Trip_Change_Request] OFF
GO
SET IDENTITY_INSERT [dbo].[Drivers] ON 

INSERT [dbo].[Drivers] ([driver_id], [user_id], [license_number], [license_class], [hire_date], [driver_status]) VALUES (1, 2, N'112233445566', N'D', CAST(N'2020-01-10' AS Date), N'Active')
INSERT [dbo].[Drivers] ([driver_id], [user_id], [license_number], [license_class], [hire_date], [driver_status]) VALUES (2, 3, N'123456789011', N'D2', CAST(N'2025-06-27' AS Date), N'Active')
SET IDENTITY_INSERT [dbo].[Drivers] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Cancel_Requests] ON 

INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (5, 3, 1, CAST(N'2025-06-24T14:51:01.693' AS DateTime), N'bệnh', N'Rejected', 5, CAST(N'2025-06-24T14:51:18.320' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (7, 7, 6, CAST(N'2025-07-14T17:59:35.067' AS DateTime), N'bị bệnh', N'Approved', 1, CAST(N'2025-07-14T19:57:11.243' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (17, 8, 6, CAST(N'2025-07-14T19:33:07.550' AS DateTime), N'fhd', N'Approved', 1, CAST(N'2025-07-14T20:05:37.870' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (18, 15, 6, CAST(N'2025-07-14T20:00:25.057' AS DateTime), N'sf', N'Approved', 1, CAST(N'2025-07-22T13:45:07.840' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (19, 22, 6, CAST(N'2025-07-22T13:46:29.467' AS DateTime), N'lí do cá nhận', N'Approved', 1, CAST(N'2025-07-22T13:46:40.580' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (20, 21, 6, CAST(N'2025-07-22T13:52:52.383' AS DateTime), N'x', N'Approved', 1, CAST(N'2025-07-22T13:53:20.233' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (21, 20, 6, CAST(N'2025-07-22T14:09:20.300' AS DateTime), N'cbxcb', N'Approved', 1, CAST(N'2025-07-22T14:09:35.760' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (22, 23, 6, CAST(N'2025-07-22T14:28:54.630' AS DateTime), N'return', N'Rejected', 1, CAST(N'2025-07-22T14:29:31.567' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (23, 24, 6, CAST(N'2025-07-22T14:29:01.360' AS DateTime), N'return', N'Approved', 1, CAST(N'2025-07-22T14:29:28.727' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (24, 25, 6, CAST(N'2025-07-22T14:29:07.007' AS DateTime), N'return', N'Approved', 1, CAST(N'2025-07-22T14:29:27.900' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (25, 26, 6, CAST(N'2025-07-22T14:29:12.620' AS DateTime), N'return', N'Approved', 1, CAST(N'2025-07-22T14:29:26.503' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (26, 27, 6, CAST(N'2025-07-24T03:13:36.133' AS DateTime), N'ok', N'Rejected', 1, CAST(N'2025-07-24T03:14:11.090' AS DateTime))
INSERT [dbo].[Invoice_Cancel_Requests] ([request_id], [invoice_id], [user_id], [request_date], [cancel_reason], [request_status], [approved_by_staff_id], [approval_date]) VALUES (27, 27, 6, CAST(N'2025-07-24T03:14:25.360' AS DateTime), N'ghjk', N'Approved', 1, CAST(N'2025-07-24T03:14:34.123' AS DateTime))
SET IDENTITY_INSERT [dbo].[Invoice_Cancel_Requests] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Items] ON 

INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (1, 1, 1, 500000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (4, 3, 2, 14000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (5, 7, 6, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (6, 8, 7, 735000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (7, 9, 8, 735000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (8, 11, 10, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (9, 12, 11, 735000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (10, 12, 12, 735000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (11, 12, 13, 735000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (12, 13, 14, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (13, 13, 15, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (14, 14, 16, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (15, 14, 17, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (16, 15, 18, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (17, 15, 19, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (18, 16, 20, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (19, 17, 21, 5555)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (20, 17, 22, 5555)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (21, 17, 23, 5555)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (22, 18, 24, 5555)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (23, 19, 25, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (24, 19, 26, 245000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (25, 20, 27, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (26, 20, 28, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (27, 21, 29, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (28, 22, 30, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (29, 22, 31, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (30, 23, 32, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (31, 23, 33, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (32, 24, 34, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (33, 24, 35, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (34, 25, 36, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (35, 26, 37, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (36, 27, 38, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (37, 28, 39, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (38, 28, 40, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (39, 29, 41, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (40, 30, 42, 175000)
INSERT [dbo].[Invoice_Items] ([item_id], [invoice_id], [ticket_id], [invoice_amount]) VALUES (41, 30, 43, 175000)
SET IDENTITY_INSERT [dbo].[Invoice_Items] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Reviews] ON 

INSERT [dbo].[Invoice_Reviews] ([review_id], [invoice_id], [review_rating], [review_text], [review_created_at]) VALUES (3, 1, 3, N'ok con dê', CAST(N'2025-07-14T12:54:08.470' AS DateTime))
INSERT [dbo].[Invoice_Reviews] ([review_id], [invoice_id], [review_rating], [review_text], [review_created_at]) VALUES (4, 9, 5, N'Xe đẹp, đi an toàn', CAST(N'2025-07-16T22:58:48.857' AS DateTime))
SET IDENTITY_INSERT [dbo].[Invoice_Reviews] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice_Taxes] ON 

INSERT [dbo].[Invoice_Taxes] ([invoice_tax_id], [invoice_id], [invoice_tax_type], [invoice_tax_percent], [invoice_tax_amount]) VALUES (1, 1, N'VAT', CAST(10.00 AS Decimal(5, 2)), CAST(50000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Invoice_Taxes] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoices] ON 

INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (1, 1, 500000, N'Credit Card', CAST(N'2025-06-10T17:00:13.640' AS DateTime), N'INV001', N'Nguyen Thi Lan', N'lan@example.com', N'0123456789', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (3, 1, 150000, N'Bank', CAST(N'2025-06-24T00:28:26.623' AS DateTime), N'INV002', N'Nguyen Van Phuc', N'lan@example.com', N'02222222', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (7, 6, 245000, N'FPTUPay', CAST(N'2025-07-14T17:22:25.860' AS DateTime), N'INV-88188254', NULL, NULL, NULL, N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (8, 6, 735000, N'FPTUPay', CAST(N'2025-07-14T17:49:03.040' AS DateTime), N'INV-47E02636', NULL, NULL, NULL, N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (9, 6, 735000, N'FPTUPay', CAST(N'2025-07-14T18:17:02.783' AS DateTime), N'INV-22149E3A', NULL, NULL, NULL, N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (11, 6, 245000, N'FPTUPay', CAST(N'2025-07-14T18:41:31.987' AS DateTime), N'INV-28C47AF2', N'Hoai', N'0233456789', N'ainzle@gmail.com', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (12, 6, 735000, N'FPTUPay', CAST(N'2025-07-14T18:51:34.590' AS DateTime), N'INV-4A363287', N'HOAIPV', N'0233456789', N'lan@example.com', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (13, 6, 490000, N'FPTUPay', CAST(N'2025-07-14T18:55:25.130' AS DateTime), N'INV-C8315793', N'Hoai sv', N'0987654333', N'333@gmail.com', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (14, 6, 490000, N'FPTUPay', CAST(N'2025-07-14T18:57:33.973' AS DateTime), N'INV-2B01C8C4', N'sgdgg', N'0323523532', N'333@gmail.com', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (15, 6, 490000, N'FPTUPay', CAST(N'2025-07-14T19:02:22.960' AS DateTime), N'INV-78E80D41', N'Hoaixvcx', N'0323523144', N'fdgdgdf@gmail.com', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (16, 6, 245000, N'FPTUPay', CAST(N'2025-07-14T23:48:51.220' AS DateTime), N'INV-8AA89171', N'Test', N'0323523144', N'phamvanhoai600@gmail.com', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (17, 6, 16665, N'FPTUPay', CAST(N'2025-07-15T00:42:58.787' AS DateTime), N'INV-4762955E', N'Pham Van Hoai', N'admin@gmail.com', N'0914873283', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (18, 6, 5555, N'FPTUPay', CAST(N'2025-07-15T00:44:47.517' AS DateTime), N'INV-674C0EB5', N'Hoai', N'lan@example.com', N'0914873283', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (19, 6, 490000, N'FPTUPay', CAST(N'2025-07-15T00:58:30.100' AS DateTime), N'INV-4A0342DE', N'Hoai sv', N'tu@example.com', N'0323523144', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (20, 6, 350000, N'FPTUPay', CAST(N'2025-07-15T01:01:44.803' AS DateTime), N'INV-BCACF8DA', N'Test new', N'lan@example.com', N'0323523532', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (21, 6, 175000, N'FPTUPay', CAST(N'2025-07-15T12:54:36.337' AS DateTime), N'INV-D4B9FB3D', N'Trần Văn A', N'phamvanhoai600@gmail.com', N'0914873283', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (22, 6, 350000, N'FPTUPay', CAST(N'2025-07-15T16:33:04.267' AS DateTime), N'INV-58CAB207', N'Hoai', N'phamvanhoai600@gmail.com', N'0914873283', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (23, 6, 350000, N'FPTUPay', CAST(N'2025-07-22T14:11:37.310' AS DateTime), N'INVE966551F', N'Test Book vé đã hủy', N'phamvanhoai600@gmail.com', N'0233456789', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (24, 6, 350000, N'FPTUPay', CAST(N'2025-07-22T14:17:44.203' AS DateTime), N'INV39037FC8', N'Nguyen Thanh A', N'phamvanhoai600@gmail.com', N'0987654333', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (25, 6, 175000, N'FPTUPay', CAST(N'2025-07-22T14:24:45.210' AS DateTime), N'INV85650B10', N'Test payment', N'phamvanhofsfs@gmail.com', N'0233456789', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (26, 6, 175000, N'FPTUPay', CAST(N'2025-07-22T14:27:02.843' AS DateTime), N'INVA083C2DD', N'test pay', N'cxbcb@gmail.com', N'0233456789', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (27, 6, 175000, N'FPTUPay', CAST(N'2025-07-22T14:28:13.667' AS DateTime), N'INV0EDC4D7A', N'fbdcbx', N'vcb@v.vn', N'0323523144', N'Cancelled')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (28, 6, 350000, N'FPTUPay', CAST(N'2025-07-22T16:59:25.740' AS DateTime), N'INV4D87D889', N'Hoai Dang Code', N'phamvanhoai600@gmail.com', N'0323523532', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (29, 6, 175000, N'FPTUPay', CAST(N'2025-07-22T22:40:48.570' AS DateTime), N'INV149FDC62', N'Hoai sv', N'tu@example.com', N'0987654333', N'Paid')
INSERT [dbo].[Invoices] ([invoice_id], [user_id], [invoice_total_amount], [payment_method], [paid_at], [invoice_code], [invoice_full_name], [invoice_email], [invoice_phone], [invoice_status]) VALUES (30, 6, 350000, N'FPTUPay', CAST(N'2025-07-24T03:13:02.593' AS DateTime), N'INV4B1D6EB4', N'Phạm Văn Hoài', N'hoaipvce181744@fpt.edu.vn', N'0394024151', N'Paid')
SET IDENTITY_INSERT [dbo].[Invoices] OFF
GO
SET IDENTITY_INSERT [dbo].[Locations] ON 

INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (1, N'Hà Nội', N'Mỹ Đình, Nam Từ Liêm, Hà Nội, Việt Nam', 21.028469, 105.777296, N'Bus Terminal', N'Bến Xe Mỹ Đình', CAST(N'2025-06-20T14:15:16.673' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (2, N'TP Hồ Chí Minh', N'395 Đ. Kinh Dương Vương, An Lạc, Bình Tân, Hồ Chí Minh 700000, Việt Nam', 10.740972, 106.618881, N'Bus Terminal', N'Bến xe Miền Tây', CAST(N'2025-06-20T14:15:16.673' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (3, N'Cần Thơ', N'2Q4F+74R, Đường dẫn cầu Cần Thơ, QL1A, Hưng Thành, Cái Răng, Cần Thơ, Việt Nam', 10.005964797967224, 105.77308072571536, N'Bus Terminal', N'Bến Xe Trung Tâm Cần Thơ', CAST(N'2025-06-20T14:15:16.673' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (4, N'Ngã Năm', N'HJ55+VJP, TT. Ngã Năm, tx. Ngã Năm, Sóc Trăng, Việt Nam', 9.559734, 105.609072, N'Bus Terminal', N'Bến xe khách Ngã Năm', CAST(N'2025-06-20T15:06:03.583' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (5, N'Đà Lạt', N'1 Đường Tô Hiến Thành, Phường 3, Đà Lạt, Lâm Đồng, Việt Nam', 11.926957071219411, 108.44577399375216, N'Bus Terminal', N'Bến xe Liên tỉnh Đà Lạt', CAST(N'2025-06-20T15:07:06.200' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (6, N'Cà Mau', N'Phường 6, Tp. Cà Mau, Cà Mau, Việt Nam', 9.1758318744532623, 105.17129567064556, N'Bus Terminal', N'Bến Xe Khách Cà Mau', CAST(N'2025-06-20T15:07:50.510' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (12, N'Sóc Trăng', N'Lê Văn Tám, Phường 3, Tp. Sóc Trăng, Sóc Trăng, Việt Nam', 9.59389327794539, 105.97174569581793, N'Bus Terminal', N'Bến xe Sóc Trăng', CAST(N'2025-06-21T03:08:13.680' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (13, N'Hậu Giang', N'Hậu Giang', 9.775547, 105.461454, N'City', N'Hậu Giang', CAST(N'2025-06-21T17:25:42.740' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (14, N'Bạc Liêu', N'522 Trần Phú, Phường 7, Bạc Liêu, Việt Nam', 9.3030136625305069, 105.72035104120556, N'Bus Terminal', N'Bến Xe Bạc Liêu', CAST(N'2025-06-26T16:00:10.123' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (16, N'test', N'Phuong 6, Tp. Ca Mau, Ca Mau', 10.8231, 106.6297, N'City', N'', CAST(N'2025-07-22T17:24:59.760' AS DateTime), N'Active')
INSERT [dbo].[Locations] ([location_id], [location_name], [address], [latitude], [longitude], [location_type], [location_description], [location_created_at], [location_status]) VALUES (17, N'Long An', N'Bến Lức, Tỉnh Long An', 10.625517, 106.478806, N'City', N'', CAST(N'2025-07-24T03:40:56.827' AS DateTime), N'Active')
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
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (20, 6, N'3cb3c97d-f9b2-469c-b1d9-e3b38e6c5edd', CAST(N'2025-06-17T02:10:24.497' AS DateTime), CAST(N'2025-06-17T03:10:24.497' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (21, 6, N'187342fc-9973-418c-a88d-da950b73c317', CAST(N'2025-06-17T02:12:11.827' AS DateTime), CAST(N'2025-06-17T03:12:11.827' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (22, 6, N'f0bfe769-f959-4e9e-a1d3-0488fdd5e2d6', CAST(N'2025-06-17T02:12:53.627' AS DateTime), CAST(N'2025-06-17T03:12:53.627' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (23, 6, N'2baf2dc7-b3d0-4c05-8123-144ae82e52e2', CAST(N'2025-06-17T02:13:26.660' AS DateTime), CAST(N'2025-06-17T03:13:26.660' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (24, 6, N'8becea3d-3947-49f2-b347-7f579f4ed6b9', CAST(N'2025-06-17T02:19:51.447' AS DateTime), CAST(N'2025-06-17T03:19:51.447' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (25, 6, N'5a40d5a3-cbb6-44dd-8536-5e33fe3af416', CAST(N'2025-06-17T02:20:47.623' AS DateTime), CAST(N'2025-06-17T03:20:47.623' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (26, 6, N'beaa5bcc-9272-4c01-937e-90609a219dcc', CAST(N'2025-06-17T02:22:00.407' AS DateTime), CAST(N'2025-06-17T03:22:00.407' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (27, 6, N'62fedd5c-5247-4b1b-b13e-88c9042cd4ae', CAST(N'2025-06-17T02:23:00.523' AS DateTime), CAST(N'2025-06-17T03:23:00.523' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (28, 6, N'6ea72b57-93df-4aa1-b1df-8af8a5419df9', CAST(N'2025-06-17T02:24:03.157' AS DateTime), CAST(N'2025-06-17T03:24:03.157' AS DateTime), 0)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (29, 6, N'7a5ae043-6e3b-48f0-b220-1c55307fb4ab', CAST(N'2025-06-17T11:49:27.027' AS DateTime), CAST(N'2025-06-17T12:49:27.027' AS DateTime), 1)
INSERT [dbo].[Password_Reset_Tokens] ([token_id], [user_id], [token], [token_created_at], [token_expires_at], [token_used]) VALUES (30, 6, N'be7f3ec5-e4e6-4ccc-b325-ab34b1e46bdd', CAST(N'2025-07-24T03:18:42.630' AS DateTime), CAST(N'2025-07-24T04:18:42.630' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Password_Reset_Tokens] OFF
GO
SET IDENTITY_INSERT [dbo].[Route_Prices] ON 

INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (154, 54, 13, CAST(175000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (155, 54, 1, CAST(210000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (156, 54, 2, CAST(150000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (157, 53, 13, CAST(245000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (158, 53, 1, CAST(335000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (159, 53, 2, CAST(130000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (160, 52, 1, CAST(850000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (161, 52, 2, CAST(500000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (162, 52, 13, CAST(700000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (163, 48, 1, CAST(990000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (164, 48, 2, CAST(600000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (165, 48, 13, CAST(750000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (166, 3, 1, CAST(175000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (167, 3, 13, CAST(245000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (168, 3, 2, CAST(175000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (169, 2, 1, CAST(215000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (170, 2, 13, CAST(185000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (171, 2, 2, CAST(145000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (175, 1, 1, CAST(1500000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (176, 1, 2, CAST(990000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (177, 1, 13, CAST(1200000.00 AS Decimal(18, 2)), CAST(N'2025-07-15' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (179, 56, 13, CAST(125000.00 AS Decimal(18, 2)), CAST(N'2025-07-24' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (180, 56, 1, CAST(155000.00 AS Decimal(18, 2)), CAST(N'2025-07-24' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (181, 56, 2, CAST(90000.00 AS Decimal(18, 2)), CAST(N'2025-07-24' AS Date), NULL)
INSERT [dbo].[Route_Prices] ([route_price_id], [route_id], [bus_type_id], [route_price], [route_price_effective_from], [route_price_effective_to]) VALUES (182, 55, 13, CAST(5000000.00 AS Decimal(18, 2)), CAST(N'2025-07-24' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Route_Prices] OFF
GO
SET IDENTITY_INSERT [dbo].[Route_Stops] ON 

INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (186, 54, 1, 4, 5, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (187, 54, 2, 3, 5, 120)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (188, 54, 3, 2, 0, 120)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (189, 53, 1, 14, 0, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (190, 53, 2, 12, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (191, 53, 3, 3, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (192, 53, 4, 2, 0, 180)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (193, 52, 1, 5, 2, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (194, 52, 2, 4, 2, 120)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (195, 52, 3, 5, 2, 10)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (196, 52, 4, 12, 50, 1332)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (197, 48, 1, 5, 5, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (198, 48, 2, 4, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (199, 3, 1, 6, 5, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (200, 3, 2, 14, 5, 30)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (201, 3, 3, 12, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (202, 3, 4, 3, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (203, 3, 5, 2, 5, 120)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (204, 2, 1, 3, 5, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (205, 2, 2, 2, 0, 180)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (207, 1, 1, 1, 15, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (208, 1, 2, 2, 5, 2880)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (211, 56, 1, 12, 0, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (212, 56, 2, 13, 5, 60)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (213, 56, 3, 3, 0, 30)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (214, 55, 1, 12, 5, 0)
INSERT [dbo].[Route_Stops] ([route_stop_id], [route_id], [route_stop_number], [location_id], [route_stop_dwell_minutes], [travel_minutes]) VALUES (215, 55, 2, 16, 5, 120)
SET IDENTITY_INSERT [dbo].[Route_Stops] OFF
GO
SET IDENTITY_INSERT [dbo].[Routes] ON 

INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (1, 1700, 1, 2, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (2, 210, 3, 2, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (3, 295, 6, 2, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (30, 475, 6, 4, N'Inactive')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (48, 43, 6, 1, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (52, 54, 3, 13, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (53, 245, 14, 2, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (54, 145, 4, 2, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (55, 323, 12, 16, N'Active')
INSERT [dbo].[Routes] ([route_id], [distance_km], [start_location_id], [end_location_id], [route_status]) VALUES (56, 82, 12, 3, N'Active')
SET IDENTITY_INSERT [dbo].[Routes] OFF
GO
SET IDENTITY_INSERT [dbo].[Seat_History] ON 

INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (1, 7, N'B15', 9, N'Booked', N'Cancelled', CAST(N'2025-07-14T20:05:37.910' AS DateTime), N'Invoice Cancelled', 8)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (2, 7, N'B16', 9, N'Booked', N'Cancelled', CAST(N'2025-07-14T20:05:37.910' AS DateTime), N'Invoice Cancelled', 8)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (3, 7, N'B17', 9, N'Booked', N'Cancelled', CAST(N'2025-07-14T20:05:37.910' AS DateTime), N'Invoice Cancelled', 8)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (4, 18, N'B10', 9, N'Booked', N'Cancelled', CAST(N'2025-07-22T13:45:07.870' AS DateTime), N'Invoice Cancelled', 15)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (5, 19, N'B11', 9, N'Booked', N'Cancelled', CAST(N'2025-07-22T13:45:07.870' AS DateTime), N'Invoice Cancelled', 15)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (6, 30, N'A2', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T13:46:40.610' AS DateTime), N'Invoice Cancelled', 22)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (7, 31, N'A3', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T13:46:40.610' AS DateTime), N'Invoice Cancelled', 22)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (8, 29, N'A7', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T13:53:20.273' AS DateTime), N'Invoice Cancelled', 21)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (9, 27, N'A1', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:09:35.800' AS DateTime), N'Invoice Cancelled', 20)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (10, 28, N'A4', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:09:35.800' AS DateTime), N'Invoice Cancelled', 20)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (11, 37, N'B12', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:29:26.540' AS DateTime), N'Invoice Cancelled', 26)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (12, 36, N'A11', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:29:27.900' AS DateTime), N'Invoice Cancelled', 25)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (13, 34, N'B11', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:29:28.730' AS DateTime), N'Invoice Cancelled', 24)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (14, 35, N'B10', 12, N'Booked', N'Cancelled', CAST(N'2025-07-22T14:29:28.730' AS DateTime), N'Invoice Cancelled', 24)
INSERT [dbo].[Seat_History] ([history_id], [ticket_id], [history_seat_number], [trip_id], [history_previous_status], [history_current_status], [history_changed_at], [history_change_reason], [invoice_id]) VALUES (15, 38, N'A5', 12, N'Booked', N'Cancelled', CAST(N'2025-07-24T03:14:34.183' AS DateTime), N'Invoice Cancelled', 27)
SET IDENTITY_INSERT [dbo].[Seat_History] OFF
GO
SET IDENTITY_INSERT [dbo].[Ticket_Seat] ON 

INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (3, 1, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (5, 2, N'B7')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (7, 3, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (6, 3, N'A2')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (8, 4, N'B1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (9, 5, N'A5')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (10, 6, N'A3')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (11, 7, N'B15')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (12, 7, N'B16')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (13, 7, N'B17')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (14, 8, N'A15')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (15, 8, N'A16')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (16, 8, N'A17')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (17, 9, N'A4')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (18, 9, N'A7')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (19, 10, N'A6')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (20, 11, N'A14')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (21, 12, N'A13')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (22, 13, N'A12')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (23, 14, N'B12')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (24, 15, N'B13')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (25, 16, N'B2')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (26, 17, N'B5')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (27, 18, N'B10')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (28, 19, N'B11')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (29, 20, N'B4')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (30, 21, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (31, 22, N'A4')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (32, 23, N'A5')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (33, 24, N'B11')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (34, 25, N'B9')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (35, 26, N'B14')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (36, 27, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (37, 28, N'A4')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (38, 29, N'A7')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (39, 30, N'A2')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (40, 31, N'A3')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (41, 32, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (42, 33, N'A4')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (43, 34, N'B11')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (44, 35, N'B10')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (45, 36, N'A11')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (46, 37, N'B12')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (47, 38, N'A5')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (48, 39, N'B12')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (49, 40, N'B1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (50, 41, N'B11')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (51, 42, N'A1')
INSERT [dbo].[Ticket_Seat] ([ticket_seat_id], [ticket_id], [seat_number]) VALUES (52, 43, N'A28')
SET IDENTITY_INSERT [dbo].[Ticket_Seat] OFF
GO
SET IDENTITY_INSERT [dbo].[Tickets] ON 

INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (1, 1, 1, N'Booked', CAST(N'2025-07-15T16:36:17.763' AS DateTime), CAST(N'2025-07-15T16:36:17.833' AS DateTime), N'TICKET001', 1, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (2, 9, 1, N'Booked', CAST(N'2025-07-24T03:21:37.577' AS DateTime), NULL, N'TICKET002', 1, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (3, 9, 0, N'Booked', NULL, NULL, N'TKT7E5B2106', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (4, 9, 0, N'Booked', NULL, NULL, N'TKT3600BC3E', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (5, 9, 19, N'Booked', NULL, NULL, N'TKT47B25C94', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (6, 9, 19, N'Booked', NULL, NULL, N'TKTC5420987', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (7, 9, 19, N'Booked', NULL, NULL, N'TKTDB37095C', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (8, 9, 19, N'Booked', NULL, NULL, N'TKT4147B334', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (9, 9, 19, N'Booked', NULL, NULL, N'TKTF71C8FE0', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (10, 9, 19, N'Booked', NULL, NULL, N'TKT7A95B510', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (11, 9, 6, N'Booked', NULL, NULL, N'TKT304106E8', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (12, 9, 6, N'Booked', NULL, NULL, N'TKT99D01FA2', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (13, 9, 6, N'Booked', NULL, NULL, N'TKT00BD820F', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (14, 9, 6, N'Booked', NULL, NULL, N'TKTB43B9DB2', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (15, 9, 6, N'Booked', NULL, NULL, N'TKT8D0A8660', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (16, 9, 6, N'Booked', NULL, NULL, N'TKTB92E92AC', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (17, 9, 6, N'Booked', NULL, NULL, N'TKT9780E702', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (18, 9, 6, N'Booked', NULL, NULL, N'TKTCFF58265', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (19, 9, 6, N'Booked', NULL, NULL, N'TKT9AFADDAA', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (20, 9, 6, N'Booked', NULL, NULL, N'TKTF5951497', 12, 3)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (21, 2, 6, N'Booked', NULL, NULL, N'TKT26016E1C', 6, 6)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (22, 2, 6, N'Booked', NULL, NULL, N'TKTA4EEA8C6', 6, 6)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (23, 2, 6, N'Booked', NULL, NULL, N'TKT41F4F8E6', 6, 6)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (24, 2, 6, N'Booked', NULL, NULL, N'TKTD46AD532', 6, 6)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (25, 9, 6, N'Booked', NULL, NULL, N'TKTF9CB37F1', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (26, 9, 6, N'Booked', CAST(N'2025-07-24T03:21:39.017' AS DateTime), NULL, N'TKTDF737EEB', 14, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (27, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:24.293' AS DateTime), CAST(N'2025-07-23T00:36:24.317' AS DateTime), N'TKT85B882FF', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (28, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:24.360' AS DateTime), CAST(N'2025-07-23T00:36:24.387' AS DateTime), N'TKTD7F94D42', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (29, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:24.430' AS DateTime), CAST(N'2025-07-23T00:36:24.450' AS DateTime), N'TKT531233F1', 14, 12)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (30, 12, 6, N'Booked', NULL, NULL, N'TKTF2F5F3C2', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (31, 12, 6, N'Booked', NULL, NULL, N'TKT9A6FF7AC', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (32, 12, 6, N'Booked', NULL, NULL, N'TKT0E3195BC', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (33, 12, 6, N'Booked', NULL, NULL, N'TKTE1585093', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (34, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:23.830' AS DateTime), CAST(N'2025-07-23T00:36:23.853' AS DateTime), N'TKT98EB2256', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (35, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:23.900' AS DateTime), CAST(N'2025-07-23T00:36:23.923' AS DateTime), N'TKTDF445ADA', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (36, 12, 6, N'Cancelled', CAST(N'2025-07-23T00:36:23.967' AS DateTime), CAST(N'2025-07-23T00:36:23.987' AS DateTime), N'TKT06434C76', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (37, 12, 6, N'Cancelled', NULL, NULL, N'TKTF1470578', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (38, 12, 6, N'Cancelled', NULL, NULL, N'TKT6BC10BB2', 6, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (39, 12, 6, N'Booked', NULL, NULL, N'TKT1EEE0950', 12, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (40, 12, 6, N'Booked', NULL, NULL, N'TKTC78DEF36', 12, 2)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (41, 12, 6, N'Booked', CAST(N'2025-07-23T00:36:24.223' AS DateTime), CAST(N'2025-07-23T00:36:24.247' AS DateTime), N'TKT14C727DC', 14, 3)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (42, 10, 6, N'Booked', NULL, NULL, N'TKT2910C55A', 14, 3)
INSERT [dbo].[Tickets] ([ticket_id], [trip_id], [user_id], [ticket_status], [check_in], [check_out], [ticket_code], [pickup_location_id], [dropoff_location_id]) VALUES (43, 10, 6, N'Booked', NULL, NULL, N'TKT8C8B11E8', 14, 3)
SET IDENTITY_INSERT [dbo].[Tickets] OFF
GO
SET IDENTITY_INSERT [dbo].[Trip_Bus] ON 

INSERT [dbo].[Trip_Bus] ([trip_bus_id], [trip_id], [bus_id]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [dbo].[Trip_Bus] OFF
GO
SET IDENTITY_INSERT [dbo].[Trip_Driver] ON 

INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (1, 1, 1, NULL)
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (3, 3, 1, CAST(N'2025-06-24T12:00:13.600' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (5, 9, 1, CAST(N'2025-07-09T16:06:33.470' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (8, 2, 1, CAST(N'2025-07-09T16:29:07.060' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (9, 10, 1, CAST(N'2025-07-09T20:20:56.817' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (11, 12, 1, CAST(N'2025-07-15T00:52:50.877' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (12, 13, 1, CAST(N'2025-07-15T15:22:36.447' AS DateTime))
INSERT [dbo].[Trip_Driver] ([trip_driver_id], [trip_id], [driver_id], [assigned_at]) VALUES (14, 8, 2, CAST(N'2025-07-24T03:39:16.747' AS DateTime))
SET IDENTITY_INSERT [dbo].[Trip_Driver] OFF
GO
SET IDENTITY_INSERT [dbo].[Trips] ON 

INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (1, 1, 1, CAST(N'2025-07-13T17:27:00.000' AS DateTime), N'Ongoing')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (2, 1, 1, CAST(N'2025-07-22T19:00:00.000' AS DateTime), N'Cancelled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (3, 2, 1, CAST(N'2025-07-22T18:20:00.000' AS DateTime), N'Completed')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (7, 1, 1, CAST(N'2025-07-13T17:38:00.000' AS DateTime), N'Cancelled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (8, 1, 2, CAST(N'2025-07-25T19:20:00.000' AS DateTime), N'Scheduled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (9, 53, 3, CAST(N'2025-06-01T07:00:00.000' AS DateTime), N'Cancelled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (10, 3, 2, CAST(N'2025-07-30T14:30:00.000' AS DateTime), N'Scheduled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (12, 3, 1, CAST(N'2025-07-26T00:30:00.000' AS DateTime), N'Scheduled')
INSERT [dbo].[Trips] ([trip_id], [route_id], [bus_id], [departure_time], [trip_status]) VALUES (13, 53, 3, CAST(N'2025-07-23T00:00:00.000' AS DateTime), N'Completed')
SET IDENTITY_INSERT [dbo].[Trips] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (1, N'Nguyen Thi Lan', N'lan@example.com', N'$2a$12$qFYV83onvGw5MZHtJnmBx.JPA8tVeihcU.YBd79VEjWvbF/uKabNG', N'0123456789', N'Staff', CAST(N'1990-05-15' AS Date), N'Female', N'123 ABC Street, Hanoi', CAST(N'2025-06-10T16:44:44.483' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (2, N'Tran Minh Tu', N'tu@example.com', N'$2a$12$gP5D4/3q.P2xKrFN8kVfK.LZrXyurfYPIJJyQduPPbcq97PNmNlwW', N'0987654321', N'Driver', CAST(N'1985-08-25' AS Date), N'Male', N'456 XYZ Avenue, Ho Chi Minh City', CAST(N'2025-06-10T16:44:44.483' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (3, N'Le Dang Khoa', N'khoa@fpt.edu.vn', N'$2a$12$qFYV83onvGw5MZHtJnmBx.JPA8tVeihcU.YBd79VEjWvbF/uKabNG', N'0843123123', N'Driver', CAST(N'2005-05-11' AS Date), N'Female', N'Vinh Chau, ST', CAST(N'2025-06-10T23:25:01.420' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (4, N'KHOA', N'khoald@gmail.com', N'123', N'0987654321', N'Customer', CAST(N'2025-06-14' AS Date), N'Male', N'1', CAST(N'2025-06-11T00:47:22.630' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (5, N'Hoài', N'admin@gmail.com', N'$2a$12$gP5D4/3q.P2xKrFN8kVfK.LZrXyurfYPIJJyQduPPbcq97PNmNlwW', N'', N'Admin', NULL, N'Male', N'', CAST(N'2025-06-11T23:27:45.573' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (6, N'HOAIPV', N'phamvanhoai600@gmail.com', N'$2a$12$gP5D4/3q.P2xKrFN8kVfK.LZrXyurfYPIJJyQduPPbcq97PNmNlwW', N'0987654322', N'Customer', CAST(N'2025-07-08' AS Date), N'Female', N'dsf', CAST(N'2025-06-12T00:37:25.880' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (7, N'HOAIPV', N'H@gmail.com', N'$2a$12$O5NnFYq2KnRI4vCfV5Wbqe3x9.mjaY04plBdpNYkdHlIvVPNKDKEW', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:16:43.390' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (8, N'A', N'D@gmail.com', N'$2a$12$miYXfk5aS9MUZmHzdOpsMe2vfQ4ldqGmuMJ6md.60wdppivN5Ymrm', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:17:42.130' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (9, N'SFDFSD', N'SDFDSF@gmail.com', N'$2a$12$aZGikAQ43TDNiMbq8sGsc./pSf8mPzwOqFVP0D7dYr3wNyOAvFlAO', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:19:08.997' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (10, N'CXZ', N'ZXCXZC@gmail.com', N'$2a$12$ltTqIk9fY5rAsH5ml58OBeIytEt9PCJLBptM0uTkB/2eWGhL..swa', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:19:50.887' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (11, N'SFÀA', N'XCBXCB@gmail.com', N'$2a$12$BiztC7YDu.rL/B/fA1F6Veqeu0Z.oKaoaMT0CzldW1enBx.dTuvPK', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T03:20:17.710' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (12, N'aZXVZXVXZ', N'XZVVXZ@gmail.com', N'$2a$12$glOJDuIYuWWQ4PzKXea9YeQeLG3IWi3owDWtAntjj6xAyPFSJYddm', N'', N'Customer', NULL, N'Male', N'', CAST(N'2025-06-12T03:20:38.687' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (13, N'Hoai Dep Jai', N'hoaiaz@gmail.com', N'$2a$12$XPViVuPdypWTXEzlKTd.7uaxXnnPFKJwbfS5lBpFodMg6DtUUnnpy', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-12T13:55:09.947' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (32, N'HOAI18', N'hoai18@gmail.com', N'$2a$12$fjwZEDubKbr66B16Wb/4aOPTF4cukSt21YgdGQ/p1khbIN3FiP4Fu', NULL, N'Admin', NULL, NULL, NULL, CAST(N'2025-06-14T14:39:41.917' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (33, N'KHOA KHUNG KHI ', N'aidi@gma-il.com', N'$2a$12$BPl.kKDQ1mie6zn1E0FX6.ngSvxJfTwzCd6p8wCPN5/Q51A.oxBiS', N'', N'Admin', CAST(N'2025-06-10' AS Date), N'Male', N'', CAST(N'2025-06-14T21:33:14.383' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (34, N'HOAI09', N'hoai09@gmail.com', N'$2a$12$FpCjiM.mSLHlHDajDT5.f.96tBkk3KtkLbLsc4pOhdQqYmMpmHntW', N'', N'Admin', NULL, N'Male', N'', CAST(N'2025-06-16T15:47:58.613' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (35, N'usercz', N'zczcz@gmail.com', N'$2a$12$NZZDHd0tG8f1e7E4j1KxUu9SoU..3Ooh0HRYlSnRcgkWa6UnzbHfm', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-16T15:54:10.427' AS DateTime), N'Active')
INSERT [dbo].[Users] ([user_id], [user_name], [user_email], [password], [user_phone], [role], [birthdate], [gender], [user_address], [user_created_at], [user_status]) VALUES (36, N'Khoa', N'admin2222@gmail.com', N'$2a$12$XLlRH1RisllwmF0Ja3CBAetGh4A0JT4HafJnsncBJ5mtsqPdXpJtO', NULL, N'Customer', NULL, NULL, NULL, CAST(N'2025-06-24T16:16:59.753' AS DateTime), N'Active')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [UQ__Bus_Driv__A08FE4B7B121D3EC]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Bus_Driver] ADD UNIQUE NONCLUSTERED 
(
	[bus_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Bus_Type__BB856E1BE31581A6]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Bus_Types] ADD UNIQUE NONCLUSTERED 
(
	[bus_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Buses__87EF9F59B621CEFA]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Buses] ADD UNIQUE NONCLUSTERED 
(
	[plate_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Drivers__B9BE370E7FFC3A41]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Drivers] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Invoice___D596F96AEDBF6197]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Invoice_Items] ADD UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Invoice___F58DFD48FC2DA80A]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Invoice_Reviews] ADD UNIQUE NONCLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Invoices__5ED70A3513621721]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED 
(
	[invoice_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Password__CA90DA7A06112F0E]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD UNIQUE NONCLUSTERED 
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_RouteStops_Order]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Route_Stops] ADD  CONSTRAINT [UQ_RouteStops_Order] UNIQUE NONCLUSTERED 
(
	[route_id] ASC,
	[route_stop_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Ticket_S__CA9A40B115DF2B0B]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Ticket_Seat] ADD UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC,
	[seat_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Tickets__628DB75F374E351A]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Tickets] ADD UNIQUE NONCLUSTERED 
(
	[ticket_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Trip_Bus__F686B211F41F337C]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Trip_Bus] ADD UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[bus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Trip_Dri__FA6B41C4743E7FD1]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Trip_Driver] ADD UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__B0FBA2120F6B8328]    Script Date: 24/07/2025 03:48:00 SA ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[user_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  DEFAULT ((1)) FOR [bus_type_seat_template_is_active]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  CONSTRAINT [DF_BTST_Zone]  DEFAULT ('down') FOR [bus_type_seat_template_zone]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  CONSTRAINT [DF_BTST_Row]  DEFAULT ((1)) FOR [bus_type_seat_template_row]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  CONSTRAINT [DF_BTST_Col]  DEFAULT ((1)) FOR [bus_type_seat_template_col]
GO
ALTER TABLE [dbo].[Bus_Type_Seat_Template] ADD  CONSTRAINT [DF_BTST_Order]  DEFAULT ((0)) FOR [bus_type_seat_template_order]
GO
ALTER TABLE [dbo].[Driver_Incidents] ADD  DEFAULT ('Pending') FOR [incident_status]
GO
ALTER TABLE [dbo].[Driver_Incidents] ADD  DEFAULT (getdate()) FOR [incident_created_at]
GO
ALTER TABLE [dbo].[Driver_Incidents] ADD  DEFAULT (getdate()) FOR [incident_updated_at]
GO
ALTER TABLE [dbo].[Driver_License_History] ADD  DEFAULT (getdate()) FOR [changed_at]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] ADD  DEFAULT (getdate()) FOR [request_date]
GO
ALTER TABLE [dbo].[Driver_Trip_Change_Request] ADD  DEFAULT ('Pending') FOR [request_status]
GO
ALTER TABLE [dbo].[Drivers] ADD  DEFAULT ('Active') FOR [driver_status]
GO
ALTER TABLE [dbo].[Favorite_Routes] ADD  DEFAULT (getdate()) FOR [favorite_routes_created_at]
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] ADD  DEFAULT (getdate()) FOR [request_date]
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] ADD  DEFAULT ('Pending') FOR [request_status]
GO
ALTER TABLE [dbo].[Invoice_Reviews] ADD  DEFAULT (getdate()) FOR [review_created_at]
GO
ALTER TABLE [dbo].[Invoices] ADD  DEFAULT (getdate()) FOR [paid_at]
GO
ALTER TABLE [dbo].[Invoices] ADD  DEFAULT (N'Thanh toán thành công') FOR [invoice_status]
GO
ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [DF_Locations_CreatedAt]  DEFAULT (getdate()) FOR [location_created_at]
GO
ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [DF_Locations_Status]  DEFAULT ('Active') FOR [location_status]
GO
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD  DEFAULT (getdate()) FOR [token_created_at]
GO
ALTER TABLE [dbo].[Password_Reset_Tokens] ADD  DEFAULT ((0)) FOR [token_used]
GO
ALTER TABLE [dbo].[Route_Prices] ADD  DEFAULT (getdate()) FOR [route_price_effective_from]
GO
ALTER TABLE [dbo].[Route_Stops] ADD  DEFAULT ((0)) FOR [route_stop_dwell_minutes]
GO
ALTER TABLE [dbo].[Route_Stops] ADD  DEFAULT ((0)) FOR [travel_minutes]
GO
ALTER TABLE [dbo].[Routes] ADD  DEFAULT ('Active') FOR [route_status]
GO
ALTER TABLE [dbo].[Seat_History] ADD  DEFAULT (getdate()) FOR [history_changed_at]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (left(CONVERT([varchar](36),newid()),(6))) FOR [ticket_code]
GO
ALTER TABLE [dbo].[Trip_Driver] ADD  DEFAULT (getdate()) FOR [assigned_at]
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
ALTER TABLE [dbo].[Buses]  WITH CHECK ADD  CONSTRAINT [FK_buses_bus_type] FOREIGN KEY([bus_type_id])
REFERENCES [dbo].[Bus_Types] ([bus_type_id])
GO
ALTER TABLE [dbo].[Buses] CHECK CONSTRAINT [FK_buses_bus_type]
GO
ALTER TABLE [dbo].[Driver_Incidents]  WITH CHECK ADD FOREIGN KEY([driver_id])
REFERENCES [dbo].[Drivers] ([driver_id])
GO
ALTER TABLE [dbo].[Driver_Incidents]  WITH CHECK ADD FOREIGN KEY([trip_id])
REFERENCES [dbo].[Trips] ([trip_id])
GO
ALTER TABLE [dbo].[Driver_Incidents]  WITH CHECK ADD  CONSTRAINT [FK_DriverIncidents_Users] FOREIGN KEY([incident_support_by])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Driver_Incidents] CHECK CONSTRAINT [FK_DriverIncidents_Users]
GO
ALTER TABLE [dbo].[Driver_License_History]  WITH CHECK ADD  CONSTRAINT [FK_LicenseHistory_Admin] FOREIGN KEY([changed_by])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Driver_License_History] CHECK CONSTRAINT [FK_LicenseHistory_Admin]
GO
ALTER TABLE [dbo].[Driver_License_History]  WITH CHECK ADD  CONSTRAINT [FK_LicenseHistory_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Driver_License_History] CHECK CONSTRAINT [FK_LicenseHistory_User]
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
ALTER TABLE [dbo].[Favorite_Routes]  WITH CHECK ADD FOREIGN KEY([route_id])
REFERENCES [dbo].[Routes] ([route_id])
GO
ALTER TABLE [dbo].[Favorite_Routes]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests]  WITH CHECK ADD  CONSTRAINT [FK_ICR_Invoices] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoices] ([invoice_id])
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] CHECK CONSTRAINT [FK_ICR_Invoices]
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests]  WITH CHECK ADD  CONSTRAINT [FK_TCR_ApprovedBy] FOREIGN KEY([approved_by_staff_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] CHECK CONSTRAINT [FK_TCR_ApprovedBy]
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests]  WITH CHECK ADD  CONSTRAINT [FK_TCR_Requester] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] CHECK CONSTRAINT [FK_TCR_Requester]
GO
ALTER TABLE [dbo].[Invoice_Items]  WITH CHECK ADD FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoices] ([invoice_id])
GO
ALTER TABLE [dbo].[Invoice_Items]  WITH CHECK ADD FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Invoice_Reviews]  WITH CHECK ADD FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoices] ([invoice_id])
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
ALTER TABLE [dbo].[Route_Prices]  WITH CHECK ADD FOREIGN KEY([bus_type_id])
REFERENCES [dbo].[Bus_Types] ([bus_type_id])
GO
ALTER TABLE [dbo].[Route_Prices]  WITH CHECK ADD FOREIGN KEY([route_id])
REFERENCES [dbo].[Routes] ([route_id])
GO
ALTER TABLE [dbo].[Route_Stops]  WITH CHECK ADD  CONSTRAINT [FK_RouteStops_Locations] FOREIGN KEY([location_id])
REFERENCES [dbo].[Locations] ([location_id])
GO
ALTER TABLE [dbo].[Route_Stops] CHECK CONSTRAINT [FK_RouteStops_Locations]
GO
ALTER TABLE [dbo].[Route_Stops]  WITH CHECK ADD  CONSTRAINT [FK_RouteStops_Routes] FOREIGN KEY([route_id])
REFERENCES [dbo].[Routes] ([route_id])
GO
ALTER TABLE [dbo].[Route_Stops] CHECK CONSTRAINT [FK_RouteStops_Routes]
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
ALTER TABLE [dbo].[Driver_License_History]  WITH CHECK ADD CHECK  (([new_license_class]='D2' OR [new_license_class]='D'))
GO
ALTER TABLE [dbo].[Driver_License_History]  WITH CHECK ADD CHECK  (([old_license_class]='D2' OR [old_license_class]='D'))
GO
ALTER TABLE [dbo].[Driver_License_History]  WITH CHECK ADD  CONSTRAINT [CK_LicenseHistory_UpgradeOnly] CHECK  (([old_license_class]='D' AND [new_license_class]='D2' OR [old_license_class]='D2' AND [new_license_class]='D'))
GO
ALTER TABLE [dbo].[Driver_License_History] CHECK CONSTRAINT [CK_LicenseHistory_UpgradeOnly]
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests]  WITH CHECK ADD  CONSTRAINT [CK_TCR_Status] CHECK  (([request_status]='Rejected' OR [request_status]='Approved' OR [request_status]='Pending'))
GO
ALTER TABLE [dbo].[Invoice_Cancel_Requests] CHECK CONSTRAINT [CK_TCR_Status]
GO
ALTER TABLE [dbo].[Invoice_Reviews]  WITH CHECK ADD CHECK  (([review_rating]>=(1) AND [review_rating]<=(5)))
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [CK__tickets__ticket_status] CHECK  (([ticket_status]='Completed' OR [ticket_status]='Cancelled' OR [ticket_status]='Booked'))
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [CK__tickets__ticket_status]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([gender]='Other' OR [gender]='Female' OR [gender]='Male'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([role]='Staff' OR [role]='Customer' OR [role]='Driver' OR [role]='Admin'))
GO
USE [master]
GO
ALTER DATABASE [BusTicket] SET  READ_WRITE 
GO
