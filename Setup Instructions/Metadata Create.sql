
USE dev_MetadataDB



DROP TABLE Visibilities;
DROP TABLE Statuses
DROP TABLE Audios;



--CREATE TABLE Statuses(
--	[Id] INT PRIMARY KEY IDENTITY(1,1),
--	[Status] VARCHAR(63) NOT NULL UNIQUE,
--	[Description] VARCHAR(255)
--);
--GO

-- INSERT INTO Statuses ([Status], [Description])
-- VALUES ('READY', 'This audio is available for use.'),
--        ('UPLOADING', 'This audio is being uploaded.'),
--        ('PROCESSING', 'This audio is being processed.'),
--        ('DELETED', 'This audio has been deleted by the owner.');


 --CREATE TABLE Visibilities(
 --	[Id] INT PRIMARY KEY IDENTITY(1,1),
 --	[Visibility] VARCHAR(63) NOT NULL UNIQUE,
 --	[Description] VARCHAR(255)
 --);
 --GO


 --INSERT INTO Visibilities ([Visibility], [Description])
 --VALUES ('Public', 'This audio is accessible to everyone.'),
 --       ('Private', 'This audio is only visible to you.'),
 --       ('Unlisted', 'This audio is not publicly listed but can be accessed with a direct link.');

 --delete from Visibilities;


CREATE TABLE Audios(
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Title] NVARCHAR(127),
	[Description] NVARCHAR(1023) DEFAULT '',
	[Thumbnail] VARBINARY(MAX) NULL,
	[DurationSec] INT NOT NULL,
	[FileSize] BIGINT,
	[FileType] NVARCHAR(32),
	[FileChecksum] VARBINARY(16),
	[Listens] INT,
	[StatusId] INT,
	[VisibilityId] INT,
	[UploadedAt] DATETIME DEFAULT GETDATE(),
	[UploaderId] INT,
    FOREIGN KEY ([StatusId]) REFERENCES Statuses(Id),
    FOREIGN KEY ([VisibilityId]) REFERENCES Visibilities(Id)
);
GO

--CREATE TABLE Tags(
--	Id INT PRIMARY KEY IDENTITY(1,1),
--	AudioId INT,
--	Tag NVARCHAR(100),
--	CONSTRAINT FK_Tags_Audios FOREIGN KEY (AudioId) REFERENCES Audios(Id) ON DELETE CASCADE,
--	CONSTRAINT UQ_Tags_AudioId_Tag UNIQUE (AudioId, Tag)
--)



--drop table Listens
--Create Table Listens(
--	Id INT PRIMARY KEY IDENTITY(1,1),
--	AudioId INT,
--	UserId INT,
--	ListenedAt DATETIME DEFAULT GETDATE(),
--	CONSTRAINT FK_Listens_Audios FOREIGN KEY (AudioId) REFERENCES Audios(Id) ON DELETE CASCADE
--)



select * from Visibilities

INSERT INTO Audios (Title, Description, DurationSec, FileSize, FileType, VisibilityId)
VALUES ('Example Title', 'Example Description', 180, 1024, 'mp3', 1);

select * from Audios

select * from tags
SELECT * FROM LISTENS


select * from Visibilities