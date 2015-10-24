-- Generation Time: Sep 10, 2015
-- Server version: 5.6.17
-- PHP Version: 5.5.12

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`) VALUES
(1, 'group test'),
(2, 'Développeur'),
(3, 'Minus et Cortex');

-- --------------------------------------------------------

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id`, `name`, `progress`, `description`, `duration`, `date_begin`, `date_end`, `status`) VALUES
(5, 'Project Handler', 60, 'Solution logicielle collaborative, open source et gratuite.\r\ngestion de projet simple et complète.\r\nvisant PME plutôt.\r\n', 546, '2014-09-01', '2016-02-29', 'STATUS_ACTIVE'),
(6, 'Site vitrine', 100, 'Site vitrine de Project Handler', 72, '2015-02-02', '2015-05-14', 'STATUS_DONE'),
(7, 'Tenter de conquérir le monde !', 0, 'Minus et Cortex veulent conquérir le monde !', 27, '2015-09-04', '2015-10-13', 'STATUS_ACTIVE'),
(8, 'Application Android', 0, 'Application Andorid pour Project Handler', 65, '2015-07-06', '2015-10-03', 'STATUS_ACTIVE'),
(9, 'Application IOS', 0, 'application', 85, '2015-09-07', '2016-01-07', 'STATUS_ACTIVE');

-- --------------------------------------------------------

--
-- Dumping data for table `subtask`
--

INSERT INTO `subtask` (`id`, `description`, `task_id`, `user_id`, `validated`, `taken`) VALUES
(1, 'toto', 136, 1, 0, 0),
(2, 'plop', 136, 1, 0, 0),
(3, 'titi\n', 136, 2, 0, 0),
(4, 'sous tache 1', 132, 1, 0, 0),
(5, 'sous tache', 118, 1, 1, 0);

