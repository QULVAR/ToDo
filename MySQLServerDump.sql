DROP TABLE IF EXISTS users;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `lastUpdate` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);


DROP TABLE IF EXISTS folders;
CREATE TABLE `folders` (
  `id` int NOT NULL,
  `user` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `folders_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`)
);

DROP TABLE IF EXISTS languages;
CREATE TABLE `languages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO languages (id, name) VALUES
(1, 'English'),
(2, 'Русский');

DROP TABLE IF EXISTS lists;
CREATE TABLE `lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `folder` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `folder` (`folder`),
  CONSTRAINT `lists_ibfk_1` FOREIGN KEY (`folder`) REFERENCES `folders` (`id`)
);

DROP TABLE IF EXISTS tasks;
CREATE TABLE `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `list` (`list`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`list`) REFERENCES `lists` (`id`)
);

DROP TABLE IF EXISTS taskProperties;
CREATE TABLE `taskProperties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task` int NOT NULL,
  `description` text,
  `timestamp` int DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS settings;
CREATE TABLE `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `folder` int NOT NULL DEFAULT '1',
  `standartFolder` int DEFAULT NULL,
  `list` int NOT NULL DEFAULT '1',
  `standartList` int DEFAULT NULL,
  `notifications` int NOT NULL DEFAULT '1',
  `timeUntilEnd` int NOT NULL DEFAULT '10800',
  `language` int NOT NULL DEFAULT '0',
  `warningBeforeComplete` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `standartFolder` (`standartFolder`),
  KEY `standartList` (`standartList`),
  KEY `language` (`language`),
  CONSTRAINT `settings_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`),
  CONSTRAINT `settings_ibfk_2` FOREIGN KEY (`standartFolder`) REFERENCES `folders` (`id`),
  CONSTRAINT `settings_ibfk_3` FOREIGN KEY (`standartList`) REFERENCES `lists` (`id`),
  CONSTRAINT `settings_ibfk_4` FOREIGN KEY (`language`) REFERENCES `languages` (`id`)
);