create database 1BF25CS074;
use 1BF25CS074;
CREATE TABLE Suppliers (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(30)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10, 2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Suppliers(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Suppliers (sid, sname, city) VALUES
(10001, 'Acme Widget','Bangalore'),
(10002,'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO Parts (pid, pname, color) VALUES
(20001, 'Book','Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil','Green'),
(20004,'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO Catalog (sid, pid, cost) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid;

SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT P.pid
    FROM Parts P
    WHERE NOT EXISTS (
        SELECT C.pid
        FROM Catalog C
        WHERE C.sid = S.sid  AND C.pid = P.pid
    )
);
SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT P.pid
    FROM Parts P
    WHERE P.color = 'Red'
    AND NOT EXISTS (
        SELECT C.pid
        FROM Catalog C
        WHERE C.sid = S.sid AND C.pid = P.pid
    )
);
SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE S.sname LIKE 'Acme Widget%'
AND P.pid NOT IN (
    SELECT C1.pid
    FROM Catalog C1
    JOIN Suppliers S1 ON C1.sid = S1.sid
    WHERE S1.sname NOT LIKE 'Acme Widget%'
);
SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost > (
    SELECT AVG(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = C.pid
);
SELECT P.pid, P.pname, S.sname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid
);
SELECT C.pid
FROM Catalog C, Suppliers S, Parts P
WHERE C.sid = S.sid  AND C.pid = P.pid;
        
SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Parts P ON C.pid = P.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (SELECT MAX(cost) FROM Catalog);

SELECT S.sid, S.sname
FROM Suppliers S
WHERE S.sid NOT IN (
    SELECT C.sid
    FROM Catalog C
    JOIN Parts P ON C.pid = P.pid
    WHERE P.color = 'Red'
);
SELECT S.sid, S.sname, COALESCE(SUM(C.cost), 0) AS total_value
FROM Suppliers S
LEFT JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT S.sid, S.sname
FROM Suppliers S
JOIN Catalog C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(C.pid) >= 2;

SELECT P.pid, P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MIN(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid
);
CREATE VIEW MostExpensiveSuppliers AS
SELECT P.pid, P.pname, S.sid, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid
);

SELECT * FROM EXPENSIVE_SUPPLIER;