-- --------------------------------------------------------

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`id`, `name`, `progress`, `description`, `level`, `duration`, `starting_date`, `ending_date`, `status`, `project_id`, `row`, `task_priority_id`) VALUES
(75, 'Environnement de développement', 100, 'Installation de l''environnement de développement', 1, 13, '2014-09-01', '2014-09-18', 'STATUS_DONE', 5, 2, NULL),
(76, 'Configuration WAR', 100, 'Configuration pour la création de l''archive web', 1, 13, '2014-09-01', '2014-09-18', 'STATUS_DONE', 5, 3, NULL),
(77, 'Installation Tomcat ', 100, 'Installation Tomcat sur serveur', 1, 13, '2014-09-01', '2014-09-18', 'STATUS_DONE', 5, 4, NULL),
(81, 'Authentication', 100, '', 1, 10, '2015-07-15', '2015-07-29', 'STATUS_DONE', 8, 2, NULL),
(82, 'Home + Menu', 100, '', 1, 5, '2015-07-29', '2015-08-05', 'STATUS_DONE', 8, 3, NULL),
(83, 'NetworkHelper', 100, '', 1, 5, '2015-08-05', '2015-08-12', 'STATUS_DONE', 8, 4, NULL),
(84, 'Projects', 100, '', 1, 16, '2015-08-12', '2015-09-03', 'STATUS_DONE', 8, 5, NULL),
(85, 'Projects List', 100, '', 2, 8, '2015-08-12', '2015-08-22', 'STATUS_DONE', 8, 6, NULL),
(86, 'Project Detail', 100, '', 2, 8, '2015-08-24', '2015-09-03', 'STATUS_DONE', 8, 7, NULL),
(87, 'Tasks', 30, '', 1, 14, '2015-09-03', '2015-09-23', 'STATUS_ACTIVE', 8, 8, NULL),
(88, 'Task sList', 50, '', 2, 7, '2015-09-03', '2015-09-12', 'STATUS_ACTIVE', 8, 9, NULL),
(89, 'Task Detail', 0, '', 2, 7, '2015-09-14', '2015-09-23', 'STATUS_SUSPENDED', 8, 10, NULL),
(90, 'Tickets', 0, '', 1, 8, '2015-09-23', '2015-10-03', 'STATUS_SUSPENDED', 8, 11, NULL),
(91, 'Tickets List', 0, '', 2, 4, '2015-09-23', '2015-09-29', 'STATUS_SUSPENDED', 8, 12, NULL),
(92, 'Ticket Detail', 0, '', 2, 4, '2015-09-29', '2015-10-03', 'STATUS_SUSPENDED', 8, 13, NULL),
(93, 'v0.1', 100, 'Module de session des utilisateurs', 1, 16, '2014-10-10', '2014-11-01', 'STATUS_DONE', 5, 5, NULL),
(101, 'v0.2', 100, 'Module d''administration des utilisateurs', 1, 2, '2014-11-03', '2014-11-05', 'STATUS_DONE', 5, 6, NULL),
(109, 'v0.3', 100, 'Module sécurité', 1, 14, '2014-11-05', '2014-11-25', 'STATUS_DONE', 5, 7, NULL),
(113, 'v0.4', 100, 'Module de gestion des projets', 1, 150, '2014-11-25', '2015-07-01', 'STATUS_ACTIVE', 5, 8, NULL),
(114, 'database', 100, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_DONE', 5, 9, NULL),
(115, 'Model', 100, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_DONE', 5, 10, NULL),
(116, 'DAO', 100, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_DONE', 5, 11, NULL),
(118, 'Service', 100, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_ACTIVE', 5, 12, NULL),
(119, 'Controller', 90, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_ACTIVE', 5, 13, NULL),
(120, 'View', 80, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_ACTIVE', 5, 14, NULL),
(121, 'Tests', 0, '', 2, 1, '2014-11-25', '2014-11-26', 'STATUS_ACTIVE', 5, 15, NULL),
(122, 'v0.5', 0, 'Module de gestion des ressources', 1, 1, '2015-07-01', '2015-07-02', 'STATUS_SUSPENDED', 5, 16, NULL),
(123, 'v0.6', 0, 'Module de gestion du planning', 1, 1, '2015-07-02', '2015-07-03', 'STATUS_SUSPENDED', 5, 17, NULL),
(124, 'v1.1', 0, 'Module de gestion du diagramme de Gantt', 1, 1, '2015-07-03', '2015-07-04', 'STATUS_SUSPENDED', 5, 18, NULL),
(125, 'v1.2', 0, ' Module de gestion de tickets', 1, 1, '2015-07-06', '2015-07-07', 'STATUS_SUSPENDED', 5, 19, NULL),
(126, 'v1.3', 0, 'Module de gestion des documents', 1, 1, '2015-07-07', '2015-07-08', 'STATUS_SUSPENDED', 5, 20, NULL),
(127, 'v2.1', 0, 'Module de communications avec les applications mobiles', 1, 1, '2015-07-08', '2015-07-09', 'STATUS_SUSPENDED', 5, 21, NULL),
(128, 'v2.2', 0, ' Module de notifications', 1, 1, '2015-07-09', '2015-07-10', 'STATUS_SUSPENDED', 5, 22, NULL),
(129, 'Plan', 0, '', 1, 1, '2015-09-04', '2015-09-05', 'STATUS_ACTIVE', 7, 2, NULL),
(130, 'Task 3', 0, '', 1, 1, '2015-09-04', '2015-09-05', 'STATUS_ACTIVE', 7, 3, NULL),
(131, 'Milestone', 0, '', 1, 4, '2015-09-07', '2015-09-11', 'STATUS_ACTIVE', 9, 2, NULL),
(132, 'task 1', 0, '', 2, 3, '2015-09-07', '2015-09-10', 'STATUS_ACTIVE', 9, 3, NULL),
(133, 'task2', 0, '', 2, 1, '2015-09-10', '2015-09-11', 'STATUS_SUSPENDED', 9, 4, NULL);

-- --------------------------------------------------------

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `time_stamp`, `user_id`) VALUES
(3, '186ddfb9-a465-4417-9ce8-baf1d8c01b8e', 1416049588886, 10),
(4, '402445ca-2650-46ee-be9d-a906dab09c63', 1435935436351, 51);

-- --------------------------------------------------------

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`, `civility_id`, `work_day`, `daily_hour`, `avatar_file_name`) VALUES
(1, 'Admin', 'Admin', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'admin@admin.com', NULL, '0123456789', '', 0, 1, NULL, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(2, 'Guillard', 'Arthur', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'arthur.guillard@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '2_4a2a6d25-9637-4d93-a81c-134382c0e502.png'),
(3, 'Cyril', 'Fillatre', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'cyril.fillatre@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'ttttttf', '09:00 AM - 05:00 PM', '3_ef03093e-deed-4243-97ed-f7d150e80281.jpg'),
(4, 'Lukas', 'Fauser', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'lukas.fauser@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '4_6dc38e85-dcd0-4713-8790-05ab652a65e0.jpg'),
(5, 'Guillaume', 'Roncari', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'guillaume.roncari@example.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '5_5bd1238d-3b04-4886-9129-64873e2e7a8e.png'),
(6, 'Paul', 'Peyrefitte', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'paul.peyrefitte@example.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '6_e5cb6525-d2f8-4a10-bc21-c84107c3f5a5.png'),
(7, 'Cortex', 'CORTEX', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'cortex@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '7_5f1aa936-fee2-4a14-ab8c-a8ea99134b74.jpg'),
(8, 'Minus', 'MINUS', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'minus@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '8_8fb621b5-872c-4ab9-b9ab-1bc37ef18415.jpg'),
(51, 'test', 'test', '$2a$10$a9VC.a4ZcXvPeq3TdKhT9ONgK05Kd96mhArMD.Yyk4upZipZkLSAa', 'test@test.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL);

-- --------------------------------------------------------

--
-- Dumping data for table `users_groups`
--

INSERT INTO `users_groups` (`users_id`, `groups_id`) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3);

-- --------------------------------------------------------

--
-- Dumping data for table `users_projects`
--

INSERT INTO `users_projects` (`user_id`, `project_id`) VALUES
(1, 5),
(2, 5),
(3, 5),
(4, 5),
(5, 5),
(6, 5),
(1, 6),
(5, 6),
(1, 7),
(7, 7),
(1, 8),
(3, 8),
(1, 9),
(3, 9),
(4, 9),
(5, 9),
(6, 9);

-- --------------------------------------------------------

--
-- Dumping data for table `users_tasks`
--

INSERT INTO `users_tasks` (`users_id`, `tasks_id`) VALUES
(4, 132);

-- --------------------------------------------------------

--
-- Dumping data for table `depend_tasks`
--

INSERT INTO `depend_tasks` (`task_id1`, `task_id2`) VALUES
(82, 81),
(83, 82),
(84, 83),
(87, 84),
(86, 85),
(90, 87),
(89, 88),
(92, 91),
(124, 123),
(127, 126),
(133, 132);


-- --------------------------------------------------------
