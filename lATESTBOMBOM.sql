-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260914.9e4dc5b5f4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 09, 2026 at 12:43 AM
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
-- Table structure for table `audit_logs`
--
CREATE TABLE `audit_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `actor_user_id` bigint UNSIGNED DEFAULT NULL,
  `event` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` bigint UNSIGNED DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`) VALUES
(1, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 3, '{\"payload\": {\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": true, \"description\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-09 15:44:35'),
(2, 1, 'users.update', 'App\\Models\\User', 1, '{\"after\": {\"name\": \"Vince\", \"email\": \"vinzmuloc@gmail.com\", \"role_ids\": [1], \"is_active\": true}, \"before\": {\"name\": \"Super Admin\", \"email\": \"vinzmuloc@gmail.com\", \"role_ids\": [1], \"is_active\": true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-09 10:26:21'),
(3, 1, 'users.create', 'App\\Models\\User', 10, '{\"payload\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [5], \"is_active\": true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-10 13:08:36'),
(4, 1, 'offices.create', 'App\\Models\\Office', 9, '{\"payload\": {\"code\": \"csd\", \"name\": \"Computer Services Division\", \"is_active\": true, \"description\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 10:24:12'),
(5, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 1, '{\"payload\": {\"code\": \"csd_1\", \"name\": \"Acknowledged\", \"is_active\": true, \"description\": null, \"order_number\": 1}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 10:33:19'),
(6, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 2, '{\"payload\": {\"code\": \"csd_2\", \"name\": \"Processed\", \"is_active\": true, \"description\": null, \"order_number\": 2}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 10:33:38'),
(7, 1, 'office_steps.create', 'App\\Models\\OfficeStep', 3, '{\"payload\": {\"code\": \"csd_3\", \"name\": \"Completed\", \"is_active\": true, \"description\": null, \"order_number\": 3}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 10:33:46'),
(8, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 1, '{\"after\": {\"office_id\": 9}, \"before\": {\"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 11:04:59'),
(9, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 1, '{\"after\": {\"office_id\": null}, \"before\": {\"office_id\": 9}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 11:05:01'),
(10, 1, 'transactions.reassign_office', 'App\\Models\\Transaction', 5, '{\"after\": {\"office_id\": 9}, \"before\": {\"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-11 11:05:07'),
(11, 1, 'users.update', 'App\\Models\\User', 10, '{\"after\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [4], \"is_active\": true, \"office_id\": null}, \"before\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [5], \"is_active\": true, \"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-13 13:07:53'),
(12, 1, 'users.update', 'App\\Models\\User', 10, '{\"after\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [6], \"is_active\": true, \"office_id\": null}, \"before\": {\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [4], \"is_active\": true, \"office_id\": null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-13 13:08:45'),
(13, 1, 'transactions.delete', 'App\\Models\\Transaction', 1, '{\"reference_number\":\"JFCW-GO9W-DM6Q\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:31:38'),
(14, 1, 'transactions.delete', 'App\\Models\\Transaction', 2, '{\"reference_number\":\"UTST-CZUL-F55O\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:31:42'),
(15, 1, 'transactions.delete', 'App\\Models\\Transaction', 3, '{\"reference_number\":\"TSYP-YHTP-JNWK\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:31:46'),
(16, 1, 'transactions.delete', 'App\\Models\\Transaction', 4, '{\"reference_number\":\"7ERC-ULBD-0AV1\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:31:50'),
(17, 1, 'transactions.delete', 'App\\Models\\Transaction', 5, '{\"reference_number\":\"GCHJ-9XQD-CV59\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:31:54'),
(18, 1, 'transactions.delete', 'App\\Models\\Transaction', 10, '{\"reference_number\":\"CC5T-ZXED-JAFX\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-15 11:32:01'),
(19, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 1, '{\"before\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true},\"after\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 09:10:42'),
(20, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 1, '{\"before\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"LGU payroll processing\",\"is_active\":true},\"after\":{\"code\":\"payroll\",\"name\":\"Payroll\",\"description\":\"job order\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 09:11:37'),
(21, 1, 'transactions.finalize', 'App\\Models\\Transaction', 16, '{\"reference_number\":\"Z5UP-ADG3-47IT\",\"current_step_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-21 15:47:33'),
(22, 1, 'transactions.finalize', 'App\\Models\\Transaction', 15, '{\"reference_number\":\"VYIR-X6GM-MMXP\",\"current_step_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-21 15:48:27'),
(23, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 09:16:15'),
(24, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 8, '{\"payload\":{\"code\":\"it_procurement\",\"name\":\"IT Equipment Procurement\",\"description\":\"Procurement Process of IT Equipment\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 13:53:22'),
(25, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 8, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 14:55:12'),
(26, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 9, '{\"payload\":{\"code\":\"it_procurements\",\"name\":\"IT Equipment Procurement\",\"description\":\"It Equipment Procurement\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 14:56:33'),
(27, 1, 'roles.create', 'App\\Models\\Role', 14, '{\"payload\":{\"code\":\"clerk_receiving\",\"name\":\"Clerk Receiving\",\"description\":\"Receiving of documents\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 15:10:36'),
(28, 1, 'roles.update', 'App\\Models\\Role', 3, '{\"before\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"Processes assigned steps.\"},\"after\":{\"code\":\"clerk_releasing\",\"name\":\"Clerk Releasing\",\"description\":\"Release assigned steps.\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 15:11:19'),
(29, 1, 'roles.create', 'App\\Models\\Role', 15, '{\"payload\":{\"code\":\"clerk_procurement\",\"name\":\"Clerk Procurement\",\"description\":\"Clerk assigned in Procurement\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 15:12:12'),
(30, 1, 'roles.create', 'App\\Models\\Role', 16, '{\"payload\":{\"code\":\"staff_technical\",\"name\":\"Staff Technical\",\"description\":null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 15:14:57'),
(31, 1, 'transactions.finalize', 'App\\Models\\Transaction', 26, '{\"reference_number\":\"PBXC-UHD1-HBAJ\",\"current_step_id\":209}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 16:41:24'),
(32, 1, 'transactions.finalize', 'App\\Models\\Transaction', 28, '{\"reference_number\":\"3VZO-F8OG-28XK\",\"current_step_id\":74}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-25 17:05:30'),
(33, 1, 'transactions.delete', 'App\\Models\\Transaction', 9, '{\"reference_number\":\"K8JB-EEGG-36OC\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:16:49'),
(34, 1, 'transactions.delete', 'App\\Models\\Transaction', 11, '{\"reference_number\":\"4JNN-BZGT-BRYB\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:16:52'),
(35, 1, 'transactions.delete', 'App\\Models\\Transaction', 12, '{\"reference_number\":\"LUC2-ULOD-KIFH\",\"transaction_type_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:16:55'),
(36, 1, 'transactions.delete', 'App\\Models\\Transaction', 13, '{\"reference_number\":\"OWOB-BEOY-FW1M\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:16:59'),
(37, 1, 'transactions.delete', 'App\\Models\\Transaction', 14, '{\"reference_number\":\"HHZB-GGI6-RIQH\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:17:11'),
(38, 1, 'transactions.delete', 'App\\Models\\Transaction', 15, '{\"reference_number\":\"VYIR-X6GM-MMXP\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:17:14'),
(39, 1, 'transactions.delete', 'App\\Models\\Transaction', 16, '{\"reference_number\":\"Z5UP-ADG3-47IT\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:17:17'),
(40, 1, 'transactions.delete', 'App\\Models\\Transaction', 17, '{\"reference_number\":\"G6RW-ZX2H-UUMI\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:17:20'),
(41, 1, 'transactions.delete', 'App\\Models\\Transaction', 18, '{\"reference_number\":\"4YD8-5DKW-JCYT\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 14:17:23'),
(42, 1, 'offices.delete', 'App\\Models\\Office', 18, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 09:41:17'),
(43, 1, 'offices.delete', 'App\\Models\\Office', 6, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 09:41:27'),
(44, 1, 'offices.delete', 'App\\Models\\Office', 17, '{\"note\":\"Soft deleted office; members unassigned\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 09:41:40'),
(45, 1, 'offices.create', 'App\\Models\\Office', 25, '{\"payload\":{\"code\":\"legal\",\"name\":\"Legal Officce\",\"description\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 09:43:44'),
(46, 1, 'transactions.delete', 'App\\Models\\Transaction', 31, '{\"reference_number\":\"KYR2-A1PI-SK9P\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-28 13:29:47'),
(47, 1, 'transactions.delete', 'App\\Models\\Transaction', 19, '{\"reference_number\":\"M5JW-EMVY-6REJ\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:16'),
(48, 1, 'transactions.delete', 'App\\Models\\Transaction', 20, '{\"reference_number\":\"5PAV-VMC3-7KNX\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:19'),
(49, 1, 'transactions.delete', 'App\\Models\\Transaction', 21, '{\"reference_number\":\"WMMQ-TXQM-KHWO\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:22'),
(50, 1, 'transactions.delete', 'App\\Models\\Transaction', 22, '{\"reference_number\":\"YLAA-6XW4-FZOH\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:24'),
(51, 1, 'transactions.delete', 'App\\Models\\Transaction', 23, '{\"reference_number\":\"Q9TM-29EI-BD6H\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:27'),
(52, 1, 'transactions.delete', 'App\\Models\\Transaction', 26, '{\"reference_number\":\"PBXC-UHD1-HBAJ\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:34'),
(53, 1, 'transactions.delete', 'App\\Models\\Transaction', 25, '{\"reference_number\":\"LUG7-LNDC-PLJF\",\"transaction_type_id\":8}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:37'),
(54, 1, 'transactions.delete', 'App\\Models\\Transaction', 24, '{\"reference_number\":\"VMMR-UGLN-OTKG\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:44'),
(55, 1, 'transactions.delete', 'App\\Models\\Transaction', 27, '{\"reference_number\":\"GVMS-GIEX-GXSS\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:46'),
(56, 1, 'transactions.delete', 'App\\Models\\Transaction', 28, '{\"reference_number\":\"3VZO-F8OG-28XK\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 08:15:51'),
(57, 1, 'transactions.delete', 'App\\Models\\Transaction', 34, '{\"reference_number\":\"LOHR-3WAY-OUA1\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 15:29:08'),
(58, 1, 'transactions.delete', 'App\\Models\\Transaction', 33, '{\"reference_number\":\"OX84-PMLV-HER6\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 15:29:11'),
(59, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 10, '{\"payload\":{\"code\":\"wadawd\",\"name\":\"2q21232\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 15:31:04'),
(60, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 10, '{\"before\":{\"code\":\"wadawd\",\"name\":\"2q21232\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]},\"after\":{\"code\":\"wadawd\",\"name\":\"2q21232-aa\",\"description\":\"awadawd\",\"is_active\":true,\"office_ids\":[25]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 15:32:35'),
(61, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 10, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 15:39:29'),
(62, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 9, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:29:17'),
(63, 1, 'transaction_types.create', 'App\\Models\\TransactionType', 11, '{\"payload\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[24]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:30:22'),
(64, 1, 'offices.create', 'App\\Models\\Office', 26, '{\"payload\":{\"code\":\"paad\",\"name\":\"Procurement Acquisition and Awards Division\",\"description\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:41:30'),
(65, 1, 'transactions.delete', 'App\\Models\\Transaction', 36, '{\"reference_number\":\"CRVI-X0P1-WSOM\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 16:58:22'),
(66, 1, 'transactions.delete', 'App\\Models\\Transaction', 37, '{\"reference_number\":\"2BEY-TTBW-NPT7\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 17:31:02'),
(67, 1, 'transactions.finalize', 'App\\Models\\Transaction', 38, '{\"reference_number\":\"BNWR-79LJ-VBVP\",\"current_step_id\":399}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-29 17:44:39'),
(68, 1, 'transactions.delete', 'App\\Models\\Transaction', 29, '{\"reference_number\":\"LKFA-RUF3-OIWT\",\"transaction_type_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 08:08:49'),
(69, 1, 'transactions.delete', 'App\\Models\\Transaction', 30, '{\"reference_number\":\"POYT-3B32-0Y8P\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 08:08:53'),
(70, 1, 'transactions.delete', 'App\\Models\\Transaction', 32, '{\"reference_number\":\"ROQO-Z1YN-DW1W\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 08:08:57'),
(71, 1, 'transactions.delete', 'App\\Models\\Transaction', 35, '{\"reference_number\":\"EIWE-HTYG-FUJ8\",\"transaction_type_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 08:09:00'),
(72, 1, 'transactions.delete', 'App\\Models\\Transaction', 38, '{\"reference_number\":\"BNWR-79LJ-VBVP\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 08:09:04'),
(73, 1, 'transactions.delete', 'App\\Models\\Transaction', 39, '{\"reference_number\":\"MWY6-RWFW-BF41\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-30 09:07:23'),
(74, 1, 'workflow_definitions.delete_draft', 'App\\Models\\WorkflowDefinition', 6, '{\"deleted\":{\"transaction_type_id\":2,\"version\":2,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 12:16:32'),
(75, 1, 'workflow_definitions.delete_draft', 'App\\Models\\WorkflowDefinition', 18, '{\"deleted\":{\"transaction_type_id\":3,\"version\":5,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 12:16:32'),
(76, 1, 'workflow_definitions.save_as', 'App\\Models\\WorkflowDefinition', 62, '{\"source_id\":62,\"source_version\":5,\"to_version\":5,\"name\":\"Bryan\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:32:13'),
(77, 1, 'workflow_definitions.save_as', 'App\\Models\\WorkflowDefinition', 64, '{\"source_id\":63,\"source_version\":6,\"to_version\":7,\"name\":\"bry\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:33:37'),
(78, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 16, '{\"from_version\":7,\"from_id\":64,\"to_version\":4,\"to_id\":16}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:33:50'),
(79, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":4,\"from_id\":16,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:34:10'),
(80, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 64, '{\"from_version\":5,\"from_id\":62,\"to_version\":7,\"to_id\":64}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 09:02:13'),
(81, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":7,\"from_id\":64,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 09:02:19'),
(82, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 63, '{\"from_version\":5,\"from_id\":62,\"to_version\":6,\"to_id\":63}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:05:08'),
(83, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 62, '{\"from_version\":6,\"from_id\":63,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:05:57'),
(84, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:28:19'),
(85, 1, 'users.update', 'App\\Models\\User', 10, '{\"before\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[6]},\"after\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-15 17:04:10'),
(86, 1, 'users.update', 'App\\Models\\User', 10, '{\"before\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"user@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-16 10:14:17'),
(87, 1, 'transactions.delete', 'App\\Models\\Transaction', 49, '{\"reference_number\":\"PVP2-D4DX-DEB9\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-19 10:25:23'),
(92, 1, 'roles.delete', 'App\\Models\\Role', 3, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:47:58'),
(93, 1, 'roles.delete', 'App\\Models\\Role', 4, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:01'),
(94, 1, 'roles.delete', 'App\\Models\\Role', 7, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:05'),
(95, 1, 'roles.delete', 'App\\Models\\Role', 8, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:09'),
(96, 1, 'roles.delete', 'App\\Models\\Role', 9, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:37'),
(97, 1, 'roles.delete', 'App\\Models\\Role', 10, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:41'),
(98, 1, 'roles.delete', 'App\\Models\\Role', 11, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:43'),
(99, 1, 'roles.delete', 'App\\Models\\Role', 12, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:44'),
(100, 1, 'roles.delete', 'App\\Models\\Role', 13, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:47'),
(101, 1, 'roles.delete', 'App\\Models\\Role', 14, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:49'),
(102, 1, 'roles.delete', 'App\\Models\\Role', 15, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:50'),
(103, 1, 'roles.delete', 'App\\Models\\Role', 16, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:52'),
(104, 1, 'roles.create', 'App\\Models\\Role', 17, '{\"payload\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:03:27'),
(106, 1, 'roles.delete', 'App\\Models\\Role', 14, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:15:39'),
(107, 1, 'roles.delete', 'App\\Models\\Role', 4, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:18:43'),
(108, 1, 'roles.update', 'App\\Models\\Role', 17, '{\"before\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"},\"after\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document\\/s)\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:20:55'),
(109, 1, 'users.update', 'App\\Models\\User', 10, '{\"before\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"user@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:14'),
(110, 1, 'users.update', 'App\\Models\\User', 10, '{\"before\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:30'),
(111, 1, 'users.deactivate', 'App\\Models\\User', 32, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:41'),
(112, 1, 'users.deactivate', 'App\\Models\\User', 31, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:42'),
(113, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:56'),
(114, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:59'),
(115, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:02'),
(116, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:04'),
(117, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:06'),
(118, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:08'),
(119, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:09'),
(120, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:11'),
(121, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:12'),
(122, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:14'),
(123, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:15'),
(124, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:17'),
(125, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:18'),
(126, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:20'),
(127, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:21'),
(128, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:24'),
(129, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:25'),
(130, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:27'),
(131, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:28'),
(132, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:30'),
(133, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:31'),
(134, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:33'),
(135, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:34'),
(136, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:36'),
(137, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:37'),
(138, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:39'),
(139, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:40'),
(140, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:42'),
(141, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:43'),
(142, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:45'),
(143, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:47'),
(144, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:49'),
(145, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:50'),
(146, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:52'),
(147, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:54'),
(148, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:56'),
(149, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:57'),
(150, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:59'),
(151, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:01'),
(152, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:03'),
(153, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:04'),
(154, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:06'),
(155, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:08'),
(156, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:09'),
(157, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:11'),
(158, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:12'),
(159, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:15'),
(160, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:18'),
(161, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:20'),
(162, 1, 'users.deactivate', 'App\\Models\\User', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:23'),
(163, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 67, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":3,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":2,\"routes_deleted\":1,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-20 09:54:11'),
(164, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 68, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:28:34'),
(165, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 69, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:29:30'),
(166, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 70, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:33:14'),
(167, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 71, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:36:16'),
(168, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 72, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:40:11'),
(169, 1, 'transaction_types.delete', 'App\\Models\\TransactionType', 2, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:20:38'),
(170, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 11, '{\"before\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[24]},\"after\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:20:53'),
(171, 1, 'transactions.delete', 'App\\Models\\Transaction', 58, '{\"reference_number\":\"WPXD-SJ3M-5TPV\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:24:03');
INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`) VALUES
(172, 1, 'transactions.delete', 'App\\Models\\Transaction', 57, '{\"reference_number\":\"GXBX-Q8AB-NTE8\",\"transaction_type_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:24:05'),
(173, 1, 'transactions.delete', 'App\\Models\\Transaction', 56, '{\"reference_number\":\"DZHW-VDG3-DV7C\",\"transaction_type_id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:24:08'),
(174, NULL, 'users.register', 'App\\Models\\User', 60, '{\"payload\":{\"name\":\"Bryan Martin Wee\",\"email\":\"charls.inoferio@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 14:30:22'),
(175, NULL, 'users.register', 'App\\Models\\User', 61, '{\"payload\":{\"name\":\"Claude Test Signup 1\",\"email\":\"claude.test.signup1@example.com\",\"office_id\":8,\"role_ids\":[17]}}', '127.0.0.1', 'curl/8.21.0', '2026-10-21 14:39:42'),
(176, NULL, 'users.register', 'App\\Models\\User', 62, '{\"payload\":{\"name\":\"Claude Test Signup 2\",\"email\":\"claude.test.signup2@example.com\",\"office_id\":8,\"role_ids\":[17]}}', '127.0.0.1', 'curl/8.21.0', '2026-10-21 14:39:44'),
(177, 1, 'users.approve', 'App\\Models\\User', 61, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-21 14:40:07'),
(178, 1, 'users.reject', 'App\\Models\\User', 62, '{\"payload\":{\"email\":\"claude.test.signup2@example.com\",\"name\":\"Claude Test Signup 2\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-21 14:40:10'),
(179, 1, 'users.reject', 'App\\Models\\User', 60, '{\"payload\":{\"email\":\"charls.inoferio@gmail.com\",\"name\":\"Bryan Martin Wee\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 15:25:21'),
(180, 59, 'profile.update', 'App\\Models\\User', 59, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-22 14:45:33'),
(181, 59, 'profile.update', 'App\\Models\\User', 59, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-22 14:45:36'),
(182, 2, 'profile.password', 'App\\Models\\User', 2, '[]', '127.0.0.1', 'curl/8.21.0', '2026-10-22 14:46:33'),
(183, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 73, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":1}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-25 12:18:39'),
(184, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 74, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-26 08:53:01'),
(185, 1, 'offices.update', 'App\\Models\\Office', 24, '{\"before\":{\"code\":\"CSD\",\"name\":\"Computer Service Division\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CSD\",\"name\":\"Computer Service Division\",\"description\":null,\"icon_path\":\"offices\\/icons\\/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-26 09:29:02'),
(186, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 75, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":3,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":2,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:08:11'),
(187, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 76, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:08:26'),
(188, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 77, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:09:57'),
(189, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 78, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:04'),
(190, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 79, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:15'),
(191, 1, 'workflow_definitions.apply_staged', 'App\\Models\\WorkflowDefinition', 80, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:26'),
(192, 1, 'users.deactivate', 'App\\Models\\User', 40, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:52:22'),
(193, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarros\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:56:42'),
(194, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarros\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:27'),
(195, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[2,17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:37'),
(196, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[2,17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:41'),
(197, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":9,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:48'),
(198, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":9,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":24,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:55'),
(199, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":24,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 19:00:04'),
(200, 1, 'users.update', 'App\\Models\\User', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":true,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 19:00:08'),
(201, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMOS\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:53:23'),
(202, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMOS\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:53:32'),
(203, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Offices\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:06'),
(204, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Offices\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:14'),
(205, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":\"wadawd\",\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:22'),
(206, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":\"wadawd\",\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:27'),
(207, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:29'),
(208, 1, 'offices.update', 'App\\Models\\Office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":false},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:30'),
(209, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 63, '{\"from_version\":5,\"from_id\":62,\"to_version\":6,\"to_id\":63}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:58:33'),
(210, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:58:57'),
(211, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:59:04'),
(212, 1, 'workflow_definitions.make_live', 'App\\Models\\WorkflowDefinition', 64, '{\"from_version\":6,\"from_id\":63,\"to_version\":7,\"to_id\":64}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:59:20'),
(213, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communications\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 23:15:45'),
(214, 1, 'transaction_types.update', 'App\\Models\\TransactionType', 3, '{\"before\":{\"code\":\"communications\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 23:15:49'),
(215, 1, 'transactions.archive', 'App\\Models\\Transaction', 66, '{\"was_done\":false,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 22:48:59'),
(216, 1, 'transactions.unarchive', 'App\\Models\\Transaction', 66, '{\"note\":\"Restored to the active transaction lists; record and history unchanged.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:09:28'),
(217, 1, 'transactions.archive', 'App\\Models\\Transaction', 66, '{\"was_done\":false,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:10:10'),
(218, 1, 'transactions.finalize', 'App\\Models\\Transaction', 65, '{\"reference_number\":\"JZJO-GQWY-CMD5\",\"current_step_id\":500}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:22:33'),
(219, 1, 'transactions.finalize', 'App\\Models\\Transaction', 53, '{\"reference_number\":\"WJVR-4V6U-2ZRT\",\"current_step_id\":74}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:23:08'),
(220, 1, 'transactions.archive', 'App\\Models\\Transaction', 65, '{\"was_done\":true,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:23:23'),
(221, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:41:00'),
(222, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:41:02'),
(223, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:39'),
(224, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:53'),
(225, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:57'),
(226, 1, 'transactions.privacy', 'App\\Models\\Transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:45:01'),
(227, 1, 'transactions.privacy', 'App\\Models\\Transaction', 67, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:47:06'),
(228, 1, 'transactions.privacy', 'App\\Models\\Transaction', 67, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:52:39'),
(229, NULL, 'users.register', 'App\\Models\\User', 63, '{\"payload\":{\"name\":\"juan\",\"username\":\"wadwad\",\"email\":\"AWDJAWJKDN@GMAIL.OCCM\",\"office_id\":9,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:56:24'),
(230, NULL, 'users.register', 'App\\Models\\User', 64, '{\"payload\":{\"name\":\"Juan dila\",\"username\":\"dela\",\"email\":\"juandela@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:33:43'),
(231, 1, 'users.approve', 'App\\Models\\User', 64, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:46:24'),
(232, NULL, 'users.register', 'App\\Models\\User', 65, '{\"payload\":{\"name\":\"newcsd\",\"username\":\"newcsd\",\"email\":\"newcsd@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:51:41'),
(233, 1, 'users.reject', 'App\\Models\\User', 65, '{\"payload\":{\"email\":\"newcsd@gmail.com\",\"name\":\"newcsd\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 17:01:00'),
(234, 1, 'transactions.privacy', 'App\\Models\\Transaction', 67, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 18:51:18'),
(235, 1, 'transactions.privacy', 'App\\Models\\Transaction', 67, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 18:51:19');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--
CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81', 'i:18;', 1793945092),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81:timer', 'i:1793945092;', 1793945092),
('transaction-cache-2bc272d56d27d905f34f73f9d47d9b5a', 'i:4;', 1793926309),
('transaction-cache-2bc272d56d27d905f34f73f9d47d9b5a:timer', 'i:1793926309;', 1793926309),
('transaction-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:2;', 1793926350),
('transaction-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1793926350;', 1793926350),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:1;', 1794184266),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1794184266;', 1794184266),
('transaction-cache-afa9674935f1748ea6188c8f2ec0ef3d', 'i:17;', 1793928621),
('transaction-cache-afa9674935f1748ea6188c8f2ec0ef3d:timer', 'i:1793928621;', 1793928621),
('transaction-cache-approvals:count:u1', 'a:2:{s:20:\"pending_requirements\";i:31;s:12:\"transactions\";i:14;}', 1794184822),
('transaction-cache-approvals:count:u10', 'a:2:{s:20:\"pending_requirements\";i:17;s:12:\"transactions\";i:8;}', 1793945093),
('transaction-cache-approvals:count:u59', 'a:2:{s:20:\"pending_requirements\";i:15;s:12:\"transactions\";i:7;}', 1793928621),
('transaction-cache-dash:summary:0927472b0f7644c158b4a1bb0ebfd322', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:14;s:7:\"overdue\";i:8;s:7:\"deleted\";i:39;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:10;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1794184405),
('transaction-cache-dash:summary:3a07ec706930a530e5e1306f212bbc57', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:6;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793949863),
('transaction-cache-dash:summary:62bbf0b8ef4b99d6b7eacf9747a69b04', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:12;s:7:\"overdue\";i:8;s:7:\"deleted\";i:18;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793949867),
('transaction-cache-dash:summary:8cdceaffa19f546b2a1a22082565ad9b', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:12;s:7:\"overdue\";i:8;s:7:\"deleted\";i:13;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793944744),
('transaction-cache-dash:summary:8f23063c690b99e2bd1f295c9299cc41', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:12;s:7:\"overdue\";i:8;s:7:\"deleted\";i:13;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793944742),
('transaction-cache-dash:summary:9a6a5cb7e8dd5a786133d9ad383b4ab9', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:2;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793946825),
('transaction-cache-dash:summary:a4c6eb1da3aa6fddcfe2b7151b48dfc1', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793944732),
('transaction-cache-dash:summary:aad51638e144cc138a67e20f7b264dad', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:12;s:7:\"overdue\";i:8;s:7:\"deleted\";i:12;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793946834),
('transaction-cache-dash:summary:ac1b38a62f595386cbe1bcdeee5aa6b9', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:15;s:7:\"overdue\";i:11;s:7:\"deleted\";i:12;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:6;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684731),
('transaction-cache-dash:summary:ad705782aee58eb7e8d3f7930be6042c', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:4;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793949862),
('transaction-cache-dash:summary:b7c27f85dca15bbe66495a34ad65ad20', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:15;s:7:\"overdue\";i:11;s:7:\"deleted\";i:12;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:6;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684785),
('transaction-cache-dash:summary:c0c25f6035995495076087e57a5239f4', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684713),
('transaction-cache-dash:summary:c28a8748367aa71bd5ee373fa43e0523', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:15;s:7:\"overdue\";i:11;s:7:\"deleted\";i:12;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:6;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684707),
('transaction-cache-dash:summary:c5fa1818163f5aaf514b717a7f9fa6dd', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684704),
('transaction-cache-dash:summary:c6bf6e5100ccbda7e2f4bfc51208d04a', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:12;s:7:\"overdue\";i:8;s:7:\"deleted\";i:15;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793945094),
('transaction-cache-dash:summary:c92ed520509a5dc987f113b6772c5614', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:9:\"this_week\";s:5:\"label\";s:21:\"This week (Nov 2–8)\";s:4:\"from\";s:25:\"2026-11-02T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-11-09T00:00:00+08:00\";}s:9:\"completed\";i:1;s:10:\"in_process\";i:1;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793942686),
('transaction-cache-dash:summary:ca3bf56330793a522b688a69ce2797d7', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684780),
('transaction-cache-dash:summary:de971551a3939c8efdfbec1c5c742a4d', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684774),
('transaction-cache-dash:summary:e9b3fbf010e8285c7f7879da48029b1d', 'a:6:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:15;s:7:\"overdue\";i:11;s:7:\"deleted\";i:12;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:6;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1793684705),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:4;', 1794184772),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1794184772;', 1794184772);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:offices', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:23:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-11-04 06:54:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-11-04 06:54:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"LEGAL\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-28 17:43:44\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"LEGAL\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-28 17:43:44\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:8;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:9;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:10;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:11;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:12;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:13;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:14;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:15;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:16;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:17;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:18;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:19;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:20;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:21;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:22;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1794184811);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:transaction-types:v4', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-09 23:44:35\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-11-04 07:15:49\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-09 23:44:35\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-11-04 07:15:49\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:13:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:3;s:15:\"pivot_office_id\";i:23;s:16:\"pivot_created_at\";s:19:\"2026-09-23 17:16:15\";s:16:\"pivot_updated_at\";s:19:\"2026-09-23 17:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-23 17:16:15\";s:10:\"updated_at\";s:19:\"2026-09-23 17:16:15\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-23 17:16:15\";s:10:\"updated_at\";s:19:\"2026-09-23 17:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:64;s:19:\"transaction_type_id\";i:3;s:7:\"version\";i:7;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:3:\"bry\";s:5:\"notes\";s:1:\"s\";s:12:\"published_at\";s:19:\"2026-09-30 20:33:37\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 20:33:36\";s:10:\"updated_at\";s:19:\"2026-11-04 06:59:20\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:64;s:19:\"transaction_type_id\";i:3;s:7:\"version\";i:7;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:3:\"bry\";s:5:\"notes\";s:1:\"s\";s:12:\"published_at\";s:19:\"2026-09-30 20:33:37\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 20:33:36\";s:10:\"updated_at\";s:19:\"2026-11-04 06:59:20\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:405;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:15:\"communication_1\";s:4:\"name\";s:23:\"Communication Station 1\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:405;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:15:\"communication_1\";s:4:\"name\";s:23:\"Communication Station 1\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:405;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:405;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:405;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:406;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:15:\"communication_2\";s:4:\"name\";s:25:\"Communication Station End\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:406;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:15:\"communication_2\";s:4:\"name\";s:25:\"Communication Station End\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:406;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:406;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:406;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:407;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:15:\"communication_3\";s:4:\"name\";s:3:\"bry\";s:5:\"stage\";N;s:9:\"office_id\";i:23;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:407;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:15:\"communication_3\";s:4:\"name\";s:3:\"bry\";s:5:\"stage\";N;s:9:\"office_id\";i:23;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:407;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:407;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:407;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-09 21:24:39\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-20 17:11:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-09 21:24:39\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-20 17:11:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";r:246;s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:80;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:9;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";N;s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-27 17:10:26\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:80;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:9;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";N;s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-27 17:10:26\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:498;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:11:\"collect_dtr\";s:4:\"name\";s:11:\"Collect DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:2880;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:498;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:11:\"collect_dtr\";s:4:\"name\";s:11:\"Collect DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:2880;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:6;s:4:\"code\";s:8:\"end_user\";s:4:\"name\";s:8:\"End User\";s:11:\"description\";s:34:\"Creates and forwards PR documents.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:6;s:4:\"code\";s:8:\"end_user\";s:4:\"name\";s:8:\"End User\";s:11:\"description\";s:34:\"Creates and forwards PR documents.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:498;s:13:\"pivot_role_id\";i:6;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:6;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:6;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:498;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:499;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:12:\"validate_dtr\";s:4:\"name\";s:12:\"Validate DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";i:4;s:11:\"sla_minutes\";i:2880;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:499;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:12:\"validate_dtr\";s:4:\"name\";s:12:\"Validate DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";i:4;s:11:\"sla_minutes\";i:2880;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:1;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:500;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:16:\"finalize_payroll\";s:4:\"name\";s:16:\"Finalize Payroll\";s:5:\"stage\";s:10:\"Accounting\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:4320;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:500;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:16:\"finalize_payroll\";s:4:\"name\";s:16:\"Finalize Payroll\";s:5:\"stage\";s:10:\"Accounting\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:4320;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:1;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:30:22\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-30 00:30:22\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:30:22\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-30 00:30:22\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";r:246;s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:74;s:19:\"transaction_type_id\";i:11;s:7:\"version\";i:18;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-26 16:53:01\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:74;s:19:\"transaction_type_id\";i:11;s:7:\"version\";i:18;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-26 16:53:01\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:8:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:475;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:26:\"procurement_it_equipment_1\";s:4:\"name\";s:16:\"Submit PR to GSO\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:0;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:475;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:26:\"procurement_it_equipment_1\";s:4:\"name\";s:16:\"Submit PR to GSO\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:0;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:475;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:475;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:475;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:476;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:26:\"procurement_it_equipment_2\";s:4:\"name\";s:33:\"GSO return approve PR to end user\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";i:8;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:476;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:26:\"procurement_it_equipment_2\";s:4:\"name\";s:33:\"GSO return approve PR to end user\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";i:8;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:476;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:476;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:476;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:477;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:26:\"procurement_it_equipment_3\";s:4:\"name\";s:16:\"Submit PR to OCT\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";i:5;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:477;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:26:\"procurement_it_equipment_3\";s:4:\"name\";s:16:\"Submit PR to OCT\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";i:5;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:477;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:477;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:477;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:478;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:4;s:4:\"code\";s:26:\"procurement_it_equipment_4\";s:4:\"name\";s:35:\"OCT  Return approve PR to  End user\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:478;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:4;s:4:\"code\";s:26:\"procurement_it_equipment_4\";s:4:\"name\";s:35:\"OCT  Return approve PR to  End user\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:478;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:478;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:478;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:479;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:5;s:4:\"code\";s:26:\"procurement_it_equipment_5\";s:4:\"name\";s:16:\"Submit PR to CBO\";s:5:\"stage\";s:29:\"Availability of Appropriation\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:479;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:5;s:4:\"code\";s:26:\"procurement_it_equipment_5\";s:4:\"name\";s:16:\"Submit PR to CBO\";s:5:\"stage\";s:29:\"Availability of Appropriation\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:479;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:479;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:480;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:6;s:4:\"code\";s:26:\"procurement_it_equipment_6\";s:4:\"name\";s:25:\"Submit Pr to Mayor Office\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:1;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:480;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:6;s:4:\"code\";s:26:\"procurement_it_equipment_6\";s:4:\"name\";s:25:\"Submit Pr to Mayor Office\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:1;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:480;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:480;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:481;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:7;s:4:\"code\";s:26:\"procurement_it_equipment_7\";s:4:\"name\";s:37:\"Mayor Office return approve PR to CBO\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:481;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:7;s:4:\"code\";s:26:\"procurement_it_equipment_7\";s:4:\"name\";s:37:\"Mayor Office return approve PR to CBO\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";r:3437;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:481;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:481;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:481;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:482;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:8;s:4:\"code\";s:26:\"procurement_it_equipment_8\";s:4:\"name\";s:17:\"Submit PR to PAAD\";s:5:\"stage\";s:13:\"PR submission\";s:9:\"office_id\";i:26;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:482;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:8;s:4:\"code\";s:26:\"procurement_it_equipment_8\";s:4:\"name\";s:17:\"Submit PR to PAAD\";s:5:\"stage\";s:13:\"PR submission\";s:9:\"office_id\";i:26;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:7:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:11:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:192:\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-10-19 23:20:55\";s:10:\"deleted_at\";N;s:22:\"pivot_workflow_step_id\";i:482;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:482;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:482;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:509;s:12:\"pivotRelated\";r:560;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:3:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1794184810);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-weather:zamboanga', 'a:5:{s:11:\"temperature\";d:29.7;s:4:\"code\";i:1;s:6:\"is_day\";i:1;s:4:\"time\";s:16:\"2026-11-09T08:15\";s:5:\"place\";s:14:\"Zamboanga City\";}', 1794185933);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--
CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `checklist_overrides`
--

INSERT INTO `checklist_overrides` (`id`, `workflow_step_id`, `requirement_definition_id`, `name`, `code`, `description`, `is_required`, `display_order`, `created_at`, `updated_at`) VALUES
(11, 40, 19, 'Uploaded to Google Drive', 'drive_uploaded', NULL, 1, 1, '2026-09-24 10:48:06', '2026-09-24 10:48:06'),
(12, 3, 28, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-09-24 10:48:06', '2026-09-24 10:48:06'),
(13, 71, 25, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-24 10:48:06', '2026-09-24 10:48:06'),
(14, 2, 27, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-09-24 10:54:17', '2026-09-24 10:54:17'),
(15, 2, 36, 'AR', 'ar', 'AR remarks', 1, 2, '2026-09-24 10:54:17', '2026-09-24 10:54:17'),
(16, 39, 23, 'Signed PR PDF attached', 'signed_pr_pdf', NULL, 1, 1, '2026-09-25 14:25:55', '2026-09-25 14:25:55'),
(17, 73, 30, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-09-25 17:02:03', '2026-09-25 17:02:03'),
(18, 73, 35, 'AR', 'ar', 'AR remarks', 0, 1, '2026-09-25 17:02:03', '2026-09-28 13:30:46'),
(19, 74, 31, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-09-25 17:05:21', '2026-09-25 17:05:21'),
(20, 73, 37, 'Payroll', 'payroll', NULL, 1, 2, '2026-09-28 13:30:46', '2026-09-28 13:30:46'),
(21, 73, 38, 'MedCert', 'medcert', NULL, 0, 3, '2026-09-28 13:35:07', '2026-09-28 13:35:07'),
(22, 74, 39, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-09-29 15:11:10', '2026-09-29 15:11:10'),
(23, 337, 43, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:55:14', '2026-09-29 16:55:14'),
(24, 337, 42, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:55:14', '2026-09-29 16:55:14'),
(25, 345, 46, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(26, 345, 45, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(27, 353, 48, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(28, 353, 47, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(29, 361, 50, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(30, 361, 49, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(31, 369, 52, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(32, 369, 51, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(33, 377, 54, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(34, 377, 53, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(35, 385, 56, 'PR', 'pr', NULL, 1, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(36, 385, 55, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(38, 386, 58, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-09-29 17:05:10', '2026-09-29 17:05:10'),
(39, 387, 59, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-09-29 17:06:06', '2026-09-29 17:06:06'),
(42, 389, 62, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-09-29 17:11:47', '2026-09-29 17:11:47'),
(43, 388, 64, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-09-29 17:13:11', '2026-09-29 17:13:11'),
(44, 390, 66, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-09-29 17:14:03', '2026-09-29 17:14:03'),
(45, 393, 74, 'PR', 'pr', NULL, 1, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(46, 393, 73, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(47, 394, 75, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(48, 395, 76, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(49, 396, 70, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(50, 397, 71, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(51, 398, 68, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(52, 399, 77, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-09-29 17:16:33', '2026-09-29 17:16:33'),
(53, 401, 80, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 12:31:59', '2026-09-30 12:31:59'),
(54, 403, 82, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 12:32:33', '2026-09-30 12:32:33'),
(55, 406, 84, 'Communication logged', 'comm_logged', 'Tick once the communication is received and logged.', 1, 1, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(56, 409, 95, 'PR', 'pr', NULL, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(57, 409, 92, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(58, 410, 96, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(59, 411, 97, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(60, 412, 89, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(61, 413, 90, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(62, 414, 87, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(63, 415, 93, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(64, 417, 107, 'PR', 'pr', NULL, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(65, 417, 104, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(66, 418, 108, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(67, 419, 109, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(68, 420, 101, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(69, 421, 102, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(70, 422, 99, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(71, 423, 105, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(72, 426, 113, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(73, 426, 111, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(74, 425, 112, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(75, 425, 110, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(76, 425, 115, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(77, 425, 114, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(78, 428, 126, 'PR', 'pr', NULL, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(79, 428, 123, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(80, 429, 127, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(81, 430, 128, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(82, 431, 120, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(83, 432, 121, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(84, 433, 118, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(85, 434, 124, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(86, 436, 138, 'PR', 'pr', NULL, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(87, 436, 135, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(88, 437, 139, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(89, 438, 140, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(90, 439, 132, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(91, 440, 133, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(92, 441, 130, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(93, 442, 136, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(94, 444, 150, 'PR', 'pr', NULL, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(95, 444, 147, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(96, 445, 151, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(97, 446, 152, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(98, 447, 144, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(99, 448, 145, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(100, 449, 142, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(101, 450, 148, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(102, 452, 162, 'PR', 'pr', NULL, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(103, 452, 159, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(104, 453, 163, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(105, 454, 164, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(106, 455, 156, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(107, 456, 157, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(108, 457, 154, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(109, 458, 160, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(110, 460, 174, 'PR', 'pr', NULL, 1, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(111, 460, 171, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(112, 461, 175, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(113, 462, 176, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(114, 463, 168, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(115, 464, 169, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(116, 465, 166, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(117, 466, 172, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-20 13:40:11', '2026-10-20 13:40:11'),
(118, 468, 186, 'PR', 'pr', NULL, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(119, 468, 183, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(120, 469, 187, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(121, 470, 188, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(122, 471, 180, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(123, 472, 181, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(124, 473, 178, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(125, 474, 184, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(126, 476, 198, 'PR', 'pr', NULL, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(127, 476, 195, 'Market Scanning', 'market_scan', NULL, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(128, 477, 199, 'PR with Number', 'pr_number', NULL, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(129, 478, 200, 'PR with number', 'pr_with_number', NULL, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(130, 479, 192, 'CTO approve PR', 'cto_app', NULL, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(131, 480, 193, 'CTO approved PR', 'cto_app_pr', NULL, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(132, 481, 190, 'CBO approve PR', 'cbo_app', NULL, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(133, 482, 196, 'Mayor Office Approve PR', 'mo_app_pr', NULL, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(134, 485, 204, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(135, 485, 202, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(136, 484, 203, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(137, 484, 201, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(138, 484, 206, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(139, 484, 205, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(140, 488, 211, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(141, 488, 209, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(142, 487, 210, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(143, 487, 208, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(144, 487, 213, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(145, 487, 212, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(146, 491, 218, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(147, 491, 216, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(148, 490, 217, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(149, 490, 215, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(150, 490, 220, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(151, 490, 219, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(152, 494, 225, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(153, 494, 223, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(154, 493, 224, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(155, 493, 222, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(156, 493, 227, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(157, 493, 226, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(158, 497, 232, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(159, 497, 230, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(160, 496, 231, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 0, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(161, 496, 229, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(162, 496, 234, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(163, 496, 233, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(164, 500, 239, 'DTR validated', 'dtr_validated', 'Tick once DTRs are validated.', 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(165, 500, 237, 'Birth Certificate', 'birth_certificate', NULL, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(166, 499, 238, 'DTR collected', 'dtr_collected', 'Tick once DTRs are collected.', 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(167, 499, 236, 'AR', 'ar', 'AR remarks', 0, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(168, 499, 241, 'Payroll', 'payroll', NULL, 1, 2, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(169, 499, 240, 'MedCert', 'medcert', NULL, 0, 3, '2026-10-27 09:10:26', '2026-10-27 09:10:26');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--
CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
(1, NULL, 1, 'pr_number', 'PR Number', 'text', NULL, 1, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, NULL, 2, 'request_title', 'Request Title', 'text', NULL, 2, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, NULL, 3, 'office_name', 'Office / Dept', 'text', NULL, 3, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, NULL, 4, 'request_amount', 'Amount', 'number', NULL, 4, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(5, NULL, 5, 'drive_link', 'Google Drive Link', 'text', NULL, 5, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(6, NULL, 6, 'dts_number', 'DTS Number', 'text', NULL, 6, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(7, NULL, 7, 'remarks', 'Remarks', 'textarea', NULL, 7, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL);

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
  `value_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `value_number` decimal(18,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `field_values`
--

INSERT INTO `field_values` (`id`, `transaction_id`, `field_definition_id`, `value_json`, `value_text`, `value_number`, `created_at`, `updated_at`, `updated_by`) VALUES
(1, 9, 2, '{\"value\": \"Almost\"}', 'Almost', NULL, '2026-09-13 11:36:55', '2026-09-13 11:36:55', 1),
(2, 9, 3, '{\"value\": \"Almost Office\"}', 'Almost Office', NULL, '2026-09-13 11:36:55', '2026-09-13 11:36:55', 1),
(3, 9, 4, '{\"value\": 500}', '500', NULL, '2026-09-13 11:36:55', '2026-09-13 11:36:55', 1),
(4, 9, 7, '{\"value\": \"ad\"}', 'ad', NULL, '2026-09-13 11:36:55', '2026-09-13 11:36:55', 1),
(5, 9, 5, '{\"value\": \"Minotaur.com\"}', 'Minotaur.com', NULL, '2026-09-13 12:46:56', '2026-09-13 12:46:56', 1),
(6, 9, 6, '{\"value\":\"34534534\"}', '34534534', NULL, '2026-09-20 09:05:15', '2026-09-20 09:05:15', 1),
(7, 17, 2, '{\"value\":\"3234234\"}', '3234234', NULL, '2026-09-20 11:30:52', '2026-09-20 11:30:52', 1),
(8, 17, 3, '{\"value\":\"234\"}', '234', NULL, '2026-09-20 11:30:52', '2026-09-20 11:30:52', 1),
(9, 17, 4, '{\"value\":3242}', '3242', NULL, '2026-09-20 11:30:52', '2026-09-20 11:30:52', 1),
(10, 17, 7, '{\"value\":\"23423\"}', '23423', NULL, '2026-09-20 11:30:52', '2026-09-20 11:30:52', 1),
(11, 17, 5, '{\"value\":\"67567567\"}', '67567567', NULL, '2026-09-20 11:32:50', '2026-09-20 11:32:50', 1),
(12, 18, 2, '{\"value\":\"3234234\"}', '3234234', NULL, '2026-09-21 09:18:56', '2026-09-21 09:18:56', 1),
(13, 18, 3, '{\"value\":\"234\"}', '234', NULL, '2026-09-21 09:18:56', '2026-09-21 09:18:56', 1),
(14, 18, 4, '{\"value\":1}', '1', NULL, '2026-09-21 09:18:56', '2026-09-21 09:18:56', 1),
(15, 18, 7, '{\"value\":null}', NULL, NULL, '2026-09-21 09:18:56', '2026-09-21 09:18:56', 1),
(16, 18, 5, '{\"value\":\"waffawfawfas\"}', 'waffawfawfas', NULL, '2026-09-21 09:21:46', '2026-09-21 11:29:48', 1),
(17, 18, 6, '{\"value\":\"awdawfaaawaa\"}', 'awdawfaaawaa', NULL, '2026-09-21 09:22:45', '2026-09-21 11:29:41', 1),
(18, 18, 1, '{\"value\":\"46\"}', '46', NULL, '2026-09-21 09:26:43', '2026-09-21 09:26:43', 1);

-- --------------------------------------------------------

--
-- Table structure for table `government_references`
--
CREATE TABLE `government_references` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `government_references`
--

INSERT INTO `government_references` (`id`, `code`, `title`, `source`, `url`, `notes`, `is_verified`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'RA-9184', 'Government Procurement Reform Act (placeholder record)', 'Republic Act', NULL, 'TO VERIFY — admin must encode official URL/sections. Do not hardcode legal text.', 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, 'IRR-RA-9184', 'IRR for RA 9184 (placeholder record)', 'IRR', NULL, 'TO VERIFY — admin must encode official URL/sections.', 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 'COA-CIRCULAR-TO-VERIFY', 'COA Circular (placeholder record)', 'COA', NULL, 'TO VERIFY — replace with exact COA circular code + official link.', 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, 'DBM-GUIDANCE-TO-VERIFY', 'DBM Guidance (placeholder record)', 'DBM', NULL, 'TO VERIFY — replace with exact DBM issuance + official link.', 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--
CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
(56, '2026_10_05_000002_create_transaction_step_data_table', 25),
(57, '2026_10_06_000001_add_label_to_transaction_attachments_table', 26),
(58, '2026_10_08_000001_add_source_to_transaction_attachments_table', 26),
(59, '2026_10_14_000001_add_flagged_items_to_transaction_step_runs_table', 27),
(60, '2026_10_20_000001_fix_contact_number_on_users_table', 28),
(61, '2026_10_20_000002_add_approval_to_users_table', 28),
(62, '2026_10_20_000001_add_is_end_user_to_workflow_steps_table', 29),
(64, '2026_10_21_000001_link_transaction_types_createdby_office', 30),
(65, '2026_10_22_000001_allow_clerk_on_every_workflow_step', 31),
(66, '2026_10_24_000001_uppercase_office_codes', 32),
(67, '2026_10_26_000001_add_icon_path_to_offices_table', 32),
(68, '2026_10_29_000001_add_username_to_users_table', 33),
(69, '2026_11_05_000001_add_is_archive_to_transactions_table', 34),
(70, '2026_11_05_000002_add_is_private_to_transactions_table', 35);

-- --------------------------------------------------------

--
-- Table structure for table `offices`
--
CREATE TABLE `offices` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icon_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `offices`
--

INSERT INTO `offices` (`id`, `code`, `name`, `description`, `icon_path`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'OCM', 'Office of the City Mayor', NULL, NULL, 1, NULL, NULL, NULL),
(2, 'OCA', 'Office of the City Administrator', NULL, NULL, 1, NULL, NULL, NULL),
(3, 'OCAC', 'Office of the City Accountant', NULL, NULL, 1, NULL, NULL, NULL),
(4, 'OCAS', 'Office of the City Assessor', NULL, NULL, 1, NULL, NULL, NULL),
(5, 'OCT', 'Office of the City Treasurer', NULL, NULL, 1, NULL, NULL, NULL),
(6, 'OCE', 'Office of the City Engineer', NULL, NULL, 1, NULL, '2026-09-28 09:41:27', '2026-09-28 09:41:27'),
(7, 'OCL', 'Office of the City Engineer', NULL, NULL, 1, NULL, NULL, NULL),
(8, 'GSO', 'General Service Office', NULL, NULL, 1, NULL, NULL, NULL),
(9, 'OCB', 'Office of the City Budget', NULL, NULL, 1, NULL, NULL, NULL),
(10, 'OCPD', 'Office of the City Planning and Development', NULL, NULL, 1, NULL, NULL, NULL),
(11, 'OCH', 'Office of the City Health', NULL, NULL, 1, NULL, NULL, NULL),
(12, 'OCSWD', 'Office of the City Social Welfare and Development', NULL, NULL, 1, NULL, NULL, NULL),
(13, 'OCV', 'Office of the City Veterinarian', NULL, NULL, 1, NULL, NULL, NULL),
(14, 'OCAG', 'Office of the City Agricultural', NULL, NULL, 1, NULL, NULL, NULL),
(15, 'OCCR', 'Office of the City Civil Registrar', NULL, NULL, 1, NULL, NULL, NULL),
(16, 'OCENR', 'Office of the City Environment and Natural Resources', NULL, NULL, 1, NULL, NULL, NULL),
(17, 'CCZ', 'Colegio De La Ciudad De Zamboanga', NULL, NULL, 1, NULL, '2026-09-28 09:41:40', '2026-09-28 09:41:40'),
(18, 'SSP', 'Secretary to the Sangguniang Panlungsod', NULL, NULL, 1, NULL, '2026-09-28 09:41:17', '2026-09-28 09:41:17'),
(19, 'SP', 'Sangguniang Panlungsod', NULL, NULL, 1, NULL, NULL, NULL),
(20, 'OCDRDM', 'Office of the City Disaster Risk Deduction Management', NULL, NULL, 1, NULL, NULL, NULL),
(21, 'CHRMO', 'City Human Resource Management Office', NULL, NULL, 1, NULL, '2026-11-03 22:54:30', NULL),
(22, 'GDS', 'CMO - Gender and Development Services (GAD)', NULL, NULL, 1, NULL, NULL, NULL),
(23, 'LEDIPS', 'Local Economic Development and Investment Promotion Services', NULL, NULL, 1, NULL, NULL, NULL),
(24, 'CSD', 'Computer Service Division', NULL, 'offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg', 1, NULL, '2026-10-26 09:29:02', NULL),
(25, 'LEGAL', 'Legal Officce', NULL, NULL, 1, '2026-09-28 09:43:44', '2026-10-25 09:16:44', NULL),
(26, 'PAAD', 'Procurement Acquisition and Awards Division', NULL, NULL, 1, '2026-09-29 16:41:30', '2026-10-25 09:16:44', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `office_steps`
--
CREATE TABLE `office_steps` (
  `id` bigint UNSIGNED NOT NULL,
  `office_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '1',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
(3, 23, 3, '2026-09-23 09:16:15', '2026-09-23 09:16:15'),
(5, 24, 9, '2026-09-25 14:56:33', '2026-09-25 14:56:33'),
(6, 25, 10, '2026-09-29 15:31:04', '2026-09-29 15:31:04');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--
CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requirement_definitions`
--

INSERT INTO `requirement_definitions` (`id`, `workflow_definition_id`, `order_number`, `code`, `name`, `label`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, 2, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 2, 3, 'dts_created', 'DTS created', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, 2, 4, 'pr_encoded', 'PR Number encoded', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(5, 2, 5, 'city_admin_signed', 'City Admin signed', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(6, 2, 6, 'treasurer_signed', 'Treasurer signed', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(7, 2, 7, 'doc_validated', 'Document validated (untampered)', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(8, 2, 8, 'earmark_completed', 'Earmark completed', NULL, NULL, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(17, 7, 5, 'city_admin_signed', 'City Admin signed', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(18, 7, 7, 'doc_validated', 'Document validated (untampered)', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(19, 7, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(20, 7, 3, 'dts_created', 'DTS created', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(21, 7, 8, 'earmark_completed', 'Earmark completed', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(22, 7, 4, 'pr_encoded', 'PR Number encoded', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(23, 7, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(24, 7, 6, 'treasurer_signed', 'Treasurer signed', NULL, NULL, 1, '2026-09-13 09:39:26', '2026-09-13 09:39:26', NULL),
(25, 16, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03', NULL),
(26, 16, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03', NULL),
(27, 1, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03', NULL),
(28, 1, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03', NULL),
(29, 1, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03', NULL),
(30, 17, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-09-13 16:53:40', '2026-09-28 13:35:09', NULL),
(31, 17, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-09-13 16:53:40', '2026-09-29 15:11:13', NULL),
(32, 17, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(35, 17, 0, 'ar', 'AR', 'AR', 'AR remarks', 1, '2026-09-22 10:27:31', '2026-09-28 13:35:09', NULL),
(36, 1, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-09-22 19:13:05', '2026-09-22 19:13:05', NULL),
(37, 17, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-09-28 13:30:45', '2026-09-28 13:35:09', NULL),
(38, 17, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-09-28 13:35:06', '2026-09-28 13:35:09', NULL),
(39, 17, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-09-29 15:11:09', '2026-09-29 15:11:13', NULL),
(40, 53, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:50:11', '2026-09-29 16:52:19', NULL),
(41, 53, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:52:17', '2026-09-29 16:52:19', NULL),
(42, 54, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(43, 54, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(44, 53, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-29 16:53:49', '2026-09-29 16:53:50', NULL),
(45, 55, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(46, 55, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(47, 56, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(48, 56, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(49, 57, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(50, 57, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(51, 58, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(52, 58, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(53, 59, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(54, 59, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(55, 60, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(56, 60, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(57, 60, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-29 17:03:51', '2026-09-29 17:03:52', NULL),
(58, 60, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-09-29 17:05:09', '2026-09-29 17:05:10', NULL),
(59, 60, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-09-29 17:06:05', '2026-09-29 17:06:06', NULL),
(60, 60, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-09-29 17:07:59', '2026-09-29 17:13:11', NULL),
(61, 60, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-09-29 17:08:31', '2026-09-29 17:11:47', NULL),
(62, 60, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-09-29 17:11:46', '2026-09-29 17:11:48', NULL),
(64, 60, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-09-29 17:13:10', '2026-09-29 17:13:14', NULL),
(66, 60, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-09-29 17:14:02', '2026-09-29 17:14:03', NULL),
(67, 61, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(68, 61, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(69, 61, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(70, 61, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(71, 61, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(72, 61, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(73, 61, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(74, 61, 0, 'pr', 'PR', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(75, 61, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(76, 61, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(77, 61, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-09-29 17:16:32', '2026-09-29 17:16:33', NULL),
(79, 61, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-09-29 17:23:00', '2026-09-29 17:23:00', NULL),
(80, 62, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(81, 62, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(82, 63, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 12:32:33', '2026-09-30 12:32:33', NULL),
(83, 63, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 12:32:33', '2026-09-30 12:32:33', NULL),
(84, 64, 1, 'comm_logged', 'Communication logged', NULL, 'Tick once the communication is received and logged.', 1, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(85, 64, 2, 'comm_released', 'Communication released', NULL, 'Tick once the communication is released at the end station.', 1, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(86, 65, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(87, 65, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(88, 65, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(89, 65, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(90, 65, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(91, 65, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(92, 65, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(93, 65, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(94, 65, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(95, 65, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(96, 65, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(97, 65, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(98, 66, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(99, 66, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(100, 66, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(101, 66, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(102, 66, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(103, 66, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(104, 66, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(105, 66, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(106, 66, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(107, 66, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(108, 66, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(109, 66, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(110, 67, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(111, 67, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(112, 67, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(113, 67, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(114, 67, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(115, 67, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(116, 67, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(117, 68, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(118, 68, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(119, 68, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(120, 68, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(121, 68, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(122, 68, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(123, 68, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(124, 68, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(125, 68, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(126, 68, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(127, 68, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(128, 68, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(129, 69, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(130, 69, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(131, 69, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(132, 69, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(133, 69, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(134, 69, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(135, 69, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(136, 69, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(137, 69, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(138, 69, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(139, 69, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(140, 69, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(141, 70, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(142, 70, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(143, 70, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(144, 70, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(145, 70, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(146, 70, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(147, 70, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(148, 70, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(149, 70, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(150, 70, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(151, 70, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(152, 70, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(153, 71, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(154, 71, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(155, 71, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(156, 71, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(157, 71, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(158, 71, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(159, 71, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(160, 71, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(161, 71, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(162, 71, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(163, 71, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(164, 71, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(165, 72, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(166, 72, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(167, 72, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(168, 72, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(169, 72, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(170, 72, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(171, 72, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(172, 72, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(173, 72, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(174, 72, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(175, 72, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(176, 72, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(177, 73, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(178, 73, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(179, 73, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(180, 73, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(181, 73, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(182, 73, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(183, 73, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(184, 73, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(185, 73, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(186, 73, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(187, 73, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(188, 73, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(189, 74, 0, 'approve_pr', 'Approved PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(190, 74, 0, 'cbo_app', 'CBO approve PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(191, 74, 0, 'cbo_app_pr', 'CBO approved PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(192, 74, 0, 'cto_app', 'CTO approve PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(193, 74, 0, 'cto_app_pr', 'CTO approved PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(194, 74, 0, 'gso_app_pr', 'GSO approved PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(195, 74, 0, 'market_scan', 'Market Scanning', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(196, 74, 0, 'mo_app_pr', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(197, 74, 0, 'mo_app_prs', 'Mayor Office Approve PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(198, 74, 0, 'pr', 'PR', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(199, 74, 0, 'pr_number', 'PR with Number', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(200, 74, 0, 'pr_with_number', 'PR with number', NULL, NULL, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(201, 75, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(202, 75, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(203, 75, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(204, 75, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(205, 75, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(206, 75, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(207, 75, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(208, 76, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(209, 76, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(210, 76, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(211, 76, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(212, 76, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(213, 76, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(214, 76, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(215, 77, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(216, 77, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(217, 77, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(218, 77, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(219, 77, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(220, 77, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(221, 77, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(222, 78, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(223, 78, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(224, 78, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(225, 78, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(226, 78, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(227, 78, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(228, 78, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(229, 79, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(230, 79, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(231, 79, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(232, 79, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(233, 79, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(234, 79, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(235, 79, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(236, 80, 0, 'ar', 'AR', NULL, 'AR remarks', 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(237, 80, 0, 'birth_certificate', 'Birth Certificate', NULL, NULL, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(238, 80, 1, 'dtr_collected', 'DTR collected', NULL, 'Tick once DTRs are collected.', 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(239, 80, 2, 'dtr_validated', 'DTR validated', NULL, 'Tick once DTRs are validated.', 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(240, 80, 0, 'medcert', 'MedCert', NULL, NULL, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(241, 80, 0, 'payroll', 'Payroll', NULL, NULL, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(242, 80, 3, 'payroll_finalized', 'Payroll finalized', NULL, 'Tick once payroll is finalized.', 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--
CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `code`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'superadmin', 'Super Admin', 'Full access (local-only).', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL),
(2, 'admin', 'Admin', 'Manages master data and workflows.', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL),
(3, 'clerk_releasing', 'Clerk Releasing', 'Release assigned steps.', '2026-03-09 13:24:36', '2026-10-19 14:47:58', '2026-10-19 14:47:58'),
(4, 'approver', 'Approver', 'Approves steps routed to them.', '2026-03-09 13:24:36', '2026-10-19 15:18:43', '2026-10-19 15:18:43'),
(5, 'viewer', 'Viewer', 'Read-only access.', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL),
(6, 'end_user', 'End User', 'Creates and forwards PR documents.', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL),
(7, 'gso', 'GSO', 'General Services Office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:05', '2026-10-19 14:48:05'),
(8, 'city_admin', 'City Administrator', 'Signs/approves as City Admin.', '2026-03-09 13:24:36', '2026-10-19 14:48:09', '2026-10-19 14:48:09'),
(9, 'cto', 'CTO', 'City Treasurer Office reviewer.', '2026-03-09 13:24:36', '2026-10-19 14:48:37', '2026-10-19 14:48:37'),
(10, 'city_treasurer', 'City Treasurer', 'Signs/approves as Treasurer.', '2026-03-09 13:24:36', '2026-10-19 14:48:41', '2026-10-19 14:48:41'),
(11, 'cadmin', 'CAdmin', 'City Admin office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:43', '2026-10-19 14:48:43'),
(12, 'cbo', 'CBO', 'City Budget Office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:44', '2026-10-19 14:48:44'),
(13, 'bac_paad', 'BAC-PAAD', 'Receives final submitted documents.', '2026-03-09 13:24:36', '2026-10-19 14:48:47', '2026-10-19 14:48:47'),
(14, 'clerk_receiving', 'Clerk Receiving', 'Receiving of documents', '2026-09-25 15:10:36', '2026-10-19 15:15:39', '2026-10-19 15:15:39'),
(15, 'clerk_procurement', 'Clerk Procurement', 'Clerk assigned in Procurement', '2026-09-25 15:12:12', '2026-10-19 14:48:50', '2026-10-19 14:48:50'),
(16, 'staff_technical', 'Staff Technical', NULL, '2026-09-25 15:14:57', '2026-10-19 14:48:52', '2026-10-19 14:48:52'),
(17, 'clerk', 'Clerk', 'A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)', '2026-10-19 15:03:27', '2026-10-19 15:20:55', NULL);

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
(1, 1, '2026-03-09 13:24:36', '2026-03-09 13:24:36'),
(2, 10, '2026-10-15 17:04:10', '2026-10-15 17:04:10'),
(5, 33, '2026-10-19 08:48:36', '2026-10-19 08:48:36'),
(6, 2, '2026-03-09 13:24:37', '2026-03-09 13:24:37'),
(17, 36, '2026-10-20 13:57:40', '2026-10-20 13:57:40'),
(17, 39, '2026-10-20 13:57:41', '2026-10-20 13:57:41'),
(17, 40, '2026-10-20 13:57:42', '2026-10-20 13:57:42'),
(17, 42, '2026-10-20 13:57:42', '2026-10-20 13:57:42'),
(17, 43, '2026-10-20 13:57:43', '2026-10-20 13:57:43'),
(17, 58, '2026-10-20 13:57:48', '2026-10-20 13:57:48'),
(17, 59, '2026-10-21 13:47:00', '2026-10-21 13:47:00'),
(17, 63, '2026-11-04 23:56:24', '2026-11-04 23:56:24'),
(17, 64, '2026-11-05 16:33:43', '2026-11-05 16:33:43');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('0ZD0VPDsmcBEfp26dqcpqLzBBTHLFxi5ueKJEgvm', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidHA0dmFaMjdKb1IxZG04Z0RLMmhPQUhJbjZPMzh0TmhiOFpUWmkxRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184378),
('16klhZT7HDYqVWKhLDXRnuTiSnnPnfKbCHRw0MnG', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOVc4UWxNYnhQWHpZdmwxeG5yUWhuQmY0TUpDZmZxRWI3TDFpVEtyQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183695),
('1dVxJAsWJLeszaWtnZFrl0U0gTZd1GtuXy8pgBKl', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGUxTEdsWU5tekkzUVdPQlFxZW9jVzRqazR0eHI2b3Bmejg5YlAzZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183633),
('1iCrUHNkeI46hr4yMjRwx1cPaSLZDafgTZF61Obc', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZnh5cVgwQ3lMT2pjQU1qd1BDZnlBS0VpOEtZTnpweDFEUXl2aG1xYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184409),
('1Wnu9jSrznISz1aRgE49acq3ohcuR70BlEVkaf1X', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiU2dqR3czcm5jaXdTVkludVZRSldVc1lQZDFBVkFTSTRuSDJLZEZ6bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184874),
('1ZNDlyYenltWvE4O6zb9zAZdrNbqRN6SDlX3htop', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUxGZkZyaVpacXEyRTh6VkdnSXpGMUVXVXJrM0xqd0tKTFVoZ1BsMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183883),
('2g4o9kCtDBLYQY5tiUIWsjj1t1wdTLSFlfAfxj8I', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHgzU3NYMHg4UjFEak9KeWlXQ1l4N2drcERSWFNsZG1HVXhWRXRGcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184254),
('5EsXVPR3um7YwrhPOUiOVqUmQrf0C1SJ6PJjEGHM', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMklpNnV2SXlTVHZkdFl2d09kZW04TGxkVXA1OU1uUnlBQjVnSGRkTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184873),
('6LciFOUhjrDKqVfKaYsWWJKUzvf7Nv8kCsDKLx41', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSnNXUkN0MENCdUdLTzBUVmdkbXd3eHpaeUdtY09SY3d0U05JdTF0NiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184223),
('6rSMi6KMe3HdJHscKwfLnWRvDVCceZ54tU6txG1D', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTnZ2d0pjRVpIZTlQS3E1UGNJRWIwQ3R4eVdydG9DNnY1aWpLV0kycCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183789),
('7bPiSEmqr7phu8dshGwTQGPMQkKR3npF069sCzvf', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiamwwcFYya0haV08xUzFvdW03R0pHZ2hIQnFFbkkzMVhIT0pYbzQ3SiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184068),
('81YufvqRQ350KvPvuhSWRsePhinvV4pHdpFi1KwJ', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVndUMkJHVk40ZFNYQjJOTVlYYWRmRmFQNXd2UmxGT0NoNndZb0praCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184750),
('89leuROp4OrfreFqNy29PanBBdc7SL6Lqgd4GzaR', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY3FPcEU0WDAzMmRwOVdGQmJ4Nk1aMXQxaWFXQ1lFb0pEa2hJUlNXNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184564),
('8C9AeqWhWlRqGxLHNFp6XpVlXYxNdMbH90WaSiOK', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTk5aZzNKWE9UTGNBampRd2FyemVJT2NVN2p3V1NmUUxoclJBN0piMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183665),
('BQXDf4KdNKLYdfHprMQsSZQKhLARib6lUm2wwLLH', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidjZKY3NNRFNDNHdVVlFzM2E1S0xNNUJpT3JUVGl2VG8wUjdDMkhmeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183602),
('Bxkw68A7Rb06G7dWhfvTyPv5rU6KwyHFwmzMgLYc', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiODhKSFMzSkFOcmRhMkpBN0hrbkVTclRQWTRMenl1aVZLaW10QkdrWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183820),
('cAGsMWz1dRG9MX5pzHamge2L8TxXRTBOf3vWP5FJ', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUl1cUc1cUt5eEdPaUZYSVpzYW1Ed2Fyb3M5anNSNGFleEcxYjEzbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184843),
('CvY1P67hwhVcZFO1x5vcTlyMo7MFHdWudutaQBo9', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ2FPcVluQ0x1RHRNb3h2b0Z3SUpSdHdDOFpzRWdnbU9XTE1UcUxpSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184006),
('d9i0NoTDa7E4NuiC8TsHu7iJLVA4goI3qYUypmSY', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibXU4QjIyYnlJWnhXdUM4bGNad3A5cGdQdmwyMll3UVJZMWczR2RPQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184038),
('Da7ur6hnhHJKxIVBARTCJrlKUkeuLa5SvVCKmv6q', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjRzSEpWTTJ2M2lIWGJhWUhsTXdWYVZlZElPQldqdVNncGNFT1dqeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184595),
('Dj7saTC4HeFuEYhvB8fRnPeWdv95407R4BtcQ6MP', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUVUbE44anFPQ2MyTWZIYkZvUXhlV0NXZElWdHZKWFZDaVNzT3p2TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184286),
('dkF5Jbf2nl6h5ZCUU7zDIeGijMgrcwro2tvGvdHX', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibFlTZWNCblNPSE4xZXQ3Y1k3NUFPNGthYU1zTXJ2RnZTWXlBdlBQTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183600),
('DKPcZ2zkpG5S0IPl1JTNz2pXoF7RHmt7iUyNIgsS', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVZobkhubWtVUFBZb3ZTYVdiYXlwVXUxbkxLWnhLMG1sT0gyWnZTeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184658),
('DNR5b0Jqabwb3736aM2a2fzHOeGmJMXM1U8X9yoK', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVpGNlN6UUZRZ0t4bWVFOHhhSEdDeWhqcFRPY2R2bnBrQXBFWDdmdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183975),
('DTXmi1uwiAVgX9NJ2mRvAEbWIPDhkq6FnnqI4h27', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia1lteEZLOUduamNmeHcyb2EzR0Y4UzdCZmxIZmFKTUZxV2cwRFJBRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184193),
('DygyPA5DfVeX7oE9uArwaFsi7o2EX4CWTfhBXzNB', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYndtd3NaZExGOTQ0MzBBRkJXOVVRMEtsU2tsTGNPYUx6NW9xWElPQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184378),
('EaxltXDiz96istClohYDRh7dqktA3wgdsqttmPbk', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibFo4ZHQ2VTRpdDNHOGVSM3BQSFY5aXMxRnh6dUdUdHVaYnNQUG5iayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183664),
('eDH2aJB5GzmiJaPAL2UBX6ZTITlIs9HVJ5Gd96rx', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidUpXdDhwUXBZRVBORGpzN1dvNTlzUFBsaTFYTXdGTzA1YzR5cFBKUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184533),
('EjqVgSjSPCaaZg8XsNfdwBwXti302h58T86d4n1I', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV3ZpU1R2dmRkcDl3QW1hVVRKQlJqemJHY1pTWncxSkVNbEpOZEk4cSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184935),
('gPBN8umJzdaFBFpL7ID0oYR5HG9O6Wb6E9YDpDha', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibWdDOG5PMExyQVNzWmN3SW15Z1NEU205UllPb2hCMUZYNDgxMThRNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184689),
('Gukncr6Ghvr7DjyFLGujrswwuprrIDmKkMrFpNum', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTERmbU92MVQ2N3hEMllqV2pCSkNKUGdsMG5wTDdpbVlnNTEwOUpMNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184658),
('HbkBgza5ELTwJJmRlTlI6N5TFL3Hvni9UH80vjP9', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidFRZd2ZSYkhqcGNvUVF6UnJYQ0RPOU9TUFAxY25sYmVNRHNQTmRORiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794185028),
('HbuepwN06Y9MkiaAsLYWrkYyt98OIhJcH9qFeDwq', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVmVic2I2QWVEdDFWV3JJbEhzV3J2bVFpSU1vcXhSUmlDOHZoYjFyViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184068),
('hFC5KhgcTA0L7PxwUqcMgbCeEeZ7qAuY3f2vOISN', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUF5UENIa0ZsSWFtV3ZCQVJpWGtUdjVHcWNoenBia3BJWUpQRVdGdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184285),
('iaE5PzC3u8clc991oEnp9yxcvs7LSmFPdJasohih', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVNSRGRTeUxGRlJqalVVc3R2MU1wN1FtQnJBbjRRQmpNNDRhMDA0biI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184162),
('IhsV8Xcod2Qt6jYRvBtI1GrKDNTiiddLm8erbVJI', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWNjQWNwWW5oNzd4YWxUVDV1T0FzckZKY3pJQkVvTHJReGR0dmJhZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184904),
('iO92eqa4SqRrcCyeUUUSbeGdLQm3WZ7iGrr4z43b', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRU1jSGF4ZnRqWHc1bGp3UUVsOFNpY1ZFZ0Jqd2xaemFrY3M1OFl6byI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183851),
('IPtN1nudSz9dZgk0Svl9ZsGd8UloHZyASjhBf4Zc', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSjIzYWVib0R4WjdyUVNYV0FHWm1OWlpsN2piek9NMTkxUElXZjc3UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184996),
('jbWLF8soTpNZi5r8fkEaBqO8RugKMkEPgGJKZmDX', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkxNOEo2ekxyNWJkalpURDNZWVhYellQWFFBZHJqbHJpb0lSTFNpVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184192),
('Jh8DqizcUnFuGpUsLpl0tBemDUQPcJGRi1VUMbOg', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibTJVbnRtYTNNMzhtaWFWbHVHM3BmdWNBbUJvaDZJSlFXRlBYdEphSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184781),
('JIvJkdoyPhbpQBubvB5KQoJu2ZKWWqlaaya9xbL3', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ1J0VXVyZ1VnSk9NZzR1bUJRb0QwbDZja1lwdTRXM2lKc0lLUUZKVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184533),
('JJDmVgQHuAAzLT0Bu2wZZ5GZnR1oNqbpOtciQyVf', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ2t6SWFacHE0YlBxTkFUWWxxZXpsQmE2dmU2VDl0YVJ1blBHaE5jTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183727),
('JPTShaCAbE66jYXOeGLfjq8gSZcDKJfqMvhRQa5H', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUtiMUxXaFBJQTJ2aHdCUGVvTVFhUzFITTVEZ0FMaXpwaXpuczZQVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183821),
('jT1lznukoKvo3KfwXSswnqCjld4djByOGGkCBAxn', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWHRXaEZWZ20zc0dpQkRuZk1ZenJNTDJ2eFdRM3ozSWFiaDV4R0tBbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184627),
('jvpQ6nGSaU3L8h78rOTjU4aRN8Qy2JRFHb8MqisV', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYXJaQkpPbEdrVEFDczBxSEJrU0l1Vjd3Qm1GQ3lPVzNFaVM1bEU3YiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184997),
('jVZlRaSTL01tsBIKHefjPriQnDJLZTitieaO1qQ0', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicUM3WlFDZnNiWklNbDZzM0xncVYySmJtNWUxOHh0VllyQjN2b3JodSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184131),
('JwDqxhSEFGHgKNLDHXsDRyoVwe7siS1ocH46PbOs', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiazJ4NzhPakhiTVFPZWZ1S3RvVFVVeWFaQUt4WktWbkFUeFpiekVndiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184440),
('K0oSfDD5EVV8fMRTOlI1OjPgjuyPZwxIIkXfpzDh', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMm1ENmh0eUpMU1pzUnhRRWRSSDJQUVBjaE1XYm1MSTUwOXJkdnFyWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184006),
('KKouHiwolKqGPG5hGRUT0ZOLgi0xHZNTG7I2icA9', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlladjRvSDd6MGgwNGN6c0dwVGlDcDhZb21QM2s0c205NVE5U2xNYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184224),
('KTz8GwiBfa5MrNH0x1q77g325c0L9OEPsAOeomPn', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidWxtdURkQXZwSHJWNm1VN3k3QlpFU01CeldHZ2VHZDFYRUlQUDAzQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183882),
('mNBG6nB6WxCSUQ6vMfR3kQoecPCumoQf6dc9ByuW', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUc4YThreUhadWlwUVV4RG5UeWoxMWN0ZU95RjA5bXNlRXViWUxGcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184751),
('N1GjJGEdVmRFIBSoU8sG2lNyK1xGqbXg6hGZUhD0', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUlB0dkhuQXFERU01aENNMk93eFVEeTFyakJmeXM5OUs4bFlNT2tGTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184100),
('nb8aLkooHQ2WkyMiZItJdtZzMgQsqj0AXqfjUUam', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOENyeDRIdUZkV05tTmRxdXVLUzd6YjI3Wkw0M0JpazlzYlQwSkpSMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184689),
('NLONJdItNe8pPHm9zaICIrCwKT21KGzDikHAA16W', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidE1lQjRYMTlnbXpPcDJoNFoxRGRGWWVoSFZmbk9CWGZ0WTVmRHBlcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184501),
('Ocgy6Pt9YczSTBdbuRuvDeKDw6uiMmpHgkTsFTb4', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibVZIeVY4MmFlRVpTUkF3OHZzTjR6THEyYWd0M3JiTjRWZHlEM2FTcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184812),
('Oda9EwZHAmEhg7M5fdd49Wh8QeFuNinwxg5hxVWq', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVW5RV1dPajRDV1dyUWk1WUR6SEtEQUtxN0FnaEpobGpiYXBzVkJ5MyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794185027),
('OEXeXA6sFn7FdIyR5g7g0NpoFC1zhjm92rXFjUNs', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3dGUlY3UDRJWHU4Smd4VmpxQW8yY0ZlT3JpNnNPcDhyNFFXcVVHVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183790),
('OIXZRN8aXNivIQxnnZwtTH1bAhZbttDubwPZmypA', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMThsMFhuTTIyblVTS3MyTVpxQnlMTE1QZFQ2RTJ6WUpva01BdXFQcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183913),
('oyenKWe5KHyP9K6HLEJEvCO0IrDCRTrRJpXuwEVO', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUNkVjI2aHdqMk82NVg1MDRLWGZyOXNuR3hNSkU1aHl6eERYS1RrOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184781),
('oYGrffCfczst8WCBNeSDwRAWrsEJ7dclKsfqObRm', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1V0dmNRUFh4N3U5YlJjWTNzRFNrdDltUW1CNTdCcm84UGtyeDBKayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184255),
('PUvMW2Oi7dsMo11ZPlBR05T3kOs3qRN2v7z8dTuB', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY3lxSTgwbUdjdGRQWmF3Zmc3NndidkU3TkFCYzZaMlZpdUFONU8xUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183696),
('PX1qoPflyDaR2cfIVRlcaWFVVG2Nezzognxcce8z', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicE5LMHBQb2ZTWkdLQXJDcEtwblFHR0dLVHRWQUhnZmE4Z2xpazZGOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183944),
('PYK4C9PAlkSDnzJrAYUqlaPkPDI6JD5PTd3XWzOy', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVzdKQnNQTkpDdDZpdDloTjZNNnVCaXNCTlphaVVDTnliVE41U3kxRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184099),
('QmhsdCGIeMUC2N56oMPmfxnmkmriCGtQN1fQaihn', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUpJMnNwSmdoYk5oUUl4aTRNRkRabXI3ZmxYa0FXa1hHdWVPMnBwUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184720),
('qn4QvJ7UL0G5lNDYu9xTPRQwdmq2QOGb4zmdDWpL', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkxSem12ZDc3Y2pOc1h1TGIwSHF1ckZiZmE3RzhucVF4QTZMRWJ6MSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184720),
('QUALpaULoYT3GcF5ORpGVZkNJXTpfjL63wnXigAH', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMXh1c285Q3RkV1NEZ1VzaVc3dFJlVEVMV1NVcGNTQ0NnQ2xEb3B4dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183759),
('r3UeiFYKGuyJMJKMcMr4s8oS93ruhOcm0QIP9fdc', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR0JuWExOdUs0aU5TZFp0M0pFdk93Y1luNEJtOUNuaEh1YllGUVJacSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184440),
('rbU8EeYTjvbXeB7BSNClTNDKqbjIzDjLywytFNRk', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicXRodlF6TFMwODJqaVR6NE5mWU5MWmtQVVBmdjVPNWlqRTYwTUR5bSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184471),
('RPRLLfesaz0c32266ojIbVgbsa0LKDqxtt3AZfRz', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGNWNkZUUHZSc0FkQTloSVo3d1NmeUVHbmpVNUlwbU93Z1Z6MmlwTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184626),
('rQLscDSKvrOwT9Nk2f4OHms0mDDoHCgbpfb6jxa1', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicUJJTmhEODdzNGlxbDJVVlIzVWJQSWNlUE1XclN5eHRXMjlBY1R4ZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184966),
('T9qnB7GIlgiB7h8q9Ate7bkV4PpgLyOVuq7ffEnK', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSldYcFJvRERqWFRpNWpHR0NSSFU3Vm9za1NDZmhCOUFBZFlSYkdZZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184564),
('Ta7FjhWOE0Q2llEqq2Jti6E4uSLCywlnazPCdpZv', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidWE2OEh4NHZqaXpscUk3ZEkyTGh1bXZOdTM2bVNWM0xiWjdablZJbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183758),
('tFTqigsrQorAvHq0cPeks92K8yWMZmp70rXLclBC', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0pmVVMxVU1sZHVoYk5Qd0dsWmx0WmtpclNwenFHRjQ0V1RqQW9LWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183944),
('To4oe18oMKvd0AahzRMUqzBdS1zpueWs645JO9Jt', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiekRJcHpBc01hZElrMTdDT25mS2lTQ0xDbUxBcXZwUDJiUjVxeHh1WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184409),
('tu9mSPA3YQglyCQzA0Osi8BHQZWMcBj7G77RmZFg', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHFhTVBjbktyUldGZTY1Z2V6VmtzYXNibDRkM1BJd1NBZjh4TzNlaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184812),
('TZi0eqHNIO6V7bz702kkEgUWssg9IHyBCfbHj4p3', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiczJYY2puUlMzcXU1RVVXQUoycWZKRDhIeHlhbW5FdllnYXlVNmZzSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184316),
('U7BwjqewYBH6EeN6Cg34eGQuzSsWQwYOm9sGQSdP', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ3lXZk1rNENDUEZ2ZUFjTXBKcXVsa3htWm5PS2xrNFJSanNnNWp3NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184843),
('ucHAgQotEwbqdPIeYGglTmVz5uDOEHkjF0A0Vrg2', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2lNbU9Yb1J1RHA3S3lXSDZ4MGJDbWZjNnZCYnZ3QmQwNkZKOGEwbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183914),
('UpK9s2BD17YJ7x7R5Beq7oYSZWau39X8HgAr2zyA', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHZydXp5VEo2UG5wdFpPU2wzVTYwUXNhYlJheVYwTE0wMXk5bUtRRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183727),
('uuWWD53FoWYyADdh4Pcpe5JxSUUrHRghLpikGmSo', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOFZjRVZ2REFmcnZZakZzUWR5SjFRUThuQ0pVZFJUN2pjSEgyOW5teiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184596),
('uwvWT3cNtGhDhaSXivsTpENZPLH5AB3dxLKM9GFz', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjRsQVpCU0JSeWJFb0E3MmpjWjVsTURZZTRkRDRMMzdMTEpSVGljZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184966),
('VbT66Po59U4jxY5KbkVQREu5HvcraDWLibzzMxL1', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieElRelVVWjNmNmNXMXY0N3paUjRCSVRRRWdpZEZZVmoxR1VRdGpLcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184037),
('WDq00MHiv7FcavMeQpCn8pJa9b3b2h4OSUh5Dz9M', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVVTc3MwbVBjbllCVzNmdERoTHpxWjg2RTJhTk55d2JFeklqZWZSTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183976),
('wTk8rE9SkUyFN4qDWstGvweHEKL44od3B3bcVmif', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYlBFV0ROY2pSemdmSG1pSm85S3JySnBkeU9EMmxBWGVyV1RsM0FRcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184161),
('ww9HA07H2b3rlMiF3xDesoqvpmoTiinrkz2cw7wh', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicWdSOWszaFpOWk0zQUo1eml5QWVFRlV2amhteFZ0djRzcXNqMVlBRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184317),
('XwXzhjln560820h2RImjq9oWBwQ4a6Q51Scs8yqX', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXFpRGNHYnF5bUFyUzB3VEFGNDlMcTZqYnl5TG0wTUo1WXhWVjFDbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184904),
('y82gepAvf0I1saw7vGmetoL7pOuuVpoNS9KwVXB5', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoib0wxZWI0VkFUemEwTHVjaUNlQmNZWU9ybUZ5Z1JWcVNabGxwRTZ4ViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NzA6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC8ud2VsbC1rbm93bi9hcHBzcGVjaWZpYy9jb20uY2hyb21lLmRldnRvb2xzLmpzb24iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6ImE1MDFjNTUwZDJmZTJlNTY1ZTY4NTBjYmEzMWQyYzE3MTE2M2RlYWU0ZGQ2MzU0ZGVkYTc0NzY2MmZjMjc4OWEiO30=', 1794184762),
('YRI8BoLlgwa9l8d0HW0bfX0QFaJlTm86TXEXEobm', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZElPQmhjcHZIa1VRdDhPRlhyRjUxQ0kzRkdTSUJxbVpsS1BURU1BVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184935),
('zcI5WNXFwQLN3mUuKO0gB68dRJfczODWsGSZFY9Q', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiODd4bTJkUzI1SGZ6Zmk1OGtQU3ZDVm9SeU5aaTBPdWQ3UUpBWEQ0SSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794184502),
('zNfkEW9iwQ54vRO9SMryVLEzYJiMNiA1gZC0nRS4', NULL, '127.0.0.1', 'opencode/latest/2.2.5/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnJkVHB5em05M28xNEEydnpTYzF6eVo0MVNLbjg3MGd3bUNFTEl4NSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794183852);

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
(1, 4, 1, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(2, 5, 2, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(3, 6, 3, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(4, 8, 4, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(5, 10, 5, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(6, 12, 6, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(7, 15, 7, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(8, 16, 8, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(17, 50, 21, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(18, 49, 18, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(19, 44, 17, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(20, 40, 20, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(21, 38, 23, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(22, 42, 22, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(23, 46, 24, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(24, 39, 19, 1, 1, 1, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(25, 70, 25, 1, 1, 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03'),
(26, 71, 26, 1, 1, 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03'),
(27, 1, 27, 1, 1, 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03'),
(28, 2, 28, 1, 1, 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03'),
(29, 3, 29, 1, 1, 1, '2026-09-13 15:01:03', '2026-09-13 15:01:03'),
(30, 72, 30, 1, 1, 0, '2026-09-13 16:53:40', '2026-09-28 13:35:09'),
(31, 74, 32, 1, 1, 1, '2026-09-13 16:53:40', '2026-09-13 16:53:40'),
(32, 73, 31, 1, 1, 1, '2026-09-13 16:53:40', '2026-09-29 15:11:13'),
(35, 72, 35, 1, 0, 1, '2026-09-22 10:27:31', '2026-09-28 13:35:09'),
(36, 1, 36, 2, 1, 1, '2026-09-22 19:13:05', '2026-09-22 19:13:05'),
(37, 72, 37, 2, 1, 1, '2026-09-28 13:30:46', '2026-09-28 13:35:09'),
(38, 72, 38, 3, 0, 0, '2026-09-28 13:35:07', '2026-09-28 13:35:09'),
(39, 73, 39, 1, 1, 1, '2026-09-29 15:11:10', '2026-09-29 15:11:13'),
(40, 328, 40, 0, 1, 1, '2026-09-29 16:50:12', '2026-09-29 16:52:19'),
(41, 328, 41, 1, 1, 1, '2026-09-29 16:52:18', '2026-09-29 16:52:19'),
(42, 336, 43, 0, 1, 1, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(43, 336, 42, 1, 1, 1, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(44, 329, 44, 0, 1, 1, '2026-09-29 16:53:50', '2026-09-29 16:53:50'),
(45, 344, 46, 0, 1, 1, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(46, 344, 45, 1, 1, 1, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(47, 352, 48, 0, 1, 1, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(48, 352, 47, 1, 1, 1, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(49, 360, 50, 0, 1, 1, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(50, 360, 49, 1, 1, 1, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(51, 368, 52, 0, 1, 1, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(52, 368, 51, 1, 1, 1, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(53, 376, 54, 0, 1, 1, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(54, 376, 53, 1, 1, 1, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(55, 384, 56, 0, 1, 1, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(56, 384, 55, 1, 1, 1, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(58, 385, 58, 0, 1, 1, '2026-09-29 17:05:10', '2026-09-29 17:05:10'),
(59, 386, 59, 0, 1, 1, '2026-09-29 17:06:06', '2026-09-29 17:06:06'),
(62, 388, 62, 1, 1, 1, '2026-09-29 17:11:47', '2026-09-29 17:11:49'),
(63, 387, 64, 1, 1, 1, '2026-09-29 17:13:11', '2026-09-29 17:13:14'),
(64, 389, 66, 0, 1, 1, '2026-09-29 17:14:03', '2026-09-29 17:14:03'),
(65, 392, 74, 0, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(66, 392, 73, 1, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(67, 393, 75, 0, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(68, 394, 76, 0, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(69, 395, 70, 1, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(70, 396, 71, 1, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(71, 397, 68, 0, 1, 1, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(72, 398, 77, 0, 1, 1, '2026-09-29 17:16:33', '2026-09-29 17:16:33'),
(73, 399, 79, 0, 1, 1, '2026-09-29 17:23:00', '2026-09-29 17:23:00'),
(74, 400, 80, 1, 1, 1, '2026-09-30 12:31:59', '2026-09-30 12:31:59'),
(75, 401, 81, 1, 1, 1, '2026-09-30 12:31:59', '2026-09-30 12:31:59'),
(76, 402, 82, 1, 1, 1, '2026-09-30 12:32:33', '2026-09-30 12:32:33'),
(77, 403, 83, 1, 1, 1, '2026-09-30 12:32:33', '2026-09-30 12:32:33'),
(78, 405, 84, 1, 1, 1, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(79, 406, 85, 1, 1, 1, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(80, 408, 95, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(81, 408, 92, 1, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(82, 409, 96, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(83, 410, 97, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(84, 411, 89, 1, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(85, 412, 90, 1, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(86, 413, 87, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(87, 414, 93, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(88, 415, 94, 0, 1, 1, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(89, 416, 107, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(90, 416, 104, 1, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(91, 417, 108, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(92, 418, 109, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(93, 419, 101, 1, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(94, 420, 102, 1, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(95, 421, 99, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(96, 422, 105, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(97, 423, 106, 0, 1, 1, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(98, 424, 110, 1, 0, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(99, 424, 112, 1, 1, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(100, 424, 115, 2, 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(101, 424, 114, 3, 0, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(102, 426, 116, 1, 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(103, 425, 111, 1, 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(104, 425, 113, 1, 1, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(105, 427, 126, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(106, 427, 123, 1, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(107, 428, 127, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(108, 429, 128, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(109, 430, 120, 1, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(110, 431, 121, 1, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(111, 432, 118, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(112, 433, 124, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(113, 434, 125, 0, 1, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(114, 435, 138, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(115, 435, 135, 1, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(116, 436, 139, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(117, 437, 140, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(118, 438, 132, 1, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(119, 439, 133, 1, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(120, 440, 130, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(121, 441, 136, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(122, 442, 137, 0, 1, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(123, 443, 150, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(124, 443, 147, 1, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(125, 444, 151, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(126, 445, 152, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(127, 446, 144, 1, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(128, 447, 145, 1, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(129, 448, 142, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(130, 449, 148, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(131, 450, 149, 0, 1, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(132, 451, 162, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(133, 451, 159, 1, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(134, 452, 163, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(135, 453, 164, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(136, 454, 156, 1, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(137, 455, 157, 1, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(138, 456, 154, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(139, 457, 160, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(140, 458, 161, 0, 1, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(141, 459, 174, 0, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(142, 459, 171, 1, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(143, 460, 175, 0, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(144, 461, 176, 0, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(145, 462, 168, 1, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(146, 463, 169, 1, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(147, 464, 166, 0, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(148, 465, 172, 0, 1, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(149, 466, 173, 0, 1, 1, '2026-10-20 13:40:11', '2026-10-20 13:40:11'),
(150, 467, 186, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(151, 467, 183, 1, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(152, 468, 187, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(153, 469, 188, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(154, 470, 180, 1, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(155, 471, 181, 1, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(156, 472, 178, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(157, 473, 184, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(158, 474, 185, 0, 1, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(159, 475, 198, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(160, 475, 195, 1, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(161, 476, 199, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(162, 477, 200, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(163, 478, 192, 1, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(164, 479, 193, 1, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(165, 480, 190, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(166, 481, 196, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(167, 482, 197, 0, 1, 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(168, 483, 201, 1, 0, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(169, 483, 203, 1, 1, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(170, 483, 206, 2, 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(171, 483, 205, 3, 0, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(172, 485, 207, 1, 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(173, 484, 202, 1, 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(174, 484, 204, 1, 1, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(175, 486, 208, 1, 0, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(176, 486, 210, 1, 1, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(177, 486, 213, 2, 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(178, 486, 212, 3, 0, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(179, 488, 214, 1, 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(180, 487, 209, 1, 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(181, 487, 211, 1, 1, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(182, 489, 215, 1, 0, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(183, 489, 217, 1, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(184, 489, 220, 2, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(185, 489, 219, 3, 0, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(186, 491, 221, 1, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(187, 490, 216, 1, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(188, 490, 218, 1, 1, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(189, 492, 222, 1, 0, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(190, 492, 224, 1, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(191, 492, 227, 2, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(192, 492, 226, 3, 0, 0, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(193, 494, 228, 1, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(194, 493, 223, 1, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(195, 493, 225, 1, 1, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(196, 495, 229, 1, 0, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(197, 495, 231, 1, 0, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(198, 495, 234, 2, 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(199, 495, 233, 3, 0, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(200, 497, 235, 1, 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(201, 496, 230, 1, 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(202, 496, 232, 1, 1, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(203, 498, 236, 1, 0, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(204, 498, 238, 1, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(205, 498, 241, 2, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(206, 498, 240, 3, 0, 0, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(207, 500, 242, 1, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(208, 499, 237, 1, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(209, 499, 239, 1, 1, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26');

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
(1, 4, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(2, 5, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(3, 6, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(4, 7, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(5, 8, 7, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(6, 9, 7, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(7, 10, 8, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(8, 11, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(9, 12, 10, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(10, 13, 9, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(11, 14, 11, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(12, 15, 12, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(13, 16, 12, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(14, 17, 13, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(29, 38, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(30, 39, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(31, 40, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(32, 41, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(33, 42, 7, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(34, 43, 7, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(35, 44, 8, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(36, 45, 6, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(37, 46, 10, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(38, 47, 9, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(39, 48, 11, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(40, 49, 12, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(41, 50, 12, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(42, 51, 13, '2026-09-23 09:27:37', '2026-09-23 09:27:37'),
(43, 70, 3, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(44, 71, 4, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(45, 1, 3, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(46, 2, 3, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(47, 2, 4, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(48, 3, 4, '2026-09-13 15:00:34', '2026-09-13 15:00:34'),
(49, 72, 3, '2026-09-13 16:53:40', '2026-09-13 16:53:40'),
(50, 73, 3, '2026-09-13 16:53:40', '2026-09-13 16:53:40'),
(51, 73, 4, '2026-09-13 16:53:40', '2026-09-13 16:53:40'),
(52, 74, 4, '2026-09-13 16:53:40', '2026-09-13 16:53:40'),
(83, 98, 6, '2026-09-25 14:58:07', '2026-09-25 14:58:07'),
(84, 99, 3, '2026-09-25 14:59:10', '2026-09-25 14:59:10'),
(85, 100, 3, '2026-09-25 15:01:04', '2026-09-25 15:01:04'),
(86, 101, 3, '2026-09-25 15:04:57', '2026-09-25 15:04:57'),
(87, 102, 3, '2026-09-25 15:06:04', '2026-09-25 15:06:04'),
(88, 103, 3, '2026-09-25 15:07:29', '2026-09-25 15:07:29'),
(89, 104, 4, '2026-09-25 15:08:29', '2026-09-25 15:08:29'),
(90, 105, 3, '2026-09-25 15:09:33', '2026-09-25 15:09:33'),
(92, 107, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(93, 108, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(94, 109, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(95, 110, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(96, 111, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(97, 112, 4, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(98, 113, 3, '2026-09-25 15:12:20', '2026-09-25 15:12:20'),
(99, 106, 15, '2026-09-25 15:13:20', '2026-09-25 15:13:20'),
(100, 114, 15, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(101, 115, 3, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(103, 117, 3, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(104, 118, 3, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(105, 119, 3, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(106, 120, 4, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(107, 121, 3, '2026-09-25 15:13:32', '2026-09-25 15:13:32'),
(108, 116, 15, '2026-09-25 15:13:45', '2026-09-25 15:13:45'),
(109, 122, 15, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(110, 123, 3, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(111, 124, 15, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(112, 125, 3, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(113, 126, 3, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(115, 128, 4, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(116, 129, 3, '2026-09-25 15:14:13', '2026-09-25 15:14:13'),
(117, 127, 16, '2026-09-25 15:15:24', '2026-09-25 15:15:24'),
(118, 130, 15, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(119, 131, 3, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(120, 132, 15, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(121, 133, 3, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(122, 134, 3, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(123, 135, 16, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(125, 137, 3, '2026-09-25 15:15:34', '2026-09-25 15:15:34'),
(126, 136, 15, '2026-09-25 15:15:43', '2026-09-25 15:15:43'),
(127, 138, 15, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(128, 139, 3, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(129, 140, 15, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(130, 141, 3, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(131, 142, 3, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(132, 143, 16, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(133, 144, 15, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(134, 145, 3, '2026-09-25 15:15:47', '2026-09-25 15:15:47'),
(135, 146, 15, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(136, 147, 3, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(137, 148, 15, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(138, 149, 3, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(139, 150, 3, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(140, 151, 16, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(141, 152, 15, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(142, 153, 3, '2026-09-25 15:16:00', '2026-09-25 15:16:00'),
(143, 154, 15, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(144, 155, 3, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(145, 156, 15, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(146, 157, 3, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(147, 158, 3, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(148, 159, 16, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(149, 160, 15, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(150, 161, 3, '2026-09-25 15:16:13', '2026-09-25 15:16:13'),
(151, 162, 15, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(152, 163, 3, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(153, 164, 15, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(154, 165, 3, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(155, 166, 3, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(156, 167, 16, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(157, 168, 15, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(158, 169, 3, '2026-09-25 15:16:28', '2026-09-25 15:16:28'),
(159, 170, 15, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(160, 171, 3, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(161, 172, 15, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(162, 173, 3, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(163, 174, 3, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(164, 175, 16, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(165, 176, 15, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(166, 177, 3, '2026-09-25 15:16:41', '2026-09-25 15:16:41'),
(167, 178, 15, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(168, 179, 3, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(169, 180, 15, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(170, 181, 3, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(171, 182, 3, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(172, 183, 16, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(173, 184, 15, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(174, 185, 3, '2026-09-25 15:16:57', '2026-09-25 15:16:57'),
(175, 186, 15, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(176, 187, 3, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(177, 188, 15, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(178, 189, 3, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(179, 190, 3, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(180, 191, 16, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(181, 192, 15, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(182, 193, 3, '2026-09-25 15:17:13', '2026-09-25 15:17:13'),
(183, 194, 15, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(184, 195, 3, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(185, 196, 15, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(186, 197, 3, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(187, 198, 3, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(188, 199, 16, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(189, 200, 15, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(190, 201, 3, '2026-09-25 15:17:34', '2026-09-25 15:17:34'),
(191, 202, 15, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(192, 203, 3, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(193, 204, 15, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(194, 205, 3, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(195, 206, 3, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(196, 207, 16, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(197, 208, 15, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(198, 209, 3, '2026-09-25 15:17:45', '2026-09-25 15:17:45'),
(199, 210, 15, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(200, 211, 3, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(201, 212, 15, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(202, 213, 3, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(203, 214, 3, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(204, 215, 16, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(205, 216, 15, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(206, 217, 3, '2026-09-27 14:13:53', '2026-09-27 14:13:53'),
(207, 218, 15, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(208, 219, 3, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(209, 220, 15, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(210, 221, 3, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(211, 222, 3, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(212, 223, 16, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(213, 224, 15, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(214, 225, 3, '2026-09-27 14:14:30', '2026-09-27 14:14:30'),
(215, 226, 15, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(216, 227, 3, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(217, 228, 15, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(218, 229, 3, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(219, 230, 3, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(220, 231, 16, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(221, 232, 15, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(222, 233, 3, '2026-09-27 14:15:04', '2026-09-27 14:15:04'),
(223, 234, 15, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(224, 235, 3, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(225, 236, 15, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(226, 237, 3, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(227, 238, 3, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(228, 239, 16, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(229, 240, 15, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(230, 241, 3, '2026-09-27 14:15:25', '2026-09-27 14:15:25'),
(231, 242, 15, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(232, 243, 3, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(233, 244, 15, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(234, 245, 3, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(235, 246, 3, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(236, 247, 16, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(237, 248, 15, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(238, 249, 3, '2026-09-28 09:20:34', '2026-09-28 09:20:34'),
(239, 250, 15, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(240, 251, 3, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(241, 252, 15, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(242, 253, 3, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(243, 254, 3, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(244, 255, 16, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(245, 256, 15, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(246, 257, 3, '2026-09-28 09:27:45', '2026-09-28 09:27:45'),
(247, 258, 14, '2026-09-28 09:28:13', '2026-09-28 09:28:13'),
(248, 259, 15, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(249, 260, 3, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(250, 261, 15, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(251, 262, 3, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(252, 263, 3, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(253, 264, 16, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(254, 265, 15, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(255, 266, 3, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(256, 267, 14, '2026-09-28 09:31:40', '2026-09-28 09:31:40'),
(257, 268, 15, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(258, 269, 3, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(259, 270, 15, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(260, 271, 3, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(261, 272, 3, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(262, 273, 16, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(263, 274, 15, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(264, 275, 3, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(265, 276, 14, '2026-09-28 09:32:11', '2026-09-28 09:32:11'),
(266, 277, 14, '2026-09-28 09:33:29', '2026-09-28 09:33:29'),
(267, 278, 14, '2026-09-28 09:35:21', '2026-09-28 09:35:21'),
(268, 279, 14, '2026-09-28 09:36:00', '2026-09-28 09:36:00'),
(269, 280, 14, '2026-09-28 09:36:47', '2026-09-28 09:36:47'),
(270, 281, 14, '2026-09-28 09:37:46', '2026-09-28 09:37:46'),
(271, 282, 14, '2026-09-28 09:38:27', '2026-09-28 09:38:27'),
(272, 283, 14, '2026-09-28 09:39:16', '2026-09-28 09:39:16'),
(273, 284, 14, '2026-09-28 09:47:01', '2026-09-28 09:47:01'),
(274, 285, 14, '2026-09-28 09:51:04', '2026-09-28 09:51:04'),
(275, 286, 11, '2026-09-29 15:27:22', '2026-09-29 15:27:22'),
(276, 287, 2, '2026-09-29 15:34:30', '2026-09-29 15:34:30'),
(277, 288, 12, '2026-09-29 15:37:11', '2026-09-29 15:37:11'),
(278, 289, 2, '2026-09-29 15:37:52', '2026-09-29 15:37:52'),
(279, 290, 12, '2026-09-29 15:37:52', '2026-09-29 15:37:52'),
(280, 291, 15, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(281, 292, 3, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(282, 293, 15, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(283, 294, 3, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(284, 295, 3, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(285, 296, 16, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(286, 297, 15, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(287, 298, 3, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(288, 299, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(289, 300, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(290, 301, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(291, 302, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(292, 303, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(293, 304, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(294, 305, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(295, 306, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(296, 307, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(297, 308, 14, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(298, 309, 11, '2026-09-29 16:23:40', '2026-09-29 16:23:40'),
(317, 328, 14, '2026-09-29 16:33:36', '2026-09-29 16:33:36'),
(318, 329, 14, '2026-09-29 16:34:50', '2026-09-29 16:34:50'),
(319, 330, 14, '2026-09-29 16:35:35', '2026-09-29 16:35:35'),
(320, 331, 14, '2026-09-29 16:36:14', '2026-09-29 16:36:14'),
(321, 332, 14, '2026-09-29 16:36:56', '2026-09-29 16:36:56'),
(322, 333, 14, '2026-09-29 16:37:32', '2026-09-29 16:37:32'),
(323, 334, 14, '2026-09-29 16:38:24', '2026-09-29 16:38:24'),
(324, 335, 14, '2026-09-29 16:42:34', '2026-09-29 16:42:34'),
(325, 336, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(326, 337, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(327, 338, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(328, 339, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(329, 340, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(330, 341, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(331, 342, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(332, 343, 14, '2026-09-29 16:52:28', '2026-09-29 16:52:28'),
(333, 344, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(334, 345, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(335, 346, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(336, 347, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(337, 348, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(338, 349, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(339, 350, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(340, 351, 14, '2026-09-29 16:55:17', '2026-09-29 16:55:17'),
(341, 352, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(342, 353, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(343, 354, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(344, 355, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(345, 356, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(346, 357, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(347, 358, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(348, 359, 14, '2026-09-29 16:55:27', '2026-09-29 16:55:27'),
(349, 360, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(350, 361, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(351, 362, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(352, 363, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(353, 364, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(354, 365, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(355, 366, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(356, 367, 14, '2026-09-29 16:55:37', '2026-09-29 16:55:37'),
(357, 368, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(358, 369, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(359, 370, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(360, 371, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(361, 372, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(362, 373, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(363, 374, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(364, 375, 14, '2026-09-29 16:55:49', '2026-09-29 16:55:49'),
(365, 376, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(366, 377, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(367, 378, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(368, 379, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(369, 380, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(370, 381, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(371, 382, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(372, 383, 14, '2026-09-29 16:56:08', '2026-09-29 16:56:08'),
(373, 384, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(374, 385, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(375, 386, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(376, 387, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(377, 388, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(378, 389, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(379, 390, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(380, 391, 14, '2026-09-29 16:56:20', '2026-09-29 16:56:20'),
(381, 392, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(382, 393, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(383, 394, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(384, 395, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(385, 396, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(386, 397, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(387, 398, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(388, 399, 14, '2026-09-29 17:15:05', '2026-09-29 17:15:05'),
(389, 400, 3, '2026-09-30 12:31:59', '2026-09-30 12:31:59'),
(390, 401, 4, '2026-09-30 12:31:59', '2026-09-30 12:31:59'),
(391, 402, 3, '2026-09-30 12:32:32', '2026-09-30 12:32:32'),
(392, 403, 4, '2026-09-30 12:32:32', '2026-09-30 12:32:32'),
(393, 404, 11, '2026-09-30 12:33:10', '2026-09-30 12:33:10'),
(394, 405, 3, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(395, 406, 4, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(396, 407, 11, '2026-09-30 12:33:37', '2026-09-30 12:33:37'),
(397, 408, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(398, 409, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(399, 410, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(400, 411, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(401, 412, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(402, 413, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(403, 414, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(404, 415, 14, '2026-10-04 09:33:21', '2026-10-04 09:33:21'),
(405, 416, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(406, 417, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(407, 418, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(408, 419, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(409, 420, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(410, 421, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(411, 422, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(412, 423, 14, '2026-10-04 09:33:33', '2026-10-04 09:33:33'),
(413, 424, 6, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(414, 426, 2, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(415, 426, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(416, 426, 17, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(417, 425, 17, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(418, 425, 2, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(419, 425, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(420, 427, 6, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(421, 428, 17, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(422, 429, 17, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(423, 430, 6, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(424, 431, 17, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(425, 431, 2, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(426, 432, 17, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(427, 432, 2, '2026-10-20 13:28:34', '2026-10-20 13:28:34'),
(428, 435, 6, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(429, 436, 17, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(430, 437, 17, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(431, 438, 6, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(432, 439, 2, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(433, 439, 17, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(434, 440, 2, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(435, 440, 17, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(436, 441, 17, '2026-10-20 13:29:30', '2026-10-20 13:29:30'),
(437, 443, 6, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(438, 444, 17, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(439, 445, 17, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(440, 446, 6, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(441, 447, 2, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(442, 447, 17, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(443, 448, 2, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(444, 448, 17, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(445, 449, 17, '2026-10-20 13:33:14', '2026-10-20 13:33:14'),
(446, 451, 6, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(447, 452, 17, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(448, 453, 17, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(449, 454, 6, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(450, 455, 2, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(451, 455, 17, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(452, 456, 2, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(453, 456, 17, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(454, 457, 17, '2026-10-20 13:36:15', '2026-10-20 13:36:15'),
(455, 459, 6, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(456, 460, 17, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(457, 461, 17, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(458, 462, 6, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(459, 463, 2, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(460, 463, 17, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(461, 464, 2, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(462, 464, 17, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(463, 465, 17, '2026-10-20 13:40:10', '2026-10-20 13:40:10'),
(464, 1, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(465, 3, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(466, 2, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(467, 72, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(468, 74, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(469, 73, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(470, 424, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(471, 18, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(472, 19, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(473, 20, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(474, 21, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(475, 22, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(476, 23, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(477, 70, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(478, 71, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(479, 400, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(480, 401, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(481, 402, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(482, 403, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(483, 404, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(484, 405, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(485, 406, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(486, 407, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(487, 328, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(488, 329, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(489, 330, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(490, 331, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(491, 332, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(492, 333, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(493, 334, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(494, 335, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(495, 336, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(496, 337, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(497, 338, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(498, 339, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(499, 340, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(500, 341, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(501, 342, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(502, 343, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(503, 344, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(504, 345, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(505, 346, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(506, 347, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(507, 348, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(508, 349, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(509, 350, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(510, 351, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(511, 352, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(512, 353, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(513, 354, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(514, 355, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(515, 356, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(516, 357, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(517, 358, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(518, 359, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(519, 360, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(520, 361, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(521, 362, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(522, 363, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(523, 364, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(524, 365, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(525, 366, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(526, 367, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(527, 368, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(528, 369, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(529, 370, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(530, 371, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(531, 372, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(532, 373, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(533, 374, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(534, 375, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(535, 376, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(536, 377, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(537, 378, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(538, 379, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(539, 380, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(540, 381, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(541, 382, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(542, 383, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(543, 384, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(544, 385, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(545, 386, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(546, 387, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(547, 388, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(548, 389, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(549, 390, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(550, 391, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(551, 392, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(552, 393, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(553, 394, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(554, 395, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(555, 396, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(556, 397, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(557, 398, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(558, 399, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(559, 408, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(560, 409, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(561, 410, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(562, 411, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(563, 412, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(564, 413, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(565, 414, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(566, 415, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(567, 416, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(568, 417, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(569, 418, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(570, 419, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(571, 420, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(572, 421, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(573, 422, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(574, 423, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(575, 427, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(576, 430, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(577, 433, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(578, 434, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(579, 435, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(580, 438, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(581, 442, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(582, 443, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(583, 446, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(584, 450, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(585, 451, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(586, 454, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(587, 458, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(588, 459, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(589, 462, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(590, 466, 17, '2026-10-21 13:43:09', '2026-10-21 13:43:09'),
(591, 467, 6, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(592, 467, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(593, 468, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(594, 469, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(595, 470, 6, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(596, 470, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(597, 471, 2, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(598, 471, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(599, 472, 2, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(600, 472, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(601, 473, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(602, 474, 17, '2026-10-25 12:18:38', '2026-10-25 12:18:38'),
(604, 475, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(605, 476, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(606, 477, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(608, 478, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(609, 479, 2, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(610, 479, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(611, 480, 2, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(612, 480, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(613, 481, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(614, 482, 17, '2026-10-26 08:53:01', '2026-10-26 08:53:01'),
(615, 483, 6, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(616, 483, 17, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(617, 484, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(618, 484, 2, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(619, 484, 17, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(620, 485, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(621, 485, 2, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(622, 485, 17, '2026-10-27 09:08:11', '2026-10-27 09:08:11'),
(623, 486, 6, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(624, 486, 17, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(625, 487, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(626, 487, 2, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(627, 487, 17, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(628, 488, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(629, 488, 2, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(630, 488, 17, '2026-10-27 09:08:26', '2026-10-27 09:08:26'),
(631, 489, 6, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(632, 489, 17, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(633, 490, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(634, 490, 2, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(635, 490, 17, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(636, 491, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(637, 491, 2, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(638, 491, 17, '2026-10-27 09:09:57', '2026-10-27 09:09:57'),
(639, 492, 6, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(640, 492, 17, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(641, 493, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(642, 493, 2, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(643, 493, 17, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(644, 494, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(645, 494, 2, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(646, 494, 17, '2026-10-27 09:10:04', '2026-10-27 09:10:04'),
(647, 495, 6, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(648, 495, 17, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(649, 496, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(650, 496, 2, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(651, 496, 17, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(652, 497, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(653, 497, 2, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(654, 497, 17, '2026-10-27 09:10:15', '2026-10-27 09:10:15'),
(655, 498, 6, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(656, 498, 17, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(657, 499, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(658, 499, 2, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(659, 499, 17, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(660, 500, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(661, 500, 2, '2026-10-27 09:10:26', '2026-10-27 09:10:26'),
(662, 500, 17, '2026-10-27 09:10:26', '2026-10-27 09:10:26');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--
CREATE TABLE `transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_type_id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `reference_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_done` tinyint(1) NOT NULL DEFAULT '0',
  `is_archive` tinyint(1) NOT NULL DEFAULT '0',
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `transaction_type_id`, `workflow_definition_id`, `office_id`, `reference_number`, `title`, `is_done`, `is_archive`, `is_private`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 3, 3, NULL, 'JFCW-GO9W-DM6Q', 'Communication 1', 0, 0, 0, 1, '2026-03-09 15:51:48', '2026-09-15 11:31:38', '2026-09-15 11:31:38'),
(2, 3, 3, NULL, 'UTST-CZUL-F55O', 'Communication 2', 0, 0, 0, 1, '2026-03-09 15:57:06', '2026-09-15 11:31:42', '2026-09-15 11:31:42'),
(3, 3, 4, NULL, 'TSYP-YHTP-JNWK', 'Communication 3', 0, 0, 0, 1, '2026-03-09 15:57:31', '2026-09-15 11:31:46', '2026-09-15 11:31:46'),
(4, 3, 4, NULL, '7ERC-ULBD-0AV1', 'Communication 4', 0, 0, 0, 1, '2026-03-09 16:32:03', '2026-09-15 11:31:50', '2026-09-15 11:31:50'),
(5, 3, 4, 9, 'GCHJ-9XQD-CV59', 'Shopee', 0, 0, 0, 1, '2026-09-11 08:50:34', '2026-09-15 11:31:54', '2026-09-15 11:31:54'),
(9, 2, 7, 9, 'K8JB-EEGG-36OC', 'Lazada', 0, 0, 0, 1, '2026-09-11 14:24:51', '2026-09-27 14:16:49', '2026-09-27 14:16:49'),
(10, 3, 4, NULL, 'CC5T-ZXED-JAFX', 'Lazada', 0, 0, 0, 1, '2026-09-13 14:42:14', '2026-09-15 11:32:01', '2026-09-15 11:32:01'),
(11, 2, 7, NULL, '4JNN-BZGT-BRYB', 'qwe', 0, 0, 0, 1, '2026-09-13 14:48:16', '2026-09-27 14:16:52', '2026-09-27 14:16:52'),
(12, 3, 16, NULL, 'LUC2-ULOD-KIFH', 'ewq', 0, 0, 0, 1, '2026-09-13 14:48:28', '2026-09-27 14:16:55', '2026-09-27 14:16:55'),
(13, 1, 1, NULL, 'OWOB-BEOY-FW1M', 'eqweqwe', 0, 0, 0, 1, '2026-09-13 14:48:43', '2026-09-27 14:16:59', '2026-09-27 14:16:59'),
(14, 1, 1, NULL, 'HHZB-GGI6-RIQH', 'new', 0, 0, 0, 1, '2026-09-13 16:13:33', '2026-09-27 14:17:11', '2026-09-27 14:17:11'),
(15, 1, 1, NULL, 'VYIR-X6GM-MMXP', 'BAAA', 1, 0, 0, 1, '2026-09-15 11:18:48', '2026-09-27 14:17:14', '2026-09-27 14:17:14'),
(16, 1, 1, NULL, 'Z5UP-ADG3-47IT', NULL, 1, 0, 0, 1, '2026-09-20 09:09:18', '2026-09-27 14:17:17', '2026-09-27 14:17:17'),
(17, 2, 7, NULL, 'G6RW-ZX2H-UUMI', NULL, 0, 0, 0, 1, '2026-09-20 11:10:13', '2026-09-27 14:17:20', '2026-09-27 14:17:20'),
(18, 2, 7, NULL, '4YD8-5DKW-JCYT', NULL, 0, 0, 0, 1, '2026-09-21 17:15:15', '2026-09-27 22:17:23', '2026-09-27 22:17:23'),
(19, 1, 1, 22, 'M5JW-EMVY-6REJ', 'adsa', 0, 0, 0, 1, '2026-09-22 10:12:24', '2026-09-29 08:15:16', '2026-09-29 08:15:16'),
(20, 1, 1, 21, '5PAV-VMC3-7KNX', 'almost', 0, 0, 0, 1, '2026-09-22 10:42:49', '2026-09-29 08:15:19', '2026-09-29 08:15:19'),
(21, 2, 7, 21, 'WMMQ-TXQM-KHWO', 'e', 0, 0, 0, 1, '2026-09-23 09:25:08', '2026-09-29 08:15:22', '2026-09-29 08:15:22'),
(22, 1, 1, 24, 'YLAA-6XW4-FZOH', 'Payroll For Sharief', 0, 0, 0, 1, '2026-09-24 10:50:22', '2026-09-29 08:15:24', '2026-09-29 08:15:24'),
(23, 2, 7, 24, 'Q9TM-29EI-BD6H', 'TISTING', 0, 0, 0, 1, '2026-09-24 11:18:37', '2026-09-29 08:15:27', '2026-09-29 08:15:27'),
(24, 2, 7, 24, 'VMMR-UGLN-OTKG', 'Testing', 0, 0, 0, 1, '2026-09-24 11:22:47', '2026-09-29 08:15:44', '2026-09-29 08:15:44'),
(26, 9, 39, NULL, 'PBXC-UHD1-HBAJ', NULL, 1, 0, 0, 1, '2026-09-25 15:18:46', '2026-09-29 08:15:34', '2026-09-29 08:15:34'),
(27, 9, 39, 24, 'GVMS-GIEX-GXSS', NULL, 0, 0, 0, 1, '2026-09-25 16:46:46', '2026-09-29 08:15:46', '2026-09-29 08:15:46'),
(28, 1, 17, 24, '3VZO-F8OG-28XK', NULL, 1, 0, 0, 1, '2026-09-25 17:01:06', '2026-09-29 08:15:51', '2026-09-29 08:15:51'),
(29, 9, 43, 24, 'LKFA-RUF3-OIWT', NULL, 0, 0, 0, 1, '2026-09-27 14:17:39', '2026-09-30 08:08:49', '2026-09-30 08:08:49'),
(30, 1, 17, 8, 'POYT-3B32-0Y8P', NULL, 0, 0, 0, 1, '2026-09-28 10:45:58', '2026-09-30 08:08:53', '2026-09-30 08:08:53'),
(31, 1, 17, 22, 'KYR2-A1PI-SK9P', NULL, 0, 0, 0, 1, '2026-09-28 10:51:58', '2026-09-28 13:29:47', '2026-09-28 13:29:47'),
(32, 1, 17, 24, 'ROQO-Z1YN-DW1W', NULL, 0, 0, 0, 1, '2026-09-28 13:33:30', '2026-09-30 08:08:57', '2026-09-30 08:08:57'),
(33, 9, 46, 25, 'OX84-PMLV-HER6', 'LEGAL OFFICEEEE', 0, 0, 0, 1, '2026-09-29 15:25:53', '2026-09-29 15:29:11', '2026-09-29 15:29:11'),
(34, 9, 47, 21, 'LOHR-3WAY-OUA1', 'waawdaw', 0, 0, 0, 1, '2026-09-29 15:28:31', '2026-09-29 15:29:08', '2026-09-29 15:29:08'),
(35, 1, 17, 21, 'EIWE-HTYG-FUJ8', NULL, 0, 0, 0, 1, '2026-09-29 16:12:36', '2026-09-30 08:09:00', '2026-09-30 08:09:00'),
(36, 11, 53, 24, 'CRVI-X0P1-WSOM', NULL, 0, 0, 0, 1, '2026-09-29 16:54:47', '2026-09-29 16:58:22', '2026-09-29 16:58:22'),
(37, 11, 60, 24, '2BEY-TTBW-NPT7', NULL, 0, 0, 0, 1, '2026-09-29 16:58:33', '2026-09-29 17:31:02', '2026-09-29 17:31:02'),
(38, 11, 61, 24, 'BNWR-79LJ-VBVP', NULL, 1, 0, 0, 1, '2026-09-29 17:31:10', '2026-09-30 08:09:04', '2026-09-30 08:09:04'),
(39, 11, 61, 24, 'MWY6-RWFW-BF41', NULL, 0, 0, 0, 1, '2026-09-29 17:44:55', '2026-09-30 09:07:23', '2026-09-30 09:07:23'),
(40, 11, 61, 24, 'NU5A-C47R-ESAV', NULL, 0, 0, 0, 1, '2026-09-30 08:09:17', '2026-09-30 08:09:17', NULL),
(41, 11, 66, 24, 'AEFT-WUDT-SHDA', NULL, 0, 0, 0, 1, '2026-10-04 09:34:21', '2026-10-04 09:34:21', NULL),
(49, 11, 66, 24, 'PVP2-D4DX-DEB9', 'charls inoferio payroll', 0, 0, 0, 10, '2026-10-16 11:29:22', '2026-10-19 10:25:23', '2026-10-19 10:25:23'),
(50, 1, 17, 24, '3BRU-SA8W-QRGR', 'sharief kundo mudrikal', 0, 0, 0, 10, '2026-10-16 11:37:24', '2026-10-16 11:37:24', NULL),
(51, 2, 7, 24, 'P00V-E8YI-EAOW', 'sharief procurement', 0, 0, 0, 10, '2026-10-16 11:40:38', '2026-10-16 11:40:38', NULL),
(52, 11, 66, 24, 'WBFQ-HKOG-LDKE', 'sharief', 0, 0, 0, 10, '2026-10-16 11:44:18', '2026-10-16 11:44:18', NULL),
(53, 1, 17, 24, 'WJVR-4V6U-2ZRT', 'Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL', 1, 0, 0, 1, '2026-10-19 10:25:54', '2026-11-04 23:23:08', NULL),
(54, 1, 17, 24, 'V4E0-O3TL-W9BS', 'Charls inoferio Payroll October 1 - 15 2026', 0, 0, 0, 1, '2026-10-19 15:13:46', '2026-10-19 15:13:46', NULL),
(55, 11, 66, 24, 'ACV0-ALRI-XZAG', 'Anthony Procurement', 0, 0, 0, 1, '2026-10-20 13:05:41', '2026-10-20 13:05:41', NULL),
(56, 2, 7, 9, 'DZHW-VDG3-DV7C', 'sharief procurement', 0, 0, 0, 43, '2026-10-21 13:18:42', '2026-10-21 13:24:08', '2026-10-21 13:24:08'),
(57, 11, 72, 9, 'GXBX-Q8AB-NTE8', 'sharief Procurement', 0, 0, 0, 43, '2026-10-21 13:21:41', '2026-10-21 13:24:05', '2026-10-21 13:24:05'),
(58, 11, 72, 9, 'WPXD-SJ3M-5TPV', NULL, 0, 0, 0, 43, '2026-10-21 13:23:13', '2026-10-21 13:24:03', '2026-10-21 13:24:03'),
(59, 11, 72, 24, 'VPWN-I12N-H2OH', 'vincent anthony procurement', 0, 0, 0, 59, '2026-10-21 13:55:58', '2026-10-21 13:55:58', NULL),
(60, 11, 72, 24, 'WTJW-93XH-W5CY', NULL, 0, 0, 0, 59, '2026-10-22 13:56:00', '2026-10-22 13:56:00', NULL),
(61, 11, 72, 24, 'GQZ5-C05U-WL85', NULL, 0, 0, 0, 59, '2026-10-22 13:58:16', '2026-10-22 13:58:16', NULL),
(62, 11, 72, 5, 'VJIK-GNG6-1IXR', NULL, 0, 0, 0, 40, '2026-10-22 14:16:57', '2026-10-22 14:16:57', NULL),
(63, 11, 72, 24, 'HFSH-PS3K-TYOD', NULL, 0, 0, 0, 59, '2026-10-22 14:19:11', '2026-10-22 14:19:11', NULL),
(64, 1, 67, 24, '9IRD-DMGH-XSJG', NULL, 0, 0, 0, 1, '2026-10-26 08:25:08', '2026-11-04 23:45:01', NULL),
(65, 1, 80, 24, 'JZJO-GQWY-CMD5', NULL, 1, 1, 0, 1, '2026-10-27 09:10:47', '2026-11-04 23:23:23', NULL),
(66, 1, 80, 24, 'Y36S-XQWD-0QVH', NULL, 0, 1, 0, 1, '2026-10-29 19:24:36', '2026-11-04 23:10:10', NULL),
(67, 11, 74, 16, '9BW8-WZLF-ZWL0', 'LENIN LENIN', 0, 0, 0, 1, '2026-11-04 23:46:58', '2026-11-05 18:51:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_attachments`
--
CREATE TABLE `transaction_attachments` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `requirement_definition_id` bigint UNSIGNED DEFAULT NULL,
  `source_attachment_id` bigint UNSIGNED DEFAULT NULL,
  `step_run_id` bigint UNSIGNED DEFAULT NULL,
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stored_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `disk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `mime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size_bytes` bigint UNSIGNED NOT NULL DEFAULT '0',
  `uploaded_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_attachments`
--

INSERT INTO `transaction_attachments` (`id`, `transaction_id`, `workflow_step_id`, `requirement_definition_id`, `source_attachment_id`, `step_run_id`, `original_name`, `label`, `stored_path`, `disk`, `mime`, `size_bytes`, `uploaded_by`, `created_at`, `updated_at`) VALUES
(1, 9, 40, 20, NULL, NULL, 'updatedTRANSACTION.sql', NULL, 'attachments/9/40/byLWjADXvnDJyNO1ePVkxabS2GQXFCJCsxzaacK2.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:15:19', '2026-09-15 11:15:19'),
(2, 15, 1, 27, NULL, NULL, 'updatedTRANSACTION.sql', NULL, 'attachments/15/1/hZLkJbKmX5VsOh2rpmO4CT94aL8BcBWlenTJWP0d.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:19:09', '2026-09-15 11:19:09'),
(3, 15, 1, NULL, NULL, 29, 'updatedTRANSACTION.sql', NULL, 'attachments/15/1/SlBUOGC2MRwZv89P7ZdhM2gNVMHFkZNy7i6t0aUb.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:19:26', '2026-09-15 11:19:31'),
(4, 15, 2, 28, NULL, NULL, 'updatedTRANSACTION.sql', NULL, 'attachments/15/2/SUN2o8FaukgttwMQL1VAarPnERIAQaY5t5QiC3Dh.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:19:50', '2026-09-15 11:19:50'),
(5, 15, 2, NULL, NULL, 30, 'updatedTRANSACTION.sql', NULL, 'attachments/15/2/eYbl6TUKCJ2TJf6j3NVx3KjMswKGvzmo3KFOF8Sh.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:20:03', '2026-09-15 11:20:06'),
(6, 15, 1, NULL, NULL, 31, 'updatedTRANSACTION.sql', NULL, 'attachments/15/1/dm6deCRTaM7p9sTUkcZ2uTue6lgU5PduPWt8RWjK.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 11:25:03', '2026-09-15 11:25:05'),
(9, 20, 1, 27, NULL, NULL, 'updatedTRANSACTION.sql', NULL, 'attachments/20/1/MQEG1RPeMcEZGhseferAqu4b5iu9uyO0GwKMZ5u6.txt', 'local', 'text/plain', 85545, 1, '2026-09-22 11:22:58', '2026-09-22 11:22:58'),
(10, 20, 1, 36, NULL, NULL, 'updatedTRANSACTION.sql', NULL, 'attachments/20/1/i7YAyOFBihN1x2iufEjejB0zFF7pCvQIBeYwRXW1.txt', 'local', 'text/plain', 85545, 1, '2026-09-22 11:23:03', '2026-09-22 11:23:03'),
(11, 22, 1, 27, NULL, 104, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/22/1/pdyQ0LR9YWs9oR7bxEU1QWs8PIh2xy5J2xrxXSDL.pdf', 'local', 'application/pdf', 584366, 1, '2026-09-24 10:54:07', '2026-09-24 10:54:17'),
(12, 22, 1, 36, NULL, 104, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', NULL, 'attachments/22/1/d1ojR66DO3C6X0J5dTdzEcac2NkBimqkRImIZcVF.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-24 10:54:13', '2026-09-24 10:54:17'),
(13, 22, 2, 28, NULL, 105, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', NULL, 'attachments/22/2/mT1HTLREHoAcayXMpDPWDBtjaIrKfpZ6rhJLIsmB.pdf', 'local', 'application/pdf', 470731, 1, '2026-09-24 10:57:43', '2026-09-24 10:58:02'),
(14, 24, 38, 23, NULL, 110, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', NULL, 'attachments/24/38/FALzG59NKNo6SiYG8RwTdSkinJsZwfrw8IjVApI8.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-25 14:25:52', '2026-09-25 14:25:55'),
(15, 28, 72, 35, NULL, 122, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', NULL, 'attachments/28/72/gV4eCAaMrSYdnJNP03NZW6ZCZhoDygCA0AbolZ5O.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-25 17:01:55', '2026-09-25 17:02:03'),
(16, 28, 72, 30, NULL, 122, 'APPPROVED BUDGET FOR THE CONTRACT.pdf', NULL, 'attachments/28/72/5iLGSSXzNEhaHKmyVbhHqKNU2sk0Ez5oPuKBYujv.pdf', 'local', 'application/pdf', 427193, 1, '2026-09-25 17:02:00', '2026-09-25 17:02:03'),
(17, 28, 73, 31, NULL, 123, 'APPOINTMENT  OF DUTY CHRIST JOY GALANO.pdf', NULL, 'attachments/28/73/me1DYTxYZZ8iDSqr9EtTwyTfNnCmS7JbwLCyWTFl.pdf', 'local', 'application/pdf', 317046, 1, '2026-09-25 17:05:13', '2026-09-25 17:05:21'),
(18, 30, 72, 35, NULL, 139, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', NULL, 'attachments/30/72/Kgw1kf9SyAYFWlunAonj6QRRpfYyn4OPeBUgg6vu.pdf', 'local', 'application/pdf', 8594822, 1, '2026-09-28 10:46:15', '2026-09-28 10:46:28'),
(19, 30, 72, 30, NULL, 139, 'APPOINTMENT  OF DUTY BRY WEE AL BASHIR ROPETA.pdf', NULL, 'attachments/30/72/ynHL3lyj1o6o46E1K9fJoJ0wItFnJUnOcHxCQnJk.pdf', 'local', 'application/pdf', 1149079, 1, '2026-09-28 10:46:21', '2026-09-28 10:46:28'),
(20, 30, 73, 31, NULL, NULL, 'AFFIDAVIT OF LOSS.pdf', NULL, 'attachments/30/73/182w2207upCAIcPTI7TMd5STb77Kgrthw2sAIGkp.pdf', 'local', 'application/pdf', 325045, 1, '2026-09-28 10:48:05', '2026-09-28 10:48:05'),
(21, 31, 72, 35, NULL, 141, 'APPOINTMENT  OF DUTY BRY WEE AL BASHIR ROPETA.pdf', NULL, 'attachments/31/72/JF52qlz9sxrrHowymh840Vnl1CJjnXyDwRXwVOS6.pdf', 'local', 'application/pdf', 1149079, 1, '2026-09-28 10:52:11', '2026-09-28 10:52:22'),
(22, 31, 72, 30, NULL, 141, 'ANNUAL MEMBERSHIP TO THE ETRACS SUSTAINABILITY PROGRAM FOR THE CITY GOV.pdf', NULL, 'attachments/31/72/7SEvtfOy4zzi5J8i3oudd2bpGbWh2PN3pW9TpgEn.pdf', 'local', 'application/pdf', 248246, 1, '2026-09-28 10:52:16', '2026-09-28 10:52:22'),
(41, 32, 72, 37, NULL, 165, 'Payroll.pdf', NULL, 'attachments/32/72/Vj6dZi4FhBAsOEiUZ34tdQhaX6h93T7GOR53YN5g.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 15:15:58', '2026-09-29 15:41:58'),
(42, 32, 72, 35, NULL, 165, 'AR.pdf', NULL, 'attachments/32/72/0BPV2sIpGeEBvK6M5xWrL9ciQFbwFvxoF5XBYgzH.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 15:16:02', '2026-09-29 15:41:58'),
(43, 35, 72, 37, NULL, 171, 'Payroll.pdf', NULL, 'attachments/35/72/nRNKMFzx6NWpEvKcWBNbBVPvoMxzQBqkpS721FhT.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 16:13:51', '2026-09-29 16:13:57'),
(44, 35, 72, 35, NULL, 171, 'AR.pdf', NULL, 'attachments/35/72/cLwAsEhAd9tjWb8pqlkQvz5HVsegI0VDtZt6utrg.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 16:13:54', '2026-09-29 16:13:57'),
(45, 35, 73, 39, NULL, 172, 'Birthcert.pdf', NULL, 'attachments/35/73/BxNLrpGWHVwX2VLNUql55uaT2qz3f6THXtT6tO4I.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 16:15:55', '2026-09-29 16:19:36'),
(46, 35, 73, 31, NULL, 172, 'DTR validated.pdf', NULL, 'attachments/35/73/qkxQBa5R02HhNct2NYzCssxggvXor0HWeztonhVY.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 16:16:00', '2026-09-29 16:19:36'),
(47, 37, 384, 56, NULL, 180, 'AR.pdf', NULL, 'attachments/37/384/uxQ7r6bQ3pgCoc1lCDJONekjknKhFzsTMQlhtRX3.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:17:44', '2026-09-29 17:17:49'),
(48, 37, 384, 55, NULL, 180, 'AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf', NULL, 'attachments/37/384/rU6Pj0tWbmD5vULnlefQ0H5cRiuMOSbl4Q3GetNo.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 17:17:47', '2026-09-29 17:17:49'),
(49, 37, 385, 58, NULL, 181, 'INCOME GENERATED BY THE CITY FROM NEW BUSINESS.pdf', NULL, 'attachments/37/385/AzwxR7mOCbmc3IR1BGD3rp4xSGVuh8MtpOS7ohue.pdf', 'local', 'application/pdf', 290838, 1, '2026-09-29 17:18:01', '2026-09-29 17:19:41'),
(50, 37, 386, 59, NULL, 182, 'AR.pdf', NULL, 'attachments/37/386/KDi3vTw7Hy3y4vWFDusI5vvFPsk8F0fhbKFa2MUW.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:19:53', '2026-09-29 17:20:01'),
(51, 37, 387, 64, NULL, 183, 'AR.pdf', NULL, 'attachments/37/387/6XFVaFEUFzIJfcm9j5MCeQFagmppFCYFj5tWyAPm.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:20:26', '2026-09-29 17:20:28'),
(52, 37, 388, 62, NULL, 184, 'Birthcert.pdf', NULL, 'attachments/37/388/gpOv2kEPeMjh6AsTcqxNLhtq1Pcg0JXmF3wKYldb.pdf', 'local', 'application/pdf', 359202, 1, '2026-09-29 17:20:45', '2026-09-29 17:20:54'),
(53, 37, 389, 66, NULL, 185, 'AR.pdf', NULL, 'attachments/37/389/TCaB43a4Dr6D8OH9tOZIkv4hxKvJ4ErH4uUJa2nn.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:21:10', '2026-09-29 17:21:11'),
(54, 38, 392, 74, NULL, 190, 'AR.pdf', NULL, 'attachments/38/392/CdbLgzRQgqeLlPoRep9Qa99okYOo1K5L4IhnUVot.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:31:25', '2026-09-29 17:31:30'),
(55, 38, 392, 73, NULL, 190, 'AR.pdf', NULL, 'attachments/38/392/b80bppIb50Ja2HqRUOQqnofrQSV8d8iF2y0Snrin.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:31:29', '2026-09-29 17:31:30'),
(56, 38, 393, 75, NULL, 191, 'AR.pdf', NULL, 'attachments/38/393/kg8iuCimu9QHrvlqmaQIXFGT6lh6h9VqxKymEtC5.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:31:47', '2026-09-29 17:31:49'),
(57, 38, 394, 76, NULL, 192, 'AR.pdf', NULL, 'attachments/38/394/BCueZ9u7cj18n3nOxQOysGJa7DgLf9xvBQF9gMOj.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:32:02', '2026-09-29 17:32:04'),
(58, 38, 395, 70, NULL, 193, 'AR.pdf', NULL, 'attachments/38/395/ydhVKYaWxyV9eKYAvieC4T44yKxiql1XjmpN2Y5L.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:32:16', '2026-09-29 17:32:20'),
(59, 38, 396, 71, NULL, 194, 'AR.pdf', NULL, 'attachments/38/396/8j68fFN6EnhTkJgaefgdes670jGg0sYxD9LQUcVG.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:44:02', '2026-09-29 17:44:03'),
(60, 38, 397, 68, NULL, 195, 'AR.pdf', NULL, 'attachments/38/397/C8NxF0rVxAtyuHxQsyLxyt9sSfVM0BogpDchpfTC.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:44:18', '2026-09-29 17:44:20'),
(61, 38, 398, 77, NULL, 196, 'AR.pdf', NULL, 'attachments/38/398/5Rb6SrKvZavzmMMMexEyXTMa4scGrejvpoQDj2B5.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:44:30', '2026-09-29 17:44:32'),
(62, 39, 392, 74, NULL, 199, 'AR.pdf', NULL, 'attachments/39/392/g1GLrynOmE7OR1KQ2puGx4L9K8PuXCnzy4qRPMIe.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:47:10', '2026-09-29 17:47:17'),
(63, 39, 392, 73, NULL, 199, 'AR.pdf', NULL, 'attachments/39/392/390wp17jmCARGgFNqi89ktqb7s17uO7Qo8PVQ2Iw.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:47:13', '2026-09-29 17:47:17'),
(64, 39, 393, 75, NULL, 200, 'AR.pdf', NULL, 'attachments/39/393/qTI2ycczwa52AjSPDtx5JbnHNTuOcWpVTXBEN2gA.pdf', 'local', 'application/pdf', 679398, 1, '2026-09-29 17:48:05', '2026-09-29 17:49:31'),
(65, 40, 392, 74, NULL, 202, 'AR.pdf', NULL, 'attachments/40/392/If8wTVtno3BZ9gJXLaBQqsARvDK6dSi8VSd0J9C3.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:17', '2026-10-01 16:12:24'),
(66, 40, 392, 73, NULL, 202, 'AR.pdf', NULL, 'attachments/40/392/WrqrhZCU9iVa4ZOZlGmoLspGYOCRnCeGVmcnOuqD.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:21', '2026-10-01 16:12:24'),
(67, 40, 393, 75, NULL, 203, 'AR.pdf', NULL, 'attachments/40/393/kHHtEGfe7S3jBlIJ5gWrk5tIy5XWeAvZzcATXFRB.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:37', '2026-10-01 16:12:38'),
(79, 49, 416, 107, NULL, 224, 'Name of association.docx', NULL, 'attachments/2026/10/49/416/9YSVK28vCGaPuQ9mzpG4Hv72SKq1JKJzbrWy0Enf.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:30:29', '2026-10-16 11:30:35'),
(80, 49, 416, 104, NULL, 224, 'Name of association.docx', NULL, 'attachments/2026/10/49/416/MMYxcXyiFRP7TOkd6kYcsz45bCI95GkIhUJMgwje.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:30:34', '2026-10-16 11:30:35'),
(81, 50, 72, 30, NULL, 226, 'Name of association.docx', NULL, 'attachments/2026/10/50/72/ZsVttICjNuwXfjA12bw8deot2yAziXYi8xFRcvA6.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:38:28', '2026-10-16 11:38:52'),
(82, 50, 72, 37, NULL, 226, 'Name of association.docx', NULL, 'attachments/2026/10/50/72/cR22gwO8h51YccHUG8QqHgjmoNl8KIcE08mO3Bcc.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:38:31', '2026-10-16 11:38:52'),
(83, 50, 72, 35, NULL, 226, 'Name of association.docx', NULL, 'attachments/2026/10/50/72/NTar5qAwv7FPIw9Ln8PCjmeIQixexUbXT3VMuYpB.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:38:50', '2026-10-16 11:38:52'),
(84, 51, 38, 23, NULL, 228, 'Name of association.docx', NULL, 'attachments/2026/10/51/38/CAFkJ2E8FYjLRlwQ84i7J8As3G6ZBQd1KPW40y3J.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:41:06', '2026-10-16 11:41:08'),
(85, 52, 416, 107, NULL, 230, 'Name of association.docx', NULL, 'attachments/2026/10/52/416/ZjlpiwtSzfbv0CVffwrZtOLANLdtCRVDDfqXd2qF.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:44:36', '2026-10-16 11:44:41'),
(86, 52, 416, 104, NULL, 230, 'Name of association.docx', NULL, 'attachments/2026/10/52/416/0WCANVg4D3DDcaB08mHoPqhW3DoVWi2MuUqQJgbj.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 10, '2026-10-16 11:44:39', '2026-10-16 11:44:41'),
(87, 53, 72, 37, NULL, 232, 'Name of association.docx', NULL, 'attachments/2026/10/53/72/jPv7vYRe9kNg9oWbQj7ptT7iB5bPaIF2M7pCGrUN.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 1, '2026-10-19 11:52:00', '2026-10-19 11:52:22'),
(88, 53, 72, 35, NULL, 232, 'Name of association.docx', NULL, 'attachments/2026/10/53/72/8lNrCPKtFcQpDKGTfM4ReORxt2uB1uCU3VzRVd7u.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 1, '2026-10-19 11:52:04', '2026-10-19 11:52:22'),
(89, 53, 72, 30, NULL, 232, 'Name of association.docx', NULL, 'attachments/2026/10/53/72/DfNWB5DEaBPNT1pQvKAVAEXXl5KPJN8tbeuB3nPQ.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 1, '2026-10-19 11:52:21', '2026-10-19 11:52:22'),
(90, 53, 73, 39, NULL, 233, 'Name of association.docx', NULL, 'attachments/2026/10/53/73/873ZrmdyakmO0Sodzzo05ODivla5sKyyVgNuidy5.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 1, '2026-10-19 11:52:41', '2026-10-19 11:52:49'),
(91, 53, 73, 31, NULL, 233, 'Name of association.docx', NULL, 'attachments/2026/10/53/73/KcODfGGs9thglkXi9fdCGM2MtwbjnQ4Z3rOTJnHt.docx', 'local', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 29840, 1, '2026-10-19 11:52:47', '2026-10-19 11:52:49'),
(92, 59, 459, 174, NULL, 240, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/59/459/smMVadeUIBpL0ChEHKSA8qgrvQggHyxEoOa3IGao.jpg', 'local', 'image/jpeg', 350210, 59, '2026-10-21 13:56:14', '2026-10-21 13:56:31'),
(93, 59, 459, 171, NULL, 240, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/59/459/ZcwhliMeZqictqcs9uZd40pGQGi7x7I6nsNfOP9A.jpg', 'local', 'image/jpeg', 350210, 59, '2026-10-21 13:56:16', '2026-10-21 13:56:31'),
(94, 59, 460, 175, NULL, 241, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/59/460/zak39fec9OP4y8InJap4JiFoA2AWe8rO4TDR9TDX.jpg', 'local', 'image/jpeg', 350210, 42, '2026-10-21 13:58:18', '2026-10-21 13:58:33'),
(95, 61, 459, 174, NULL, 246, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/61/459/AX77OhAZDxNqolhgCFyatlolI0CWhHGUSlwwNVgo.jpg', 'local', 'image/jpeg', 350210, 59, '2026-10-22 13:58:49', '2026-10-22 13:58:55'),
(96, 61, 459, 171, NULL, 246, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/61/459/0CCUYfV00MrubEW1avvYZxFSSrojwIuiQS6I4KCj.jpg', 'local', 'image/jpeg', 350210, 59, '2026-10-22 13:58:53', '2026-10-22 13:58:55'),
(97, 61, 460, 175, NULL, 247, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/61/460/2OeTkL6VAQ5FCT9yvdvynDNTOfGVaOn4bHV9wYeV.jpg', 'local', 'image/jpeg', 350210, 42, '2026-10-22 14:01:33', '2026-10-22 14:01:35'),
(98, 61, 461, 176, 97, 248, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/61/460/2OeTkL6VAQ5FCT9yvdvynDNTOfGVaOn4bHV9wYeV.jpg', 'local', 'image/jpeg', 350210, 40, '2026-10-22 14:04:46', '2026-10-22 14:04:49'),
(99, 59, 461, 176, 94, 252, 'City Hall Pic 1.jpg', NULL, 'attachments/2026/10/59/460/zak39fec9OP4y8InJap4JiFoA2AWe8rO4TDR9TDX.jpg', 'local', 'image/jpeg', 350210, 40, '2026-10-22 15:03:24', '2026-10-22 15:03:26'),
(103, 64, 424, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'wadwad', 'attachments/2026/10/64/424/4W8Y4uRLbfJaqe9BAmR0eDdSKYmbSPrmkkDc2CRu.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-26 08:29:59', '2026-10-26 08:29:59'),
(106, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'awdawd', 'attachments/2026/10/65/498/yjsLpxREV49suMgRWvw83KtKoTZjwjgQ4M689EPG.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-27 19:19:02', '2026-10-29 18:03:09'),
(108, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'wadawd', 'attachments/2026/10/65/498/WI8fvNifopklllbRoedpJnE61zfo51Z6gheaM3uf.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-27 21:02:36', '2026-10-29 18:03:09'),
(109, 65, 498, NULL, NULL, NULL, 'AFFIDAVIT OF LOSS.pdf', 'awdaw', 'attachments/2026/10/65/498/k8ii4xyRuj17lnFOj3v1inDr7Vw9U7u4dO5Ag9kD.pdf', 'local', 'application/pdf', 325045, 1, '2026-10-27 21:12:27', '2026-10-29 18:03:09'),
(110, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'wadawd', 'attachments/2026/10/65/498/FY8edXgAk9mtL8KaUtphxao9KBzIkBu2JF6Pcve5.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-27 21:24:24', '2026-10-29 18:03:09'),
(111, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'awdawd', 'attachments/2026/10/65/498/d8MCTH98o0w59Bng5MXY6riFZSvYK4YcH60T43z4.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-27 21:53:33', '2026-10-29 18:03:09'),
(112, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'adwadwad', 'attachments/2026/10/65/498/VF9onIUBdHMDlQ65BMWhxN2p5dvYd2CG4rIlBMUL.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-27 21:53:44', '2026-10-29 18:03:09'),
(113, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'adwadwad', 'attachments/2026/10/65/498/isQmfbqYgOG3RTFXRiaSmqTUEr0X0F1UWGo8Ngvb.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-27 21:53:46', '2026-10-29 18:03:09'),
(114, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'adwadwad', 'attachments/2026/10/65/498/aFlSuNguludQD7Df3og2D3FmDRv108FbAcZBZadv.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-27 21:53:48', '2026-10-29 18:03:09'),
(115, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'adwadwad', 'attachments/2026/10/65/498/oYBGHdK3nnfFppevbhMRC5YafVygx6q34EhHRl0U.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-27 21:53:51', '2026-10-29 18:03:09'),
(121, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'wadawd', 'attachments/2026/10/65/498/txP9c6H4GaUQncckVf7EXFrGv2anupeHmliPlvIk.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-27 22:14:18', '2026-10-29 18:03:09'),
(122, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'wadawd', 'attachments/2026/10/65/498/FX12K4RTkq0bCqX2HXDmzxBb9KPJHQy8apItO3ic.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-27 22:14:18', '2026-10-29 18:03:09'),
(123, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'wadawd', 'attachments/2026/10/65/498/9lu4eYLerqaJNMbVnTPXP8DSDGZXDQ4WwIivIDS9.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-27 22:14:19', '2026-10-29 18:03:09'),
(124, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'wadawd', 'attachments/2026/10/65/498/YSl5ufWvVVTzwoJX5LdyZXc91pm16BprkbGmeCCn.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-27 22:14:20', '2026-10-29 18:03:09'),
(125, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'wadawd', 'attachments/2026/10/65/498/FAgNy3X8ZAqfoPDp9w36QC68dWyWQVD1529AlPNt.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-27 22:14:20', '2026-10-29 18:03:09'),
(126, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'wadawd', 'attachments/2026/10/65/498/RiuUUTTWRd399n0NxMiueWCE08p2teox3APQZ16M.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-27 22:14:22', '2026-10-29 18:03:09'),
(127, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'bahubuli', 'attachments/2026/10/65/498/0Stxjj9JfScOl7M9rl91AFR2Tbr8U203tniU7G0B.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-27 22:14:33', '2026-10-29 18:03:09'),
(128, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'awdawdaw', 'attachments/2026/10/65/498/8Qv6W6HOMaKhyiLFNsYzMbliv7c6rOr4bwhJJ3qA.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:03:28', '2026-10-29 18:03:09'),
(129, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'awdawdaw', 'attachments/2026/10/65/498/Rc69uUa3GArgzyyF9A9vinLnEOCSJiJxhUiL03vq.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:03:29', '2026-10-29 18:03:09'),
(130, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'awdawdaw', 'attachments/2026/10/65/498/qy7dbNbT7HWROryg0YiN3KcYvmdFZRsTR6AEZHua.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:03:30', '2026-10-29 18:03:09'),
(131, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'awdawdaw', 'attachments/2026/10/65/498/40e6nMIspYSREVDKUXf6WsQg1ATbdO3XVRiXvrId.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:03:31', '2026-10-29 18:03:09'),
(132, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'awdawdaw', 'attachments/2026/10/65/498/NII1IN4Shi1ycPacg2S6m7uZDmalcdFAtNWb8V0Y.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:03:31', '2026-10-29 18:03:09'),
(133, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'awdawdaw', 'attachments/2026/10/65/498/pGIUMavINj1wJWKvWiWW62OkM15U9zs0BQcEtM50.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:03:33', '2026-10-29 18:03:09'),
(134, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'jiji', 'attachments/2026/10/65/498/uvrbtcJl0igEVhCxIPJT2HGXZuSeUqiKDmmJqX0q.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:05:48', '2026-10-29 18:03:09'),
(135, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'jiji', 'attachments/2026/10/65/498/04wnv4eWBPgMkrxK9JyybdxoYHhwRSnPFx9ita4q.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:05:49', '2026-10-29 18:03:09'),
(136, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'jiji', 'attachments/2026/10/65/498/CWwSKlF2ANeOxOzz6w2PS2m2mvlyx921jS4AAmiI.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:05:49', '2026-10-29 18:03:09'),
(137, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'jiji', 'attachments/2026/10/65/498/KbR88FT2UMBNqgQhPzzreNdPxFJh7es3Mdwl2E44.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:05:50', '2026-10-29 18:03:09'),
(138, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'jiji', 'attachments/2026/10/65/498/sPB1DFx9OUrZegQ1c8UnPqM8uDQqwKTk7QxYdFDK.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:05:51', '2026-10-29 18:03:09'),
(139, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'jiji', 'attachments/2026/10/65/498/HVZGWhBQvzcDC62b3zeKGwzsJpXcQ7485eZX5Mc0.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:05:53', '2026-10-29 18:03:09'),
(140, 65, 498, NULL, NULL, NULL, 'AFFIDAVIT  OF LOSS CARL DEALA.pdf', 'jiji', 'attachments/2026/10/65/498/aSMY3stWKJeEsy8ER1unUWBeJa5H48OdnjI8aKjC.pdf', 'local', 'application/pdf', 440807, 1, '2026-10-28 00:05:54', '2026-10-29 18:03:09'),
(141, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'jiji', 'attachments/2026/10/65/498/GmHi0RdUTrB1qKJcTmf3e378XsWeYHZOcC65cgU2.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:10:14', '2026-10-29 18:03:09'),
(142, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'jiji', 'attachments/2026/10/65/498/BG49TuxmMTUUlw9qNwQW1Ky5q7xqrX5389Xqwy1v.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:10:15', '2026-10-29 18:03:09'),
(143, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'jiji', 'attachments/2026/10/65/498/A8zxr72ErzLhmcfzsGOSAbdp1u0H8ZXVFgqSix9c.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:10:16', '2026-10-29 18:03:09'),
(144, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'jiji', 'attachments/2026/10/65/498/ruCVHQrjl1kQzdAOLVb3lqKfMo8ey4QVB4vYRSQo.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:10:16', '2026-10-29 18:03:09'),
(145, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'jiji', 'attachments/2026/10/65/498/5TCylw6NaPm3awGevKbeSlg9RlDRdlNO13HDFE2L.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:10:17', '2026-10-29 18:03:09'),
(146, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'jiji', 'attachments/2026/10/65/498/LKKAki2tKJkOHtjsw4wyCgoOxnRSQYliMz1npQQT.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:10:18', '2026-10-29 18:03:09'),
(147, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'jiji', 'attachments/2026/10/65/498/N7ZnAH2FNiSOO3N0FopsChVLxsnqJ2uFnTNGvv7r.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:12:10', '2026-10-29 18:03:09'),
(148, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'jiji', 'attachments/2026/10/65/498/iADZelbuR5YsKdCfoRdvPpTmnEGZyM4BmO6tzXM5.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:12:11', '2026-10-29 18:03:09'),
(149, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'jiji', 'attachments/2026/10/65/498/M0UB6swbvaw0uB65ly3t1O3RBr09lMLLaxydthD3.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:12:11', '2026-10-29 18:03:09'),
(150, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'jiji', 'attachments/2026/10/65/498/GuGjj1hkV6ODpvhKluj3KYPfm6Rr1b3VNilB3LDC.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:12:12', '2026-10-29 18:03:09'),
(151, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'jiji', 'attachments/2026/10/65/498/ps66dc2urHKhL5bSownI43IXDB7h34cyW0wtOGBi.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:12:13', '2026-10-29 18:03:09'),
(152, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'jiji', 'attachments/2026/10/65/498/lR3UbR21Kmddq066NQl0tWDXl5HRqMLPGiQ9Dr41.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:12:14', '2026-10-29 18:03:09'),
(153, 65, 498, NULL, NULL, NULL, 'AFFIDAVIT  OF LOSS CARL DEALA.pdf', 'jiji', 'attachments/2026/10/65/498/PIl38jB8KU1FPQJsGqp125jcZMY5S2wKP6rVbXFn.pdf', 'local', 'application/pdf', 440807, 1, '2026-10-28 00:12:14', '2026-10-29 18:03:09'),
(154, 65, 498, NULL, NULL, NULL, 'AFFIDAVIT OF LOSS.pdf', 'jiji', 'attachments/2026/10/65/498/KBesR19JgOn1z7g9mgdGzFJAB5MtHZjZIHvKdaBS.pdf', 'local', 'application/pdf', 325045, 1, '2026-10-28 00:12:15', '2026-10-29 18:03:09'),
(155, 65, 498, NULL, NULL, NULL, 'ANNUAL MEMBERSHIP TO THE ETRACS SUSTAINABILITY PROGRAM FOR THE CITY GOV.pdf', 'jiji', 'attachments/2026/10/65/498/BaJHpjdlIEltSkGcPmM6LuuXIX29VYjYhgA2JFHI.pdf', 'local', 'application/pdf', 248246, 1, '2026-10-28 00:12:16', '2026-10-29 18:03:09'),
(156, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'kkjikh', 'attachments/2026/10/65/498/gVwIaEo6gtNgCN0kCcaBGWYQptvbCen1yCtfM9Aq.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:13:02', '2026-10-29 18:03:09'),
(157, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'kkjikh', 'attachments/2026/10/65/498/NZPerqxF26c3Aiy9XeggZjam1GOd7p5eULwl7nKI.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:13:03', '2026-10-29 18:03:09'),
(158, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'kkjikh', 'attachments/2026/10/65/498/jkHRfDYLmMYK3BNXrj54P3SLER9gDtbHkaMhcck1.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:13:04', '2026-10-29 18:03:09'),
(159, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'kkjikh', 'attachments/2026/10/65/498/vogtfu28pgqj6ckFFieeJAdl6NdXthVyeC90Az35.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:13:04', '2026-10-29 18:03:09'),
(160, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'kkjikh', 'attachments/2026/10/65/498/MuZpCyXTwGh1kzadHAqRUjs8UxEuhHc96Kt2IwXq.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:13:05', '2026-10-29 18:03:09'),
(161, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'kkjikh', 'attachments/2026/10/65/498/ivmqJZi9SXdKDeb9ZcKvx8n5dunSJwegY9Os7qfB.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:13:06', '2026-10-29 18:03:09'),
(162, 65, 498, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'sxadw', 'attachments/2026/10/65/498/BlZDI05Iedyu04z6iPoVecKALiEnyRQHMX0xIYvb.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-28 00:20:19', '2026-10-29 18:03:09'),
(163, 65, 498, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'sxadw', 'attachments/2026/10/65/498/FxIagIaAkg6JTzPudZ3Cts1a2jglLNJgSXQ4UHYZ.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-28 00:20:20', '2026-10-29 18:03:09'),
(164, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'sxadw', 'attachments/2026/10/65/498/DNPJuiisDhjz5UCVmY2RTlSXzM4gftBN9aijJhZR.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-28 00:20:20', '2026-10-29 18:03:09'),
(165, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'sxadw', 'attachments/2026/10/65/498/cor8uUJYKaj4eIPHBaWF5wpeaYvFdIqeqmwECV2b.pdf', 'local', 'application/pdf', 385033, 1, '2026-10-28 00:20:21', '2026-10-29 18:03:09'),
(166, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'sxadw', 'attachments/2026/10/65/498/LVs9AF1CTyIWJgRLZxbDUBkVreRpr1tGVZGIqG0L.pdf', 'local', 'application/pdf', 470731, 1, '2026-10-28 00:20:22', '2026-10-29 18:03:09'),
(167, 65, 498, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'sxadw', 'attachments/2026/10/65/498/XobzXinH4Zazw2eouISIxH5DgFtvPLMmEHLtmYA0.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-28 00:20:23', '2026-10-29 18:03:09'),
(168, 65, 498, NULL, NULL, NULL, 'AFFIDAVIT  OF LOSS CARL DEALA.pdf', 'sxadw', 'attachments/2026/10/65/498/tunSGvbkf2lEoOLuC1gpwqLrqxiXjSlXTnYPzfzb.pdf', 'local', 'application/pdf', 440807, 1, '2026-10-28 00:20:24', '2026-10-29 18:03:09'),
(169, 65, 498, 238, NULL, 255, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/65/498/0hzE6pQ0e5z9APOcwBuIqtpCXV2N9ol2hbComIKQ.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 18:02:22', '2026-10-29 18:03:09'),
(170, 65, 498, 241, NULL, 255, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/65/498/VSUQiMH1tSx8UI91K3PVdzNWqvdwpA0AfBw4alLA.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 18:02:29', '2026-10-29 18:03:09'),
(171, 65, 498, 236, NULL, 255, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/65/498/LNVlidmRkJ7aPwG45e7gnRr2muZR9GjVhocjMfSA.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 18:02:36', '2026-10-29 18:03:09'),
(178, 66, 498, 238, NULL, 257, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/66/498/mUthOImyipMUy4EpZ2Y8OXyjWxlpVfmWgyPgq4Ka.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 19:25:10', '2026-10-29 19:25:42'),
(179, 66, 498, 241, NULL, 257, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/66/498/Owuxz39AlX4F8CgwUFOGjysYdViVETWLeW2JxStM.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 19:25:19', '2026-10-29 19:25:42'),
(180, 66, 498, 236, NULL, 257, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/66/498/RPdmuiPujEZHepNOa6pknj32SuRBNiUITIKeryTN.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-29 19:25:23', '2026-10-29 19:25:42'),
(181, 66, 498, NULL, NULL, 257, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'new', 'attachments/2026/10/66/498/TkliK8r3VHYfC5cHBnlKRiZ7pxbFMUTIyULuvPIc.pdf', 'local', 'application/pdf', 8594822, 1, '2026-10-29 19:25:36', '2026-10-29 19:25:42'),
(182, 66, 499, 237, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', NULL, 'attachments/2026/10/66/499/RF5TL2osaR2spY3FeSDldwaEzPhWSqCiGepvBEil.pdf', 'local', 'application/pdf', 483163, 1, '2026-10-30 00:43:43', '2026-10-30 00:43:43'),
(183, 66, 499, 239, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', NULL, 'attachments/2026/10/66/499/beTSWIkJLZDFpfGcKxtRyaxU3amK6AAeVLhM1ToR.pdf', 'local', 'application/pdf', 1418894, 1, '2026-10-31 08:12:05', '2026-10-31 08:12:05'),
(184, 66, 499, 239, NULL, NULL, 'Screenshot (9).png', NULL, 'attachments/2026/10/66/499/cZp3J1aTXDbIxc4wvpRVxDdGDkuyQ1kZmzL4Svwg.png', 'local', 'image/png', 3363318, 1, '2026-10-31 08:12:13', '2026-10-31 08:12:13'),
(185, 66, 499, 239, NULL, NULL, 'Fix_boy_shouting_sound_66a0d00c.mp4', NULL, 'attachments/2026/10/66/499/dZ2JomReECy0ecC5AsWBthGun3d76LYXB4mELgpq.mp4', 'local', 'video/mp4', 3337891, 1, '2026-10-31 08:12:24', '2026-10-31 08:12:24'),
(187, 66, 499, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'wadawd', 'attachments/2026/11/66/499/EKLfchI6cchtUhwPpTKBw5GuvGe3BzqM7VNzBYlM.pdf', 'local', 'application/pdf', 584366, 1, '2026-11-02 17:24:45', '2026-11-02 17:24:45'),
(188, 66, 499, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'wadawd', 'attachments/2026/11/66/499/5nl4PaXlmADm3hVVeCwMrxWoe7RNS0k6TIDFeqES.pdf', 'local', 'application/pdf', 1418894, 1, '2026-11-02 17:24:46', '2026-11-02 17:24:46'),
(189, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'wadawd', 'attachments/2026/11/66/499/6hRwZt1WEapAwYVDezcbo5WqU3wWaYQNng8skAzY.pdf', 'local', 'application/pdf', 483163, 1, '2026-11-02 17:24:46', '2026-11-02 17:24:46'),
(190, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'wadawd', 'attachments/2026/11/66/499/0JXmL64Joew9YwU5KiKv9E5CiqHDgukHSu5IoINZ.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-02 17:24:47', '2026-11-02 17:24:47'),
(191, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'wadawd', 'attachments/2026/11/66/499/7YHu2GUb6zXwl7JGGAobDS8PHRNQe2DuVBRoHPQ4.pdf', 'local', 'application/pdf', 470731, 1, '2026-11-02 17:24:47', '2026-11-02 17:24:47'),
(192, 66, 499, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'dddd', 'attachments/2026/11/66/499/6bR54WO9pteU0BA53Tsj6i0KhLyb6MN6refUUbAH.pdf', 'local', 'application/pdf', 584366, 1, '2026-11-02 17:24:59', '2026-11-02 17:24:59'),
(193, 66, 499, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'dddd', 'attachments/2026/11/66/499/cmay7g2v0lhDPB5gLnfgUC5MgxOdduOOwZgo5UFr.pdf', 'local', 'application/pdf', 1418894, 1, '2026-11-02 17:25:00', '2026-11-02 17:25:00'),
(194, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'dddd', 'attachments/2026/11/66/499/7ki8fdklqoDZpL398xcGbJLmbFBY40FHe6nTozRg.pdf', 'local', 'application/pdf', 483163, 1, '2026-11-02 17:25:00', '2026-11-02 17:25:00'),
(195, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'dddd', 'attachments/2026/11/66/499/Us6KvMq57aLpeql5wHcI49ijiaxSWOBVogdNMWjh.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-02 17:25:01', '2026-11-02 17:25:01'),
(196, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'dddd', 'attachments/2026/11/66/499/D9cfozdezxANJhVyVyrbhw3iKd0KPmIa3WNVSkCj.pdf', 'local', 'application/pdf', 470731, 1, '2026-11-02 17:25:01', '2026-11-02 17:25:01'),
(197, 66, 499, NULL, NULL, NULL, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'awdaw', 'attachments/2026/11/66/499/y16W3BkMLUsz2OARjMn0tANksFU5xjCSDFUwZXU8.pdf', 'local', 'application/pdf', 584366, 1, '2026-11-02 17:46:47', '2026-11-02 17:46:47'),
(198, 66, 499, NULL, NULL, NULL, '2025 ANNUAL INCOME TAX RETURN INFORMERCIAL THROUGH AVAILABLE MEDIA PLATFORMS.pdf', 'awdaw', 'attachments/2026/11/66/499/NLdlOx2jsyioHLT4QXyzEDjaXTPHXBpuBhDQ0ekx.pdf', 'local', 'application/pdf', 1418894, 1, '2026-11-02 17:46:47', '2026-11-02 17:46:47'),
(199, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', 'awdaw', 'attachments/2026/11/66/499/gVKf5GG8Q5UBklhSEZbtd0gvlHkmCSkO4mySl5zd.pdf', 'local', 'application/pdf', 483163, 1, '2026-11-02 17:46:48', '2026-11-02 17:46:48'),
(200, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'awdaw', 'attachments/2026/11/66/499/26f2sT9OmJPs4KqiaXGGNzqJVSAWPo7yFfXS5Zev.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-02 17:46:48', '2026-11-02 17:46:48'),
(201, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', 'awdaw', 'attachments/2026/11/66/499/83d50S7aFrQ2VL0fttJMeJw6gncDqUTZMq3FMFFa.pdf', 'local', 'application/pdf', 470731, 1, '2026-11-02 17:46:49', '2026-11-02 17:46:49'),
(202, 66, 499, NULL, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'awdaw', 'attachments/2026/11/66/499/H0zsWgF93d3d0ulzIPTmqueek3mN10u1v6ybZbD4.pdf', 'local', 'application/pdf', 8594822, 1, '2026-11-02 17:46:51', '2026-11-02 17:46:51'),
(203, 66, 499, NULL, NULL, NULL, 'AFFIDAVIT  OF LOSS CARL DEALA.pdf', 'awdaw', 'attachments/2026/11/66/499/Rp5NXY1Ijkfhvk8X2j4GhMa7TsOrQCUV3Yxj5RrC.pdf', 'local', 'application/pdf', 440807, 1, '2026-11-02 17:46:52', '2026-11-02 17:46:52'),
(204, 66, 499, NULL, NULL, NULL, 'AFFIDAVIT OF LOSS.pdf', 'awdaw', 'attachments/2026/11/66/499/i39CdtBMKdqrpL3lXsz9NB3CTlh9tfMTsekj9a5X.pdf', 'local', 'application/pdf', 325045, 1, '2026-11-02 17:46:52', '2026-11-02 17:46:52'),
(205, 65, 499, 237, 171, 258, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/65/498/LNVlidmRkJ7aPwG45e7gnRr2muZR9GjVhocjMfSA.pdf', 'local', 'application/pdf', 584366, 1, '2026-11-04 23:21:49', '2026-11-04 23:22:09'),
(206, 65, 499, 239, 171, 258, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', NULL, 'attachments/2026/10/65/498/LNVlidmRkJ7aPwG45e7gnRr2muZR9GjVhocjMfSA.pdf', 'local', 'application/pdf', 584366, 1, '2026-11-04 23:21:52', '2026-11-04 23:22:09'),
(207, 65, 500, 242, NULL, NULL, 'ACCEPTANCE AND INSPECTIO REPORT  LENIN COMPUTER SYSTEMS.pdf', NULL, 'attachments/2026/11/65/500/ytjeRMZmFLzrGqzO3AdGfxoYIgS9sySge7MrssBG.pdf', 'local', 'application/pdf', 483163, 1, '2026-11-04 23:22:31', '2026-11-04 23:22:31'),
(208, 53, 74, 32, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', NULL, 'attachments/2026/11/53/74/EovZvDhrJwerYzhx3pH8hbdcmJb5BZjSilWuevwj.pdf', 'local', 'application/pdf', 470731, 1, '2026-11-04 23:23:06', '2026-11-04 23:23:06');

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
(1, 20, 1, NULL, 1, '2026-09-22 11:32:03', '2026-09-22 11:32:03', '2026-09-22 11:32:03'),
(2, 20, 1, NULL, 1, '2026-09-22 11:32:05', '2026-09-22 11:32:05', '2026-09-22 11:32:05'),
(3, 21, 38, NULL, 1, '2026-09-23 09:28:34', '2026-09-23 09:28:34', '2026-09-23 09:28:34'),
(4, 22, 2, 14, 1, '2026-09-24 10:57:51', '2026-09-24 10:57:51', '2026-09-24 10:57:51'),
(6, 22, 2, 15, 1, '2026-09-24 10:57:57', '2026-09-24 10:57:57', '2026-09-24 10:57:57'),
(7, 28, 73, 17, 1, '2026-09-25 17:05:19', '2026-09-25 17:05:19', '2026-09-25 17:05:19'),
(8, 28, 73, 18, 1, '2026-09-25 17:05:20', '2026-09-25 17:05:20', '2026-09-25 17:05:20'),
(10, 31, 73, 17, 1, '2026-09-28 13:21:24', '2026-09-28 13:21:24', '2026-09-28 13:21:24'),
(11, 31, 73, 18, 1, '2026-09-28 13:21:25', '2026-09-28 13:21:25', '2026-09-28 13:21:25'),
(12, 24, 39, 16, 1, '2026-09-28 14:21:58', '2026-09-28 14:21:58', '2026-09-28 14:21:58'),
(33, 35, 73, 17, 1, '2026-09-29 16:14:38', '2026-09-29 16:14:38', '2026-09-29 16:14:38'),
(34, 35, 73, 18, 1, '2026-09-29 16:14:39', '2026-09-29 16:14:39', '2026-09-29 16:14:39'),
(35, 35, 73, 20, 1, '2026-09-29 16:14:40', '2026-09-29 16:14:40', '2026-09-29 16:14:40'),
(36, 35, 73, 21, 1, '2026-09-29 16:14:41', '2026-09-29 16:14:41', '2026-09-29 16:14:41'),
(37, 37, 385, 35, 1, '2026-09-29 17:17:52', '2026-09-29 17:17:52', '2026-09-29 17:17:52'),
(38, 37, 385, 36, 1, '2026-09-29 17:17:53', '2026-09-29 17:17:53', '2026-09-29 17:17:53'),
(39, 37, 386, 38, 1, '2026-09-29 17:19:44', '2026-09-29 17:19:44', '2026-09-29 17:19:44'),
(40, 37, 387, 39, 1, '2026-09-29 17:20:06', '2026-09-29 17:20:06', '2026-09-29 17:20:06'),
(41, 37, 388, 43, 1, '2026-09-29 17:20:34', '2026-09-29 17:20:34', '2026-09-29 17:20:34'),
(42, 37, 389, 42, 1, '2026-09-29 17:20:58', '2026-09-29 17:20:58', '2026-09-29 17:20:58'),
(43, 37, 390, 44, 1, '2026-09-29 17:21:16', '2026-09-29 17:21:16', '2026-09-29 17:21:16'),
(44, 38, 393, 45, 1, '2026-09-29 17:31:34', '2026-09-29 17:31:34', '2026-09-29 17:31:34'),
(45, 38, 393, 46, 1, '2026-09-29 17:31:35', '2026-09-29 17:31:35', '2026-09-29 17:31:35'),
(46, 38, 394, 47, 1, '2026-09-29 17:31:53', '2026-09-29 17:31:53', '2026-09-29 17:31:53'),
(47, 38, 395, 48, 1, '2026-09-29 17:32:08', '2026-09-29 17:32:08', '2026-09-29 17:32:08'),
(48, 38, 396, 49, 1, '2026-09-29 17:32:24', '2026-09-29 17:32:24', '2026-09-29 17:32:24'),
(49, 38, 397, 50, 1, '2026-09-29 17:44:08', '2026-09-29 17:44:08', '2026-09-29 17:44:08'),
(50, 38, 398, 51, 1, '2026-09-29 17:44:23', '2026-09-29 17:44:23', '2026-09-29 17:44:23'),
(51, 39, 393, 45, 1, '2026-09-29 17:47:33', '2026-09-29 17:47:33', '2026-09-29 17:47:33'),
(52, 39, 393, 46, 1, '2026-09-29 17:47:35', '2026-09-29 17:47:35', '2026-09-29 17:47:35'),
(53, 40, 393, 45, 1, '2026-10-01 16:12:29', '2026-10-01 16:12:29', '2026-10-01 16:12:29'),
(54, 40, 393, 46, 1, '2026-10-01 16:12:30', '2026-10-01 16:12:30', '2026-10-01 16:12:30'),
(58, 53, 73, 20, 1, '2026-10-19 11:52:29', '2026-10-19 11:52:29', '2026-10-19 11:52:29'),
(59, 53, 73, 17, 1, '2026-10-19 11:52:30', '2026-10-19 11:52:30', '2026-10-19 11:52:30'),
(60, 53, 73, 18, 1, '2026-10-19 11:52:31', '2026-10-19 11:52:31', '2026-10-19 11:52:31'),
(61, 59, 460, 110, 42, '2026-10-21 13:57:49', '2026-10-21 13:57:49', '2026-10-21 13:57:49'),
(62, 59, 460, 111, 42, '2026-10-21 13:57:50', '2026-10-21 13:57:50', '2026-10-21 13:57:50'),
(64, 61, 460, 110, 42, '2026-10-22 14:01:19', '2026-10-22 14:01:19', '2026-10-22 14:01:19'),
(65, 61, 460, 111, 42, '2026-10-22 14:01:21', '2026-10-22 14:01:21', '2026-10-22 14:01:21'),
(66, 61, 461, 112, 40, '2026-10-22 14:04:30', '2026-10-22 14:04:30', '2026-10-22 14:04:30'),
(67, 59, 461, 112, 40, '2026-10-22 15:03:15', '2026-10-22 15:03:15', '2026-10-22 15:03:15'),
(68, 65, 499, 166, 1, '2026-10-29 18:03:27', '2026-10-29 18:03:27', '2026-10-29 18:03:27'),
(69, 65, 499, 168, 1, '2026-10-29 18:03:29', '2026-10-29 18:03:29', '2026-10-29 18:03:29'),
(70, 66, 499, 166, 1, '2026-10-29 19:25:50', '2026-10-29 19:25:50', '2026-10-29 19:25:50'),
(72, 66, 499, 168, 1, '2026-10-29 19:42:25', '2026-10-29 19:42:25', '2026-10-29 19:42:25'),
(73, 65, 500, 164, 1, '2026-11-04 23:22:17', '2026-11-04 23:22:17', '2026-11-04 23:22:17'),
(74, 65, 500, 165, 1, '2026-11-04 23:22:17', '2026-11-04 23:22:17', '2026-11-04 23:22:17'),
(75, 53, 74, 22, 1, '2026-11-04 23:22:49', '2026-11-04 23:22:49', '2026-11-04 23:22:49'),
(76, 53, 74, 19, 1, '2026-11-04 23:22:50', '2026-11-04 23:22:50', '2026-11-04 23:22:50');

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
(4, 9, 38, 23, 1, '2026-09-13 11:36:34', '2026-09-13 11:36:34', '2026-09-13 11:36:34'),
(6, 9, 39, 19, 1, '2026-09-13 12:32:29', '2026-09-13 12:32:29', '2026-09-13 12:32:29'),
(7, 12, 70, 25, 1, '2026-09-13 15:04:43', '2026-09-13 15:04:43', '2026-09-13 15:04:43'),
(8, 12, 71, 26, 1, '2026-09-13 15:04:52', '2026-09-13 15:04:52', '2026-09-13 15:04:52'),
(9, 14, 1, 27, 1, '2026-09-13 16:16:35', '2026-09-13 16:16:35', '2026-09-13 16:16:35'),
(10, 14, 2, 28, 1, '2026-09-13 16:39:08', '2026-09-13 16:39:08', '2026-09-13 16:39:08'),
(11, 14, 3, 29, 1, '2026-09-13 16:42:21', '2026-09-13 16:42:21', '2026-09-13 16:42:21'),
(14, 15, 1, 27, 1, '2026-09-15 11:19:12', '2026-09-15 11:19:12', '2026-09-15 11:19:12'),
(15, 15, 2, 28, 1, '2026-09-15 11:19:53', '2026-09-15 11:19:53', '2026-09-15 11:19:53'),
(26, 9, 40, 20, 1, '2026-09-20 09:04:48', '2026-09-20 09:04:48', '2026-09-20 09:04:48'),
(31, 17, 38, 23, 1, '2026-09-20 11:30:46', '2026-09-20 11:30:46', '2026-09-20 11:30:46'),
(32, 17, 39, 19, 1, '2026-09-20 11:32:01', '2026-09-20 11:32:01', '2026-09-20 11:32:01'),
(33, 17, 40, 20, 1, '2026-09-20 14:12:24', '2026-09-20 14:12:24', '2026-09-20 14:12:24'),
(34, 18, 38, 23, 1, '2026-09-21 09:18:33', '2026-09-21 09:18:33', '2026-09-21 09:18:33'),
(35, 18, 39, 19, 1, '2026-09-21 09:21:44', '2026-09-21 09:21:44', '2026-09-21 09:21:44'),
(37, 18, 42, 22, 1, '2026-09-21 09:26:20', '2026-09-21 09:26:20', '2026-09-21 09:26:20'),
(46, 18, 40, 20, 1, '2026-09-21 15:15:29', '2026-09-21 15:15:29', '2026-09-21 15:15:29'),
(47, 16, 1, 27, 1, '2026-09-21 15:29:55', '2026-09-21 15:29:55', '2026-09-21 15:29:55'),
(48, 16, 2, 28, 1, '2026-09-21 15:30:09', '2026-09-21 15:30:09', '2026-09-21 15:30:09'),
(49, 19, 1, 27, 1, '2026-09-22 10:39:09', '2026-09-22 10:39:09', '2026-09-22 10:39:09'),
(94, 32, 72, 37, 1, '2026-09-29 15:15:41', '2026-09-29 15:15:41', '2026-09-29 15:15:41'),
(95, 32, 72, 30, 1, '2026-09-29 15:15:47', '2026-09-29 15:15:47', '2026-09-29 15:15:47'),
(96, 32, 72, 38, 1, '2026-09-29 15:15:48', '2026-09-29 15:15:48', '2026-09-29 15:15:48'),
(97, 32, 72, 35, 1, '2026-09-29 15:15:48', '2026-09-29 15:15:48', '2026-09-29 15:15:48'),
(98, 35, 72, 30, 1, '2026-09-29 16:13:43', '2026-09-29 16:13:43', '2026-09-29 16:13:43'),
(99, 35, 72, 37, 1, '2026-09-29 16:13:44', '2026-09-29 16:13:44', '2026-09-29 16:13:44'),
(100, 35, 72, 38, 1, '2026-09-29 16:13:45', '2026-09-29 16:13:45', '2026-09-29 16:13:45'),
(101, 35, 72, 35, 1, '2026-09-29 16:13:46', '2026-09-29 16:13:46', '2026-09-29 16:13:46'),
(103, 35, 73, 31, 1, '2026-09-29 16:14:45', '2026-09-29 16:14:45', '2026-09-29 16:14:45'),
(104, 35, 73, 39, 1, '2026-09-29 16:16:27', '2026-09-29 16:16:27', '2026-09-29 16:16:27'),
(105, 37, 384, 56, 1, '2026-09-29 17:17:37', '2026-09-29 17:17:37', '2026-09-29 17:17:37'),
(106, 37, 384, 55, 1, '2026-09-29 17:17:38', '2026-09-29 17:17:38', '2026-09-29 17:17:38'),
(107, 37, 385, 58, 1, '2026-09-29 17:17:57', '2026-09-29 17:17:57', '2026-09-29 17:17:57'),
(108, 37, 386, 59, 1, '2026-09-29 17:19:48', '2026-09-29 17:19:48', '2026-09-29 17:19:48'),
(109, 37, 387, 64, 1, '2026-09-29 17:20:13', '2026-09-29 17:20:13', '2026-09-29 17:20:13'),
(110, 37, 388, 62, 1, '2026-09-29 17:20:37', '2026-09-29 17:20:37', '2026-09-29 17:20:37'),
(111, 37, 389, 66, 1, '2026-09-29 17:21:01', '2026-09-29 17:21:01', '2026-09-29 17:21:01'),
(112, 38, 392, 74, 1, '2026-09-29 17:31:20', '2026-09-29 17:31:20', '2026-09-29 17:31:20'),
(113, 38, 392, 73, 1, '2026-09-29 17:31:20', '2026-09-29 17:31:20', '2026-09-29 17:31:20'),
(114, 38, 393, 75, 1, '2026-09-29 17:31:40', '2026-09-29 17:31:40', '2026-09-29 17:31:40'),
(115, 38, 394, 76, 1, '2026-09-29 17:31:58', '2026-09-29 17:31:58', '2026-09-29 17:31:58'),
(116, 38, 395, 70, 1, '2026-09-29 17:32:12', '2026-09-29 17:32:12', '2026-09-29 17:32:12'),
(117, 38, 396, 71, 1, '2026-09-29 17:32:27', '2026-09-29 17:32:27', '2026-09-29 17:32:27'),
(118, 38, 397, 68, 1, '2026-09-29 17:44:14', '2026-09-29 17:44:14', '2026-09-29 17:44:14'),
(119, 38, 398, 77, 1, '2026-09-29 17:44:26', '2026-09-29 17:44:26', '2026-09-29 17:44:26'),
(120, 39, 392, 74, 1, '2026-09-29 17:46:32', '2026-09-29 17:46:32', '2026-09-29 17:46:32'),
(121, 39, 392, 73, 1, '2026-09-29 17:46:34', '2026-09-29 17:46:34', '2026-09-29 17:46:34'),
(122, 39, 393, 75, 1, '2026-09-29 17:47:59', '2026-09-29 17:47:59', '2026-09-29 17:47:59'),
(123, 40, 392, 74, 1, '2026-09-30 09:07:56', '2026-09-30 09:07:56', '2026-09-30 09:07:56'),
(124, 40, 392, 73, 1, '2026-09-30 09:07:57', '2026-09-30 09:07:57', '2026-09-30 09:07:57'),
(125, 40, 393, 75, 1, '2026-10-01 16:12:33', '2026-10-01 16:12:33', '2026-10-01 16:12:33'),
(140, 49, 416, 107, 10, '2026-10-16 11:30:09', '2026-10-16 11:30:09', '2026-10-16 11:30:09'),
(141, 49, 416, 104, 10, '2026-10-16 11:30:10', '2026-10-16 11:30:10', '2026-10-16 11:30:10'),
(142, 50, 72, 37, 10, '2026-10-16 11:38:09', '2026-10-16 11:38:09', '2026-10-16 11:38:09'),
(143, 50, 72, 30, 10, '2026-10-16 11:38:12', '2026-10-16 11:38:12', '2026-10-16 11:38:12'),
(145, 51, 38, 23, 10, '2026-10-16 11:41:00', '2026-10-16 11:41:00', '2026-10-16 11:41:00'),
(146, 52, 416, 107, 10, '2026-10-16 11:44:31', '2026-10-16 11:44:31', '2026-10-16 11:44:31'),
(147, 52, 416, 104, 10, '2026-10-16 11:44:32', '2026-10-16 11:44:32', '2026-10-16 11:44:32'),
(148, 53, 72, 37, 1, '2026-10-19 10:26:04', '2026-10-19 10:26:04', '2026-10-19 10:26:04'),
(149, 53, 72, 30, 1, '2026-10-19 10:26:05', '2026-10-19 10:26:05', '2026-10-19 10:26:05'),
(150, 53, 73, 31, 1, '2026-10-19 11:52:35', '2026-10-19 11:52:35', '2026-10-19 11:52:35'),
(151, 53, 73, 39, 1, '2026-10-19 11:52:36', '2026-10-19 11:52:36', '2026-10-19 11:52:36'),
(152, 59, 459, 174, 59, '2026-10-21 13:56:10', '2026-10-21 13:56:10', '2026-10-21 13:56:10'),
(153, 59, 459, 171, 59, '2026-10-21 13:56:10', '2026-10-21 13:56:10', '2026-10-21 13:56:10'),
(154, 59, 460, 175, 42, '2026-10-21 13:57:54', '2026-10-21 13:57:54', '2026-10-21 13:57:54'),
(155, 61, 459, 171, 59, '2026-10-22 13:58:34', '2026-10-22 13:58:34', '2026-10-22 13:58:34'),
(156, 61, 459, 174, 59, '2026-10-22 13:58:35', '2026-10-22 13:58:35', '2026-10-22 13:58:35'),
(157, 61, 460, 175, 42, '2026-10-22 14:01:28', '2026-10-22 14:01:28', '2026-10-22 14:01:28'),
(158, 61, 461, 176, 40, '2026-10-22 14:04:34', '2026-10-22 14:04:34', '2026-10-22 14:04:34'),
(160, 59, 461, 176, 40, '2026-10-22 15:03:21', '2026-10-22 15:03:21', '2026-10-22 15:03:21'),
(179, 63, 459, 174, 1, '2026-10-29 17:57:49', '2026-10-29 17:57:49', '2026-10-29 17:57:49'),
(180, 63, 459, 171, 1, '2026-10-29 17:57:52', '2026-10-29 17:57:52', '2026-10-29 17:57:52'),
(185, 65, 498, 238, 1, '2026-10-29 18:02:07', '2026-10-29 18:02:07', '2026-10-29 18:02:07'),
(186, 65, 498, 241, 1, '2026-10-29 18:02:24', '2026-10-29 18:02:24', '2026-10-29 18:02:24'),
(190, 66, 498, 238, 1, '2026-10-29 19:25:04', '2026-10-29 19:25:04', '2026-10-29 19:25:04'),
(191, 66, 498, 241, 1, '2026-10-29 19:25:11', '2026-10-29 19:25:11', '2026-10-29 19:25:11'),
(192, 66, 499, 237, 1, '2026-10-30 00:43:35', '2026-10-30 00:43:35', '2026-10-30 00:43:35'),
(193, 66, 499, 239, 1, '2026-10-31 08:11:53', '2026-10-31 08:11:53', '2026-10-31 08:11:53'),
(194, 65, 499, 237, 1, '2026-11-04 23:21:43', '2026-11-04 23:21:43', '2026-11-04 23:21:43'),
(195, 65, 499, 239, 1, '2026-11-04 23:21:45', '2026-11-04 23:21:45', '2026-11-04 23:21:45'),
(196, 65, 500, 242, 1, '2026-11-04 23:22:23', '2026-11-04 23:22:23', '2026-11-04 23:22:23'),
(197, 53, 74, 32, 1, '2026-11-04 23:22:54', '2026-11-04 23:22:54', '2026-11-04 23:22:54');

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
(1, 1, 19, '2026-03-09 15:53:29', '2026-03-09 15:51:48', '2026-03-09 15:53:29'),
(2, 2, 19, '2026-03-09 15:57:11', '2026-03-09 15:57:06', '2026-03-09 15:57:11'),
(3, 3, 20, '2026-03-09 16:00:39', '2026-03-09 15:57:31', '2026-03-09 16:00:39'),
(4, 4, 21, '2026-03-09 16:32:33', '2026-03-09 16:32:03', '2026-03-09 16:32:33'),
(5, 5, 20, '2026-09-11 08:50:34', '2026-09-11 08:50:34', '2026-09-11 08:50:34'),
(9, 9, 42, '2026-09-21 08:54:14', '2026-09-11 14:24:51', '2026-09-21 08:54:14'),
(10, 10, 20, '2026-09-13 14:42:14', '2026-09-13 14:42:14', '2026-09-13 14:42:14'),
(11, 11, 38, '2026-09-13 14:48:16', '2026-09-13 14:48:16', '2026-09-13 14:48:16'),
(12, 12, 71, '2026-09-13 15:04:47', '2026-09-13 14:48:28', '2026-09-13 15:04:47'),
(13, 13, 1, '2026-09-20 10:09:46', '2026-09-13 14:48:43', '2026-09-20 10:09:46'),
(14, 14, 3, '2026-09-13 16:39:23', '2026-09-13 16:13:33', '2026-09-13 16:39:23'),
(15, 15, 3, '2026-09-21 15:48:17', '2026-09-15 11:18:48', '2026-09-21 15:48:17'),
(16, 16, 3, '2026-09-21 15:30:10', '2026-09-20 09:09:18', '2026-09-21 15:30:10'),
(17, 17, 40, '2026-09-20 11:32:50', '2026-09-20 11:10:13', '2026-09-20 11:32:50'),
(18, 18, 38, '2026-09-21 15:25:43', '2026-09-21 09:15:15', '2026-09-21 15:25:43'),
(19, 19, 1, '2026-09-22 10:12:24', '2026-09-22 10:12:24', '2026-09-22 10:12:24'),
(20, 20, 1, '2026-09-22 10:42:49', '2026-09-22 10:42:49', '2026-09-22 10:42:49'),
(21, 21, 38, '2026-09-23 09:25:08', '2026-09-23 09:25:08', '2026-09-23 09:25:08'),
(22, 22, 1, '2026-09-24 10:58:43', '2026-09-24 10:50:22', '2026-09-24 10:58:43'),
(23, 23, 38, '2026-09-24 11:18:37', '2026-09-24 11:18:37', '2026-09-24 11:18:37'),
(24, 24, 39, '2026-09-25 14:25:55', '2026-09-24 11:22:47', '2026-09-25 14:25:55'),
(26, 26, 209, '2026-09-25 16:40:39', '2026-09-25 15:18:46', '2026-09-25 16:40:39'),
(27, 27, 202, '2026-09-27 14:12:19', '2026-09-25 16:46:46', '2026-09-27 14:12:19'),
(28, 28, 74, '2026-09-25 17:05:21', '2026-09-25 17:01:06', '2026-09-25 17:05:21'),
(29, 29, 238, '2026-09-28 09:00:07', '2026-09-27 14:17:39', '2026-09-28 09:00:07'),
(30, 30, 73, '2026-09-28 10:46:28', '2026-09-28 10:45:58', '2026-09-28 10:46:28'),
(31, 31, 73, '2026-09-28 13:20:46', '2026-09-28 10:51:58', '2026-09-28 13:20:46'),
(32, 32, 73, '2026-09-29 15:55:22', '2026-09-28 13:33:30', '2026-09-29 15:55:22'),
(33, 33, 259, '2026-09-29 15:25:53', '2026-09-29 15:25:53', '2026-09-29 15:25:53'),
(34, 34, 268, '2026-09-29 15:28:31', '2026-09-29 15:28:31', '2026-09-29 15:28:31'),
(35, 35, 74, '2026-09-29 17:30:00', '2026-09-29 16:12:36', '2026-09-29 17:30:00'),
(36, 36, 328, '2026-09-29 16:54:47', '2026-09-29 16:54:47', '2026-09-29 16:54:47'),
(37, 37, 390, '2026-09-29 17:21:11', '2026-09-29 16:58:33', '2026-09-29 17:21:11'),
(38, 38, 399, '2026-09-29 17:44:32', '2026-09-29 17:31:10', '2026-09-29 17:44:32'),
(39, 39, 394, '2026-09-29 17:49:31', '2026-09-29 17:44:55', '2026-09-29 17:49:31'),
(40, 40, 394, '2026-10-04 09:31:35', '2026-09-30 08:09:17', '2026-10-04 09:31:35'),
(41, 41, 416, '2026-10-04 09:34:21', '2026-10-04 09:34:21', '2026-10-04 09:34:21'),
(49, 49, 417, '2026-10-16 11:30:35', '2026-10-16 11:29:22', '2026-10-16 11:30:35'),
(50, 50, 73, '2026-10-16 11:38:52', '2026-10-16 11:37:24', '2026-10-16 11:38:52'),
(51, 51, 39, '2026-10-16 11:41:08', '2026-10-16 11:40:38', '2026-10-16 11:41:08'),
(52, 52, 417, '2026-10-16 11:44:41', '2026-10-16 11:44:18', '2026-10-16 11:44:41'),
(53, 53, 74, '2026-10-19 11:52:49', '2026-10-19 10:25:54', '2026-10-19 11:52:49'),
(54, 54, 72, '2026-10-19 15:13:46', '2026-10-19 15:13:46', '2026-10-19 15:13:46'),
(55, 55, 416, '2026-10-20 13:05:41', '2026-10-20 13:05:41', '2026-10-20 13:05:41'),
(56, 56, 38, '2026-10-21 13:18:42', '2026-10-21 13:18:42', '2026-10-21 13:18:42'),
(57, 57, 459, '2026-10-21 13:21:41', '2026-10-21 13:21:41', '2026-10-21 13:21:41'),
(58, 58, 459, '2026-10-21 13:23:13', '2026-10-21 13:23:13', '2026-10-21 13:23:13'),
(59, 59, 462, '2026-10-22 15:03:26', '2026-10-21 13:55:58', '2026-10-22 15:03:26'),
(60, 60, 459, '2026-10-22 13:56:00', '2026-10-22 13:56:00', '2026-10-22 13:56:00'),
(61, 61, 462, '2026-10-22 14:04:49', '2026-10-22 13:58:16', '2026-10-22 14:04:49'),
(62, 62, 459, '2026-10-22 14:16:57', '2026-10-22 14:16:57', '2026-10-22 14:16:57'),
(63, 63, 459, '2026-10-22 14:19:11', '2026-10-22 14:19:11', '2026-10-22 14:19:11'),
(64, 64, 424, '2026-10-26 08:25:08', '2026-10-26 08:25:08', '2026-10-26 08:25:08'),
(65, 65, 500, '2026-11-04 23:22:09', '2026-10-27 17:10:47', '2026-11-04 23:22:09'),
(66, 66, 499, '2026-10-29 19:25:42', '2026-10-29 19:24:36', '2026-10-29 19:25:42'),
(67, 67, 475, '2026-11-04 23:46:58', '2026-11-04 23:46:58', '2026-11-04 23:46:58');

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
  `data_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `action_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `flagged_items` json DEFAULT NULL,
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

INSERT INTO `transaction_step_runs` (`id`, `transaction_id`, `from_step_id`, `to_step_id`, `action_code`, `remarks`, `flagged_items`, `performed_by`, `performed_at`, `received_at`, `received_by`, `received_office_id`, `sla_minutes_snapshot`, `created_at`, `updated_at`) VALUES
(1, 1, 18, 18, 'create', 'Transaction created', NULL, 1, '2026-03-09 15:51:48', '2026-03-09 15:51:48', NULL, NULL, 60, '2026-03-09 15:51:48', '2026-03-09 15:51:48'),
(2, 1, 18, 19, 'submit', NULL, NULL, 1, '2026-03-09 15:53:29', '2026-03-09 15:53:29', NULL, NULL, 60, '2026-03-09 15:53:29', '2026-03-09 15:53:29'),
(3, 2, 18, 18, 'create', 'Transaction created', NULL, 1, '2026-03-09 15:57:06', '2026-03-09 15:57:06', NULL, NULL, 60, '2026-03-09 15:57:06', '2026-03-09 15:57:06'),
(4, 2, 18, 19, 'submit', NULL, NULL, 1, '2026-03-09 15:57:11', '2026-03-09 15:57:11', NULL, NULL, 60, '2026-03-09 15:57:11', '2026-03-09 15:57:11'),
(5, 3, 20, 20, 'create', 'Transaction created', NULL, 1, '2026-03-09 15:57:31', '2026-03-09 15:57:31', NULL, NULL, 60, '2026-03-09 15:57:31', '2026-03-09 15:57:31'),
(6, 3, 20, 21, 'submit', NULL, NULL, 1, '2026-03-09 15:57:36', '2026-03-09 15:57:36', NULL, NULL, 60, '2026-03-09 15:57:36', '2026-03-09 15:57:36'),
(7, 3, 21, 20, 'submit', NULL, NULL, 1, '2026-03-09 15:57:39', '2026-03-09 15:57:39', NULL, NULL, 60, '2026-03-09 15:57:40', '2026-03-09 15:57:40'),
(8, 3, 20, 21, 'submit', NULL, NULL, 1, '2026-03-09 15:58:41', '2026-03-09 15:58:41', NULL, NULL, 60, '2026-03-09 15:58:41', '2026-03-09 15:58:41'),
(9, 3, 21, 20, 'submit', NULL, NULL, 1, '2026-03-09 16:00:39', '2026-03-09 16:00:39', NULL, NULL, 60, '2026-03-09 16:00:39', '2026-03-09 16:00:39'),
(10, 4, 20, 20, 'create', 'Transaction created', NULL, 1, '2026-03-09 16:32:03', '2026-03-09 16:32:03', NULL, NULL, 60, '2026-03-09 16:32:03', '2026-03-09 16:32:03'),
(11, 4, 20, 21, 'submit', 'MEMO', NULL, 1, '2026-03-09 16:32:33', '2026-03-09 16:32:33', NULL, NULL, 60, '2026-03-09 16:32:33', '2026-03-09 16:32:33'),
(12, 5, 20, 20, 'create', 'Transaction created', NULL, 1, '2026-09-11 08:50:34', '2026-09-11 08:50:34', NULL, NULL, 60, '2026-09-11 08:50:34', '2026-09-11 08:50:34'),
(16, 9, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-11 14:24:51', '2026-09-11 14:24:51', NULL, NULL, 2880, '2026-09-11 14:24:51', '2026-09-11 14:24:51'),
(17, 9, 38, 39, 'submit', 'wako', NULL, 1, '2026-09-13 11:36:55', '2026-09-13 11:36:55', NULL, NULL, 2880, '2026-09-13 11:36:55', '2026-09-13 11:36:55'),
(18, 9, 39, 40, 'submit', NULL, NULL, 1, '2026-09-13 12:46:56', '2026-09-13 12:46:56', NULL, NULL, 2880, '2026-09-13 12:46:56', '2026-09-13 12:46:56'),
(19, 10, 20, 20, 'create', 'Transaction created', NULL, 1, '2026-09-13 14:42:14', '2026-09-13 14:42:14', NULL, NULL, 60, '2026-09-13 14:42:14', '2026-09-13 14:42:14'),
(20, 11, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-13 14:48:16', '2026-09-13 14:48:16', NULL, NULL, 2880, '2026-09-13 14:48:16', '2026-09-13 14:48:16'),
(21, 12, 70, 70, 'create', 'Transaction created', NULL, 1, '2026-09-13 14:48:28', '2026-09-13 14:48:28', NULL, NULL, 60, '2026-09-13 14:48:28', '2026-09-13 14:48:28'),
(22, 13, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-13 14:48:43', '2026-09-13 14:48:43', NULL, NULL, 2880, '2026-09-13 14:48:43', '2026-09-13 14:48:43'),
(23, 12, 70, 71, 'submit', NULL, NULL, 1, '2026-09-13 15:04:47', '2026-09-13 15:04:47', NULL, NULL, 60, '2026-09-13 15:04:47', '2026-09-13 15:04:47'),
(24, 14, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-13 16:13:33', '2026-09-13 16:13:33', NULL, NULL, 2880, '2026-09-13 16:13:33', '2026-09-13 16:13:33'),
(25, 14, 1, 2, 'submit', NULL, NULL, 1, '2026-09-13 16:22:19', '2026-09-13 16:22:19', NULL, NULL, 2880, '2026-09-13 16:22:19', '2026-09-13 16:22:19'),
(26, 14, 2, 3, 'approve', NULL, NULL, 1, '2026-09-13 16:39:23', '2026-09-13 16:39:23', NULL, NULL, 4320, '2026-09-13 16:39:23', '2026-09-13 16:39:23'),
(27, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 11:18:09', '2026-09-15 11:18:09', NULL, NULL, 2880, '2026-09-15 11:18:09', '2026-09-15 11:18:09'),
(28, 15, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-15 11:18:48', '2026-09-15 11:18:48', NULL, NULL, 2880, '2026-09-15 11:18:48', '2026-09-15 11:18:48'),
(29, 15, 1, 2, 'submit', 'DTR', NULL, 1, '2026-09-15 11:19:31', '2026-09-15 11:19:31', NULL, NULL, 2880, '2026-09-15 11:19:31', '2026-09-15 11:19:31'),
(30, 15, 2, 1, 'return', NULL, NULL, 1, '2026-09-15 11:20:06', '2026-09-15 11:20:06', NULL, NULL, 2880, '2026-09-15 11:20:06', '2026-09-15 11:20:06'),
(31, 15, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 11:25:05', '2026-09-15 11:25:05', NULL, NULL, 2880, '2026-09-15 11:25:05', '2026-09-15 11:25:05'),
(32, 13, 2, 1, 'return', 'ge', NULL, 1, '2026-09-15 11:49:36', '2026-09-15 11:49:36', NULL, NULL, 2880, '2026-09-15 11:49:36', '2026-09-15 11:49:36'),
(33, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 11:52:53', '2026-09-15 11:52:53', NULL, NULL, 2880, '2026-09-15 11:52:53', '2026-09-15 11:52:53'),
(34, 13, 2, 1, 'return', NULL, NULL, 1, '2026-09-15 11:53:25', '2026-09-15 11:53:25', NULL, NULL, 2880, '2026-09-15 11:53:25', '2026-09-15 11:53:25'),
(35, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 11:55:48', '2026-09-15 11:55:48', NULL, NULL, 2880, '2026-09-15 11:55:48', '2026-09-15 11:55:48'),
(36, 13, 2, 1, 'return', NULL, NULL, 1, '2026-09-15 11:55:59', '2026-09-15 11:55:59', NULL, NULL, 2880, '2026-09-15 11:55:59', '2026-09-15 11:55:59'),
(38, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 11:59:35', '2026-09-15 11:59:35', NULL, NULL, 2880, '2026-09-15 11:59:35', '2026-09-15 11:59:35'),
(39, 13, 2, 1, 'return', NULL, NULL, 1, '2026-09-15 11:59:46', '2026-09-15 11:59:46', NULL, NULL, 2880, '2026-09-15 11:59:46', '2026-09-15 11:59:46'),
(41, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-15 12:03:35', '2026-09-15 12:03:35', NULL, NULL, 2880, '2026-09-15 12:03:35', '2026-09-15 12:03:35'),
(42, 13, 2, 1, 'return', NULL, NULL, 1, '2026-09-15 12:03:45', '2026-09-15 12:03:45', NULL, NULL, 2880, '2026-09-15 12:03:45', '2026-09-15 12:03:45'),
(43, 9, 40, 41, 'submit', NULL, NULL, 1, '2026-09-20 09:05:15', '2026-09-20 09:05:15', NULL, NULL, 2880, '2026-09-20 09:05:15', '2026-09-20 09:05:15'),
(44, 16, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-20 09:09:18', '2026-09-20 09:09:18', NULL, NULL, 2880, '2026-09-20 09:09:18', '2026-09-20 09:09:18'),
(45, 13, 1, 2, 'submit', NULL, NULL, 1, '2026-09-20 09:52:22', '2026-09-20 09:52:22', NULL, NULL, 2880, '2026-09-20 09:52:22', '2026-09-20 09:52:22'),
(46, 13, 2, 1, 'return', NULL, NULL, 1, '2026-09-20 10:09:46', '2026-09-20 10:09:46', NULL, NULL, 2880, '2026-09-20 10:09:46', '2026-09-20 10:09:46'),
(47, 17, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-20 11:10:13', '2026-09-20 11:10:13', NULL, NULL, 2880, '2026-09-20 11:10:13', '2026-09-20 11:10:13'),
(48, 17, 38, 39, 'submit', 'awdawdawdawdawdawdwadaw', NULL, 1, '2026-09-20 11:30:52', '2026-09-20 11:30:52', NULL, NULL, 2880, '2026-09-20 11:30:52', '2026-09-20 11:30:52'),
(49, 17, 39, 40, 'submit', NULL, NULL, 1, '2026-09-20 11:32:50', '2026-09-20 11:32:50', NULL, NULL, 2880, '2026-09-20 11:32:50', '2026-09-20 11:32:50'),
(50, 9, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 08:54:14', '2026-09-21 08:54:14', NULL, NULL, 2880, '2026-09-21 08:54:14', '2026-09-21 08:54:14'),
(51, 18, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-21 09:15:15', '2026-09-21 09:15:15', NULL, NULL, 2880, '2026-09-21 09:15:15', '2026-09-21 09:15:15'),
(52, 18, 38, 39, 'submit', NULL, NULL, 1, '2026-09-21 09:18:56', '2026-09-21 09:18:56', NULL, NULL, 2880, '2026-09-21 09:18:56', '2026-09-21 09:18:56'),
(53, 18, 39, 40, 'submit', NULL, NULL, 1, '2026-09-21 09:21:46', '2026-09-21 09:21:46', NULL, NULL, 2880, '2026-09-21 09:21:46', '2026-09-21 09:21:46'),
(54, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 09:22:45', '2026-09-21 09:22:45', NULL, NULL, 2880, '2026-09-21 09:22:45', '2026-09-21 09:22:45'),
(55, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 09:26:00', '2026-09-21 09:26:00', NULL, NULL, 2880, '2026-09-21 09:26:00', '2026-09-21 09:26:00'),
(56, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 09:26:43', '2026-09-21 09:26:43', NULL, NULL, 2880, '2026-09-21 09:26:43', '2026-09-21 09:26:43'),
(57, 18, 43, 40, 'rewind', 'Rewound to past station', NULL, 1, '2026-09-21 10:48:26', '2026-09-21 10:48:26', NULL, NULL, 2880, '2026-09-21 10:48:26', '2026-09-21 10:48:26'),
(58, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 10:48:26', '2026-09-21 10:48:26', NULL, NULL, 2880, '2026-09-21 10:48:26', '2026-09-21 10:48:26'),
(59, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 10:55:28', '2026-09-21 10:55:28', NULL, NULL, 2880, '2026-09-21 10:55:28', '2026-09-21 10:55:28'),
(60, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 10:56:03', '2026-09-21 10:56:03', NULL, NULL, 2880, '2026-09-21 10:56:03', '2026-09-21 10:56:03'),
(61, 18, 43, 40, 'rewind', 'Rewound to past station', NULL, 1, '2026-09-21 10:57:26', '2026-09-21 10:57:26', NULL, NULL, 2880, '2026-09-21 10:57:26', '2026-09-21 10:57:26'),
(62, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 10:57:27', '2026-09-21 10:57:27', NULL, NULL, 2880, '2026-09-21 10:57:27', '2026-09-21 10:57:27'),
(63, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 10:57:39', '2026-09-21 10:57:39', NULL, NULL, 2880, '2026-09-21 10:57:39', '2026-09-21 10:57:39'),
(64, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 10:57:52', '2026-09-21 10:57:52', NULL, NULL, 2880, '2026-09-21 10:57:52', '2026-09-21 10:57:52'),
(65, 18, 43, 38, 'return', 'hay nako', NULL, 1, '2026-09-21 11:04:31', '2026-09-21 11:04:31', NULL, NULL, 2880, '2026-09-21 11:04:31', '2026-09-21 11:04:31'),
(66, 18, 38, 39, 'submit', NULL, NULL, 1, '2026-09-21 11:04:51', '2026-09-21 11:04:51', NULL, NULL, 2880, '2026-09-21 11:04:51', '2026-09-21 11:04:51'),
(67, 18, 39, 40, 'submit', NULL, NULL, 1, '2026-09-21 11:04:57', '2026-09-21 11:04:57', NULL, NULL, 2880, '2026-09-21 11:04:57', '2026-09-21 11:04:57'),
(68, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 11:05:06', '2026-09-21 11:05:06', NULL, NULL, 2880, '2026-09-21 11:05:06', '2026-09-21 11:05:06'),
(69, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 11:05:14', '2026-09-21 11:05:14', NULL, NULL, 2880, '2026-09-21 11:05:14', '2026-09-21 11:05:14'),
(70, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 11:10:05', '2026-09-21 11:10:05', NULL, NULL, 2880, '2026-09-21 11:10:05', '2026-09-21 11:10:05'),
(71, 18, 43, 38, 'return', 'awdawd', NULL, 1, '2026-09-21 13:49:06', '2026-09-21 13:49:06', NULL, NULL, 2880, '2026-09-21 13:49:06', '2026-09-21 13:49:06'),
(72, 18, 38, 39, 'submit', NULL, NULL, 1, '2026-09-21 13:49:22', '2026-09-21 13:49:22', NULL, NULL, 2880, '2026-09-21 13:49:22', '2026-09-21 13:49:22'),
(73, 18, 39, 40, 'submit', NULL, NULL, 1, '2026-09-21 13:49:29', '2026-09-21 13:49:29', NULL, NULL, 2880, '2026-09-21 13:49:29', '2026-09-21 13:49:29'),
(74, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 13:49:38', '2026-09-21 13:49:38', NULL, NULL, 2880, '2026-09-21 13:49:38', '2026-09-21 13:49:38'),
(75, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 13:49:47', '2026-09-21 13:49:47', NULL, NULL, 2880, '2026-09-21 13:49:47', '2026-09-21 13:49:47'),
(76, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 13:49:55', '2026-09-21 13:49:55', NULL, NULL, 2880, '2026-09-21 13:49:55', '2026-09-21 13:49:55'),
(77, 18, 43, 38, 'return', 'awda', NULL, 1, '2026-09-21 13:52:22', '2026-09-21 13:52:22', NULL, NULL, 2880, '2026-09-21 13:52:22', '2026-09-21 13:52:22'),
(78, 18, 38, 39, 'submit', NULL, NULL, 1, '2026-09-21 13:52:53', '2026-09-21 13:52:53', NULL, NULL, 2880, '2026-09-21 13:52:53', '2026-09-21 13:52:53'),
(79, 18, 39, 40, 'submit', NULL, NULL, 1, '2026-09-21 13:57:34', '2026-09-21 13:57:34', NULL, NULL, 2880, '2026-09-21 13:57:34', '2026-09-21 13:57:34'),
(80, 18, 40, 43, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 14:54:35', '2026-09-21 14:54:35', NULL, NULL, 2880, '2026-09-21 14:54:35', '2026-09-21 14:54:35'),
(81, 18, 43, 40, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 14:55:46', '2026-09-21 14:55:46', NULL, NULL, 2880, '2026-09-21 14:55:46', '2026-09-21 14:55:46'),
(82, 18, 40, 41, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 14:55:52', '2026-09-21 14:55:52', NULL, NULL, 2880, '2026-09-21 14:55:52', '2026-09-21 14:55:52'),
(83, 18, 41, 40, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 14:56:03', '2026-09-21 14:56:03', NULL, NULL, 2880, '2026-09-21 14:56:03', '2026-09-21 14:56:03'),
(84, 18, 40, 41, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 14:56:51', '2026-09-21 14:56:51', NULL, NULL, 2880, '2026-09-21 14:56:51', '2026-09-21 14:56:51'),
(85, 18, 41, 40, 'revisit', 'Jumped to a passed station', NULL, 1, '2026-09-21 15:01:30', '2026-09-21 15:01:30', NULL, NULL, 2880, '2026-09-21 15:01:30', '2026-09-21 15:01:30'),
(86, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 15:15:31', '2026-09-21 15:15:31', NULL, NULL, 2880, '2026-09-21 15:15:31', '2026-09-21 15:15:31'),
(87, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 15:15:39', '2026-09-21 15:15:39', NULL, NULL, 2880, '2026-09-21 15:15:39', '2026-09-21 15:15:39'),
(88, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 15:15:49', '2026-09-21 15:15:49', NULL, NULL, 2880, '2026-09-21 15:15:49', '2026-09-21 15:15:49'),
(89, 18, 43, 40, 'revisit', 'please fix', NULL, 1, '2026-09-21 15:16:08', '2026-09-21 15:16:08', NULL, NULL, 2880, '2026-09-21 15:16:08', '2026-09-21 15:16:08'),
(90, 18, 40, 41, 'submit', NULL, NULL, 1, '2026-09-21 15:16:16', '2026-09-21 15:16:16', NULL, NULL, 2880, '2026-09-21 15:16:16', '2026-09-21 15:16:16'),
(91, 18, 41, 42, 'submit', NULL, NULL, 1, '2026-09-21 15:16:30', '2026-09-21 15:16:30', NULL, NULL, 2880, '2026-09-21 15:16:30', '2026-09-21 15:16:30'),
(92, 18, 42, 43, 'submit', NULL, NULL, 1, '2026-09-21 15:16:42', '2026-09-21 15:16:42', NULL, NULL, 2880, '2026-09-21 15:16:42', '2026-09-21 15:16:42'),
(93, 18, 43, 40, 'revisit', 'please fix', NULL, 1, '2026-09-21 15:17:13', '2026-09-21 15:17:13', NULL, NULL, 2880, '2026-09-21 15:17:13', '2026-09-21 15:17:13'),
(94, 18, 40, 38, 'revisit', 'yamiti kudasai', NULL, 1, '2026-09-21 15:25:43', '2026-09-21 15:25:43', NULL, NULL, 2880, '2026-09-21 15:25:43', '2026-09-21 15:25:43'),
(95, 16, 1, 2, 'submit', NULL, NULL, 1, '2026-09-21 15:29:57', '2026-09-21 15:29:57', NULL, NULL, 2880, '2026-09-21 15:29:57', '2026-09-21 15:29:57'),
(96, 16, 2, 3, 'approve', NULL, NULL, 1, '2026-09-21 15:30:10', '2026-09-21 15:30:10', NULL, NULL, 4320, '2026-09-21 15:30:10', '2026-09-21 15:30:10'),
(97, 16, 3, 3, 'finalize', 'Process finalized', NULL, 1, '2026-09-21 15:47:33', '2026-09-21 15:47:33', NULL, NULL, 4320, '2026-09-21 15:47:33', '2026-09-21 15:47:33'),
(98, 15, 2, 3, 'approve', NULL, NULL, 1, '2026-09-21 15:48:17', '2026-09-21 15:48:17', NULL, NULL, 4320, '2026-09-21 15:48:17', '2026-09-21 15:48:17'),
(99, 15, 3, 3, 'finalize', 'Process finalized', NULL, 1, '2026-09-21 15:48:27', '2026-09-21 15:48:27', NULL, NULL, 4320, '2026-09-21 15:48:27', '2026-09-21 15:48:27'),
(100, 19, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-22 10:12:24', '2026-09-22 10:12:24', NULL, NULL, 2880, '2026-09-22 10:12:24', '2026-09-22 10:12:24'),
(101, 20, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-22 10:42:49', '2026-09-22 10:42:49', NULL, NULL, 2880, '2026-09-22 10:42:49', '2026-09-22 10:42:49'),
(102, 21, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-23 09:25:08', '2026-09-23 09:25:08', NULL, NULL, 2880, '2026-09-23 09:25:08', '2026-09-23 09:25:08'),
(103, 22, 1, 1, 'create', 'Transaction created', NULL, 1, '2026-09-24 10:50:22', '2026-09-24 10:50:22', NULL, NULL, 2880, '2026-09-24 10:50:22', '2026-09-24 10:50:22'),
(104, 22, 1, 2, 'submit', NULL, NULL, 1, '2026-09-24 10:54:17', '2026-09-24 10:54:17', NULL, NULL, 2880, '2026-09-24 10:54:17', '2026-09-24 10:54:17'),
(105, 22, 2, 3, 'approve', NULL, NULL, 1, '2026-09-24 10:58:02', '2026-09-24 10:58:02', NULL, NULL, 4320, '2026-09-24 10:58:02', '2026-09-24 10:58:02'),
(106, 22, 3, 1, 'revisit', 'something wong', NULL, 1, '2026-09-24 10:58:43', '2026-09-24 10:58:43', NULL, NULL, 2880, '2026-09-24 10:58:43', '2026-09-24 10:58:43'),
(107, 23, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-24 11:18:37', '2026-09-24 11:18:37', NULL, NULL, 2880, '2026-09-24 11:18:37', '2026-09-24 11:18:37'),
(108, 24, 38, 38, 'create', 'Transaction created', NULL, 1, '2026-09-24 11:22:47', '2026-09-24 11:22:47', NULL, NULL, 2880, '2026-09-24 11:22:47', '2026-09-24 11:22:47'),
(110, 24, 38, 39, 'submit', NULL, NULL, 1, '2026-09-25 14:25:55', '2026-09-25 14:26:20', 1, NULL, 2880, '2026-09-25 14:25:55', '2026-09-25 14:26:20'),
(111, 26, 202, 202, 'create', 'Transaction created', NULL, 1, '2026-09-25 15:18:46', '2026-09-25 15:18:46', 1, 24, 100, '2026-09-25 15:18:46', '2026-09-25 15:18:46'),
(112, 26, 202, 203, 'submit', NULL, NULL, 1, '2026-09-25 15:19:27', '2026-09-25 15:19:33', 1, 10, 20, '2026-09-25 15:19:27', '2026-09-25 15:19:33'),
(113, 26, 203, 204, 'submit', NULL, NULL, 1, '2026-09-25 15:19:47', '2026-09-25 15:19:56', 1, 24, 10, '2026-09-25 15:19:47', '2026-09-25 15:19:56'),
(114, 26, 204, 205, 'submit', NULL, NULL, 1, '2026-09-25 15:37:13', '2026-09-25 15:37:16', 1, 9, 9, '2026-09-25 15:37:13', '2026-09-25 15:37:16'),
(115, 26, 205, 206, 'submit', NULL, NULL, 1, '2026-09-25 15:37:22', '2026-09-25 15:37:24', 1, 24, 10, '2026-09-25 15:37:22', '2026-09-25 15:37:24'),
(116, 26, 206, 207, 'submit', NULL, NULL, 1, '2026-09-25 16:06:07', '2026-09-25 16:13:04', 1, 24, 20, '2026-09-25 16:06:07', '2026-09-25 16:13:04'),
(117, 26, 207, 208, 'submit', NULL, NULL, 1, '2026-09-25 16:40:17', '2026-09-25 16:40:26', 1, 24, 90, '2026-09-25 16:40:17', '2026-09-25 16:40:26'),
(118, 26, 208, 209, 'submit', NULL, NULL, 1, '2026-09-25 16:40:39', NULL, NULL, 24, 80, '2026-09-25 16:40:39', '2026-09-25 16:40:39'),
(119, 26, 209, 209, 'finalize', 'Process finalized', NULL, 1, '2026-09-25 16:41:24', NULL, NULL, NULL, 0, '2026-09-25 16:41:24', '2026-09-25 16:41:24'),
(120, 27, 202, 202, 'create', 'Transaction created', NULL, 1, '2026-09-25 16:46:46', '2026-09-25 16:46:46', 1, 24, 100, '2026-09-25 16:46:46', '2026-09-25 16:46:46'),
(121, 28, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-09-25 17:01:06', '2026-09-25 17:01:06', 1, NULL, 2880, '2026-09-25 17:01:06', '2026-09-25 17:01:06'),
(122, 28, 72, 73, 'submit', NULL, NULL, 1, '2026-09-25 17:02:03', '2026-09-25 17:05:01', 1, 4, 2880, '2026-09-25 17:02:03', '2026-09-25 17:05:01'),
(123, 28, 73, 74, 'approve', NULL, NULL, 1, '2026-09-25 17:05:21', '2026-09-25 17:05:25', 1, NULL, 4320, '2026-09-25 17:05:21', '2026-09-25 17:05:25'),
(124, 28, 74, 74, 'finalize', 'Process finalized', NULL, 1, '2026-09-25 17:05:30', '2026-09-25 17:05:30', 1, NULL, 4320, '2026-09-25 17:05:30', '2026-09-25 17:05:30'),
(125, 27, 202, 203, 'submit', 'hallo', NULL, 1, '2026-09-27 13:22:41', '2026-09-27 13:23:19', 1, 10, 20, '2026-09-27 13:22:41', '2026-09-27 13:23:19'),
(126, 27, 203, 204, 'submit', NULL, NULL, 1, '2026-09-27 14:09:55', '2026-09-27 14:11:52', 1, 24, 10, '2026-09-27 14:09:55', '2026-09-27 14:11:52'),
(127, 27, 204, 202, 'revisit', 'Kulang bAI', NULL, 1, '2026-09-27 14:12:19', '2026-09-27 14:12:24', 1, 24, 100, '2026-09-27 14:12:19', '2026-09-27 14:12:24'),
(128, 29, 234, 234, 'create', 'Transaction created', NULL, 1, '2026-09-27 14:17:39', '2026-09-27 14:17:39', 1, 10, 100, '2026-09-27 14:17:39', '2026-09-27 14:17:39'),
(129, 29, 234, 235, 'submit', NULL, NULL, 1, '2026-09-27 14:18:06', '2026-09-27 14:18:14', 1, 24, 20, '2026-09-27 14:18:06', '2026-09-27 14:18:14'),
(130, 29, 235, 236, 'submit', NULL, NULL, 1, '2026-09-27 14:18:37', '2026-09-27 14:18:40', 1, 9, 10, '2026-09-27 14:18:37', '2026-09-27 14:18:40'),
(131, 29, 236, 237, 'submit', NULL, NULL, 1, '2026-09-27 15:10:32', '2026-09-27 15:21:05', 1, 24, 9, '2026-09-27 15:10:32', '2026-09-27 15:21:05'),
(132, 29, 237, 238, 'submit', NULL, NULL, 1, '2026-09-28 08:40:36', '2026-09-28 08:58:48', 1, 24, 10, '2026-09-28 08:40:36', '2026-09-28 08:58:48'),
(133, 29, 238, 234, 'revisit', 'kulang man', NULL, 1, '2026-09-28 08:59:14', '2026-09-28 08:59:19', 1, 10, 100, '2026-09-28 08:59:14', '2026-09-28 08:59:19'),
(134, 29, 234, 235, 'submit', NULL, NULL, 1, '2026-09-28 08:59:41', '2026-09-28 08:59:43', 1, 24, 20, '2026-09-28 08:59:41', '2026-09-28 08:59:43'),
(135, 29, 235, 236, 'submit', NULL, NULL, 1, '2026-09-28 08:59:48', '2026-09-28 08:59:50', 1, 9, 10, '2026-09-28 08:59:48', '2026-09-28 08:59:50'),
(136, 29, 236, 237, 'submit', NULL, NULL, 1, '2026-09-28 08:59:57', '2026-09-28 08:59:59', 1, 24, 9, '2026-09-28 08:59:57', '2026-09-28 08:59:59'),
(137, 29, 237, 238, 'submit', NULL, NULL, 1, '2026-09-28 09:00:07', '2026-09-28 09:00:08', 1, 24, 10, '2026-09-28 09:00:07', '2026-09-28 09:00:08'),
(138, 30, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-09-28 10:45:58', '2026-09-28 10:45:58', 1, NULL, 2880, '2026-09-28 10:45:58', '2026-09-28 10:45:58'),
(139, 30, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 10:46:28', '2026-09-28 10:46:29', 1, 4, 2880, '2026-09-28 10:46:28', '2026-09-28 10:46:29'),
(140, 31, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-09-28 10:51:58', '2026-09-28 10:51:58', 1, NULL, 2880, '2026-09-28 10:51:58', '2026-09-28 10:51:58'),
(141, 31, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 10:52:22', '2026-09-28 10:52:26', 1, 4, 2880, '2026-09-28 10:52:22', '2026-09-28 10:52:26'),
(142, 31, 73, 72, 'revisit', 'kulang', NULL, 1, '2026-09-28 10:53:04', '2026-09-28 10:53:08', 1, NULL, 2880, '2026-09-28 10:53:04', '2026-09-28 10:53:08'),
(143, 31, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 10:53:16', '2026-09-28 10:53:20', 1, 4, 2880, '2026-09-28 10:53:16', '2026-09-28 10:53:20'),
(144, 31, 73, 72, 'return', NULL, NULL, 1, '2026-09-28 10:53:50', '2026-09-28 10:54:01', 1, NULL, 2880, '2026-09-28 10:53:50', '2026-09-28 10:54:01'),
(145, 31, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 11:07:34', '2026-09-28 11:07:36', 1, 4, 2880, '2026-09-28 11:07:34', '2026-09-28 11:07:36'),
(146, 31, 73, 72, 'return', NULL, NULL, 1, '2026-09-28 11:40:41', '2026-09-28 11:40:44', 1, NULL, 2880, '2026-09-28 11:40:41', '2026-09-28 11:40:44'),
(147, 31, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 13:20:46', '2026-09-28 13:21:08', 1, 4, 2880, '2026-09-28 13:20:46', '2026-09-28 13:21:08'),
(148, 32, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-09-28 13:33:30', '2026-09-28 13:33:30', 1, NULL, 2880, '2026-09-28 13:33:30', '2026-09-28 13:33:30'),
(149, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-28 16:54:52', '2026-09-28 16:54:54', 1, 4, 2880, '2026-09-28 16:54:52', '2026-09-28 16:54:54'),
(150, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 08:16:35', '2026-09-29 08:16:37', 1, NULL, 2880, '2026-09-29 08:16:35', '2026-09-29 08:16:37'),
(151, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 08:25:39', '2026-09-29 08:25:58', 1, 4, 2880, '2026-09-29 08:25:39', '2026-09-29 08:25:58'),
(152, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 08:30:32', '2026-09-29 08:30:34', 1, NULL, 2880, '2026-09-29 08:30:32', '2026-09-29 08:30:34'),
(153, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 13:33:25', '2026-09-29 13:33:28', 1, 4, 2880, '2026-09-29 13:33:25', '2026-09-29 13:33:28'),
(154, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 13:34:50', '2026-09-29 13:34:52', 1, NULL, 2880, '2026-09-29 13:34:50', '2026-09-29 13:34:52'),
(155, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 13:51:40', '2026-09-29 13:51:43', 1, 4, 2880, '2026-09-29 13:51:40', '2026-09-29 13:51:43'),
(156, 32, 73, 72, 'revisit', 'leme see something', NULL, 1, '2026-09-29 14:07:45', '2026-09-29 14:07:47', 1, NULL, 2880, '2026-09-29 14:07:45', '2026-09-29 14:07:47'),
(157, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 14:08:07', '2026-09-29 14:08:09', 1, 4, 2880, '2026-09-29 14:08:07', '2026-09-29 14:08:09'),
(158, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 14:17:06', '2026-09-29 14:17:08', 1, NULL, 2880, '2026-09-29 14:17:06', '2026-09-29 14:17:08'),
(159, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 14:17:13', '2026-09-29 14:17:15', 1, 4, 2880, '2026-09-29 14:17:13', '2026-09-29 14:17:15'),
(160, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 15:03:40', '2026-09-29 15:03:51', 1, NULL, 2880, '2026-09-29 15:03:40', '2026-09-29 15:03:51'),
(161, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 15:06:11', '2026-09-29 15:06:13', 1, 4, 2880, '2026-09-29 15:06:11', '2026-09-29 15:06:13'),
(162, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 15:15:11', '2026-09-29 15:15:14', 1, NULL, 2880, '2026-09-29 15:15:11', '2026-09-29 15:15:14'),
(163, 33, 259, 259, 'create', 'Transaction created', NULL, 1, '2026-09-29 15:25:53', '2026-09-29 15:25:53', 1, 10, 100, '2026-09-29 15:25:53', '2026-09-29 15:25:53'),
(164, 34, 268, 268, 'create', 'Transaction created', NULL, 1, '2026-09-29 15:28:31', '2026-09-29 15:28:31', 1, 10, 100, '2026-09-29 15:28:31', '2026-09-29 15:28:31'),
(165, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 15:41:58', '2026-09-29 15:42:01', 1, 4, 2880, '2026-09-29 15:41:58', '2026-09-29 15:42:01'),
(166, 32, 73, 72, 'return', NULL, NULL, 1, '2026-09-29 15:46:23', '2026-09-29 15:46:25', 1, NULL, 2880, '2026-09-29 15:46:23', '2026-09-29 15:46:25'),
(167, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 15:46:42', '2026-09-29 15:46:55', 1, 4, 2880, '2026-09-29 15:46:42', '2026-09-29 15:46:55'),
(168, 32, 73, 72, 'revisit', 'Kulang boss', NULL, 1, '2026-09-29 15:47:36', '2026-09-29 15:47:38', 1, NULL, 2880, '2026-09-29 15:47:36', '2026-09-29 15:47:38'),
(169, 32, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 15:55:22', '2026-09-29 15:55:24', 1, 4, 2880, '2026-09-29 15:55:22', '2026-09-29 15:55:24'),
(170, 35, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-09-29 16:12:36', '2026-09-29 16:12:36', 1, NULL, 2880, '2026-09-29 16:12:36', '2026-09-29 16:12:36'),
(171, 35, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 16:13:57', '2026-09-29 16:13:59', 1, 4, 2880, '2026-09-29 16:13:57', '2026-09-29 16:13:59'),
(172, 35, 73, 72, 'revisit', 'Kulang man ni uy', NULL, 1, '2026-09-29 16:19:36', '2026-09-29 16:19:39', 1, NULL, 2880, '2026-09-29 16:19:36', '2026-09-29 16:19:39'),
(173, 35, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 16:19:54', '2026-09-29 16:19:57', 1, 4, 2880, '2026-09-29 16:19:54', '2026-09-29 16:19:57'),
(174, 35, 73, 74, 'approve', NULL, NULL, 1, '2026-09-29 16:25:38', '2026-09-29 16:25:58', 1, NULL, 4320, '2026-09-29 16:25:38', '2026-09-29 16:25:58'),
(175, 35, 74, 73, 'revisit', 'Kulang bai uy', NULL, 1, '2026-09-29 16:26:21', '2026-09-29 16:26:24', 1, 4, 2880, '2026-09-29 16:26:21', '2026-09-29 16:26:24'),
(176, 35, 73, 72, 'revisit', 'Walang Hardcopy ng AR', NULL, 1, '2026-09-29 16:42:57', '2026-09-29 16:42:59', 1, NULL, 2880, '2026-09-29 16:42:57', '2026-09-29 16:42:59'),
(177, 36, 328, 328, 'create', 'Transaction created', NULL, 1, '2026-09-29 16:54:47', '2026-09-29 16:54:47', 1, 8, 0, '2026-09-29 16:54:47', '2026-09-29 16:54:47'),
(178, 37, 384, 384, 'create', 'Transaction created', NULL, 1, '2026-09-29 16:58:33', '2026-09-29 16:58:33', 1, 8, 0, '2026-09-29 16:58:33', '2026-09-29 16:58:33'),
(179, 35, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 17:16:58', '2026-09-29 17:17:00', 1, 4, 2880, '2026-09-29 17:16:58', '2026-09-29 17:17:00'),
(180, 37, 384, 385, 'submit', NULL, NULL, 1, '2026-09-29 17:17:49', '2026-09-29 17:17:50', 1, 24, 120, '2026-09-29 17:17:49', '2026-09-29 17:17:50'),
(181, 37, 385, 386, 'submit', NULL, NULL, 1, '2026-09-29 17:19:41', '2026-09-29 17:19:43', 1, 5, 120, '2026-09-29 17:19:41', '2026-09-29 17:19:43'),
(182, 37, 386, 387, 'submit', NULL, NULL, 1, '2026-09-29 17:20:01', '2026-09-29 17:20:03', 1, 24, 120, '2026-09-29 17:20:01', '2026-09-29 17:20:03'),
(183, 37, 387, 388, 'submit', NULL, NULL, 1, '2026-09-29 17:20:28', '2026-09-29 17:20:31', 1, 9, 120, '2026-09-29 17:20:28', '2026-09-29 17:20:31'),
(184, 37, 388, 389, 'submit', NULL, NULL, 1, '2026-09-29 17:20:54', '2026-09-29 17:20:56', 1, 1, 120, '2026-09-29 17:20:54', '2026-09-29 17:20:56'),
(185, 37, 389, 390, 'submit', NULL, NULL, 1, '2026-09-29 17:21:11', '2026-09-29 17:21:14', 1, 9, 120, '2026-09-29 17:21:11', '2026-09-29 17:21:14'),
(186, 35, 73, 72, 'revisit', 'Kulang po Maem', NULL, 1, '2026-09-29 17:28:49', '2026-09-29 17:29:47', 1, NULL, 2880, '2026-09-29 17:28:49', '2026-09-29 17:29:47'),
(187, 35, 72, 73, 'submit', NULL, NULL, 1, '2026-09-29 17:29:51', '2026-09-29 17:29:55', 1, 4, 2880, '2026-09-29 17:29:51', '2026-09-29 17:29:55'),
(188, 35, 73, 74, 'approve', NULL, NULL, 1, '2026-09-29 17:30:00', '2026-09-29 17:30:02', 1, NULL, 4320, '2026-09-29 17:30:00', '2026-09-29 17:30:02'),
(189, 38, 392, 392, 'create', 'Transaction created', NULL, 1, '2026-09-29 17:31:10', '2026-09-29 17:31:10', 1, 8, 0, '2026-09-29 17:31:10', '2026-09-29 17:31:10'),
(190, 38, 392, 393, 'submit', NULL, NULL, 1, '2026-09-29 17:31:30', '2026-09-29 17:31:32', 1, 24, 120, '2026-09-29 17:31:30', '2026-09-29 17:31:32'),
(191, 38, 393, 394, 'submit', NULL, NULL, 1, '2026-09-29 17:31:49', '2026-09-29 17:31:51', 1, 5, 120, '2026-09-29 17:31:49', '2026-09-29 17:31:51'),
(192, 38, 394, 395, 'submit', NULL, NULL, 1, '2026-09-29 17:32:04', '2026-09-29 17:32:06', 1, 24, 120, '2026-09-29 17:32:04', '2026-09-29 17:32:06'),
(193, 38, 395, 396, 'submit', NULL, NULL, 1, '2026-09-29 17:32:20', '2026-09-29 17:32:22', 1, 9, 120, '2026-09-29 17:32:20', '2026-09-29 17:32:22'),
(194, 38, 396, 397, 'submit', NULL, NULL, 1, '2026-09-29 17:44:03', '2026-09-29 17:44:05', 1, 1, 120, '2026-09-29 17:44:03', '2026-09-29 17:44:05'),
(195, 38, 397, 398, 'submit', NULL, NULL, 1, '2026-09-29 17:44:20', '2026-09-29 17:44:21', 1, 9, 120, '2026-09-29 17:44:20', '2026-09-29 17:44:21'),
(196, 38, 398, 399, 'submit', NULL, NULL, 1, '2026-09-29 17:44:32', '2026-09-29 17:44:34', 1, 26, 120, '2026-09-29 17:44:32', '2026-09-29 17:44:34'),
(197, 38, 399, 399, 'finalize', 'Transaction finalized', NULL, 1, '2026-09-29 17:44:39', '2026-09-29 17:44:39', 1, 26, 120, '2026-09-29 17:44:39', '2026-09-29 17:44:39'),
(198, 39, 392, 392, 'create', 'Transaction created', NULL, 1, '2026-09-29 17:44:55', '2026-09-29 17:44:55', 1, 8, 0, '2026-09-29 17:44:55', '2026-09-29 17:44:55'),
(199, 39, 392, 393, 'submit', NULL, NULL, 1, '2026-09-29 17:47:17', '2026-09-29 17:47:21', 1, 24, 120, '2026-09-29 17:47:17', '2026-09-29 17:47:21'),
(200, 39, 393, 394, 'submit', NULL, NULL, 1, '2026-09-29 17:49:31', '2026-09-29 17:50:03', 1, 5, 120, '2026-09-29 17:49:31', '2026-09-29 17:50:03'),
(201, 40, 392, 392, 'create', 'Transaction created', NULL, 1, '2026-09-30 08:09:17', '2026-09-30 08:09:17', 1, 8, 0, '2026-09-30 08:09:17', '2026-09-30 08:09:17'),
(202, 40, 392, 393, 'submit', NULL, NULL, 1, '2026-10-01 16:12:24', '2026-10-01 16:12:26', 1, 24, 120, '2026-10-01 16:12:24', '2026-10-01 16:12:26'),
(203, 40, 393, 394, 'submit', NULL, NULL, 1, '2026-10-01 16:12:38', '2026-10-01 16:16:55', 1, 5, 120, '2026-10-01 16:12:38', '2026-10-01 16:16:55'),
(204, 40, 394, 392, 'return', 'kulan man ni bai', NULL, 1, '2026-10-01 16:17:51', '2026-10-01 16:17:52', 1, 8, 0, '2026-10-01 16:17:51', '2026-10-01 16:17:52'),
(205, 40, 392, 393, 'submit', NULL, NULL, 1, '2026-10-02 18:06:10', '2026-10-02 18:06:17', 1, 24, 120, '2026-10-02 18:06:10', '2026-10-02 18:06:17'),
(206, 40, 393, 394, 'submit', NULL, NULL, 1, '2026-10-04 09:31:35', '2026-10-04 09:31:40', 1, 5, 120, '2026-10-04 09:31:35', '2026-10-04 09:31:40'),
(207, 41, 416, 416, 'create', 'Transaction created', NULL, 1, '2026-10-04 09:34:21', '2026-10-04 09:34:21', 1, 8, 0, '2026-10-04 09:34:21', '2026-10-04 09:34:21'),
(223, 49, 416, 416, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:29:22', '2026-10-16 11:29:22', 10, 8, 0, '2026-10-16 11:29:22', '2026-10-16 11:29:22'),
(224, 49, 416, 417, 'submit', NULL, NULL, 10, '2026-10-16 11:30:35', NULL, NULL, 24, 120, '2026-10-16 11:30:35', '2026-10-16 11:30:35'),
(225, 50, 72, 72, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:37:24', '2026-10-16 11:37:24', 10, NULL, 2880, '2026-10-16 11:37:24', '2026-10-16 11:37:24'),
(226, 50, 72, 73, 'submit', NULL, NULL, 10, '2026-10-16 11:38:52', NULL, NULL, 4, 2880, '2026-10-16 11:38:52', '2026-10-16 11:38:52'),
(227, 51, 38, 38, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:40:38', '2026-10-16 11:40:38', 10, NULL, 2880, '2026-10-16 11:40:38', '2026-10-16 11:40:38'),
(228, 51, 38, 39, 'submit', NULL, NULL, 10, '2026-10-16 11:41:08', NULL, NULL, NULL, 2880, '2026-10-16 11:41:08', '2026-10-16 11:41:08'),
(229, 52, 416, 416, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:44:18', '2026-10-16 11:44:18', 10, 8, 0, '2026-10-16 11:44:18', '2026-10-16 11:44:18'),
(230, 52, 416, 417, 'submit', NULL, NULL, 10, '2026-10-16 11:44:41', NULL, NULL, 24, 120, '2026-10-16 11:44:41', '2026-10-16 11:44:41'),
(231, 53, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-10-19 10:25:54', '2026-10-19 10:25:54', 1, NULL, 2880, '2026-10-19 10:25:54', '2026-10-19 10:25:54'),
(232, 53, 72, 73, 'submit', NULL, NULL, 1, '2026-10-19 11:52:22', '2026-10-19 11:52:25', 1, 4, 2880, '2026-10-19 11:52:22', '2026-10-19 11:52:25'),
(233, 53, 73, 74, 'approve', NULL, NULL, 1, '2026-10-19 19:52:49', '2026-11-04 23:22:46', 1, NULL, 4320, '2026-10-19 19:52:49', '2026-11-04 23:22:46'),
(234, 54, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-10-19 15:13:46', '2026-10-19 15:13:46', 1, NULL, 2880, '2026-10-19 15:13:46', '2026-10-19 15:13:46'),
(235, 55, 416, 416, 'create', 'Transaction created', NULL, 1, '2026-10-20 13:05:41', '2026-10-20 13:05:41', 1, 8, 0, '2026-10-20 13:05:41', '2026-10-20 13:05:41'),
(236, 56, 38, 38, 'create', 'Transaction created', NULL, 43, '2026-10-21 13:18:42', '2026-10-21 13:18:42', 43, 9, 2880, '2026-10-21 13:18:42', '2026-10-21 13:18:42'),
(237, 57, 459, 459, 'create', 'Transaction created', NULL, 43, '2026-10-21 13:21:41', '2026-10-21 13:21:41', 43, 9, 0, '2026-10-21 13:21:41', '2026-10-21 13:21:41'),
(238, 58, 459, 459, 'create', 'Transaction created', NULL, 43, '2026-10-21 13:23:13', '2026-10-21 13:23:13', 43, 9, 0, '2026-10-21 13:23:13', '2026-10-21 13:23:13'),
(239, 59, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-21 13:55:58', '2026-10-21 13:55:58', 59, 24, 0, '2026-10-21 13:55:58', '2026-10-21 13:55:58'),
(240, 59, 459, 460, 'submit', 'testing vers 1', NULL, 59, '2026-10-21 13:56:31', '2026-10-21 13:57:29', 42, 8, 120, '2026-10-21 13:56:31', '2026-10-21 13:57:29'),
(241, 59, 460, 461, 'submit', NULL, NULL, 42, '2026-10-21 13:58:33', '2026-10-21 14:16:41', 40, 5, 120, '2026-10-21 13:58:33', '2026-10-21 14:16:41'),
(242, 59, 461, 459, 'return', 'wrong name spelling encode the correct name of the employee please', '[{\"code\": \"pr_number\", \"name\": \"PR with Number\", \"requirement_definition_id\": 175}]', 40, '2026-10-21 14:17:30', '2026-10-21 14:19:35', 59, 24, 0, '2026-10-21 14:17:30', '2026-10-21 14:19:35'),
(243, 59, 459, 460, 'submit', 'ganyan talaga name ko helllo?', NULL, 59, '2026-10-21 14:19:58', '2026-10-22 15:02:15', 42, 8, 120, '2026-10-21 14:19:58', '2026-10-22 15:02:15'),
(244, 60, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 13:56:00', '2026-10-22 13:56:00', 59, 24, 0, '2026-10-22 13:56:00', '2026-10-22 13:56:00'),
(245, 61, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 13:58:16', '2026-10-22 13:58:16', 59, 24, 0, '2026-10-22 13:58:16', '2026-10-22 13:58:16'),
(246, 61, 459, 460, 'submit', NULL, NULL, 59, '2026-10-22 13:58:55', '2026-10-22 14:01:15', 42, 8, 120, '2026-10-22 13:58:55', '2026-10-22 14:01:15'),
(247, 61, 460, 461, 'submit', NULL, NULL, 42, '2026-10-22 14:01:35', '2026-10-22 14:04:27', 40, 5, 120, '2026-10-22 14:01:35', '2026-10-22 14:04:27'),
(248, 61, 461, 462, 'submit', NULL, NULL, 40, '2026-10-22 14:04:49', NULL, NULL, 24, 120, '2026-10-22 14:04:49', '2026-10-22 14:04:49'),
(249, 62, 459, 459, 'create', 'Transaction created', NULL, 40, '2026-10-22 14:16:57', '2026-10-22 14:16:57', 40, 5, 0, '2026-10-22 14:16:57', '2026-10-22 14:16:57'),
(250, 63, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 14:19:11', '2026-10-22 14:19:11', 59, 24, 0, '2026-10-22 14:19:11', '2026-10-22 14:19:11'),
(251, 59, 460, 461, 'submit', NULL, NULL, 42, '2026-10-22 15:02:23', '2026-10-22 15:03:12', 40, 5, 120, '2026-10-22 15:02:23', '2026-10-22 15:03:12'),
(252, 59, 461, 462, 'submit', NULL, NULL, 40, '2026-10-22 23:03:26', NULL, NULL, NULL, 120, '2026-10-22 23:03:26', '2026-10-22 23:03:26'),
(253, 64, 424, 424, 'create', 'Transaction created', NULL, 1, '2026-10-26 08:25:08', '2026-10-26 08:25:08', 1, 24, 2880, '2026-10-26 08:25:08', '2026-10-26 08:25:08'),
(254, 65, 498, 498, 'create', 'Transaction created', NULL, 1, '2026-10-27 09:10:47', '2026-10-27 09:10:47', 1, 24, 2880, '2026-10-27 09:10:47', '2026-10-27 09:10:47'),
(255, 65, 498, 499, 'submit', NULL, NULL, 1, '2026-10-29 18:03:09', '2026-10-29 18:03:13', 1, 4, 2880, '2026-10-29 18:03:09', '2026-10-29 18:03:13'),
(256, 66, 498, 498, 'create', 'Transaction created', NULL, 1, '2026-10-29 19:24:36', '2026-10-29 19:24:36', 1, 24, 2880, '2026-10-29 19:24:36', '2026-10-29 19:24:36'),
(257, 66, 498, 499, 'submit', 'Kulang bai', NULL, 1, '2026-10-29 19:25:42', '2026-10-29 19:25:45', 1, 4, 2880, '2026-10-29 19:25:42', '2026-10-29 19:25:45'),
(258, 65, 499, 500, 'approve', NULL, NULL, 1, '2026-11-04 23:22:09', '2026-11-04 23:22:12', 1, 24, 4320, '2026-11-04 23:22:09', '2026-11-04 23:22:12'),
(259, 65, 500, 500, 'finalize', 'Transaction finalized', NULL, 1, '2026-11-04 23:22:33', '2026-11-04 23:22:33', 1, 24, 4320, '2026-11-04 23:22:33', '2026-11-04 23:22:33'),
(260, 53, 74, 74, 'finalize', 'Transaction finalized', NULL, 1, '2026-11-04 23:23:08', '2026-11-04 23:23:08', 1, 24, 4320, '2026-11-04 23:23:08', '2026-11-04 23:23:08'),
(261, 67, 475, 475, 'create', 'Transaction created', NULL, 1, '2026-11-04 23:46:58', '2026-11-04 23:46:58', 1, 16, 0, '2026-11-04 23:46:58', '2026-11-04 23:46:58');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_types`
--
CREATE TABLE `transaction_types` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `createdby_office` bigint UNSIGNED DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_types`
--

INSERT INTO `transaction_types` (`id`, `code`, `name`, `description`, `is_active`, `created_at`, `createdby_office`, `updated_at`, `deleted_at`) VALUES
(1, 'payroll', 'Payroll', 'job order', 1, '2026-03-09 13:24:39', 24, '2026-09-20 09:11:37', NULL),
(2, 'procurement', 'Procurement', 'LGU procurement process (inventory-linked)', 1, '2026-03-09 13:24:39', 24, '2026-10-21 13:20:38', '2026-10-21 13:20:38'),
(3, 'communication', 'Communication', NULL, 0, '2026-03-09 15:44:35', 24, '2026-11-03 23:15:49', NULL),
(9, 'it_procurements', 'IT Equipment Procurement', 'It Equipment Procurement', 1, '2026-09-25 14:56:33', 24, '2026-09-29 16:29:17', '2026-09-29 16:29:17'),
(10, 'wadawd', '2q21232-aa', 'awadawd', 1, '2026-09-29 15:31:04', 24, '2026-09-29 15:39:29', '2026-09-29 15:39:29'),
(11, 'procurement_it_equipment', 'Procurement : IT Equipment', 'This is a procurement for the it department', 1, '2026-09-29 16:30:22', 24, '2026-09-29 16:30:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `Contact_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `office_id`, `Contact_number`, `email_verified_at`, `password`, `is_active`, `approved_at`, `approved_by`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Vince', 'superadmin', 'vinzmuloc@gmail.com', NULL, NULL, NULL, '$2y$12$0qYrVEsSWeB1IRG9q7pAYefTu456iEGLGc26EfllLoZprYDLUTLX2', 1, '2026-03-09 21:24:36', NULL, '5mTRgooLU8Qelc34l9a075V4KGMaLN3zvqQ5mNzVReuzviQTZdPwp4Zc8sqG', '2026-03-09 21:24:36', '2026-09-09 18:26:20'),
(2, 'End User', 'enduser', 'enduser@lgu.test', NULL, NULL, NULL, '$2y$12$Hn3rfdfNGa5OUVsghdyOr.DVZR.G4DMNc43uJSfKpbg9tRFQN9jXa', 1, '2026-03-09 21:24:37', NULL, NULL, '2026-03-09 21:24:37', '2026-10-22 22:46:33'),
(10, 'Sharief Kundo Mudrikal', 'csdadmin', 'admin@gmail.com', 24, NULL, NULL, '$2y$12$cG0x/1gA9iHyFISjEkjLN.SLWgAWti150Y2TejkH0eMUzbJqmD8rm', 1, '2026-09-10 13:08:36', NULL, NULL, '2026-09-10 13:08:36', '2026-10-21 15:16:39'),
(33, 'Guest Viewer', 'viewer', 'viewer@lgu.test', NULL, NULL, NULL, '$2y$12$uwcCeYFp3vLZKw2HOHrfpeH283z0B8sUPG.o6TbPWNyQJRsVdO/hO', 1, '2026-10-19 08:48:36', NULL, NULL, '2026-10-19 08:48:36', '2026-10-19 08:48:36'),
(36, 'Maria Theresa Climaco', 'ocmclerk', 'mtclimaco.ocm@gmail.com', 1, '09171234501', '2026-10-20 13:57:40', '$2y$12$eiIQwCQ0v9QDTl/j8aWkReeI.5SZhsGdU7X9QWNXiBFgT4GGum1XC', 1, '2026-10-20 13:57:40', 1, NULL, '2026-10-20 13:57:40', '2026-10-20 13:57:40'),
(39, 'Ramon Enriquez', 'ocasclerk', 'ramon.enriquez.zc@gmail.com', 4, '09351234504', '2026-10-20 13:57:41', '$2y$12$qwDo6j4t.yHLMY6gKmyAMugcV3wekJbqnY9c.4ooba80.dvZsMe9m', 1, '2026-10-20 13:57:41', 1, NULL, '2026-10-20 13:57:41', '2026-10-20 13:57:41'),
(40, 'Angelica Mae Navarro', 'chrmoclerk', 'angelicamae.navarro@gmail.com', 21, '09451234505', '2026-10-20 13:57:42', '$2y$12$S6dhHWTVM0zofwuKCnrMBOaCHNN9fHpsDcjOQ2zUwRsxiUCp8YY1.', 1, '2026-10-20 13:57:42', 1, NULL, '2026-10-20 13:57:42', '2026-11-03 19:00:08'),
(42, 'Rhea Lyn Francisco', 'gsoclerk', 'rhealyn.francisco.gso@gmail.com', 8, '09661234507', '2026-10-20 13:57:42', '$2y$12$Swxu2OV95ZF7FzHD2eewN.yd93azIIqFnALMV7GTM29can.gQZvym', 1, '2026-10-20 13:57:42', 1, NULL, '2026-10-20 13:57:42', '2026-10-20 13:57:42'),
(43, 'Carlo Miguel Saavedra', 'ocbclerk', 'cmsaavedra.budget@gmail.com', 9, '09771234508', '2026-10-20 13:57:43', '$2y$12$YbnYXLHnTsXwmwSzT8IlxuwgAFVn3DJTgUSALsZAgmXnQ3jY7MEZ6', 1, '2026-10-20 13:57:43', 1, NULL, '2026-10-20 13:57:43', '2026-10-20 13:57:43'),
(58, 'Arnel Go', 'paadclerk', 'arnel.go.paad@gmail.com', 26, '09451234523', '2026-10-20 13:57:48', '$2y$12$PJFZeMX8vurdu6fssH.tLOVVq6boi0ea1zrk1opJt7iuK/VGqT1AO', 1, '2026-10-20 13:57:48', 1, NULL, '2026-10-20 13:57:48', '2026-10-20 13:57:48'),
(59, 'John Rey Wee', 'csdclerk', 'johnrey.wee.csd@gmail.com', 24, '09271234521', '2026-10-21 13:47:00', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-21 13:47:00', 1, NULL, '2026-10-21 13:47:00', '2026-10-22 14:45:36'),
(63, 'juan', 'ocbclerk2', 'AWDJAWJKDN@GMAIL.OCCM', 9, '090933921111', NULL, '$2y$12$.JBec/bE4QJ5urxGJG.QmejCIT//.vytnTXdmm0X0WhlFgUtFYxZ2', 0, NULL, NULL, NULL, '2026-11-04 23:56:24', '2026-11-04 23:56:24'),
(64, 'Juan dila', 'csdclerk2', 'juandela@gmail.com', 24, '09093392171', NULL, '$2y$12$uJIBsLdc9y54a/hqygzlbummboEQVVh2quG4v/8sYPeui05WBPA9u', 1, '2026-11-05 16:46:24', 1, NULL, '2026-11-05 16:33:43', '2026-11-05 16:46:24');

-- --------------------------------------------------------

--
-- Table structure for table `workflow_definitions`
--
CREATE TABLE `workflow_definitions` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_type_id` bigint UNSIGNED NOT NULL,
  `version` int UNSIGNED NOT NULL DEFAULT '1',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `is_live` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
(1, 1, 1, 'published', 0, 'Payroll v1', 'Seeded sample workflow (TO VERIFY actual process)', '2026-03-09 13:24:39', 1, '2026-03-09 13:24:39', '2026-10-27 09:10:26', NULL),
(2, 2, 1, 'published', 0, 'Purchase Request v1', 'Seeded full PR workflow based on executive summary flow image', '2026-03-09 13:24:39', 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 3, 1, 'published', 0, NULL, NULL, '2026-03-09 15:51:30', 1, '2026-03-09 15:49:10', '2026-11-03 22:59:20', NULL),
(4, 3, 2, 'published', 0, NULL, NULL, '2026-03-09 15:57:22', 1, '2026-03-09 15:56:26', '2026-11-03 22:59:20', NULL),
(5, 3, 3, 'published', 0, NULL, NULL, '2026-09-13 14:43:18', 1, '2026-03-09 16:30:24', '2026-11-03 22:59:20', NULL),
(7, 2, 3, 'published', 1, NULL, NULL, '2026-09-11 12:12:13', 1, '2026-09-11 12:07:42', '2026-09-11 12:12:13', NULL),
(16, 3, 4, 'published', 0, NULL, NULL, '2026-09-13 14:43:45', 1, '2026-09-13 14:43:22', '2026-11-03 22:59:20', NULL),
(17, 1, 2, 'published', 0, NULL, NULL, '2026-09-24 11:04:26', 1, '2026-09-13 16:53:40', '2026-10-27 09:10:26', NULL),
(26, 9, 1, 'published', 0, NULL, NULL, '2026-09-25 15:09:34', 1, '2026-09-25 14:56:43', '2026-09-25 15:09:34', NULL),
(27, 9, 2, 'published', 0, NULL, NULL, '2026-09-25 15:13:21', 1, '2026-09-25 15:12:20', '2026-09-25 15:13:21', NULL),
(28, 9, 3, 'published', 0, NULL, NULL, '2026-09-25 15:13:46', 1, '2026-09-25 15:13:32', '2026-09-25 15:13:46', NULL),
(29, 9, 4, 'published', 0, NULL, NULL, '2026-09-25 15:15:25', 1, '2026-09-25 15:14:13', '2026-09-25 15:15:25', NULL),
(30, 9, 5, 'published', 0, NULL, NULL, '2026-09-25 15:15:44', 1, '2026-09-25 15:15:34', '2026-09-25 15:15:44', NULL),
(31, 9, 6, 'published', 0, NULL, NULL, '2026-09-25 15:15:55', 1, '2026-09-25 15:15:47', '2026-09-25 15:15:55', NULL),
(32, 9, 7, 'published', 0, NULL, NULL, '2026-09-25 15:16:10', 1, '2026-09-25 15:15:59', '2026-09-25 15:16:10', NULL),
(33, 9, 8, 'published', 0, NULL, NULL, '2026-09-25 15:16:23', 1, '2026-09-25 15:16:13', '2026-09-25 15:16:23', NULL),
(34, 9, 9, 'published', 0, NULL, NULL, '2026-09-25 15:16:37', 1, '2026-09-25 15:16:28', '2026-09-25 15:16:37', NULL),
(35, 9, 10, 'published', 0, NULL, NULL, '2026-09-25 15:16:52', 1, '2026-09-25 15:16:41', '2026-09-25 15:16:52', NULL),
(36, 9, 11, 'published', 0, NULL, NULL, '2026-09-25 15:17:09', 1, '2026-09-25 15:16:57', '2026-09-25 15:17:09', NULL),
(37, 9, 12, 'published', 0, NULL, NULL, '2026-09-25 15:17:30', 1, '2026-09-25 15:17:13', '2026-09-25 15:17:30', NULL),
(38, 9, 13, 'published', 0, NULL, NULL, '2026-09-25 15:17:42', 1, '2026-09-25 15:17:34', '2026-09-25 15:17:42', NULL),
(39, 9, 14, 'published', 0, NULL, NULL, '2026-09-25 15:17:55', 1, '2026-09-25 15:17:45', '2026-09-25 15:17:55', NULL),
(40, 9, 15, 'published', 0, NULL, NULL, '2026-09-27 14:14:18', 1, '2026-09-27 14:13:53', '2026-09-27 14:14:18', NULL),
(41, 9, 16, 'published', 0, NULL, NULL, '2026-09-27 14:14:45', 1, '2026-09-27 14:14:30', '2026-09-27 14:14:45', NULL),
(42, 9, 17, 'published', 0, NULL, NULL, '2026-09-27 14:15:13', 1, '2026-09-27 14:15:04', '2026-09-27 14:15:13', NULL),
(43, 9, 18, 'published', 0, NULL, NULL, '2026-09-27 14:15:48', 1, '2026-09-27 14:15:25', '2026-09-27 14:15:48', NULL),
(44, 9, 19, 'published', 0, NULL, NULL, '2026-09-28 09:20:39', 1, '2026-09-28 09:20:34', '2026-09-28 09:20:39', NULL),
(45, 9, 20, 'published', 0, NULL, NULL, '2026-09-28 09:28:14', 1, '2026-09-28 09:27:45', '2026-09-28 09:28:14', NULL),
(46, 9, 21, 'published', 0, NULL, NULL, '2026-09-28 09:32:00', 1, '2026-09-28 09:31:40', '2026-09-28 09:32:00', NULL),
(47, 9, 22, 'published', 0, NULL, NULL, '2026-09-29 15:27:23', 1, '2026-09-28 09:32:11', '2026-09-29 15:27:23', NULL),
(48, 10, 1, 'published', 1, NULL, NULL, '2026-09-29 15:37:12', 1, '2026-09-29 15:34:04', '2026-09-29 15:37:12', NULL),
(49, 10, 2, 'draft', 0, NULL, NULL, NULL, NULL, '2026-09-29 15:37:52', '2026-09-29 15:37:52', NULL),
(50, 9, 23, 'published', 1, NULL, NULL, '2026-09-29 16:24:42', 1, '2026-09-29 16:23:40', '2026-09-29 16:24:42', NULL),
(53, 11, 1, 'published', 0, NULL, NULL, '2026-09-29 16:42:35', 1, '2026-09-29 16:30:31', '2026-10-26 08:53:01', NULL),
(54, 11, 2, 'published', 0, NULL, NULL, '2026-09-29 16:55:15', 1, '2026-09-29 16:52:28', '2026-10-26 08:53:01', NULL),
(55, 11, 3, 'published', 0, NULL, NULL, '2026-09-29 16:55:25', 1, '2026-09-29 16:55:17', '2026-10-26 08:53:01', NULL),
(56, 11, 4, 'published', 0, NULL, NULL, '2026-09-29 16:55:35', 1, '2026-09-29 16:55:27', '2026-10-26 08:53:01', NULL),
(57, 11, 5, 'published', 0, NULL, NULL, '2026-09-29 16:55:46', 1, '2026-09-29 16:55:37', '2026-10-26 08:53:01', NULL),
(58, 11, 6, 'published', 0, NULL, NULL, '2026-09-29 16:55:57', 1, '2026-09-29 16:55:49', '2026-10-26 08:53:01', NULL),
(59, 11, 7, 'published', 0, NULL, NULL, '2026-09-29 16:56:17', 1, '2026-09-29 16:56:08', '2026-10-26 08:53:01', NULL),
(60, 11, 8, 'published', 0, NULL, NULL, '2026-09-29 16:56:30', 1, '2026-09-29 16:56:20', '2026-10-26 08:53:01', NULL),
(61, 11, 9, 'published', 0, NULL, NULL, '2026-09-29 17:15:16', 1, '2026-09-29 17:15:05', '2026-10-26 08:53:01', NULL),
(62, 3, 5, 'published', 0, 'Bryan', NULL, '2026-09-30 12:32:13', 1, '2026-09-30 12:31:59', '2026-11-03 22:59:20', NULL),
(63, 3, 6, 'published', 0, NULL, NULL, '2026-09-30 12:33:11', 1, '2026-09-30 12:32:32', '2026-11-03 22:59:20', NULL),
(64, 3, 7, 'published', 1, 'bry', 's', '2026-09-30 12:33:37', 1, '2026-09-30 12:33:36', '2026-11-03 22:59:20', NULL),
(65, 11, 10, 'published', 0, NULL, NULL, '2026-10-04 09:33:29', 1, '2026-10-04 09:33:21', '2026-10-26 08:53:01', NULL),
(66, 11, 11, 'published', 0, NULL, NULL, '2026-10-04 09:33:40', 1, '2026-10-04 09:33:33', '2026-10-26 08:53:01', NULL),
(67, 1, 3, 'published', 0, 'Payroll', NULL, '2026-10-20 09:54:10', 1, '2026-10-20 09:54:10', '2026-10-27 09:10:26', NULL),
(68, 11, 12, 'published', 0, 'Procurement : IT Equipment', NULL, '2026-10-20 13:28:34', 1, '2026-10-20 13:28:34', '2026-10-26 08:53:01', NULL),
(69, 11, 13, 'published', 0, 'Procurement : IT Equipment', NULL, '2026-10-20 13:29:30', 1, '2026-10-20 13:29:30', '2026-10-26 08:53:01', NULL),
(70, 11, 14, 'published', 0, 'Procurement : IT Equipment', NULL, '2026-10-20 13:33:14', 1, '2026-10-20 13:33:14', '2026-10-26 08:53:01', NULL),
(71, 11, 15, 'published', 0, 'Procurement : IT Equipment', NULL, '2026-10-20 13:36:16', 1, '2026-10-20 13:36:15', '2026-10-26 08:53:01', NULL),
(72, 11, 16, 'published', 0, 'Procurement : IT Equipment', NULL, '2026-10-20 13:40:11', 1, '2026-10-20 13:40:10', '2026-10-26 08:53:01', NULL),
(73, 11, 17, 'published', 0, NULL, NULL, '2026-10-25 12:18:38', 1, '2026-10-25 12:18:38', '2026-10-26 08:53:01', NULL),
(74, 11, 18, 'published', 1, 'Procurement : IT Equipment', NULL, '2026-10-26 08:53:01', 1, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(75, 1, 4, 'published', 0, NULL, NULL, '2026-10-27 09:08:11', 1, '2026-10-27 09:08:11', '2026-10-27 09:10:26', NULL),
(76, 1, 5, 'published', 0, NULL, NULL, '2026-10-27 09:08:26', 1, '2026-10-27 09:08:26', '2026-10-27 09:10:26', NULL),
(77, 1, 6, 'published', 0, NULL, NULL, '2026-10-27 09:09:57', 1, '2026-10-27 09:09:57', '2026-10-27 09:10:26', NULL),
(78, 1, 7, 'published', 0, NULL, NULL, '2026-10-27 09:10:04', 1, '2026-10-27 09:10:04', '2026-10-27 09:10:26', NULL),
(79, 1, 8, 'published', 0, NULL, NULL, '2026-10-27 09:10:15', 1, '2026-10-27 09:10:15', '2026-10-27 09:10:26', NULL),
(80, 1, 9, 'published', 1, NULL, NULL, '2026-10-27 09:10:26', 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `workflow_routes`
--
CREATE TABLE `workflow_routes` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `from_step_id` bigint UNSIGNED NOT NULL,
  `to_step_id` bigint UNSIGNED NOT NULL,
  `action_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_return_route` tinyint(1) NOT NULL DEFAULT '0',
  `condition_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `route_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `required_approvals_count` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_routes`
--

INSERT INTO `workflow_routes` (`id`, `workflow_definition_id`, `from_step_id`, `to_step_id`, `action_code`, `is_return_route`, `condition_expression`, `route_group`, `required_approvals_count`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 2, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, 1, 2, 3, 'approve', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 1, 2, 1, 'return', 1, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, 2, 4, 5, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(5, 2, 5, 6, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(6, 2, 6, 7, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(7, 2, 7, 8, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(8, 2, 8, 9, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(9, 2, 9, 10, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(10, 2, 10, 11, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(11, 2, 11, 12, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(12, 2, 12, 13, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(13, 2, 13, 14, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(14, 2, 14, 15, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(15, 2, 15, 16, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(16, 2, 16, 17, 'submit', 0, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(17, 2, 9, 4, 'return', 1, NULL, NULL, NULL, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(18, 3, 18, 19, 'submit', 0, NULL, NULL, NULL, '2026-03-09 15:50:23', '2026-03-09 15:50:23', NULL),
(19, 4, 20, 21, 'submit', 0, NULL, NULL, NULL, '2026-03-09 15:56:26', '2026-03-09 15:56:26', NULL),
(20, 4, 21, 20, 'submit', 0, NULL, NULL, NULL, '2026-03-09 15:56:48', '2026-03-09 15:56:48', NULL),
(21, 5, 22, 23, 'submit', 0, NULL, NULL, NULL, '2026-03-09 16:30:24', '2026-03-09 16:30:24', NULL),
(22, 5, 23, 22, 'submit', 0, NULL, NULL, NULL, '2026-03-09 16:30:24', '2026-03-09 16:30:24', NULL),
(37, 7, 43, 38, 'return', 1, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(38, 7, 38, 39, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(39, 7, 39, 40, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(40, 7, 40, 41, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(41, 7, 41, 42, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(42, 7, 42, 43, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(43, 7, 43, 44, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(44, 7, 44, 45, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(45, 7, 45, 46, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(46, 7, 46, 47, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(47, 7, 47, 48, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(48, 7, 48, 49, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(49, 7, 49, 50, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(50, 7, 50, 51, 'submit', 0, NULL, NULL, NULL, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(54, 16, 70, 71, 'submit', 0, NULL, NULL, NULL, '2026-09-13 14:43:22', '2026-09-13 14:43:22', NULL),
(55, 16, 71, 70, 'return', 1, NULL, NULL, NULL, '2026-09-13 14:43:22', '2026-09-13 14:49:48', NULL),
(56, 17, 73, 74, 'approve', 0, NULL, NULL, NULL, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(57, 17, 73, 72, 'return', 1, NULL, NULL, NULL, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(58, 17, 72, 73, 'submit', 0, NULL, NULL, NULL, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(64, 32, 146, 147, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:09', '2026-09-25 15:16:09', NULL),
(65, 33, 154, 155, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(66, 33, 155, 156, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:22', '2026-09-25 15:16:22', NULL),
(67, 34, 162, 163, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(68, 34, 163, 164, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(69, 34, 164, 165, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:36', '2026-09-25 15:16:36', NULL),
(70, 35, 170, 171, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(71, 35, 171, 172, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(72, 35, 172, 173, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(73, 35, 173, 174, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:51', '2026-09-25 15:16:51', NULL),
(74, 36, 178, 179, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(75, 36, 179, 180, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(76, 36, 180, 181, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(77, 36, 181, 182, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(78, 36, 181, 182, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:08', '2026-09-25 15:17:08', NULL),
(79, 37, 186, 187, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(80, 37, 187, 188, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(81, 37, 188, 189, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(82, 37, 190, 191, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:13', '2026-09-25 15:17:29', NULL),
(83, 37, 189, 190, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(84, 38, 194, 195, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(85, 38, 195, 196, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(86, 38, 196, 197, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(87, 38, 198, 199, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(88, 38, 197, 198, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(89, 38, 199, 200, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:41', '2026-09-25 15:17:41', NULL),
(90, 39, 202, 203, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(91, 39, 203, 204, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(92, 39, 204, 205, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(93, 39, 206, 207, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(94, 39, 205, 206, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(95, 39, 207, 208, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(96, 39, 208, 209, 'submit', 0, NULL, NULL, NULL, '2026-09-25 15:17:54', '2026-09-25 15:17:54', NULL),
(97, 40, 210, 211, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(98, 40, 211, 212, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(99, 40, 212, 213, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(100, 40, 214, 215, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(101, 40, 213, 214, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(102, 40, 215, 216, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(103, 40, 216, 217, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(104, 41, 218, 219, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(105, 41, 219, 220, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(106, 41, 220, 221, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(107, 41, 222, 223, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(108, 41, 221, 222, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(109, 41, 223, 224, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(110, 41, 224, 225, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(111, 42, 226, 227, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(112, 42, 227, 228, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(113, 42, 228, 229, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(114, 42, 230, 231, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(115, 42, 229, 230, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(116, 42, 231, 232, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(117, 42, 232, 233, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(118, 43, 234, 235, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(119, 43, 235, 236, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(120, 43, 236, 237, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(121, 43, 238, 239, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(122, 43, 237, 238, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(123, 43, 239, 240, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(124, 43, 240, 241, 'submit', 0, NULL, NULL, NULL, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(125, 44, 242, 243, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(126, 44, 243, 244, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(127, 44, 244, 245, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(128, 44, 246, 247, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(129, 44, 245, 246, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(130, 44, 247, 248, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(131, 44, 248, 249, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(132, 45, 250, 251, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(133, 45, 251, 252, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(134, 45, 252, 253, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(135, 45, 254, 255, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(136, 45, 253, 254, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(137, 45, 255, 256, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(138, 45, 256, 257, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(139, 46, 259, 260, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(140, 46, 260, 261, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(141, 46, 261, 262, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(142, 46, 263, 264, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(143, 46, 262, 263, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(144, 46, 264, 265, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(145, 46, 265, 266, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(146, 47, 268, 269, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(147, 47, 269, 270, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(148, 47, 270, 271, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(149, 47, 272, 273, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(150, 47, 271, 272, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(151, 47, 273, 274, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(152, 47, 274, 275, 'submit', 0, NULL, NULL, NULL, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(153, 50, 291, 292, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(154, 50, 292, 293, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(155, 50, 293, 294, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(156, 50, 295, 296, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(157, 50, 294, 295, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(158, 50, 296, 297, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(159, 50, 297, 298, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(160, 54, 336, 337, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:14', '2026-09-29 16:55:14', NULL),
(161, 55, 344, 345, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(162, 55, 345, 346, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:24', '2026-09-29 16:55:24', NULL),
(163, 56, 352, 353, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(164, 56, 353, 354, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(165, 56, 354, 355, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:34', '2026-09-29 16:55:34', NULL),
(166, 57, 360, 361, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(167, 57, 361, 362, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(168, 57, 362, 363, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(169, 57, 363, 364, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:45', '2026-09-29 16:55:45', NULL),
(170, 58, 368, 369, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(171, 58, 369, 370, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(172, 58, 370, 371, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(173, 58, 371, 372, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(174, 58, 372, 373, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:55:56', '2026-09-29 16:55:56', NULL),
(175, 59, 376, 377, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(176, 59, 377, 378, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(177, 59, 378, 379, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(178, 59, 379, 380, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(179, 59, 380, 381, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(180, 59, 381, 382, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:16', '2026-09-29 16:56:16', NULL),
(181, 60, 384, 385, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(182, 60, 385, 386, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(183, 60, 386, 387, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(184, 60, 387, 388, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(185, 60, 388, 389, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(186, 60, 389, 390, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(187, 60, 390, 391, 'submit', 0, NULL, NULL, NULL, '2026-09-29 16:56:28', '2026-09-29 16:56:28', NULL),
(188, 61, 392, 393, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(189, 61, 393, 394, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(190, 61, 394, 395, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(191, 61, 395, 396, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(192, 61, 396, 397, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(193, 61, 397, 398, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(194, 61, 398, 399, 'submit', 0, NULL, NULL, NULL, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(195, 62, 401, 400, 'return', 1, NULL, NULL, NULL, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(196, 62, 400, 401, 'submit', 0, NULL, NULL, NULL, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(197, 63, 403, 402, 'return', 1, NULL, NULL, NULL, '2026-09-30 12:32:33', '2026-09-30 12:32:33', NULL),
(198, 63, 402, 403, 'submit', 0, NULL, NULL, NULL, '2026-09-30 12:32:33', '2026-09-30 12:32:33', NULL),
(199, 64, 406, 405, 'return', 1, NULL, NULL, NULL, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(200, 64, 405, 406, 'submit', 0, NULL, NULL, NULL, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(201, 65, 408, 409, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(202, 65, 409, 410, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(203, 65, 410, 411, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(204, 65, 411, 412, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(205, 65, 412, 413, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(206, 65, 413, 414, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(207, 65, 414, 415, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(208, 66, 416, 417, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(209, 66, 417, 418, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(210, 66, 418, 419, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(211, 66, 419, 420, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(212, 66, 420, 421, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(213, 66, 421, 422, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(214, 66, 422, 423, 'submit', 0, NULL, NULL, NULL, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(215, 67, 425, 426, 'approve', 0, NULL, NULL, NULL, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(216, 67, 425, 424, 'return', 1, NULL, NULL, NULL, '2026-10-20 09:54:10', '2026-10-20 09:54:10', '2026-10-20 09:54:10'),
(217, 67, 424, 425, 'submit', 0, NULL, NULL, NULL, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(218, 68, 427, 428, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(219, 68, 428, 429, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(220, 68, 429, 430, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(221, 68, 430, 431, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(222, 68, 431, 432, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(223, 68, 432, 433, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(224, 68, 433, 434, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(225, 69, 435, 436, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(226, 69, 436, 437, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(227, 69, 437, 438, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(228, 69, 438, 439, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(229, 69, 439, 440, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(230, 69, 440, 441, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(231, 69, 441, 442, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(232, 70, 443, 444, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(233, 70, 444, 445, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(234, 70, 445, 446, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(235, 70, 446, 447, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(236, 70, 447, 448, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(237, 70, 448, 449, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(238, 70, 449, 450, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(239, 71, 451, 452, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(240, 71, 452, 453, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(241, 71, 453, 454, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(242, 71, 454, 455, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(243, 71, 455, 456, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(244, 71, 456, 457, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(245, 71, 457, 458, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(246, 72, 459, 460, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(247, 72, 460, 461, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(248, 72, 461, 462, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(249, 72, 462, 463, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(250, 72, 463, 464, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(251, 72, 464, 465, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(252, 72, 465, 466, 'submit', 0, NULL, NULL, NULL, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(253, 73, 467, 468, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(254, 73, 468, 469, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(255, 73, 469, 470, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(256, 73, 470, 471, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(257, 73, 471, 472, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(258, 73, 472, 473, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(259, 73, 473, 474, 'submit', 0, NULL, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(260, 74, 475, 476, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(261, 74, 476, 477, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(262, 74, 477, 478, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(263, 74, 478, 479, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(264, 74, 479, 480, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(265, 74, 480, 481, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(266, 74, 481, 482, 'submit', 0, NULL, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(267, 75, 484, 485, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(268, 75, 483, 484, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(269, 76, 487, 488, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(270, 76, 486, 487, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(271, 77, 490, 491, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(272, 77, 489, 490, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(273, 78, 493, 494, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(274, 78, 492, 493, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(275, 79, 496, 497, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(276, 79, 495, 496, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(277, 80, 499, 500, 'approve', 0, NULL, NULL, NULL, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(278, 80, 498, 499, 'submit', 0, NULL, NULL, NULL, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `workflow_steps`
--
CREATE TABLE `workflow_steps` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_definition_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order_number` int UNSIGNED NOT NULL DEFAULT '1',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `stage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `sla_minutes` int UNSIGNED NOT NULL DEFAULT '0',
  `is_start` tinyint(1) NOT NULL DEFAULT '0',
  `is_end` tinyint(1) NOT NULL DEFAULT '0',
  `is_end_user` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_steps`
--

INSERT INTO `workflow_steps` (`id`, `workflow_definition_id`, `parent_id`, `order_number`, `code`, `name`, `stage`, `office_id`, `sla_minutes`, `is_start`, `is_end`, `is_end_user`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, 1, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 1, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, 2, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 2880, 1, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(5, 2, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 2880, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(6, 2, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 2880, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(7, 2, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 2880, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(8, 2, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(9, 2, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(10, 2, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(11, 2, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 2880, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(12, 2, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(13, 2, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(14, 2, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(15, 2, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(16, 2, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 2880, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(17, 2, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 2880, 0, 1, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(18, 3, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 15:49:26', '2026-03-09 15:49:26', NULL),
(19, 3, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 15:49:41', '2026-03-09 15:49:41', NULL),
(20, 4, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 15:56:26', '2026-03-09 15:56:26', NULL),
(21, 4, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 15:56:26', '2026-03-09 15:56:26', NULL),
(22, 5, NULL, 1, 'ridz', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 16:30:24', '2026-09-13 14:43:17', NULL),
(23, 5, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 16:30:24', '2026-03-09 16:30:24', NULL),
(38, 7, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 2880, 1, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(39, 7, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 2880, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(40, 7, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 2880, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(41, 7, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 2880, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(42, 7, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(43, 7, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(44, 7, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(45, 7, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 2880, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(46, 7, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(47, 7, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(48, 7, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(49, 7, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(50, 7, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 2880, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(51, 7, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 2880, 0, 1, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(70, 16, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-09-13 14:43:22', '2026-09-13 14:49:48', NULL),
(71, 16, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, 0, '2026-09-13 14:43:22', '2026-09-13 14:49:48', NULL),
(72, 17, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 0, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(73, 17, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-09-13 16:53:40', '2026-09-24 11:04:24', NULL),
(74, 17, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(98, 26, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 1, '2026-09-25 14:58:07', '2026-09-25 14:58:07', NULL),
(99, 26, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 14:59:10', '2026-09-25 14:59:10', NULL),
(100, 26, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:01:04', '2026-09-25 15:01:04', NULL),
(101, 26, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:04:57', '2026-09-25 15:04:57', NULL),
(102, 26, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:06:04', '2026-09-25 15:06:04', NULL),
(103, 26, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:07:29', '2026-09-25 15:07:29', NULL),
(104, 26, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-25 15:08:29', '2026-09-25 15:08:29', NULL),
(105, 26, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:09:33', '2026-09-25 15:09:33', NULL),
(106, 27, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(107, 27, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(108, 27, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(109, 27, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(110, 27, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(111, 27, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(112, 27, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(113, 27, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:12:20', '2026-09-25 15:12:20', NULL),
(114, 28, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(115, 28, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(116, 28, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(117, 28, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(118, 28, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(119, 28, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(120, 28, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(121, 28, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:13:32', '2026-09-25 15:13:32', NULL),
(122, 29, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(123, 29, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(124, 29, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(125, 29, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(126, 29, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(127, 29, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(128, 29, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(129, 29, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:14:13', '2026-09-25 15:14:13', NULL),
(130, 30, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(131, 30, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(132, 30, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(133, 30, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(134, 30, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(135, 30, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(136, 30, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(137, 30, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:15:34', '2026-09-25 15:15:34', NULL),
(138, 31, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(139, 31, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(140, 31, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(141, 31, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(142, 31, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(143, 31, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(144, 31, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:54', NULL),
(145, 31, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:15:47', '2026-09-25 15:15:47', NULL),
(146, 32, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(147, 32, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(148, 32, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(149, 32, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(150, 32, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(151, 32, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(152, 32, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(153, 32, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:16:00', '2026-09-25 15:16:00', NULL),
(154, 33, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(155, 33, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(156, 33, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(157, 33, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(158, 33, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(159, 33, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(160, 33, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(161, 33, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:16:13', '2026-09-25 15:16:13', NULL),
(162, 34, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(163, 34, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(164, 34, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(165, 34, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(166, 34, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(167, 34, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(168, 34, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(169, 34, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:16:28', '2026-09-25 15:16:28', NULL),
(170, 35, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(171, 35, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(172, 35, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(173, 35, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(174, 35, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(175, 35, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(176, 35, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(177, 35, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:16:41', '2026-09-25 15:16:41', NULL),
(178, 36, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(179, 36, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(180, 36, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(181, 36, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(182, 36, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(183, 36, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(184, 36, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(185, 36, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:16:57', '2026-09-25 15:16:57', NULL),
(186, 37, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(187, 37, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(188, 37, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(189, 37, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(190, 37, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(191, 37, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(192, 37, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(193, 37, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:17:13', '2026-09-25 15:17:13', NULL),
(194, 38, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(195, 38, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(196, 38, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(197, 38, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(198, 38, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(199, 38, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(200, 38, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(201, 38, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:17:34', '2026-09-25 15:17:34', NULL),
(202, 39, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 24, 100, 1, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(203, 39, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(204, 39, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(205, 39, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(206, 39, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(207, 39, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(208, 39, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(209, 39, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-25 15:17:45', '2026-09-25 15:17:45', NULL),
(210, 40, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:14:17', NULL),
(211, 40, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 10, 20, 0, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(212, 40, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(213, 40, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(214, 40, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(215, 40, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(216, 40, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(217, 40, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-27 14:13:53', '2026-09-27 14:13:53', NULL),
(218, 41, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(219, 41, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:44', NULL),
(220, 41, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 24, 10, 0, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(221, 41, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(222, 41, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(223, 41, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(224, 41, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(225, 41, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-27 14:14:30', '2026-09-27 14:14:30', NULL),
(226, 42, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(227, 42, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(228, 42, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:12', NULL),
(229, 42, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 9, 9, 0, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(230, 42, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(231, 42, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(232, 42, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(233, 42, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-27 14:15:04', '2026-09-27 14:15:04', NULL),
(234, 43, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(235, 43, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(236, 43, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(237, 43, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:47', NULL),
(238, 43, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(239, 43, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(240, 43, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 1, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(241, 43, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-27 14:15:25', '2026-09-27 14:15:25', NULL),
(242, 44, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(243, 44, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(244, 44, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(245, 44, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(246, 44, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(247, 44, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(248, 44, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:38', NULL),
(249, 44, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-28 09:20:34', '2026-09-28 09:20:34', NULL),
(250, 45, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(251, 45, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(252, 45, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(253, 45, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(254, 45, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(255, 45, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(256, 45, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(257, 45, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-28 09:27:45', '2026-09-28 09:27:45', NULL),
(258, 45, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 24, 0, 0, 0, 0, '2026-09-28 09:28:13', '2026-09-28 09:28:13', NULL),
(259, 46, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(260, 46, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(261, 46, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(262, 46, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(263, 46, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(264, 46, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(265, 46, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(266, 46, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 1, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:40', NULL),
(267, 46, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, 0, '2026-09-28 09:31:40', '2026-09-28 09:31:54', NULL),
(268, 47, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(269, 47, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(270, 47, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(271, 47, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(272, 47, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(273, 47, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(274, 47, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(275, 47, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:16', NULL),
(276, 47, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, 0, '2026-09-28 09:32:11', '2026-09-28 09:32:11', NULL),
(277, 47, NULL, 10, 'it_procurements_10', 'Return GSO Approve PR to end user', 'PR numbering', 24, 60, 0, 0, 0, '2026-09-28 09:33:29', '2026-09-28 09:33:29', NULL),
(278, 47, NULL, 11, 'it_procurements_11', 'Submit PR to CTO (availability of funds)', 'Availability of funds', 5, 58, 0, 0, 0, '2026-09-28 09:35:21', '2026-09-28 09:35:21', NULL),
(279, 47, NULL, 12, 'it_procurements_12', 'Return CTO approve PR to  End user', 'Availability of funds', 24, 60, 0, 0, 0, '2026-09-28 09:36:00', '2026-09-28 09:36:00', NULL),
(280, 47, NULL, 13, 'it_procurements_13', 'Submit PR to CBO (Availability of Appropriation)', 'Availability of Appropriation', 9, 60, 0, 0, 0, '2026-09-28 09:36:47', '2026-09-28 09:36:47', NULL),
(281, 47, NULL, 14, 'it_procurements_14', 'Submit Pr to Mayor Office (Approval)', 'Mayors Approval', 1, 58, 0, 0, 0, '2026-09-28 09:37:46', '2026-09-28 09:37:46', NULL),
(282, 47, NULL, 15, 'it_procurements_15', 'Return Approve Pr to CBO', 'Mayors Approval', 9, 60, 0, 0, 0, '2026-09-28 09:38:27', '2026-09-28 09:38:27', NULL),
(283, 47, NULL, 16, 'it_procurements_16', 'Submit PR to PAAD', 'PR submission', 10, 60, 0, 0, 0, '2026-09-28 09:39:16', '2026-09-28 09:39:16', NULL),
(284, 47, NULL, 17, 'it_procurements_17', 'Conduct Bidding and Awarding', 'Bids and Awards', 25, 58, 0, 0, 0, '2026-09-28 09:47:01', '2026-09-28 09:47:01', NULL),
(285, 47, NULL, 18, 'it_procurements_18', 'Create Contract', 'Contract', 10, 60, 0, 0, 0, '2026-09-28 09:51:04', '2026-09-28 09:51:04', NULL),
(286, 47, NULL, 19, 'it_procurements_19', 'awda', 'wadawd', 21, 60, 0, 1, 0, '2026-09-29 15:27:22', '2026-09-29 15:27:22', NULL),
(287, 48, NULL, 1, 'wadawd_1', 'step1 trial', 'stepp1', 21, 120, 1, 0, 0, '2026-09-29 15:34:30', '2026-09-29 15:34:30', NULL),
(288, 48, NULL, 2, 'wadawd_2', 'step2', 'steppp2', 25, 60, 0, 1, 0, '2026-09-29 15:37:11', '2026-09-29 15:37:11', NULL),
(289, 49, NULL, 1, 'wadawd_1', 'step1 trial', 'stepp1', 21, 120, 1, 0, 0, '2026-09-29 15:37:52', '2026-09-29 15:37:52', NULL),
(290, 49, NULL, 2, 'wadawd_2', 'step2', 'steppp2', 25, 60, 0, 0, 0, '2026-09-29 15:37:52', '2026-09-29 15:37:55', NULL),
(291, 50, NULL, 1, 'it_procurements_1', 'Create Annual Investment Plan', 'Planning', 10, 100, 1, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:42', '2026-09-29 16:23:42'),
(292, 50, NULL, 2, 'it_procurements_2', 'Return Approve AIP to end user', 'Planning', 24, 20, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:44', '2026-09-29 16:23:44'),
(293, 50, NULL, 3, 'it_procurements_3', 'Create PPMP', 'Planning', 9, 10, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:48', '2026-09-29 16:23:48'),
(294, 50, NULL, 4, 'it_procurements_4', 'Release Appropriation', 'Budgeting', 24, 9, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:51', '2026-09-29 16:23:51'),
(295, 50, NULL, 5, 'it_procurements_5', 'Create Technical Specification', 'PR Preparation', 24, 10, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:54', '2026-09-29 16:23:54'),
(296, 50, NULL, 6, 'it_procurements_6', 'Return Approve AIP to end user', 'PR preparation', 24, 20, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:58', '2026-09-29 16:23:58'),
(297, 50, NULL, 7, 'it_procurements_7', 'Create Market Scanning', 'PR Preparation', 24, 90, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:01', '2026-09-29 16:24:01'),
(298, 50, NULL, 8, 'it_procurements_8', 'Create PR', 'PR  Planning', 24, 80, 1, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:40', NULL),
(299, 50, NULL, 9, 'it_procurements_9', 'Submit PR to GSO (numbering/checking)', 'PR numbering', 8, 0, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(300, 50, NULL, 10, 'it_procurements_10', 'Return GSO Approve PR to end user', 'PR numbering', 24, 60, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(301, 50, NULL, 11, 'it_procurements_11', 'Submit PR to CTO (availability of funds)', 'Availability of funds', 5, 58, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(302, 50, NULL, 12, 'it_procurements_12', 'Return CTO approve PR to  End user', 'Availability of funds', 24, 60, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(303, 50, NULL, 13, 'it_procurements_13', 'Submit PR to CBO (Availability of Appropriation)', 'Availability of Appropriation', 9, 60, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(304, 50, NULL, 14, 'it_procurements_14', 'Submit Pr to Mayor Office (Approval)', 'Mayors Approval', 1, 58, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(305, 50, NULL, 15, 'it_procurements_15', 'Return Approve Pr to CBO', 'Mayors Approval', 9, 60, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:23:40', NULL),
(306, 50, NULL, 16, 'it_procurements_16', 'Submit PR to PAAD', 'PR submission', 10, 60, 0, 1, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:29', NULL),
(307, 50, NULL, 17, 'it_procurements_17', 'Conduct Bidding and Awarding', 'Bids and Awards', 25, 58, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:17', '2026-09-29 16:24:17'),
(308, 50, NULL, 18, 'it_procurements_18', 'Create Contract', 'Contract', 10, 60, 0, 0, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:22', '2026-09-29 16:24:22'),
(309, 50, NULL, 19, 'it_procurements_19', 'awda', 'wadawd', 21, 60, 0, 1, 0, '2026-09-29 16:23:40', '2026-09-29 16:24:20', '2026-09-29 16:24:20'),
(328, 53, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:33:36', '2026-09-29 16:33:36', NULL),
(329, 53, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:34:50', '2026-09-29 16:34:50', NULL),
(330, 53, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:35:35', '2026-09-29 16:35:35', NULL),
(331, 53, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:36:14', '2026-09-29 16:36:14', NULL),
(332, 53, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:36:56', '2026-09-29 16:36:56', NULL),
(333, 53, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:37:32', '2026-09-29 16:37:32', NULL),
(334, 53, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:38:23', '2026-09-29 16:38:23', NULL),
(335, 53, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:42:34', '2026-09-29 16:42:34', NULL),
(336, 54, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(337, 54, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(338, 54, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(339, 54, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(340, 54, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(341, 54, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(342, 54, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(343, 54, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:52:28', '2026-09-29 16:52:28', NULL),
(344, 55, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(345, 55, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(346, 55, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(347, 55, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(348, 55, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(349, 55, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(350, 55, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(351, 55, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:55:17', '2026-09-29 16:55:17', NULL),
(352, 56, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(353, 56, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(354, 56, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(355, 56, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(356, 56, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(357, 56, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(358, 56, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(359, 56, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:55:27', '2026-09-29 16:55:27', NULL),
(360, 57, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(361, 57, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(362, 57, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(363, 57, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(364, 57, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(365, 57, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(366, 57, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(367, 57, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:55:37', '2026-09-29 16:55:37', NULL),
(368, 58, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(369, 58, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(370, 58, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(371, 58, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(372, 58, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(373, 58, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(374, 58, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(375, 58, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:55:49', '2026-09-29 16:55:49', NULL),
(376, 59, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(377, 59, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(378, 59, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(379, 59, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(380, 59, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(381, 59, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(382, 59, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(383, 59, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:56:08', '2026-09-29 16:56:08', NULL),
(384, 60, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(385, 60, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(386, 60, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(387, 60, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(388, 60, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(389, 60, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(390, 60, NULL, 7, 'procurement_it_equipment_7', 'CMO return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(391, 60, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 16:56:20', '2026-09-29 16:56:20', NULL),
(392, 61, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(393, 61, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(394, 61, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to CTO', 'Availability of funds', 5, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(395, 61, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(396, 61, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(397, 61, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL);
INSERT INTO `workflow_steps` (`id`, `workflow_definition_id`, `parent_id`, `order_number`, `code`, `name`, `stage`, `office_id`, `sla_minutes`, `is_start`, `is_end`, `is_end_user`, `created_at`, `updated_at`, `deleted_at`) VALUES
(398, 61, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:15', NULL),
(399, 61, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-09-29 17:15:05', '2026-09-29 17:15:05', NULL),
(400, 62, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(401, 62, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, 0, '2026-09-30 12:31:59', '2026-09-30 12:31:59', NULL),
(402, 63, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-09-30 12:32:32', '2026-09-30 12:32:32', NULL),
(403, 63, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, 0, '2026-09-30 12:32:32', '2026-09-30 12:32:32', NULL),
(404, 63, 402, 3, 'communication_3', 'bry', NULL, 23, 60, 0, 0, 0, '2026-09-30 12:33:10', '2026-09-30 12:33:10', NULL),
(405, 64, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(406, 64, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, 0, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(407, 64, NULL, 3, 'communication_3', 'bry', NULL, 23, 60, 0, 0, 0, '2026-09-30 12:33:37', '2026-09-30 12:33:37', NULL),
(408, 65, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(409, 65, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(410, 65, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:28', NULL),
(411, 65, NULL, 4, 'procurement_it_equipment_4', 'CTO  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(412, 65, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(413, 65, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(414, 65, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(415, 65, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-04 09:33:21', '2026-10-04 09:33:21', NULL),
(416, 66, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(417, 66, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(418, 66, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(419, 66, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:39', NULL),
(420, 66, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(421, 66, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(422, 66, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(423, 66, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-04 09:33:33', '2026-10-04 09:33:33', NULL),
(424, 67, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(425, 67, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(426, 67, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(427, 68, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(428, 68, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(429, 68, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(430, 68, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 1, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(431, 68, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(432, 68, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(433, 68, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(434, 68, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-20 13:28:34', '2026-10-20 13:28:34', NULL),
(435, 69, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', 8, 0, 1, 0, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(436, 69, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 24, 120, 0, 0, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(437, 69, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(438, 69, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', 24, 120, 0, 0, 1, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(439, 69, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(440, 69, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(441, 69, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(442, 69, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-20 13:29:30', '2026-10-20 13:29:30', NULL),
(443, 70, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', NULL, 0, 1, 0, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(444, 70, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 8, 120, 0, 0, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(445, 70, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(446, 70, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', NULL, 120, 0, 0, 1, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(447, 70, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(448, 70, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(449, 70, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(450, 70, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-20 13:33:14', '2026-10-20 13:33:14', NULL),
(451, 71, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', NULL, 0, 1, 0, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(452, 71, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 8, 120, 0, 0, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(453, 71, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(454, 71, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', NULL, 120, 0, 0, 1, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(455, 71, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(456, 71, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(457, 71, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:16', NULL),
(458, 71, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-20 13:36:15', '2026-10-20 13:36:15', NULL),
(459, 72, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', NULL, 0, 1, 0, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(460, 72, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 8, 120, 0, 0, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(461, 72, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(462, 72, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', NULL, 120, 0, 0, 1, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(463, 72, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(464, 72, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(465, 72, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(466, 72, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-20 13:40:10', '2026-10-20 13:40:10', NULL),
(467, 73, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', NULL, 0, 1, 0, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(468, 73, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 8, 120, 0, 0, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(469, 73, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(470, 73, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', NULL, 120, 0, 0, 1, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(471, 73, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(472, 73, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(473, 73, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(474, 73, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(475, 74, NULL, 1, 'procurement_it_equipment_1', 'Submit PR to GSO', 'PR numbering', NULL, 0, 1, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(476, 74, NULL, 2, 'procurement_it_equipment_2', 'GSO return approve PR to end user', 'PR numbering', 8, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(477, 74, NULL, 3, 'procurement_it_equipment_3', 'Submit PR to OCT', 'Availability of funds', 5, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(478, 74, NULL, 4, 'procurement_it_equipment_4', 'OCT  Return approve PR to  End user', 'Availability of funds', NULL, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(479, 74, NULL, 5, 'procurement_it_equipment_5', 'Submit PR to CBO', 'Availability of Appropriation', 9, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(480, 74, NULL, 6, 'procurement_it_equipment_6', 'Submit Pr to Mayor Office', 'Mayor Approval', 1, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(481, 74, NULL, 7, 'procurement_it_equipment_7', 'Mayor Office return approve PR to CBO', 'Mayor Approval', 9, 120, 0, 0, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(482, 74, NULL, 8, 'procurement_it_equipment_8', 'Submit PR to PAAD', 'PR submission', 26, 120, 0, 1, 0, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL),
(483, 75, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(484, 75, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(485, 75, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(486, 76, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(487, 76, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(488, 76, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(489, 77, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(490, 77, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(491, 77, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(492, 78, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(493, 78, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(494, 78, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(495, 79, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(496, 79, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(497, 79, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(498, 80, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 2880, 1, 0, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(499, 80, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 2880, 0, 0, 0, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(500, 80, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 4320, 0, 1, 0, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `workflow_step_data`
--
CREATE TABLE `workflow_step_data` (
  `id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `display_order` int UNSIGNED NOT NULL DEFAULT '0',
  `min_length` int UNSIGNED DEFAULT NULL,
  `max_length` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workflow_step_data`
--

INSERT INTO `workflow_step_data` (`id`, `workflow_step_id`, `code`, `display_name`, `type`, `is_required`, `display_order`, `min_length`, `max_length`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 467, 'awdawdawd', 'awdawd', 'text', 0, 0, NULL, NULL, '2026-10-25 12:18:38', '2026-10-25 12:18:38', NULL),
(2, 475, 'awdawdawd', 'awdawd', 'text', 0, 0, NULL, NULL, '2026-10-26 08:53:01', '2026-10-26 08:53:01', NULL);

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
  ADD KEY `transactions_office_id_foreign` (`office_id`),
  ADD KEY `transactions_is_archive_index` (`is_archive`),
  ADD KEY `transactions_is_private_index` (`is_private`);

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
  ADD KEY `fk_ta_user` (`uploaded_by`),
  ADD KEY `ix_ta_source` (`source_attachment_id`);

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
  ADD UNIQUE KEY `transaction_types_code_unique` (`code`),
  ADD KEY `foreign_key_office_created_by` (`createdby_office`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD KEY `users_office_id_foreign` (`office_id`),
  ADD KEY `users_approved_by_foreign` (`approved_by`);

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=236;

--
-- AUTO_INCREMENT for table `checklist_overrides`
--
ALTER TABLE `checklist_overrides`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=243;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `step_requirements`
--
ALTER TABLE `step_requirements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- AUTO_INCREMENT for table `step_roles`
--
ALTER TABLE `step_roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=663;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `transaction_attachments`
--
ALTER TABLE `transaction_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `transaction_checklist_checks`
--
ALTER TABLE `transaction_checklist_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT for table `transaction_states`
--
ALTER TABLE `transaction_states`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=262;

--
-- AUTO_INCREMENT for table `transaction_types`
--
ALTER TABLE `transaction_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `workflow_definitions`
--
ALTER TABLE `workflow_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `workflow_routes`
--
ALTER TABLE `workflow_routes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=279;

--
-- AUTO_INCREMENT for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=501;

--
-- AUTO_INCREMENT for table `workflow_step_data`
--
ALTER TABLE `workflow_step_data`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  ADD CONSTRAINT `fk_ta_source` FOREIGN KEY (`source_attachment_id`) REFERENCES `transaction_attachments` (`id`) ON DELETE CASCADE,
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
-- Constraints for table `transaction_types`
--
ALTER TABLE `transaction_types`
  ADD CONSTRAINT `foreign_key_office_created_by` FOREIGN KEY (`createdby_office`) REFERENCES `offices` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
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
