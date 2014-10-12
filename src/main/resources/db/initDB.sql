-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2014 at 08:11 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `project_handler`
--

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE IF NOT EXISTS `address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `street_number` varchar(10) CHARACTER SET utf8 NOT NULL,
  `street_name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `city` varchar(30) CHARACTER SET utf8 NOT NULL,
  `zipcode` varchar(5) CHARACTER SET utf8 NOT NULL,
  `country` varchar(30) CHARACTER SET utf8 NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`id`, `street_number`, `street_name`, `city`, `zipcode`, `country`, `user_id`) VALUES
(1, '17', 'avenue niel', 'paris', '75017', 'france', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `last_name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `password` varchar(70) CHARACTER SET utf8 NOT NULL,
  `email` varchar(30) CHARACTER SET utf8 NOT NULL,
  `address` bigint(20) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `mobile_phone` varchar(10) DEFAULT NULL,
  `user_role` int(11) NOT NULL DEFAULT '1',
  `account_status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `address` (`address`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`) VALUES
(1, 'Bruce', 'Wayne', '1234', 'bruce.wayne@batman.com', 1, NULL, NULL, 1, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`address`) REFERENCES `address` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
