-- SQL Dump
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2015 at 09:49 PM
-- Server version: 9.4.0-1

--
-- Database: project_handler
--

DROP DATABASE project_handler;

CREATE DATABASE project_handler
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United Kingdom.1252'
       LC_CTYPE = 'English_United Kingdom.1252'
       CONNECTION LIMIT = -1;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE IF NOT EXISTS address (
  id BIGSERIAL,
  street_number varchar(10) NOT NULL,
  street_name varchar(30) NOT NULL,
  city varchar(30) NOT NULL,
  zipcode varchar(5) NOT NULL,
  country varchar(30) NOT NULL,
  user_id bigint DEFAULT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table civility
--

CREATE TABLE IF NOT EXISTS civility (
  id BIGSERIAL,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table depend_tasks
--

CREATE TABLE IF NOT EXISTS depend_tasks (
  task_id1 BIGSERIAL,
  task_id2 BIGSERIAL,
  PRIMARY KEY (task_id1,task_id2)
);

-- --------------------------------------------------------

--
-- Table structure for table groups
--

CREATE TABLE IF NOT EXISTS groups (
  id BIGSERIAL,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table project
--

CREATE TABLE IF NOT EXISTS project (
  id BIGSERIAL,
  name varchar(30) NOT NULL,
  progress bigint NOT NULL,
  description varchar(500) DEFAULT NULL,
  duration bigint NOT NULL,
  date_begin date DEFAULT NULL,
  date_end date DEFAULT NULL,
  status varchar(30) NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table task
--

CREATE TABLE IF NOT EXISTS task (
  id BIGSERIAL,
  name varchar(30) NOT NULL,
  progress bigint NOT NULL,
  description varchar(500) DEFAULT NULL,
  level bigint NOT NULL,
  duration bigint NOT NULL,
  starting_date date DEFAULT NULL,
  ending_date date DEFAULT NULL,
  status varchar(30) DEFAULT NULL,
  project_id BIGSERIAL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table tickets
--

CREATE TABLE IF NOT EXISTS tickets (
  id BIGSERIAL,
  title varchar(100) DEFAULT NULL,
  text varchar(500) DEFAULT NULL,
  ticket_status int NOT NULL DEFAULT '1',
  user_id bigint DEFAULT NULL,
  project_id bigint NOT NULL,
  ticket_priority_id bigint DEFAULT NULL,
  ticket_tracker_id bigint DEFAULT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table ticket_messages
--

CREATE TABLE IF NOT EXISTS ticket_messages (
  id BIGSERIAL,
  ticket_id bigint NOT NULL,
  user_id bigint DEFAULT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  text varchar(500) DEFAULT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table ticket_priority
--

CREATE TABLE IF NOT EXISTS ticket_priority (
  id BIGSERIAL,
  value int NOT NULL,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table ticket_tracker
--

CREATE TABLE IF NOT EXISTS ticket_tracker (
  id BIGSERIAL,
  name varchar(50) NOT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table tokens
--

CREATE TABLE IF NOT EXISTS tokens (
  id BIGSERIAL,
  token varchar(50)  NOT NULL,
  time_stamp bigint NOT NULL DEFAULT '0',
  user_id bigint DEFAULT NULL,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table users
--

CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL,
  first_name varchar(30)  DEFAULT NULL,
  last_name varchar(30)  DEFAULT NULL,
  password varchar(70)  DEFAULT NULL,
  email varchar(30)  NOT NULL,
  address bigint DEFAULT NULL,
  phone varchar(10) DEFAULT NULL,
  mobile_phone varchar(10) DEFAULT NULL,
  user_role int NOT NULL DEFAULT '1',
  account_status int NOT NULL DEFAULT '0',
  civility_id bigint DEFAULT NULL,
  civility int DEFAULT NULL,
  PRIMARY KEY (id)
);

--
-- Dumping data for table users
--

INSERT INTO users (id, first_name, last_name, password, email, address, phone, mobile_phone, user_role, account_status, civility) VALUES
(1, 'Admin', 'Admin', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'admin@admin.com', NULL, '0123456789', '', 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table users_groups
--

CREATE TABLE IF NOT EXISTS users_groups (
  users_id BIGSERIAL,
  groups_id BIGSERIAL,
  PRIMARY KEY (users_id,groups_id)
);

-- --------------------------------------------------------

--
-- Table structure for table users_projects
--

CREATE TABLE IF NOT EXISTS users_projects (
  user_id bigint,
  project_id bigint,
  PRIMARY KEY (user_id,project_id)
);

-- --------------------------------------------------------

--
-- Table structure for table users_tasks
--

CREATE TABLE IF NOT EXISTS users_tasks (
  users_id bigint,
  tasks_id bigint,
  PRIMARY KEY (users_id,tasks_id)
);

-- --------------------------------------------------------

--
-- Table structure for table users_tickets
--

CREATE TABLE IF NOT EXISTS users_tickets (
  user_id bigint,
  ticket_id bigint,
  PRIMARY KEY (user_id,ticket_id)
);

-- --------------------------------------------------------

--
-- Constraints for dumped tables
--

--
-- Constraints for table address
--
ALTER TABLE address
  ADD CONSTRAINT address_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table depend_tasks
--
ALTER TABLE depend_tasks
  ADD CONSTRAINT depend_tasks_ibfk_1 FOREIGN KEY (task_id1) REFERENCES task (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT depend_tasks_ibfk_2 FOREIGN KEY (task_id2) REFERENCES task (id) ON DELETE CASCADE ON UPDATE CASCADE;
 
--
-- Constraints for table tickets
--
ALTER TABLE tickets
  ADD CONSTRAINT ticket_tracker_ibfk FOREIGN KEY (ticket_tracker_id) REFERENCES ticket_tracker (id),
  ADD CONSTRAINT fk_ticket_project FOREIGN KEY (project_id) REFERENCES project (id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  ADD CONSTRAINT ticket_priority_ibkf FOREIGN KEY (ticket_priority_id) REFERENCES ticket_priority (id);
  
--
-- Constraints for table ticket_messages
--
ALTER TABLE ticket_messages
  ADD CONSTRAINT fk_ticketmessage_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_ticketmessage_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE CASCADE;

--
-- Constraints for table users
--
ALTER TABLE users
  ADD CONSTRAINT civility_ibfk FOREIGN KEY (civility_id) REFERENCES civility (id),
  ADD CONSTRAINT users_ibfk_1 FOREIGN KEY (address) REFERENCES address (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table users_groups
--
ALTER TABLE users_groups
  ADD CONSTRAINT users_groups_ibfk_1 FOREIGN KEY (users_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT users_groups_ibfk_2 FOREIGN KEY (groups_id) REFERENCES groups (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table users_tasks
--
ALTER TABLE users_tasks
  ADD CONSTRAINT users_tasks_ibfk_2 FOREIGN KEY (tasks_id) REFERENCES task (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT users_tasks_ibfk_1 FOREIGN KEY (users_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table users_tickets
--
ALTER TABLE users_tickets
  ADD CONSTRAINT users_tickets_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (id),
  ADD CONSTRAINT users_tickets_ibfk_2 FOREIGN KEY (ticket_id) REFERENCES tickets (id);
  
  
  
  
  
--
-- alter 
--
 CREATE TABLE IF NOT EXISTS event (
  id BIGSERIAL,
  title varchar(30) NOT NULL,
  description varchar(500) DEFAULT NULL,
  starting_date date NOT NULL,
  ending_date date NOT NULL,
  status varchar(30) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users_events (
  users_id BIGSERIAL,
  events_id BIGSERIAL,
  PRIMARY KEY (users_id,events_id)
);

ALTER TABLE users_events
  ADD CONSTRAINT users_events_ibfk_2 FOREIGN KEY (events_id) REFERENCES event (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT users_events_ibfk_1 FOREIGN KEY (users_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE users DROP civility;

DELETE FROM civility;
INSERT INTO civility(id, name) VALUES 
	(1, 'projecthandler.civility.mister'),
	(2, 'projecthandler.civility.mrs'),
	(3, 'projecthandler.civility.miss');
 
CREATE TABLE IF NOT EXISTS users_projects (
  user_id BIGSERIAL,
  project_id BIGSERIAL,
  PRIMARY KEY (user_id, project_id),
  KEY users_projects_ibfk_2 (project_id)
);

ALTER TABLE users_projects
	ADD CONSTRAINT users_projects_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (id),
 	ADD CONSTRAINT users_projects_ibfk_2 FOREIGN KEY (project_id) REFERENCES project (id);--pb ?!

ALTER TABLE users ADD work_day VARCHAR(32) NOT NULL DEFAULT 'tttttff';
ALTER TABLE users ADD daily_hour VARCHAR(32) NOT NULL DEFAULT '09:00 AM - 05:00 PM';

ALTER TABLE users ADD avatar_file_name VARCHAR(100) NULL DEFAULT NULL ;
ALTER TABLE users ADD avatar_base_64 text NULL DEFAULT NULL ;
