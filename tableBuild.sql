CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Categories (CategoryName) VALUES
('Burger'),
('Drink'),
('Fries');

CREATE TABLE MenuItems (
    ItemId INT PRIMARY KEY IDENTITY,
    ItemName VARCHAR(100) NOT NULL,
    CategoryId INT FOREIGN KEY REFERENCES Categories(CategoryId),
    ItemPrice DECIMAL(5,2) NOT NULL,
    ItemImage VARCHAR(100)
);


CREATE TABLE Orders (
    OrderId INT PRIMARY KEY IDENTITY,
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    OrderDate DATETIME DEFAULT GETDATE(),
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    TotalAmount DECIMAL(6,2),
    PaymentMethod VARCHAR(50),
    DeliveryType VARCHAR(20),
    DeliveryAddress VARCHAR(255)
);


CREATE TABLE OrderDetails (
    OrderDetailId INT PRIMARY KEY IDENTITY,
    OrderId INT FOREIGN KEY REFERENCES Orders(OrderId),
    ItemId INT FOREIGN KEY REFERENCES MenuItems(ItemId),
    Quantity INT,
    ItemPrice DECIMAL(5,2)
);

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255), 
    IsAdmin BIT DEFAULT 0
);

CREATE TABLE Cart (
    CartId INT PRIMARY KEY IDENTITY,
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    ItemId INT FOREIGN KEY REFERENCES MenuItems(ItemId),
    Quantity INT NOT NULL,
    DateAdded DATETIME DEFAULT GETDATE()
);

ALTER TABLE Orders
ADD DeliveryStatus VARCHAR(30) DEFAULT 'Pending';
