USE [BusTicket]
GO
/****** Object:  Table [dbo].[Bus_Driver]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[bus_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bus_Type_Seat_Template]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[bus_type_id] ASC,
	[seat_template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bus_Types]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[bus_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Buses]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[plate_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver_Trip_Change_Request]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Drivers]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Items]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Taxes]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Invoices]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[invoice_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Password_Reset_Tokens]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Route_Pricing]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Routes]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Seat_History]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Seat_Templates]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Ticket_Seat]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ticket_id] ASC,
	[seat_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ticket_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trip_Bus]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[bus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trip_Driver]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[trip_id] ASC,
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trips]    Script Date: 12/06/2025 04:11:53 CH ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 12/06/2025 04:11:53 CH ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
