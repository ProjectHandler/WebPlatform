
--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`) VALUES
(8, 'Superméchants'),
(9, 'Conférence');

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id`, `name`, `progress`, `description`, `duration`, `date_begin`, `date_end`, `status`) VALUES
(21, 'Gantter', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop p', 781, '2015-08-17', '2017-10-06', 'STATUS_ACTIVE'),
(22, 'Machine à sous démente', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 56, '2015-08-28', '2015-11-14', 'STATUS_ACTIVE'),
(23, 'test', 0, 's opposed to using ''Content here, content here'', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a sear', 1, '2015-08-28', '2015-08-29', 'STATUS_ACTIVE'),
(24, 'test2', 0, 'qsdqdq', 28, '2015-02-28', '2015-03-28', 'STATUS_ACTIVE');

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`id`, `name`, `progress`, `description`, `level`, `duration`, `starting_date`, `ending_date`, `status`, `project_id`, `row`, `task_priority_id`) VALUES
(67, 'Mile1', 0, '', 1, 73, '2015-08-17', '2015-11-26', 'STATUS_ACTIVE', 21, 2, NULL),
(68, 'Task1', 100, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 2, 15, '2015-08-28', '2015-09-18', 'STATUS_DONE', 21, 3, NULL),
(69, 'Task2', 45, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 2, 49, '2015-09-18', '2015-11-26', 'STATUS_ACTIVE', 21, 4, NULL),
(70, 'Mile2', 0, '', 1, 26, '2015-09-18', '2015-10-24', 'STATUS_ACTIVE', 21, 5, NULL),
(71, 'Task3', 16, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 2, 15, '2015-09-18', '2015-10-09', 'STATUS_ACTIVE', 21, 6, NULL),
(72, 'Task4', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 2, 11, '2015-10-09', '2015-10-24', 'STATUS_SUSPENDED', 21, 7, NULL),
(73, 'Task5', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ', 2, 11, '2015-10-09', '2015-10-24', 'STATUS_SUSPENDED', 21, 8, NULL),
(74, 'Mile1', 0, '', 1, 27, '2015-08-28', '2015-10-06', 'STATUS_ACTIVE', 22, 2, NULL),
(75, 'Task1', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since ', 2, 16, '2015-08-28', '2015-09-19', 'STATUS_DONE', 22, 3, NULL),
(76, 'Task2', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since ', 2, 11, '2015-09-21', '2015-10-06', 'STATUS_DONE', 22, 4, NULL),
(77, 'Mile2', 0, '', 1, 35, '2015-09-21', '2015-11-07', 'STATUS_ACTIVE', 22, 5, NULL),
(78, 'Task7', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since ', 2, 10, '2015-09-21', '2015-10-03', 'STATUS_FAILED', 22, 6, NULL),
(79, 'Last Move', 0, '', 2, 24, '2015-10-06', '2015-11-07', 'STATUS_ACTIVE', 22, 7, NULL);


-- --------------------------------------------------------

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `time_stamp`, `user_id`) VALUES
(3, '186ddfb9-a465-4417-9ce8-baf1d8c01b8e', 1416049588886, 10);


--
-- Dumping data for table `address`
--

INSERT INTO `address` (`id`, `street_number`, `street_name`, `city`, `zipcode`, `country`, `user_id`) VALUES
(2, '31', 'Herberton Park', 'Dublin', '8', 'Ireland', 11),
(3, '48', 'Rue polisson', 'Meûtière-en-Veuhlu', '789', 'Luxembourg', 12),
(4, '67', 'Rue Jean-seb', 'Boursouflé-en-Vesace', '92220', 'France', 13);

-- --------------------------------------------------------

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`, `civility_id`, `work_day`, `daily_hour`, `avatar_file_name`) VALUES
(10, 'User1', 'Spiderman', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user1@example.com', 2, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(11, 'Admin', 'Admin', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'admin@admin.com', NULL, '0123456789', '', 0, 1, NULL, 'tttttff', '09:00 AM - 05:00 PM', '11_0df71b3d-7dcc-4ab8-85a0-90651553a714.jpg'),
(12, 'User2', 'Batman', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user2@example.com', 3, '01000001', '06000001', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(13, 'User3', 'Superman', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user3@example.com', 3, '0133449978', '0612546879', 1, 1, 2, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(15, 'User5', 'Hulk', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user5@example.com', 4, '07888888', '06888888', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(16, 'User6', 'Wonder Woman', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user6@example.com', 3, '1111111111', '6666666666', 1, 0, 2, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(17, 'User7', 'Ribéry', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user7@example.com', 2, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(18, 'User8', 'Zlatan', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user8@example.com', 3, '01000001', '06000001', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(19, 'User9', 'Zidane', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user9@example.com', 3, '0133449978', '0612546879', 1, 1, 2, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(20, 'User10', 'Zlutine', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user10@example.com', 2, '0198877665', '0698877665', 1, 1, 3, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(21, 'User11', 'Minus', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user11@example.com', 4, '07888888', '06888888', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(22, 'User12', 'Cortex', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user12@example.com', 3, '1111111111', '6666666666', 1, 1, 2, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(23, 'User13', 'Mechant', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'user13@example.com', 3, '1111111111', '6666666666', 1, 1, 2, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(24, 'Guillard', 'Arthur', '$2a$10$H6CPJ6JiF93AMuPR257Cr.5tj0eU1LzX0uLp5otT0ukYFib1i6n7.', 'arthur.guillard@gmail.com', NULL, '0606060606', '', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL);


--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `title`, `text`, `ticket_status`, `user_id`, `project_id`, `ticket_priority_id`, `ticket_tracker_id`, `created_at`, `updated_at`) VALUES
(10, 'Lorem ipsum', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a', 1, 11, 21, 5, NULL, '2015-08-27 23:28:03', '2015-08-27 23:28:03'),
(11, 'Mathieu valbuena', 't of the printing and typesetting indus', 1, 11, 21, 6, NULL, '2015-08-27 23:28:51', '2015-08-27 23:28:51'),
(12, 'Problème d''eau', 'De l''eau de pluie de l''eau de là haut', 1, 11, 21, 5, NULL, '2015-08-27 23:29:36', '2015-08-27 23:29:36'),
(13, 'Minus et Cortex', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since ', 1, 11, 22, 5, NULL, '2015-08-27 23:39:02', '2015-08-27 23:39:02');

-- --------------------------------------------------------

--
-- Dumping data for table `ticket_messages`
--

INSERT INTO `ticket_messages` (`id`, `ticket_id`, `user_id`, `created_at`, `updated_at`, `text`) VALUES
(16, 10, 11, '2015-08-27 23:28:11', '2015-08-27 23:28:11', 'Lorem Ipsum is simply dummy'),
(17, 10, 11, '2015-08-27 23:28:17', '2015-08-27 23:28:17', 'n an unknown printer took a'),
(18, 10, 11, '2015-08-27 23:28:21', '2015-08-27 23:28:21', 't of the printing and typesetting indus'),
(19, 11, 11, '2015-08-27 23:28:57', '2015-08-27 23:28:57', 'Mais lol!'),
(20, 11, 11, '2015-08-27 23:29:01', '2015-08-27 23:29:01', ';)'),
(21, 12, 11, '2015-08-27 23:29:46', '2015-08-27 23:29:46', 'et le soleil blanc sur ta peau?'),
(22, 12, 11, '2015-08-27 23:29:53', '2015-08-27 23:29:53', 'tululu tululululu'),
(23, 12, 11, '2015-08-27 23:30:00', '2015-08-27 23:30:00', 'et que de que de que!!'),
(24, 13, 11, '2015-08-27 23:39:20', '2015-08-27 23:39:20', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since '),
(25, 13, 11, '2015-08-27 23:39:25', '2015-08-27 23:39:25', 'Lorem Ipsum is simply dummy '),
(26, 13, 11, '2015-08-27 23:39:29', '2015-08-27 23:39:29', 'ng and typesetting industry. Lore'),
(27, 13, 11, '2015-08-27 23:39:33', '2015-08-27 23:39:33', 'esetting industry. Lorem Ipsum has be');

--
-- Dumping data for table `users_groups`
--

INSERT INTO `users_groups` (`users_id`, `groups_id`) VALUES
(10, 4),
(11, 4),
(12, 4),
(13, 4),
(15, 4),
(16, 4),
(11, 5),
(17, 5),
(18, 5),
(19, 5),
(11, 7),
(21, 7),
(22, 7),
(21, 8),
(22, 8),
(23, 8);

--
-- Dumping data for table `users_projects`
--

INSERT INTO `users_projects` (`user_id`, `project_id`) VALUES
(10, 21),
(11, 21),
(12, 21),
(13, 21),
(15, 21),
(17, 21),
(18, 21),
(11, 22),
(15, 22),
(21, 22),
(22, 22),
(23, 22),
(11, 23),
(21, 23),
(22, 23),
(23, 23),
(11, 24);

--
-- Dumping data for table `users_tasks`
--

INSERT INTO `users_tasks` (`users_id`, `tasks_id`) VALUES
(10, 68),
(13, 69),
(10, 71),
(11, 71),
(12, 71),
(15, 71),
(12, 72),
(17, 72),
(18, 72),
(10, 73),
(17, 73),
(18, 73),
(11, 75),
(15, 75),
(21, 76),
(23, 76),
(11, 78),
(15, 78),
(21, 78),
(22, 78),
(23, 78);

--
-- Dumping data for table `depend_tasks`
--

INSERT INTO `depend_tasks` (`task_id1`, `task_id2`) VALUES
(69, 68),
(71, 68),
(72, 71),
(73, 71),
(76, 75),
(78, 75),
(79, 76);

--
-- Dumping data for table `users_tickets`
--

INSERT INTO `users_tickets` (`user_id`, `ticket_id`) VALUES
(10, 10),
(15, 10),
(17, 10),
(11, 11),
(12, 11),
(15, 11),
(18, 11),
(10, 12),
(13, 12),
(15, 12),
(17, 12),
(11, 13),
(21, 13),
(22, 13);