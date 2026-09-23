-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260914.9e4dc5b5f4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 23, 2026 at 12:44 AM
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
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` bigint UNSIGNED DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `ip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

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
(22, 1, 'transactions.finalize', 'App\\Models\\Transaction', 15, '{\"reference_number\":\"VYIR-X6GM-MMXP\",\"current_step_id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-21 23:48:27');

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
('laravel-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:1;', 1790055009),
('laravel-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1790055009;', 1790055009),
('laravel-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:6;', 1790063533),
('laravel-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1790063533;', 1790063533),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81', 'i:5;', 1789364911),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81:timer', 'i:1789364911;', 1789364911),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:2;', 1789527931),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1789527931;', 1789527931),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:5;', 1789534780),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1789534780;', 1789534780);

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
) ;

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

--
-- Dumping data for table `field_definition_workflow_step`
--

INSERT INTO `field_definition_workflow_step` (`id`, `workflow_step_id`, `field_definition_id`, `display_order`, `required_override`, `created_at`, `updated_at`) VALUES
(1, 4, 2, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(2, 4, 3, 2, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(3, 4, 4, 3, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(4, 4, 7, 4, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(5, 5, 5, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(6, 6, 6, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(7, 6, 5, 2, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(8, 8, 1, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(9, 26, 5, 2, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(10, 26, 6, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(11, 24, 2, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(12, 24, 3, 2, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(13, 24, 4, 3, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(14, 24, 7, 4, 0, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(15, 28, 1, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(16, 25, 5, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(17, 40, 5, 2, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(18, 40, 6, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(19, 38, 2, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(20, 38, 3, 2, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(21, 38, 4, 3, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(22, 38, 7, 4, 0, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(23, 42, 1, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(24, 39, 5, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26');

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
) ;

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
(43, '2026_09_30_000001_add_is_done_to_transactions_table', 13);

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
(9, 'csd', 'Computer Services Division', NULL, 1, '2026-09-11 18:24:12', '2026-09-11 18:24:12', NULL);

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

--
-- Dumping data for table `office_steps`
--

INSERT INTO `office_steps` (`id`, `office_id`, `parent_id`, `order_number`, `code`, `name`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 9, NULL, 1, 'csd_1', 'Acknowledged', NULL, 1, '2026-09-11 18:33:19', '2026-09-11 18:33:19', NULL),
(2, 9, NULL, 2, 'csd_2', 'Processed', NULL, 1, '2026-09-11 18:33:38', '2026-09-11 18:33:38', NULL),
(3, 9, NULL, 3, 'csd_3', 'Completed', NULL, 1, '2026-09-11 18:33:46', '2026-09-11 18:33:46', NULL);

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
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requirement_definitions`
--

INSERT INTO `requirement_definitions` (`id`, `workflow_definition_id`, `order_number`, `code`, `name`, `description`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 2, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 2, 3, 'dts_created', 'DTS created', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 2, 4, 'pr_encoded', 'PR Number encoded', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, 2, 5, 'city_admin_signed', 'City Admin signed', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, 2, 6, 'treasurer_signed', 'Treasurer signed', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, 2, 7, 'doc_validated', 'Document validated (untampered)', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(8, 2, 8, 'earmark_completed', 'Earmark completed', NULL, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(9, 6, 5, 'city_admin_signed', 'City Admin signed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(10, 6, 7, 'doc_validated', 'Document validated (untampered)', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(11, 6, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(12, 6, 3, 'dts_created', 'DTS created', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(13, 6, 8, 'earmark_completed', 'Earmark completed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(14, 6, 4, 'pr_encoded', 'PR Number encoded', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(15, 6, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(16, 6, 6, 'treasurer_signed', 'Treasurer signed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(17, 7, 5, 'city_admin_signed', 'City Admin signed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(18, 7, 7, 'doc_validated', 'Document validated (untampered)', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(19, 7, 2, 'drive_uploaded', 'Uploaded to Google Drive', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(20, 7, 3, 'dts_created', 'DTS created', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(21, 7, 8, 'earmark_completed', 'Earmark completed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(22, 7, 4, 'pr_encoded', 'PR Number encoded', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(23, 7, 1, 'signed_pr_pdf', 'Signed PR PDF attached', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(24, 7, 6, 'treasurer_signed', 'Treasurer signed', NULL, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26', NULL),
(25, 16, 1, 'comm_logged', 'Communication logged', 'Tick once the communication is received and logged.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(26, 16, 2, 'comm_released', 'Communication released', 'Tick once the communication is released at the end station.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(27, 1, 1, 'dtr_collected', 'DTR collected', 'Tick once DTRs are collected.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(28, 1, 2, 'dtr_validated', 'DTR validated', 'Tick once DTRs are validated.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(29, 1, 3, 'payroll_finalized', 'Payroll finalized', 'Tick once payroll is finalized.', 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03', NULL),
(30, 17, 1, 'dtr_collected', 'DTR collected', 'Tick once DTRs are collected.', 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(31, 17, 2, 'dtr_validated', 'DTR validated', 'Tick once DTRs are validated.', 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(32, 17, 3, 'payroll_finalized', 'Payroll finalized', 'Tick once payroll is finalized.', 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(33, 18, 1, 'comm_logged', 'Communication logged', 'Tick once the communication is received and logged.', 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL),
(34, 18, 2, 'comm_released', 'Communication released', 'Tick once the communication is released at the end station.', 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL);

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
(3, 'clerk', 'Clerk', 'Processes assigned steps.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(4, 'approver', 'Approver', 'Approves steps routed to them.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(5, 'viewer', 'Viewer', 'Read-only access.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(6, 'end_user', 'End User', 'Creates and forwards PR documents.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(7, 'gso', 'GSO', 'General Services Office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(8, 'city_admin', 'City Administrator', 'Signs/approves as City Admin.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(9, 'cto', 'CTO', 'City Treasurer Office reviewer.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(10, 'city_treasurer', 'City Treasurer', 'Signs/approves as Treasurer.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(11, 'cadmin', 'CAdmin', 'City Admin office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(12, 'cbo', 'CBO', 'City Budget Office processor.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL),
(13, 'bac_paad', 'BAC-PAAD', 'Receives final submitted documents.', '2026-03-09 21:24:36', '2026-03-09 21:24:36', NULL);

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
('dM9A3dDWJ1WnXICyd5acxiikr4BlQJcvreQnwTwH', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiWXhCa3RiNkluQTNSdzh2bDU5UGhLdGozd0xyUnFoRGNra0ZZajZaNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvd2VhdGhlciI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjE3OiJwYXNzd29yZF9oYXNoX3dlYiI7czo2NDoiOWIzYTI0N2FkNTM2NDY5ZmEyNjVjYjQxZDkwZDI3Mzc0NTMyMjI1MjJhODdhMWZhYTRmM2Y0MmU3MjAxZjliZCI7fQ==', 1790063483);

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `step_requirements`
--

INSERT INTO `step_requirements` (`id`, `workflow_step_id`, `requirement_definition_id`, `display_order`, `is_required`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(2, 5, 2, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(3, 6, 3, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(4, 8, 4, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(5, 10, 5, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(6, 12, 6, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(7, 15, 7, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(8, 16, 8, 1, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(9, 36, 13, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(10, 35, 10, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(11, 30, 9, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(12, 26, 12, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(13, 24, 15, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(14, 28, 14, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(15, 32, 16, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(16, 25, 11, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(17, 50, 21, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(18, 49, 18, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(19, 44, 17, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(20, 40, 20, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(21, 38, 23, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(22, 42, 22, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(23, 46, 24, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(24, 39, 19, 1, 1, '2026-09-13 17:39:26', '2026-09-13 17:39:26'),
(25, 70, 25, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(26, 71, 26, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(27, 1, 27, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(28, 2, 28, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(29, 3, 29, 1, 1, '2026-09-13 23:01:03', '2026-09-13 23:01:03'),
(30, 72, 30, 1, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(31, 74, 32, 1, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(32, 73, 31, 1, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40'),
(33, 75, 33, 1, 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10'),
(34, 76, 34, 1, 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10');

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
(1, 4, 6, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(2, 5, 6, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(3, 6, 6, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(4, 7, 6, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(5, 8, 7, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(6, 9, 7, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(7, 10, 8, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(8, 11, 6, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(9, 12, 10, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(10, 13, 9, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(11, 14, 11, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(12, 15, 12, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(13, 16, 12, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(14, 17, 13, '2026-03-09 21:24:39', '2026-03-09 21:24:39'),
(15, 24, 6, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(16, 25, 6, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(17, 26, 6, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(18, 27, 6, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(19, 28, 7, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(20, 29, 7, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(21, 30, 8, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(22, 31, 6, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(23, 32, 10, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(24, 33, 9, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(25, 34, 11, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(26, 35, 12, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(27, 36, 12, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(28, 37, 13, '2026-09-11 19:51:53', '2026-09-11 19:51:53'),
(29, 38, 6, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(30, 39, 6, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(31, 40, 6, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(32, 41, 6, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(33, 42, 7, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(34, 43, 7, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(35, 44, 8, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(36, 45, 6, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(37, 46, 10, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(38, 47, 9, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(39, 48, 11, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(40, 49, 12, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(41, 50, 12, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
(42, 51, 13, '2026-09-11 20:07:42', '2026-09-11 20:07:42'),
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
(53, 75, 3, '2026-09-21 23:27:10', '2026-09-21 23:27:10'),
(54, 76, 4, '2026-09-21 23:27:10', '2026-09-21 23:27:10');

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
(9, 2, 7, 9, 'K8JB-EEGG-36OC', 'Lazada', 0, 1, '2026-09-11 22:24:51', '2026-09-11 22:24:51', NULL),
(10, 3, 4, NULL, 'CC5T-ZXED-JAFX', 'Lazada', 0, 1, '2026-09-13 22:42:14', '2026-09-15 19:32:01', '2026-09-15 19:32:01'),
(11, 2, 7, NULL, '4JNN-BZGT-BRYB', 'qwe', 0, 1, '2026-09-13 22:48:16', '2026-09-13 22:48:16', NULL),
(12, 3, 16, NULL, 'LUC2-ULOD-KIFH', 'ewq', 0, 1, '2026-09-13 22:48:28', '2026-09-13 22:48:28', NULL),
(13, 1, 1, NULL, 'OWOB-BEOY-FW1M', 'eqweqwe', 0, 1, '2026-09-13 22:48:43', '2026-09-13 22:48:43', NULL),
(14, 1, 1, NULL, 'HHZB-GGI6-RIQH', 'new', 0, 1, '2026-09-14 00:13:33', '2026-09-14 00:13:33', NULL),
(15, 1, 1, NULL, 'VYIR-X6GM-MMXP', 'BAAA', 1, 1, '2026-09-15 19:18:48', '2026-09-21 23:48:27', NULL),
(16, 1, 1, NULL, 'Z5UP-ADG3-47IT', NULL, 1, 1, '2026-09-20 17:09:18', '2026-09-21 23:47:33', NULL),
(17, 2, 7, NULL, 'G6RW-ZX2H-UUMI', NULL, 0, 1, '2026-09-20 19:10:13', '2026-09-20 19:10:13', NULL),
(18, 2, 7, NULL, '4YD8-5DKW-JCYT', NULL, 0, 1, '2026-09-21 17:15:15', '2026-09-21 17:15:15', NULL);

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
(6, 15, 1, NULL, 31, 'updatedTRANSACTION.sql', 'attachments/15/1/dm6deCRTaM7p9sTUkcZ2uTue6lgU5PduPWt8RWjK.txt', 'local', 'text/plain', 85545, 1, '2026-09-15 19:25:03', '2026-09-15 19:25:05');

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
  `checked_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
(48, 16, 2, 28, 1, '2026-09-21 23:30:09', '2026-09-21 23:30:09', '2026-09-21 23:30:09');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_states`
--
CREATE TABLE `transaction_states` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `current_step_id` bigint UNSIGNED NOT NULL,
  `entered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
(18, 18, 38, '2026-09-21 23:25:43', '2026-09-21 17:15:15', '2026-09-21 23:25:43');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_station_touches`
--
CREATE TABLE `transaction_station_touches` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `workflow_step_id` bigint UNSIGNED NOT NULL,
  `touched_by` bigint UNSIGNED NOT NULL,
  `touched_at` timestamp NOT NULL,
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
  `performed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_step_runs`
--

INSERT INTO `transaction_step_runs` (`id`, `transaction_id`, `from_step_id`, `to_step_id`, `action_code`, `remarks`, `performed_by`, `performed_at`, `created_at`, `updated_at`) VALUES
(1, 1, 18, 18, 'create', 'Transaction created', 1, '2026-03-09 23:51:48', '2026-03-09 23:51:48', '2026-03-09 23:51:48'),
(2, 1, 18, 19, 'submit', NULL, 1, '2026-03-09 23:53:29', '2026-03-09 23:53:29', '2026-03-09 23:53:29'),
(3, 2, 18, 18, 'create', 'Transaction created', 1, '2026-03-09 23:57:06', '2026-03-09 23:57:06', '2026-03-09 23:57:06'),
(4, 2, 18, 19, 'submit', NULL, 1, '2026-03-09 23:57:11', '2026-03-09 23:57:11', '2026-03-09 23:57:11'),
(5, 3, 20, 20, 'create', 'Transaction created', 1, '2026-03-09 23:57:31', '2026-03-09 23:57:31', '2026-03-09 23:57:31'),
(6, 3, 20, 21, 'submit', NULL, 1, '2026-03-09 23:57:36', '2026-03-09 23:57:36', '2026-03-09 23:57:36'),
(7, 3, 21, 20, 'submit', NULL, 1, '2026-03-09 23:57:39', '2026-03-09 23:57:40', '2026-03-09 23:57:40'),
(8, 3, 20, 21, 'submit', NULL, 1, '2026-03-09 23:58:41', '2026-03-09 23:58:41', '2026-03-09 23:58:41'),
(9, 3, 21, 20, 'submit', NULL, 1, '2026-03-10 00:00:39', '2026-03-10 00:00:39', '2026-03-10 00:00:39'),
(10, 4, 20, 20, 'create', 'Transaction created', 1, '2026-03-10 00:32:03', '2026-03-10 00:32:03', '2026-03-10 00:32:03'),
(11, 4, 20, 21, 'submit', 'MEMO', 1, '2026-03-10 00:32:33', '2026-03-10 00:32:33', '2026-03-10 00:32:33'),
(12, 5, 20, 20, 'create', 'Transaction created', 1, '2026-09-11 16:50:34', '2026-09-11 16:50:34', '2026-09-11 16:50:34'),
(16, 9, 38, 38, 'create', 'Transaction created', 1, '2026-09-11 22:24:51', '2026-09-11 22:24:51', '2026-09-11 22:24:51'),
(17, 9, 38, 39, 'submit', 'wako', 1, '2026-09-13 19:36:55', '2026-09-13 19:36:55', '2026-09-13 19:36:55'),
(18, 9, 39, 40, 'submit', NULL, 1, '2026-09-13 20:46:56', '2026-09-13 20:46:56', '2026-09-13 20:46:56'),
(19, 10, 20, 20, 'create', 'Transaction created', 1, '2026-09-13 22:42:14', '2026-09-13 22:42:14', '2026-09-13 22:42:14'),
(20, 11, 38, 38, 'create', 'Transaction created', 1, '2026-09-13 22:48:16', '2026-09-13 22:48:16', '2026-09-13 22:48:16'),
(21, 12, 70, 70, 'create', 'Transaction created', 1, '2026-09-13 22:48:28', '2026-09-13 22:48:28', '2026-09-13 22:48:28'),
(22, 13, 1, 1, 'create', 'Transaction created', 1, '2026-09-13 22:48:43', '2026-09-13 22:48:43', '2026-09-13 22:48:43'),
(23, 12, 70, 71, 'submit', NULL, 1, '2026-09-13 23:04:47', '2026-09-13 23:04:47', '2026-09-13 23:04:47'),
(24, 14, 1, 1, 'create', 'Transaction created', 1, '2026-09-14 00:13:33', '2026-09-14 00:13:33', '2026-09-14 00:13:33'),
(25, 14, 1, 2, 'submit', NULL, 1, '2026-09-14 00:22:19', '2026-09-14 00:22:19', '2026-09-14 00:22:19'),
(26, 14, 2, 3, 'approve', NULL, 1, '2026-09-14 00:39:23', '2026-09-14 00:39:23', '2026-09-14 00:39:23'),
(27, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:18:09', '2026-09-15 19:18:09', '2026-09-15 19:18:09'),
(28, 15, 1, 1, 'create', 'Transaction created', 1, '2026-09-15 19:18:48', '2026-09-15 19:18:48', '2026-09-15 19:18:48'),
(29, 15, 1, 2, 'submit', 'DTR', 1, '2026-09-15 19:19:31', '2026-09-15 19:19:31', '2026-09-15 19:19:31'),
(30, 15, 2, 1, 'return', NULL, 1, '2026-09-15 19:20:06', '2026-09-15 19:20:06', '2026-09-15 19:20:06'),
(31, 15, 1, 2, 'submit', NULL, 1, '2026-09-15 19:25:05', '2026-09-15 19:25:05', '2026-09-15 19:25:05'),
(32, 13, 2, 1, 'return', 'ge', 1, '2026-09-15 19:49:36', '2026-09-15 19:49:36', '2026-09-15 19:49:36'),
(33, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:52:53', '2026-09-15 19:52:53', '2026-09-15 19:52:53'),
(34, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:53:25', '2026-09-15 19:53:25', '2026-09-15 19:53:25'),
(35, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:55:48', '2026-09-15 19:55:48', '2026-09-15 19:55:48'),
(36, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:55:59', '2026-09-15 19:55:59', '2026-09-15 19:55:59'),
(38, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 19:59:35', '2026-09-15 19:59:35', '2026-09-15 19:59:35'),
(39, 13, 2, 1, 'return', NULL, 1, '2026-09-15 19:59:46', '2026-09-15 19:59:46', '2026-09-15 19:59:46'),
(41, 13, 1, 2, 'submit', NULL, 1, '2026-09-15 20:03:35', '2026-09-15 20:03:35', '2026-09-15 20:03:35'),
(42, 13, 2, 1, 'return', NULL, 1, '2026-09-15 20:03:45', '2026-09-15 20:03:45', '2026-09-15 20:03:45'),
(43, 9, 40, 41, 'submit', NULL, 1, '2026-09-20 17:05:15', '2026-09-20 17:05:15', '2026-09-20 17:05:15'),
(44, 16, 1, 1, 'create', 'Transaction created', 1, '2026-09-20 17:09:18', '2026-09-20 17:09:18', '2026-09-20 17:09:18'),
(45, 13, 1, 2, 'submit', NULL, 1, '2026-09-20 17:52:22', '2026-09-20 17:52:22', '2026-09-20 17:52:22'),
(46, 13, 2, 1, 'return', NULL, 1, '2026-09-20 18:09:46', '2026-09-20 18:09:46', '2026-09-20 18:09:46'),
(47, 17, 38, 38, 'create', 'Transaction created', 1, '2026-09-20 19:10:13', '2026-09-20 19:10:13', '2026-09-20 19:10:13'),
(48, 17, 38, 39, 'submit', 'awdawdawdawdawdawdwadaw', 1, '2026-09-20 19:30:52', '2026-09-20 19:30:52', '2026-09-20 19:30:52'),
(49, 17, 39, 40, 'submit', NULL, 1, '2026-09-20 19:32:50', '2026-09-20 19:32:50', '2026-09-20 19:32:50'),
(50, 9, 41, 42, 'submit', NULL, 1, '2026-09-21 16:54:14', '2026-09-21 16:54:14', '2026-09-21 16:54:14'),
(51, 18, 38, 38, 'create', 'Transaction created', 1, '2026-09-21 17:15:15', '2026-09-21 17:15:15', '2026-09-21 17:15:15'),
(52, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 17:18:56', '2026-09-21 17:18:56', '2026-09-21 17:18:56'),
(53, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 17:21:46', '2026-09-21 17:21:46', '2026-09-21 17:21:46'),
(54, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 17:22:45', '2026-09-21 17:22:45', '2026-09-21 17:22:45'),
(55, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 17:26:00', '2026-09-21 17:26:00', '2026-09-21 17:26:00'),
(56, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 17:26:43', '2026-09-21 17:26:43', '2026-09-21 17:26:43'),
(57, 18, 43, 40, 'rewind', 'Rewound to past station', 1, '2026-09-21 18:48:26', '2026-09-21 18:48:26', '2026-09-21 18:48:26'),
(58, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 18:48:26', '2026-09-21 18:48:26', '2026-09-21 18:48:26'),
(59, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 18:55:28', '2026-09-21 18:55:28', '2026-09-21 18:55:28'),
(60, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 18:56:03', '2026-09-21 18:56:03', '2026-09-21 18:56:03'),
(61, 18, 43, 40, 'rewind', 'Rewound to past station', 1, '2026-09-21 18:57:26', '2026-09-21 18:57:26', '2026-09-21 18:57:26'),
(62, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 18:57:27', '2026-09-21 18:57:27', '2026-09-21 18:57:27'),
(63, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 18:57:39', '2026-09-21 18:57:39', '2026-09-21 18:57:39'),
(64, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 18:57:52', '2026-09-21 18:57:52', '2026-09-21 18:57:52'),
(65, 18, 43, 38, 'return', 'hay nako', 1, '2026-09-21 19:04:31', '2026-09-21 19:04:31', '2026-09-21 19:04:31'),
(66, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 19:04:51', '2026-09-21 19:04:51', '2026-09-21 19:04:51'),
(67, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 19:04:57', '2026-09-21 19:04:57', '2026-09-21 19:04:57'),
(68, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 19:05:06', '2026-09-21 19:05:06', '2026-09-21 19:05:06'),
(69, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 19:05:14', '2026-09-21 19:05:14', '2026-09-21 19:05:14'),
(70, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 19:10:05', '2026-09-21 19:10:05', '2026-09-21 19:10:05'),
(71, 18, 43, 38, 'return', 'awdawd', 1, '2026-09-21 21:49:06', '2026-09-21 21:49:06', '2026-09-21 21:49:06'),
(72, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 21:49:22', '2026-09-21 21:49:22', '2026-09-21 21:49:22'),
(73, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 21:49:29', '2026-09-21 21:49:29', '2026-09-21 21:49:29'),
(74, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 21:49:38', '2026-09-21 21:49:38', '2026-09-21 21:49:38'),
(75, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 21:49:47', '2026-09-21 21:49:47', '2026-09-21 21:49:47'),
(76, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 21:49:55', '2026-09-21 21:49:55', '2026-09-21 21:49:55'),
(77, 18, 43, 38, 'return', 'awda', 1, '2026-09-21 21:52:22', '2026-09-21 21:52:22', '2026-09-21 21:52:22'),
(78, 18, 38, 39, 'submit', NULL, 1, '2026-09-21 21:52:53', '2026-09-21 21:52:53', '2026-09-21 21:52:53'),
(79, 18, 39, 40, 'submit', NULL, 1, '2026-09-21 21:57:34', '2026-09-21 21:57:34', '2026-09-21 21:57:34'),
(80, 18, 40, 43, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:54:35', '2026-09-21 22:54:35', '2026-09-21 22:54:35'),
(81, 18, 43, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:55:46', '2026-09-21 22:55:46', '2026-09-21 22:55:46'),
(82, 18, 40, 41, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:55:52', '2026-09-21 22:55:52', '2026-09-21 22:55:52'),
(83, 18, 41, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:56:03', '2026-09-21 22:56:03', '2026-09-21 22:56:03'),
(84, 18, 40, 41, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 22:56:51', '2026-09-21 22:56:51', '2026-09-21 22:56:51'),
(85, 18, 41, 40, 'revisit', 'Jumped to a passed station', 1, '2026-09-21 23:01:30', '2026-09-21 23:01:30', '2026-09-21 23:01:30'),
(86, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 23:15:31', '2026-09-21 23:15:31', '2026-09-21 23:15:31'),
(87, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 23:15:39', '2026-09-21 23:15:39', '2026-09-21 23:15:39'),
(88, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 23:15:49', '2026-09-21 23:15:49', '2026-09-21 23:15:49'),
(89, 18, 43, 40, 'revisit', 'please fix', 1, '2026-09-21 23:16:08', '2026-09-21 23:16:08', '2026-09-21 23:16:08'),
(90, 18, 40, 41, 'submit', NULL, 1, '2026-09-21 23:16:16', '2026-09-21 23:16:16', '2026-09-21 23:16:16'),
(91, 18, 41, 42, 'submit', NULL, 1, '2026-09-21 23:16:30', '2026-09-21 23:16:30', '2026-09-21 23:16:30'),
(92, 18, 42, 43, 'submit', NULL, 1, '2026-09-21 23:16:42', '2026-09-21 23:16:42', '2026-09-21 23:16:42'),
(93, 18, 43, 40, 'revisit', 'please fix', 1, '2026-09-21 23:17:13', '2026-09-21 23:17:13', '2026-09-21 23:17:13'),
(94, 18, 40, 38, 'revisit', 'yamiti kudasai', 1, '2026-09-21 23:25:43', '2026-09-21 23:25:43', '2026-09-21 23:25:43'),
(95, 16, 1, 2, 'submit', NULL, 1, '2026-09-21 23:29:57', '2026-09-21 23:29:57', '2026-09-21 23:29:57'),
(96, 16, 2, 3, 'approve', NULL, 1, '2026-09-21 23:30:10', '2026-09-21 23:30:10', '2026-09-21 23:30:10'),
(97, 16, 3, 3, 'finalize', 'Process finalized', 1, '2026-09-21 23:47:33', '2026-09-21 23:47:33', '2026-09-21 23:47:33'),
(98, 15, 2, 3, 'approve', NULL, 1, '2026-09-21 23:48:17', '2026-09-21 23:48:17', '2026-09-21 23:48:17'),
(99, 15, 3, 3, 'finalize', 'Process finalized', 1, '2026-09-21 23:48:27', '2026-09-21 23:48:27', '2026-09-21 23:48:27');

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
(3, 'communication', 'Communication', NULL, 1, '2026-03-09 23:44:35', '2026-03-09 23:44:35', NULL);

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

INSERT INTO `workflow_definitions` (`id`, `transaction_type_id`, `version`, `status`, `name`, `notes`, `published_at`, `published_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'published', 'Payroll v1', 'Seeded sample workflow (TO VERIFY actual process)', '2026-03-09 21:24:39', 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 2, 1, 'published', 'Purchase Request v1', 'Seeded full PR workflow based on executive summary flow image', '2026-03-09 21:24:39', 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 3, 1, 'published', NULL, NULL, '2026-03-09 23:51:30', 1, '2026-03-09 23:49:10', '2026-03-09 23:51:30', NULL),
(4, 3, 2, 'published', NULL, NULL, '2026-03-09 23:57:22', 1, '2026-03-09 23:56:26', '2026-03-09 23:57:22', NULL),
(5, 3, 3, 'published', NULL, NULL, '2026-09-13 22:43:18', 1, '2026-03-10 00:30:24', '2026-09-13 22:43:18', NULL),
(6, 2, 2, 'draft', NULL, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(7, 2, 3, 'published', NULL, NULL, '2026-09-11 20:12:13', 1, '2026-09-11 20:07:42', '2026-09-11 20:12:13', NULL),
(16, 3, 4, 'published', NULL, NULL, '2026-09-13 22:43:45', 1, '2026-09-13 22:43:22', '2026-09-13 22:43:45', NULL),
(17, 1, 2, 'draft', NULL, NULL, NULL, NULL, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(18, 3, 5, 'draft', NULL, NULL, NULL, NULL, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL);

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
) ;

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
(23, 6, 29, 24, 'return', 1, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(24, 6, 24, 25, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(25, 6, 25, 26, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(26, 6, 26, 27, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(27, 6, 27, 28, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(28, 6, 28, 29, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(29, 6, 29, 30, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(30, 6, 30, 31, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(31, 6, 31, 32, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(32, 6, 32, 33, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(33, 6, 33, 34, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(34, 6, 34, 35, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(35, 6, 35, 36, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(36, 6, 36, 37, 'submit', 0, NULL, NULL, NULL, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
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
(59, 18, 76, 75, 'return', 1, NULL, NULL, NULL, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL),
(60, 18, 75, 76, 'submit', 0, NULL, NULL, NULL, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL);

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

INSERT INTO `workflow_steps` (`id`, `workflow_definition_id`, `parent_id`, `order_number`, `code`, `name`, `stage`, `sla_minutes`, `is_start`, `is_end`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', 2880, 1, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(2, 1, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(3, 1, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', 4320, 0, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(4, 2, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', 2880, 1, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(5, 2, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(6, 2, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(7, 2, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(8, 2, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(9, 2, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(10, 2, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(11, 2, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(12, 2, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(13, 2, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(14, 2, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(15, 2, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(16, 2, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', 2880, 0, 0, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(17, 2, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', 2880, 0, 1, '2026-03-09 21:24:39', '2026-03-09 21:24:39', NULL),
(18, 3, NULL, 1, 'station_1', 'Station 1', NULL, 60, 1, 0, '2026-03-09 23:49:26', '2026-03-09 23:49:26', NULL),
(19, 3, NULL, 2, 'station_2', 'Station 2', NULL, 60, 0, 1, '2026-03-09 23:49:41', '2026-03-09 23:49:41', NULL),
(20, 4, NULL, 1, 'station_1', 'Station 1', NULL, 60, 1, 0, '2026-03-09 23:56:26', '2026-03-09 23:56:26', NULL),
(21, 4, NULL, 2, 'station_2', 'Station 2', NULL, 60, 0, 1, '2026-03-09 23:56:26', '2026-03-09 23:56:26', NULL),
(22, 5, NULL, 1, 'ridz', 'Communication Station 1', NULL, 60, 1, 0, '2026-03-10 00:30:24', '2026-09-13 22:43:17', NULL),
(23, 5, NULL, 2, 'station_2', 'Station 2', NULL, 60, 0, 1, '2026-03-10 00:30:24', '2026-03-10 00:30:24', NULL),
(24, 6, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', 2880, 1, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(25, 6, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(26, 6, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(27, 6, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(28, 6, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(29, 6, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(30, 6, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(31, 6, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(32, 6, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(33, 6, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(34, 6, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(35, 6, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(36, 6, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', 2880, 0, 0, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(37, 6, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', 2880, 0, 1, '2026-09-11 19:51:53', '2026-09-11 19:51:53', NULL),
(38, 7, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', 2880, 1, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(39, 7, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(40, 7, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(41, 7, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(42, 7, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(43, 7, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(44, 7, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(45, 7, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(46, 7, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(47, 7, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(48, 7, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(49, 7, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(50, 7, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', 2880, 0, 0, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(51, 7, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', 2880, 0, 1, '2026-09-11 20:07:42', '2026-09-11 20:07:42', NULL),
(70, 16, NULL, 1, 'communication_1', 'Communication Station 1', NULL, 60, 1, 0, '2026-09-13 22:43:22', '2026-09-13 22:49:48', NULL),
(71, 16, NULL, 2, 'communication_2', 'Communication Station End', NULL, 60, 0, 1, '2026-09-13 22:43:22', '2026-09-13 22:49:48', NULL),
(72, 17, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', 2880, 1, 0, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(73, 17, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 2880, 0, 0, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(74, 17, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', 4320, 0, 1, '2026-09-14 00:53:40', '2026-09-14 00:53:40', NULL),
(75, 18, NULL, 1, 'communication_1', 'Communication Station 1', NULL, 60, 1, 0, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL),
(76, 18, NULL, 2, 'communication_2', 'Communication Station End', NULL, 60, 0, 1, '2026-09-21 23:27:10', '2026-09-21 23:27:10', NULL);

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
-- Indexes for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_step_runs_from_step_id_foreign` (`from_step_id`),
  ADD KEY `transaction_step_runs_to_step_id_foreign` (`to_step_id`),
  ADD KEY `transaction_step_runs_performed_by_foreign` (`performed_by`),
  ADD KEY `transaction_step_runs_transaction_id_performed_at_index` (`transaction_id`,`performed_at`);

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
  ADD KEY `wf_steps_def_parent_order_idx` (`workflow_definition_id`,`parent_id`,`order_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `field_definitions`
--
ALTER TABLE `field_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `field_definition_workflow_step`
--
ALTER TABLE `field_definition_workflow_step`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `field_values`
--
ALTER TABLE `field_values`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `offices`
--
ALTER TABLE `offices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `office_steps`
--
ALTER TABLE `office_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `requirement_definitions`
--
ALTER TABLE `requirement_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `step_requirements`
--
ALTER TABLE `step_requirements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `step_roles`
--
ALTER TABLE `step_roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `transaction_attachments`
--
ALTER TABLE `transaction_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `transaction_states`
--
ALTER TABLE `transaction_states`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `transaction_station_touches`
--
ALTER TABLE `transaction_station_touches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `transaction_types`
--
ALTER TABLE `transaction_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `workflow_definitions`
--
ALTER TABLE `workflow_definitions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `workflow_routes`
--
ALTER TABLE `workflow_routes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_actor_user_id_foreign` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`);

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
-- Constraints for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  ADD CONSTRAINT `transaction_step_runs_from_step_id_foreign` FOREIGN KEY (`from_step_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `transaction_step_runs_performed_by_foreign` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
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
  ADD CONSTRAINT `workflow_steps_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `workflow_steps` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workflow_steps_workflow_definition_id_foreign` FOREIGN KEY (`workflow_definition_id`) REFERENCES `workflow_definitions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
