-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260914.9e4dc5b5f4
-- https://www.phpmyadmin.net/
--
<<<<<<<< HEAD:transaction.sql(20).sql
-- Host: localhost:3306
-- Generation Time: Oct 05, 2026 at 03:13 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.33
========
-- Host: 127.0.0.1
-- Generation Time: Oct 05, 2026 at 08:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12
>>>>>>>> versioncontrolcache:oct 5.sql

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
-- Table structure for table `audit_logs`
--
CREATE TABLE `audit_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `actor_user_id` bigint UNSIGNED DEFAULT NULL,
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` bigint UNSIGNED DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `ip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`) VALUES
(1, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 3, '{\"payload\": {\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": true, \"description\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-09 23:44:35'),
(2, 1, 'users.update', 'App\\Models\\User', 1, '{\"after\": {\"name\": \"Vince\", \"email\": \"vinzmuloc@gmail.com\", \"role_ids\": [1], \"is_active\": true}, \"before\": {\"name\": \"Super Admin\", \"email\": \"vinzmuloc@gmail.com\", \"role_ids\": [1], \"is_active\": true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-09 18:26:21'),
(3, 1, 'users.create', 'App\\Models\\User', 10, '{\"payload\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [5], \"is_active\": true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-10 21:08:36'),
(4, 1, 'offices.create', 'App\\Models\\Office', 9, '{\"payload\": {\"code\": \"csd\", \"name\": \"Computer Services Division\", \"is_active\": true, \"description\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 18:24:12'),
(5, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 1, '{\"payload\": {\"code\": \"csd_1\", \"name\": \"Acknowledged\", \"is_active\": true, \"description\": null, \"order_number\": 1}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 18:33:19'),
(6, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 2, '{\"payload\": {\"code\": \"csd_2\", \"name\": \"Processed\", \"is_active\": true, \"description\": null, \"order_number\": 2}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 18:33:38'),
(7, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 3, '{\"payload\": {\"code\": \"csd_3\", \"name\": \"Completed\", \"is_active\": true, \"description\": null, \"order_number\": 3}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 18:33:46'),
(8, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 1, '{\"after\": {\"office_id\": 9}, \"before\": {\"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 19:04:59'),
(9, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 1, '{\"after\": {\"office_id\": null}, \"before\": {\"office_id\": 9}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 19:05:01'),
(10, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 5, '{\"after\": {\"office_id\": 9}, \"before\": {\"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 19:05:07'),
(11, 1, 'users.update', 'App\\Models\\User', 10, '{\"after\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [4], \"is_active\": true, \"office_id\": null}, \"before\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [5], \"is_active\": true, \"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-13 21:07:53'),
(12, 1, 'users.update', 'App\\Models\\User', 10, '{\"after\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [6], \"is_active\": true, \"office_id\": null}, \"before\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [4], \"is_active\": true, \"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-13 21:08:45'),
(13, 1, 'transactions.delete', 'App\\Models\\Transaction', 1, '{\"reference_number\":\"JFCW-GO9W-DM6Q\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:31:38'),
(14, 1, 'transactions.delete', 'App\\Models\\Transaction', 2, '{\"reference_number\":\"UTST-CZUL-F55O\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:31:42'),
(15, 1, 'transactions.delete', 'App\\Models\\Transaction', 3, '{\"reference_number\":\"TSYP-YHTP-JNWK\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:31:46'),
(16, 1, 'transactions.delete', 'App\\Models\\Transaction', 4, '{\"reference_number\":\"7ERC-ULBD-0AV1\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:31:50'),
(17, 1, 'transactions.delete', 'App\\Models\\Transaction', 5, '{\"reference_number\":\"GCHJ-9XQD-CV59\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:31:54'),
(18, 1, 'transactions.delete', 'App\\Models\\Transaction', 10, '{\"reference_number\":\"CC5T-ZXED-JAFX\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 19:32:01'),
(19, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 1, '{\"before\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true},\"after\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 17:10:42'),
(20, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 1, '{\"before\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true},\"after\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"job order\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 17:11:37'),
(21, 1, 'transactions.finalize', 'App\\Models\\Transaction', 16, '{\"reference_number\":\"Z5UP-ADG3-47IT\",\"current_step_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-21 23:47:33'),
(22, 1, 'transactions.finalize', 'App\\Models\\Transaction', 15, '{\"reference_number\":\"VYIR-X6GM-MMXP\",\"current_step_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-21 23:48:27'),
(23, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 17:16:15'),
(24, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 8, '{\"payload\":{\"code\":\"it_procurement\",\"name\":\"IT Equipment Procurement\",\"description\":\"Procurement Process of IT Equipment\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 21:53:22'),
(25, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 8, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 22:55:12'),
(26, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 9, '{\"payload\":{\"code\":\"it_procurements\",\"name\":\"IT Equipment Procurement\",\"description\":\"It Equipment Procurement\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 22:56:33'),
(27, 1, 'roles.create', 'App\\Models\\Role', 14, '{\"payload\":{\"code\":\"clerk_receiving\",\"name\":\"Clerk Receiving\",\"description\":\"Receiving of documents\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 23:10:36'),
(28, 1, 'roles.update', 'App\\Models\\Role', 3, '{\"before\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"Processes assigned steps.\"},\"after\":{\"code\":\"clerk_releasing\",\"name\":\"Clerk Releasing\",\"description\":\"Release assigned steps.\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 23:11:19'),
(29, 1, 'roles.create', 'App\\Models\\Role', 15, '{\"payload\":{\"code\":\"clerk_procurement\",\"name\":\"Clerk Procurement\",\"description\":\"Clerk assigned in Procurement\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 23:12:12'),
(30, 1, 'roles.create', 'App\\Models\\Role', 16, '{\"payload\":{\"code\":\"staff_technical\",\"name\":\"Staff Technical\",\"description\":null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 23:14:57'),
(31, 1, 'transactions.finalize', 'App\\Models\\Transaction', 26, '{\"reference_number\":\"PBXC-UHD1-HBAJ\",\"current_step_id\":209}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 00:41:24'),
(32, 1, 'transactions.finalize', 'App\\Models\\Transaction', 28, '{\"reference_number\":\"3VZO-F8OG-28XK\",\"current_step_id\":74}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 01:05:30'),
(33, 1, 'transactions.delete', 'App\\Models\\Transaction', 9, '{\"reference_number\":\"K8JB-EEGG-36OC\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:16:49'),
(34, 1, 'transactions.delete', 'App\\Models\\Transaction', 11, '{\"reference_number\":\"4JNN-BZGT-BRYB\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:16:52'),
(35, 1, 'transactions.delete', 'App\\Models\\Transaction', 12, '{\"reference_number\":\"LUC2-ULOD-KIFH\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:16:55'),
(36, 1, 'transactions.delete', 'App\\Models\\Transaction', 13, '{\"reference_number\":\"OWOB-BEOY-FW1M\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:16:59'),
(37, 1, 'transactions.delete', 'App\\Models\\Transaction', 14, '{\"reference_number\":\"HHZB-GGI6-RIQH\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:17:11'),
(38, 1, 'transactions.delete', 'App\\Models\\Transaction', 15, '{\"reference_number\":\"VYIR-X6GM-MMXP\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:17:14'),
(39, 1, 'transactions.delete', 'App\\Models\\Transaction', 16, '{\"reference_number\":\"Z5UP-ADG3-47IT\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:17:17'),
(40, 1, 'transactions.delete', 'App\\Models\\Transaction', 17, '{\"reference_number\":\"G6RW-ZX2H-UUMI\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:17:20'),
(41, 1, 'transactions.delete', 'App\\Models\\Transaction', 18, '{\"reference_number\":\"4YD8-5DKW-JCYT\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:17:23'),
(42, 1, 'offices.delete', 'App\\Models\\Office', 18, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 17:41:17'),
(43, 1, 'offices.delete', 'App\\Models\\Office', 6, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 17:41:27'),
(44, 1, 'offices.delete', 'App\\Models\\Office', 17, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 17:41:40'),
(45, 1, 'offices.create', 'App\\Models\\Office', 25, '{\"payload\":{\"code\":\"legal\",\"name\":\"Legal Officce\",\"description\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 17:43:44'),
(46, 1, 'transactions.delete', 'App\\Models\\Transaction', 31, '{\"reference_number\":\"KYR2-A1PI-SK9P\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 21:29:47'),
(47, 1, 'transactions.delete', 'App\\Models\\Transaction', 19, '{\"reference_number\":\"M5JW-EMVY-6REJ\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:16'),
(48, 1, 'transactions.delete', 'App\\Models\\Transaction', 20, '{\"reference_number\":\"5PAV-VMC3-7KNX\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:19'),
(49, 1, 'transactions.delete', 'App\\Models\\Transaction', 21, '{\"reference_number\":\"WMMQ-TXQM-KHWO\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:22'),
(50, 1, 'transactions.delete', 'App\\Models\\Transaction', 22, '{\"reference_number\":\"YLAA-6XW4-FZOH\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:24'),
(51, 1, 'transactions.delete', 'App\\Models\\Transaction', 23, '{\"reference_number\":\"Q9TM-29EI-BD6H\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:27'),
(52, 1, 'transactions.delete', 'App\\Models\\Transaction', 26, '{\"reference_number\":\"PBXC-UHD1-HBAJ\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:34'),
(53, 1, 'transactions.delete', 'App\\Models\\Transaction', 25, '{\"reference_number\":\"LUG7-LNDC-PLJF\",\"transaction_type_id\":8}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:37'),
(54, 1, 'transactions.delete', 'App\\Models\\Transaction', 24, '{\"reference_number\":\"VMMR-UGLN-OTKG\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:44'),
(55, 1, 'transactions.delete', 'App\\Models\\Transaction', 27, '{\"reference_number\":\"GVMS-GIEX-GXSS\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:46'),
(56, 1, 'transactions.delete', 'App\\Models\\Transaction', 28, '{\"reference_number\":\"3VZO-F8OG-28XK\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:15:51'),
(57, 1, 'transactions.delete', 'App\\Models\\Transaction', 34, '{\"reference_number\":\"LOHR-3WAY-OUA1\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 23:29:08'),
(58, 1, 'transactions.delete', 'App\\Models\\Transaction', 33, '{\"reference_number\":\"OX84-PMLV-HER6\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 23:29:11'),
(59, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 10, '{\"payload\":{\"code\":\"wadawd\",\"name\":\"2q21232\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 23:31:04'),
(60, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 10, '{\"before\":{\"code\":\"wadawd\",\"name\":\"2q21232\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]},\"after\":{\"code\":\"wadawd\",\"name\":\"2q21232-aa\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 23:32:35'),
(61, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 10, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 23:39:29'),
(62, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 9, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 00:29:17'),
(63, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 11, '{\"payload\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 00:30:22'),
(64, 1, 'offices.create', 'App\\Models\\Office', 26, '{\"payload\":{\"code\":\"paad\",\"name\":\"Procurement Acquisition and Awards Division\",\"description\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 00:41:30'),
(65, 1, 'transactions.delete', 'App\\Models\\Transaction', 36, '{\"reference_number\":\"CRVI-X0P1-WSOM\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 00:58:22'),
(66, 1, 'transactions.delete', 'App\\Models\\Transaction', 37, '{\"reference_number\":\"2BEY-TTBW-NPT7\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 01:31:02'),
(67, 1, 'transactions.finalize', 'App\\Models\\Transaction', 38, '{\"reference_number\":\"BNWR-79LJ-VBVP\",\"current_step_id\":399}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 01:44:39'),
(68, 1, 'transactions.delete', 'App\\Models\\Transaction', 29, '{\"reference_number\":\"LKFA-RUF3-OIWT\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 16:08:49'),
(69, 1, 'transactions.delete', 'App\\Models\\Transaction', 30, '{\"reference_number\":\"POYT-3B32-0Y8P\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 16:08:53'),
(70, 1, 'transactions.delete', 'App\\Models\\Transaction', 32, '{\"reference_number\":\"ROQO-Z1YN-DW1W\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 16:08:57'),
(71, 1, 'transactions.delete', 'App\\Models\\Transaction', 35, '{\"reference_number\":\"EIWE-HTYG-FUJ8\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 16:09:00'),
(72, 1, 'transactions.delete', 'App\\Models\\Transaction', 38, '{\"reference_number\":\"BNWR-79LJ-VBVP\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 16:09:04'),
(73, 1, 'transactions.delete', 'App\\Models\\Transaction', 39, '{\"reference_number\":\"MWY6-RWFW-BF41\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 17:07:23'),
(74, 1, 'workflow_definitions.delete_draft', 'App\\Models\\WorkflowDefinition', 6, '{\"deleted\":{\"transaction_type_id\":2,\"version\":2,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 20:16:32'),
(75, 1, 'workflow_definitions.delete_draft', 'App\\Models\\WorkflowDefinition', 18, '{\"deleted\":{\"transaction_type_id\":3,\"version\":5,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 20:16:32'),
(76, 1, 'workflow_definitions.save_as', 'App\\Models\\WorkflowDefinition', 62, '{\"source_id\":62,\"source_version\":5,\"to_version\":5,\"name\":\"Bryan\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 20:32:13'),
(77, 1, 'workflow_definitions.save_as', 'App\\Models\\WorkflowDefinition', 64, '{\"source_id\":63,\"source_version\":6,\"to_version\":7,\"name\":\"bry\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 20:33:37'),
(78, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 16, '{\"from_version\":7,\"from_id\":64,\"to_version\":4,\"to_id\":16}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 20:33:50'),
(79, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":4,\"from_id\":16,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 20:34:10'),
(80, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 64, '{\"from_version\":5,\"from_id\":62,\"to_version\":7,\"to_id\":64}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 17:02:13'),
(81, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":7,\"from_id\":64,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 17:02:19'),
(82, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 63, '{\"from_version\":5,\"from_id\":62,\"to_version\":6,\"to_id\":63}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 19:05:08'),
(83, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":6,\"from_id\":63,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 19:05:57'),
(84, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 19:28:19');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
<<<<<<<< HEAD:transaction.sql(20).sql
('laravel-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:2;', 1791163135),
('laravel-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1791163135;', 1791163135),
('laravel-cache-approvals:count:u1', 'a:2:{s:20:\"pending_requirements\";i:2;s:12:\"transactions\";i:1;}', 1790923790),
('laravel-cache-dash:summary:58b1c79e10d5ebee27c1605bc8f68257', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:9:\"last_week\";s:5:\"label\";s:23:\"Last week (Sep 21–27)\";s:4:\"from\";s:25:\"2026-09-21T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-09-28T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:5;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1790923791),
('laravel-cache-dash:summary:d8e283ce6193c2172e40896f6b1ca810', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-10\";s:5:\"label\";s:12:\"October 2026\";s:4:\"from\";s:25:\"2026-10-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-11-01T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:1;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1790923794),
('laravel-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:1;', 1791170051),
('laravel-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1791170051;', 1791170051),
('laravel-cache-lookup:offices', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:23:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:8;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:9;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:10;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:11;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:12;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:13;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:14;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:15;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:16;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:17;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:18;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:19;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:20;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:21;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:22;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1790924340);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-lookup:transaction-types', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:4:{i:0;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:3;s:15:\"pivot_office_id\";i:23;s:16:\"pivot_created_at\";s:19:\"2026-09-24 01:16:15\";s:16:\"pivot_updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:11;s:15:\"pivot_office_id\";i:24;s:16:\"pivot_created_at\";s:19:\"2026-09-30 08:30:22\";s:16:\"pivot_updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:137;s:12:\"pivotRelated\";r:179;s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1790924341),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81', 'i:5;', 1789364911),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81:timer', 'i:1789364911;', 1789364911),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:2;', 1790900683),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1790900683;', 1790900683),
('transaction-cache-approvals:count:u1', 'a:2:{s:20:\"pending_requirements\";i:2;s:12:\"transactions\";i:1;}', 1790902454),
('transaction-cache-dash:summary:58b1c79e10d5ebee27c1605bc8f68257', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:9:\"last_week\";s:5:\"label\";s:23:\"Last week (Sep 21–27)\";s:4:\"from\";s:25:\"2026-09-21T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-09-28T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:5;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1790900702),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:26;', 1790902453),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1790902453;', 1790902453);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:offices', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:23:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:8;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:9;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:10;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:11;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:12;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:13;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:14;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:15;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:16;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:17;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:18;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:19;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:20;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:21;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:22;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1790902687);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:transaction-types', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:4:{i:0;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:3;s:15:\"pivot_office_id\";i:23;s:16:\"pivot_created_at\";s:19:\"2026-09-24 01:16:15\";s:16:\"pivot_updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:11;s:15:\"pivot_office_id\";i:24;s:16:\"pivot_created_at\";s:19:\"2026-09-30 08:30:22\";s:16:\"pivot_updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:137;s:12:\"pivotRelated\";r:179;s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1790902681),
('transaction-cache-weather:zamboanga', 'a:5:{s:11:\"temperature\";d:29.4;s:4:\"code\";i:1;s:6:\"is_day\";i:1;s:4:\"time\";s:16:\"2026-10-02T08:15\";s:5:\"place\";s:14:\"Zamboanga City\";}', 1790902426);
========
('transaction-cache-approvals:count:u1', 'a:2:{s:20:\"pending_requirements\";i:2;s:12:\"transactions\";i:1;}', 1791182921),
('transaction-cache-dash:summary:e79088e300c7aad1053735300403126f', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:9:\"last_week\";s:5:\"label\";s:26:\"Last week (Sep 28–Oct 4)\";s:4:\"from\";s:25:\"2026-09-28T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-10-05T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:1;s:7:\"overdue\";i:0;s:7:\"deleted\";i:11;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1791182951),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:34;', 1791182921),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1791182921;', 1791182921),
('transaction-cache-lookup:offices', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:23:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"legal\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"updated_at\";s:19:\"2026-09-29 01:43:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:8;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:9;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:10;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:11;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:12;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:13;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:14;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:15;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:16;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:17;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:18;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:19;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:20;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:21;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"paad\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"updated_at\";s:19:\"2026-09-30 08:41:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:22;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1791182919);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:transaction-types', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:4:{i:0;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-10-02 03:28:19\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-10 07:44:35\";s:10:\"updated_at\";s:19:\"2026-10-02 03:28:19\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:3;s:15:\"pivot_office_id\";i:23;s:16:\"pivot_created_at\";s:19:\"2026-09-24 01:16:15\";s:16:\"pivot_updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-24 01:16:15\";s:10:\"updated_at\";s:19:\"2026-09-24 01:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-09-21 01:11:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:11:\"procurement\";s:4:\"name\";s:11:\"Procurement\";s:11:\"description\";s:42:\"LGU procurement process (inventory-linked)\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"updated_at\";s:19:\"2026-03-10 05:24:39\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:8:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:11;s:15:\"pivot_office_id\";i:24;s:16:\"pivot_created_at\";s:19:\"2026-09-30 08:30:22\";s:16:\"pivot_updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:11;s:9:\"office_id\";i:24;s:10:\"created_at\";s:19:\"2026-09-30 08:30:22\";s:10:\"updated_at\";s:19:\"2026-09-30 08:30:22\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:137;s:12:\"pivotRelated\";r:179;s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1791182917),
('transaction-cache-weather:zamboanga', 'a:5:{s:11:\"temperature\";d:27.1;s:4:\"code\";i:51;s:6:\"is_day\";i:1;s:4:\"time\";s:16:\"2026-10-05T14:15\";s:5:\"place\";s:14:\"Zamboanga City\";}', 1791183248);
>>>>>>>> versioncontrolcache:oct 5.sql

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `checklist_overrides`
--
CREATE TABLE `checklist_overrides` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `requirement_definition_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `checklist_overrides`
--

INSERT INTO `checklist_overrides` (`id`, `workflow_step_id`, `requirement_definition_id`, `name`, `code`, `description`, `is_required`, `display_order`, `created_at`, `updated_at`) VALUES
(11, 40, 19, 'Uploaded to Google Drive', 'drive_uploaded', NULL, 1, 1, '2026-09-24 18:48:06', '2026-09-24 18:48:06'),
(12, 3, 28, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-09-24 18:48:06', '2026-09-24 18:48:06'),
(13, 71, 25, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-24 18:48:06', '2026-09-24 18:48:06'),
(14, 2, 27, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-09-24 18:54:17', '2026-09-24 18:54:17'),
(15, 2, 36, 'AR', 'ar', 'AR remarks', 1, 2, '2026-09-24 18:54:17', '2026-09-24 18:54:17'),
(16, 39, 23, 'Signed PR PDF attached', 'signed_pr_pdf', NULL, 1, 1, '2026-09-25 22:25:55', '2026-09-25 22:25:55'),
(17, 73, 30, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-09-26 01:02:03', '2026-09-26 01:02:03'),
(18, 73, 35, 'AR', 'ar', 'AR remarks', 0, 1, '2026-09-26 01:02:03', '2026-09-28 21:30:46'),
(19, 74, 31, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-09-26 01:05:21', '2026-09-26 01:05:21'),
(20, 73, 37, 'Payroll', 'payroll', NULL, 1, 2, '2026-09-28 21:30:46', '2026-09-28 21:30:46'),
(21, 73, 38, 'MedCert', 'medcert', NULL, 0, 3, '2026-09-28 21:35:07', '2026-09-28 21:35:07'),
(22, 74, 39, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-09-29 23:11:10', '2026-09-29 23:11:10'),
(23, 337, 43, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:55:14', '2026-09-30 00:55:14'),
(24, 337, 42, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:55:14', '2026-09-30 00:55:14'),
(25, 345, 46, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(26, 345, 45, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(27, 353, 48, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(28, 353, 47, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(29, 361, 50, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(30, 361, 49, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(31, 369, 52, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(32, 369, 51, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(33, 377, 54, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(34, 377, 53, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(35, 385, 56, 'PR', 'pr', NULL, 1, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(36, 385, 55, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(38, 386, 58, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-09-30 01:05:10', '2026-09-30 01:05:10'),
(39, 387, 59, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-09-30 01:06:06', '2026-09-30 01:06:06'),
(42, 389, 62, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-09-30 01:11:47', '2026-09-30 01:11:47'),
(43, 388, 64, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-09-30 01:13:11', '2026-09-30 01:13:11'),
(44, 390, 66, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-09-30 01:14:03', '2026-09-30 01:14:03'),
(45, 393, 74, 'PR', 'pr', NULL, 1, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(46, 393, 73, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(47, 394, 75, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(48, 395, 76, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(49, 396, 70, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(50, 397, 71, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(51, 398, 68, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(52, 399, 77, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-09-30 01:16:33', '2026-09-30 01:16:33'),
(53, 401, 80, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59'),
(54, 403, 82, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 20:32:33', '2026-09-30 20:32:33'),
(55, 406, 84, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(56, 409, 95, 'PR', 'pr', NULL, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(57, 409, 92, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(58, 410, 96, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(59, 411, 97, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(60, 412, 89, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(61, 413, 90, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(62, 414, 87, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(63, 415, 93, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(64, 417, 107, 'PR', 'pr', NULL, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(65, 417, 104, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(66, 418, 108, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(67, 419, 109, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(68, 420, 101, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(69, 421, 102, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(70, 422, 99, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(71, 423, 105, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--
CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `field_definitions`
--
CREATE TABLE `field_definitions` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED DEFAULT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '0',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `unique` tinyint(1) NOT NULL DEFAULT '0',
  `sensitive` tinyint(1) NOT NULL DEFAULT '0',
  `min_length` int UNSIGNED DEFAULT NULL,
  `max_length` int UNSIGNED DEFAULT NULL,
  `min_value` decimal(18,4) DEFAULT NULL,
  `max_value` decimal(18,4) DEFAULT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `validation_rules` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `field_definitions`
--

INSERT INTO `field_definitions` (`id`, `workflow_definition_id`, `order_number`, `code`, `name`, `type`, `group`, `display_order`, `required`, `unique`, `sensitive`, `min_length`, `max_length`, `min_value`, `max_value`, `options`, `validation_rules`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, NULL, 1, 'pr_number', 'PR Number', 'text', NULL, 1, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, NULL, 2, 'request_title', 'Request Title', 'text', NULL, 2, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, NULL, 3, 'office_name', 'Office / Dept', 'text', NULL, 3, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, NULL, 4, 'request_amount', 'Amount', 'number', NULL, 4, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, NULL, 5, 'drive_link', 'Google Drive Link', 'text', NULL, 5, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, NULL, 6, 'dts_number', 'DTS Number', 'text', NULL, 6, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, NULL, 7, 'remarks', 'Remarks', 'textarea', NULL, 7, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `field_definition_workflow_step`
--
CREATE TABLE `field_definition_workflow_step` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `field_definition_id` bigint UNSIGNED NOT NULL,
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `required_override` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `field_values`
--
CREATE TABLE `field_values` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `field_definition_id` bigint UNSIGNED NOT NULL,
  `value_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `value_text` text COLLATE utf8mb4_unicode_ci,
  `value_number` decimal(18,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `field_values`
--

INSERT INTO `field_values` (`id`, `transaction_id`, `field_definition_id`, `value_json`, `value_text`, `value_number`, `created_at`, `updated_at`, `updated_by`) VALUES
(1, 9, 2, '{\"value\": \"Almost\"}', 'Almost', NULL, '2026-09-13 19:36:55', '2026-09-13 19:36:55', 1),
(2, 9, 3, '{\"value\": \"Almost Office\"}', 'Almost Office', NULL, '2026-09-13 19:36:55', '2026-09-13 19:36:55', 1),
(3, 9, 4, '{\"value\": 500}', '500', NULL, '2026-09-13 19:36:55', '2026-09-13 19:36:55', 1),
(4, 9, 7, '{\"value\": \"ad\"}', 'ad', NULL, '2026-09-13 19:36:55', '2026-09-13 19:36:55', 1),
(5, 9, 5, '{\"value\": \"Minotaur.com\"}', 'Minotaur.com', NULL, '2026-09-13 20:46:56', '2026-09-13 20:46:56', 1),
(6, 9, 6, '{\"value\":\"34534534\"}', '34534534', NULL, '2026-09-20 17:05:15', '2026-09-20 17:05:15', 1),
(7, 17, 2, '{\"value\":\"3234234\"}', '3234234', NULL, '2026-09-20 19:30:52', '2026-09-20 19:30:52', 1),
(8, 17, 3, '{\"value\":\"234\"}', '234', NULL, '2026-09-20 19:30:52', '2026-09-20 19:30:52', 1),
(9, 17, 4, '{\"value\":3242}', '3242', NULL, '2026-09-20 19:30:52', '2026-09-20 19:30:52', 1),
(10, 17, 7, '{\"value\":\"23423\"}', '23423', NULL, '2026-09-20 19:30:52', '2026-09-20 19:30:52', 1),
(11, 17, 5, '{\"value\":\"67567567\"}', '67567567', NULL, '2026-09-20 19:32:50', '2026-09-20 19:32:50', 1),
(12, 18, 2, '{\"value\":\"3234234\"}', '3234234', NULL, '2026-09-21 17:18:56', '2026-09-21 17:18:56', 1),
(13, 18, 3, '{\"value\":\"234\"}', '234', NULL, '2026-09-21 17:18:56', '2026-09-21 17:18:56', 1),
(14, 18, 4, '{\"value\":1}', '1', NULL, '2026-09-21 17:18:56', '2026-09-21 17:18:56', 1),
(15, 18, 7, '{\"value\":null}', NULL, NULL, '2026-09-21 17:18:56', '2026-09-21 17:18:56', 1),
(16, 18, 5, '{\"value\":\"waffawfawfas\"}', 'waffawfawfas', NULL, '2026-09-21 17:21:46', '2026-09-21 19:29:48', 1),
(17, 18, 6, '{\"value\":\"awdawfaaawaa\"}', 'awdawfaaawaa', NULL, '2026-09-21 17:22:45', '2026-09-21 19:29:41', 1),
(18, 18, 1, '{\"value\":\"46\"}', '46', NULL, '2026-09-21 17:26:43', '2026-09-21 17:26:43', 1);

-- --------------------------------------------------------

--
-- Table structure for table `government_references`
--
CREATE TABLE `government_references` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `government_references`
--

INSERT INTO `government_references` (`id`, `code`, `title`, `source`, `url`, `notes`, `is_verified`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'RA-9184', 'Government Procurement Reform Act (placeholder record)', 'Republic Act', NULL, 'TO VERIFY — admin must encode official URL/sections. Do not hardcode legal text.', 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 'IRR-RA-9184', 'IRR for RA 9184 (placeholder record)', 'IRR', NULL, 'TO VERIFY — admin must encode official URL/sections.', 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 'COA-CIRCULAR-TO-VERIFY', 'COA Circular (placeholder record)', 'COA', NULL, 'TO VERIFY — replace with exact COA circular code + official link.', 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 'DBM-GUIDANCE-TO-VERIFY', 'DBM Guidance (placeholder record)', 'DBM', NULL, 'TO VERIFY — replace with exact DBM issuance + official link.', 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--
CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--
CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_02_05_052702_add_is_active_to_users_table', 1),
(5, '2026_02_05_052705_create_permissions_table', 1),
(6, '2026_02_05_052705_create_roles_table', 1),
(7, '2026_02_05_052706_create_permission_role_table', 1),
(8, '2026_02_05_052706_create_role_user_table', 1),
(9, '2026_02_05_052707_create_audit_logs_table', 1),
(10, '2026_02_05_073807_create_transaction_types_table', 1),
(11, '2026_02_05_073808_create_government_references_table', 1),
(12, '2026_02_05_080353_create_workflow_definitions_table', 1),
(13, '2026_02_05_080353_create_workflow_steps_table', 1),
(14, '2026_02_05_080354_create_step_roles_table', 1),
(15, '2026_02_05_080354_create_workflow_routes_table', 1),
(16, '2026_02_05_082653_create_transactions_table', 1),
(17, '2026_02_05_082654_create_transaction_states_table', 1),
(18, '2026_02_05_082654_create_transaction_step_runs_table', 1),
(19, '2026_02_09_052515_create_field_definitions_table', 1),
(20, '2026_02_09_052516_create_field_definition_workflow_step_table', 1),
(21, '2026_02_09_052516_create_field_values_table', 1),
(22, '2026_02_09_063313_add_pivot_meta_to_field_definition_workflow_step_table', 1),
(23, '2026_02_09_065833_alter_field_definitions_make_workflow_definition_id_nullable', 1),
(24, '2026_02_11_022416_alter_field_values_add_value_number_and_updated_by', 1),
(25, '2026_02_11_084440_create_requirement_definitions_table', 1),
(26, '2026_02_11_084933_create_requirement_checks_table', 1),
(27, '2026_02_12_000737_create_requirement_definition_workflow_step_table', 1),
(28, '2026_02_12_000739_create_step_requirements_table', 1),
(29, '2026_02_12_000740_create_transaction_requirement_checks_table', 1),
(30, '2026_02_13_000001_create_offices_table', 2),
(31, '2026_02_13_000002_add_office_id_to_users_table', 2),
(32, '2026_02_13_000003_create_office_steps_table', 3),
(33, '2026_02_13_000004_add_office_id_to_transactions_table', 4),
(34, '2026_02_13_000005_add_parent_id_to_office_steps_table', 5),
(35, '2026_02_13_000006_drop_parent_id_from_office_steps_table', 6),
(36, '2026_02_13_000007_add_parent_id_to_workflow_steps_table', 7),
(37, '2026_02_13_000008_drop_parent_id_from_workflow_steps_table', 8),
(38, '2026_02_13_000009_readd_parent_id_to_office_steps_table', 9),
(39, '2026_02_13_000010_readd_parent_id_to_workflow_steps_table', 9),
(40, '2026_02_14_000001_create_transaction_attachments_table', 10),
(41, '2026_09_16_120000_drop_dead_requirement_tables', 11),
(42, '2026_09_23_000001_create_transaction_station_touches_table', 12),
(43, '2026_09_30_000001_add_is_done_to_transactions_table', 13),
(44, '2026_09_30_000002_add_label_to_requirement_definitions_table', 14),
(45, '2026_09_30_000003_create_checklist_overrides_table', 15),
(46, '2026_09_30_000004_rename_label_to_code_on_checklist_overrides_table', 16),
(47, '2026_09_30_000005_create_transaction_checklist_checks_table', 17),
(48, '2026_09_24_000001_create_office_transaction_type_table', 18),
(49, '2026_09_25_000001_add_office_id_to_workflow_steps_table', 19),
(50, '2026_10_01_000001_add_receive_tracking_to_transaction_step_runs_table', 20),
(51, '2026_10_02_000001_fix_rogue_on_update_timestamps', 21),
(52, '2026_10_02_000002_repair_clobbered_step_run_timestamps', 22),
(53, '2026_10_03_000001_add_is_upload_required_to_step_requirements_table', 23),
(54, '2026_10_01_120000_add_is_live_to_workflow_definitions_table', 24),
(55, '2026_10_05_000001_create_workflow_step_data_table', 25),
(56, '2026_10_05_000002_create_transaction_step_data_table', 25);

-- --------------------------------------------------------

--
-- Table structure for table `offices`
--
CREATE TABLE `offices` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `offices`
--

INSERT INTO `offices` (`id`, `code`, `name`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'OCM', 'Office of the City Mayor', NULL, 1, NULL, NULL, NULL),
(2, 'OCA', 'Office of the City Administrator', NULL, 1, NULL, NULL, NULL),
(3, 'OCAC', 'Office of the City Accountant', NULL, 1, NULL, NULL, NULL),
(4, 'OCAS', 'Office of the City Assessor', NULL, 1, NULL, NULL, NULL),
(5, 'OCT', 'Office of the City Treasurer', NULL, 1, NULL, NULL, NULL),
(6, 'OCE', 'Office of the City Engineer', NULL, 1, NULL, '2026-09-28 17:41:27', '2026-09-28 17:41:27'),
(7, 'OCL', 'Office of the City Engineer', NULL, 1, NULL, NULL, NULL),
(8, 'GSO', 'General Service Office', NULL, 1, NULL, NULL, NULL),
(9, 'OCB', 'Office of the City Budget', NULL, 1, NULL, NULL, NULL),
(10, 'OCPD', 'Office of the City Planning and Development', NULL, 1, NULL, NULL, NULL),
(11, 'OCH', 'Office of the City Health', NULL, 1, NULL, NULL, NULL),
(12, 'OCSWD', 'Office of the City Social Welfare and Development', NULL, 1, NULL, NULL, NULL),
(13, 'OCV', 'Office of the City Veterinarian', NULL, 1, NULL, NULL, NULL),
(14, 'OCAG', 'Office of the City Agricultural', NULL, 1, NULL, NULL, NULL),
(15, 'OCCR', 'Office of the City Civil Registrar', NULL, 1, NULL, NULL, NULL),
(16, 'OCENR', 'Office of the City Environment and Natural Resources', NULL, 1, NULL, NULL, NULL),
(17, 'CCZ', 'Colegio De La Ciudad De Zamboanga', NULL, 1, NULL, '2026-09-28 17:41:40', '2026-09-28 17:41:40'),
(18, 'SSP', 'Secretary to the Sangguniang Panlungsod', NULL, 1, NULL, '2026-09-28 17:41:17', '2026-09-28 17:41:17'),
(19, 'SP', 'Sangguniang Panlungsod', NULL, 1, NULL, NULL, NULL),
(20, 'OCDRDM', 'Office of the City Disaster Risk Deduction Management', NULL, 1, NULL, NULL, NULL),
(21, 'CHRMO', 'City Human Resource Management Office', NULL, 1, NULL, NULL, NULL),
(22, 'GDS', 'CMO - Gender and Development Services (GAD)', NULL, 1, NULL, NULL, NULL),
(23, 'LEDIPS', 'Local Economic Development and Investment Promotion Services', NULL, 1, NULL, NULL, NULL),
(24, 'CSD', 'Computer Service Division', NULL, 1, NULL, NULL, NULL),
(25, 'legal', 'Legal Officce', NULL, 1, '2026-09-28 17:43:44', '2026-09-28 17:43:44', NULL),
(26, 'paad', 'Procurement Acquisition and Awards Division', NULL, 1, '2026-09-30 00:41:30', '2026-09-30 00:41:30', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `office_steps`
--
CREATE TABLE `office_steps` (
  `id` bigint UNSIGNED NOT NULL,
  `office_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '1',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `office_transaction_type`
--
CREATE TABLE `office_transaction_type` (
  `id` bigint UNSIGNED NOT NULL,
  `office_id` bigint UNSIGNED NOT NULL,
  `transaction_type_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `office_transaction_type`
--

INSERT INTO `office_transaction_type` (`id`, `office_id`, `transaction_type_id`, `created_at`, `updated_at`) VALUES
(3, 23, 3, '2026-09-23 17:16:15', '2026-09-23 17:16:15'),
(5, 24, 9, '2026-09-25 22:56:33', '2026-09-25 22:56:33'),
(6, 25, 10, '2026-09-29 23:31:04', '2026-09-29 23:31:04'),
(7, 24, 11, '2026-09-30 00:30:22', '2026-09-30 00:30:22');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--
CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--
CREATE TABLE `permission_role` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `requirement_definitions`
--
CREATE TABLE `requirement_definitions` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '0',
  `code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requirement_definitions`
--

INSERT INTO `requirement_definitions` (`id`, `workflow_definition_id`, `order_number`, `code`, `name`, `label`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 2, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 2, 3, 'dts_created', 'DTS created', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 2, 4, 'pr_encoded', 'PR Number encoded', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, 2, 5, 'city_admin_signed', 'City Admin signed', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, 2, 6, 'treasurer_signed', 'Treasurer signed', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, 2, 7, 'doc_validated', 'Document validated (untampered)', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(8, 2, 8, 'earmark_completed', 'Earmark completed', NULL, NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(17, 7, 5, 'city_admin_signed', 'City Admin signed', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(18, 7, 7, 'doc_validated', 'Document validated (untampered)', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(19, 7, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(20, 7, 3, 'dts_created', 'DTS created', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(21, 7, 8, 'earmark_completed', 'Earmark completed', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(22, 7, 4, 'pr_encoded', 'PR Number encoded', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(23, 7, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(24, 7, 6, 'treasurer_signed', 'Treasurer signed', NULL, NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(25, 16, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(26, 16, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(27, 1, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(28, 1, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(29, 1, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(30, 17, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-09-14 00:53:40', '2026-09-28 21:35:09', NULL),
(31, 17, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-09-14 00:53:40', '2026-09-29 23:11:13', NULL),
(32, 17, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(35, 17, 0, 'ar', 'AR', 'AR', 'AR remarks', 1, '2026-09-22 18:27:31', '2026-09-28 21:35:09', NULL),
(36, 1, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-09-23 03:13:05', '2026-09-23 03:13:05', NULL),
(37, 17, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-09-28 21:30:45', '2026-09-28 21:35:09', NULL),
(38, 17, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-09-28 21:35:06', '2026-09-28 21:35:09', NULL),
(39, 17, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-09-29 23:11:09', '2026-09-29 23:11:13', NULL),
(40, 53, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:50:11', '2026-09-30 00:52:19', NULL),
(41, 53, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:52:17', '2026-09-30 00:52:19', NULL),
(42, 54, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(43, 54, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(44, 53, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-30 00:53:49', '2026-09-30 00:53:50', NULL),
(45, 55, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(46, 55, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(47, 56, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(48, 56, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(49, 57, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(50, 57, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(51, 58, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(52, 58, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(53, 59, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(54, 59, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(55, 60, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(56, 60, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(57, 60, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-30 01:03:51', '2026-09-30 01:03:52', NULL),
(58, 60, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-09-30 01:05:09', '2026-09-30 01:05:10', NULL),
(59, 60, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-09-30 01:06:05', '2026-09-30 01:06:06', NULL),
(60, 60, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-09-30 01:07:59', '2026-09-30 01:13:11', NULL),
(61, 60, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-09-30 01:08:31', '2026-09-30 01:11:47', NULL),
(62, 60, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-09-30 01:11:46', '2026-09-30 01:11:48', NULL),
(64, 60, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-09-30 01:13:10', '2026-09-30 01:13:14', NULL),
(66, 60, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-09-30 01:14:02', '2026-09-30 01:14:03', NULL),
(67, 61, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(68, 61, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(69, 61, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(70, 61, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(71, 61, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(72, 61, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(73, 61, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(74, 61, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(75, 61, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(76, 61, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(77, 61, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-09-30 01:16:32', '2026-09-30 01:16:33', NULL),
(79, 61, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-09-30 01:23:00', '2026-09-30 01:23:00', NULL),
(80, 62, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(81, 62, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(82, 63, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 20:32:33', '2026-09-30 20:32:33', NULL),
(83, 63, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 20:32:33', '2026-09-30 20:32:33', NULL),
(84, 64, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(85, 64, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(86, 65, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(87, 65, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(88, 65, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(89, 65, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(90, 65, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(91, 65, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(92, 65, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(93, 65, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(94, 65, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(95, 65, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(96, 65, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(97, 65, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(98, 66, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(99, 66, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(100, 66, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(101, 66, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(102, 66, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(103, 66, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(104, 66, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(105, 66, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(106, 66, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(107, 66, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(108, 66, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(109, 66, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--
CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `code`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'superadmin', 'Super Admin', 'Full access (local-only).', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(2, 'admin', 'Admin', 'Manages master data and workflows.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(3, 'clerk_releasing', 'Clerk Releasing', 'Release assigned steps.', '2026-03-09 21:24:36', '2026-09-25 23:11:19', NULL),
(4, 'approver', 'Approver', 'Approves steps routed to them.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(5, 'viewer', 'Viewer', 'Read-only access.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(6, 'end_user', 'End User', 'Creates and forwards PR documents.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(7, 'gso', 'GSO', 'General Services Office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(8, 'city_admin', 'City Administrator', 'Signs/approves as City Admin.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(9, 'cto', 'CTO', 'City Treasurer Office reviewer.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(10, 'city_treasurer', 'City Treasurer', 'Signs/approves as Treasurer.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(11, 'cadmin', 'CAdmin', 'City Admin office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(12, 'cbo', 'CBO', 'City Budget Office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(13, 'bac_paad', 'BAC-PAAD', 'Receives final submitted documents.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(14, 'clerk_receiving', 'Clerk Receiving', 'Receiving of documents', '2026-09-25 23:10:36', '2026-09-25 23:10:36', NULL),
(15, 'clerk_procurement', 'Clerk Procurement', 'Clerk assigned in Procurement', '2026-09-25 23:12:12', '2026-09-25 23:12:12', NULL),
(16, 'staff_technical', 'Staff Technical', NULL, '2026-09-25 23:14:57', '2026-09-25 23:14:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--
CREATE TABLE `role_user` (
  `role_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_user`
--

INSERT INTO `role_user` (`role_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-03-09 21:24:36', '2026-03-09 21:24:36'),
(6, 2, '2026-03-09 21:24:37', '2026-03-09 21:24:37'),
(6, 10, '2026-09-13 21:08:45', '2026-09-13 21:08:45'),
(7, 3, '2026-03-09 21:24:37', '2026-03-09 21:24:37'),
(8, 4, '2026-03-09 21:24:37', '2026-03-09 21:24:37'),
(9, 5, '2026-03-09 21:24:37', '2026-03-09 21:24:37'),
(10, 6, '2026-03-09 21:24:38', '2026-03-09 21:24:38'),
(11, 7, '2026-03-09 21:24:38', '2026-03-09 21:24:38'),
(12, 8, '2026-03-09 21:24:38', '2026-03-09 21:24:38'),
(13, 9, '2026-03-09 21:24:39', '2026-03-09 21:24:39');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
<<<<<<<< HEAD:transaction.sql(20).sql
('Q2fzTBfrYZhcFqOJiIDw8lKJwc79t0NgFNMj9lDl', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiNW5COUdxNnV2MTdqeU5sR3A4Q05YY2tDTmhCdXRMYjBES1I1TmZpMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvd2VhdGhlciI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjE3OiJwYXNzd29yZF9oYXNoX3dlYiI7czo2NDoiOWIzYTI0N2FkNTM2NDY5ZmEyNjVjYjQxZDkwZDI3Mzc0NTMyMjI1MjJhODdhMWZhYTRmM2Y0MmU3MjAxZjliZCI7fQ==', 1791169991);
========
('dKk2DZQ7KvsbtGqifKxMoODXZdehcvmZoytFXiYC', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoidVBTSDdiU0xOelpFT0tFdWRnaHJKbjBCSHJ2TkFVajF4S0pwOGIzYSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC90cmFuc2FjdGlvbnMiO3M6NToicm91dGUiO047fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6ImRkN2MxYzgyOGIzM2EyZGJiZWRjZjQ0NmFhZjlkOGFjZWFhYzVlZmU4ZjNjZjAxOTYzYWU4ZWNmNzYzMDk1NDMiO30=', 1791182910);
>>>>>>>> versioncontrolcache:oct 5.sql

-- --------------------------------------------------------

--
-- Table structure for table `step_requirements`
--
CREATE TABLE `step_requirements` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `requirement_definition_id` bigint UNSIGNED NOT NULL,
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `is_upload_required` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `step_requirements`
--

INSERT INTO `step_requirements` (`id`, `workflow_step_id`, `requirement_definition_id`, `display_order`, `is_required`, `is_upload_required`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(2, 5, 2, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(3, 6, 3, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(4, 8, 4, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(5, 10, 5, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(6, 12, 6, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(7, 15, 7, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(8, 16, 8, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(17, 50, 21, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(18, 49, 18, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(19, 44, 17, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(20, 40, 20, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(21, 38, 23, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(22, 42, 22, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(23, 46, 24, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(24, 39, 19, 1, 1, 1, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(25, 70, 25, 1, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(26, 71, 26, 1, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(27, 1, 27, 1, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(28, 2, 28, 1, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(29, 3, 29, 1, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(30, 72, 30, 1, 1, 0, '2026-09-14 00:53:40', '2026-09-28 21:35:09'),
(31, 74, 32, 1, 1, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(32, 73, 31, 1, 1, 1, '2026-09-14 00:53:40', '2026-09-29 23:11:13'),
(35, 72, 35, 1, 0, 1, '2026-09-22 18:27:31', '2026-09-28 21:35:09'),
(36, 1, 36, 2, 1, 1, '2026-09-23 03:13:05', '2026-09-23 03:13:05'),
(37, 72, 37, 2, 1, 1, '2026-09-28 21:30:46', '2026-09-28 21:35:09'),
(38, 72, 38, 3, 0, 0, '2026-09-28 21:35:07', '2026-09-28 21:35:09'),
(39, 73, 39, 1, 1, 1, '2026-09-29 23:11:10', '2026-09-29 23:11:13'),
(40, 328, 40, 0, 1, 1, '2026-09-30 00:50:12', '2026-09-30 00:52:19'),
(41, 328, 41, 1, 1, 1, '2026-09-30 00:52:18', '2026-09-30 00:52:19'),
(42, 336, 43, 0, 1, 1, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(43, 336, 42, 1, 1, 1, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(44, 329, 44, 0, 1, 1, '2026-09-30 00:53:50', '2026-09-30 00:53:50'),
(45, 344, 46, 0, 1, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(46, 344, 45, 1, 1, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(47, 352, 48, 0, 1, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(48, 352, 47, 1, 1, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(49, 360, 50, 0, 1, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(50, 360, 49, 1, 1, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(51, 368, 52, 0, 1, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(52, 368, 51, 1, 1, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(53, 376, 54, 0, 1, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(54, 376, 53, 1, 1, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(55, 384, 56, 0, 1, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(56, 384, 55, 1, 1, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(58, 385, 58, 0, 1, 1, '2026-09-30 01:05:10', '2026-09-30 01:05:10'),
(59, 386, 59, 0, 1, 1, '2026-09-30 01:06:06', '2026-09-30 01:06:06'),
(62, 388, 62, 1, 1, 1, '2026-09-30 01:11:47', '2026-09-30 01:11:49'),
(63, 387, 64, 1, 1, 1, '2026-09-30 01:13:11', '2026-09-30 01:13:14'),
(64, 389, 66, 0, 1, 1, '2026-09-30 01:14:03', '2026-09-30 01:14:03'),
(65, 392, 74, 0, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(66, 392, 73, 1, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(67, 393, 75, 0, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(68, 394, 76, 0, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(69, 395, 70, 1, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(70, 396, 71, 1, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(71, 397, 68, 0, 1, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(72, 398, 77, 0, 1, 1, '2026-09-30 01:16:33', '2026-09-30 01:16:33'),
(73, 399, 79, 0, 1, 1, '2026-09-30 01:23:00', '2026-09-30 01:23:00'),
(74, 400, 80, 1, 1, 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59'),
(75, 401, 81, 1, 1, 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59'),
(76, 402, 82, 1, 1, 1, '2026-09-30 20:32:33', '2026-09-30 20:32:33'),
(77, 403, 83, 1, 1, 1, '2026-09-30 20:32:33', '2026-09-30 20:32:33'),
(78, 405, 84, 1, 1, 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(79, 406, 85, 1, 1, 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(80, 408, 95, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(81, 408, 92, 1, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(82, 409, 96, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(83, 410, 97, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(84, 411, 89, 1, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(85, 412, 90, 1, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(86, 413, 87, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(87, 414, 93, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(88, 415, 94, 0, 1, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(89, 416, 107, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(90, 416, 104, 1, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(91, 417, 108, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(92, 418, 109, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(93, 419, 101, 1, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(94, 420, 102, 1, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(95, 421, 99, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(96, 422, 105, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(97, 423, 106, 0, 1, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33');

-- --------------------------------------------------------

--
-- Table structure for table `step_roles`
--
CREATE TABLE `step_roles` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `step_roles`
--

INSERT INTO `step_roles` (`id`, `workflow_step_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 4, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(2, 5, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(3, 6, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(4, 7, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(5, 8, 7, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(6, 9, 7, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(7, 10, 8, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(8, 11, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(9, 12, 10, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(10, 13, 9, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(11, 14, 11, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(12, 15, 12, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(13, 16, 12, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(14, 17, 13, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(29, 38, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(30, 39, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(31, 40, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(32, 41, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(33, 42, 7, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(34, 43, 7, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(35, 44, 8, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(36, 45, 6, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(37, 46, 10, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(38, 47, 9, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(39, 48, 11, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(40, 49, 12, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(41, 50, 12, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(42, 51, 13, '2026-09-23 17:27:37', '2026-09-23 17:27:37'),
(43, 70, 3, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(44, 71, 4, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(45, 1, 3, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(46, 2, 3, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(47, 2, 4, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(48, 3, 4, '2026-09-13 23:00:34', '2026-09-13 23:00:34'),
(49, 72, 3, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(50, 73, 3, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(51, 73, 4, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(52, 74, 4, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(83, 98, 6, '2026-09-25 22:58:07', '2026-09-25 22:58:07'),
(84, 99, 3, '2026-09-25 22:59:10', '2026-09-25 22:59:10'),
(85, 100, 3, '2026-09-25 23:01:04', '2026-09-25 23:01:04'),
(86, 101, 3, '2026-09-25 23:04:57', '2026-09-25 23:04:57'),
(87, 102, 3, '2026-09-25 23:06:04', '2026-09-25 23:06:04'),
(88, 103, 3, '2026-09-25 23:07:29', '2026-09-25 23:07:29'),
(89, 104, 4, '2026-09-25 23:08:29', '2026-09-25 23:08:29'),
(90, 105, 3, '2026-09-25 23:09:33', '2026-09-25 23:09:33'),
(92, 107, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(93, 108, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(94, 109, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(95, 110, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(96, 111, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(97, 112, 4, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(98, 113, 3, '2026-09-25 23:12:20', '2026-09-25 23:12:20'),
(99, 106, 15, '2026-09-25 23:13:20', '2026-09-25 23:13:20'),
(100, 114, 15, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(101, 115, 3, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(103, 117, 3, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(104, 118, 3, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(105, 119, 3, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(106, 120, 4, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(107, 121, 3, '2026-09-25 23:13:32', '2026-09-25 23:13:32'),
(108, 116, 15, '2026-09-25 23:13:45', '2026-09-25 23:13:45'),
(109, 122, 15, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(110, 123, 3, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(111, 124, 15, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(112, 125, 3, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(113, 126, 3, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(115, 128, 4, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(116, 129, 3, '2026-09-25 23:14:13', '2026-09-25 23:14:13'),
(117, 127, 16, '2026-09-25 23:15:24', '2026-09-25 23:15:24'),
(118, 130, 15, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(119, 131, 3, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(120, 132, 15, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(121, 133, 3, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(122, 134, 3, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(123, 135, 16, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(125, 137, 3, '2026-09-25 23:15:34', '2026-09-25 23:15:34'),
(126, 136, 15, '2026-09-25 23:15:43', '2026-09-25 23:15:43'),
(127, 138, 15, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(128, 139, 3, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(129, 140, 15, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(130, 141, 3, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(131, 142, 3, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(132, 143, 16, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(133, 144, 15, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(134, 145, 3, '2026-09-25 23:15:47', '2026-09-25 23:15:47'),
(135, 146, 15, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(136, 147, 3, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(137, 148, 15, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(138, 149, 3, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(139, 150, 3, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(140, 151, 16, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(141, 152, 15, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(142, 153, 3, '2026-09-25 23:16:00', '2026-09-25 23:16:00'),
(143, 154, 15, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(144, 155, 3, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(145, 156, 15, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(146, 157, 3, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(147, 158, 3, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(148, 159, 16, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(149, 160, 15, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(150, 161, 3, '2026-09-25 23:16:13', '2026-09-25 23:16:13'),
(151, 162, 15, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(152, 163, 3, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(153, 164, 15, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(154, 165, 3, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(155, 166, 3, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(156, 167, 16, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(157, 168, 15, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(158, 169, 3, '2026-09-25 23:16:28', '2026-09-25 23:16:28'),
(159, 170, 15, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(160, 171, 3, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(161, 172, 15, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(162, 173, 3, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(163, 174, 3, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(164, 175, 16, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(165, 176, 15, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(166, 177, 3, '2026-09-25 23:16:41', '2026-09-25 23:16:41'),
(167, 178, 15, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(168, 179, 3, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(169, 180, 15, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(170, 181, 3, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(171, 182, 3, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(172, 183, 16, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(173, 184, 15, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(174, 185, 3, '2026-09-25 23:16:57', '2026-09-25 23:16:57'),
(175, 186, 15, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(176, 187, 3, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(177, 188, 15, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(178, 189, 3, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(179, 190, 3, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(180, 191, 16, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(181, 192, 15, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(182, 193, 3, '2026-09-25 23:17:13', '2026-09-25 23:17:13'),
(183, 194, 15, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(184, 195, 3, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(185, 196, 15, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(186, 197, 3, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(187, 198, 3, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(188, 199, 16, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(189, 200, 15, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(190, 201, 3, '2026-09-25 23:17:34', '2026-09-25 23:17:34'),
(191, 202, 15, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(192, 203, 3, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(193, 204, 15, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(194, 205, 3, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(195, 206, 3, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(196, 207, 16, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(197, 208, 15, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(198, 209, 3, '2026-09-25 23:17:45', '2026-09-25 23:17:45'),
(199, 210, 15, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(200, 211, 3, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(201, 212, 15, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(202, 213, 3, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(203, 214, 3, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(204, 215, 16, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(205, 216, 15, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(206, 217, 3, '2026-09-27 22:13:53', '2026-09-27 22:13:53'),
(207, 218, 15, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(208, 219, 3, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(209, 220, 15, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(210, 221, 3, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(211, 222, 3, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(212, 223, 16, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(213, 224, 15, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(214, 225, 3, '2026-09-27 22:14:30', '2026-09-27 22:14:30'),
(215, 226, 15, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(216, 227, 3, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(217, 228, 15, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(218, 229, 3, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(219, 230, 3, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(220, 231, 16, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(221, 232, 15, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(222, 233, 3, '2026-09-27 22:15:04', '2026-09-27 22:15:04'),
(223, 234, 15, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(224, 235, 3, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(225, 236, 15, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(226, 237, 3, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(227, 238, 3, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(228, 239, 16, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(229, 240, 15, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(230, 241, 3, '2026-09-27 22:15:25', '2026-09-27 22:15:25'),
(231, 242, 15, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(232, 243, 3, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(233, 244, 15, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(234, 245, 3, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(235, 246, 3, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(236, 247, 16, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(237, 248, 15, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(238, 249, 3, '2026-09-28 17:20:34', '2026-09-28 17:20:34'),
(239, 250, 15, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(240, 251, 3, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(241, 252, 15, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(242, 253, 3, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(243, 254, 3, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(244, 255, 16, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(245, 256, 15, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(246, 257, 3, '2026-09-28 17:27:45', '2026-09-28 17:27:45'),
(247, 258, 14, '2026-09-28 17:28:13', '2026-09-28 17:28:13'),
(248, 259, 15, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(249, 260, 3, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(250, 261, 15, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(251, 262, 3, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(252, 263, 3, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(253, 264, 16, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(254, 265, 15, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(255, 266, 3, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(256, 267, 14, '2026-09-28 17:31:40', '2026-09-28 17:31:40'),
(257, 268, 15, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(258, 269, 3, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(259, 270, 15, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(260, 271, 3, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(261, 272, 3, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(262, 273, 16, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(263, 274, 15, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(264, 275, 3, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(265, 276, 14, '2026-09-28 17:32:11', '2026-09-28 17:32:11'),
(266, 277, 14, '2026-09-28 17:33:29', '2026-09-28 17:33:29'),
(267, 278, 14, '2026-09-28 17:35:21', '2026-09-28 17:35:21'),
(268, 279, 14, '2026-09-28 17:36:00', '2026-09-28 17:36:00'),
(269, 280, 14, '2026-09-28 17:36:47', '2026-09-28 17:36:47'),
(270, 281, 14, '2026-09-28 17:37:46', '2026-09-28 17:37:46'),
(271, 282, 14, '2026-09-28 17:38:27', '2026-09-28 17:38:27'),
(272, 283, 14, '2026-09-28 17:39:16', '2026-09-28 17:39:16'),
(273, 284, 14, '2026-09-28 17:47:01', '2026-09-28 17:47:01'),
(274, 285, 14, '2026-09-28 17:51:04', '2026-09-28 17:51:04'),
(275, 286, 11, '2026-09-29 23:27:22', '2026-09-29 23:27:22'),
(276, 287, 2, '2026-09-29 23:34:30', '2026-09-29 23:34:30'),
(277, 288, 12, '2026-09-29 23:37:11', '2026-09-29 23:37:11'),
(278, 289, 2, '2026-09-29 23:37:52', '2026-09-29 23:37:52'),
(279, 290, 12, '2026-09-29 23:37:52', '2026-09-29 23:37:52'),
(280, 291, 15, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(281, 292, 3, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(282, 293, 15, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(283, 294, 3, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(284, 295, 3, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(285, 296, 16, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(286, 297, 15, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(287, 298, 3, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(288, 299, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(289, 300, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(290, 301, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(291, 302, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(292, 303, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(293, 304, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(294, 305, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(295, 306, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(296, 307, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(297, 308, 14, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(298, 309, 11, '2026-09-30 00:23:40', '2026-09-30 00:23:40'),
(317, 328, 14, '2026-09-30 00:33:36', '2026-09-30 00:33:36'),
(318, 329, 14, '2026-09-30 00:34:50', '2026-09-30 00:34:50'),
(319, 330, 14, '2026-09-30 00:35:35', '2026-09-30 00:35:35'),
(320, 331, 14, '2026-09-30 00:36:14', '2026-09-30 00:36:14'),
(321, 332, 14, '2026-09-30 00:36:56', '2026-09-30 00:36:56'),
(322, 333, 14, '2026-09-30 00:37:32', '2026-09-30 00:37:32'),
(323, 334, 14, '2026-09-30 00:38:24', '2026-09-30 00:38:24'),
(324, 335, 14, '2026-09-30 00:42:34', '2026-09-30 00:42:34'),
(325, 336, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(326, 337, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(327, 338, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(328, 339, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(329, 340, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(330, 341, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(331, 342, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(332, 343, 14, '2026-09-30 00:52:28', '2026-09-30 00:52:28'),
(333, 344, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(334, 345, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(335, 346, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(336, 347, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(337, 348, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(338, 349, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(339, 350, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(340, 351, 14, '2026-09-30 00:55:17', '2026-09-30 00:55:17'),
(341, 352, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(342, 353, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(343, 354, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(344, 355, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(345, 356, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(346, 357, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(347, 358, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(348, 359, 14, '2026-09-30 00:55:27', '2026-09-30 00:55:27'),
(349, 360, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(350, 361, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(351, 362, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(352, 363, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(353, 364, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(354, 365, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(355, 366, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(356, 367, 14, '2026-09-30 00:55:37', '2026-09-30 00:55:37'),
(357, 368, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(358, 369, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(359, 370, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(360, 371, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(361, 372, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(362, 373, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(363, 374, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(364, 375, 14, '2026-09-30 00:55:49', '2026-09-30 00:55:49'),
(365, 376, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(366, 377, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(367, 378, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(368, 379, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(369, 380, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(370, 381, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(371, 382, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(372, 383, 14, '2026-09-30 00:56:08', '2026-09-30 00:56:08'),
(373, 384, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(374, 385, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(375, 386, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(376, 387, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(377, 388, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(378, 389, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(379, 390, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(380, 391, 14, '2026-09-30 00:56:20', '2026-09-30 00:56:20'),
(381, 392, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(382, 393, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(383, 394, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(384, 395, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(385, 396, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(386, 397, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(387, 398, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(388, 399, 14, '2026-09-30 01:15:05', '2026-09-30 01:15:05'),
(389, 400, 3, '2026-09-30 20:31:59', '2026-09-30 20:31:59'),
(390, 401, 4, '2026-09-30 20:31:59', '2026-09-30 20:31:59'),
(391, 402, 3, '2026-09-30 20:32:32', '2026-09-30 20:32:32'),
(392, 403, 4, '2026-09-30 20:32:32', '2026-09-30 20:32:32'),
(393, 404, 11, '2026-09-30 20:33:10', '2026-09-30 20:33:10'),
(394, 405, 3, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(395, 406, 4, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(396, 407, 11, '2026-09-30 20:33:37', '2026-09-30 20:33:37'),
(397, 408, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(398, 409, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(399, 410, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(400, 411, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(401, 412, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(402, 413, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(403, 414, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(404, 415, 14, '2026-10-04 17:33:21', '2026-10-04 17:33:21'),
(405, 416, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(406, 417, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(407, 418, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(408, 419, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(409, 420, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(410, 421, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(411, 422, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33'),
(412, 423, 14, '2026-10-04 17:33:33', '2026-10-04 17:33:33');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--
CREATE TABLE `transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_type_id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `reference_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_done` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `transaction_type_id`, `workflow_definition_id`, `office_id`, `reference_number`, `title`, `is_done`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 3, 3, NULL, 'JFCW-GO9W-DM6Q', 'Communication 1', 0, 1, '2026-03-09 23:51:48', '2026-09-15 19:31:38', '2026-09-15 19:31:38'),
(2, 3, 3, NULL, 'UTST-CZUL-F55O', 'Communication 2', 0, 1, '2026-03-09 23:57:06', '2026-09-15 19:31:42', '2026-09-15 19:31:42'),
(3, 3, 4, NULL, 'TSYP-YHTP-JNWK', 'Communication 3', 0, 1, '2026-03-09 23:57:31', '2026-09-15 19:31:46', '2026-09-15 19:31:46'),
(4, 3, 4, NULL, '7ERC-ULBD-0AV1', 'Communication 4', 0, 1, '2026-03-10 00:32:03', '2026-09-15 19:31:50', '2026-09-15 19:31:50'),
(5, 3, 4, 9, 'GCHJ-9XQD-CV59', 'Shopee', 0, 1, '2026-09-11 16:50:34', '2026-09-15 19:31:54', '2026-09-15 19:31:54'),
(9, 2, 7, 9, 'K8JB-EEGG-36OC', 'Lazada', 0, 1, '2026-09-11 22:24:51', '2026-09-27 22:16:49', '2026-09-27 22:16:49'),
(10, 3, 4, NULL, 'CC5T-ZXED-JAFX', 'Lazada', 0, 1, '2026-09-13 22:42:14', '2026-09-15 19:32:01', '2026-09-15 19:32:01'),
(11, 2, 7, NULL, '4JNN-BZGT-BRYB', 'qwe', 0, 1, '2026-09-13 22:48:16', '2026-09-27 22:16:52', '2026-09-27 22:16:52'),
(12, 3, 16, NULL, 'LUC2-ULOD-KIFH', 'ewq', 0, 1, '2026-09-13 22:48:28', '2026-09-27 22:16:55', '2026-09-27 22:16:55'),
(13, 1, 1, NULL, 'OWOB-BEOY-FW1M', 'eqweqwe', 0, 1, '2026-09-13 22:48:43', '2026-09-27 22:16:59', '2026-09-27 22:16:59'),
(14, 1, 1, NULL, 'HHZB-GGI6-RIQH', 'new', 0, 1, '2026-09-14 00:13:33', '2026-09-27 22:17:11', '2026-09-27 22:17:11'),
(15, 1, 1, NULL, 'VYIR-X6GM-MMXP', 'BAAA', 1, 1, '2026-09-15 19:18:48', '2026-09-27 22:17:14', '2026-09-27 22:17:14'),
(16, 1, 1, NULL, 'Z5UP-ADG3-47IT', NULL, 1, 1, '2026-09-20 17:09:18', '2026-09-27 22:17:17', '2026-09-27 22:17:17'),
(17, 2, 7, NULL, 'G6RW-ZX2H-UUMI', NULL, 0, 1, '2026-09-20 19:10:13', '2026-09-27 22:17:20', '2026-09-27 22:17:20'),
(18, 2, 7, NULL, '4YD8-5DKW-JCYT', NULL, 0, 1, '2026-09-21 17:15:15', '2026-09-27 22:17:23', '2026-09-27 22:17:23'),
(19, 1, 1, 22, 'M5JW-EMVY-6REJ', 'adsa', 0, 1, '2026-09-22 18:12:24', '2026-09-29 16:15:16', '2026-09-29 16:15:16'),
(20, 1, 1, 21, '5PAV-VMC3-7KNX', 'almost', 0, 1, '2026-09-22 18:42:49', '2026-09-29 16:15:19', '2026-09-29 16:15:19'),
(21, 2, 7, 21, 'WMMQ-TXQM-KHWO', 'e', 0, 1, '2026-09-23 17:25:08', '2026-09-29 16:15:22', '2026-09-29 16:15:22'),
(22, 1, 1, 24, 'YLAA-6XW4-FZOH', 'Payroll For Sharief', 0, 1, '2026-09-24 18:50:22', '2026-09-29 16:15:24', '2026-09-29 16:15:24'),
(23, 2, 7, 24, 'Q9TM-29EI-BD6H', 'TISTING', 0, 1, '2026-09-24 19:18:37', '2026-09-29 16:15:27', '2026-09-29 16:15:27'),
(24, 2, 7, 24, 'VMMR-UGLN-OTKG', 'Testing', 0, 1, '2026-09-24 19:22:47', '2026-09-29 16:15:44', '2026-09-29 16:15:44'),
(26, 9, 39, NULL, 'PBXC-UHD1-HBAJ', NULL, 1, 1, '2026-09-25 23:18:46', '2026-09-29 16:15:34', '2026-09-29 16:15:34'),
(27, 9, 39, 24, 'GVMS-GIEX-GXSS', NULL, 0, 1, '2026-09-26 00:46:46', '2026-09-29 16:15:46', '2026-09-29 16:15:46'),
(28, 1, 17, 24, '3VZO-F8OG-28XK', NULL, 1, 1, '2026-09-26 01:01:06', '2026-09-29 16:15:51', '2026-09-29 16:15:51'),
(29, 9, 43, 24, 'LKFA-RUF3-OIWT', NULL, 0, 1, '2026-09-27 22:17:39', '2026-09-30 16:08:49', '2026-09-30 16:08:49'),
(30, 1, 17, 8, 'POYT-3B32-0Y8P', NULL, 0, 1, '2026-09-28 18:45:58', '2026-09-30 16:08:53', '2026-09-30 16:08:53'),
(31, 1, 17, 22, 'KYR2-A1PI-SK9P', NULL, 0, 1, '2026-09-28 18:51:58', '2026-09-28 21:29:47', '2026-09-28 21:29:47'),
(32, 1, 17, 24, 'ROQO-Z1YN-DW1W', NULL, 0, 1, '2026-09-28 21:33:30', '2026-09-30 16:08:57', '2026-09-30 16:08:57'),
(33, 9, 46, 25, 'OX84-PMLV-HER6', 'LEGAL OFFICEEEE', 0, 1, '2026-09-29 23:25:53', '2026-09-29 23:29:11', '2026-09-29 23:29:11'),
(34, 9, 47, 21, 'LOHR-3WAY-OUA1', 'waawdaw', 0, 1, '2026-09-29 23:28:31', '2026-09-29 23:29:08', '2026-09-29 23:29:08'),
(35, 1, 17, 21, 'EIWE-HTYG-FUJ8', NULL, 0, 1, '2026-09-30 00:12:36', '2026-09-30 16:09:00', '2026-09-30 16:09:00'),
(36, 11, 53, 24, 'CRVI-X0P1-WSOM', NULL, 0, 1, '2026-09-30 00:54:47', '2026-09-30 00:58:22', '2026-09-30 00:58:22'),
(37, 11, 60, 24, '2BEY-TTBW-NPT7', NULL, 0, 1, '2026-09-30 00:58:33', '2026-09-30 01:31:02', '2026-09-30 01:31:02'),
(38, 11, 61, 24, 'BNWR-79LJ-VBVP', NULL, 1, 1, '2026-09-30 01:31:10', '2026-09-30 16:09:04', '2026-09-30 16:09:04'),
(39, 11, 61, 24, 'MWY6-RWFW-BF41', NULL, 0, 1, '2026-09-30 01:44:55', '2026-09-30 17:07:23', '2026-09-30 17:07:23'),
(40, 11, 61, 24, 'NU5A-C47R-ESAV', NULL, 0, 1, '2026-09-30 16:09:17', '2026-09-30 16:09:17', NULL),
(41, 11, 66, 24, 'AEFT-WUDT-SHDA', NULL, 0, 1, '2026-10-04 17:34:21', '2026-10-04 17:34:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_attachments`
--
CREATE TABLE `transaction_attachments` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `requirement_definition_id` bigint UNSIGNED DEFAULT NULL,
  `step_run_id` bigint UNSIGNED DEFAULT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stored_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disk` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `mime` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size_bytes` bigint UNSIGNED NOT NULL DEFAULT '0',
  `uploaded_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_attachments`
--

INSERT INTO `transaction_attachments` (`id`, `transaction_id`, `workflow_step_id`, `requirement_definition_id`, `step_run_id`, `original_name`, `stored_path`, `disk`, `mime`, `size_bytes`, `uploaded_by`, `created_at`, `updated_at`) VALUES
(1, 9, 40, 20, NULL, 'updatedTRANSACTION.sql', 'attachments/9/40/byLWjADXvnDJyNO1ePVkxabS2GQXFCJCsxzaacK2.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:15:19', '2026-09-15 19:15:19'),
(2, 15, 1, 27, NULL, 'updatedTRANSACTION.sql', 'attachments/15/1/hZLkJbKmX5VsOh2rpmO4CT94aL8BcBWlenTJWP0d.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:19:09', '2026-09-15 19:19:09'),
(3, 15, 1, NULL, 29, 'updatedTRANSACTION.sql', 'attachments/15/1/SlBUOGC2MRwZv89P7ZdhM2gNVMHFkZNy7i6t0aUb.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:19:26', '2026-09-15 19:19:31'),
(4, 15, 2, 28, NULL, 'updatedTRANSACTION.sql', 'attachments/15/2/SUN2o8FaukgttwMQL1VAarPnERIAQaY5t5QiC3Dh.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:19:50', '2026-09-15 19:19:50'),
(5, 15, 2, NULL, 30, 'updatedTRANSACTION.sql', 'attachments/15/2/eYbl6TUKCJ2TJf6j3NVx3KjMswKGvzmo3KFOF8Sh.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:20:03', '2026-09-15 19:20:06'),
(6, 15, 1, NULL, 31, 'updatedTRANSACTION.sql', 'attachments/15/1/dm6deCRTaM7p9sTUkcZ2uTue6lgU5PduPWt8RWjK.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:25:03', '2026-09-15 19:25:05'),
(9, 20, 1, 27, NULL, 'updatedTRANSACTION.sql', 'attachments/20/1/MQEG1RPeMcEZGhseferAqu4b5iu9uyO0GwKMZ5u6.txt', 'local', 'text/plain', 85545, 1, '2026-09-22 19:22:58', '2026-09-22 19:22:58'),
(10, 20, 1, 36, NULL, 'updatedTRANSACTION.sql', 'attachments/20/1/i7YAyOFBihN1x2iufEjejB0zFF7pCvQIBeYwRXW1.txt', 'local', 'text/plain', 85545, 1, '2026-09-22 19:23:03', '2026-09-22 19:23:03'),
(11, 22, 1, 27, 104, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'attachments/22/1/pdyQ0LR9YWs9oR7bxEU1QWs8PIh2xy5J2xrxXSDL.pdf', 'local', 'application/pdf', 584366, 1, '2026-09-24 18:54:07', '2026-09-24 18:54:17'),
(12, 22, 1, 36, 104, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', 'attachments/22/1/d1ojR66DO3C6X0J5dTdzEcac2NkBimqkRImIZcVF.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-24 18:54:13', '2026-09-24 18:54:17'),
(13, 22, 2, 28, 105, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'attachments/22/2/mT1HTLREHoAcayXMpDPWDBtjaIrKfpZ6rhJLIsmB.pdf', 'local', 'application/pdf', 470731, 1, '2026-09-24 18:57:43', '2026-09-24 18:58:02'),
(14, 24, 38, 23, 110, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', 'attachments/24/38/FALzG59NKNo6SiYG8RwTdSkinJsZwfrw8IjVApI8.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-25 22:25:52', '2026-09-25 22:25:55'),
(15, 28, 72, 35, 122, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', 'attachments/28/72/gV4eCAaMrSYdnJNP03NZW6ZCZhoDygCA0AbolZ5O.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-26 01:01:55', '2026-09-26 01:02:03'),
(16, 28, 72, 30, 122, 'APPPROVED BUDGET FOR THE CONTRACT.pdf', 'attachments/28/72/5iLGSSXzNEhaHKmyVbhHqKNU2sk0Ez5oPuKBYujv.pdf', 'local', 'application/pdf', 427193, 1, '2026-09-26 01:02:00', '2026-09-26 01:02:03'),
(17, 28, 73, 31, 123, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', 'attachments/28/73/me1DYTxYZZ8iDSqr9EtTwyTfNnCmS7JbwLCyWTFl.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-26 01:05:13', '2026-09-26 01:05:21'),
(18, 30, 72, 35, 139, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'attachments/30/72/Kgw1kf9SyAYFWlunAonj6QRRpfYyn4OPeBUgg6vu.pdf', 'local', 'application/pdf', 8594822, 1, '2026-09-28 18:46:15', '2026-09-28 18:46:28'),
(19, 30, 72, 30, 139, 'APPOINTMENT  OF DUTY BRY WEE AL BASHIR ROPETA.pdf', 'attachments/30/72/ynHL3lyj1o6o46E1K9fJoJ0wItFnJUnOcHxCQnJk.pdf', 'local', 'application/pdf', 1149079, 1, '2026-09-28 18:46:21', '2026-09-28 18:46:28'),
(20, 30, 73, 31, NULL, 'AFFIDAVIT OF LOSS.pdf', 'attachments/30/73/182w2207upCAIcPTI7TMd5STb77Kgrthw2sAIGkp.pdf', 'local', 'application/pdf', 325045, 1, '2026-09-28 18:48:05', '2026-09-28 18:48:05'),
(21, 31, 72, 35, 141, 'APPOINTMENT  OF DUTY BRY WEE AL BASHIR ROPETA.pdf', 'attachments/31/72/JF52qlz9sxrrHowymh840Vnl1CJjnXyDwRXwVOS6.pdf', 'local', 'application/pdf', 1149079, 1, '2026-09-28 18:52:11', '2026-09-28 18:52:22'),
(22, 31, 72, 30, 141, 'ANNUAL MEMBERSHIP TO THE ETRACS SUSTAINABILITY PROGRAM FOR THE CITY GOV.pdf', 'attachments/31/72/7SEvtfOy4zzi5J8i3oudd2bpGbWh2PN3pW9TpgEn.pdf', 'local', 'application/pdf', 248246, 1, '2026-09-28 18:52:16', '2026-09-28 18:52:22'),
(41, 32, 72, 37, 165, 'Payroll.pdf', 'attachments/32/72/Vj6dZi4FhBAsOEiUZ34tdQhaX6h93T7GOR53YN5g.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 23:15:58', '2026-09-29 23:41:58'),
(42, 32, 72, 35, 165, 'AR.pdf', 'attachments/32/72/0BPV2sIpGeEBvK6M5xWrL9ciQFbwFvxoF5XBYgzH.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 23:16:02', '2026-09-29 23:41:58'),
(43, 35, 72, 37, 171, 'Payroll.pdf', 'attachments/35/72/nRNKMFzx6NWpEvKcWBNbBVPvoMxzQBqkpS721FhT.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-30 00:13:51', '2026-09-30 00:13:57'),
(44, 35, 72, 35, 171, 'AR.pdf', 'attachments/35/72/cLwAsEhAd9tjWb8pqlkQvz5HVsegI0VDtZt6utrg.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 00:13:54', '2026-09-30 00:13:57'),
(45, 35, 73, 39, 172, 'Birthcert.pdf', 'attachments/35/73/BxNLrpGWHVwX2VLNUql55uaT2qz3f6THXtT6tO4I.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-30 00:15:55', '2026-09-30 00:19:36'),
(46, 35, 73, 31, 172, 'DTR validated.pdf', 'attachments/35/73/qkxQBa5R02HhNct2NYzCssxggvXor0HWeztonhVY.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-30 00:16:00', '2026-09-30 00:19:36'),
(47, 37, 384, 56, 180, 'AR.pdf', 'attachments/37/384/uxQ7r6bQ3pgCoc1lCDJONekjknKhFzsTMQlhtRX3.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:17:44', '2026-09-30 01:17:49'),
(48, 37, 384, 55, 180, 'AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf', 'attachments/37/384/rU6Pj0tWbmD5vULnlefQ0H5cRiuMOSbl4Q3GetNo.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-30 01:17:47', '2026-09-30 01:17:49'),
(49, 37, 385, 58, 181, 'INCOME GENERATED BY THE CITY FROM NEW BUSINESS.pdf', 'attachments/37/385/AzwxR7mOCbmc3IR1BGD3rp4xSGVuh8MtpOS7ohue.pdf', 'local', 'application/pdf', 290838, 1, '2026-09-30 01:18:01', '2026-09-30 01:19:41'),
(50, 37, 386, 59, 182, 'AR.pdf', 'attachments/37/386/KDi3vTw7Hy3y4vWFDusI5vvFPsk8F0fhbKFa2MUW.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:19:53', '2026-09-30 01:20:01'),
(51, 37, 387, 64, 183, 'AR.pdf', 'attachments/37/387/6XFVaFEUFzIJfcm9j5MCeQFagmppFCYFj5tWyAPm.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:20:26', '2026-09-30 01:20:28'),
(52, 37, 388, 62, 184, 'Birthcert.pdf', 'attachments/37/388/gpOv2kEPeMjh6AsTcqxNLhtq1Pcg0JXmF3wKYldb.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-30 01:20:45', '2026-09-30 01:20:54'),
(53, 37, 389, 66, 185, 'AR.pdf', 'attachments/37/389/TCaB43a4Dr6D8OH9tOZIkv4hxKvJ4ErH4uUJa2nn.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:21:10', '2026-09-30 01:21:11'),
(54, 38, 392, 74, 190, 'AR.pdf', 'attachments/38/392/CdbLgzRQgqeLlPoRep9Qa99okYOo1K5L4IhnUVot.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:31:25', '2026-09-30 01:31:30'),
(55, 38, 392, 73, 190, 'AR.pdf', 'attachments/38/392/b80bppIb50Ja2HqRUOQqnofrQSV8d8iF2y0Snrin.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:31:29', '2026-09-30 01:31:30'),
(56, 38, 393, 75, 191, 'AR.pdf', 'attachments/38/393/kg8iuCimu9QHrvlqmaQIXFGT6lh6h9VqxKymEtC5.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:31:47', '2026-09-30 01:31:49'),
(57, 38, 394, 76, 192, 'AR.pdf', 'attachments/38/394/BCueZ9u7cj18n3nOxQOysGJa7DgLf9xvBQF9gMOj.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:32:02', '2026-09-30 01:32:04'),
(58, 38, 395, 70, 193, 'AR.pdf', 'attachments/38/395/ydhVKYaWxyV9eKYAvieC4T44yKxiql1XjmpN2Y5L.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:32:16', '2026-09-30 01:32:20'),
(59, 38, 396, 71, 194, 'AR.pdf', 'attachments/38/396/8j68fFN6EnhTkJgaefgdes670jGg0sYxD9LQUcVG.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:44:02', '2026-09-30 01:44:03'),
(60, 38, 397, 68, 195, 'AR.pdf', 'attachments/38/397/C8NxF0rVxAtyuHxQsyLxyt9sSfVM0BogpDchpfTC.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:44:18', '2026-09-30 01:44:20'),
(61, 38, 398, 77, 196, 'AR.pdf', 'attachments/38/398/5Rb6SrKvZavzmMMMexEyXTMa4scGrejvpoQDj2B5.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:44:30', '2026-09-30 01:44:32'),
(62, 39, 392, 74, 199, 'AR.pdf', 'attachments/39/392/g1GLrynOmE7OR1KQ2puGx4L9K8PuXCnzy4qRPMIe.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:47:10', '2026-09-30 01:47:17'),
(63, 39, 392, 73, 199, 'AR.pdf', 'attachments/39/392/390wp17jmCARGgFNqi89ktqb7s17uO7Qo8PVQ2Iw.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:47:13', '2026-09-30 01:47:17'),
(64, 39, 393, 75, 200, 'AR.pdf', 'attachments/39/393/qTI2ycczwa52AjSPDtx5JbnHNTuOcWpVTXBEN2gA.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-30 01:48:05', '2026-09-30 01:49:31'),
(65, 40, 392, 74, 202, 'AR.pdf', 'attachments/40/392/If8wTVtno3BZ9gJXLaBQqsARvDK6dSi8VSd0J9C3.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-02 00:12:17', '2026-10-02 00:12:24'),
(66, 40, 392, 73, 202, 'AR.pdf', 'attachments/40/392/WrqrhZCU9iVa4ZOZlGmoLspGYOCRnCeGVmcnOuqD.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-02 00:12:21', '2026-10-02 00:12:24'),
(67, 40, 393, 75, 203, 'AR.pdf', 'attachments/40/393/kHHtEGfe7S3jBlIJ5gWrk5tIy5XWeAvZzcATXFRB.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-02 00:12:37', '2026-10-02 00:12:38');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_checklist_checks`
--
CREATE TABLE `transaction_checklist_checks` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `checklist_override_id` bigint UNSIGNED DEFAULT NULL,
  `checked_by` bigint UNSIGNED NOT NULL,
  `checked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_checklist_checks`
--

INSERT INTO `transaction_checklist_checks` (`id`, `transaction_id`, `workflow_step_id`, `checklist_override_id`, `checked_by`, `checked_at`, `created_at`, `updated_at`) VALUES
(1, 20, 1, NULL, 1, '2026-09-22 19:32:03', '2026-09-22 19:32:03', '2026-09-22 19:32:03'),
(2, 20, 1, NULL, 1, '2026-09-22 19:32:05', '2026-09-22 19:32:05', '2026-09-22 19:32:05'),
(3, 21, 38, NULL, 1, '2026-09-23 17:28:34', '2026-09-23 17:28:34', '2026-09-23 17:28:34'),
(4, 22, 2, 14, 1, '2026-09-24 18:57:51', '2026-09-24 18:57:51', '2026-09-24 18:57:51'),
(6, 22, 2, 15, 1, '2026-09-24 18:57:57', '2026-09-24 18:57:57', '2026-09-24 18:57:57'),
(7, 28, 73, 17, 1, '2026-09-26 01:05:19', '2026-09-26 01:05:19', '2026-09-26 01:05:19'),
(8, 28, 73, 18, 1, '2026-09-26 01:05:20', '2026-09-26 01:05:20', '2026-09-26 01:05:20'),
(10, 31, 73, 17, 1, '2026-09-28 21:21:24', '2026-09-28 21:21:24', '2026-09-28 21:21:24'),
(11, 31, 73, 18, 1, '2026-09-28 21:21:25', '2026-09-28 21:21:25', '2026-09-28 21:21:25'),
(12, 24, 39, 16, 1, '2026-09-28 22:21:58', '2026-09-28 22:21:58', '2026-09-28 22:21:58'),
(33, 35, 73, 17, 1, '2026-09-30 00:14:38', '2026-09-30 00:14:38', '2026-09-30 00:14:38'),
(34, 35, 73, 18, 1, '2026-09-30 00:14:39', '2026-09-30 00:14:39', '2026-09-30 00:14:39'),
(35, 35, 73, 20, 1, '2026-09-30 00:14:40', '2026-09-30 00:14:40', '2026-09-30 00:14:40'),
(36, 35, 73, 21, 1, '2026-09-30 00:14:41', '2026-09-30 00:14:41', '2026-09-30 00:14:41'),
(37, 37, 385, 35, 1, '2026-09-30 01:17:52', '2026-09-30 01:17:52', '2026-09-30 01:17:52'),
(38, 37, 385, 36, 1, '2026-09-30 01:17:53', '2026-09-30 01:17:53', '2026-09-30 01:17:53'),
(39, 37, 386, 38, 1, '2026-09-30 01:19:44', '2026-09-30 01:19:44', '2026-09-30 01:19:44'),
(40, 37, 387, 39, 1, '2026-09-30 01:20:06', '2026-09-30 01:20:06', '2026-09-30 01:20:06'),
(41, 37, 388, 43, 1, '2026-09-30 01:20:34', '2026-09-30 01:20:34', '2026-09-30 01:20:34'),
(42, 37, 389, 42, 1, '2026-09-30 01:20:58', '2026-09-30 01:20:58', '2026-09-30 01:20:58'),
(43, 37, 390, 44, 1, '2026-09-30 01:21:16', '2026-09-30 01:21:16', '2026-09-30 01:21:16'),
(44, 38, 393, 45, 1, '2026-09-30 01:31:34', '2026-09-30 01:31:34', '2026-09-30 01:31:34'),
(45, 38, 393, 46, 1, '2026-09-30 01:31:35', '2026-09-30 01:31:35', '2026-09-30 01:31:35'),
(46, 38, 394, 47, 1, '2026-09-30 01:31:53', '2026-09-30 01:31:53', '2026-09-30 01:31:53'),
(47, 38, 395, 48, 1, '2026-09-30 01:32:08', '2026-09-30 01:32:08', '2026-09-30 01:32:08'),
(48, 38, 396, 49, 1, '2026-09-30 01:32:24', '2026-09-30 01:32:24', '2026-09-30 01:32:24'),
(49, 38, 397, 50, 1, '2026-09-30 01:44:08', '2026-09-30 01:44:08', '2026-09-30 01:44:08'),
(50, 38, 398, 51, 1, '2026-09-30 01:44:23', '2026-09-30 01:44:23', '2026-09-30 01:44:23'),
(51, 39, 393, 45, 1, '2026-09-30 01:47:33', '2026-09-30 01:47:33', '2026-09-30 01:47:33'),
(52, 39, 393, 46, 1, '2026-09-30 01:47:35', '2026-09-30 01:47:35', '2026-09-30 01:47:35'),
(53, 40, 393, 45, 1, '2026-10-02 00:12:29', '2026-10-02 00:12:29', '2026-10-02 00:12:29'),
(54, 40, 393, 46, 1, '2026-10-02 00:12:30', '2026-10-02 00:12:30', '2026-10-02 00:12:30');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_requirement_checks`
--
CREATE TABLE `transaction_requirement_checks` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `requirement_definition_id` bigint UNSIGNED NOT NULL,
  `checked_by` bigint UNSIGNED NOT NULL,
  `checked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_requirement_checks`
--

INSERT INTO `transaction_requirement_checks` (`id`, `transaction_id`, `workflow_step_id`, `requirement_definition_id`, `checked_by`, `checked_at`, `created_at`, `updated_at`) VALUES
(4, 9, 38, 23, 1, '2026-09-13 19:36:34', '2026-09-13 19:36:34', '2026-09-13 19:36:34'),
(6, 9, 39, 19, 1, '2026-09-13 20:32:29', '2026-09-13 20:32:29', '2026-09-13 20:32:29'),
(7, 12, 70, 25, 1, '2026-09-13 23:04:43', '2026-09-13 23:04:43', '2026-09-13 23:04:43'),
(8, 12, 71, 26, 1, '2026-09-13 23:04:52', '2026-09-13 23:04:52', '2026-09-13 23:04:52'),
(9, 14, 1, 27, 1, '2026-09-14 00:16:35', '2026-09-14 00:16:35', '2026-09-14 00:16:35'),
(10, 14, 2, 28, 1, '2026-09-14 00:39:08', '2026-09-14 00:39:08', '2026-09-14 00:39:08'),
(11, 14, 3, 29, 1, '2026-09-14 00:42:21', '2026-09-14 00:42:21', '2026-09-14 00:42:21'),
(14, 15, 1, 27, 1, '2026-09-15 19:19:12', '2026-09-15 19:19:12', '2026-09-15 19:19:12'),
(15, 15, 2, 28, 1, '2026-09-15 19:19:53', '2026-09-15 19:19:53', '2026-09-15 19:19:53'),
(26, 9, 40, 20, 1, '2026-09-20 17:04:48', '2026-09-20 17:04:48', '2026-09-20 17:04:48'),
(31, 17, 38, 23, 1, '2026-09-20 19:30:46', '2026-09-20 19:30:46', '2026-09-20 19:30:46'),
(32, 17, 39, 19, 1, '2026-09-20 19:32:01', '2026-09-20 19:32:01', '2026-09-20 19:32:01'),
(33, 17, 40, 20, 1, '2026-09-20 22:12:24', '2026-09-20 22:12:24', '2026-09-20 22:12:24'),
(34, 18, 38, 23, 1, '2026-09-21 17:18:33', '2026-09-21 17:18:33', '2026-09-21 17:18:33'),
(35, 18, 39, 19, 1, '2026-09-21 17:21:44', '2026-09-21 17:21:44', '2026-09-21 17:21:44'),
(37, 18, 42, 22, 1, '2026-09-21 17:26:20', '2026-09-21 17:26:20', '2026-09-21 17:26:20'),
(46, 18, 40, 20, 1, '2026-09-21 23:15:29', '2026-09-21 23:15:29', '2026-09-21 23:15:29'),
(47, 16, 1, 27, 1, '2026-09-21 23:29:55', '2026-09-21 23:29:55', '2026-09-21 23:29:55'),
(48, 16, 2, 28, 1, '2026-09-21 23:30:09', '2026-09-21 23:30:09', '2026-09-21 23:30:09'),
(49, 19, 1, 27, 1, '2026-09-22 18:39:09', '2026-09-22 18:39:09', '2026-09-22 18:39:09'),
(94, 32, 72, 37, 1, '2026-09-29 23:15:41', '2026-09-29 23:15:41', '2026-09-29 23:15:41'),
(95, 32, 72, 30, 1, '2026-09-29 23:15:47', '2026-09-29 23:15:47', '2026-09-29 23:15:47'),
(96, 32, 72, 38, 1, '2026-09-29 23:15:48', '2026-09-29 23:15:48', '2026-09-29 23:15:48'),
(97, 32, 72, 35, 1, '2026-09-29 23:15:48', '2026-09-29 23:15:48', '2026-09-29 23:15:48'),
(98, 35, 72, 30, 1, '2026-09-30 00:13:43', '2026-09-30 00:13:43', '2026-09-30 00:13:43'),
(99, 35, 72, 37, 1, '2026-09-30 00:13:44', '2026-09-30 00:13:44', '2026-09-30 00:13:44'),
(100, 35, 72, 38, 1, '2026-09-30 00:13:45', '2026-09-30 00:13:45', '2026-09-30 00:13:45'),
(101, 35, 72, 35, 1, '2026-09-30 00:13:46', '2026-09-30 00:13:46', '2026-09-30 00:13:46'),
(103, 35, 73, 31, 1, '2026-09-30 00:14:45', '2026-09-30 00:14:45', '2026-09-30 00:14:45'),
(104, 35, 73, 39, 1, '2026-09-30 00:16:27', '2026-09-30 00:16:27', '2026-09-30 00:16:27'),
(105, 37, 384, 56, 1, '2026-09-30 01:17:37', '2026-09-30 01:17:37', '2026-09-30 01:17:37'),
(106, 37, 384, 55, 1, '2026-09-30 01:17:38', '2026-09-30 01:17:38', '2026-09-30 01:17:38'),
(107, 37, 385, 58, 1, '2026-09-30 01:17:57', '2026-09-30 01:17:57', '2026-09-30 01:17:57'),
(108, 37, 386, 59, 1, '2026-09-30 01:19:48', '2026-09-30 01:19:48', '2026-09-30 01:19:48'),
(109, 37, 387, 64, 1, '2026-09-30 01:20:13', '2026-09-30 01:20:13', '2026-09-30 01:20:13'),
(110, 37, 388, 62, 1, '2026-09-30 01:20:37', '2026-09-30 01:20:37', '2026-09-30 01:20:37'),
(111, 37, 389, 66, 1, '2026-09-30 01:21:01', '2026-09-30 01:21:01', '2026-09-30 01:21:01'),
(112, 38, 392, 74, 1, '2026-09-30 01:31:20', '2026-09-30 01:31:20', '2026-09-30 01:31:20'),
(113, 38, 392, 73, 1, '2026-09-30 01:31:20', '2026-09-30 01:31:20', '2026-09-30 01:31:20'),
(114, 38, 393, 75, 1, '2026-09-30 01:31:40', '2026-09-30 01:31:40', '2026-09-30 01:31:40'),
(115, 38, 394, 76, 1, '2026-09-30 01:31:58', '2026-09-30 01:31:58', '2026-09-30 01:31:58'),
(116, 38, 395, 70, 1, '2026-09-30 01:32:12', '2026-09-30 01:32:12', '2026-09-30 01:32:12'),
(117, 38, 396, 71, 1, '2026-09-30 01:32:27', '2026-09-30 01:32:27', '2026-09-30 01:32:27'),
(118, 38, 397, 68, 1, '2026-09-30 01:44:14', '2026-09-30 01:44:14', '2026-09-30 01:44:14'),
(119, 38, 398, 77, 1, '2026-09-30 01:44:26', '2026-09-30 01:44:26', '2026-09-30 01:44:26'),
(120, 39, 392, 74, 1, '2026-09-30 01:46:32', '2026-09-30 01:46:32', '2026-09-30 01:46:32'),
(121, 39, 392, 73, 1, '2026-09-30 01:46:34', '2026-09-30 01:46:34', '2026-09-30 01:46:34'),
(122, 39, 393, 75, 1, '2026-09-30 01:47:59', '2026-09-30 01:47:59', '2026-09-30 01:47:59'),
(123, 40, 392, 74, 1, '2026-09-30 17:07:56', '2026-09-30 17:07:56', '2026-09-30 17:07:56'),
(124, 40, 392, 73, 1, '2026-09-30 17:07:57', '2026-09-30 17:07:57', '2026-09-30 17:07:57'),
(125, 40, 393, 75, 1, '2026-10-02 00:12:33', '2026-10-02 00:12:33', '2026-10-02 00:12:33');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_states`
--
CREATE TABLE `transaction_states` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `current_step_id` bigint UNSIGNED NOT NULL,
  `entered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_states`
--

INSERT INTO `transaction_states` (`id`, `transaction_id`, `current_step_id`, `entered_at`, `created_at`, `updated_at`) VALUES
(1, 1, 19, '2026-03-09 23:53:29', '2026-03-09 23:51:48', '2026-03-09 23:53:29'),
(2, 2, 19, '2026-03-09 23:57:11', '2026-03-09 23:57:06', '2026-03-09 23:57:11'),
(3, 3, 20, '2026-03-10 00:00:39', '2026-03-09 23:57:31', '2026-03-10 00:00:39'),
(4, 4, 21, '2026-03-10 00:32:33', '2026-03-10 00:32:03', '2026-03-10 00:32:33'),
(5, 5, 20, '2026-09-11 16:50:34', '2026-09-11 16:50:34', '2026-09-11 16:50:34'),
(9, 9, 42, '2026-09-21 16:54:14', '2026-09-11 22:24:51', '2026-09-21 16:54:14'),
(10, 10, 20, '2026-09-13 22:42:14', '2026-09-13 22:42:14', '2026-09-13 22:42:14'),
(11, 11, 38, '2026-09-13 22:48:16', '2026-09-13 22:48:16', '2026-09-13 22:48:16'),
(12, 12, 71, '2026-09-13 23:04:47', '2026-09-13 22:48:28', '2026-09-13 23:04:47'),
(13, 13, 1, '2026-09-20 18:09:46', '2026-09-13 22:48:43', '2026-09-20 18:09:46'),
(14, 14, 3, '2026-09-14 00:39:23', '2026-09-14 00:13:33', '2026-09-14 00:39:23'),
(15, 15, 3, '2026-09-21 23:48:17', '2026-09-15 19:18:48', '2026-09-21 23:48:17'),
(16, 16, 3, '2026-09-21 23:30:10', '2026-09-20 17:09:18', '2026-09-21 23:30:10'),
(17, 17, 40, '2026-09-20 19:32:50', '2026-09-20 19:10:13', '2026-09-20 19:32:50'),
(18, 18, 38, '2026-09-21 23:25:43', '2026-09-21 17:15:15', '2026-09-21 23:25:43'),
(19, 19, 1, '2026-09-22 18:12:24', '2026-09-22 18:12:24', '2026-09-22 18:12:24'),
(20, 20, 1, '2026-09-22 18:42:49', '2026-09-22 18:42:49', '2026-09-22 18:42:49'),
(21, 21, 38, '2026-09-23 17:25:08', '2026-09-23 17:25:08', '2026-09-23 17:25:08'),
(22, 22, 1, '2026-09-24 18:58:43', '2026-09-24 18:50:22', '2026-09-24 18:58:43'),
(23, 23, 38, '2026-09-24 19:18:37', '2026-09-24 19:18:37', '2026-09-24 19:18:37'),
(24, 24, 39, '2026-09-25 22:25:55', '2026-09-24 19:22:47', '2026-09-25 22:25:55'),
(26, 26, 209, '2026-09-26 00:40:39', '2026-09-25 23:18:46', '2026-09-26 00:40:39'),
(27, 27, 202, '2026-09-27 22:12:19', '2026-09-26 00:46:46', '2026-09-27 22:12:19'),
(28, 28, 74, '2026-09-26 01:05:21', '2026-09-26 01:01:06', '2026-09-26 01:05:21'),
(29, 29, 238, '2026-09-28 17:00:07', '2026-09-27 22:17:39', '2026-09-28 17:00:07'),
(30, 30, 73, '2026-09-28 18:46:28', '2026-09-28 18:45:58', '2026-09-28 18:46:28'),
(31, 31, 73, '2026-09-28 21:20:46', '2026-09-28 18:51:58', '2026-09-28 21:20:46'),
(32, 32, 73, '2026-09-29 23:55:22', '2026-09-28 21:33:30', '2026-09-29 23:55:22'),
(33, 33, 259, '2026-09-29 23:25:53', '2026-09-29 23:25:53', '2026-09-29 23:25:53'),
(34, 34, 268, '2026-09-29 23:28:31', '2026-09-29 23:28:31', '2026-09-29 23:28:31'),
(35, 35, 74, '2026-09-30 01:30:00', '2026-09-30 00:12:36', '2026-09-30 01:30:00'),
(36, 36, 328, '2026-09-30 00:54:47', '2026-09-30 00:54:47', '2026-09-30 00:54:47'),
(37, 37, 390, '2026-09-30 01:21:11', '2026-09-30 00:58:33', '2026-09-30 01:21:11'),
(38, 38, 399, '2026-09-30 01:44:32', '2026-09-30 01:31:10', '2026-09-30 01:44:32'),
(39, 39, 394, '2026-09-30 01:49:31', '2026-09-30 01:44:55', '2026-09-30 01:49:31'),
(40, 40, 394, '2026-10-04 17:31:35', '2026-09-30 16:09:17', '2026-10-04 17:31:35'),
(41, 41, 416, '2026-10-04 17:34:21', '2026-10-04 17:34:21', '2026-10-04 17:34:21');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_station_touches`
--
CREATE TABLE `transaction_station_touches` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `touched_by` bigint UNSIGNED NOT NULL,
  `touched_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_step_data`
--
CREATE TABLE `transaction_step_data` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_data_id` bigint UNSIGNED NOT NULL,
  `transaction_step_run_id` bigint UNSIGNED DEFAULT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `data_value` text COLLATE utf8mb4_unicode_ci,
  `entered_by` bigint UNSIGNED DEFAULT NULL,
  `entered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_step_runs`
--
CREATE TABLE `transaction_step_runs` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `from_step_id` bigint UNSIGNED NOT NULL,
  `to_step_id` bigint UNSIGNED DEFAULT NULL,
  `action_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `performed_by` bigint UNSIGNED NOT NULL,
  `performed_at` timestamp NULL DEFAULT NULL,
  `received_at` timestamp NULL DEFAULT NULL,
  `received_by` bigint UNSIGNED DEFAULT NULL,
  `received_office_id` bigint UNSIGNED DEFAULT NULL,
  `sla_minutes_snapshot` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_step_runs`
--

INSERT INTO `transaction_step_runs` (`id`, `transaction_id`, `from_step_id`, `to_step_id`, `action_code`, `remarks`, `performed_by`, `performed_at`, `received_at`, `received_by`, `received_office_id`, `sla_minutes_snapshot`, `created_at`, `updated_at`) VALUES
(1, 1, 18, 18, 'create', 'Transaction created', 1, '2026-03-09 23:51:48', '2026-03-09 23:51:48', NULL, NULL, 60, '2026-03-09 23:51:48', '2026-03-09 23:51:48'),
(2, 1, 18, 19, 'submit', NULL, 1, '2026-03-09 23:53:29', '2026-03-09 23:53:29', NULL, NULL, 60, '2026-03-09 23:53:29', '2026-03-09 23:53:29'),
(3, 2, 18, 18, 'create', 'Transaction created', 1, '2026-03-09 23:57:06', '2026-03-09 23:57:06', NULL, NULL, 60, '2026-03-09 23:57:06', '2026-03-09 23:57:06'),
(4, 2, 18, 19, 'submit', NULL, 1, '2026-03-09 23:57:11', '2026-03-09 23:57:11', NULL, NULL, 60, '2026-03-09 23:57:11', '2026-03-09 23:57:11'),
(5, 3, 20, 20, 'create', 'Transaction created', 1, '2026-03-09 23:57:31', '2026-03-09 23:57:31', NULL, NULL, 60, '2026-03-09 23:57:31', '2026-03-09 23:57:31'),
(6, 3, 20, 21, 'submit', NULL, 1, '2026-03-09 23:57:36', '2026-03-09 23:57:36', NULL, NULL, 60, '2026-03-09 23:57:36', '2026-03-09 23:57:36'),
(7, 3, 21, 20, 'submit', NULL, 1, '2026-03-09 23:57:39', '2026-03-09 23:57:39', NULL, NULL, 60, '2026-03-09 23:57:40', '2026-03-09 23:57:40'),
(8, 3, 20, 21, 'submit', NULL, 1, '2026-03-09 23:58:41', '2026-03-09 23:58:41', NULL, NULL, 60, '2026-03-09 23:58:41', '2026-03-09 23:58:41'),
(9, 3, 21, 20, 'submit', NULL, 1, '2026-03-10 00:00:39', '2026-03-10 00:00:39', NULL, NULL, 60, '2026-03-10 00:00:39', '2026-03-10 00:00:39'),
(10, 4, 20, 20, 'create', 'Transaction created', 1, '2026-03-10 00:32:03', '2026-03-10 00:32:03', NULL, NULL, 60, '2026-03-10 00:32:03', '2026-03-10 00:32:03'),
(11, 4, 20, 21, 'submit', 'MEMO', 1, '2026-03-10 00:32:33', '2026-03-10 00:32:33', NULL, NULL, 60, '2026-03-10 00:32:33', '2026-03-10 00:32:33'),
(12, 5, 20, 20, 'create', 'Transaction created', 1, '2026-09-11 16:50:34', '2026-09-11 16:50:34', NULL, NULL, 60, '2026-09-11 16:50:34', '2026-09-11 16:50:34'),
(16, 9, 38, 38, 'create', 'Transaction created', 1, '2026-09-11 22:24:51', '2026-09-11 22:24:51', NULL, NULL, 2880, '2026-09-11 22:24:51', '2026-09-11 22:24:51'),
(17, 9, 38, 39, 'submit', 'wako', 1, '2026-09-13 19:36:55', '2026-09-13 19:36:55', NULL, NULL, 2880, '2026-09-13 19:36:55', '2026-09-13 19:36:55'),
(18, 9, 39, 40, 'submit', NULL, 1, '2026-09-13 20:46:56', '2026-09-13 20:46:56', NULL, NULL, 2880, '2026-09-13 20:46:56', '2026-09-13 20:46:56'),
(19, 10, 20, 20, 'create', 'Transaction created', 1, '2026-09-13 22:42:14', '2026-09-13 22:42:14', NULL, NULL, 60, '2026-09-13 22:42:14', '2026-09-13 22:42:14'),
(20, 11, 38, 38, 'create', 'Transaction created', 1, '2026-09-13 22:48:16', '2026-09-13 22:48:16', NULL, NULL, 2880, '2026-09-13 22:48:16', '2026-09-13 22:48:16'),
(21, 12, 70, 70, 'create', 'Transaction created', 1, '2026-09-13 22:48:28', '2026-09-13 22:48:28', NULL, NULL, 60, '2026-09-13 22:48:28', '2026-09-13 22:48:28'),
(22, 13, 1, 1, 'create', 'Transaction created', 1, '2026-09-13 22:48:43', '2026-09-13 22:48:43', NULL, NULL, 2880, '2026-09-13 22:48:43', '2026-09-13 22:48:43'),
(23, 12, 70, 71, 'submit', NULL, 1, '2026-09-13 23:04:47', '2026-09-13 23:04:47', NULL, NULL, 60, '2026-09-13 23:04:47', '2026-09-13 23:04:47'),
(24, 14, 1, 1, 'create', 'Transaction created', 1, '2026-09-14 00:13:33', '2026-09-14 00:13:33', NULL, NULL, 2880, '2026-09-14 00:13:33', '2026-09-14 00:13:33'),
(25, 14, 1, 2, 'submit', NULL, 1, '2026-09-14 00:22:19', '2026-09-14 00:22:19', NULL, NULL, 2880, '2026-09-14 00:22:19', '2026-09-14 00:22:19'),
(26, 14, 2, 3, 'approve', NULL, 1, '2026-09-14 00:39:23', '2026-09-14 00:39:23', NULL, NULL, 4320, '2026-09-14 00:39:23', '2026-09-14 00:39:23'),
(27, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:18:09', '2026-09-15 19:18:09', NULL, NULL, 2880, '2026-09-15 19:18:09', '2026-09-15 19:18:09'),
(28, 15, 1, 1, 'create', 'Transaction created', 1, '2026-09-15 19:18:48', '2026-09-15 19:18:48', NULL, NULL, 2880, '2026-09-15 19:18:48', '2026-09-15 19:18:48'),
(29, 15, 1, 2, 'submit', 'DTR', 1, '2026-09-15 19:19:31', '2026-09-15 19:19:31', NULL, NULL, 2880, '2026-09-15 19:19:31', '2026-09-15 19:19:31'),
(30, 15, 2, 1, 'return', NULL, 1, '2026-09-15 19:20:06', '2026-09-15 19:20:06', NULL, NULL, 2880, '2026-09-15 19:20:06', '2026-09-15 19:20:06'),
(31, 15, 1, 2, 'submit', NULL, 1, '2026-09-15 19:25:05', '2026-09-15 19:25:05', NULL, NULL, 2880, '2026-09-15 19:25:05', '2026-09-15 19:25:05'),
(32, 13, 2, 1, 'return', 'ge', 1, '2026-09-15 19:49:36', '2026-09-15 19:49:36', NULL, NULL, 2880, '2026-09-15 19:49:36', '2026-09-15 19:49:36'),
(33, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:52:53', '2026-09-15 19:52:53', NULL, NULL, 2880, '2026-09-15 19:52:53', '2026-09-15 19:52:53'),
(34, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:53:25', '2026-09-15 19:53:25', NULL, NULL, 2880, '2026-09-15 19:53:25', '2026-09-15 19:53:25'),
(35, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:55:48', '2026-09-15 19:55:48', NULL, NULL, 2880, '2026-09-15 19:55:48', '2026-09-15 19:55:48'),
(36, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:55:59', '2026-09-15 19:55:59', NULL, NULL, 2880, '2026-09-15 19:55:59', '2026-09-15 19:55:59'),
(38, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:59:35', '2026-09-15 19:59:35', NULL, NULL, 2880, '2026-09-15 19:59:35', '2026-09-15 19:59:35'),
(39, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:59:46', '2026-09-15 19:59:46', NULL, NULL, 2880, '2026-09-15 19:59:46', '2026-09-15 19:59:46'),
(41, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 20:03:35', '2026-09-15 20:03:35', NULL, NULL, 2880, '2026-09-15 20:03:35', '2026-09-15 20:03:35'),
(42, 13, 2, 1, 'return', NULL, 1, '2026-09-15 20:03:45', '2026-09-15 20:03:45', NULL, NULL, 2880, '2026-09-15 20:03:45', '2026-09-15 20:03:45'),
(43, 9, 40, 41, 'submit', NULL, 1, '2026-09-20 17:05:15', '2026-09-20 17:05:15', NULL, NULL, 2880, '2026-09-20 17:05:15', '2026-09-20 17:05:15'),
(44, 16, 1, 1, 'create', 'Transaction created', 1, '2026-09-20 17:09:18', '2026-09-20 17:09:18', NULL, NULL, 2880, '2026-09-20 17:09:18', '2026-09-20 17:09:18'),
(45, 13, 1, 2, 'submit', NULL, 1, '2026-09-20 17:52:22', '2026-09-20 17:52:22', NULL, NULL, 2880, '2026-09-20 17:52:22', '2026-09-20 17:52:22'),
(46, 13, 2, 1, 'return', NULL, 1, '2026-09-20 18:09:46', '2026-09-20 18:09:46', NULL, NULL, 2880, '2026-09-20 18:09:46', '2026-09-20 18:09:46'),
(47, 17, 38, 38, 'create', 'Transaction created', 1, '2026-09-20 19:10:13', '2026-09-20 19:10:13', NULL, NULL, 2880, '2026-09-20 19:10:13', '2026-09-20 19:10:13'),
(48, 17, 38, 39, 'submit', 'awdawdawdawdawdawdwadaw', 1, '2026-09-20 19:30:52', '2026-09-20 19:30:52', NULL, NULL, 2880, '2026-09-20 19:30:52', '2026-09-20 19:30:52'),
(49, 17, 39, 40, 'submit', NULL, 1, '2026-09-20 19:32:50', '2026-09-20 19:32:50', NULL, NULL, 2880, '2026-09-20 19:32:50', '2026-09-20 19:32:50'),
(50, 9, 41, 42, 'submit', NULL, 1, '2026-09-21 16:54:14', '2026-09-21 16:54:14', NULL, NULL, 2880, '2026-09-21 16:54:14', '2026-09-21 16:54:14'),
(51, 18, 38, 38, 'create', 'Transaction created', 1, '2026-09-21 17:15:15', '2026-09-21 17:15:15', NULL, NULL, 2880, '2026-09-21 17:15:15', '2026-09-21 17:15:15'),
(52, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 17:18:56', '2026-09-21 17:18:56', NULL, NULL, 2880, '2026-09-21 17:18:56', '2026-09-21 17:18:56'),
(53, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 17:21:46', '2026-09-21 17:21:46', NULL, NULL, 2880, '2026-09-21 17:21:46', '2026-09-21 17:21:46'),
(54, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 17:22:45', '2026-09-21 17:22:45', NULL, NULL, 2880, '2026-09-21 17:22:45', '2026-09-21 17:22:45'),
(55, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 17:26:00', '2026-09-21 17:26:00', NULL, NULL, 2880, '2026-09-21 17:26:00', '2026-09-21 17:26:00'),
(56, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 17:26:43', '2026-09-21 17:26:43', NULL, NULL, 2880, '2026-09-21 17:26:43', '2026-09-21 17:26:43'),
(57, 18, 43, 40, 'rewind', 'Rewound to past station', 1, '2026-09-21 18:48:26', '2026-09-21 18:48:26', NULL, NULL, 2880, '2026-09-21 18:48:26', '2026-09-21 18:48:26'),
(58, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 18:48:26', '2026-09-21 18:48:26', NULL, NULL, 2880, '2026-09-21 18:48:26', '2026-09-21 18:48:26'),
(59, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 18:55:28', '2026-09-21 18:55:28', NULL, NULL, 2880, '2026-09-21 18:55:28', '2026-09-21 18:55:28'),
(60, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 18:56:03', '2026-09-21 18:56:03', NULL, NULL, 2880, '2026-09-21 18:56:03', '2026-09-21 18:56:03'),
(61, 18, 43, 40, 'rewind', 'Rewound to past station', 1, '2026-09-21 18:57:26', '2026-09-21 18:57:26', NULL, NULL, 2880, '2026-09-21 18:57:26', '2026-09-21 18:57:26'),
(62, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 18:57:27', '2026-09-21 18:57:27', NULL, NULL, 2880, '2026-09-21 18:57:27', '2026-09-21 18:57:27'),
(63, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 18:57:39', '2026-09-21 18:57:39', NULL, NULL, 2880, '2026-09-21 18:57:39', '2026-09-21 18:57:39'),
(64, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 18:57:52', '2026-09-21 18:57:52', NULL, NULL, 2880, '2026-09-21 18:57:52', '2026-09-21 18:57:52'),
(65, 18, 43, 38, 'return', 'hay nako', 1, '2026-09-21 19:04:31', '2026-09-21 19:04:31', NULL, NULL, 2880, '2026-09-21 19:04:31', '2026-09-21 19:04:31'),
(66, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 19:04:51', '2026-09-21 19:04:51', NULL, NULL, 2880, '2026-09-21 19:04:51', '2026-09-21 19:04:51'),
(67, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 19:04:57', '2026-09-21 19:04:57', NULL, NULL, 2880, '2026-09-21 19:04:57', '2026-09-21 19:04:57'),
(68, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 19:05:06', '2026-09-21 19:05:06', NULL, NULL, 2880, '2026-09-21 19:05:06', '2026-09-21 19:05:06'),
(69, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 19:05:14', '2026-09-21 19:05:14', NULL, NULL, 2880, '2026-09-21 19:05:14', '2026-09-21 19:05:14'),
(70, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 19:10:05', '2026-09-21 19:10:05', NULL, NULL, 2880, '2026-09-21 19:10:05', '2026-09-21 19:10:05'),
(71, 18, 43, 38, 'return', 'awdawd', 1, '2026-09-21 21:49:06', '2026-09-21 21:49:06', NULL, NULL, 2880, '2026-09-21 21:49:06', '2026-09-21 21:49:06'),
(72, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 21:49:22', '2026-09-21 21:49:22', NULL, NULL, 2880, '2026-09-21 21:49:22', '2026-09-21 21:49:22'),
(73, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 21:49:29', '2026-09-21 21:49:29', NULL, NULL, 2880, '2026-09-21 21:49:29', '2026-09-21 21:49:29'),
(74, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 21:49:38', '2026-09-21 21:49:38', NULL, NULL, 2880, '2026-09-21 21:49:38', '2026-09-21 21:49:38'),
(75, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 21:49:47', '2026-09-21 21:49:47', NULL, NULL, 2880, '2026-09-21 21:49:47', '2026-09-21 21:49:47'),
(76, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 21:49:55', '2026-09-21 21:49:55', NULL, NULL, 2880, '2026-09-21 21:49:55', '2026-09-21 21:49:55'),
(77, 18, 43, 38, 'return', 'awda', 1, '2026-09-21 21:52:22', '2026-09-21 21:52:22', NULL, NULL, 2880, '2026-09-21 21:52:22', '2026-09-21 21:52:22'),
(78, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 21:52:53', '2026-09-21 21:52:53', NULL, NULL, 2880, '2026-09-21 21:52:53', '2026-09-21 21:52:53'),
(79, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 21:57:34', '2026-09-21 21:57:34', NULL, NULL, 2880, '2026-09-21 21:57:34', '2026-09-21 21:57:34'),
(80, 18, 40, 43, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:54:35', '2026-09-21 22:54:35', NULL, NULL, 2880, '2026-09-21 22:54:35', '2026-09-21 22:54:35'),
(81, 18, 43, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:55:46', '2026-09-21 22:55:46', NULL, NULL, 2880, '2026-09-21 22:55:46', '2026-09-21 22:55:46'),
(82, 18, 40, 41, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:55:52', '2026-09-21 22:55:52', NULL, NULL, 2880, '2026-09-21 22:55:52', '2026-09-21 22:55:52'),
(83, 18, 41, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:56:03', '2026-09-21 22:56:03', NULL, NULL, 2880, '2026-09-21 22:56:03', '2026-09-21 22:56:03'),
(84, 18, 40, 41, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:56:51', '2026-09-21 22:56:51', NULL, NULL, 2880, '2026-09-21 22:56:51', '2026-09-21 22:56:51'),
(85, 18, 41, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 23:01:30', '2026-09-21 23:01:30', NULL, NULL, 2880, '2026-09-21 23:01:30', '2026-09-21 23:01:30'),
(86, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 23:15:31', '2026-09-21 23:15:31', NULL, NULL, 2880, '2026-09-21 23:15:31', '2026-09-21 23:15:31'),
(87, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 23:15:39', '2026-09-21 23:15:39', NULL, NULL, 2880, '2026-09-21 23:15:39', '2026-09-21 23:15:39'),
(88, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 23:15:49', '2026-09-21 23:15:49', NULL, NULL, 2880, '2026-09-21 23:15:49', '2026-09-21 23:15:49'),
(89, 18, 43, 40, 'revisit', 'please fix', 1, '2026-09-21 23:16:08', '2026-09-21 23:16:08', NULL, NULL, 2880, '2026-09-21 23:16:08', '2026-09-21 23:16:08'),
(90, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 23:16:16', '2026-09-21 23:16:16', NULL, NULL, 2880, '2026-09-21 23:16:16', '2026-09-21 23:16:16'),
(91, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 23:16:30', '2026-09-21 23:16:30', NULL, NULL, 2880, '2026-09-21 23:16:30', '2026-09-21 23:16:30'),
(92, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 23:16:42', '2026-09-21 23:16:42', NULL, NULL, 2880, '2026-09-21 23:16:42', '2026-09-21 23:16:42'),
(93, 18, 43, 40, 'revisit', 'please fix', 1, '2026-09-21 23:17:13', '2026-09-21 23:17:13', NULL, NULL, 2880, '2026-09-21 23:17:13', '2026-09-21 23:17:13'),
(94, 18, 40, 38, 'revisit', 'yamiti kudasai', 1, '2026-09-21 23:25:43', '2026-09-21 23:25:43', NULL, NULL, 2880, '2026-09-21 23:25:43', '2026-09-21 23:25:43'),
(95, 16, 1, 2, 'submit', NULL, 1, '2026-09-21 23:29:57', '2026-09-21 23:29:57', NULL, NULL, 2880, '2026-09-21 23:29:57', '2026-09-21 23:29:57'),
(96, 16, 2, 3, 'approve', NULL, 1, '2026-09-21 23:30:10', '2026-09-21 23:30:10', NULL, NULL, 4320, '2026-09-21 23:30:10', '2026-09-21 23:30:10'),
(97, 16, 3, 3, 'finalize', 'Process finalized', 1, '2026-09-21 23:47:33', '2026-09-21 23:47:33', NULL, NULL, 4320, '2026-09-21 23:47:33', '2026-09-21 23:47:33'),
(98, 15, 2, 3, 'approve', NULL, 1, '2026-09-21 23:48:17', '2026-09-21 23:48:17', NULL, NULL, 4320, '2026-09-21 23:48:17', '2026-09-21 23:48:17'),
(99, 15, 3, 3, 'finalize', 'Process finalized', 1, '2026-09-21 23:48:27', '2026-09-21 23:48:27', NULL, NULL, 4320, '2026-09-21 23:48:27', '2026-09-21 23:48:27'),
(100, 19, 1, 1, 'create', 'Transaction created', 1, '2026-09-22 18:12:24', '2026-09-22 18:12:24', NULL, NULL, 2880, '2026-09-22 18:12:24', '2026-09-22 18:12:24'),
(101, 20, 1, 1, 'create', 'Transaction created', 1, '2026-09-22 18:42:49', '2026-09-22 18:42:49', NULL, NULL, 2880, '2026-09-22 18:42:49', '2026-09-22 18:42:49'),
(102, 21, 38, 38, 'create', 'Transaction created', 1, '2026-09-23 17:25:08', '2026-09-23 17:25:08', NULL, NULL, 2880, '2026-09-23 17:25:08', '2026-09-23 17:25:08'),
(103, 22, 1, 1, 'create', 'Transaction created', 1, '2026-09-24 18:50:22', '2026-09-24 18:50:22', NULL, NULL, 2880, '2026-09-24 18:50:22', '2026-09-24 18:50:22'),
(104, 22, 1, 2, 'submit', NULL, 1, '2026-09-24 18:54:17', '2026-09-24 18:54:17', NULL, NULL, 2880, '2026-09-24 18:54:17', '2026-09-24 18:54:17'),
(105, 22, 2, 3, 'approve', NULL, 1, '2026-09-24 18:58:02', '2026-09-24 18:58:02', NULL, NULL, 4320, '2026-09-24 18:58:02', '2026-09-24 18:58:02'),
(106, 22, 3, 1, 'revisit', 'something wong', 1, '2026-09-24 18:58:43', '2026-09-24 18:58:43', NULL, NULL, 2880, '2026-09-24 18:58:43', '2026-09-24 18:58:43'),
(107, 23, 38, 38, 'create', 'Transaction created', 1, '2026-09-24 19:18:37', '2026-09-24 19:18:37', NULL, NULL, 2880, '2026-09-24 19:18:37', '2026-09-24 19:18:37'),
(108, 24, 38, 38, 'create', 'Transaction created', 1, '2026-09-24 19:22:47', '2026-09-24 19:22:47', NULL, NULL, 2880, '2026-09-24 19:22:47', '2026-09-24 19:22:47'),
(110, 24, 38, 39, 'submit', NULL, 1, '2026-09-25 22:25:55', '2026-09-25 22:26:20', 1, NULL, 2880, '2026-09-25 22:25:55', '2026-09-25 22:26:20'),
(111, 26, 202, 202, 'create', 'Transaction created', 1, '2026-09-25 23:18:46', '2026-09-25 23:18:46', 1, 24, 100, '2026-09-25 23:18:46', '2026-09-25 23:18:46'),
(112, 26, 202, 203, 'submit', NULL, 1, '2026-09-25 23:19:27', '2026-09-25 23:19:33', 1, 10, 20, '2026-09-25 23:19:27', '2026-09-25 23:19:33'),
(113, 26, 203, 204, 'submit', NULL, 1, '2026-09-25 23:19:47', '2026-09-25 23:19:56', 1, 24, 10, '2026-09-25 23:19:47', '2026-09-25 23:19:56'),
(114, 26, 204, 205, 'submit', NULL, 1, '2026-09-25 23:37:13', '2026-09-25 23:37:16', 1, 9, 9, '2026-09-25 23:37:13', '2026-09-25 23:37:16'),
(115, 26, 205, 206, 'submit', NULL, 1, '2026-09-25 23:37:22', '2026-09-25 23:37:24', 1, 24, 10, '2026-09-25 23:37:22', '2026-09-25 23:37:24'),
(116, 26, 206, 207, 'submit', NULL, 1, '2026-09-26 00:06:07', '2026-09-26 00:13:04', 1, 24, 20, '2026-09-26 00:06:07', '2026-09-26 00:13:04'),
(117, 26, 207, 208, 'submit', NULL, 1, '2026-09-26 00:40:17', '2026-09-26 00:40:26', 1, 24, 90, '2026-09-26 00:40:17', '2026-09-26 00:40:26'),
(118, 26, 208, 209, 'submit', NULL, 1, '2026-09-26 00:40:39', NULL, NULL, 24, 80, '2026-09-26 00:40:39', '2026-09-26 00:40:39'),
(119, 26, 209, 209, 'finalize', 'Process finalized', 1, '2026-09-26 00:41:24', NULL, NULL, NULL, 0, '2026-09-26 00:41:24', '2026-09-26 00:41:24'),
(120, 27, 202, 202, 'create', 'Transaction created', 1, '2026-09-26 00:46:46', '2026-09-26 00:46:46', 1, 24, 100, '2026-09-26 00:46:46', '2026-09-26 00:46:46'),
(121, 28, 72, 72, 'create', 'Transaction created', 1, '2026-09-26 01:01:06', '2026-09-26 01:01:06', 1, NULL, 2880, '2026-09-26 01:01:06', '2026-09-26 01:01:06'),
(122, 28, 72, 73, 'submit', NULL, 1, '2026-09-26 01:02:03', '2026-09-26 01:05:01', 1, 4, 2880, '2026-09-26 01:02:03', '2026-09-26 01:05:01'),
(123, 28, 73, 74, 'approve', NULL, 1, '2026-09-26 01:05:21', '2026-09-26 01:05:25', 1, NULL, 4320, '2026-09-26 01:05:21', '2026-09-26 01:05:25'),
(124, 28, 74, 74, 'finalize', 'Process finalized', 1, '2026-09-26 01:05:30', '2026-09-26 01:05:30', 1, NULL, 4320, '2026-09-26 01:05:30', '2026-09-26 01:05:30'),
(125, 27, 202, 203, 'submit', 'hallo', 1, '2026-09-27 21:22:41', '2026-09-27 21:23:19', 1, 10, 20, '2026-09-27 21:22:41', '2026-09-27 21:23:19'),
(126, 27, 203, 204, 'submit', NULL, 1, '2026-09-27 22:09:55', '2026-09-27 22:11:52', 1, 24, 10, '2026-09-27 22:09:55', '2026-09-27 22:11:52'),
(127, 27, 204, 202, 'revisit', 'Kulang bAI', 1, '2026-09-27 22:12:19', '2026-09-27 22:12:24', 1, 24, 100, '2026-09-27 22:12:19', '2026-09-27 22:12:24'),
(128, 29, 234, 234, 'create', 'Transaction created', 1, '2026-09-27 22:17:39', '2026-09-27 22:17:39', 1, 10, 100, '2026-09-27 22:17:39', '2026-09-27 22:17:39'),
(129, 29, 234, 235, 'submit', NULL, 1, '2026-09-27 22:18:06', '2026-09-27 22:18:14', 1, 24, 20, '2026-09-27 22:18:06', '2026-09-27 22:18:14'),
(130, 29, 235, 236, 'submit', NULL, 1, '2026-09-27 22:18:37', '2026-09-27 22:18:40', 1, 9, 10, '2026-09-27 22:18:37', '2026-09-27 22:18:40'),
(131, 29, 236, 237, 'submit', NULL, 1, '2026-09-27 23:10:32', '2026-09-27 23:21:05', 1, 24, 9, '2026-09-27 23:10:32', '2026-09-27 23:21:05'),
(132, 29, 237, 238, 'submit', NULL, 1, '2026-09-28 16:40:36', '2026-09-28 16:58:48', 1, 24, 10, '2026-09-28 16:40:36', '2026-09-28 16:58:48'),
(133, 29, 238, 234, 'revisit', 'kulang man', 1, '2026-09-28 16:59:14', '2026-09-28 16:59:19', 1, 10, 100, '2026-09-28 16:59:14', '2026-09-28 16:59:19'),
(134, 29, 234, 235, 'submit', NULL, 1, '2026-09-28 16:59:41', '2026-09-28 16:59:43', 1, 24, 20, '2026-09-28 16:59:41', '2026-09-28 16:59:43'),
(135, 29, 235, 236, 'submit', NULL, 1, '2026-09-28 16:59:48', '2026-09-28 16:59:50', 1, 9, 10, '2026-09-28 16:59:48', '2026-09-28 16:59:50'),
(136, 29, 236, 237, 'submit', NULL, 1, '2026-09-28 16:59:57', '2026-09-28 16:59:59', 1, 24, 9, '2026-09-28 16:59:57', '2026-09-28 16:59:59'),
(137, 29, 237, 238, 'submit', NULL, 1, '2026-09-28 17:00:07', '2026-09-28 17:00:08', 1, 24, 10, '2026-09-28 17:00:07', '2026-09-28 17:00:08'),
(138, 30, 72, 72, 'create', 'Transaction created', 1, '2026-09-28 18:45:58', '2026-09-28 18:45:58', 1, NULL, 2880, '2026-09-28 18:45:58', '2026-09-28 18:45:58'),
(139, 30, 72, 73, 'submit', NULL, 1, '2026-09-28 18:46:28', '2026-09-28 18:46:29', 1, 4, 2880, '2026-09-28 18:46:28', '2026-09-28 18:46:29'),
(140, 31, 72, 72, 'create', 'Transaction created', 1, '2026-09-28 18:51:58', '2026-09-28 18:51:58', 1, NULL, 2880, '2026-09-28 18:51:58', '2026-09-28 18:51:58'),
(141, 31, 72, 73, 'submit', NULL, 1, '2026-09-28 18:52:22', '2026-09-28 18:52:26', 1, 4, 2880, '2026-09-28 18:52:22', '2026-09-28 18:52:26'),
(142, 31, 73, 72, 'revisit', 'kulang', 1, '2026-09-28 18:53:04', '2026-09-28 18:53:08', 1, NULL, 2880, '2026-09-28 18:53:04', '2026-09-28 18:53:08'),
(143, 31, 72, 73, 'submit', NULL, 1, '2026-09-28 18:53:16', '2026-09-28 18:53:20', 1, 4, 2880, '2026-09-28 18:53:16', '2026-09-28 18:53:20'),
(144, 31, 73, 72, 'return', NULL, 1, '2026-09-28 18:53:50', '2026-09-28 18:54:01', 1, NULL, 2880, '2026-09-28 18:53:50', '2026-09-28 18:54:01'),
(145, 31, 72, 73, 'submit', NULL, 1, '2026-09-28 19:07:34', '2026-09-28 19:07:36', 1, 4, 2880, '2026-09-28 19:07:34', '2026-09-28 19:07:36'),
(146, 31, 73, 72, 'return', NULL, 1, '2026-09-28 19:40:41', '2026-09-28 19:40:44', 1, NULL, 2880, '2026-09-28 19:40:41', '2026-09-28 19:40:44'),
(147, 31, 72, 73, 'submit', NULL, 1, '2026-09-28 21:20:46', '2026-09-28 21:21:08', 1, 4, 2880, '2026-09-28 21:20:46', '2026-09-28 21:21:08'),
(148, 32, 72, 72, 'create', 'Transaction created', 1, '2026-09-28 21:33:30', '2026-09-28 21:33:30', 1, NULL, 2880, '2026-09-28 21:33:30', '2026-09-28 21:33:30'),
(149, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 00:54:52', '2026-09-29 00:54:54', 1, 4, 2880, '2026-09-29 00:54:52', '2026-09-29 00:54:54'),
(150, 32, 73, 72, 'return', NULL, 1, '2026-09-29 16:16:35', '2026-09-29 16:16:37', 1, NULL, 2880, '2026-09-29 16:16:35', '2026-09-29 16:16:37'),
(151, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 16:25:39', '2026-09-29 16:25:58', 1, 4, 2880, '2026-09-29 16:25:39', '2026-09-29 16:25:58'),
(152, 32, 73, 72, 'return', NULL, 1, '2026-09-29 16:30:32', '2026-09-29 16:30:34', 1, NULL, 2880, '2026-09-29 16:30:32', '2026-09-29 16:30:34'),
(153, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 21:33:25', '2026-09-29 21:33:28', 1, 4, 2880, '2026-09-29 21:33:25', '2026-09-29 21:33:28'),
(154, 32, 73, 72, 'return', NULL, 1, '2026-09-29 21:34:50', '2026-09-29 21:34:52', 1, NULL, 2880, '2026-09-29 21:34:50', '2026-09-29 21:34:52'),
(155, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 21:51:40', '2026-09-29 21:51:43', 1, 4, 2880, '2026-09-29 21:51:40', '2026-09-29 21:51:43'),
(156, 32, 73, 72, 'revisit', 'leme see something', 1, '2026-09-29 22:07:45', '2026-09-29 22:07:47', 1, NULL, 2880, '2026-09-29 22:07:45', '2026-09-29 22:07:47'),
(157, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 22:08:07', '2026-09-29 22:08:09', 1, 4, 2880, '2026-09-29 22:08:07', '2026-09-29 22:08:09'),
(158, 32, 73, 72, 'return', NULL, 1, '2026-09-29 22:17:06', '2026-09-29 22:17:08', 1, NULL, 2880, '2026-09-29 22:17:06', '2026-09-29 22:17:08'),
(159, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 22:17:13', '2026-09-29 22:17:15', 1, 4, 2880, '2026-09-29 22:17:13', '2026-09-29 22:17:15'),
(160, 32, 73, 72, 'return', NULL, 1, '2026-09-29 23:03:40', '2026-09-29 23:03:51', 1, NULL, 2880, '2026-09-29 23:03:40', '2026-09-29 23:03:51'),
(161, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 23:06:11', '2026-09-29 23:06:13', 1, 4, 2880, '2026-09-29 23:06:11', '2026-09-29 23:06:13'),
(162, 32, 73, 72, 'return', NULL, 1, '2026-09-29 23:15:11', '2026-09-29 23:15:14', 1, NULL, 2880, '2026-09-29 23:15:11', '2026-09-29 23:15:14'),
(163, 33, 259, 259, 'create', 'Transaction created', 1, '2026-09-29 23:25:53', '2026-09-29 23:25:53', 1, 10, 100, '2026-09-29 23:25:53', '2026-09-29 23:25:53'),
(164, 34, 268, 268, 'create', 'Transaction created', 1, '2026-09-29 23:28:31', '2026-09-29 23:28:31', 1, 10, 100, '2026-09-29 23:28:31', '2026-09-29 23:28:31'),
(165, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 23:41:58', '2026-09-29 23:42:01', 1, 4, 2880, '2026-09-29 23:41:58', '2026-09-29 23:42:01'),
(166, 32, 73, 72, 'return', NULL, 1, '2026-09-29 23:46:23', '2026-09-29 23:46:25', 1, NULL, 2880, '2026-09-29 23:46:23', '2026-09-29 23:46:25'),
(167, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 23:46:42', '2026-09-29 23:46:55', 1, 4, 2880, '2026-09-29 23:46:42', '2026-09-29 23:46:55'),
(168, 32, 73, 72, 'revisit', 'Kulang boss', 1, '2026-09-29 23:47:36', '2026-09-29 23:47:38', 1, NULL, 2880, '2026-09-29 23:47:36', '2026-09-29 23:47:38'),
(169, 32, 72, 73, 'submit', NULL, 1, '2026-09-29 23:55:22', '2026-09-29 23:55:24', 1, 4, 2880, '2026-09-29 23:55:22', '2026-09-29 23:55:24'),
(170, 35, 72, 72, 'create', 'Transaction created', 1, '2026-09-30 00:12:36', '2026-09-30 00:12:36', 1, NULL, 2880, '2026-09-30 00:12:36', '2026-09-30 00:12:36'),
(171, 35, 72, 73, 'submit', NULL, 1, '2026-09-30 00:13:57', '2026-09-30 00:13:59', 1, 4, 2880, '2026-09-30 00:13:57', '2026-09-30 00:13:59'),
(172, 35, 73, 72, 'revisit', 'Kulang man ni uy', 1, '2026-09-30 00:19:36', '2026-09-30 00:19:39', 1, NULL, 2880, '2026-09-30 00:19:36', '2026-09-30 00:19:39'),
(173, 35, 72, 73, 'submit', NULL, 1, '2026-09-30 00:19:54', '2026-09-30 00:19:57', 1, 4, 2880, '2026-09-30 00:19:54', '2026-09-30 00:19:57'),
(174, 35, 73, 74, 'approve', NULL, 1, '2026-09-30 00:25:38', '2026-09-30 00:25:58', 1, NULL, 4320, '2026-09-30 00:25:38', '2026-09-30 00:25:58'),
(175, 35, 74, 73, 'revisit', 'Kulang bai uy', 1, '2026-09-30 00:26:21', '2026-09-30 00:26:24', 1, 4, 2880, '2026-09-30 00:26:21', '2026-09-30 00:26:24'),
(176, 35, 73, 72, 'revisit', 'Walang Hardcopy ng AR', 1, '2026-09-30 00:42:57', '2026-09-30 00:42:59', 1, NULL, 2880, '2026-09-30 00:42:57', '2026-09-30 00:42:59'),
(177, 36, 328, 328, 'create', 'Transaction created', 1, '2026-09-30 00:54:47', '2026-09-30 00:54:47', 1, 8, 0, '2026-09-30 00:54:47', '2026-09-30 00:54:47'),
(178, 37, 384, 384, 'create', 'Transaction created', 1, '2026-09-30 00:58:33', '2026-09-30 00:58:33', 1, 8, 0, '2026-09-30 00:58:33', '2026-09-30 00:58:33'),
(179, 35, 72, 73, 'submit', NULL, 1, '2026-09-30 01:16:58', '2026-09-30 01:17:00', 1, 4, 2880, '2026-09-30 01:16:58', '2026-09-30 01:17:00'),
(180, 37, 384, 385, 'submit', NULL, 1, '2026-09-30 01:17:49', '2026-09-30 01:17:50', 1, 24, 120, '2026-09-30 01:17:49', '2026-09-30 01:17:50'),
(181, 37, 385, 386, 'submit', NULL, 1, '2026-09-30 01:19:41', '2026-09-30 01:19:43', 1, 5, 120, '2026-09-30 01:19:41', '2026-09-30 01:19:43'),
(182, 37, 386, 387, 'submit', NULL, 1, '2026-09-30 01:20:01', '2026-09-30 01:20:03', 1, 24, 120, '2026-09-30 01:20:01', '2026-09-30 01:20:03'),
(183, 37, 387, 388, 'submit', NULL, 1, '2026-09-30 01:20:28', '2026-09-30 01:20:31', 1, 9, 120, '2026-09-30 01:20:28', '2026-09-30 01:20:31'),
(184, 37, 388, 389, 'submit', NULL, 1, '2026-09-30 01:20:54', '2026-09-30 01:20:56', 1, 1, 120, '2026-09-30 01:20:54', '2026-09-30 01:20:56'),
(185, 37, 389, 390, 'submit', NULL, 1, '2026-09-30 01:21:11', '2026-09-30 01:21:14', 1, 9, 120, '2026-09-30 01:21:11', '2026-09-30 01:21:14'),
(186, 35, 73, 72, 'revisit', 'Kulang po Maem', 1, '2026-09-30 01:28:49', '2026-09-30 01:29:47', 1, NULL, 2880, '2026-09-30 01:28:49', '2026-09-30 01:29:47'),
(187, 35, 72, 73, 'submit', NULL, 1, '2026-09-30 01:29:51', '2026-09-30 01:29:55', 1, 4, 2880, '2026-09-30 01:29:51', '2026-09-30 01:29:55'),
(188, 35, 73, 74, 'approve', NULL, 1, '2026-09-30 01:30:00', '2026-09-30 01:30:02', 1, NULL, 4320, '2026-09-30 01:30:00', '2026-09-30 01:30:02'),
(189, 38, 392, 392, 'create', 'Transaction created', 1, '2026-09-30 01:31:10', '2026-09-30 01:31:10', 1, 8, 0, '2026-09-30 01:31:10', '2026-09-30 01:31:10'),
(190, 38, 392, 393, 'submit', NULL, 1, '2026-09-30 01:31:30', '2026-09-30 01:31:32', 1, 24, 120, '2026-09-30 01:31:30', '2026-09-30 01:31:32'),
(191, 38, 393, 394, 'submit', NULL, 1, '2026-09-30 01:31:49', '2026-09-30 01:31:51', 1, 5, 120, '2026-09-30 01:31:49', '2026-09-30 01:31:51'),
(192, 38, 394, 395, 'submit', NULL, 1, '2026-09-30 01:32:04', '2026-09-30 01:32:06', 1, 24, 120, '2026-09-30 01:32:04', '2026-09-30 01:32:06'),
(193, 38, 395, 396, 'submit', NULL, 1, '2026-09-30 01:32:20', '2026-09-30 01:32:22', 1, 9, 120, '2026-09-30 01:32:20', '2026-09-30 01:32:22'),
(194, 38, 396, 397, 'submit', NULL, 1, '2026-09-30 01:44:03', '2026-09-30 01:44:05', 1, 1, 120, '2026-09-30 01:44:03', '2026-09-30 01:44:05'),
(195, 38, 397, 398, 'submit', NULL, 1, '2026-09-30 01:44:20', '2026-09-30 01:44:21', 1, 9, 120, '2026-09-30 01:44:20', '2026-09-30 01:44:21'),
(196, 38, 398, 399, 'submit', NULL, 1, '2026-09-30 01:44:32', '2026-09-30 01:44:34', 1, 26, 120, '2026-09-30 01:44:32', '2026-09-30 01:44:34'),
(197, 38, 399, 399, 'finalize', 'Transaction finalized', 1, '2026-09-30 01:44:39', '2026-09-30 01:44:39', 1, 26, 120, '2026-09-30 01:44:39', '2026-09-30 01:44:39'),
(198, 39, 392, 392, 'create', 'Transaction created', 1, '2026-09-30 01:44:55', '2026-09-30 01:44:55', 1, 8, 0, '2026-09-30 01:44:55', '2026-09-30 01:44:55'),
(199, 39, 392, 393, 'submit', NULL, 1, '2026-09-30 01:47:17', '2026-09-30 01:47:21', 1, 24, 120, '2026-09-30 01:47:17', '2026-09-30 01:47:21'),
(200, 39, 393, 394, 'submit', NULL, 1, '2026-09-30 01:49:31', '2026-09-30 01:50:03', 1, 5, 120, '2026-09-30 01:49:31', '2026-09-30 01:50:03'),
(201, 40, 392, 392, 'create', 'Transaction created', 1, '2026-09-30 16:09:17', '2026-09-30 16:09:17', 1, 8, 0, '2026-09-30 16:09:17', '2026-09-30 16:09:17'),
(202, 40, 392, 393, 'submit', NULL, 1, '2026-10-02 00:12:24', '2026-10-02 00:12:26', 1, 24, 120, '2026-10-02 00:12:24', '2026-10-02 00:12:26'),
(203, 40, 393, 394, 'submit', NULL, 1, '2026-10-02 00:12:38', '2026-10-02 00:16:55', 1, 5, 120, '2026-10-02 00:12:38', '2026-10-02 00:16:55'),
(204, 40, 394, 392, 'return', 'kulan man ni bai', 1, '2026-10-02 00:17:51', '2026-10-02 00:17:52', 1, 8, 0, '2026-10-02 00:17:51', '2026-10-02 00:17:52'),
(205, 40, 392, 393, 'submit', NULL, 1, '2026-10-03 02:06:10', '2026-10-03 02:06:17', 1, 24, 120, '2026-10-03 02:06:10', '2026-10-03 02:06:17'),
(206, 40, 393, 394, 'submit', NULL, 1, '2026-10-04 17:31:35', '2026-10-04 17:31:40', 1, 5, 120, '2026-10-04 17:31:35', '2026-10-04 17:31:40'),
(207, 41, 416, 416, 'create', 'Transaction created', 1, '2026-10-04 17:34:21', '2026-10-04 17:34:21', 1, 8, 0, '2026-10-04 17:34:21', '2026-10-04 17:34:21');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_types`
--
CREATE TABLE `transaction_types` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_types`
--

INSERT INTO `transaction_types` (`id`, `code`, `name`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'payroll', 'Payroll', 'job order', 1, '2026-03-09 21:24:39', '2026-09-20 17:11:37', NULL),
(2, 'procurement', 'Procurement', 'LGU procurement process (inventory-linked)', 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 'communication', 'Communication', NULL, 0, '2026-03-09 23:44:35', '2026-10-01 19:28:19', NULL),
(9, 'it_procurements', 'IT Equipment Procurement', 'It Equipment Procurement', 1, '2026-09-25 22:56:33', '2026-09-30 00:29:17', '2026-09-30 00:29:17'),
(10, 'wadawd', '2q21232-aa', 'awadawd', 1, '2026-09-29 23:31:04', '2026-09-29 23:39:29', '2026-09-29 23:39:29'),
(11, 'procurement_it_equipment', 'Procurement : IT Equipment', 'This is a procurement for the it department', 1, '2026-09-30 00:30:22', '2026-09-30 00:30:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `office_id`, `email_verified_at`, `password`, `is_active`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Vince', 'vinzmuloc@gmail.com', NULL, NULL, '$2y$12$Y6CeLNLVyESGRM8XGb/gL.ALhhOklVb4y/IoAWB6S9C0n4E64HxU.', 1, NULL, '2026-03-09 21:24:36', '2026-09-09 18:26:20'),
(2, 'End User', 'enduser@lgu.test', NULL, NULL, '$2y$12$h2C/zOIwaECF3Ah6LweuTuUcKlxykuFUfuKKUPqYx7r4wwRQoRAGC', 1, NULL, '2026-03-09 21:24:37', '2026-09-11 18:19:05'),
(3, 'GSO Officer', 'gso@lgu.test', NULL, NULL, '$2y$12$rrriIb9sCNEWUxc7H8mOre2PO95QwtyKlr3Y6U.YouvDznO.QCGqq', 1, NULL, '2026-03-09 21:24:37', '2026-09-11 18:19:05'),
(4, 'City Administrator', 'cityadmin@lgu.test', NULL, NULL, '$2y$12$GJQGkzjDxYeHp8sygkILPOvHVLz5fxU3jCSN00KQc1sJnk9iYSc1O', 1, NULL, '2026-03-09 21:24:37', '2026-09-11 18:19:05'),
(5, 'CTO', 'cto@lgu.test', NULL, NULL, '$2y$12$n.m75WfpWW3sEUWWak9ZeetxYF7fZnHzpTenRJ3aaiVkFIaPUYVAm', 1, NULL, '2026-03-09 21:24:37', '2026-09-11 18:19:05'),
(6, 'City Treasurer', 'treasurer@lgu.test', NULL, NULL, '$2y$12$ZcefDk4X.cJoTYbBeTQcZ.8..jBDttx6kw9IM6cumVbrhGxWspL3G', 1, NULL, '2026-03-09 21:24:38', '2026-09-11 18:19:05'),
(7, 'CAdmin', 'cadmin@lgu.test', NULL, NULL, '$2y$12$qP71hW5oIAtu9rzjdqAYqOPzL1bh.N1m5PyAzqmE/4nUtI.PPoBZi', 1, NULL, '2026-03-09 21:24:38', '2026-09-11 18:19:05'),
(8, 'CBO', 'cbo@lgu.test', NULL, NULL, '$2y$12$GauIm7PsF1P1WnBXdiEWwOEEAEW5EFNkoIGyexEZdsaDM/hKoqyb.', 1, NULL, '2026-03-09 21:24:38', '2026-09-11 18:19:05'),
(9, 'BAC-PAAD', 'bac@lgu.test', NULL, NULL, '$2y$12$RO/AJp268imBpaUY287aFOSZsUlEuWcL/NFQJx7O/Vh14E5AeKAHS', 1, NULL, '2026-03-09 21:24:39', '2026-09-11 18:19:05'),
(10, 'Hendrich', 'user@gmail.com', NULL, NULL, '$2y$12$MpH73ZeDsEcViqIozri/COASRyUkzzwxzXuwoexTwmiF2K5KunAHq', 1, NULL, '2026-09-10 21:08:36', '2026-09-10 21:08:36');

-- --------------------------------------------------------

--
-- Table structure for table `workflow_definitions`
--
CREATE TABLE `workflow_definitions` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_type_id` bigint UNSIGNED NOT NULL,
  `version` int UNSIGNED NOT NULL DEFAULT '1',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `is_live` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `published_at` timestamp NULL DEFAULT NULL,
  `published_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_definitions`
--

INSERT INTO `workflow_definitions` (`id`, `transaction_type_id`, `version`, `status`, `is_live`, `name`, `notes`, `published_at`, `published_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'published', 0, 'Payroll v1', 'Seeded sample workflow (TO VERIFY actual process)', '2026-03-09 21:24:39', 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 2, 1, 'published', 0, 'Purchase Request v1', 'Seeded full PR workflow based on executive summary flow image', '2026-03-09 21:24:39', 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 3, 1, 'published', 0, NULL, NULL, '2026-03-09 23:51:30', 1, '2026-03-09 23:49:10', '2026-10-01 19:05:57', NULL),
(4, 3, 2, 'published', 0, NULL, NULL, '2026-03-09 23:57:22', 1, '2026-03-09 23:56:26', '2026-10-01 19:05:57', NULL),
(5, 3, 3, 'published', 0, NULL, NULL, '2026-09-13 22:43:18', 1, '2026-03-10 00:30:24', '2026-10-01 19:05:57', NULL),
(7, 2, 3, 'published', 1, NULL, NULL, '2026-09-11 20:12:13', 1, '2026-09-11 20:07:42', '2026-09-11 20:12:13', NULL),
(16, 3, 4, 'published', 0, NULL, NULL, '2026-09-13 22:43:45', 1, '2026-09-13 22:43:22', '2026-10-01 19:05:57', NULL),
(17, 1, 2, 'published', 1, NULL, NULL, '2026-09-24 19:04:26', 1, '2026-09-14 00:53:40', '2026-09-24 19:04:26', NULL),
(26, 9, 1, 'published', 0, NULL, NULL, '2026-09-25 23:09:34', 1, '2026-09-25 22:56:43', '2026-09-25 23:09:34', NULL),
(27, 9, 2, 'published', 0, NULL, NULL, '2026-09-25 23:13:21', 1, '2026-09-25 23:12:20', '2026-09-25 23:13:21', NULL),
(28, 9, 3, 'published', 0, NULL, NULL, '2026-09-25 23:13:46', 1, '2026-09-25 23:13:32', '2026-09-25 23:13:46', NULL),
(29, 9, 4, 'published', 0, NULL, NULL, '2026-09-25 23:15:25', 1, '2026-09-25 23:14:13', '2026-09-25 23:15:25', NULL),
(30, 9, 5, 'published', 0, NULL, NULL, '2026-09-25 23:15:44', 1, '2026-09-25 23:15:34', '2026-09-25 23:15:44', NULL),
(31, 9, 6, 'published', 0, NULL, NULL, '2026-09-25 23:15:55', 1, '2026-09-25 23:15:47', '2026-09-25 23:15:55', NULL),
(32, 9, 7, 'published', 0, NULL, NULL, '2026-09-25 23:16:10', 1, '2026-09-25 23:15:59', '2026-09-25 23:16:10', NULL),
(33, 9, 8, 'published', 0, NULL, NULL, '2026-09-25 23:16:23', 1, '2026-09-25 23:16:13', '2026-09-25 23:16:23', NULL),
(34, 9, 9, 'published', 0, NULL, NULL, '2026-09-25 23:16:37', 1, '2026-09-25 23:16:28', '2026-09-25 23:16:37', NULL),
(35, 9, 10, 'published', 0, NULL, NULL, '2026-09-25 23:16:52', 1, '2026-09-25 23:16:41', '2026-09-25 23:16:52', NULL),
(36, 9, 11, 'published', 0, NULL, NULL, '2026-09-25 23:17:09', 1, '2026-09-25 23:16:57', '2026-09-25 23:17:09', NULL),
(37, 9, 12, 'published', 0, NULL, NULL, '2026-09-25 23:17:30', 1, '2026-09-25 23:17:13', '2026-09-25 23:17:30', NULL),
(38, 9, 13, 'published', 0, NULL, NULL, '2026-09-25 23:17:42', 1, '2026-09-25 23:17:34', '2026-09-25 23:17:42', NULL),
(39, 9, 14, 'published', 0, NULL, NULL, '2026-09-25 23:17:55', 1, '2026-09-25 23:17:45', '2026-09-25 23:17:55', NULL),
(40, 9, 15, 'published', 0, NULL, NULL, '2026-09-27 22:14:18', 1, '2026-09-27 22:13:53', '2026-09-27 22:14:18', NULL),
(41, 9, 16, 'published', 0, NULL, NULL, '2026-09-27 22:14:45', 1, '2026-09-27 22:14:30', '2026-09-27 22:14:45', NULL),
(42, 9, 17, 'published', 0, NULL, NULL, '2026-09-27 22:15:13', 1, '2026-09-27 22:15:04', '2026-09-27 22:15:13', NULL),
(43, 9, 18, 'published', 0, NULL, NULL, '2026-09-27 22:15:48', 1, '2026-09-27 22:15:25', '2026-09-27 22:15:48', NULL),
(44, 9, 19, 'published', 0, NULL, NULL, '2026-09-28 17:20:39', 1, '2026-09-28 17:20:34', '2026-09-28 17:20:39', NULL),
(45, 9, 20, 'published', 0, NULL, NULL, '2026-09-28 17:28:14', 1, '2026-09-28 17:27:45', '2026-09-28 17:28:14', NULL),
(46, 9, 21, 'published', 0, NULL, NULL, '2026-09-28 17:32:00', 1, '2026-09-28 17:31:40', '2026-09-28 17:32:00', NULL),
(47, 9, 22, 'published', 0, NULL, NULL, '2026-09-29 23:27:23', 1, '2026-09-28 17:32:11', '2026-09-29 23:27:23', NULL),
(48, 10, 1, 'published', 1, NULL, NULL, '2026-09-29 23:37:12', 1, '2026-09-29 23:34:04', '2026-09-29 23:37:12', NULL),
(49, 10, 2, 'draft', 0, NULL, NULL, NULL, NULL, '2026-09-29 23:37:52', '2026-09-29 23:37:52', NULL),
(50, 9, 23, 'published', 1, NULL, NULL, '2026-09-30 00:24:42', 1, '2026-09-30 00:23:40', '2026-09-30 00:24:42', NULL),
<<<<<<<< HEAD:transaction.sql(20).sql
(53, 11, 1, 'published', 0, NULL, NULL, '2026-09-30 00:42:35', 1, '2026-09-30 00:30:31', '2026-10-04 17:33:40', NULL),
(54, 11, 2, 'published', 0, NULL, NULL, '2026-09-30 00:55:15', 1, '2026-09-30 00:52:28', '2026-10-04 17:33:40', NULL),
(55, 11, 3, 'published', 0, NULL, NULL, '2026-09-30 00:55:25', 1, '2026-09-30 00:55:17', '2026-10-04 17:33:40', NULL),
(56, 11, 4, 'published', 0, NULL, NULL, '2026-09-30 00:55:35', 1, '2026-09-30 00:55:27', '2026-10-04 17:33:40', NULL),
(57, 11, 5, 'published', 0, NULL, NULL, '2026-09-30 00:55:46', 1, '2026-09-30 00:55:37', '2026-10-04 17:33:40', NULL),
(58, 11, 6, 'published', 0, NULL, NULL, '2026-09-30 00:55:57', 1, '2026-09-30 00:55:49', '2026-10-04 17:33:40', NULL),
(59, 11, 7, 'published', 0, NULL, NULL, '2026-09-30 00:56:17', 1, '2026-09-30 00:56:08', '2026-10-04 17:33:40', NULL),
(60, 11, 8, 'published', 0, NULL, NULL, '2026-09-30 00:56:30', 1, '2026-09-30 00:56:20', '2026-10-04 17:33:40', NULL),
(61, 11, 9, 'published', 0, NULL, NULL, '2026-09-30 01:15:16', 1, '2026-09-30 01:15:05', '2026-10-04 17:33:40', NULL),
(62, 3, 5, 'published', 1, 'Bryan', NULL, '2026-09-30 20:32:13', 1, '2026-09-30 20:31:59', '2026-09-30 20:34:10', NULL),
(63, 3, 6, 'published', 0, NULL, NULL, '2026-09-30 20:33:11', 1, '2026-09-30 20:32:32', '2026-09-30 20:34:10', NULL),
(64, 3, 7, 'published', 0, 'bry', 's', '2026-09-30 20:33:37', 1, '2026-09-30 20:33:36', '2026-09-30 20:34:10', NULL),
(65, 11, 10, 'published', 0, NULL, NULL, '2026-10-04 17:33:29', 1, '2026-10-04 17:33:21', '2026-10-04 17:33:40', NULL),
(66, 11, 11, 'published', 1, NULL, NULL, '2026-10-04 17:33:40', 1, '2026-10-04 17:33:33', '2026-10-04 17:33:40', NULL);
========
(53, 11, 1, 'published', 0, NULL, NULL, '2026-09-30 00:42:35', 1, '2026-09-30 00:30:31', '2026-09-30 00:42:35', NULL),
(54, 11, 2, 'published', 0, NULL, NULL, '2026-09-30 00:55:15', 1, '2026-09-30 00:52:28', '2026-09-30 00:55:15', NULL),
(55, 11, 3, 'published', 0, NULL, NULL, '2026-09-30 00:55:25', 1, '2026-09-30 00:55:17', '2026-09-30 00:55:25', NULL),
(56, 11, 4, 'published', 0, NULL, NULL, '2026-09-30 00:55:35', 1, '2026-09-30 00:55:27', '2026-09-30 00:55:35', NULL),
(57, 11, 5, 'published', 0, NULL, NULL, '2026-09-30 00:55:46', 1, '2026-09-30 00:55:37', '2026-09-30 00:55:46', NULL),
(58, 11, 6, 'published', 0, NULL, NULL, '2026-09-30 00:55:57', 1, '2026-09-30 00:55:49', '2026-09-30 00:55:57', NULL),
(59, 11, 7, 'published', 0, NULL, NULL, '2026-09-30 00:56:17', 1, '2026-09-30 00:56:08', '2026-09-30 00:56:17', NULL),
(60, 11, 8, 'published', 0, NULL, NULL, '2026-09-30 00:56:30', 1, '2026-09-30 00:56:20', '2026-09-30 00:56:30', NULL),
(61, 11, 9, 'published', 1, NULL, NULL, '2026-09-30 01:15:16', 1, '2026-09-30 01:15:05', '2026-09-30 01:15:16', NULL),
(62, 3, 5, 'published', 1, 'Bryan', NULL, '2026-09-30 20:32:13', 1, '2026-09-30 20:31:59', '2026-10-01 19:05:57', NULL),
(63, 3, 6, 'published', 0, NULL, NULL, '2026-09-30 20:33:11', 1, '2026-09-30 20:32:32', '2026-10-01 19:05:57', NULL),
(64, 3, 7, 'published', 0, 'bry', 's', '2026-09-30 20:33:37', 1, '2026-09-30 20:33:36', '2026-10-01 19:05:57', NULL);
>>>>>>>> versioncontrolcache:oct 5.sql

-- --------------------------------------------------------

--
-- Table structure for table `workflow_routes`
--
CREATE TABLE `workflow_routes` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `from_step_id` bigint UNSIGNED NOT NULL,
  `to_step_id` bigint UNSIGNED NOT NULL,
  `action_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_return_route` tinyint(1) NOT NULL DEFAULT '0',
  `condition_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `route_group` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `required_approvals_count` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_routes`
--

INSERT INTO `workflow_routes` (`id`, `workflow_definition_id`, `from_step_id`, `to_step_id`, `action_code`, `is_return_route`, `condition_expression`, `route_group`, `required_approvals_count`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 2, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 1, 2, 3, 'approve', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 1, 2, 1, 'return', 1, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 2, 4, 5, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, 2, 5, 6, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, 2, 6, 7, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, 2, 7, 8, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(8, 2, 8, 9, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(9, 2, 9, 10, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(10, 2, 10, 11, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(11, 2, 11, 12, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(12, 2, 12, 13, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(13, 2, 13, 14, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(14, 2, 14, 15, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(15, 2, 15, 16, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(16, 2, 16, 17, 'submit', 0, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(17, 2, 9, 4, 'return', 1, NULL, NULL, NULL, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(18, 3, 18, 19, 'submit', 0, NULL, NULL, NULL, '2026-03-09 23:50:23', '2026-03-09 23:50:23', NULL),
(19, 4, 20, 21, 'submit', 0, NULL, NULL, NULL, '2026-03-09 23:56:26', '2026-03-09 23:56:26', NULL),
(20, 4, 21, 20, 'submit', 0, NULL, NULL, NULL, '2026-03-09 23:56:48', '2026-03-09 23:56:48', NULL),
(21, 5, 22, 23, 'submit', 0, NULL, NULL, NULL, '2026-03-10 00:30:24', '2026-03-10 00:30:24', NULL),
(22, 5, 23, 22, 'submit', 0, NULL, NULL, NULL, '2026-03-10 00:30:24', '2026-03-10 00:30:24', NULL),
(37, 7, 43, 38, 'return', 1, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(38, 7, 38, 39, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(39, 7, 39, 40, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(40, 7, 40, 41, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(41, 7, 41, 42, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(42, 7, 42, 43, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(43, 7, 43, 44, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(44, 7, 44, 45, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(45, 7, 45, 46, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(46, 7, 46, 47, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(47, 7, 47, 48, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(48, 7, 48, 49, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(49, 7, 49, 50, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(50, 7, 50, 51, 'submit', 0, NULL, NULL, NULL, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(54, 16, 70, 71, 'submit', 0, NULL, NULL, NULL, '2026-09-13 22:43:22', '2026-09-13 22:43:22', NULL),
(55, 16, 71, 70, 'return', 1, NULL, NULL, NULL, '2026-09-13 22:43:22', '2026-09-13 22:49:48', NULL),
(56, 17, 73, 74, 'approve', 0, NULL, NULL, NULL, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(57, 17, 73, 72, 'return', 1, NULL, NULL, NULL, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(58, 17, 72, 73, 'submit', 0, NULL, NULL, NULL, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(64, 32, 146, 147, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:09', '2026-09-25 23:16:09', NULL),
(65, 33, 154, 155, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:13', '2026-09-25 23:16:13', NULL),
(66, 33, 155, 156, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:22', '2026-09-25 23:16:22', NULL),
(67, 34, 162, 163, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(68, 34, 163, 164, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:28', '2026-09-25 23:16:28', NULL),
(69, 34, 164, 165, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:36', '2026-09-25 23:16:36', NULL),
(70, 35, 170, 171, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(71, 35, 171, 172, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(72, 35, 172, 173, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:41', '2026-09-25 23:16:41', NULL),
(73, 35, 173, 174, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:51', '2026-09-25 23:16:51', NULL),
(74, 36, 178, 179, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(75, 36, 179, 180, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(76, 36, 180, 181, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(77, 36, 181, 182, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:16:57', '2026-09-25 23:16:57', NULL),
(78, 36, 181, 182, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:08', '2026-09-25 23:17:08', NULL),
(79, 37, 186, 187, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(80, 37, 187, 188, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(81, 37, 188, 189, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(82, 37, 190, 191, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:13', '2026-09-25 23:17:29', NULL),
(83, 37, 189, 190, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:13', '2026-09-25 23:17:13', NULL),
(84, 38, 194, 195, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(85, 38, 195, 196, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(86, 38, 196, 197, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(87, 38, 198, 199, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(88, 38, 197, 198, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:34', '2026-09-25 23:17:34', NULL),
(89, 38, 199, 200, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:41', '2026-09-25 23:17:41', NULL),
(90, 39, 202, 203, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(91, 39, 203, 204, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(92, 39, 204, 205, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(93, 39, 206, 207, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(94, 39, 205, 206, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(95, 39, 207, 208, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(96, 39, 208, 209, 'submit', 0, NULL, NULL, NULL, '2026-09-25 23:17:54', '2026-09-25 23:17:54', NULL),
(97, 40, 210, 211, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(98, 40, 211, 212, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(99, 40, 212, 213, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(100, 40, 214, 215, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(101, 40, 213, 214, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(102, 40, 215, 216, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(103, 40, 216, 217, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(104, 41, 218, 219, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(105, 41, 219, 220, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(106, 41, 220, 221, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(107, 41, 222, 223, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(108, 41, 221, 222, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(109, 41, 223, 224, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(110, 41, 224, 225, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(111, 42, 226, 227, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(112, 42, 227, 228, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(113, 42, 228, 229, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(114, 42, 230, 231, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(115, 42, 229, 230, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(116, 42, 231, 232, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(117, 42, 232, 233, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(118, 43, 234, 235, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(119, 43, 235, 236, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(120, 43, 236, 237, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(121, 43, 238, 239, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(122, 43, 237, 238, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(123, 43, 239, 240, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(124, 43, 240, 241, 'submit', 0, NULL, NULL, NULL, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(125, 44, 242, 243, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(126, 44, 243, 244, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(127, 44, 244, 245, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(128, 44, 246, 247, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(129, 44, 245, 246, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(130, 44, 247, 248, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(131, 44, 248, 249, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(132, 45, 250, 251, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(133, 45, 251, 252, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(134, 45, 252, 253, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(135, 45, 254, 255, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(136, 45, 253, 254, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(137, 45, 255, 256, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(138, 45, 256, 257, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(139, 46, 259, 260, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(140, 46, 260, 261, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(141, 46, 261, 262, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(142, 46, 263, 264, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(143, 46, 262, 263, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(144, 46, 264, 265, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(145, 46, 265, 266, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(146, 47, 268, 269, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(147, 47, 269, 270, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(148, 47, 270, 271, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(149, 47, 272, 273, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(150, 47, 271, 272, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(151, 47, 273, 274, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(152, 47, 274, 275, 'submit', 0, NULL, NULL, NULL, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(153, 50, 291, 292, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(154, 50, 292, 293, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(155, 50, 293, 294, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(156, 50, 295, 296, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(157, 50, 294, 295, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(158, 50, 296, 297, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(159, 50, 297, 298, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(160, 54, 336, 337, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:14', '2026-09-30 00:55:14', NULL),
(161, 55, 344, 345, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(162, 55, 345, 346, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:24', '2026-09-30 00:55:24', NULL),
(163, 56, 352, 353, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(164, 56, 353, 354, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(165, 56, 354, 355, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:34', '2026-09-30 00:55:34', NULL),
(166, 57, 360, 361, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(167, 57, 361, 362, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(168, 57, 362, 363, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(169, 57, 363, 364, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:45', '2026-09-30 00:55:45', NULL),
(170, 58, 368, 369, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(171, 58, 369, 370, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(172, 58, 370, 371, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(173, 58, 371, 372, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(174, 58, 372, 373, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:55:56', '2026-09-30 00:55:56', NULL),
(175, 59, 376, 377, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(176, 59, 377, 378, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(177, 59, 378, 379, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(178, 59, 379, 380, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(179, 59, 380, 381, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(180, 59, 381, 382, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:16', '2026-09-30 00:56:16', NULL),
(181, 60, 384, 385, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(182, 60, 385, 386, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(183, 60, 386, 387, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(184, 60, 387, 388, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(185, 60, 388, 389, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(186, 60, 389, 390, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(187, 60, 390, 391, 'submit', 0, NULL, NULL, NULL, '2026-09-30 00:56:28', '2026-09-30 00:56:28', NULL),
(188, 61, 392, 393, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(189, 61, 393, 394, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(190, 61, 394, 395, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(191, 61, 395, 396, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(192, 61, 396, 397, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(193, 61, 397, 398, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(194, 61, 398, 399, 'submit', 0, NULL, NULL, NULL, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(195, 62, 401, 400, 'return', 1, NULL, NULL, NULL, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(196, 62, 400, 401, 'submit', 0, NULL, NULL, NULL, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(197, 63, 403, 402, 'return', 1, NULL, NULL, NULL, '2026-09-30 20:32:33', '2026-09-30 20:32:33', NULL),
(198, 63, 402, 403, 'submit', 0, NULL, NULL, NULL, '2026-09-30 20:32:33', '2026-09-30 20:32:33', NULL),
(199, 64, 406, 405, 'return', 1, NULL, NULL, NULL, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(200, 64, 405, 406, 'submit', 0, NULL, NULL, NULL, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(201, 65, 408, 409, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(202, 65, 409, 410, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(203, 65, 410, 411, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(204, 65, 411, 412, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(205, 65, 412, 413, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(206, 65, 413, 414, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(207, 65, 414, 415, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(208, 66, 416, 417, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(209, 66, 417, 418, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(210, 66, 418, 419, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(211, 66, 419, 420, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(212, 66, 420, 421, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(213, 66, 421, 422, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(214, 66, 422, 423, 'submit', 0, NULL, NULL, NULL, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL);

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
(209, 39, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-25 23:17:45', '2026-09-25 23:17:45', NULL),
(210, 40, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-27 22:13:53', '2026-09-27 22:14:17', NULL),
(211, 40, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(212, 40, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(213, 40, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(214, 40, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(215, 40, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(216, 40, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(217, 40, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-27 22:13:53', '2026-09-27 22:13:53', NULL),
(218, 41, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(219, 41, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:44', NULL),
(220, 41, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(221, 41, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(222, 41, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(223, 41, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(224, 41, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(225, 41, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-27 22:14:30', '2026-09-27 22:14:30', NULL),
(226, 42, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(227, 42, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(228, 42, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:12', NULL),
(229, 42, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(230, 42, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(231, 42, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(232, 42, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(233, 42, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-27 22:15:04', '2026-09-27 22:15:04', NULL),
(234, 43, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(235, 43, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(236, 43, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(237, 43, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:47', NULL),
(238, 43, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(239, 43, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(240, 43, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(241, 43, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-27 22:15:25', '2026-09-27 22:15:25', NULL),
(242, 44, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(243, 44, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(244, 44, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(245, 44, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(246, 44, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(247, 44, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(248, 44, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-28 17:20:34', '2026-09-28 17:20:38', NULL),
(249, 44, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-28 17:20:34', '2026-09-28 17:20:34', NULL),
(250, 45, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(251, 45, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(252, 45, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(253, 45, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(254, 45, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(255, 45, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(256, 45, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(257, 45, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-28 17:27:45', '2026-09-28 17:27:45', NULL),
(258, 45, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 24, 0, 0, 0, '2026-09-28 17:28:13', '2026-09-28 17:28:13', NULL),
(259, 46, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(260, 46, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(261, 46, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(262, 46, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(263, 46, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(264, 46, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(265, 46, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(266, 46, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, '2026-09-28 17:31:40', '2026-09-28 17:31:40', NULL),
(267, 46, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, '2026-09-28 17:31:40', '2026-09-28 17:31:54', NULL),
(268, 47, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(269, 47, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(270, 47, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(271, 47, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(272, 47, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(273, 47, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(274, 47, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(275, 47, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:16', NULL),
(276, 47, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, '2026-09-28 17:32:11', '2026-09-28 17:32:11', NULL),
(277, 47, NULL, 10, 'it_procurements_10', 'Return GSO Approve PR to end user', 'PR numbering', 24, 60, 0, 0, '2026-09-28 17:33:29', '2026-09-28 17:33:29', NULL),
(278, 47, NULL, 11, 'it_procurements_11', 'Submit PR to CTO (availability of funds)', 'Availability of funds', 5, 58, 0, 0, '2026-09-28 17:35:21', '2026-09-28 17:35:21', NULL),
(279, 47, NULL, 12, 'it_procurements_12', 'Return CTO approve PR to  End user', 'Availability of funds', 24, 60, 0, 0, '2026-09-28 17:36:00', '2026-09-28 17:36:00', NULL),
(280, 47, NULL, 13, 'it_procurements_13', 'Submit PR to CBO (Availability of Appropriation)', 'Availability of Appropriation', 9, 60, 0, 0, '2026-09-28 17:36:47', '2026-09-28 17:36:47', NULL),
(281, 47, NULL, 14, 'it_procurements_14', 'Submit Pr to Mayor Office (Approval)', 'Mayors Approval', 1, 58, 0, 0, '2026-09-28 17:37:46', '2026-09-28 17:37:46', NULL),
(282, 47, NULL, 15, 'it_procurements_15', 'Return Approve Pr to CBO', 'Mayors Approval', 9, 60, 0, 0, '2026-09-28 17:38:27', '2026-09-28 17:38:27', NULL),
(283, 47, NULL, 16, 'it_procurements_16', 'Submit PR to PAAD', 'PR submission', 10, 60, 0, 0, '2026-09-28 17:39:16', '2026-09-28 17:39:16', NULL),
(284, 47, NULL, 17, 'it_procurements_17', 'Conduct Bidding and Awarding', 'Bids and Awards', 25, 58, 0, 0, '2026-09-28 17:47:01', '2026-09-28 17:47:01', NULL),
(285, 47, NULL, 18, 'it_procurements_18', 'Create Contract', 'Contract', 10, 60, 0, 0, '2026-09-28 17:51:04', '2026-09-28 17:51:04', NULL),
(286, 47, NULL, 19, 'it_procurements_19', 'awda', 'wadawd', 21, 60, 0, 1, '2026-09-29 23:27:22', '2026-09-29 23:27:22', NULL),
(287, 48, NULL, 1, 'wadawd_1', 'step1 trial', 'stepp1', 21, 120, 1, 0, '2026-09-29 23:34:30', '2026-09-29 23:34:30', NULL),
(288, 48, NULL, 2, 'wadawd_2', 'step2', 'steppp2', 25, 60, 0, 1, '2026-09-29 23:37:11', '2026-09-29 23:37:11', NULL),
(289, 49, NULL, 1, 'wadawd_1', 'step1 trial', 'stepp1', 21, 120, 1, 0, '2026-09-29 23:37:52', '2026-09-29 23:37:52', NULL),
(290, 49, NULL, 2, 'wadawd_2', 'step2', 'steppp2', 25, 60, 0, 0, '2026-09-29 23:37:52', '2026-09-29 23:37:55', NULL),
(291, 50, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:42', '2026-09-30 00:23:42'),
(292, 50, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:44', '2026-09-30 00:23:44'),
(293, 50, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:48', '2026-09-30 00:23:48'),
(294, 50, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:51', '2026-09-30 00:23:51'),
(295, 50, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:54', '2026-09-30 00:23:54'),
(296, 50, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:58', '2026-09-30 00:23:58'),
(297, 50, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:24:01', '2026-09-30 00:24:01'),
(298, 50, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 1, 0, '2026-09-30 00:23:40', '2026-09-30 00:24:40', NULL),
(299, 50, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(300, 50, NULL, 10, 'it_procurements_10', 'Return GSO Approve PR to end user', 'PR numbering', 24, 60, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(301, 50, NULL, 11, 'it_procurements_11', 'Submit PR to CTO (availability of funds)', 'Availability of funds', 5, 58, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(302, 50, NULL, 12, 'it_procurements_12', 'Return CTO approve PR to  End user', 'Availability of funds', 24, 60, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(303, 50, NULL, 13, 'it_procurements_13', 'Submit PR to CBO (Availability of Appropriation)', 'Availability of Appropriation', 9, 60, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(304, 50, NULL, 14, 'it_procurements_14', 'Submit Pr to Mayor Office (Approval)', 'Mayors Approval', 1, 58, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(305, 50, NULL, 15, 'it_procurements_15', 'Return Approve Pr to CBO', 'Mayors Approval', 9, 60, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:23:40', NULL),
(306, 50, NULL, 16, 'it_procurements_16', 'Submit PR to PAAD', 'PR submission', 10, 60, 0, 1, '2026-09-30 00:23:40', '2026-09-30 00:24:29', NULL),
(307, 50, NULL, 17, 'it_procurements_17', 'Conduct Bidding and Awarding', 'Bids and Awards', 25, 58, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:24:17', '2026-09-30 00:24:17'),
(308, 50, NULL, 18, 'it_procurements_18', 'Create Contract', 'Contract', 10, 60, 0, 0, '2026-09-30 00:23:40', '2026-09-30 00:24:22', '2026-09-30 00:24:22'),
(309, 50, NULL, 19, 'it_procurements_19', 'awda', 'wadawd', 21, 60, 0, 1, '2026-09-30 00:23:40', '2026-09-30 00:24:20', '2026-09-30 00:24:20'),
(328, 53, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:33:36', '2026-09-30 00:33:36', NULL),
(329, 53, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:34:50', '2026-09-30 00:34:50', NULL),
(330, 53, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:35:35', '2026-09-30 00:35:35', NULL),
(331, 53, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:36:14', '2026-09-30 00:36:14', NULL),
(332, 53, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:36:56', '2026-09-30 00:36:56', NULL),
(333, 53, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:37:32', '2026-09-30 00:37:32', NULL),
(334, 53, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:38:23', '2026-09-30 00:38:23', NULL),
(335, 53, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:42:34', '2026-09-30 00:42:34', NULL),
(336, 54, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(337, 54, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(338, 54, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(339, 54, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(340, 54, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(341, 54, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(342, 54, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(343, 54, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:52:28', '2026-09-30 00:52:28', NULL),
(344, 55, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(345, 55, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(346, 55, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(347, 55, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(348, 55, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(349, 55, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(350, 55, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(351, 55, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:55:17', '2026-09-30 00:55:17', NULL),
(352, 56, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(353, 56, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(354, 56, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(355, 56, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(356, 56, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(357, 56, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(358, 56, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(359, 56, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:55:27', '2026-09-30 00:55:27', NULL),
(360, 57, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(361, 57, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(362, 57, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(363, 57, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(364, 57, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(365, 57, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(366, 57, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(367, 57, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:55:37', '2026-09-30 00:55:37', NULL),
(368, 58, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(369, 58, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(370, 58, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(371, 58, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(372, 58, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(373, 58, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(374, 58, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(375, 58, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:55:49', '2026-09-30 00:55:49', NULL),
(376, 59, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(377, 59, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(378, 59, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(379, 59, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(380, 59, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(381, 59, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(382, 59, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(383, 59, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:56:08', '2026-09-30 00:56:08', NULL),
(384, 60, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(385, 60, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(386, 60, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(387, 60, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(388, 60, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(389, 60, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(390, 60, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(391, 60, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 00:56:20', '2026-09-30 00:56:20', NULL),
(392, 61, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(393, 61, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(394, 61, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(395, 61, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(396, 61, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(397, 61, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(398, 61, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-09-30 01:15:05', '2026-09-30 01:15:15', NULL),
(399, 61, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-09-30 01:15:05', '2026-09-30 01:15:05', NULL),
(400, 62, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(401, 62, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, '2026-09-30 20:31:59', '2026-09-30 20:31:59', NULL),
(402, 63, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-09-30 20:32:32', '2026-09-30 20:32:32', NULL),
(403, 63, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, '2026-09-30 20:32:32', '2026-09-30 20:32:32', NULL),
(404, 63, 402, 3, 'communication_3', 'bry', NULL, 23, 60, 0, 0, '2026-09-30 20:33:10', '2026-09-30 20:33:10', NULL);
INSERT INTO `workflow_steps` (`id`, `workflow_definition_id`, `parent_id`, `order_number`, `code`, `name`, `stage`, `office_id`, `sla_minutes`, `is_start`, `is_end`, `created_at`, `updated_at`, `deleted_at`) VALUES
(405, 64, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(406, 64, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(407, 64, NULL, 3, 'communication_3', 'bry', NULL, 23, 60, 0, 0, '2026-09-30 20:33:37', '2026-09-30 20:33:37', NULL),
(408, 65, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(409, 65, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(410, 65, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:28', NULL),
(411, 65, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(412, 65, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(413, 65, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(414, 65, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(415, 65, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-10-04 17:33:21', '2026-10-04 17:33:21', NULL),
(416, 66, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(417, 66, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(418, 66, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(419, 66, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:39', NULL),
(420, 66, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(421, 66, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(422, 66, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL),
(423, 66, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, '2026-10-04 17:33:33', '2026-10-04 17:33:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `workflow_step_data`
--
CREATE TABLE `workflow_step_data` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `min_length` int UNSIGNED DEFAULT NULL,
  `max_length` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_entity_type_entity_id_index` (`entity_type`,`entity_id`),
  ADD KEY `audit_logs_event_created_at_index` (`event`,`created_at`),
  ADD KEY `audit_logs_actor_user_id_index` (`actor_user_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `checklist_overrides`
--
ALTER TABLE `checklist_overrides`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chk_step` (`workflow_step_id`),
  ADD KEY `idx_chk_reqdef` (`requirement_definition_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `field_definitions`
--
ALTER TABLE `field_definitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `field_definitions_workflow_definition_id_code_unique` (`workflow_definition_id`,`code`);

--
-- Indexes for table `field_definition_workflow_step`
--
ALTER TABLE `field_definition_workflow_step`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_step_field` (`workflow_step_id`,`field_definition_id`),
  ADD KEY `field_definition_workflow_step_field_definition_id_foreign` (`field_definition_id`);

--
-- Indexes for table `field_values`
--
ALTER TABLE `field_values`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_tx_field` (`transaction_id`,`field_definition_id`),
  ADD KEY `field_values_field_definition_id_foreign` (`field_definition_id`),
  ADD KEY `field_values_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `government_references`
--
ALTER TABLE `government_references`
  ADD PRIMARY KEY (`id`),
  ADD KEY `government_references_code_source_index` (`code`,`source`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `offices`
--
ALTER TABLE `offices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `offices_code_unique` (`code`);

--
-- Indexes for table `office_steps`
--
ALTER TABLE `office_steps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `office_steps_office_id_code_unique` (`office_id`,`code`),
  ADD KEY `office_steps_office_id_order_number_index` (`office_id`,`order_number`),
  ADD KEY `office_steps_parent_id_foreign` (`parent_id`),
  ADD KEY `office_steps_office_id_parent_id_order_number_index` (`office_id`,`parent_id`,`order_number`);

--
-- Indexes for table `office_transaction_type`
--
ALTER TABLE `office_transaction_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `office_transaction_type_office_id_transaction_type_id_unique` (`office_id`,`transaction_type_id`),
  ADD KEY `office_transaction_type_transaction_type_id_foreign` (`transaction_type_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_code_unique` (`code`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indexes for table `requirement_definitions`
--
ALTER TABLE `requirement_definitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reqdef_wf_code` (`workflow_definition_id`,`code`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_code_unique` (`code`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`role_id`,`user_id`),
  ADD KEY `role_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `step_requirements`
--
ALTER TABLE `step_requirements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_step_req` (`workflow_step_id`,`requirement_definition_id`),
  ADD KEY `fk_sr_reqdef` (`requirement_definition_id`);

--
-- Indexes for table `step_roles`
--
ALTER TABLE `step_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `step_roles_workflow_step_id_role_id_unique` (`workflow_step_id`,`role_id`),
  ADD KEY `step_roles_role_id_foreign` (`role_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transactions_reference_number_unique` (`reference_number`),
  ADD KEY `transactions_workflow_definition_id_foreign` (`workflow_definition_id`),
  ADD KEY `transactions_created_by_foreign` (`created_by`),
  ADD KEY `transactions_transaction_type_id_workflow_definition_id_index` (`transaction_type_id`,`workflow_definition_id`),
  ADD KEY `transactions_office_id_foreign` (`office_id`);

--
-- Indexes for table `transaction_attachments`
--
ALTER TABLE `transaction_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_ta_tx_step` (`transaction_id`,`workflow_step_id`),
  ADD KEY `ix_ta_tx_req` (`transaction_id`,`requirement_definition_id`),
  ADD KEY `ix_ta_run` (`step_run_id`),
  ADD KEY `fk_ta_step` (`workflow_step_id`),
  ADD KEY `fk_ta_reqdef` (`requirement_definition_id`),
  ADD KEY `fk_ta_user` (`uploaded_by`);

--
-- Indexes for table `transaction_checklist_checks`
--
ALTER TABLE `transaction_checklist_checks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tcc_tx_step_item` (`transaction_id`,`workflow_step_id`,`checklist_override_id`),
  ADD KEY `fk_tcc_step` (`workflow_step_id`),
  ADD KEY `fk_tcc_item` (`checklist_override_id`),
  ADD KEY `fk_tcc_user` (`checked_by`);

--
-- Indexes for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_trc_tx_step_req` (`transaction_id`,`workflow_step_id`,`requirement_definition_id`),
  ADD KEY `fk_trc_step` (`workflow_step_id`),
  ADD KEY `fk_trc_reqdef` (`requirement_definition_id`),
  ADD KEY `fk_trc_user` (`checked_by`);

--
-- Indexes for table `transaction_states`
--
ALTER TABLE `transaction_states`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_states_transaction_id_unique` (`transaction_id`),
  ADD KEY `transaction_states_current_step_id_foreign` (`current_step_id`);

--
-- Indexes for table `transaction_station_touches`
--
ALTER TABLE `transaction_station_touches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tst_tx_step` (`transaction_id`,`workflow_step_id`),
  ADD KEY `fk_tst_step` (`workflow_step_id`),
  ADD KEY `fk_tst_user` (`touched_by`);

--
-- Indexes for table `transaction_step_data`
--
ALTER TABLE `transaction_step_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_run_stepdata` (`transaction_step_run_id`,`workflow_step_data_id`),
  ADD KEY `transaction_step_data_workflow_step_data_id_foreign` (`workflow_step_data_id`),
  ADD KEY `transaction_step_data_workflow_step_id_foreign` (`workflow_step_id`),
  ADD KEY `transaction_step_data_entered_by_foreign` (`entered_by`),
  ADD KEY `idx_tx_stepdata_tx_step` (`transaction_id`,`workflow_step_id`);

--
-- Indexes for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_step_runs_from_step_id_foreign` (`from_step_id`),
  ADD KEY `transaction_step_runs_to_step_id_foreign` (`to_step_id`),
  ADD KEY `transaction_step_runs_performed_by_foreign` (`performed_by`),
  ADD KEY `transaction_step_runs_transaction_id_performed_at_index` (`transaction_id`,`performed_at`),
  ADD KEY `transaction_step_runs_received_by_foreign` (`received_by`),
  ADD KEY `transaction_step_runs_received_office_id_foreign` (`received_office_id`),
  ADD KEY `transaction_step_runs_transaction_id_received_at_index` (`transaction_id`,`received_at`),
  ADD KEY `transaction_step_runs_to_step_id_received_at_index` (`to_step_id`,`received_at`);

--
-- Indexes for table `transaction_types`
--
ALTER TABLE `transaction_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_types_code_unique` (`code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_office_id_foreign` (`office_id`);

--
-- Indexes for table `workflow_definitions`
--
ALTER TABLE `workflow_definitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `workflow_definitions_transaction_type_id_version_unique` (`transaction_type_id`,`version`),
  ADD KEY `workflow_definitions_published_by_foreign` (`published_by`),
  ADD KEY `workflow_definitions_transaction_type_id_status_index` (`transaction_type_id`,`status`);

--
-- Indexes for table `workflow_routes`
--
ALTER TABLE `workflow_routes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `workflow_routes_from_step_id_foreign` (`from_step_id`),
  ADD KEY `workflow_routes_to_step_id_foreign` (`to_step_id`),
  ADD KEY `workflow_routes_workflow_definition_id_action_code_index` (`workflow_definition_id`,`action_code`);

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
-- Indexes for table `workflow_step_data`
--
ALTER TABLE `workflow_step_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `workflow_step_data_workflow_step_id_code_unique` (`workflow_step_id`,`code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
<<<<<<<< HEAD:transaction.sql(20).sql
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;
========
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;
>>>>>>>> versioncontrolcache:oct 5.sql

--
-- AUTO_INCREMENT for table `checklist_overrides`
--
ALTER TABLE `checklist_overrides`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `field_definitions`
--
ALTER TABLE `field_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `field_definition_workflow_step`
--
ALTER TABLE `field_definition_workflow_step`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `field_values`
--
ALTER TABLE `field_values`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `government_references`
--
ALTER TABLE `government_references`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `offices`
--
ALTER TABLE `offices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `office_steps`
--
ALTER TABLE `office_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `office_transaction_type`
--
ALTER TABLE `office_transaction_type`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `requirement_definitions`
--
ALTER TABLE `requirement_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `step_requirements`
--
ALTER TABLE `step_requirements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `step_roles`
--
ALTER TABLE `step_roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=413;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `transaction_attachments`
--
ALTER TABLE `transaction_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `transaction_checklist_checks`
--
ALTER TABLE `transaction_checklist_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT for table `transaction_states`
--
ALTER TABLE `transaction_states`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `transaction_station_touches`
--
ALTER TABLE `transaction_station_touches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaction_step_data`
--
ALTER TABLE `transaction_step_data`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT for table `transaction_types`
--
ALTER TABLE `transaction_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `workflow_definitions`
--
ALTER TABLE `workflow_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `workflow_routes`
--
ALTER TABLE `workflow_routes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;

--
-- AUTO_INCREMENT for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=424;

--
-- AUTO_INCREMENT for table `workflow_step_data`
--
ALTER TABLE `workflow_step_data`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_actor_user_id_foreign` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `checklist_overrides`
--
ALTER TABLE `checklist_overrides`
  ADD CONSTRAINT `fk_chk_reqdef` FOREIGN KEY (`requirement_definition_id`) REFERENCES `requirement_definitions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_chk_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `field_definitions`
--
ALTER TABLE `field_definitions`
  ADD CONSTRAINT `field_definitions_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `field_definition_workflow_step`
--
ALTER TABLE `field_definition_workflow_step`
  ADD CONSTRAINT `field_definition_workflow_step_field_definition_id_foreign` FOREIGN KEY (`field_definition_id`) REFERENCES `field_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `field_definition_workflow_step_workflow_step_id_foreign` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `field_values`
--
ALTER TABLE `field_values`
  ADD CONSTRAINT `field_values_field_definition_id_foreign` FOREIGN KEY (`field_definition_id`) REFERENCES `field_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `field_values_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `field_values_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `office_steps`
--
ALTER TABLE `office_steps`
  ADD CONSTRAINT `office_steps_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `office_steps_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `office_steps` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `office_transaction_type`
--
ALTER TABLE `office_transaction_type`
  ADD CONSTRAINT `office_transaction_type_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `office_transaction_type_transaction_type_id_foreign` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `requirement_definitions`
--
ALTER TABLE `requirement_definitions`
  ADD CONSTRAINT `fk_reqdef_wf` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `step_requirements`
--
ALTER TABLE `step_requirements`
  ADD CONSTRAINT `fk_sr_reqdef` FOREIGN KEY (`requirement_definition_id`) REFERENCES `requirement_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sr_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `step_roles`
--
ALTER TABLE `step_roles`
  ADD CONSTRAINT `step_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `step_roles_workflow_step_id_foreign` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_transaction_type_id_foreign` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_attachments`
--
ALTER TABLE `transaction_attachments`
  ADD CONSTRAINT `fk_ta_reqdef` FOREIGN KEY (`requirement_definition_id`) REFERENCES `requirement_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ta_run` FOREIGN KEY (`step_run_id`) REFERENCES `transaction_step_runs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ta_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ta_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ta_user` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_checklist_checks`
--
ALTER TABLE `transaction_checklist_checks`
  ADD CONSTRAINT `fk_tcc_item` FOREIGN KEY (`checklist_override_id`) REFERENCES `checklist_overrides` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_tcc_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tcc_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tcc_user` FOREIGN KEY (`checked_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  ADD CONSTRAINT `fk_trc_reqdef` FOREIGN KEY (`requirement_definition_id`) REFERENCES `requirement_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_trc_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_trc_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_trc_user` FOREIGN KEY (`checked_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_states`
--
ALTER TABLE `transaction_states`
  ADD CONSTRAINT `transaction_states_current_step_id_foreign` FOREIGN KEY (`current_step_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `transaction_states_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_station_touches`
--
ALTER TABLE `transaction_station_touches`
  ADD CONSTRAINT `fk_tst_step` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tst_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tst_user` FOREIGN KEY (`touched_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_step_data`
--
ALTER TABLE `transaction_step_data`
  ADD CONSTRAINT `transaction_step_data_entered_by_foreign` FOREIGN KEY (`entered_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_step_data_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_step_data_transaction_step_run_id_foreign` FOREIGN KEY (`transaction_step_run_id`) REFERENCES `transaction_step_runs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_step_data_workflow_step_data_id_foreign` FOREIGN KEY (`workflow_step_data_id`) REFERENCES `workflow_step_data` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_step_data_workflow_step_id_foreign` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  ADD CONSTRAINT `transaction_step_runs_from_step_id_foreign` FOREIGN KEY (`from_step_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `transaction_step_runs_performed_by_foreign` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_step_runs_received_by_foreign` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_step_runs_received_office_id_foreign` FOREIGN KEY (`received_office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_step_runs_to_step_id_foreign` FOREIGN KEY (`to_step_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `transaction_step_runs_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `workflow_definitions`
--
ALTER TABLE `workflow_definitions`
  ADD CONSTRAINT `workflow_definitions_published_by_foreign` FOREIGN KEY (`published_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_definitions_transaction_type_id_foreign` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `workflow_routes`
--
ALTER TABLE `workflow_routes`
  ADD CONSTRAINT `workflow_routes_from_step_id_foreign` FOREIGN KEY (`from_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `workflow_routes_to_step_id_foreign` FOREIGN KEY (`to_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `workflow_routes_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  ADD CONSTRAINT `workflow_steps_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_steps_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `workflow_steps` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_steps_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `workflow_step_data`
--
ALTER TABLE `workflow_step_data`
  ADD CONSTRAINT `workflow_step_data_workflow_step_id_foreign` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
