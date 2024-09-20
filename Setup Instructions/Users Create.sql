USE dev_UsersDB


-- DROP TABLE Users;
CREATE TABLE Users(
   Id INT IDENTITY(1,1) PRIMARY KEY,
   FirstName VARCHAR(50),
   LastName VARCHAR(50),
   Email VARCHAR(50) NOT NULL,
   Username VARCHAR(50) NOT NULL,
   UserSecret VARCHAR(50) NOT NULL,
   CreatedAt DATETIME,
   UpdatedAt DATETIME,
);

-- DROP TABLE Follows;
CREATE TABLE Follows(
    FollowerId INT,
    FollowedId INT,
    FollowedAt DATETIME,
    PRIMARY KEY (FollowerId,FollowedId),
    FOREIGN KEY (FollowerId) REFERENCES Users(Id),
    FOREIGN KEY (FollowedId) REFERENCES Users(Id),
);

CREATE TABLE Likes(
    UserId INT,
    AudioId INT,
    LikedAt DATETIME,
    PRIMARY KEY (UserId,AudioId),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
	CONSTRAINT UQ_Likes_Audios UNIQUE (UserId,AudioId)
);

CREATE TABLE History(
    UserId INT,
    AudioId INT,
    ListenedAt DATETIME,
    PRIMARY KEY (UserId,AudioId),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
);






select * from Likes