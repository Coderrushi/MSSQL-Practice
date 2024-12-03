CREATE DATABASE BOOKSTORE_DB;
USE BOOKSTORE_DB;
CREATE TABLE [User] (
	UserID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	EmailID VARCHAR(50) NOT NULL UNIQUE,
	[Password] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(40) NOT NULL,
	CreatedDate DATE NOT NULL
);

CREATE TABLE ProductInfo (
	ProductID INT PRIMARY KEY IDENTITY(1,1),
	Title VARCHAR(50) NOT NULL,
	Author VARCHAR(50) NOT NULL,
	Genre VARCHAR(50) NOT NULL,
	Price DECIMAL(5,2) NOT NULL,
	Stock INT NOT NULL,
	Description VARCHAR(100) NOT NULL
);

CREATE TABLE ProductImage (
	ImageID INT PRIMARY KEY IDENTITY(1,1),
	ProductID INT,
	ImageURL VARCHAR(50) NOT NULL,
	CONSTRAINT FK_ProductImage_Product FOREIGN KEY (ProductID)
	REFERENCES ProductInfo (ProductID)
	ON DELETE CASCADE
	ON UPDATE CASCADE 
);

CREATE TABLE Cart (
	CartID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	CONSTRAINT FK_Cart_User FOREIGN KEY (UserID)
	REFERENCES [User] (UserID)
	ON DELETE CASCADE
	ON UPDATE CASCADE 
);

