-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260914.9e4dc5b5f4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 28, 2026 at 01:09 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `transaction`
--

-- --------------------------------------------------------

--
-- Table structure for table `workflow_steps`
--
CREATE TABLE `workflow_steps` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '1',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stage` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `sla_minutes` int UNSIGNED NOT NULL DEFAULT '0',
  `is_start` tinyint(1) NOT NULL DEFAULT '0',
  `is_end` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_steps`
--

INSERT INTO `workflow_steps` (`id`, `workflow_definition_id`, `parent_id`, `order_number`, `code`, `name`, `stage`, `office_id`, `sla_minutes`, `is_start`, `is_end`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 1, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 1, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 2, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 2880, 1, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, 2, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, 2, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, 2, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(8, 2, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(9, 2, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(10, 2, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(11, 2, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(12, 2, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(13, 2, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(14, 2, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(15, 2, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(16, 2, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(17, 2, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 2880, 0, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(18, 3, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, '2026-03-09 23:49:26', '2026-03-09 23:49:26', NULL),
(19, 3, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, '2026-03-09 23:49:41', '2026-03-09 23:49:41', NULL),
(20, 4, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, '2026-03-09 23:56:26', '2026-03-09 23:56:26', NULL),
(21, 4, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, '2026-03-09 23:56:26', '2026-03-09 23:56:26', NULL),
(22, 5, NULL, 1, 'ridz', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-03-10 00:30:24', '2026-09-13 22:43:17', NULL),
(23, 5, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, '2026-03-10 00:30:24', '2026-03-10 00:30:24', NULL),
(24, 6, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 2880, 1, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(25, 6, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(26, 6, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(27, 6, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(28, 6, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(29, 6, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(30, 6, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(31, 6, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(32, 6, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(33, 6, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(34, 6, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(35, 6, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(36, 6, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(37, 6, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 2880, 0, 1, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(38, 7, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 2880, 1, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(39, 7, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(40, 7, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(41, 7, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(42, 7, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(43, 7, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(44, 7, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(45, 7, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(46, 7, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(47, 7, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(48, 7, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(49, 7, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(50, 7, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(51, 7, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 2880, 0, 1, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(70, 16, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-09-13 22:43:22', '2026-09-13 22:49:48', NULL),
(71, 16, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, '2026-09-13 22:43:22', '2026-09-13 22:49:48', NULL),
(72, 17, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(73, 17, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, '2026-09-14 00:53:40', '2026-09-24 19:04:24', NULL),
(74, 17, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(75, 18, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL),
(76, 18, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL),
(77, 19, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:00:50', '2026-09-25 22:00:50', NULL),
(78, 19, NULL, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:11:02', '2026-09-25 22:11:02', NULL),
(79, 19, NULL, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:13:54', '2026-09-25 22:18:00', NULL),
(80, 20, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:19:40', '2026-09-25 22:19:40', NULL),
(81, 20, 80, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:19:40', '2026-09-25 22:19:53', NULL),
(82, 20, NULL, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:19:40', '2026-09-25 22:19:40', NULL),
(83, 21, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:19:56', '2026-09-25 22:19:56', NULL),
(84, 21, NULL, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:19:56', '2026-09-25 22:19:56', NULL),
(85, 21, 84, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:19:56', '2026-09-25 22:20:00', NULL),
(86, 22, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:20:32', '2026-09-25 22:20:32', NULL),
(87, 22, 86, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:20:32', '2026-09-25 22:38:02', NULL),
(88, 22, NULL, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:20:32', '2026-09-25 22:20:32', NULL),
(89, 23, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:38:06', '2026-09-25 22:38:06', NULL),
(90, 23, NULL, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:38:06', '2026-09-25 22:38:06', NULL),
(91, 23, 90, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:38:06', '2026-09-25 22:38:11', NULL),
(92, 24, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:42:53', '2026-09-25 22:42:53', NULL),
(93, 24, NULL, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:42:53', '2026-09-25 22:42:53', NULL),
(94, 24, NULL, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:42:53', '2026-09-25 22:42:53', NULL),
(95, 25, NULL, 1, 'it_procurement_1', 'Create Annual Investment Plan', 'Planning', 10, 1000, 1, 0, '2026-09-25 22:43:13', '2026-09-25 22:43:13', NULL),
(96, 25, NULL, 2, 'it_procurement_2', 'Return Approve AIP to end user', 'Planning', 10, 10000, 0, 0, '2026-09-25 22:43:13', '2026-09-25 22:43:13', NULL),
(97, 25, NULL, 3, 'it_procurement_3', 'Create PPMP', 'Planning', 24, 10000, 0, 1, '2026-09-25 22:43:13', '2026-09-25 22:43:13', NULL),
(98, 26, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 22:58:07', '2026-09-25 22:58:07', NULL),
(99, 26, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 22:59:10', '2026-09-25 22:59:10', NULL),
(100, 26, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:01:04', '2026-09-25 23:01:04', NULL),
(101, 26, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:04:57', '2026-09-25 23:04:57', NULL),
(102, 26, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:06:04', '2026-09-25 23:06:04', NULL),
(103, 26, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:07:29', '2026-09-25 23:07:29', NULL),
(104, 26, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-25 23:08:29', '2026-09-25 23:08:29', NULL),
(105, 26, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:09:33', '2026-09-25 23:09:33', NULL),
(106, 27, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(107, 27, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(108, 27, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(109, 27, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(110, 27, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(111, 27, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(112, 27, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(113, 27, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:12:20', '2026-09-25 23:12:20', NULL),
(114, 28, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(115, 28, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(116, 28, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(117, 28, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(118, 28, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(119, 28, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(120, 28, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(121, 28, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:13:32', '2026-09-25 23:13:32', NULL),
(122, 29, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(123, 29, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(124, 29, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(125, 29, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(126, 29, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(127, 29, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(128, 29, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(129, 29, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:14:13', '2026-09-25 23:14:13', NULL),
(130, 30, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(131, 30, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(132, 30, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(133, 30, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(134, 30, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(135, 30, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(136, 30, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(137, 30, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:15:34', '2026-09-25 23:15:34', NULL),
(138, 31, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(139, 31, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(140, 31, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(141, 31, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(142, 31, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(143, 31, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(144, 31, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:15:47', '2026-09-25 23:15:54', NULL),
(145, 31, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:15:47', '2026-09-25 23:15:47', NULL),
(146, 32, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(147, 32, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(148, 32, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(149, 32, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(150, 32, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(151, 32, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(152, 32, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(153, 32, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:16:00', '2026-09-25 23:16:00', NULL),
(154, 33, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(155, 33, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(156, 33, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(157, 33, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(158, 33, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(159, 33, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(160, 33, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(161, 33, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(162, 34, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(163, 34, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(164, 34, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(165, 34, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(166, 34, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(167, 34, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(168, 34, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(169, 34, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(170, 35, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(171, 35, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(172, 35, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(173, 35, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(174, 35, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(175, 35, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(176, 35, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(177, 35, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(178, 36, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(179, 36, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(180, 36, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(181, 36, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(182, 36, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(183, 36, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(184, 36, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(185, 36, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(186, 37, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(187, 37, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(188, 37, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(189, 37, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(190, 37, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(191, 37, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(192, 37, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(193, 37, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(194, 38, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(195, 38, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(196, 38, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(197, 38, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(198, 38, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(199, 38, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(200, 38, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(201, 38, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(202, 39, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(203, 39, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(204, 39, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(205, 39, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(206, 39, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(207, 39, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(208, 39, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(209, 39, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `workflow_steps_workflow_definition_id_code_unique` (`workflow_definition_id`,`code`),
  ADD KEY `workflow_steps_workflow_definition_id_order_number_index` (`workflow_definition_id`,`order_number`),
  ADD KEY `workflow_steps_parent_id_foreign` (`parent_id`),
  ADD KEY `wf_steps_def_parent_order_idx` (`workflow_definition_id`,`parent_id`,`order_number`),
  ADD KEY `workflow_steps_office_id_foreign` (`office_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  ADD CONSTRAINT `workflow_steps_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_steps_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `workflow_steps` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_steps_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
