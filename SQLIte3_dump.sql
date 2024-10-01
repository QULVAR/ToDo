DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  login TEXT NOT NULL,
  password TEXT NOT NULL,
  lastUpdate TEXT NOT NULL
);

DROP TABLE IF EXISTS folders;
CREATE TABLE folders (
  id INTEGER PRIMARY KEY,
  user INTEGER NOT NULL,
  name TEXT,
  color TEXT,
  FOREIGN KEY (user) REFERENCES users (id)
);

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
  id INTEGER PRIMARY KEY,
  name TEXT
);

INSERT INTO languages (id, name) VALUES
(1, 'English'),
(2, 'Русский');

DROP TABLE IF EXISTS lists;
CREATE TABLE lists (
  id INTEGER PRIMARY KEY,
  folder INTEGER NOT NULL,
  name TEXT NOT NULL,
  color TEXT,
  FOREIGN KEY (folder) REFERENCES folders (id)
);

DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  list INTEGER NOT NULL,
  name TEXT NOT NULL,
  color TEXT,
  FOREIGN KEY (list) REFERENCES lists (id)
);

DROP TABLE IF EXISTS taskProperties;
CREATE TABLE taskProperties (
  id INTEGER PRIMARY KEY,
  task INTEGER NOT NULL,
  description TEXT,
  timestamp INTEGER
);

DROP TABLE IF EXISTS settings;
CREATE TABLE settings (
  id INTEGER PRIMARY KEY,
  user INTEGER NOT NULL,
  folder INTEGER NOT NULL DEFAULT 1,
  standartFolder INTEGER,
  list INTEGER NOT NULL DEFAULT 1,
  standartList INTEGER,
  notifications INTEGER NOT NULL DEFAULT 1,
  timeUntilEnd INTEGER NOT NULL DEFAULT 10800,
  language INTEGER NOT NULL DEFAULT 0,
  warningBeforeComplete INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (user) REFERENCES users (id),
  FOREIGN KEY (standartFolder) REFERENCES folders (id),
  FOREIGN KEY (standartList) REFERENCES lists (id),
  FOREIGN KEY (language) REFERENCES languages (id)
);