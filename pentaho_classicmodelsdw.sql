CREATE TABLE Dim_Date (
    date_key INT NOT NULL PRIMARY KEY COMMENT 'Kunci Tanggal, Format YYYYMMDD',
    full_date DATE NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    day_of_week TINYINT NOT NULL COMMENT '1=Minggu, 7=Sabtu',
    day_of_month TINYINT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    month_number TINYINT NOT NULL,
    calendar_quarter TINYINT NOT NULL COMMENT 'Q1, Q2, Q3, Q4',
    calendar_year SMALLINT NOT NULL
);

CREATE TABLE Dim_Customer (
    customerNumber INT NOT NULL PRIMARY KEY,
    customerName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    postalCode VARCHAR(15) DEFAULT NULL,
    creditLimit DECIMAL(10,2) DEFAULT NULL
);

CREATE TABLE Dim_Product (
    productCode VARCHAR(15) NOT NULL PRIMARY KEY,
    productName VARCHAR(70) NOT NULL,
    productLine VARCHAR(50) NOT NULL,
    productLineDescription VARCHAR(4000) COMMENT 'Denormalisasi dari tabel productlines',
    productScale VARCHAR(10) NOT NULL,
    productVendor VARCHAR(50) NOT NULL,
    buyPrice DECIMAL(10,2) NOT NULL,
    MSRP DECIMAL(10,2) NOT NULL,
    quantityInStock SMALLINT(6) NOT NULL
);

CREATE TABLE Dim_Employee (
    employeeNumber INT NOT NULL PRIMARY KEY,
    lastName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    reportsToEmployeeNumber INT DEFAULT NULL,
    officeCity VARCHAR(50) COMMENT 'Denormalisasi dari tabel offices',
    officeCountry VARCHAR(50) COMMENT 'Denormalisasi dari tabel offices'
);

CREATE TABLE Fact_Sales (
    orderNumber INT NOT NULL,
    productCode VARCHAR(15) NOT NULL,
    customerNumber INT NOT NULL,
    salesRepEmployeeNumber INT DEFAULT NULL COMMENT 'Kunci FK ke Dim_Employee',
    order_date_key INT NOT NULL COMMENT 'FK ke Dim_Date',
    required_date_key INT NOT NULL COMMENT 'FK ke Dim_Date',
    shipped_date_key INT NULL COMMENT 'FK ke Dim_Date',
    
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10,2) NOT NULL,
    salesAmount DECIMAL(14,2) AS (quantityOrdered * priceEach) COMMENT 'Metrik terhitung',
    
    status VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (orderNumber, productCode),
    
    -- Foreign Keys
    FOREIGN KEY (customerNumber) REFERENCES Dim_Customer(customerNumber),
    FOREIGN KEY (productCode) REFERENCES Dim_Product(productCode),
    FOREIGN KEY (salesRepEmployeeNumber) REFERENCES Dim_Employee(employeeNumber),
    FOREIGN KEY (order_date_key) REFERENCES Dim_Date(date_key)
);