CREATE TABLE CartItem (
	CartItemID INT PRIMARY KEY IDENTITY(1,1),
	CartID INT,
	ProductID INT,
	Quantity INT NOT NULL,
	CONSTRAINT FK_CartItem_Cart FOREIGN KEY (CartID)
	REFERENCES Cart (CartID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_CartItem_Product FOREIGN KEY (ProductID)
	REFERENCES ProductInfo (ProductID)
	ON DELETE CASCADE
	ON UPDATE CASCADE 
);

CREATE TABLE [Address] (
	ShippingAddressID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	AddressLine1 VARCHAR(50) NOT NULL,
	AddressLine2 VARCHAR(50) NOT NULL,
	City VARCHAR(20) NOT NULL,
	[State] VARCHAR(20)NOT NULL,
	Country VARCHAR(20) NOT NULL,
	ZipCode INT NOT NULL,
	CONSTRAINT FK_Address_User FOREIGN KEY (UserID)
	REFERENCES [User] (UserID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE [Order] (
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	OrderDate DATE NOT NULL,
	TotalAmount DECIMAL(10,2) NOT NULL,
	ShippingAddressID INT,
	CONSTRAINT FK_Order_User FOREIGN KEY (UserID)
	REFERENCES [User] (UserID)
	ON DELETE NO ACTION,
	CONSTRAINT FK_Order_Address FOREIGN KEY (ShippingAddressID)
	REFERENCES [Address] (ShippingAddressID)
	ON DELETE  NO ACTION
);
GO
--Trigger to delete orders of the user who is deleted.
	CREATE TRIGGER trg_DeleteOrders_User
	ON [User]
	AFTER DELETE
	AS 
		BEGIN	
			DELETE FROM [Order] WHERE UserID IN (SELECT UserId FROM DELETED);
		END;
GO
--Trigger to delete orders of the user who's address is deleted.
CREATE TRIGGER trg_DeleteOrders_Address 
ON [Address]
AFTER DELETE
AS
	BEGIN
		DELETE FROM [Order] WHERE ShippingAddressID IN (SELECT ShippingAddressID FROM DELETED);
	END;
GO

CREATE TABLE OrderItem (
	OderItemID INT PRIMARY KEY IDENTITY(1,1),
	OrderID INT,
	ProductID INT,
	Quantity INT NOT NULL,
	Price DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_OrderItem_Order FOREIGN KEY (OrderID)
	REFERENCES [Order] (OrderID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_OrderItem_Product FOREIGN KEY (ProductID)
	REFERENCES ProductInfo (ProductID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Review (
	ReviewID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	ProductID INT,
	[Rating(1-5)] INT,
	Comment VARCHAR(50),
	ReviewDate DATE NOT NULL,
	CONSTRAINT FK_Review_User FOREIGN KEY (UserID)
	REFERENCES [User] (UserID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_Review_Product FOREIGN KEY (ProductID)
	REFERENCES ProductInfo (ProductID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE WishList (
	WishListID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	CONSTRAINT FK_WishList_User FOREIGN KEY (UserID)
	REFERENCES [User] (UserID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE WishListItem (
	WishListItemID INT PRIMARY KEY IDENTITY(1,1),
	WishListID INT,
	ProductID INT,
	CONSTRAINT FK_WishListItem_WishList FOREIGN KEY (WishListID)
	REFERENCES WishList (WishListID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_WishListItem_Product FOREIGN KEY (ProductID)
	REFERENCES ProductInfo (ProductID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Audit_Table (
	DatabaseName nvarchar(250),
	TableName nvarchar(250),
	EventType nvarchar(250),
	LoginName nvarchar(250),
	SQLCommand nvarchar(2500),
	AuditDateTime datetime
);

CREATE TABLE AuditLog (
	LogID INT PRIMARY KEY IDENTITY(1,1),
	UserID INT,
	ActionPerformed VARCHAR(20),
	ActionTime DATETIME DEFAULT GETDATE(),
	Details VARCHAR(MAX)
);

GO
--Trigger to Log changes to an audit table for tracking updates.
CREATE OR ALTER TRIGGER tr_AuditTableLogs
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE	
AS 
	BEGIN
		DECLARE @EventData XML
		SELECT @EventData = EVENTDATA()
		 
		INSERT INTO BOOKSTORE_DB.dbo.Audit_Table
		(DatabaseName, TableName, EventType, LoginName, SQLCommand, AuditDateTime)
		 VALUES
		 (
		  @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(250)'),
		  @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(250)'),
		  @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)'),
		  @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(250)'),
		  @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2500)'),
		  GetDate()
		 ) 
	END
GO
SELECT * FROM Audit_Table;
GO
--Trigger to update user activities in audit logs table
CREATE OR ALTER TRIGGER tr_UserActionLogs
ON  [User]
AFTER INSERT, UPDATE, DELETE
AS
	BEGIN
		INSERT INTO AuditLog (UserID, ActionPerformed, Details)
		SELECT 
			COALESCE(i.UserID, d.UserID) AS UserID,
			CASE 
				WHEN i.UserID IS NOT NULL  AND d.UserID IS NULL THEN 'Insert'
				WHEN i.UserID IS NOT NULL AND d.UserID IS NOT NULL THEN 'Update'
				WHEN i.UserID IS NULL AND d.UserID IS NOT NULL THEN 'Delete'
			END AS ActionPerformed,
			CASE
				WHEN i.UserID IS NOT NULL  AND d.UserID IS NULL THEN 'Registered New User'
				WHEN i.UserID IS NOT NULL AND d.UserID IS NOT NULL THEN 'Updated User Details'
				WHEN i.UserID IS NULL AND d.UserID IS NOT NULL THEN 'Deleteed User'
			END AS Details
		FROM inserted i
		FULL OUTER JOIN deleted d ON i.UserID = d.UserID
	END;
GO
SELECT * FROM AuditLog;
--Trigger to update stock in the ProductInfo table when an order is placed.
CREATE TRIGGER tr_UpdateStocK
ON OrderItem
AFTER INSERT
AS 
	BEGIN
		SET NOCOUNT ON;

		UPDATE ProductInfo
		SET Stock = Stock - I.Quantity
		FROM ProductInfo P
		INNER JOIN Inserted I
		ON P.ProductID = I.ProductID;

		IF EXISTS (
			SELECT 1
			FROM ProductInfo
			WHERE Stock < 0
		)
		BEGIN
			PRINT 'Insufficient Stock i.e. < 0';
		END
	END
GO

ALTER TABLE Review
ADD CONSTRAINT [Rating(1-5)] CHECK (Rating >= 1 AND Rating <=5)

EXEC sp_rename 'Review.Rating(1-5)', 'Rating', 'COLUMN';
GO
CREATE NONCLUSTERED INDEX IX_ProductInfo
ON ProductInfo (Title);

GO
--View for top-rated products.
CREATE VIEW vw_TopRatedProducts
AS
	SELECT P.ProductID, P.Title, P.Author, P.Genre, P.Price, AVG(R.Rating) AS AverageRating
	FROM Review R
	INNER JOIN ProductInfo P
	ON R.ProductID = P.ProductID
	GROUP BY P.ProductID, P.Title, P.Author, P.Genre, P.Price
	HAVING AVG(R.Rating) >= 4.5;
 GO
 --View for total sales by month.
 CREATE VIEW vw_SalesByMonth
 AS
	SELECT MONTH(OrderDate) AS SalesMonth, SUM(TotalAmount) AS TotalSales
	FROM [Order]
	GROUP BY MONTH(OrderDate);
 GO
 --View for User purchase history.
 CREATE VIEW vw_UserPurchaseHistory
 AS
	 SELECT U.UserID, U.FirstName, U.LastName, U.PhoneNumber ,O.OrderDate, OI.ProductID, OI.Price
	 FROM [User] AS U
	 INNER JOIN [Order] AS O ON U.UserID = O.UserID
	 INNER JOIN [OrderItem] AS OI ON O.OrderID = OI.OrderID;
 GO

 EXEC sp_rename 'OrderItem.OderItemID', 'OrderItemID', 'COLUMN';

 ALTER TABLE [User]
 ALTER COLUMN CreatedDate DATETIME NOT NULL;
 ALTER TABLE [User]
 ADD CONSTRAINT DF_User_CreatedDate DEFAULT GETDATE() FOR CreatedDate;

 ALTER TABLE Review
 ALTER COLUMN ReviewDate DATETIME NOT NULL;
 ALTER TABLE Review
 ADD CONSTRAINT DF_Review_ReviewDate DEFAULT GETDATE() FOR ReviewDate;

 GO
 --SP for adding a new user
 CREATE OR ALTER PROCEDURE proc_AddUser
	@FirstName VARCHAR(20), @LastName VARCHAR(20), @EmailID VARCHAR(50), @Password VARCHAR(50), @PhoneNumber VARCHAR(40), @CreatedDate DATETIME
    AS 
	BEGIN
		INSERT INTO [User] (FirstName, LastName, EmailID, [Password], PhoneNumber, CreatedDate)
		VALUES (@FirstName, @LastName, @EmailID, @Password, @PhoneNumber, @CreatedDate);
	END;
GO
--SP for adding  user address
CREATE PROCEDURE proc_AddUserAddress
	@UserID INT, @AddressLine1 VARCHAR(50), @AddressLine2 VARCHAR(50), @City VARCHAR(20), @State VARCHAR(20), @Country VARCHAR(20), @ZipCode INT
	AS
	BEGIN
		INSERT INTO [Address] (UserID, AddressLine1, AddressLine2, City, [State], Country, ZipCode)
		VALUES (@UserID, @AddressLine1, @AddressLine2, @City, @State, @Country, @ZipCode)
	END;
GO
--SP for adding new book
CREATE OR ALTER PROCEDURE proc_AddNewBook
	@Title VARCHAR(50) , @Author VARCHAR(50), @Genre VARCHAR(50), @Price DECIMAL(10,2), @Stock INT, @Description VARCHAR(50)
	AS 
	BEGIN
		INSERT INTO ProductInfo (Title, Author, Genre, Price, Stock, Description)
		VALUES (@Title, @Author, @Genre, @Price, @Stock, @Description)
	END
GO
--SP to Add product iamge
CREATE PROCEDURE proc_AddProductImage
	@ProductID INT, @ImageURL VARCHAR(50) 
AS 
	BEGIN
		INSERT INTO ProductImage (ProductID, ImageURL)
		VALUES (@ProductID, @ImageURL)
	END;
GO
 -- SP for Adding an order and its items.
CREATE OR ALTER PROCEDURE proc_AddAnOrder
		@OrderID INT,
		@ProductID INT,
		@Quantity INT
	AS
	BEGIN
		BEGIN TRY
			IF(SELECT Stock FROM ProductInfo WHERE ProductID = @ProductID) < @Quantity
			BEGIN
				THROW 50001, 'Insufficient stock..', 1;
			END

			INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price)
			VALUES (
				@OrderID, @ProductID, @Quantity,
					(SELECT Price FROM ProductInfo WHERE ProductID = @ProductID)
			);
		END TRY
		BEGIN CATCH 
				IF @@TRANCOUNT > 0 ROLLBACK;
				THROW;
		END CATCH
	END
GO
--SP for retrieving product details with reviews and ratings.
CREATE PROCEDURE proc_ProductDetailsWithReviewsAndRatings
@ProductID INT
AS 
	BEGIN	
		SELECT P.ProductID, P.Title, P.Author, P.Genre, P.Price, P.Stock, P.Description,
					R.Rating, R.Comment, R.ReviewDate
		FROM ProductInfo P
		LEFT JOIN Review R ON P.ProductID = R.ProductID
		WHERE P.ProductID = @ProductID
	END;
GO
--SP for Calculating total order amounts.
CREATE PROCEDURE proc_CalculatingTotalOrderAmounts
@ProductID INT
AS 
	BEGIN
		SELECT O.OrderID, SUM(OI.Quantity*OI.Price) AS TotalAmounts, O.OrderDate
		FROM [Order] O
		INNER JOIN OrderItem OI ON O.OrderID = OI.OrderID 
		WHERE OI.ProductID = @ProductID
		GROUP BY O.OrderID, O.OrderDate;
	END;
GO
--SP to add book to the cart.
CREATE OR ALTER PROCEDURE proc_AddToCart
	@UserID INT,
	@ProductID INT,
	@Quantity INT
	AS 
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION;
				DECLARE @CartID INT;
				SELECT @CartID = CartID FROM Cart WHERE UserID = @UserID;
				 
				 IF @CartID IS NULL
				BEGIN
					INSERT INTO Cart (UserID) VALUES (@UserID);
				    SET @CartID = SCOPE_IDENTITY();
				END;

				IF EXISTS (SELECT 1 FROM CartItem WHERE CartID = @CartID AND ProductID = @ProductID)
				BEGIN
					UPDATE CartItem
					SET Quantity = Quantity + @Quantity
					WHERE CartID = @CartID AND ProductID = @ProductID;
				END;
				ELSE
				BEGIN
					INSERT INTO CartItem (CartID, ProductID, Quantity)
					VALUES (@CartID, @ProductID, @Quantity);
				END;
				COMMIT TRANSACTION;
			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK;
				THROW;
			END CATCH
		END;
GO
--SP to view cart items
CREATE OR ALTER PROCEDURE proc_ViewCartItems
	@UserID INT
	AS
		BEGIN
			SELECT ci.CartItemID, p.Title AS BookTitle, ci.Quantity, p.Price AS UnitPrice, (ci.Quantity * p.Price) AS TotalPrice
			FROM CartItem ci
			JOIN ProductInfo p ON ci.ProductID = p.ProductID
			JOIN Cart c ON ci.CartID = c.CartID
			WHERE c.UserID = @UserID;
		END;
GO
--SP to add review
CREATE OR ALTER PROCEDURE proc_AddReview
	@UserID INT,
	@ProductID INT,
	@Rating INT,
	@Comment VARCHAR(50),
	@ReviewDate DATETIME
AS 
	BEGIN
		INSERT INTO Review (UserID, ProductID, Rating, Comment, ReviewDate)
		VALUES (@UserID, @ProductID, @Rating, @Comment, @ReviewDate);
	END

GO
--SP to place an order
CREATE PROCEDURE proc_PlaceAnOrder
	@UserID INT,
	@ShippingAddressID INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;
				IF EXISTS (
					SELECT 1 FROM CartItem C
					JOIN ProductInfo P ON C.ProductID = P.ProductID 
					WHERE C.CartID = (SELECT CartID FROM Cart WHERE UserID = @UserID)
						AND C.Quantity > P.Stock
				)
				BEGIN
					THROW 51000, 'Insufficient stock...', 1;
				END;

				DECLARE @OrderID INT;
				INSERT INTO [Order] (UserID, OrderDate, TotalAmount, ShippingAddressID)
				VALUES (
					@UserID,
					GETDATE(),
					(SELECT  SUM(CI.Quantity * P.Price)
						FROM CartItem CI
						JOIN ProductInfo P
						ON CI.ProductID = P.ProductID
						WHERE CI.CartID = (SELECT CartID FROM Cart WHERE UserID = @UserID)),
					@ShippingAddressID
				);
				SET @OrderID = SCOPE_IDENTITY();
				INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price)
				SELECT
					@OrderID,
					CI.ProductID,
					CI.Quantity,
					P.Price
				FROM CartItem CI
				JOIN ProductInfo P 
				ON CI.ProductID = P.ProductID
				WHERE CI.CartID = (SELECT CartID FROM Cart WHERE UserID = @UserID);

				DELETE FROM CartItem
				WHERE CartID = (SELECT CartID FROM Cart WHERE UserID = @UserID);

				COMMIT TRANSACTION;
			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK;
				THROW;
			END CATCH
		END;
GO
--SP to view order details
CREATE OR ALTER PROCEDURE proc_ViewOrderDetails
	@UserID INT = NULL,
	@OrderID INT = NULL
AS 
	BEGIN
		BEGIN TRY
			SELECT
				O.OrderID,
				U.UserID,
				U.FirstName AS FirstName,
				U.LastName AS LastName,
				U.PhoneNumber AS PhoneNumber,
				O.OrderDate,
				P.Title,
				P.Price AS UnitPrice,
				OI.Quantity,
				O.TotalAmount
			FROM [Order] O
			JOIN OrderItem OI ON O.OrderID = OI.OrderID
			JOIN ProductInfo P ON OI.ProductID = P.ProductID
			LEFT JOIN [User] U ON O.UserID = U.UserID
			WHERE (@UserID IS NULL OR O.UserID = @UserID) AND
						(@OrderID IS NULL OR O.OrderID = @OrderID)
			ORDER BY O.OrderDate DESC, O.OrderID;
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH
	END;
GO


CREATE NONCLUSTERED INDEX IX_ProductInfo_Title
ON ProductInfo (Title);

CREATE NONCLUSTERED INDEX IX_User_EmailID
ON [User] (EmailID);

CREATE NONCLUSTERED INDEX IX_Order_OrderDate
ON [Order] (OrderDate);
GO

DECLARE @CurrentDate DATETIME = GETDATE();
EXEC proc_AddUser @FirstName = 'Saurabh', @LastName = 'Sharma', @EmailID = 'ss@example.com', @Password = 'ss@12345', @PhoneNumber = '9998979695', @CreatedDate = @CurrentDate
EXEC proc_AddUser @FirstName = 'Piyush', @LastName = 'Patil', @EmailID = 'pp@example.com', @Password = 'pp@12345', @PhoneNumber = '8988878685', @CreatedDate = @CurrentDate
EXEC proc_AddUser @FirstName = 'Ishan', @LastName = 'Tyagi', @EmailID = 'it@example.com', @Password = 'it@12345', @PhoneNumber = '7978777675', @CreatedDate = @CurrentDate

 EXEC proc_AddUserAddress @UserID = 7, @AddressLine1 = '45 Brigade Road', @AddressLine2 = 'Opposite Metro Station', @City = 'Bengaluru', @State = 'Karnataka', @Country = 'India', @ZipCode = 560001;
 EXEC proc_AddUserAddress @UserID = 8, @AddressLine1 = '88 Anna Salai', @AddressLine2 = 'Near LIC Building', @City = 'Chennai', @State = 'Tamil Nadu', @Country = 'India', @ZipCode = 600002;
 EXEC proc_AddUserAddress @UserID = 9, @AddressLine1 = '32 Connaught Place', @AddressLine2 = 'Near Palika Bazaar', @City = 'New Delhi', @State = 'Delhi', @Country = 'India', @ZipCode = 110001;

 EXEC proc_AddNewBook @Title = 'The Great Gatsby', @Author = 'F. Scott Fitzgerald', @Genre = 'Classic Fiction',  @Price = 500, @Stock = 10, @Description = 'A tale of love and wealth';
 EXEC proc_AddNewBook @Title = 'To Kill a Mockingbird', @Author = 'Harper Lee', @Genre = 'Historical  Fiction',  @Price = 350, @Stock = 15, @Description = 'A story about justice and race';
 EXEC proc_AddNewBook @Title = '1984', @Author = 'George Orwell', @Genre = 'Dystopian',  @Price = 300, @Stock = 20, @Description = 'A dystopian society under surveillance';

 EXEC proc_AddProductImage @ProductID = 6, @ImageURL = 'https://www.amazon.in/Great-Gatsby-Original-Unabridged-Fitzgerald-ebook/dp/B0C1M7X943';
 EXEC proc_AddProductImage @ProductID = 7, @ImageURL = 'https://www.amazon.in/Kill-Mockingbird-Harper-Lee/dp/0099549484';
 EXEC proc_AddProductImage @ProductID = 8, @ImageURL = 'https://www.google.co.in/books/edition/1984_Nineteen_Eighty_Four/0vQCEAAAQBAJ?hl=en&gbpv=0';

EXEC proc_AddToCart @UserID = 7, @ProductID = 6, @Quantity = 2;
EXEC proc_AddToCart @UserID = 8, @ProductID = 7, @Quantity = 1;
EXEC proc_AddToCart @UserID = 9, @ProductID = 8, @Quantity = 2;

EXEC proc_ViewCartItems 8;

DECLARE @CurrentDate1 DATETIME = GETDATE();
EXEC proc_AddReview @UserID = 7, @ProductID = 6, @Rating = 4, @Comment = 'A timeless tale of love', @ReviewDate = @CurrentDate1;
EXEC proc_AddReview @UserID = 8, @ProductID = 7, @Rating = 5, @Comment = 'Profound story about justice', @ReviewDate = @CurrentDate1;
EXEC proc_AddReview @UserID = 9, @ProductID = 8, @Rating = 4, @Comment = 'Chilling depiction of surveillance', @ReviewDate = @CurrentDate1;

EXEC proc_PlaceAnOrder @UserID  = 8, @ShippingAddressID = 8;
EXEC proc_PlaceAnOrder @UserID  = 9, @ShippingAddressID = 9;

EXEC proc_ViewOrderDetails @UserID = 8;

--Backup of database
BACKUP DATABASE BOOKSTORE_DB
TO DISK = 'F:\Database_Backups\BookStore_FullBackUp.bak'
WITH FORMAT,
NAME = 'Full Backup of Book Store';

RESTORE DATABASE BOOKSTORE_DB
FROM DISK = 'F:\Database_Backups\BookStore_FullBackUp.bak'
WITH REPLACE;

--Database snapshot
CREATE DATABASE BOOKSTORE_Snapshots
ON (Name = BOOKSTORE_DB, FILENAME = 'F:\db_snapshots1\BookStore.ss')
AS SNAPSHOT OF BOOKSTORE_DB;

USE MASTER;

RESTORE DATABASE BOOKSTORE_DB
FROM DATABASE_SNAPSHOT = 'BOOKSTORE_Snapshots'
GO	

SELECT * FROM [User];
SELECT * FROM [ProductInfo];
select * from ProductImage;

select * from [Order];
select * from OrderItem;
select * from Cart;

select * from CartItem;
select * from [Address];
select * from Review;

