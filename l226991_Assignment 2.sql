--Data
CREATE TABLE Users (
    UserID INT,
	CHECK (UserID > 0),
    Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(6),
	CHECK (Gender IN ('male','female','M','F')),
    BDate DATE,
    Email VARCHAR(50) UNIQUE NOT NULL,
	PRIMARY KEY (UserID),
);
CREATE TABLE Boards (
    BoardID INT,
	CHECK (BoardID > 0),
    UserID INT,
	CHECK (UserID > 0),
    Name VARCHAR(50) NOT NULL,
	PRIMARY KEY (BoardID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Pins (
    PinID INT,
	CHECK (PinID > 0),
    BoardID INT,
	CHECK (BoardID > 0),
    Info VARCHAR(100),
    URL VARCHAR(50),
	CHECK (URL LIKE 'http://%'),
    D DATE,
	PRIMARY KEY (PinID),
    FOREIGN KEY (BoardID) REFERENCES Boards(BoardID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Comments (
    CommentID INT,
	CHECK (CommentID > 0),
    PinID INT,
	CHECK (PinID > 0),
    UserID INT,
    Text VARCHAR(200),
    D DATE,
	PRIMARY KEY (CommentID),
    FOREIGN KEY (PinID) REFERENCES Pins(PinID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL ON UPDATE SET NULL
);
CREATE TABLE Likes (
    PinID INT,
	CHECK (PinID > 0),
    UserID INT,
	CHECK (UserID > 0),
    FOREIGN KEY (PinID) REFERENCES Pins(PinID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	PRIMARY KEY (PinID, UserID),
);

--Question no.2

INSERT INTO Users (UserID, Name, Gender, BDate, Email) VALUES
(100, 'Dua Lipa', 'Female', '1990-05-15', 'dual@email.com'),
(101, 'Tony Mahfud', 'Male', '2023-08-20', 'TMahfud@email.com'),
(102, 'Zenab Farooq', 'Female', '2005-03-10', 'gossip@email.com'),
(103, 'Ali Zaid', 'Male', '1998-12-01', 'ali.zaid@email.com'),
(104, 'Abdullah Mirza', 'Female', '2012-06-25', 'helloLove@email.com');

INSERT INTO Boards (BoardID, UserID, Name) VALUES
(21, 101, 'Dance'),
(22, 100, 'Gadgets'),
(23, 104, 'Anime'),
(24, 103, 'Art'),
(25, 100, 'Music');

INSERT INTO Pins (PinID, BoardID, Info, URL, D) VALUES
(51, 21, 'Free Style', 'http://FreeStyle.jpg', '2022-01-10'),
(52, 21, 'Tango', 'http://Tango.jpg', '2022-02-15'),
(53, 23, 'Death Note', 'http://DeathNote.jpg', '2022-03-20'),
(54, 24, 'Mona Lisa', 'http://MonaLisa.jpg', '2023-04-25'),
(55, 25, 'Bekaar Dil', 'http://BekaarDil-Fighter.jpg', '2022-05-01'),
(56, 23, 'Attack on Titan', 'http://AOT.jpg', '2023-06-10');

INSERT INTO Comments (CommentID, PinID, UserID, Text, D) VALUES
(91, 51, 102, 'Ew Cringe!!', '2023-01-11'),
(92, 53, 101, 'GOAT', '2023-03-21'),
(93, 54, 103, 'Slayyyy!!!', '2023-04-26'),
(94, 55, 100, 'Such a cool Vibe', '2023-05-02'),
(95, 56, 104, 'Over Hyped', '2023-02-01'),
(96, 56, 104, 'Where can I find English sutitles?', '2023-07-06');

INSERT INTO Likes (PinID, UserID) VALUES
(51, 102),
(52, 103),
(53, 100),
(54, 100),
(55, 102),
(56, 101);

--Question no. 1
--a.

CREATE VIEW UserPinCount AS
SELECT Users.Name,Count(Pins.PinID) AS PinCount
FROM Users join Boards on Users.UserID= Boards.UserID join Pins on Boards.BoardID = Pins.BoardID
WHERE Users.UserID IN
               (
			   SELECT Boards.UserID
			   FROM Boards
			   WHERE Boards.BoardID IN
			                      (
								  SELECT TOP 10 Pins.BoardID
								  FROM Pins
								  Group BY Pins.BoardID
								  ORDER BY Count(PinID) DESC
								  )
			   )
Group BY Users.Name;

SELECT *
FROM UserPinCount
WHERE PinCount IN
              (
              SELECT MAX(PinCount)
              FROM UserPinCount
			  );

--b.
SELECT Pins.Info,Count(Likes.PinID) AS LikesCount
FROM Likes join Pins on Pins.PinID = Likes.PinID
WHERE EXISTS 
    (SELECT PinID
	FROM Likes
	GROUP BY PinID
	Having (count(PinID)) > 10
	)
GROUP BY Pins.Info;

--c.
SELECT Boards.BoardID,Info
FROM Boards left join Pins on Pins.BoardID = Boards.BoardID
WHERE Boards.BoardID IN 
                  (
				  SELECT Pins.BoardID
				  FROM Pins
				  WHERE Pins.BoardID = Boards.BoardID
				  );

--d.
SELECT P.PinID
FROM Pins AS P
WHERE 
     (SELECT COUNT(PinID)
	  FROM Likes
	  WHERE P.PinID = Likes.PinID
	 ) = (
	 SELECT COUNT(PinID)
	 FROM Comments
	 WHERE P.PinID = Comments.PinID
	 );

--e.
SELECT Users.*
FROM Users join Likes on Likes.UserID = Users.UserID
WHERE Likes.PinID =
       (
	   SELECT Likes.PinID
	   From Likes join Pins on Likes.PinID=Pins.PinID join Boards on Boards.BoardID = Pins.BoardID
	   WHERE Boards.UserID = 100
	   );

--f.
SELECT DISTINCT U.*
FROM Users As U join Comments As C on U.UserID = C.UserID 
WHERE U.UserID IN
     (SELECT U1.UserID
	  FROM Users As U1 join Comments As C1 on U1.UserID = C1.UserID
	  WHERE C.PinID = C1.PinID AND U1.UserID <> U.UserID
	 );

--g.
SELECT U.Name,DATEDIFF(year,U.BDate,GETDATE()) As Age
FROM Users As U
WHERE DATEDIFF(year,U.BDate,GETDATE()) >
           (
            SELECT avg((DATEDIFF(year,Users.BDate,GETDATE())))
            FROM Users
           );

--h.
CREATE VIEW BoardNum AS
	 SELECT B1.BoardID,Count (B1.BoardID) As NumIDs
	 FROM Pins As P join Boards As B1  on P.BoardID = B1.BoardID
	 WHERE year(P.D) = 2022
	 Group By B1.BoardID;

SELECT BoardNum.BoardID
FROM BoardNum
WHERE NumIDs IN
           (
		   SELECT Min(BoardNum.NumIDs)
		   FROM BoardNum
		   );

--i.
CREATE VIEW BoardNum2 AS
	 SELECT TOP 100 B1.BoardID,Count (B1.BoardID) As NumIDs
	 FROM Pins As P join Boards As B1  on P.BoardID = B1.BoardID
	 Group By B1.BoardID
	 ORDER BY Count (B1.BoardID) DESC

SELECT TOP 3 BoardNum2.BoardID
FROM BoardNum2
WHERE NumIDs IN
           (
		   SELECT (BoardNum2.NumIDs)
		   FROM BoardNum2
		   );

--j.
SELECT DISTINCT U.Name
FROM Users As U
WHERE U.UserID IN 
            (
			SELECT C.UserID
			FROM Comments AS C
			);

--k.
SELECT B.Name
FROM Boards As B
WHERE 
      (
      SELECT Count(P.BoardID)
	  FROM Pins As P
	  WHERE B.BoardID = P.BoardID
	  ) = 5;

--Question no.2
--a.
CREATE VIEW UserBoardsView AS
   SELECT U.UserID,U.Name,B.BoardID
   FROM Users As U left join Boards As B on U.UserID = B.UserID;

--b.
CREATE VIEW PopularPinsView AS
   SELECT L.PinID,Count(PinID)
   FROM Likes As L
   Group By PinID

--c.
CREATE VIEW UserActivityView AS
   SELECT U.UserID,U.Name,C.Text,P.*
   FROM Users As U join Comments As C on U.UserID = C.UserID join Pins As P on P.PinID = C.PinID

--d.
CREATE VIEW BoardDetailsView AS
   SELECT B.Name,P.Info, Count(Likes.PinID) As likeCount
   FROM Boards As B join Pins As P on P.BoardID = B.BoardID join Likes on P.PinID = Likes.PinID
   Group By Likes.PinID,B.Name,P.Info
   HAVING Count (P.BoardID) > 10;

--Question no. 3
--a.
--Creating the table first
CREATE TABLE PinActivityLog (
    log_id INT PRIMARY KEY,
    pin_id INT,
    activity_type VARCHAR(50),
    FOREIGN KEY (pin_id) REFERENCES Pins(PinID)
);
CREATE TRIGGER NewPinTrigger
AFTER INSERT ON Pins
FOR EACH ROW
BEGIN
    INSERT INTO PinActivityLog (pin_id, activity_type)
    VALUES (PinID, 'New Pin Created');
END;

--b.
CREATE TRIGGER PINLikesTrigger
AFTER INSERT ON Likes
FOR EACH ROW
IF ((SELECT COUNT(*) FROM Likes WHERE PinID = PinID) > 100000) THEN
    SELECT CONCAT('Pin with ID ', PinID, ' has received more than 100000 Likes!') AS Message;
END;

