PRAGMA foreign_keys = false;
PRAGMA journal_mode = WAL;

DROP TABLE IF EXISTS "datestrings";

CREATE TABLE [datestrings] (
    [id] integer primary key autoincrement,
    [iso_string] varchar(100) not null
);

