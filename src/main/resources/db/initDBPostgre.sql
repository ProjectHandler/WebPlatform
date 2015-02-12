-- SQL Dump
-- Host: 127.0.0.1
-- Generation Time: Jan 23, 2015 at 01:01 PM
-- Server version: 9.4.0-1

--
-- Database: `project_handler`
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
-- Table structure for table groups
--

CREATE TABLE IF NOT EXISTS groups (
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

--
-- Dumping data for table tokens
--

INSERT INTO tokens (id, token, time_stamp, user_id) VALUES
(3, '186ddfb9-a465-4417-9ce8-baf1d8c01b8e', 1416049588886, 10);

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
  civility int DEFAULT NULL,
  PRIMARY KEY (id)
);

--
-- Dumping data for table users
--

INSERT INTO users (id, first_name, last_name, password, email, address, phone, mobile_phone, user_role, account_status, civility) VALUES
(11, 'Admin', 'Admin', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'admin@admin.com', NULL, '0123456789', '', 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table users_groups
--

CREATE TABLE IF NOT EXISTS users_groups (
  users_id BIGSERIAL,
  groups_id BIGSERIAL,
  PRIMARY KEY (users_id,groups_id)
);

--
-- Table structure for table project
--

CREATE TABLE IF NOT EXISTS project (
  id BIGSERIAL,
  name varchar(30) NOT NULL,
  description varchar(500) DEFAULT NULL,
  date_begin date DEFAULT NULL,
  date_end date DEFAULT NULL,
  PRIMARY KEY (id)
);

--
-- Table structure for table task
--

CREATE TABLE IF NOT EXISTS task (
  id BIGSERIAL,
  name varchar(30) NOT NULL,
  description varchar(500) DEFAULT NULL,
  starting_date date DEFAULT NULL,
  ending_date date DEFAULT NULL,
  status varchar(30) DEFAULT NULL,
  project_id BIGSERIAL,
  PRIMARY KEY (id)
);

--
-- Table structure for table calendar
--

CREATE TABLE IF NOT EXISTS calendar (
  id BIGSERIAL,
  user_id BIGSERIAL NOT NULL,
  title varchar(255) NOT NULL,
  text text NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  PRIMARY KEY (id)
);

--
-- Constraints for dumped tables
--

--
-- Constraints for table address
--
ALTER TABLE address
  ADD CONSTRAINT address_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table users
--
ALTER TABLE users
  ADD CONSTRAINT users_ibfk_1 FOREIGN KEY (address) REFERENCES address (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table users_groups
--
ALTER TABLE users_groups
  ADD CONSTRAINT users_groups_ibfk_1 FOREIGN KEY (users_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT users_groups_ibfk_2 FOREIGN KEY (groups_id) REFERENCES groups (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table task
-- 
ALTER TABLE task ADD CONSTRAINT projectKey FOREIGN KEY (project_id) REFERENCES project (id) ON DELETE CASCADE;
