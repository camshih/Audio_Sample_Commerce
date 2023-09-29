/*
    Audio Sample ECommerce Library 
    
    Caleb Barynin, 500916330
    Woosung Kim, 501103273
    Cameron Shih, 501028169
    CPS 510 - 11, Group 10
    Dr. Tajali

*/


CREATE TABLE All_Users(
    usernames varchar2(20) NOT NULL,
    passwords varchar2(20) NOT NULL,
    balance numeric(10,2) DEFAULT 0,
    CONSTRAINT "pK_User" PRIMARY KEY (usernames)
);
CREATE TABLE Customers(
    cust_id int NOT NULL,
    cust_name varchar2(20),
    cust_user varchar2(20),
    cust_bal numeric(10,2),
    CONSTRAINT "pK_Customers" PRIMARY KEY (cust_id),
    CONSTRAINT "fK_Customers" FOREIGN KEY (cust_user) REFERENCES All_Users(usernames)
);
CREATE TABLE Distributors(
    dist_id int NOT NULL,
    dist_name varchar2(20),
    dist_user varchar2(20),
    dist_bal numeric(10,2),
    discount_codes varchar(20) UNIQUE NOT NULL,
    CONSTRAINT "pK_Distributors" PRIMARY KEY (dist_id),
    CONSTRAINT "fK_Distributors" FOREIGN KEY (dist_user) REFERENCES All_Users(usernames)
);
CREATE TABLE Authors(
    auth_id int NOT NULL,
    auth_name varchar2(20),
    auth_user varchar2(20),
    CONSTRAINT "pK_Authors" PRIMARY KEY (auth_id),
    CONSTRAINT "fK_Authors" FOREIGN KEY (auth_user) REFERENCES All_Users(usernames)
);
CREATE TABLE Audio_Samples(
    auth_id int,
    sample_id int NOT NULL,
    sample_name varchar2(20),
    sample_length varchar2(20),
    as_wav blob,
    price numeric(10,2),
    CONSTRAINT "pK_Audio_Samples" PRIMARY KEY (sample_id),
    CONSTRAINT "fK_Audio_Samples" FOREIGN KEY (auth_id) REFERENCES Authors(auth_id)
);
CREATE TABLE Audio_Sample_Singleton(
    st_id int,
    st_name varchar2(20),
    instrument varchar2(20),
    CONSTRAINT "fK_Audio_ST" FOREIGN KEY (st_id) REFERENCES Audio_Samples(sample_id)
);
CREATE TABLE Audio_Sample_Loopable(
    lp_id int ,
    lp_name varchar2(20),
    tempo float,
    num_measures varchar2(10),
    music_key int,
    CONSTRAINT "fK_Audio_LP" FOREIGN KEY (lp_id) REFERENCES Audio_Samples(sample_id)
);
CREATE TABLE Libraries(
    lib_id int NOT NULL,
    lib_name varchar2(20),
    auth_id int,
    description varchar2(250),
    CONSTRAINT "pK_Libaries" PRIMARY KEY (lib_id),
    CONSTRAINT "fK_Libraries" FOREIGN KEY (auth_id) REFERENCES Authors(auth_id)
);
CREATE TABLE Transactions(
    tran_id int UNIQUE NOT NULL,
    cust_id int,
    total numeric(20,2),
    timestamp DATE,
    CONSTRAINT "pK_Transactions" PRIMARY KEY (tran_id),
    CONSTRAINT "fK_Transactions" FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
);
CREATE TABLE Cart(
    cart_id int NOT NULL,
    cust_id int,
    lib_id int,
    as_id int,
    CONSTRAINT "pK_Cart" PRIMARY KEY (cart_id),
    CONSTRAINT "fK_Cart_cust" FOREIGN KEY (cust_id) REFERENCES Customers(cust_id),
    CONSTRAINT "fK_Cart_lib" FOREIGN KEY (lib_id) REFERENCES Libraries(lib_id),
    CONSTRAINT "fK_Cart_sample" FOREIGN KEY (as_id) REFERENCES Audio_Samples(sample_id)
);

INSERT INTO ALL_Users (usernames, passwords, balance) VALUES ('james000', '123jjj', 300.00);
INSERT INTO ALL_Users (usernames, passwords, balance) VALUES ('peter000', '123ppp', 300.00);
--- showcase DEFAULT 0 Constraint
INSERT INTO All_Users (usernames, passwords) VALUES('mike000', '123mmm');
--- showcase NOT NULL constraint
INSERT INTO All_Users (usernames) VALUES('abc111');

SELECT  * FROM All_Users;
INSERT INTO Customers (cust_id, cust_name, cust_user, cust_bal) VALUES (10001, 'James', 'james000', 300);
INSERT INTO Customers (cust_id, cust_name, cust_user, cust_bal) VALUES (10002, 'Peter', 'peter000', 20);
SELECT  * FROM Customers;

--- IF DELETE cust_user first => error because of fK vs pK
DELETE FROM Customers WHERE cust_user = 'james000';
DELETE FROM All_Users WHERE usernames = 'james000';

INSERT INTO Authors (auth_id, auth_name, auth_user) VALUES (30001, 'Mike', 'mike000');