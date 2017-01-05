-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Jan 05, 2017 at 12:58 AM
-- Server version: 5.6.28
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `meetings`
--

-- --------------------------------------------------------

--
-- Table structure for table `additional`
--

CREATE TABLE `additional` (
  `id` int(11) NOT NULL,
  `tid` smallint(3) NOT NULL COMMENT 'type id',
  `name` varchar(32) NOT NULL,
  `value` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `additional`
--

INSERT INTO `additional` (`id`, `tid`, `name`, `value`) VALUES
(1, 1, 'agenda_final', 'http://www.wichita.gov/Government/Council/Agendas/{0}-{1}-{2}%20Final%20City%20Council%20Agenda%20Packet.pdf'),
(2, 2, 'plat_drawings', 'http://www.wichita.gov/Government/Departments/Planning/AgendasMinutes/{0}-{1}-{2}%20Subdivision%20Agenda%20-%20Plat%20drawings.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `date`
--

CREATE TABLE `date` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `tid` smallint(3) NOT NULL COMMENT 'type id',
  `year` smallint(4) UNSIGNED NOT NULL DEFAULT '2017',
  `month` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `day` tinyint(3) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `date`
--

INSERT INTO `date` (`id`, `tid`, `year`, `month`, `day`) VALUES
(1, 1, 2017, 1, 3),
(2, 1, 2017, 1, 10),
(3, 1, 2017, 1, 17),
(4, 1, 2017, 2, 7),
(5, 1, 2017, 2, 14),
(6, 1, 2017, 2, 21),
(7, 1, 2017, 3, 7),
(8, 1, 2017, 3, 21),
(9, 1, 2017, 4, 4),
(10, 1, 2017, 4, 11),
(11, 1, 2017, 4, 18),
(12, 1, 2017, 5, 2),
(13, 1, 2017, 5, 9),
(14, 1, 2017, 5, 16),
(15, 1, 2017, 6, 6),
(16, 1, 2017, 6, 13),
(17, 1, 2017, 6, 20),
(18, 1, 2017, 7, 11),
(19, 1, 2017, 7, 18),
(20, 1, 2017, 8, 1),
(21, 1, 2017, 8, 8),
(22, 1, 2017, 8, 15),
(23, 1, 2017, 9, 5),
(24, 1, 2017, 9, 12),
(25, 1, 2017, 9, 19),
(26, 1, 2017, 10, 3),
(27, 1, 2017, 10, 10),
(28, 1, 2017, 10, 17),
(29, 1, 2017, 11, 7),
(30, 1, 2017, 11, 21),
(31, 1, 2017, 12, 5),
(32, 1, 2017, 12, 12),
(33, 1, 2017, 12, 19),
(45, 2, 2017, 1, 12),
(46, 2, 2017, 1, 26),
(47, 2, 2017, 2, 16),
(48, 2, 2017, 3, 2),
(49, 2, 2017, 3, 16),
(50, 2, 2017, 3, 30),
(51, 2, 2017, 4, 13),
(52, 2, 2017, 4, 27),
(53, 2, 2017, 5, 11),
(54, 2, 2017, 5, 25),
(55, 2, 2017, 6, 15),
(56, 2, 2017, 6, 29),
(57, 2, 2017, 7, 13),
(58, 2, 2017, 7, 27),
(59, 2, 2017, 8, 17),
(60, 2, 2017, 8, 31),
(61, 2, 2017, 9, 14),
(62, 2, 2017, 9, 28),
(63, 2, 2017, 10, 12),
(64, 2, 2017, 10, 26),
(65, 2, 2017, 11, 9),
(66, 2, 2017, 11, 30),
(67, 2, 2017, 12, 14),
(68, 2, 2017, 12, 28),
(69, 3, 2017, 1, 2),
(70, 3, 2017, 1, 9),
(71, 3, 2017, 1, 16),
(72, 3, 2017, 1, 23),
(73, 3, 2017, 2, 6),
(74, 3, 2017, 2, 13),
(75, 3, 2017, 2, 20),
(76, 3, 2017, 3, 6),
(77, 3, 2017, 3, 13),
(78, 3, 2017, 3, 20),
(79, 3, 2017, 4, 3),
(80, 3, 2017, 4, 10),
(81, 3, 2017, 4, 17),
(82, 3, 2017, 5, 8),
(83, 3, 2017, 5, 15),
(84, 3, 2017, 5, 22),
(85, 3, 2017, 6, 5),
(86, 3, 2017, 6, 12),
(87, 3, 2017, 6, 19),
(88, 3, 2017, 7, 3),
(89, 3, 2017, 7, 10),
(90, 3, 2017, 7, 17),
(91, 3, 2017, 7, 24),
(92, 3, 2017, 8, 7),
(93, 3, 2017, 8, 14),
(94, 3, 2017, 8, 21),
(95, 3, 2017, 9, 4),
(96, 3, 2017, 9, 11),
(97, 3, 2017, 9, 18),
(98, 3, 2017, 10, 2),
(99, 3, 2017, 10, 9),
(100, 3, 2017, 10, 16),
(101, 3, 2017, 10, 23),
(102, 3, 2017, 11, 6),
(103, 3, 2017, 11, 13),
(104, 3, 2017, 11, 20),
(105, 3, 2017, 12, 4),
(106, 3, 2017, 12, 11),
(107, 3, 2017, 12, 18),
(108, 4, 2017, 1, 9),
(109, 4, 2017, 1, 23),
(110, 4, 2017, 2, 13),
(111, 4, 2017, 2, 27),
(112, 4, 2017, 3, 13),
(113, 4, 2017, 3, 27),
(114, 4, 2017, 4, 10),
(115, 4, 2017, 4, 24),
(116, 4, 2017, 5, 8),
(117, 4, 2017, 5, 22),
(118, 4, 2017, 6, 5),
(119, 4, 2017, 6, 19),
(34, 5, 2017, 1, 24),
(35, 5, 2017, 2, 28),
(36, 5, 2017, 3, 28),
(37, 5, 2017, 4, 25),
(38, 5, 2017, 5, 23),
(39, 5, 2017, 6, 27),
(40, 5, 2017, 7, 25),
(41, 5, 2017, 8, 22),
(42, 5, 2017, 9, 26),
(43, 5, 2017, 10, 24),
(44, 5, 2017, 11, 28),
(120, 6, 2017, 3, 6),
(121, 7, 2017, 4, 3),
(122, 8, 2017, 4, 17),
(123, 10, 2017, 6, 29),
(174, 11, 2017, 1, 2),
(175, 11, 2017, 2, 6),
(176, 11, 2017, 3, 6),
(177, 11, 2017, 4, 3),
(178, 11, 2017, 5, 8),
(179, 11, 2017, 6, 5),
(180, 11, 2017, 7, 3),
(181, 11, 2017, 8, 7),
(182, 11, 2017, 9, 4),
(183, 11, 2017, 10, 2),
(184, 11, 2017, 11, 6),
(185, 11, 2017, 12, 4),
(186, 12, 2017, 1, 9),
(187, 12, 2017, 2, 6),
(188, 12, 2017, 3, 6),
(189, 12, 2017, 4, 3),
(190, 12, 2017, 5, 8),
(191, 12, 2017, 6, 5),
(192, 12, 2017, 7, 3),
(193, 12, 2017, 8, 7),
(194, 12, 2017, 9, 11),
(195, 12, 2017, 10, 2),
(196, 12, 2017, 11, 6),
(197, 12, 2017, 12, 4),
(198, 13, 2017, 1, 2),
(199, 13, 2017, 1, 9),
(200, 13, 2017, 1, 16),
(201, 13, 2017, 1, 23),
(202, 13, 2017, 1, 30),
(203, 13, 2017, 2, 6),
(204, 13, 2017, 2, 13),
(205, 13, 2017, 2, 20),
(206, 13, 2017, 2, 27),
(207, 13, 2017, 3, 6),
(208, 13, 2017, 3, 13),
(209, 13, 2017, 3, 20),
(210, 13, 2017, 3, 27),
(211, 13, 2017, 4, 3),
(212, 13, 2017, 4, 10),
(213, 13, 2017, 4, 17),
(214, 13, 2017, 4, 24),
(215, 13, 2017, 5, 8),
(216, 13, 2017, 5, 15),
(217, 13, 2017, 5, 22),
(218, 13, 2017, 5, 29),
(219, 13, 2017, 6, 5),
(220, 13, 2017, 6, 12),
(221, 13, 2017, 6, 19),
(222, 13, 2017, 6, 26),
(223, 13, 2017, 7, 3),
(224, 13, 2017, 7, 10),
(225, 13, 2017, 7, 17),
(226, 13, 2017, 7, 24),
(227, 13, 2017, 8, 7),
(228, 13, 2017, 8, 14),
(229, 13, 2017, 8, 21),
(230, 13, 2017, 8, 28),
(231, 13, 2017, 9, 4),
(232, 13, 2017, 9, 11),
(233, 13, 2017, 9, 18),
(234, 13, 2017, 9, 25),
(235, 13, 2017, 10, 2),
(236, 13, 2017, 10, 9),
(237, 13, 2017, 10, 16),
(238, 13, 2017, 10, 23),
(239, 13, 2017, 10, 30),
(240, 13, 2017, 11, 6),
(241, 13, 2017, 11, 13),
(242, 13, 2017, 11, 20),
(243, 13, 2017, 11, 27),
(244, 13, 2017, 12, 4),
(245, 13, 2017, 12, 11),
(246, 13, 2017, 12, 18),
(247, 13, 2017, 12, 25),
(248, 14, 2017, 1, 2),
(249, 14, 2017, 2, 6),
(250, 14, 2017, 3, 6),
(251, 14, 2017, 4, 3),
(252, 14, 2017, 5, 8),
(253, 14, 2017, 6, 5),
(254, 14, 2017, 7, 3),
(255, 14, 2017, 8, 7),
(256, 14, 2017, 9, 4),
(257, 14, 2017, 10, 2),
(258, 14, 2017, 11, 6),
(259, 14, 2017, 12, 4),
(260, 15, 2017, 1, 2),
(261, 15, 2017, 2, 6),
(262, 15, 2017, 3, 6),
(263, 15, 2017, 4, 3),
(264, 15, 2017, 5, 8),
(265, 15, 2017, 6, 5),
(266, 15, 2017, 7, 3),
(267, 15, 2017, 8, 7),
(268, 15, 2017, 9, 4),
(269, 15, 2017, 10, 2),
(270, 15, 2017, 11, 6),
(271, 15, 2017, 12, 4),
(273, 16, 2017, 1, 2),
(274, 16, 2017, 2, 6),
(275, 16, 2017, 3, 6),
(276, 16, 2017, 4, 3),
(277, 16, 2017, 5, 8),
(278, 16, 2017, 6, 5),
(279, 16, 2017, 7, 3),
(280, 16, 2017, 8, 7),
(281, 16, 2017, 9, 4),
(282, 16, 2017, 10, 2),
(283, 16, 2017, 11, 6),
(284, 16, 2017, 12, 4),
(285, 17, 2017, 1, 2),
(286, 17, 2017, 2, 6),
(287, 17, 2017, 3, 6),
(288, 17, 2017, 4, 3),
(289, 17, 2017, 5, 8),
(290, 17, 2017, 6, 5),
(291, 17, 2017, 7, 3),
(292, 17, 2017, 8, 7),
(293, 17, 2017, 9, 4),
(294, 17, 2017, 10, 2),
(295, 17, 2017, 11, 6),
(296, 17, 2017, 12, 4),
(297, 18, 2017, 1, 9),
(298, 18, 2017, 2, 13),
(299, 18, 2017, 3, 13),
(300, 18, 2017, 4, 10),
(301, 18, 2017, 5, 15),
(302, 18, 2017, 6, 12),
(303, 18, 2017, 7, 10),
(304, 18, 2017, 8, 14),
(305, 18, 2017, 9, 11),
(306, 18, 2017, 10, 9),
(307, 18, 2017, 11, 13),
(308, 18, 2017, 12, 11),
(309, 19, 2017, 1, 4),
(310, 19, 2017, 2, 8),
(311, 19, 2017, 3, 8),
(312, 19, 2017, 4, 5),
(313, 19, 2017, 5, 3),
(314, 19, 2017, 6, 7),
(315, 19, 2017, 7, 5),
(316, 19, 2017, 8, 2),
(317, 19, 2017, 9, 6),
(318, 19, 2017, 10, 4),
(319, 19, 2017, 11, 8),
(320, 19, 2017, 12, 6),
(321, 20, 2017, 1, 5),
(322, 20, 2017, 2, 2),
(323, 20, 2017, 3, 2),
(324, 20, 2017, 4, 6),
(325, 20, 2017, 5, 4),
(326, 20, 2017, 6, 8),
(327, 20, 2017, 7, 6),
(328, 20, 2017, 8, 3),
(329, 20, 2017, 9, 7),
(330, 20, 2017, 10, 5),
(331, 20, 2017, 11, 2),
(332, 20, 2017, 12, 7);

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE `type` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `type` varchar(32) NOT NULL,
  `subtype` varchar(32) DEFAULT NULL,
  `title` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(256) NOT NULL,
  `hour` tinyint(3) UNSIGNED NOT NULL,
  `minute` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `duration` tinyint(3) UNSIGNED NOT NULL DEFAULT '60' COMMENT 'in minutes',
  `email` varchar(256) NOT NULL,
  `agenda` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `type`
--

INSERT INTO `type` (`id`, `type`, `subtype`, `title`, `description`, `location`, `hour`, `minute`, `duration`, `email`, `agenda`) VALUES
(1, 'council', 'regular', 'City Council', 'Provide policy direction for Wichita', '455 N Main, 1st Floor Board Room Wichita, KS 67202', 9, 0, 120, 'JCJohnson@wichita.gov;EGlock@wichita.gov;MLovely@wichita.gov;JHensley@wichita.gov;DLCityCouncilMembers@wichita.gov', 'http://www.wichita.gov/Government/Council/Agendas/{0}-{1}-{2}%20Electronic%20City%20Council%20Agenda%20Packet.pdf'),
(2, 'subdivision', NULL, 'Subdivision and Utility Advisory', 'City utility design planning and review', 'The Ronald Reagan Building, 271 W. 3rd St N, Suite 203, Wichita KS 67201', 10, 0, 120, 'nstrahl@wichita.gov', 'http://www.wichita.gov/Government/Departments/Planning/AgendasMinutes/{0}-{1}-{2}%20Subdivision%20Agenda%20packet.pdf'),
(3, 'commision', NULL, 'County Commision', '5 member board meets', 'Sedgwick County Courthouse, 3rd floor, 525 N. Main', 9, 0, 60, 'crissy.magee@sedgwick.gov', 'https://sedgwickcounty.legistar.com/Calendar.aspx'),
(4, 'boe', NULL, 'Board of Education', 'Discuss vision, budget, financial reports, contracts, etc.', 'North High Lecture Hall, 1437 Rochester, Wichita.', 18, 0, 60, 'mwillome@usd259.net', 'http://www.usd259.org/cms/lib010/KS01906405/Centricity/domain/622/%20boe%20meetings/{0}%20{1}%20{2}%20Agenda%20-%20BOE.pdf'),
(5, 'council', 'workshop', 'Consent/Workshop', 'Review and discuss important issues, staff projects and future Council meeting agenda items', '455 N Main, 1st Floor Board Room Wichita, KS 67202', 9, 0, 120, 'JCJohnson@wichita.gov;EGlock@wichita.gov;MLovely@wichita.gov;JHensley@wichita.gov;DLCityCouncilMembers@wichita.gov', 'http://www.wichita.gov/Government/Council/Agendas/{0}-{1}-{2}%20City%20Council%20Agenda%20Packet.pdf'),
(6, 'boe', 'whole', 'Committee of the Whole', '', 'North High Lecture Hall, 1437 Rochester, Wichita.', 18, 0, 60, 'mwillome@usd259.net', NULL),
(7, 'boe', 'awards', '99% Awards', '', 'North High Lecture Hall, 1437 Rochester, Wichita.', 18, 0, 60, 'mwillome@usd259.net', NULL),
(8, 'boe', 'good_apples', 'Good Apples', '', 'North High Lecture Hall, 1437 Rochester, Wichita.', 18, 0, 60, '', NULL),
(9, 'boe', 'special', 'Special', '', 'North High Lecture Hall, 1437 Rochester, Wichita.', 18, 0, 60, '', NULL),
(10, 'boe', 'year_end', 'Year-End Meeting', '', 'North High Lecture Hall, 1437 Rochester, Wichita.', 12, 0, 60, 'mwillome@usd259.net', NULL),
(11, 'building_board', NULL, 'Board of Code Standards', 'The BCSA provides technical code review and recommendations to the City Council and County Commission on matters involving the Building Code, building construction & remodeling, contractor licensing, dangerous building condemnation and demolition, and neighborhood code enforcement matters.', '730 N. Main', 13, 0, 60, 'elaine.hammons@sedgwick.gov', 'http://www.scks.info/MABCD/default.aspx'),
(12, 'airport_board', '', 'Wichita Airport Advisory Board', 'Provide advice and recommendations to the City Council and City Manager on matters of policy and strategic long-term development issues affecting municipally-owned and operated airports.', 'Airport Administration Office, 2173 Air Cargo Road, Wichita, KS 67209', 15, 0, 60, 'airportwebmaster@wichita.gov', 'http://www.flywichita.com/wp-content/uploads/2015/02/Agenda-{0}-{1}-{2}.pdf'),
(13, 'county', 'staff', 'County Staff', '???', 'Sedgwick County Courthouse, 3rd floor, 525 N. Main', 8, 30, 60, 'crissy.magee@sedgwick.gov', '???'),
(14, 'dab', 'district_1', 'District I​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', '​Atwater NCH 2755 E 19th St N​', 18, 30, 60, 'lkwilliams@wichita.gov', 'http://www.wichita.gov/Government/Council/DABAgendasMinutes/{0}-{1}-{2}%20DAB%20I%20Agenda.pdf'),
(15, 'dab', 'district_4', 'District IV​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', 'Lionel Alford Library​ ​3447 S Meridian', 18, 30, 60, 'http://wichita.gov/', 'http://www.wichita.gov/Government/Council/DABAgendasMinutes/{0}-{1}-{2}%20DAB%20I%20Agenda.pdf'),
(16, 'dab', 'district_5', 'District V​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', '​Fire Station #21 2110 N 135th St W', 18, 30, 60, 'LRainwater@wichita.gov', 'http://www.wichita.gov/Government/Council/DABAgendasMinutes/{0}-{1}-{2}%20DAB%20I%20Agenda.pdf'),
(17, 'dab', 'district_6', 'District V​I​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', 'Evergreen NCH 2700 N Woodland​', 18, 30, 60, 'JLMiller@wichita.gov', 'http://www.wichita.gov/Government/Council/Pages/District6.aspx'),
(18, 'dab', 'district_2', 'District I​I​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', '​Fire Station #20 ​2255 S Greenwich', 18, 30, 60, 'JCJohnson@wichita.gov;EGlock@wichita.gov;MLovely@wichita.gov;JHensley@wichita.gov;DLCityCouncilMembers@wichita.gov', 'http://www.wichita.gov/Government/Council/Pages/DAB.aspx'),
(19, 'dab', 'district_3', 'District I​I​I​ Advisory Board', 'works directly with the City Council Member in the district to provide citizen input and hear resident concerns at the monthly meetings', 'WATER Center​ 101 E Pawnee', 18, 30, 60, 'twair@wichita.gov', 'http://www.wichita.gov/Government/Council/Pages/District3.aspx'),
(20, 'mech_board', NULL, 'Mechanical Board', 'Hear and decide from decisions made by the code enforcement director relative to the application \n            and interpretation of the mechanical code and to determine the suitability of alternate materials and types \n            of construction.', 'Executive Room, 730 N Main', 9, 0, 60, 'Thomas.Stolz@sedgwick.gov', 'http://www.scks.info/MABCD/mb.aspx');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `additional`
--
ALTER TABLE `additional`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `date`
--
ALTER TABLE `date`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type` (`tid`,`year`,`month`,`day`);

--
-- Indexes for table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `additional`
--
ALTER TABLE `additional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `date`
--
ALTER TABLE `date`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;
--
-- AUTO_INCREMENT for table `type`
--
ALTER TABLE `type`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;