-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260914.9e4dc5b5f4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 24, 2026 at 07:56 PM
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `actor_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_roles` json DEFAULT NULL,
  `actor_office_id` bigint UNSIGNED DEFAULT NULL,
  `actor_office_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_is_superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `module` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `transaction_id` bigint UNSIGNED DEFAULT NULL,
  `step_run_id` bigint UNSIGNED DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `changed_fields` json DEFAULT NULL,
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`, `actor_name`, `actor_email`, `actor_roles`, `actor_office_id`, `actor_office_code`, `actor_is_superadmin`, `module`, `action`, `description`, `entity_label`, `office_id`, `transaction_id`, `step_run_id`, `old_values`, `new_values`, `changed_fields`, `request_method`, `request_path`, `request_id`) VALUES
(74, 1, 'workflow_definitions.delete_draft', 'workflow_definition', 6, '{\"deleted\":{\"transaction_type_id\":2,\"version\":2,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 12:16:32', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'delete_draft', 'Deleted draft', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(75, 1, 'workflow_definitions.delete_draft', 'workflow_definition', 18, '{\"deleted\":{\"transaction_type_id\":3,\"version\":5,\"status\":\"draft\",\"name\":null}}', '127.0.0.1', 'draft-cleanup-script', '2026-09-30 12:16:32', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'delete_draft', 'Deleted draft', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(76, 1, 'workflow_definitions.save_as', 'workflow_definition', 62, '{\"source_id\":62,\"source_version\":5,\"to_version\":5,\"name\":\"Bryan\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:32:13', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'save_as', 'Saved as new version Bryan', 'Bryan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(77, 1, 'workflow_definitions.save_as', 'workflow_definition', 64, '{\"source_id\":63,\"source_version\":6,\"to_version\":7,\"name\":\"bry\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:33:37', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'save_as', 'Saved as new version bry', 'bry', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(78, 1, 'workflow_definitions.make_live', 'workflow_definition', 16, '{\"from_version\":7,\"from_id\":64,\"to_version\":4,\"to_id\":16}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:33:50', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live v4', 'v4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(79, 1, 'workflow_definitions.make_live', 'workflow_definition', 62, '{\"from_version\":4,\"from_id\":16,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-30 12:34:10', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live Bryan', 'Bryan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(80, 1, 'workflow_definitions.make_live', 'workflow_definition', 64, '{\"from_version\":5,\"from_id\":62,\"to_version\":7,\"to_id\":64}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 09:02:13', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live bry', 'bry', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(81, 1, 'workflow_definitions.make_live', 'workflow_definition', 62, '{\"from_version\":7,\"from_id\":64,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 09:02:19', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live Bryan', 'Bryan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(82, 1, 'workflow_definitions.make_live', 'workflow_definition', 63, '{\"from_version\":5,\"from_id\":62,\"to_version\":6,\"to_id\":63}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:05:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live v6', 'v6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(83, 1, 'workflow_definitions.make_live', 'workflow_definition', 62, '{\"from_version\":6,\"from_id\":63,\"to_version\":5,\"to_id\":62}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:05:57', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live Bryan', 'Bryan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(84, 1, 'transaction_types.update', 'transaction_type', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-10-01 11:28:19', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Communication', 'Communication', NULL, NULL, NULL, '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": true, \"office_ids\": [23], \"description\": null}', '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '[\"is_active\"]', NULL, NULL, NULL),
(85, 1, 'users.update', 'user', 10, '{\"before\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[6]},\"after\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-15 17:04:10', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Hendrich', 'Hendrich', 24, NULL, NULL, '{\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [6], \"is_active\": true, \"office_id\": null}', '{\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": null}', '[\"role_ids\"]', NULL, NULL, NULL),
(86, 1, 'users.update', 'user', 10, '{\"before\":{\"name\":\"Hendrich\",\"email\":\"user@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"user@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-16 10:14:17', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Sharief Kundo Mudrikal', 'Sharief Kundo Mudrikal', 24, NULL, NULL, '{\"name\": \"Hendrich\", \"email\": \"user@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": null}', '{\"name\": \"Sharief Kundo Mudrikal\", \"email\": \"user@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": 24}', '[\"name\", \"office_id\"]', NULL, NULL, NULL),
(92, 1, 'roles.delete', 'role', 3, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:47:58', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Clerk Releasing', 'Clerk Releasing', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(93, 1, 'roles.delete', 'role', 4, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:01', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Approver', 'Approver', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(94, 1, 'roles.delete', 'role', 7, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:05', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted GSO', 'GSO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(95, 1, 'roles.delete', 'role', 8, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:09', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted City Administrator', 'City Administrator', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(96, 1, 'roles.delete', 'role', 9, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:37', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted CTO', 'CTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(97, 1, 'roles.delete', 'role', 10, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:41', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted City Treasurer', 'City Treasurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(98, 1, 'roles.delete', 'role', 11, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:43', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted CAdmin', 'CAdmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(99, 1, 'roles.delete', 'role', 12, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:44', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted CBO', 'CBO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(100, 1, 'roles.delete', 'role', 13, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:47', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted BAC-PAAD', 'BAC-PAAD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(101, 1, 'roles.delete', 'role', 14, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:49', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Clerk Receiving', 'Clerk Receiving', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 1, 'roles.delete', 'role', 15, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:50', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Clerk Procurement', 'Clerk Procurement', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(103, 1, 'roles.delete', 'role', 16, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 14:48:52', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Staff Technical', 'Staff Technical', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(104, 1, 'roles.create', 'role', 17, '{\"payload\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:03:27', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'create', 'Created Clerk', 'Clerk', NULL, NULL, NULL, NULL, '{\"code\": \"clerk\", \"name\": \"Clerk\", \"description\": \"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"}', '[\"code\", \"name\", \"description\"]', NULL, NULL, NULL),
(106, 1, 'roles.delete', 'role', 14, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:15:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Clerk Receiving', 'Clerk Receiving', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(107, 1, 'roles.delete', 'role', 4, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:18:43', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Approver', 'Approver', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(108, 1, 'roles.update', 'role', 17, '{\"before\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"},\"after\":{\"code\":\"clerk\",\"name\":\"Clerk\",\"description\":\"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document\\/s)\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:20:55', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'update', 'Updated Clerk', 'Clerk', NULL, NULL, NULL, '{\"code\": \"clerk\", \"name\": \"Clerk\", \"description\": \"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations\"}', '{\"code\": \"clerk\", \"name\": \"Clerk\", \"description\": \"A clerk performs administrative, record-keeping, and general support tasks to keep daily operations running smoothly in offices, stores, and organizations. (Approving and Receiving Document/s)\"}', '[\"description\"]', NULL, NULL, NULL),
(109, 1, 'users.update', 'user', 10, '{\"before\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"user@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Sharief Kundo Mudrikal', 'Sharief Kundo Mudrikal', 24, NULL, NULL, '{\"name\": \"Sharief Kundo Mudrikal\", \"email\": \"user@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": 24}', '{\"name\": \"Sharief Kundo Mudrikal\", \"email\": \"admin@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": 24}', '[\"email\"]', NULL, NULL, NULL),
(110, 1, 'users.update', 'user', 10, '{\"before\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":24,\"is_active\":true,\"role_ids\":[2]},\"after\":{\"name\":\"Sharief Kundo Mudrikal\",\"email\":\"admin@gmail.com\",\"office_id\":null,\"is_active\":true,\"role_ids\":[2]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Sharief Kundo Mudrikal', 'Sharief Kundo Mudrikal', 24, NULL, NULL, '{\"name\": \"Sharief Kundo Mudrikal\", \"email\": \"admin@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": 24}', '{\"name\": \"Sharief Kundo Mudrikal\", \"email\": \"admin@gmail.com\", \"role_ids\": [2], \"is_active\": true, \"office_id\": null}', '[\"office_id\"]', NULL, NULL, NULL),
(111, 1, 'users.deactivate', 'user', 32, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:41', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(112, 1, 'users.deactivate', 'user', 31, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:42', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(113, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:56', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(114, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:47:59', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(115, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:02', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(116, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:04', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(117, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(118, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(119, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:09', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(120, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:11', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(121, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:12', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(122, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(123, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:15', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(124, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:17', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(125, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:18', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(126, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:20', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(127, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:21', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(128, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:24', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(129, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:25', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(130, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:27', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(131, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:28', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(132, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(133, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:31', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(134, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:33', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(135, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:34', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(136, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:36', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(137, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:37', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(138, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(139, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:40', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(140, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:42', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(141, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:43', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(142, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:45', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(143, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:47', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(144, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:49', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(145, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:50', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(146, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:52', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(147, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:54', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:56', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:57', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(150, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:48:59', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(151, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:01', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(152, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:03', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(153, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:04', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(154, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(155, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(156, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:09', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(157, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:11', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(158, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:12', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:15', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(160, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:18', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(161, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:20', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(162, 1, 'users.deactivate', 'user', 23, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-19 15:49:23', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(163, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 67, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":3,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":2,\"routes_deleted\":1,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-20 09:54:11', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Payroll', 'Payroll', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(164, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 68, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:28:34', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(165, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 69, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:29:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(166, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 70, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:33:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(167, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 71, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:36:16', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(168, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 72, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0', '2026-10-20 13:40:11', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(169, 1, 'transaction_types.delete', 'transaction_type', 2, '{\"note\":\"Soft deleted transaction type\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:20:38', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'delete', 'Deleted Procurement', 'Procurement', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(170, 1, 'transaction_types.update', 'transaction_type', 11, '{\"before\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[24]},\"after\":{\"code\":\"procurement_it_equipment\",\"name\":\"Procurement : IT Equipment\",\"description\":\"This is a procurement for the it department\",\"is_active\":true,\"office_ids\":[]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 13:20:53', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, '{\"code\": \"procurement_it_equipment\", \"name\": \"Procurement : IT Equipment\", \"is_active\": true, \"office_ids\": [24], \"description\": \"This is a procurement for the it department\"}', '{\"code\": \"procurement_it_equipment\", \"name\": \"Procurement : IT Equipment\", \"is_active\": true, \"office_ids\": [], \"description\": \"This is a procurement for the it department\"}', '[\"office_ids\"]', NULL, NULL, NULL),
(174, NULL, 'users.register', 'user', 60, '{\"payload\":{\"name\":\"Bryan Martin Wee\",\"email\":\"charls.inoferio@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 14:30:22', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered Bryan Martin Wee', 'Bryan Martin Wee', NULL, NULL, NULL, NULL, '{\"name\": \"Bryan Martin Wee\", \"email\": \"charls.inoferio@gmail.com\", \"role_ids\": [17], \"office_id\": 24}', '[\"name\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL),
(175, NULL, 'users.register', 'user', 61, '{\"payload\":{\"name\":\"Claude Test Signup 1\",\"email\":\"claude.test.signup1@example.com\",\"office_id\":8,\"role_ids\":[17]}}', '127.0.0.1', 'curl/8.21.0', '2026-10-21 14:39:42', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered Claude Test Signup 1', 'Claude Test Signup 1', NULL, NULL, NULL, NULL, '{\"name\": \"Claude Test Signup 1\", \"email\": \"claude.test.signup1@example.com\", \"role_ids\": [17], \"office_id\": 8}', '[\"name\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL);
INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`, `actor_name`, `actor_email`, `actor_roles`, `actor_office_id`, `actor_office_code`, `actor_is_superadmin`, `module`, `action`, `description`, `entity_label`, `office_id`, `transaction_id`, `step_run_id`, `old_values`, `new_values`, `changed_fields`, `request_method`, `request_path`, `request_id`) VALUES
(176, NULL, 'users.register', 'user', 62, '{\"payload\":{\"name\":\"Claude Test Signup 2\",\"email\":\"claude.test.signup2@example.com\",\"office_id\":8,\"role_ids\":[17]}}', '127.0.0.1', 'curl/8.21.0', '2026-10-21 14:39:44', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered Claude Test Signup 2', 'Claude Test Signup 2', NULL, NULL, NULL, NULL, '{\"name\": \"Claude Test Signup 2\", \"email\": \"claude.test.signup2@example.com\", \"role_ids\": [17], \"office_id\": 8}', '[\"name\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL),
(177, 1, 'users.approve', 'user', 61, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-21 14:40:07', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'approve', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(178, 1, 'users.reject', 'user', 62, '{\"payload\":{\"email\":\"claude.test.signup2@example.com\",\"name\":\"Claude Test Signup 2\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-21 14:40:10', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'reject', 'Rejected Claude Test Signup 2', 'Claude Test Signup 2', NULL, NULL, NULL, '{\"name\": \"Claude Test Signup 2\", \"email\": \"claude.test.signup2@example.com\"}', NULL, '[\"email\", \"name\"]', NULL, NULL, NULL),
(179, 1, 'users.reject', 'user', 60, '{\"payload\":{\"email\":\"charls.inoferio@gmail.com\",\"name\":\"Bryan Martin Wee\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', '2026-10-21 15:25:21', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'reject', 'Rejected Bryan Martin Wee', 'Bryan Martin Wee', NULL, NULL, NULL, '{\"name\": \"Bryan Martin Wee\", \"email\": \"charls.inoferio@gmail.com\"}', NULL, '[\"email\", \"name\"]', NULL, NULL, NULL),
(180, 59, 'profile.update', 'user', 59, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-22 14:45:33', 'John Rey Wee', 'johnrey.wee.csd@gmail.com', '[{\"id\": 17, \"code\": \"clerk\", \"name\": \"Clerk\"}]', 24, 'CSD', 0, 'profile', 'update', 'Updated John Rey Wee', 'John Rey Wee', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(181, 59, 'profile.update', 'user', 59, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/155.0.0.0 Safari/537.36', '2026-10-22 14:45:36', 'John Rey Wee', 'johnrey.wee.csd@gmail.com', '[{\"id\": 17, \"code\": \"clerk\", \"name\": \"Clerk\"}]', 24, 'CSD', 0, 'profile', 'update', 'Updated John Rey Wee', 'John Rey Wee', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(182, 2, 'profile.password', 'user', 2, '[]', '127.0.0.1', 'curl/8.21.0', '2026-10-22 14:46:33', 'End User', 'enduser@lgu.test', '[{\"id\": 6, \"code\": \"end_user\", \"name\": \"End User\"}]', NULL, NULL, 0, 'profile', 'password', 'Password changed End User', 'End User', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(183, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 73, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":1}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-25 12:18:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v17', 'v17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(184, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 74, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":8,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":7,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":0,\"requirements_deleted\":0,\"steps_bound\":0,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-26 08:53:01', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes Procurement : IT Equipment', 'Procurement : IT Equipment', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(185, 1, 'offices.update', 'office', 24, '{\"before\":{\"code\":\"CSD\",\"name\":\"Computer Service Division\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CSD\",\"name\":\"Computer Service Division\",\"description\":null,\"icon_path\":\"offices\\/icons\\/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\",\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-26 09:29:02', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated Computer Service Division', 'Computer Service Division', 24, NULL, NULL, '{\"code\": \"CSD\", \"name\": \"Computer Service Division\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CSD\", \"name\": \"Computer Service Division\", \"icon_path\": \"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\", \"is_active\": true, \"description\": null}', '[\"icon_path\"]', NULL, NULL, NULL),
(186, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 75, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":3,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":2,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:08:11', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v4', 'v4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(187, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 76, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:08:26', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v5', 'v5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(188, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 77, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:09:57', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v6', 'v6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(189, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 78, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:04', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v7', 'v7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(190, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 79, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:15', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v8', 'v8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(191, 1, 'workflow_definitions.apply_staged', 'workflow_definition', 80, '{\"mode\":\"overwrite\",\"published\":true,\"applied\":{\"steps_created\":0,\"steps_updated\":0,\"steps_deleted\":0,\"routes_created\":0,\"routes_updated\":0,\"routes_deleted\":0,\"requirements_created\":0,\"requirements_updated\":7,\"requirements_deleted\":0,\"steps_bound\":1,\"steps_checklisted\":0,\"steps_resynced\":0,\"steps_fields_synced\":0,\"step_data_saved\":0}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-10-27 09:10:26', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'apply_staged', 'Applied staged changes v9', 'v9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(192, 1, 'users.deactivate', 'user', 40, '{\"note\":\"User marked inactive (no hard delete in Step 2)\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:52:22', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'deactivate', 'Deactivated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(193, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarros\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:56:42', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarros', 'Angelica Mae Navarros', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '{\"name\": \"Angelica Mae Navarros\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '[\"name\"]', NULL, NULL, NULL),
(194, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarros\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:27', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarros\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '[\"name\"]', NULL, NULL, NULL),
(195, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[2,17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:37', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [2, 17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '[\"role_ids\"]', NULL, NULL, NULL),
(196, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[2,17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:41', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [2, 17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '[\"role_ids\"]', NULL, NULL, NULL),
(197, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":5,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":9,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:48', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 5}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 9}', '[\"office_id\"]', NULL, NULL, NULL),
(198, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":9,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":24,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 18:59:55', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 9}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 24}', '[\"office_id\"]', NULL, NULL, NULL),
(199, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":24,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":false,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 19:00:04', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 24}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 21}', '[\"office_id\"]', NULL, NULL, NULL),
(200, 1, 'users.update', 'user', 40, '{\"before\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":false,\"role_ids\":[17]},\"after\":{\"name\":\"Angelica Mae Navarro\",\"username\":null,\"email\":\"angelicamae.navarro@gmail.com\",\"office_id\":21,\"is_active\":true,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 19:00:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Angelica Mae Navarro', 'Angelica Mae Navarro', 21, NULL, NULL, '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": false, \"office_id\": 21}', '{\"name\": \"Angelica Mae Navarro\", \"email\": \"angelicamae.navarro@gmail.com\", \"role_ids\": [17], \"username\": null, \"is_active\": true, \"office_id\": 21}', '[\"is_active\"]', NULL, NULL, NULL),
(201, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMOS\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:53:23', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMOS\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"code\"]', NULL, NULL, NULL),
(202, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMOS\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:53:32', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMOS\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"code\"]', NULL, NULL, NULL),
(203, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Offices\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Offices', 'City Human Resource Management Offices', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Offices\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"name\"]', NULL, NULL, NULL),
(204, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Offices\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Offices\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"name\"]', NULL, NULL, NULL),
(205, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":\"wadawd\",\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:22', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": \"wadawd\"}', '[\"description\"]', NULL, NULL, NULL),
(206, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":\"wadawd\",\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:27', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": \"wadawd\"}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"description\"]', NULL, NULL, NULL),
(207, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:29', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": false, \"description\": null}', '[\"is_active\"]', NULL, NULL, NULL),
(208, 1, 'offices.update', 'office', 21, '{\"before\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":false},\"after\":{\"code\":\"CHRMO\",\"name\":\"City Human Resource Management Office\",\"description\":null,\"icon_path\":null,\"is_active\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:54:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'offices', 'update', 'Updated City Human Resource Management Office', 'City Human Resource Management Office', 21, NULL, NULL, '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": false, \"description\": null}', '{\"code\": \"CHRMO\", \"name\": \"City Human Resource Management Office\", \"icon_path\": null, \"is_active\": true, \"description\": null}', '[\"is_active\"]', NULL, NULL, NULL),
(209, 1, 'workflow_definitions.make_live', 'workflow_definition', 63, '{\"from_version\":5,\"from_id\":62,\"to_version\":6,\"to_id\":63}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:58:33', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live v6', 'v6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(210, 1, 'transaction_types.update', 'transaction_type', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:58:57', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Communication', 'Communication', NULL, NULL, NULL, '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": true, \"office_ids\": [23], \"description\": null}', '[\"is_active\"]', NULL, NULL, NULL),
(211, 1, 'transaction_types.update', 'transaction_type', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":true,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:59:04', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Communication', 'Communication', NULL, NULL, NULL, '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": true, \"office_ids\": [23], \"description\": null}', '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '[\"is_active\"]', NULL, NULL, NULL),
(212, 1, 'workflow_definitions.make_live', 'workflow_definition', 64, '{\"from_version\":6,\"from_id\":63,\"to_version\":7,\"to_id\":64}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 22:59:20', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'workflow_definitions', 'make_live', 'Made live bry', 'bry', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(213, 1, 'transaction_types.update', 'transaction_type', 3, '{\"before\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communications\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 23:15:45', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Communication', 'Communication', NULL, NULL, NULL, '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '{\"code\": \"communications\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '[\"code\"]', NULL, NULL, NULL),
(214, 1, 'transaction_types.update', 'transaction_type', 3, '{\"before\":{\"code\":\"communications\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]},\"after\":{\"code\":\"communication\",\"name\":\"Communication\",\"description\":null,\"is_active\":false,\"office_ids\":[23]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-03 23:15:49', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transaction_types', 'update', 'Updated Communication', 'Communication', NULL, NULL, NULL, '{\"code\": \"communications\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '{\"code\": \"communication\", \"name\": \"Communication\", \"is_active\": false, \"office_ids\": [23], \"description\": null}', '[\"code\"]', NULL, NULL, NULL),
(215, 1, 'transactions.archive', 'transaction', 66, '{\"was_done\":false,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 22:48:59', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'archive', 'Archived Y36S-XQWD-0QVH', 'Y36S-XQWD-0QVH', 24, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(216, 1, 'transactions.unarchive', 'transaction', 66, '{\"note\":\"Restored to the active transaction lists; record and history unchanged.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:09:28', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'unarchive', 'Restored Y36S-XQWD-0QVH', 'Y36S-XQWD-0QVH', 24, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(217, 1, 'transactions.archive', 'transaction', 66, '{\"was_done\":false,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:10:10', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'archive', 'Archived Y36S-XQWD-0QVH', 'Y36S-XQWD-0QVH', 24, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(218, 1, 'transactions.finalize', 'transaction', 65, '{\"reference_number\":\"JZJO-GQWY-CMD5\",\"current_step_id\":500}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:22:33', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'finalize', 'Finalized JZJO-GQWY-CMD5', 'JZJO-GQWY-CMD5', 24, 65, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(219, 1, 'transactions.finalize', 'transaction', 53, '{\"reference_number\":\"WJVR-4V6U-2ZRT\",\"current_step_id\":74}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:23:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'finalize', 'Finalized WJVR-4V6U-2ZRT', 'WJVR-4V6U-2ZRT', 24, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(220, 1, 'transactions.archive', 'transaction', 65, '{\"was_done\":true,\"note\":\"Archived instead of deleted; record and history kept.\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:23:23', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'archive', 'Archived JZJO-GQWY-CMD5', 'JZJO-GQWY-CMD5', 24, 65, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(221, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:41:00', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', NULL, NULL, NULL),
(222, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:41:02', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', NULL, NULL, NULL),
(223, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', NULL, NULL, NULL),
(224, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:53', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', NULL, NULL, NULL),
(225, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:44:57', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', NULL, NULL, NULL),
(226, 1, 'transactions.privacy', 'transaction', 64, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:45:01', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9IRD-DMGH-XSJG', '9IRD-DMGH-XSJG', 24, 64, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', NULL, NULL, NULL),
(227, 1, 'transactions.privacy', 'transaction', 67, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:47:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', NULL, NULL, NULL),
(228, 1, 'transactions.privacy', 'transaction', 67, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:52:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', NULL, NULL, NULL),
(229, NULL, 'users.register', 'user', 63, '{\"payload\":{\"name\":\"juan\",\"username\":\"wadwad\",\"email\":\"AWDJAWJKDN@GMAIL.OCCM\",\"office_id\":9,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-04 23:56:24', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered juan', 'juan', 9, NULL, NULL, NULL, '{\"name\": \"juan\", \"email\": \"AWDJAWJKDN@GMAIL.OCCM\", \"role_ids\": [17], \"username\": \"wadwad\", \"office_id\": 9}', '[\"name\", \"username\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL),
(230, NULL, 'users.register', 'user', 64, '{\"payload\":{\"name\":\"Juan dila\",\"username\":\"dela\",\"email\":\"juandela@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:33:43', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered Juan dila', 'Juan dila', 24, NULL, NULL, NULL, '{\"name\": \"Juan dila\", \"email\": \"juandela@gmail.com\", \"role_ids\": [17], \"username\": \"dela\", \"office_id\": 24}', '[\"name\", \"username\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL),
(231, 1, 'users.approve', 'user', 64, '[]', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:46:24', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'approve', 'Approved Juan dila', 'Juan dila', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(232, NULL, 'users.register', 'user', 65, '{\"payload\":{\"name\":\"newcsd\",\"username\":\"newcsd\",\"email\":\"newcsd@gmail.com\",\"office_id\":24,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 16:51:41', NULL, NULL, NULL, NULL, NULL, 0, 'users', 'register', 'Registered newcsd', 'newcsd', NULL, NULL, NULL, NULL, '{\"name\": \"newcsd\", \"email\": \"newcsd@gmail.com\", \"role_ids\": [17], \"username\": \"newcsd\", \"office_id\": 24}', '[\"name\", \"username\", \"email\", \"office_id\", \"role_ids\"]', NULL, NULL, NULL),
(233, 1, 'users.reject', 'user', 65, '{\"payload\":{\"email\":\"newcsd@gmail.com\",\"name\":\"newcsd\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 17:01:00', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'reject', 'Rejected newcsd', 'newcsd', NULL, NULL, NULL, '{\"name\": \"newcsd\", \"email\": \"newcsd@gmail.com\"}', NULL, '[\"email\", \"name\"]', NULL, NULL, NULL),
(234, 1, 'transactions.privacy', 'transaction', 67, '{\"before\":{\"is_private\":false},\"after\":{\"is_private\":true}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 18:51:18', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', NULL, NULL, NULL),
(235, 1, 'transactions.privacy', 'transaction', 67, '{\"before\":{\"is_private\":true},\"after\":{\"is_private\":false}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '2026-11-05 18:51:19', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', NULL, NULL, NULL),
(236, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-08 19:15:26', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '91e51791-bcc3-4d05-bcb1-558d6ffc90cb'),
(237, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-08 19:15:48', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '209b06be-8b00-4225-81e9-c8b7bb0f00be'),
(238, 1, 'users.reject', 'user', 63, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-08 22:57:07', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'reject', 'Rejected juan', 'juan', 9, NULL, NULL, '{\"name\": \"juan\", \"email\": \"AWDJAWJKDN@GMAIL.OCCM\"}', NULL, '[\"email\", \"name\"]', 'DELETE', '/api/admin/users/63/reject', 'a9291963-5314-4401-ac7e-95156bdcb5de'),
(239, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-09 19:41:22', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '8d478c1e-1dcf-42bc-abc5-9a0d8c40ee82'),
(240, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-09 20:03:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '3553072f-d974-47a0-b2b0-d6c99daa93df'),
(241, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-09 20:11:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '392160eb-3943-4ec0-9e52-ef173f315084');
INSERT INTO `audit_logs` (`id`, `actor_user_id`, `event`, `entity_type`, `entity_id`, `meta`, `ip`, `user_agent`, `created_at`, `actor_name`, `actor_email`, `actor_roles`, `actor_office_id`, `actor_office_code`, `actor_is_superadmin`, `module`, `action`, `description`, `entity_label`, `office_id`, `transaction_id`, `step_run_id`, `old_values`, `new_values`, `changed_fields`, `request_method`, `request_path`, `request_id`) VALUES
(242, 1, 'transactions.requirement_check', 'transaction_requirement_check', 198, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 17:45:41', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked PR', 'PR', 16, 67, NULL, NULL, '{\"requirement\": \"PR\", \"workflow_step_id\": 475, \"requirement_definition_id\": 198}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/198/check', '03ef00a2-6199-4316-bc5a-f877c734ba79'),
(243, 1, 'transactions.requirement_check', 'transaction_requirement_check', 199, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 17:45:42', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked Market Scanning', 'Market Scanning', 16, 67, NULL, NULL, '{\"requirement\": \"Market Scanning\", \"workflow_step_id\": 475, \"requirement_definition_id\": 195}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/195/check', 'a91f7b7d-f4e1-409a-b7cd-e7a2c6d57ce1'),
(244, 1, 'transactions.attachment_upload', 'transaction_attachment', 209, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 17:45:47', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 16, 67, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 385033, \"original_name\": \"ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf\", \"workflow_step_id\": 475, \"requirement_definition_id\": 198}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/67/attachments', '5cca5787-85fd-4f05-bff5-6c4f2d1da650'),
(245, 1, 'transactions.attachment_upload', 'transaction_attachment', 210, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 17:45:52', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 16, 67, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 8594822, \"original_name\": \"ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf\", \"workflow_step_id\": 475, \"requirement_definition_id\": 195}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/67/attachments', '3f741608-7ce0-4f27-a782-607808c43c7f'),
(246, 1, 'transactions.checklist_check', 'transaction_checklist_check', 77, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 23:15:51', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked PR with Number', 'PR with Number', 24, 40, NULL, NULL, '{\"item\": \"PR with Number\", \"workflow_step_id\": 394, \"checklist_override_id\": 47}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/40/checklist/47/check', 'e6916ed2-fb2f-4470-a0cf-93f96c70f7cc'),
(247, 1, 'transactions.requirement_check', 'transaction_requirement_check', 200, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 23:15:59', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked PR with number', 'PR with number', 24, 40, NULL, NULL, '{\"requirement\": \"PR with number\", \"workflow_step_id\": 394, \"requirement_definition_id\": 76}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/40/requirements/76/check', 'a4c8ad0e-81ba-4c0a-b1c3-e982eb4e7dcd'),
(248, 1, 'transactions.attachment_reuse', 'transaction_attachment', 211, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-10 23:16:07', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_reuse', 'Attachment linked AR.pdf', 'AR.pdf', 24, 40, NULL, NULL, '{\"label\": null, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 394, \"source_attachment_id\": 67, \"requirement_definition_id\": 76}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"source_attachment_id\"]', 'POST', '/api/admin/transactions/40/attachments/reuse', '817ae176-ba2e-42df-b6f2-c9ff526162b1'),
(249, 1, 'users.update', 'user', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-12 00:18:02', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Vince', 'Vince', NULL, NULL, NULL, '{\"position\": null}', '{\"position\": \"SuperVisor\"}', '[\"position\"]', 'PUT', '/api/admin/users/1', '4be29a79-5419-4513-9dd2-ecbe38987e8f'),
(250, 1, 'users.update', 'user', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-12 00:18:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'update', 'Updated Vince', 'Vince', NULL, NULL, NULL, '{\"position\": \"SuperVisor\"}', '{\"position\": \"Super Visor\"}', '[\"position\"]', 'PUT', '/api/admin/users/1', 'd8329f6e-0706-47ec-8ce2-9f3eb2a5c97f'),
(251, 1, 'transactions.checklist_check', 'transaction_checklist_check', 78, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 09:23:02', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked PR', 'PR', 16, 67, NULL, NULL, '{\"item\": \"PR\", \"workflow_step_id\": 476, \"checklist_override_id\": 126}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/checklist/126/check', '176cf628-25e2-49e7-824b-f568dd069463'),
(252, 1, 'transactions.checklist_check', 'transaction_checklist_check', 79, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 09:23:05', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked Market Scanning', 'Market Scanning', 16, 67, NULL, NULL, '{\"item\": \"Market Scanning\", \"workflow_step_id\": 476, \"checklist_override_id\": 127}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/checklist/127/check', '8aa4eb92-75b4-4879-9d85-622c406e2bd3'),
(253, 1, 'transactions.requirement_check', 'transaction_requirement_check', 201, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 09:23:12', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked PR with Number', 'PR with Number', 16, 67, NULL, NULL, '{\"requirement\": \"PR with Number\", \"workflow_step_id\": 476, \"requirement_definition_id\": 199}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/199/check', '992eabd2-6c84-4583-a96e-c50628539ab4'),
(254, 1, 'transactions.attachment_reuse', 'transaction_attachment', 212, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 09:23:15', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_reuse', 'Attachment linked ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', 16, 67, NULL, NULL, '{\"label\": null, \"original_name\": \"ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf\", \"workflow_step_id\": 476, \"source_attachment_id\": 210, \"requirement_definition_id\": 199}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"source_attachment_id\"]', 'POST', '/api/admin/transactions/67/attachments/reuse', '3a2629c1-1ffc-47cb-86e5-4c451621271c'),
(255, 1, 'transactions.checklist_check', 'transaction_checklist_check', 80, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 17:02:38', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked PR with Number', 'PR with Number', 16, 67, NULL, NULL, '{\"item\": \"PR with Number\", \"workflow_step_id\": 477, \"checklist_override_id\": 128}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/checklist/128/check', 'a27cc620-afb2-4cdf-b0c6-46a8bf5c31d5'),
(256, 1, 'transactions.requirement_check', 'transaction_requirement_check', 202, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 17:02:41', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked PR with number', 'PR with number', 16, 67, NULL, NULL, '{\"requirement\": \"PR with number\", \"workflow_step_id\": 477, \"requirement_definition_id\": 200}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/200/check', 'e4a03cff-73a7-48f6-8519-6c5ad795a3d3'),
(257, 1, 'transactions.attachment_upload', 'transaction_attachment', 213, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 17:02:49', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 16, 67, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 385033, \"original_name\": \"ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf\", \"workflow_step_id\": 477, \"requirement_definition_id\": 200}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/67/attachments', '28c1b1a2-06c7-4d79-9ee6-9b733147f1db'),
(258, 1, 'transactions.checklist_check', 'transaction_checklist_check', 81, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 21:55:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked PR with number', 'PR with number', 16, 67, NULL, NULL, '{\"item\": \"PR with number\", \"workflow_step_id\": 478, \"checklist_override_id\": 129}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/checklist/129/check', 'e8320758-0961-49f4-98ec-238900a3b61c'),
(259, 1, 'transactions.requirement_check', 'transaction_requirement_check', 203, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 21:55:09', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked CTO approve PR', 'CTO approve PR', 16, 67, NULL, NULL, '{\"requirement\": \"CTO approve PR\", \"workflow_step_id\": 478, \"requirement_definition_id\": 192}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/192/check', 'b1c8aa6b-286b-4224-ae15-7601d6f05665'),
(260, 1, 'transactions.attachment_reuse', 'transaction_attachment', 214, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-15 21:55:14', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_reuse', 'Attachment linked ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', 16, 67, NULL, NULL, '{\"label\": null, \"original_name\": \"ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf\", \"workflow_step_id\": 478, \"source_attachment_id\": 213, \"requirement_definition_id\": 192}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"source_attachment_id\"]', 'POST', '/api/admin/transactions/67/attachments/reuse', 'eee883bb-84f4-4ef4-8098-c2f0e074b4e8'),
(261, 1, 'transactions.requirement_check', 'transaction_requirement_check', 204, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:57:23', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked DTR collected', 'DTR collected', 24, 64, NULL, NULL, '{\"requirement\": \"DTR collected\", \"workflow_step_id\": 424, \"requirement_definition_id\": 112}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/requirements/112/check', '76677079-d7e1-492e-a361-8d4ad6d04a7d'),
(262, 1, 'transactions.requirement_check', 'transaction_requirement_check', 205, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:57:24', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked Payroll', 'Payroll', 24, 64, NULL, NULL, '{\"requirement\": \"Payroll\", \"workflow_step_id\": 424, \"requirement_definition_id\": 115}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/requirements/115/check', '2920238f-3cfc-4940-836b-29fe53f2ab4c'),
(263, 1, 'transactions.attachment_upload', 'transaction_attachment', 215, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:57:43', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf', 'AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf', 24, 64, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 359202, \"original_name\": \"AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf\", \"workflow_step_id\": 424, \"requirement_definition_id\": 115}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/64/attachments', '4b9b56a5-8b1f-45fa-a439-907369f02bf6'),
(264, 1, 'transactions.attachment_upload', 'transaction_attachment', 216, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:57:46', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded AR.pdf', 'AR.pdf', 24, 64, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 679398, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 424, \"requirement_definition_id\": 110}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/64/attachments', '3113a3db-e697-41be-a83b-8001320ed5b7'),
(265, 1, 'transactions.attachment_upload', 'transaction_attachment', 217, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:57:58', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded AR.pdf', 'AR.pdf', 24, 64, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 679398, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 424, \"requirement_definition_id\": 112}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/64/attachments', 'e350a57a-b08c-41b1-850a-3d59fde26885'),
(266, 1, 'transactions.checklist_check', 'transaction_checklist_check', 82, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:08', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked DTR collected', 'DTR collected', 24, 64, NULL, NULL, '{\"item\": \"DTR collected\", \"workflow_step_id\": 425, \"checklist_override_id\": 74}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/checklist/74/check', '500499fc-4c10-4261-aa25-54e942a9382e'),
(267, 1, 'transactions.checklist_check', 'transaction_checklist_check', 83, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:10', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked Payroll', 'Payroll', 24, 64, NULL, NULL, '{\"item\": \"Payroll\", \"workflow_step_id\": 425, \"checklist_override_id\": 76}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/checklist/76/check', '4399f70e-f9bb-4586-9e04-ccb3b732dd5e'),
(268, 1, 'transactions.requirement_check', 'transaction_requirement_check', 206, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:16', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked Birth Certificate', 'Birth Certificate', 24, 64, NULL, NULL, '{\"requirement\": \"Birth Certificate\", \"workflow_step_id\": 425, \"requirement_definition_id\": 111}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/requirements/111/check', '4bf2b82c-13e9-486a-bd2a-99776b15b01e'),
(269, 1, 'transactions.requirement_check', 'transaction_requirement_check', 207, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:18', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked DTR validated', 'DTR validated', 24, 64, NULL, NULL, '{\"requirement\": \"DTR validated\", \"workflow_step_id\": 425, \"requirement_definition_id\": 113}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/requirements/113/check', 'f1544763-f4aa-43e3-a655-b43508752306'),
(270, 1, 'transactions.attachment_reuse', 'transaction_attachment', 218, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:23', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_reuse', 'Attachment linked AR.pdf', 'AR.pdf', 24, 64, NULL, NULL, '{\"label\": null, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 425, \"source_attachment_id\": 217, \"requirement_definition_id\": 111}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"source_attachment_id\"]', 'POST', '/api/admin/transactions/64/attachments/reuse', '934e99ae-5796-4657-ba68-7b5e5c5d4a1f'),
(271, 1, 'transactions.attachment_reuse', 'transaction_attachment', 219, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:26', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_reuse', 'Attachment linked AR.pdf', 'AR.pdf', 24, 64, NULL, NULL, '{\"label\": null, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 425, \"source_attachment_id\": 217, \"requirement_definition_id\": 113}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"source_attachment_id\"]', 'POST', '/api/admin/transactions/64/attachments/reuse', '5aa4e122-c010-41d6-9057-60d80cb81c7b'),
(272, 1, 'transactions.checklist_check', 'transaction_checklist_check', 84, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:39', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked DTR validated', 'DTR validated', 24, 64, NULL, NULL, '{\"item\": \"DTR validated\", \"workflow_step_id\": 426, \"checklist_override_id\": 72}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/checklist/72/check', 'bc0e20d3-fd48-41dc-9677-c6ac1f1d501e'),
(273, 1, 'transactions.checklist_check', 'transaction_checklist_check', 85, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:40', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked Birth Certificate', 'Birth Certificate', 24, 64, NULL, NULL, '{\"item\": \"Birth Certificate\", \"workflow_step_id\": 426, \"checklist_override_id\": 73}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/checklist/73/check', '16a2e6bf-e53c-4773-b406-1ed354ee0063'),
(274, 1, 'transactions.requirement_check', 'transaction_requirement_check', 208, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:44', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked Payroll finalized', 'Payroll finalized', 24, 64, NULL, NULL, '{\"requirement\": \"Payroll finalized\", \"workflow_step_id\": 426, \"requirement_definition_id\": 116}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/64/requirements/116/check', 'e5cf6ffa-42b7-453b-a15e-f9d3721df94a'),
(275, 1, 'transactions.attachment_upload', 'transaction_attachment', 220, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 15:58:50', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded AR.pdf', 'AR.pdf', 24, 64, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 679398, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 426, \"requirement_definition_id\": 116}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/64/attachments', '0cdac711-b0bb-40d0-98ee-db3bff3828c2'),
(276, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 23:04:37', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": true}', '{\"is_private\": false}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '3066f748-9f80-43d2-b5d4-c05f3a7ed695'),
(277, 1, 'transactions.privacy', 'transaction', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-16 23:04:44', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'privacy', 'Privacy changed 9BW8-WZLF-ZWL0', '9BW8-WZLF-ZWL0', 16, 67, NULL, '{\"is_private\": false}', '{\"is_private\": true}', '[\"is_private\"]', 'PATCH', '/api/admin/transactions/67/privacy', '720737fb-9dbe-4a3e-aa6b-1924f7fd4790'),
(278, 1, 'transactions.officer_reassign', 'transaction', 67, '{\"reason\":\"wala man sya ngani\",\"assignment_id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-18 21:18:06', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'officer_reassign', 'Reassigned the responsible officer for the current received step.', '9BW8-WZLF-ZWL0', 16, 67, 275, '{\"officer\": {\"id\": 1, \"name\": \"Vince\"}}', '{\"officer\": {\"id\": 43, \"name\": \"Carlo Miguel Saavedra\"}}', '[\"officer\"]', 'POST', '/api/admin/transactions/67/officer-assignment', '0054c1d4-1b71-4415-982a-9613168df6fd'),
(279, 1, 'transactions.checklist_check', 'transaction_checklist_check', 86, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-18 21:18:30', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'checklist_check', 'Checklist item checked CTO approve PR', 'CTO approve PR', 16, 67, NULL, NULL, '{\"item\": \"CTO approve PR\", \"workflow_step_id\": 479, \"checklist_override_id\": 130}', '[\"checklist_override_id\", \"item\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/checklist/130/check', 'b24fc9f6-a642-43aa-bfaf-0722232ced26'),
(280, 1, 'transactions.requirement_check', 'transaction_requirement_check', 209, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-18 21:18:35', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'requirement_check', 'Requirement checked CTO approved PR', 'CTO approved PR', 16, 67, NULL, NULL, '{\"requirement\": \"CTO approved PR\", \"workflow_step_id\": 479, \"requirement_definition_id\": 193}', '[\"requirement_definition_id\", \"requirement\", \"workflow_step_id\"]', 'POST', '/api/transactions/67/requirements/193/check', '030aba16-e5bd-48a3-be3d-3035625f569d'),
(281, 1, 'transactions.attachment_upload', 'transaction_attachment', 221, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-18 21:18:47', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'transactions', 'attachment_upload', 'Attachment uploaded AR.pdf', 'AR.pdf', 16, 67, NULL, NULL, '{\"mime\": \"application/pdf\", \"label\": null, \"size_bytes\": 679398, \"original_name\": \"AR.pdf\", \"workflow_step_id\": 479, \"requirement_definition_id\": 193}', '[\"original_name\", \"workflow_step_id\", \"requirement_definition_id\", \"mime\", \"size_bytes\"]', 'POST', '/api/admin/transactions/67/attachments', 'd50c83fd-128d-41dc-a88f-e65218d06a52'),
(282, 1, 'roles.delete', 'role', 5, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-19 17:05:48', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'roles', 'delete', 'Deleted Viewer', 'Viewer', NULL, NULL, NULL, '{\"code\": \"viewer\", \"name\": \"Viewer\", \"user_ids\": [33], \"description\": \"Read-only access.\"}', NULL, '[\"code\", \"name\", \"description\", \"user_ids\"]', 'DELETE', '/api/admin/roles/5', '7c205f52-7ad7-423c-b17d-c47eb65086ff'),
(283, 1, 'users.create', 'user', 66, '{\"payload\":{\"name\":\"Franklin James I. Oliveros\",\"position\":\"clerk\",\"username\":\"gsoclerk2\",\"email\":null,\"office_id\":8,\"contact_number\":null,\"is_active\":true,\"role_ids\":[17]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-19 17:09:48', 'Vince', 'vinzmuloc@gmail.com', '[{\"id\": 1, \"code\": \"superadmin\", \"name\": \"Super Admin\"}]', NULL, NULL, 1, 'users', 'create', 'Created Franklin James I. Oliveros', 'Franklin James I. Oliveros', 8, NULL, NULL, NULL, '{\"name\": \"Franklin James I. Oliveros\", \"email\": null, \"position\": \"clerk\", \"role_ids\": [17], \"username\": \"gsoclerk2\", \"is_active\": true, \"office_id\": 8, \"contact_number\": null}', '[\"name\", \"position\", \"username\", \"office_id\", \"is_active\", \"role_ids\"]', 'POST', '/api/admin/users', 'db4637d8-818f-4c18-99da-9d298ff4c078'),
(284, 10, 'roles.create', 'role', 20, '{\"payload\":{\"code\":\"admin_aid\",\"name\":\"Admin Aid\",\"description\":\"The one manages the workers\"}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-23 16:41:22', 'Sharief Kundo Mudrikal', 'admin@gmail.com', '[{\"id\": 2, \"code\": \"admin\", \"name\": \"Admin\"}]', 24, 'CSD', 0, 'roles', 'create', 'Created Admin Aid', 'Admin Aid', 24, NULL, NULL, NULL, '{\"code\": \"admin_aid\", \"name\": \"Admin Aid\", \"description\": \"The one manages the workers\"}', '[\"code\", \"name\", \"description\"]', 'POST', '/api/office/roles', 'b356344c-2a7b-42b1-b944-e322d91384e1'),
(285, 10, 'office.users.create', 'user', 67, '{\"payload\":{\"name\":\"Sir Bry\",\"position\":\"Admin Aid\",\"username\":\"csdadminaid\",\"email\":null,\"office_id\":24,\"contact_number\":null,\"is_active\":true,\"role_ids\":[20]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-23 16:42:02', 'Sharief Kundo Mudrikal', 'admin@gmail.com', '[{\"id\": 2, \"code\": \"admin\", \"name\": \"Admin\"}]', 24, 'CSD', 0, 'office', 'users.create', 'Users.create Sir Bry', 'Sir Bry', 24, NULL, NULL, NULL, NULL, NULL, 'POST', '/api/office/users', 'e377dfef-88b0-4754-8f2b-a568ed6b9ed3'),
(286, 10, 'roles.delete', 'role', 20, '{\"note\":\"Soft deleted role\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-23 17:09:58', 'Sharief Kundo Mudrikal', 'admin@gmail.com', '[{\"id\": 2, \"code\": \"admin\", \"name\": \"Admin\"}]', 24, 'CSD', 0, 'roles', 'delete', 'Deleted Admin Aid', 'Admin Aid', 24, NULL, NULL, '{\"code\": \"admin_aid\", \"name\": \"Admin Aid\", \"user_ids\": [67], \"description\": \"The one manages the workers\"}', NULL, '[\"code\", \"name\", \"description\", \"user_ids\"]', 'DELETE', '/api/office/roles/20', 'c22dad1a-97aa-4c99-b91d-7fe9948ae2b4'),
(287, 10, 'roles.create', 'role', 21, '{\"payload\":{\"code\":\"office_head\",\"name\":\"Office Head\",\"description\":null}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-23 17:10:11', 'Sharief Kundo Mudrikal', 'admin@gmail.com', '[{\"id\": 2, \"code\": \"admin\", \"name\": \"Admin\"}]', 24, 'CSD', 0, 'roles', 'create', 'Created Office Head', 'Office Head', 24, NULL, NULL, NULL, '{\"code\": \"office_head\", \"name\": \"Office Head\", \"description\": null}', '[\"code\", \"name\"]', 'POST', '/api/office/roles', '63caf9c6-10dd-4218-8de9-e9c30b89de68'),
(288, 10, 'office.users.update', 'user', 67, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-23 17:11:27', 'Sharief Kundo Mudrikal', 'admin@gmail.com', '[{\"id\": 2, \"code\": \"admin\", \"name\": \"Admin\"}]', 24, 'CSD', 0, 'office', 'users.update', 'Users.update Sir Bry', 'Sir Bry', 24, NULL, NULL, '{\"role_ids\": []}', '{\"role_ids\": [21]}', '[\"role_ids\"]', 'PUT', '/api/office/users/67', 'ba647f97-59a6-43cc-9454-215c5aa7c7f0');

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
('transaction-cache-0e79123a6ed1ed614801fdbdd9974f7e', 'i:4;', 1795550239),
('transaction-cache-0e79123a6ed1ed614801fdbdd9974f7e:timer', 'i:1795550238;', 1795550239),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81', 'i:9;', 1795550009),
('transaction-cache-21c7ea48997eeecf541f9afb4a8bfc81:timer', 'i:1795550009;', 1795550009),
('transaction-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:2;', 1795137190),
('transaction-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1795137190;', 1795137190),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883', 'i:1;', 1795550238),
('transaction-cache-a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1795550238;', 1795550238),
('transaction-cache-afa9674935f1748ea6188c8f2ec0ef3d', 'i:9;', 1795550201),
('transaction-cache-afa9674935f1748ea6188c8f2ec0ef3d:timer', 'i:1795550201;', 1795550201),
('transaction-cache-approvals:count:u1', 'a:2:{s:20:\"pending_requirements\";i:29;s:12:\"transactions\";i:13;}', 1795500111),
('transaction-cache-approvals:count:u10', 'a:2:{s:20:\"pending_requirements\";i:17;s:12:\"transactions\";i:8;}', 1795549823),
('transaction-cache-approvals:count:u59', 'a:2:{s:20:\"pending_requirements\";i:15;s:12:\"transactions\";i:7;}', 1795550206),
('transaction-cache-approvals:count:u67', 'a:2:{s:20:\"pending_requirements\";i:0;s:12:\"transactions\";i:0;}', 1795485424),
('transaction-cache-dash:overdue-overview:310cb6f67c528fe2d9ba8d5a3baeca6a', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:5;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}}', 1795139310),
('transaction-cache-dash:overdue-overview:3b373be3b5516550b0e7890b0c9d6f47', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:2;s:7:\"overdue\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:5:\"steps\";a:1:{i:0;a:7:{s:7:\"step_id\";i:476;s:4:\"step\";s:33:\"GSO return approve PR to end user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_2\";s:12:\"order_number\";i:2;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}}}', 1795139279),
('transaction-cache-dash:overdue-overview:413c0eb1d3a271fdd3ae70a5f031ee66', 'a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:14:\"September 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-07\";s:5:\"label\";s:8:\"Jul 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-08\";s:5:\"label\";s:8:\"Aug 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:5:\"steps\";a:0:{}s:17:\"overdue_by_office\";a:0:{}}', 1795139402),
('transaction-cache-dash:overdue-overview:75445424c8994cb29bd0c1edfa0c5871', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}}', 1795498663),
('transaction-cache-dash:overdue-overview:75e922a04bce2b46bf71d243a3924ea6', 'a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:12:\"October 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-08\";s:5:\"label\";s:8:\"Aug 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:394;s:4:\"step\";s:16:\"Submit PR to CTO\";s:9:\"step_code\";s:26:\"procurement_it_equipment_3\";s:12:\"order_number\";i:3;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}}}', 1795486764),
('transaction-cache-dash:overdue-overview:d0e15e6675e23c8f2584ced52bb8acbc', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:479;s:4:\"step\";s:16:\"Submit PR to CBO\";s:9:\"step_code\";s:26:\"procurement_it_equipment_5\";s:12:\"order_number\";i:5;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";}s:5:\"count\";i:2;}i:1;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}i:1;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}}}', 1795489376),
('transaction-cache-dash:overdue-overview:v2:000119ef6eb8ddde213fd5ee0882ced8', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}}s:5:\"steps\";a:0:{}s:17:\"overdue_by_office\";a:0:{}}', 1795548969),
('transaction-cache-dash:overdue-overview:v2:1f406b3a71d1b7f34d2ff07c7512c61b', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:7;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:1;s:17:\"completed_on_time\";i:1;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}}', 1795550240),
('transaction-cache-dash:overdue-overview:v2:75445424c8994cb29bd0c1edfa0c5871', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:11;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:1;s:17:\"completed_on_time\";i:1;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}}', 1795549740),
('transaction-cache-dash:overdue-overview:v2:8840e0ed6793a9934d8a9c6b5770b6ec', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:2;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}}s:5:\"steps\";a:0:{}s:17:\"overdue_by_office\";a:0:{}}', 1795548965),
('transaction-cache-dash:overdue-overview:v2:d0e15e6675e23c8f2584ced52bb8acbc', 'a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:12;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:1;s:17:\"completed_on_time\";i:1;}}s:5:\"steps\";a:3:{i:0;a:7:{s:7:\"step_id\";i:395;s:4:\"step\";s:35:\"CTO  Return approve PR to  End user\";s:9:\"step_code\";s:26:\"procurement_it_equipment_4\";s:12:\"order_number\";i:4;s:16:\"transaction_type\";s:26:\"Procurement : IT Equipment\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:1;a:7:{s:7:\"step_id\";i:72;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}i:2;a:7:{s:7:\"step_id\";i:424;s:4:\"step\";s:11:\"Collect DTR\";s:9:\"step_code\";s:11:\"collect_dtr\";s:12:\"order_number\";i:1;s:16:\"transaction_type\";s:7:\"Payroll\";s:6:\"office\";a:3:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";}s:5:\"count\";i:1;}}s:17:\"overdue_by_office\";a:1:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}}', 1795547482),
('transaction-cache-dash:portal-status:v1:0d84933827e046906adf75cba7776597', 'a:3:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:6:\"months\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:10:\"in_process\";i:11;s:14:\"completed_late\";i:0;s:17:\"completed_on_time\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:10:\"in_process\";i:0;s:14:\"completed_late\";i:1;s:17:\"completed_on_time\";i:1;}}}', 1795550202),
('transaction-cache-dash:summary:v2:0927472b0f7644c158b4a1bb0ebfd322', 'a:18:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:13;s:7:\"overdue\";i:3;s:13:\"overdue_steps\";i:10;s:20:\"overdue_transactions\";i:4;s:23:\"overdue_steps_by_office\";a:6:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;}i:2;a:4:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:2;}i:3;a:4:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:5:\"count\";i:1;}i:4;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}i:5;a:4:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:229597;s:22:\"oldest_pending_minutes\";i:49543;s:20:\"working_transactions\";i:8;s:15:\"working_minutes\";i:72021;s:22:\"oldest_working_minutes\";i:16582;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:10;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:17:\"on_time_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"WJVR-4V6U-2ZRT\";s:5:\"title\";s:48:\"Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"JZJO-GQWY-CMD5\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:7:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:3;s:12:\"transactions\";i:1;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:16:\"reference_number\";s:14:\"9BW8-WZLF-ZWL0\";s:5:\"title\";s:11:\"LENIN LENIN\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}i:1;a:7:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;s:5:\"Vince\";i:1;s:20:\"Angelica Mae Navarro\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"NU5A-C47R-ESAV\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"VPWN-I12N-H2OH\";s:5:\"title\";s:27:\"vincent anthony procurement\";s:8:\"assigned\";a:1:{i:0;s:20:\"Angelica Mae Navarro\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1795152219),
('transaction-cache-dash:summary:v2:c6bf6e5100ccbda7e2f4bfc51208d04a', 'a:16:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:11;s:7:\"overdue\";i:2;s:13:\"overdue_steps\";i:5;s:20:\"overdue_transactions\";i:2;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:258468;s:22:\"oldest_pending_minutes\";i:55317;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:67520;s:22:\"oldest_working_minutes\";i:17556;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:8;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}}', 1795498663),
('transaction-cache-dash:summary:v3:0927472b0f7644c158b4a1bb0ebfd322', 'a:18:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:13;s:7:\"overdue\";i:3;s:13:\"overdue_steps\";i:10;s:20:\"overdue_transactions\";i:4;s:23:\"overdue_steps_by_office\";a:6:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;}i:2;a:4:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:2;}i:3;a:4:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:5:\"count\";i:1;}i:4;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}i:5;a:4:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:229619;s:22:\"oldest_pending_minutes\";i:49547;s:20:\"working_transactions\";i:8;s:15:\"working_minutes\";i:72053;s:22:\"oldest_working_minutes\";i:16586;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:10;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:17:\"on_time_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"WJVR-4V6U-2ZRT\";s:5:\"title\";s:48:\"Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"JZJO-GQWY-CMD5\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:7:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:3;s:12:\"transactions\";i:1;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:16:\"reference_number\";s:14:\"9BW8-WZLF-ZWL0\";s:5:\"title\";s:11:\"LENIN LENIN\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}i:1;a:7:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;s:5:\"Vince\";i:1;s:20:\"Angelica Mae Navarro\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"NU5A-C47R-ESAV\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"VPWN-I12N-H2OH\";s:5:\"title\";s:27:\"vincent anthony procurement\";s:8:\"assigned\";a:1:{i:0;s:20:\"Angelica Mae Navarro\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1795152471),
('transaction-cache-dash:summary:v4:0927472b0f7644c158b4a1bb0ebfd322', 'a:18:{s:6:\"period\";a:4:{s:3:\"key\";s:3:\"all\";s:5:\"label\";s:8:\"All time\";s:4:\"from\";s:25:\"1970-01-01T00:00:00+00:00\";s:2:\"to\";s:25:\"9999-12-31T23:59:59+00:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:13;s:7:\"overdue\";i:3;s:13:\"overdue_steps\";i:10;s:20:\"overdue_transactions\";i:4;s:23:\"overdue_steps_by_office\";a:6:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;}i:2;a:4:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:2;}i:3;a:4:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:5:\"count\";i:1;}i:4;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}i:5;a:4:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:229760;s:22:\"oldest_pending_minutes\";i:49576;s:20:\"working_transactions\";i:8;s:15:\"working_minutes\";i:72284;s:22:\"oldest_working_minutes\";i:16615;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:10;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:17:\"on_time_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"WJVR-4V6U-2ZRT\";s:5:\"title\";s:48:\"Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"JZJO-GQWY-CMD5\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:7:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:3;s:12:\"transactions\";i:1;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:16:\"reference_number\";s:14:\"9BW8-WZLF-ZWL0\";s:5:\"title\";s:11:\"LENIN LENIN\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}i:1;a:7:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;s:5:\"Vince\";i:1;s:20:\"Angelica Mae Navarro\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"NU5A-C47R-ESAV\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"VPWN-I12N-H2OH\";s:5:\"title\";s:27:\"vincent anthony procurement\";s:8:\"assigned\";a:1:{i:0;s:20:\"Angelica Mae Navarro\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1795154163),
('transaction-cache-dash:summary:v4:ab3528b5b4865d350b4428bf1b5da316', 'a:18:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-10\";s:5:\"label\";s:12:\"October 2026\";s:4:\"from\";s:25:\"2026-10-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-11-01T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:12;s:7:\"overdue\";i:2;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:2;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;}i:1;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:257476;s:22:\"oldest_pending_minutes\";i:55119;s:20:\"working_transactions\";i:7;s:15:\"working_minutes\";i:77390;s:22:\"oldest_working_minutes\";i:17418;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:9;}i:1;a:3:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"Payroll\";s:5:\"count\";i:4;}i:2;a:3:{s:2:\"id\";i:2;s:4:\"name\";s:11:\"Procurement\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:17:\"on_time_by_office\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;s:5:\"Vince\";i:1;s:20:\"Angelica Mae Navarro\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"NU5A-C47R-ESAV\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"VPWN-I12N-H2OH\";s:5:\"title\";s:27:\"vincent anthony procurement\";s:8:\"assigned\";a:1:{i:0;s:20:\"Angelica Mae Navarro\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1795486761),
('transaction-cache-dash:summary:v4:e8bb403ffd4166025d542df21353fdc5', 'a:17:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:1;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:262260;s:22:\"oldest_pending_minutes\";i:56076;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:68743;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:19:\"office_step_metrics\";a:4:{s:13:\"entered_today\";i:0;s:14:\"received_today\";i:0;s:11:\"in_progress\";i:3;s:8:\"released\";i:0;}}', 1795544163),
('transaction-cache-dash:summary:v4:e936cb273cea2cdd081300971ed5cf6c', 'a:18:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:1;s:7:\"overdue\";i:1;s:13:\"overdue_steps\";i:9;s:20:\"overdue_transactions\";i:2;s:23:\"overdue_steps_by_office\";a:6:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:2;}i:2;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}i:3;a:4:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:5:\"count\";i:1;}i:4;a:4:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:5:\"count\";i:1;}i:5;a:4:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:258567;s:22:\"oldest_pending_minutes\";i:55337;s:20:\"working_transactions\";i:8;s:15:\"working_minutes\";i:79973;s:22:\"oldest_working_minutes\";i:17576;s:7:\"deleted\";i:0;s:10:\"by_process\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:2:\"id\";i:11;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"count\";i:1;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:1;}}s:17:\"on_time_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"WJVR-4V6U-2ZRT\";s:5:\"title\";s:48:\"Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"JZJO-GQWY-CMD5\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:5:\"count\";i:3;s:12:\"transactions\";i:1;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:3:{s:16:\"reference_number\";s:14:\"9BW8-WZLF-ZWL0\";s:5:\"title\";s:11:\"LENIN LENIN\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}', 1795499847),
('transaction-cache-dash:summary:v4:ec2ba5aecc2dd4852e3bc44213a0679e', 'a:16:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:1;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:262051;s:22:\"oldest_pending_minutes\";i:56034;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:68743;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}}', 1795541655),
('transaction-cache-dash:summary:v4:ece56b69f6558f4bc25466001b876944', 'a:16:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:1;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:262052;s:22:\"oldest_pending_minutes\";i:56034;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:68743;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}}', 1795541667),
('transaction-cache-dash:summary:v5:0af391ea347656d38e00d625b59b9810', 'a:17:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:0;s:20:\"overdue_transactions\";i:0;s:23:\"overdue_steps_by_office\";a:0:{}s:20:\"pending_transactions\";i:0;s:15:\"pending_minutes\";i:0;s:22:\"oldest_pending_minutes\";i:0;s:20:\"working_transactions\";i:0;s:15:\"working_minutes\";i:0;s:22:\"oldest_working_minutes\";i:0;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:19:\"office_step_metrics\";a:4:{s:7:\"entered\";i:0;s:8:\"received\";i:0;s:11:\"in_progress\";i:0;s:8:\"released\";i:0;}}', 1795548970),
('transaction-cache-dash:summary:v5:2d90bc672fd40d0c9b132e1291466cef', 'a:19:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:1;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:262536;s:22:\"oldest_pending_minutes\";i:56131;s:20:\"working_transactions\";i:7;s:15:\"working_minutes\";i:79783;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:10;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:17:\"on_time_by_office\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;a:7:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:2;s:12:\"transactions\";i:2;s:6:\"people\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;s:5:\"Vince\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"samples\";O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;a:3:{s:16:\"reference_number\";s:14:\"WJVR-4V6U-2ZRT\";s:5:\"title\";s:48:\"Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL\";s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}i:1;a:3:{s:16:\"reference_number\";s:14:\"JZJO-GQWY-CMD5\";s:5:\"title\";N;s:8:\"assigned\";a:1:{i:0;s:5:\"Vince\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"returns_by_office\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:19:\"office_step_metrics\";a:4:{s:7:\"entered\";i:2;s:8:\"received\";i:2;s:11:\"in_progress\";i:1;s:8:\"released\";i:0;}}', 1795547481),
('transaction-cache-dash:summary:v5:7bdb2ec19e54748a592fc14a02e647d3', 'a:17:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:2;s:20:\"overdue_transactions\";i:0;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}i:1;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:3;s:15:\"pending_minutes\";i:150351;s:22:\"oldest_pending_minutes\";i:56150;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:67303;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:8;s:7:\"overdue\";i:1;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:19:\"office_step_metrics\";a:4:{s:7:\"entered\";i:1;s:8:\"received\";i:1;s:11:\"in_progress\";i:0;s:8:\"released\";i:0;}}', 1795548965);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-dash:summary:v5:e8bb403ffd4166025d542df21353fdc5', 'a:17:{s:6:\"period\";a:4:{s:3:\"key\";s:7:\"2026-11\";s:5:\"label\";s:13:\"November 2026\";s:4:\"from\";s:25:\"2026-11-01T00:00:00+08:00\";s:2:\"to\";s:25:\"2026-12-01T00:00:00+08:00\";}s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;s:13:\"overdue_steps\";i:4;s:20:\"overdue_transactions\";i:1;s:23:\"overdue_steps_by_office\";a:2:{i:0;a:4:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:5:\"count\";i:3;}i:1;a:4:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:5:\"count\";i:1;}}s:20:\"pending_transactions\";i:5;s:15:\"pending_minutes\";i:262766;s:22:\"oldest_pending_minutes\";i:56177;s:20:\"working_transactions\";i:6;s:15:\"working_minutes\";i:68743;s:22:\"oldest_working_minutes\";i:17760;s:7:\"deleted\";i:0;s:10:\"by_process\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:7:\"monthly\";a:3:{i:0;a:5:{s:5:\"month\";s:7:\"2026-09\";s:5:\"label\";s:8:\"Sep 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}i:1;a:5:{s:5:\"month\";s:7:\"2026-10\";s:5:\"label\";s:8:\"Oct 2026\";s:9:\"completed\";i:0;s:10:\"in_process\";i:9;s:7:\"overdue\";i:2;}i:2;a:5:{s:5:\"month\";s:7:\"2026-11\";s:5:\"label\";s:8:\"Nov 2026\";s:9:\"completed\";i:2;s:10:\"in_process\";i:0;s:7:\"overdue\";i:0;}}s:19:\"office_step_metrics\";a:4:{s:7:\"entered\";i:2;s:8:\"received\";i:2;s:11:\"in_progress\";i:1;s:8:\"released\";i:0;}}', 1795550239),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4', 'i:7;', 1795500143),
('transaction-cache-f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1795500143;', 1795500143),
('transaction-cache-lookup:offices', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:23:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-11-04 06:54:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:21;s:4:\"code\";s:5:\"CHRMO\";s:4:\"name\";s:37:\"City Human Resource Management Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-11-04 06:54:30\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:22;s:4:\"code\";s:3:\"GDS\";s:4:\"name\";s:43:\"CMO - Gender and Development Services (GAD)\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"LEGAL\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-28 17:43:44\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:25;s:4:\"code\";s:5:\"LEGAL\";s:4:\"name\";s:13:\"Legal Officce\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-28 17:43:44\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:3;s:4:\"code\";s:4:\"OCAC\";s:4:\"name\";s:29:\"Office of the City Accountant\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:2;s:4:\"code\";s:3:\"OCA\";s:4:\"name\";s:32:\"Office of the City Administrator\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:8;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:14;s:4:\"code\";s:4:\"OCAG\";s:4:\"name\";s:31:\"Office of the City Agricultural\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:9;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:10;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:11;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:15;s:4:\"code\";s:4:\"OCCR\";s:4:\"name\";s:34:\"Office of the City Civil Registrar\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:12;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:20;s:4:\"code\";s:6:\"OCDRDM\";s:4:\"name\";s:53:\"Office of the City Disaster Risk Deduction Management\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:13;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:7;s:4:\"code\";s:3:\"OCL\";s:4:\"name\";s:27:\"Office of the City Engineer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:14;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:16;s:4:\"code\";s:5:\"OCENR\";s:4:\"name\";s:52:\"Office of the City Environment and Natural Resources\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:15;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:11;s:4:\"code\";s:3:\"OCH\";s:4:\"name\";s:25:\"Office of the City Health\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:16;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:17;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:10;s:4:\"code\";s:4:\"OCPD\";s:4:\"name\";s:43:\"Office of the City Planning and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:18;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:12;s:4:\"code\";s:5:\"OCSWD\";s:4:\"name\";s:49:\"Office of the City Social Welfare and Development\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:19;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:20;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:13;s:4:\"code\";s:3:\"OCV\";s:4:\"name\";s:31:\"Office of the City Veterinarian\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:21;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:22;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:10:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:11:\"\0*\0original\";a:10:{s:2:\"id\";i:19;s:4:\"code\";s:2:\"SP\";s:4:\"name\";s:22:\"Sangguniang Panlungsod\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:11:\"steps_count\";i:0;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1795550780);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-lookup:transaction-types:v4', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-09 23:44:35\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-11-04 07:15:49\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:3;s:4:\"code\";s:13:\"communication\";s:4:\"name\";s:13:\"Communication\";s:11:\"description\";N;s:9:\"is_active\";i:0;s:10:\"created_at\";s:19:\"2026-03-09 23:44:35\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-11-04 07:15:49\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:13:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;s:25:\"pivot_transaction_type_id\";i:3;s:15:\"pivot_office_id\";i:23;s:16:\"pivot_created_at\";s:19:\"2026-09-23 17:16:15\";s:16:\"pivot_updated_at\";s:19:\"2026-09-23 17:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:23:\"office_transaction_type\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-23 17:16:15\";s:10:\"updated_at\";s:19:\"2026-09-23 17:16:15\";}s:11:\"\0*\0original\";a:4:{s:19:\"transaction_type_id\";i:3;s:9:\"office_id\";i:23;s:10:\"created_at\";s:19:\"2026-09-23 17:16:15\";s:10:\"updated_at\";s:19:\"2026-09-23 17:16:15\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:19:\"transaction_type_id\";s:13:\"\0*\0relatedKey\";s:9:\"office_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:24;s:4:\"code\";s:3:\"CSD\";s:4:\"name\";s:25:\"Computer Service Division\";s:11:\"description\";N;s:9:\"icon_path\";s:58:\"offices/icons/HCmUoj7F3cVUOymt0AhobWDzaDJ00ZyFmOc41qSh.jpg\";s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";s:19:\"2026-10-26 17:29:02\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:64;s:19:\"transaction_type_id\";i:3;s:7:\"version\";i:7;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:3:\"bry\";s:5:\"notes\";s:1:\"s\";s:12:\"published_at\";s:19:\"2026-09-30 20:33:37\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 20:33:36\";s:10:\"updated_at\";s:19:\"2026-11-04 06:59:20\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:64;s:19:\"transaction_type_id\";i:3;s:7:\"version\";i:7;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:3:\"bry\";s:5:\"notes\";s:1:\"s\";s:12:\"published_at\";s:19:\"2026-09-30 20:33:37\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 20:33:36\";s:10:\"updated_at\";s:19:\"2026-11-04 06:59:20\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:405;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:15:\"communication_1\";s:4:\"name\";s:23:\"Communication Station 1\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:405;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:15:\"communication_1\";s:4:\"name\";s:23:\"Communication Station 1\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:405;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:405;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:405;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:12:\"pivotRelated\";O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";N;s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:0;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:0:{}s:11:\"\0*\0original\";a:0:{}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:406;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:15:\"communication_2\";s:4:\"name\";s:25:\"Communication Station End\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:406;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:15:\"communication_2\";s:4:\"name\";s:25:\"Communication Station End\";s:5:\"stage\";N;s:9:\"office_id\";N;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:406;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:406;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:406;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:407;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:15:\"communication_3\";s:4:\"name\";s:3:\"bry\";s:5:\"stage\";N;s:9:\"office_id\";i:23;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:407;s:22:\"workflow_definition_id\";i:64;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:15:\"communication_3\";s:4:\"name\";s:3:\"bry\";s:5:\"stage\";N;s:9:\"office_id\";i:23;s:11:\"sla_minutes\";i:60;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"updated_at\";s:19:\"2026-09-30 20:33:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:23;s:4:\"code\";s:6:\"LEDIPS\";s:4:\"name\";s:60:\"Local Economic Development and Investment Promotion Services\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:407;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-21 21:43:09\";s:16:\"pivot_updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:407;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:407;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-21 21:43:09\";s:10:\"updated_at\";s:19:\"2026-10-21 21:43:09\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-09 21:24:39\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-20 17:11:37\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:7:\"payroll\";s:4:\"name\";s:7:\"Payroll\";s:11:\"description\";s:9:\"job order\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-03-09 21:24:39\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-20 17:11:37\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";r:246;s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:80;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:9;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";N;s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-27 17:10:26\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:80;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:9;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";N;s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-27 17:10:26\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:498;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:11:\"collect_dtr\";s:4:\"name\";s:11:\"Collect DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:960;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:498;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:11:\"collect_dtr\";s:4:\"name\";s:11:\"Collect DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:960;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:6;s:4:\"code\";s:8:\"end_user\";s:4:\"name\";s:8:\"End User\";s:11:\"description\";s:34:\"Creates and forwards PR documents.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:6;s:4:\"code\";s:8:\"end_user\";s:4:\"name\";s:8:\"End User\";s:11:\"description\";s:34:\"Creates and forwards PR documents.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:498;s:13:\"pivot_role_id\";i:6;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:6;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:6;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:498;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:498;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:499;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:12:\"validate_dtr\";s:4:\"name\";s:12:\"Validate DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";i:4;s:11:\"sla_minutes\";i:960;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:499;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:12:\"validate_dtr\";s:4:\"name\";s:12:\"Validate DTR\";s:5:\"stage\";s:2:\"HR\";s:9:\"office_id\";i:4;s:11:\"sla_minutes\";i:960;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:4;s:4:\"code\";s:4:\"OCAS\";s:4:\"name\";s:27:\"Office of the City Assessor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:1;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:499;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:499;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:500;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:16:\"finalize_payroll\";s:4:\"name\";s:16:\"Finalize Payroll\";s:5:\"stage\";s:10:\"Accounting\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:1440;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:500;s:22:\"workflow_definition_id\";i:80;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:16:\"finalize_payroll\";s:4:\"name\";s:16:\"Finalize Payroll\";s:5:\"stage\";s:10:\"Accounting\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:1440;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:3:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:1;s:4:\"code\";s:10:\"superadmin\";s:4:\"name\";s:11:\"Super Admin\";s:11:\"description\";s:25:\"Full access (local-only).\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:1;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:1;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:500;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-27 17:10:26\";s:16:\"pivot_updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:500;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-27 17:10:26\";s:10:\"updated_at\";s:19:\"2026-10-27 17:10:26\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:26:\"App\\Models\\TransactionType\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:17:\"transaction_types\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:30:22\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-30 00:30:22\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:11;s:4:\"code\";s:24:\"procurement_it_equipment\";s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:11:\"description\";s:43:\"This is a procurement for the it department\";s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:30:22\";s:16:\"createdby_office\";i:24;s:10:\"updated_at\";s:19:\"2026-09-30 00:30:22\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:3:{s:7:\"offices\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:0:{}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:15:\"createdByOffice\";r:246;s:12:\"liveWorkflow\";O:29:\"App\\Models\\WorkflowDefinition\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:20:\"workflow_definitions\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:12:{s:2:\"id\";i:74;s:19:\"transaction_type_id\";i:11;s:7:\"version\";i:18;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-26 16:53:01\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:74;s:19:\"transaction_type_id\";i:11;s:7:\"version\";i:18;s:6:\"status\";s:9:\"published\";s:7:\"is_live\";i:1;s:4:\"name\";s:26:\"Procurement : IT Equipment\";s:5:\"notes\";N;s:12:\"published_at\";s:19:\"2026-10-26 16:53:01\";s:12:\"published_by\";i:1;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:3:{s:7:\"is_live\";s:7:\"boolean\";s:12:\"published_at\";s:8:\"datetime\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"steps\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:8:{i:0;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:475;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:26:\"procurement_it_equipment_1\";s:4:\"name\";s:16:\"Submit PR to GSO\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:0;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:475;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:1;s:4:\"code\";s:26:\"procurement_it_equipment_1\";s:4:\"name\";s:16:\"Submit PR to GSO\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:0;s:8:\"is_start\";i:1;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:475;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:475;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:475;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:476;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:26:\"procurement_it_equipment_2\";s:4:\"name\";s:33:\"GSO return approve PR to end user\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";i:8;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:476;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:2;s:4:\"code\";s:26:\"procurement_it_equipment_2\";s:4:\"name\";s:33:\"GSO return approve PR to end user\";s:5:\"stage\";s:12:\"PR numbering\";s:9:\"office_id\";i:8;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:8;s:4:\"code\";s:3:\"GSO\";s:4:\"name\";s:22:\"General Service Office\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:476;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:476;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:476;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:2;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:477;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:26:\"procurement_it_equipment_3\";s:4:\"name\";s:16:\"Submit PR to OCT\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";i:5;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:477;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:3;s:4:\"code\";s:26:\"procurement_it_equipment_3\";s:4:\"name\";s:16:\"Submit PR to OCT\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";i:5;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:5;s:4:\"code\";s:3:\"OCT\";s:4:\"name\";s:28:\"Office of the City Treasurer\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:477;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:477;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:477;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:3;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:478;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:4;s:4:\"code\";s:26:\"procurement_it_equipment_4\";s:4:\"name\";s:35:\"OCT  Return approve PR to  End user\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:478;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:4;s:4:\"code\";s:26:\"procurement_it_equipment_4\";s:4:\"name\";s:35:\"OCT  Return approve PR to  End user\";s:5:\"stage\";s:21:\"Availability of funds\";s:9:\"office_id\";N;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";N;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:478;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:478;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:478;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:4;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:479;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:5;s:4:\"code\";s:26:\"procurement_it_equipment_5\";s:4:\"name\";s:16:\"Submit PR to CBO\";s:5:\"stage\";s:29:\"Availability of Appropriation\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:479;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:5;s:4:\"code\";s:26:\"procurement_it_equipment_5\";s:4:\"name\";s:16:\"Submit PR to CBO\";s:5:\"stage\";s:29:\"Availability of Appropriation\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:9;s:4:\"code\";s:3:\"OCB\";s:4:\"name\";s:25:\"Office of the City Budget\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:479;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:479;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:479;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:5;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:480;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:6;s:4:\"code\";s:26:\"procurement_it_equipment_6\";s:4:\"name\";s:25:\"Submit Pr to Mayor Office\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:1;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:480;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:6;s:4:\"code\";s:26:\"procurement_it_equipment_6\";s:4:\"name\";s:25:\"Submit Pr to Mayor Office\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:1;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:1;s:4:\"code\";s:3:\"OCM\";s:4:\"name\";s:24:\"Office of the City Mayor\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";N;s:10:\"updated_at\";N;s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:2:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:2;s:4:\"code\";s:5:\"admin\";s:4:\"name\";s:5:\"Admin\";s:11:\"description\";s:34:\"Manages master data and workflows.\";s:10:\"created_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"updated_at\";s:19:\"2026-03-09 21:24:36\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:480;s:13:\"pivot_role_id\";i:2;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:2;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:1;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:480;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:480;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:6;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:481;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:7;s:4:\"code\";s:26:\"procurement_it_equipment_7\";s:4:\"name\";s:37:\"Mayor Office return approve PR to CBO\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:481;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:7;s:4:\"code\";s:26:\"procurement_it_equipment_7\";s:4:\"name\";s:37:\"Mayor Office return approve PR to CBO\";s:5:\"stage\";s:14:\"Mayor Approval\";s:9:\"office_id\";i:9;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:0;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";r:3483;s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:481;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:481;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:481;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}i:7;O:23:\"App\\Models\\WorkflowStep\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:14:\"workflow_steps\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:15:{s:2:\"id\";i:482;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:8;s:4:\"code\";s:26:\"procurement_it_equipment_8\";s:4:\"name\";s:17:\"Submit PR to PAAD\";s:5:\"stage\";s:13:\"PR submission\";s:9:\"office_id\";i:26;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:15:{s:2:\"id\";i:482;s:22:\"workflow_definition_id\";i:74;s:9:\"parent_id\";N;s:12:\"order_number\";i:8;s:4:\"code\";s:26:\"procurement_it_equipment_8\";s:4:\"name\";s:17:\"Submit PR to PAAD\";s:5:\"stage\";s:13:\"PR submission\";s:9:\"office_id\";i:26;s:11:\"sla_minutes\";i:120;s:8:\"is_start\";i:0;s:6:\"is_end\";i:1;s:11:\"is_end_user\";i:0;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:4:{s:8:\"is_start\";s:7:\"boolean\";s:6:\"is_end\";s:7:\"boolean\";s:11:\"is_end_user\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:2:{s:6:\"office\";O:17:\"App\\Models\\Office\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:7:\"offices\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;}s:11:\"\0*\0original\";a:9:{s:2:\"id\";i:26;s:4:\"code\";s:4:\"PAAD\";s:4:\"name\";s:43:\"Procurement Acquisition and Awards Division\";s:11:\"description\";N;s:9:\"icon_path\";N;s:9:\"is_active\";i:1;s:10:\"created_at\";s:19:\"2026-09-30 00:41:30\";s:10:\"updated_at\";s:19:\"2026-10-25 17:16:44\";s:10:\"deleted_at\";N;}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"icon_path\";i:4;s:9:\"is_active\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}s:5:\"roles\";O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:1:{i:0;O:15:\"App\\Models\\Role\":34:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:5:\"roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:8:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;}s:11:\"\0*\0original\";a:12:{s:2:\"id\";i:17;s:4:\"code\";s:5:\"clerk\";s:4:\"name\";s:5:\"Clerk\";s:11:\"description\";s:25:\"Processes assigned steps.\";s:10:\"created_at\";s:19:\"2026-10-19 23:03:27\";s:10:\"updated_at\";s:19:\"2026-11-20 01:08:45\";s:10:\"deleted_at\";N;s:9:\"office_id\";N;s:22:\"pivot_workflow_step_id\";i:482;s:13:\"pivot_role_id\";i:17;s:16:\"pivot_created_at\";s:19:\"2026-10-26 16:53:01\";s:16:\"pivot_updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:1:{s:10:\"deleted_at\";s:8:\"datetime\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:1:{s:5:\"pivot\";O:44:\"Illuminate\\Database\\Eloquent\\Relations\\Pivot\":37:{s:13:\"\0*\0connection\";N;s:8:\"\0*\0table\";s:10:\"step_roles\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:0;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:4:{s:16:\"workflow_step_id\";i:482;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:11:\"\0*\0original\";a:4:{s:16:\"workflow_step_id\";i:482;s:7:\"role_id\";i:17;s:10:\"created_at\";s:19:\"2026-10-26 16:53:01\";s:10:\"updated_at\";s:19:\"2026-10-26 16:53:01\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:0:{}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:0:{}s:10:\"\0*\0guarded\";a:0:{}s:11:\"pivotParent\";r:511;s:12:\"pivotRelated\";r:562;s:13:\"\0*\0foreignKey\";s:16:\"workflow_step_id\";s:13:\"\0*\0relatedKey\";s:7:\"role_id\";}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:4:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"office_id\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:11:{i:0;s:22:\"workflow_definition_id\";i:1;s:9:\"parent_id\";i:2;s:12:\"order_number\";i:3;s:4:\"code\";i:4;s:4:\"name\";i:5;s:5:\"stage\";i:6;s:9:\"office_id\";i:7;s:11:\"sla_minutes\";i:8;s:8:\"is_start\";i:9;s:6:\"is_end\";i:10;s:11:\"is_end_user\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:8:{i:0;s:19:\"transaction_type_id\";i:1;s:7:\"version\";i:2;s:6:\"status\";i:3;s:7:\"is_live\";i:4;s:4:\"name\";i:5;s:5:\"notes\";i:6;s:12:\"published_at\";i:7;s:12:\"published_by\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:5:{i:0;s:4:\"code\";i:1;s:4:\"name\";i:2;s:11:\"description\";i:3;s:9:\"is_active\";i:4;s:16:\"createdby_office\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}s:16:\"\0*\0forceDeleting\";b:0;}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1795481349);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('transaction-cache-weather:zamboanga', 'a:5:{s:11:\"temperature\";d:25.6;s:4:\"code\";i:45;s:6:\"is_day\";i:0;s:4:\"time\";s:16:\"2026-11-25T03:45\";s:5:\"place\";s:14:\"Zamboanga City\";}', 1795551743);

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
(70, '2026_11_05_000002_add_is_private_to_transactions_table', 35),
(71, '2026_11_09_000001_extend_audit_logs_table', 36),
(72, '2026_11_10_000001_flip_is_private_semantics', 37),
(73, '2026_11_10_000002_make_existing_transactions_public', 38),
(74, '2026_11_12_000001_add_position_to_users_table', 39),
(75, '2026_11_09_000001_require_usernames_for_authentication', 40),
(76, '2026_11_11_000001_set_team_account_usernames', 40),
(77, '2026_11_11_000002_make_transactions_public_by_default', 40),
(78, '2026_11_15_000001_convert_sla_minutes_to_working_days', 41),
(79, '2026_11_15_000002_add_current_run_to_transaction_states', 42),
(80, '2026_11_17_000001_add_officer_assignments', 43),
(81, '2026_11_18_000001_mark_automatic_officer_assignments', 44),
(82, '2026_11_18_000002_add_office_scope_to_roles', 44);

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
  `deleted_at` timestamp NULL DEFAULT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `code`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`, `office_id`) VALUES
(1, 'superadmin', 'Super Admin', 'Full access (local-only).', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL, NULL),
(2, 'admin', 'Admin', 'Manages master data and workflows.', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL, NULL),
(3, 'clerk_releasing', 'Clerk Releasing', 'Release assigned steps.', '2026-03-09 13:24:36', '2026-10-19 14:47:58', '2026-10-19 14:47:58', NULL),
(4, 'approver', 'Approver', 'Approves steps routed to them.', '2026-03-09 13:24:36', '2026-10-19 15:18:43', '2026-10-19 15:18:43', NULL),
(5, 'viewer', 'Viewer', 'Read-only access.', '2026-03-09 13:24:36', '2026-11-19 17:05:48', '2026-11-19 17:05:48', NULL),
(6, 'end_user', 'End User', 'Creates and forwards PR documents.', '2026-03-09 13:24:36', '2026-03-09 13:24:36', NULL, NULL),
(7, 'gso', 'GSO', 'General Services Office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:05', '2026-10-19 14:48:05', NULL),
(8, 'city_admin', 'City Administrator', 'Signs/approves as City Admin.', '2026-03-09 13:24:36', '2026-10-19 14:48:09', '2026-10-19 14:48:09', NULL),
(9, 'cto', 'CTO', 'City Treasurer Office reviewer.', '2026-03-09 13:24:36', '2026-10-19 14:48:37', '2026-10-19 14:48:37', NULL),
(10, 'city_treasurer', 'City Treasurer', 'Signs/approves as Treasurer.', '2026-03-09 13:24:36', '2026-10-19 14:48:41', '2026-10-19 14:48:41', NULL),
(11, 'cadmin', 'CAdmin', 'City Admin office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:43', '2026-10-19 14:48:43', NULL),
(12, 'cbo', 'CBO', 'City Budget Office processor.', '2026-03-09 13:24:36', '2026-10-19 14:48:44', '2026-10-19 14:48:44', NULL),
(13, 'bac_paad', 'BAC-PAAD', 'Receives final submitted documents.', '2026-03-09 13:24:36', '2026-10-19 14:48:47', '2026-10-19 14:48:47', NULL),
(14, 'clerk_receiving', 'Clerk Receiving', 'Receiving of documents', '2026-09-25 15:10:36', '2026-10-19 15:15:39', '2026-10-19 15:15:39', NULL),
(15, 'clerk_procurement', 'Clerk Procurement', 'Clerk assigned in Procurement', '2026-09-25 15:12:12', '2026-10-19 14:48:50', '2026-10-19 14:48:50', NULL),
(16, 'staff_technical', 'Staff Technical', NULL, '2026-09-25 15:14:57', '2026-10-19 14:48:52', '2026-10-19 14:48:52', NULL),
(17, 'clerk', 'Clerk', 'Processes assigned steps.', '2026-10-19 15:03:27', '2026-11-19 17:08:45', NULL, NULL),
(20, 'admin_aid', 'Admin Aid', 'The one manages the workers', '2026-11-23 16:41:22', '2026-11-23 17:09:57', '2026-11-23 17:09:57', 24),
(21, 'office_head', 'Office Head', NULL, '2026-11-23 17:10:11', '2026-11-23 17:10:11', NULL, 24);

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
(17, 64, '2026-11-05 16:33:43', '2026-11-05 16:33:43'),
(17, 66, '2026-11-19 17:09:48', '2026-11-19 17:09:48'),
(21, 67, '2026-11-23 17:11:27', '2026-11-23 17:11:27');

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
('01GzMa8thfoA0Ds0Y65ZBXDWaJWOGDrtU1Xb9fer', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVJnN2NiS0tuNXE0MXFUTVZlT3Vod25HRllhd0Zackg0cVpqNU1WdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545282),
('0aNsepqPt3Uv5MFsD0tsTgHYGQ0OMEOAoKcbf71Z', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOG9tbFh3ZnBXeG5IVWhObm9wZmJ0MG03M1QxZ3VnUVZDRFMzWVZkZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544110),
('0D0hDs6i23LwewYEot1dG3fnMYev3UVLe0QlYn2g', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkJkMGtQQUw5R294RmFrTjhITlRIa1NobXRTQVJoSXhiTzVBbHBJMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542993),
('0dsW6rh0WbaGGe9Lagv1UdiejGvX6BWoH4e8t7Qf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3lKYVZZMFZNdEpRRnlIVHVkYWt3THY4TUhiMFkwU1ZsTDJGVHBJayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543364),
('0jcQTECxZb4Q3PVaNTJNLcugp93zlHHneGy8bOlA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFBTUEdGUEZ0TXlqZGEwZXZpZWhaRVJlcEhjYVFhclJZNThHZVUxeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542776),
('0o8acx4qxyOyS5XqELH0lhho9sPCTZ5qNG7RvmYX', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUW1RT3J0NVJvczBHT3VUMGdMNUtpc1FBR0ZveEp6cEdjQUo5Wkt6dCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544974),
('0oJ1uqYKltEHe0zr7KPNx75dyVNUslDnubwRPOFD', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2I4ZTFVZUFlTGlHOU1paUFsOUVVcExQQWNkWVM2REY5WXdBZTBQcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546206),
('0SdWlpTEzaG724wqcUw0BxtBPIuq8kenA1R15FEL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSFBvTUpiZFVxcFRHOVp4ZGhRc0RjM1dlUDZCOUp3SkUxcEVzaHZxTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548676),
('0sNhc72xwyh39TIo3IJLAtpB5D1iGHuI6uw5BNdX', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTdLZGlqbzd6VDdLbUJEZzZRYVhnRFl4U0VmV2thUXpqZXZuYVltcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548738),
('0Y84mmbAMlOOIu1Ouq4OvbOvkvYOGngtKjZCmLAl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTWpKeXp2T052QWZZclhuSmt5TU4ycUloYlpRTlB1dlE4ZUN6cWZ2QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545498),
('12Ets9PihDS1MtZzjOlBjvUEzDciuwqznpYaYVnL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZlZMRWZ4TkJwQmJNc2JzWEpyVHJXaDhsSGJ3QnNEWXJTUGxxWlRkayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546268),
('14AU3hQoQIlbtcKSyhErR1luTzm1hEShFEJkFTtH', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNTVXRTcySEw4VFlEYTJNMVNkY21IVXI4OUdxWUxOUU5PbjNUbjEyMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543737),
('1CUiy8JyC7JRyzWqvsZzXM2A81NPYDpanU7YlqGe', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGtJM1M4Q0tVbXlXWlZucWJvalNFTVFIMUJnOGN1dFljajZMcE9vbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548983),
('1d59WbUnstAxN4HrL8chEs9WjvROIGeoD29nINJv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT2VhV2EwdnFMY3RYdnhtaW1hQWpadG9mOTFZbEpRbHJxMm12bm9YRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548398),
('1HV29lerSs0GJe5w2AQdjJm2RfZC84OEPDgOjLmB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT2JzOW9Tc0lCT1V4WTF3YVNLN0xHMHgwWDBoaDdDRlV4RnlOd01COSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548026),
('1kn43faukuDA3yxuBAxbx3WNI6EFDPSeqzOwazHU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV3J0NWx3QmZmMnFoT242UWROYUY3TFI5TzkwOTBHQTJGMk5JMFV2ZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545313),
('1mijj8jtMWykFoN7uo1CwYFyvmZ9mY3SD906ICIn', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY1lBRFBsVkF3b3VWbnE2UmpnZWl1MW01ZWJ5Q3FYa2Frd1BlRms2eSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545283),
('1ZKxjA6YQARRWVre650tM2w8ifKYp06CDyMAQzl7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGNDZUxtTmlpVjQxc2NyUm85d2puRGtpYXRkNWJOOVBCeWRZYjhXWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542808),
('1ZkYCt73PYZuQ7A2T70TFIGH3MXFf3Vy0rnCDVNx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkx1VERGalliZHFVSFk3R0kzVTlsRTlIcWM1T29NbUpCWlg5T25HUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548861),
('26OPhQpUzx8eu6N2YrGsQmIK8AG5Y4faS6BPTCY2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQnRCRFNmSktEeGRlMm1WbTVzTHNnQ01paVlXd01mNWp3cHVOYlVZUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545405),
('2alh813Xf8BtjCgIOJS3PIZVGk0Q9V0Mkf0RWWsx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVXRSNmo5bElBaFNwZ0JUZjlsYzhQRHdzbkE0d1ZFSEtmdkJwTXJVeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546638),
('2CEhRocx5hVAVJLOuRwSCX7f1sIRVvL8LhxWS3dE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieHpEWnhJY0hMZGlzb0dLbFg1VUVLalpSejFwRlBkSHdyWnpMMWpIMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544418),
('2d4SwP6tJkVwSsJWWvytUklS33e3Id3Zlj5BOOmV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYnNod084VzRvekdUTGVjQkIzd3RDNFpBR285ekswQWJUd1pPbGZhSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548306),
('2eVjSuMIkIqPS3CAEL69EPapCsM3eazCzdMmxqsh', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY2pvNDNYc2hDREZQcW95ZE5MeU5nMXJCT09xa0dDRXY0cHFQWmpIcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545590),
('2FIQoZlgzu3V8vxfhBahQIy8p3HRwYmc8oS5keaQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTEo4Mk5KOU5YU2pXQmxvUVNRdDRuZHpCc2dXdm9GTml0enAyMjJENyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542529),
('2jkwI1gh0fxXnTQfdjWswj7lFGBt1WP3d7Su5HQL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRTROMFk3OTdqOUNxVmw2UWpvWncweE5ISGU0Y3RwRUZXM1J4bFlvQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545221),
('2lMHyggYBaYu1bp2JJaee57XHE3Vc6lpnooUSyEL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWHBZUk5oOHF4UW9EbUhTWXc4bWhuamNrR1lhMzUxN2UxVVE0eFhveCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547903),
('2Oc8nksb6LhJ7PPVTp8yuMdLH6jT5JmCJ1M6yCFE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMnVqcjBVTzFQdHJ5cnNHN3hBZmh0QjJacUptRW5HQ3FVV0RWQnZ3OSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549938),
('2v6qYV3NDoE8GmXranb2lW2rNtVnvD19oMBnpDZi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicGVjRGhpZGxrMEJXYUk2S3dvd1pGTTZHWEFpMHl3aGF1ek43M1MyayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546206),
('2wZ1C8bm81f4b6a3ekysU5acm4jN9f8o4fVHkRqT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGc1T0k4cVJtZGRVZ3JkT24wWjEzT1lpQTJLbXA1UzFWeUE4SzNPMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547347),
('34LEmrgY7onWkkvvP8fUur3ApBV2RGh0bpeKbzUN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic3dsYWMyQUhoS3Rqb1B2dHZNYzk0ajNQTU9EZ09EWGF3ZGt4Nk9XQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544172),
('3826RS2NtXc7goTTYdmGNUuQX8MxLAabMaBP0ra0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiODM2SkkzRThIdDIzeFBVc3ZQUzR0b1RLa0U5UVR4ZDBqWGNBVXUyeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546515),
('3bOA2dTtoLaNT4SS3l4ry8Y8qxvrzGz2dX016PFz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWEtham1qWTBUTUt5ZlhPQU1oc3hrRHNaMlA0amgzZWNKalRNZ0tqUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548646),
('3kD3uu7quZBnPo25DviGv0f3X24dKbFDWeebDYTg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTzJPRGtiV2pCa0JIZmJubHNmWTM1WUpmVDYwS2lzWTZYcmZLemhWaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548305),
('3s2qhzS3sB9ImZkirMLTPMo1hvGAkQwbaIXjIV4E', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVDgyckhSZ2MyUEdSZXhSY0dPVlE0REltbXhBdVYwd3FxejFWMzB0bSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544851),
('3UxsG7fHLZGVBto3qyMPfJvGlSM7bSZ7y3rjBsbB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0Q0eU40TXN2ejdiN2h6MWVFaFRpWldMUUQ2NktTbXhVRDZjUTBlVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543086),
('3wwkbL4O1k19hnG9sHLqau8FXaRbnsxLBgTZ8aIe', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib1FKWGd3bjhGUnZ4VjVGWWN6cEVRWkUyRXp6eFZLOVpPSG9YTHFJWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543178),
('3y4NbTTgFbB5KOXxZq1tAuhTPOOKft5jfibZutLr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEswMElGU0JsNlR0ZEs4ekgyUTNrZHN5NEpjRkpIcFNaWGhrbjA2QSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548337),
('3zgslwVegOqOTNuIMqiYYbLIbQO9isWl0Oqnqvpl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYzBXMWQ3V0RHMUFIUndEa0pMb1JWbnlEaUdoaGRlM0pMZXEzcTI0WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548953),
('49WJBcvzpS9GWBwuu1IHp8S3hB4QRwJX3lb8OVtQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzIwVllGczd6VlZwS3JxUjVoS210azZVbzVqUmJ3U0VWemI3bHdNMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545159),
('4CMXaKY7eOPWLU15PWE33g2WhsvBmuyNpWHDr2nA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0xuWXlWU1ZVa0hFRUFDT0RuWmROUmQ5YmpvUnF1YTVzTFRWYWE0cCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543301),
('4CxECGePP4iRJk0wODqppddysaFXUnBVApY8CJ9q', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZWF1ZmxaRzd2S2hkeFhMVWRWTHJpNk1Rbk5UdkNWMnFKTTROb1FjRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549200),
('4jv5Hm4vsFt2u4euzq8DcjHWhmyakXqp5N54mBaU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUEFrb3ZxY0VBbGRXWEdRaldTTDN0d1ZMb2VCWm1nRnNWR0ZqUXd0ciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546052),
('4rpgA7O4Av7Mn7QLSklBQMUMzlpXO9Q6zjjgTBvK', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWUQ1dXdIRmozeW11aG1pOFdYT2tvS2lKUHlqUnpQVmthMHpMWE1pbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547225),
('519tYHOe7vWpFvKNVvQDaQLlK4KiYn9gsH5Ux7ND', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibVRORUNnbEp1dm9zTzlDd1VtUVl4c3IwcTVBM0JZQTNmWU5NZ3NvbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549262),
('53AhHHSeuM0pOX1a5NPT8mUgkhYW4IJ6gD0V48sh', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRHBBenJ5RUFwRXNCWGxEQ3FrcjVhd2NHc21FT3lEWVM3WnJNNTM1dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547038),
('5QcE8WsubWXYmft8350QYwGg157M7mIknJRXXSV6', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOW43ZW5JaXRqcDJuSGpuNHhVN2JYSHdBWXdUV2JTVjVlZ1RZbVpMNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547902),
('61BcDRTJwHY4MlDpT03gYqDdhuv98wztwrHmdU5k', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOERpaDZTRGF5Uzdsd2MxOVNYd01ON2swYmpkNW45VXl6OTdLY2tXYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542591),
('6BYdLNtaebcoB9G956haI3aUbU40Yo3w4ZihyzSk', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic3hBNDNPTDNHRUQ2ZFh0OUFtaE15TnBzektKMjlLSjRkbENlTGZrVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547749),
('6EPIYikET7tPPdgZ20X3dVCx1VcEqv4LhUDw5p5A', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGdMaFg4OUJFMXlZbmplVlBvNFhnUVpPSEphQ25ST1RzdEdES2IwcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546883),
('6P3xa3PKHkAIdi0OP1LcoiIo3cZKnkDGL7XtMIZl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY2k3MmEzTTdTV1BuQUtuUjVUZklNWFVCWHQ3VEN5aUdHcXRnMTJpMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547841),
('6UJq9Sg4XtMkVzfR7zTDasXGRrSpLz1w2RwS69qn', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0lLc05qcUxXeTUxemRGcXI5UXhIdk1NNUtIcnBNRE1CR0ZkbElmRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549507),
('6UvehrNhWSfI7LKHiXmCapZcpVXBgo4m6CyrN9Fl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGhFWGQ1TEVNZmQyT2ptbEl5bG9teHpxVFQzMEhNS0ZnWDJyNWhFeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544573),
('6W5nN0eY87kkhjb7smlCvdcwrS0yjrdROjkXkpRH', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOThPV0pOS2c1eWtQM3lHanBmQm95eGdWOXk0MTRkbk9NRkVEVDg3WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548275),
('6XkICwHkXlZxXIAyjVkCCyVX6Z6Rk3e2YpB4W1vL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0NWQWFqZGxkVmZiRzlmMUc4TzBYQ2NWZW1rS0tHOU1XeEN6SkVVSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548553),
('70zHO0vbF2wpEX1ShBvvEXIWOGJ6mWB25Izhgiva', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3FUd0I4WHczRXRZTDJmWEQ4QzNoejlqMkRZZjlzSnEzRm1KUHVLRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544665),
('742Yf1EiNDIpIGxREAA22qlNr55ZllaZwSDtHiec', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWhVV1pqa05pc0owSmpLdVdWNGQ1RWw4VFpCZno5TFBxZzVvY3NIMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544881),
('7BXundgGBvdeATkx0hHJfWSWrSiAvNkqfmnKXGAC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGFSRjdLY25nU0hPektnYWhtSnp6VkdncWZIVnZKR0I5WW05UUxoOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548645),
('7Khfj2U1WCrc7ZzfuM4PYXPnR3Efh20CzbCYsYsq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN1REclE3aW1lV1FHOWtjYmRRVkRheks2Zldxd3pMZVJIZkE0WUVhRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545713),
('7sL4MFUZKd7p4za0V16JQOP2b4oK4FJejj0y56vp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ2c0Q0h4RVNPaFY1cTVrdzBJNzZIUWRETmhxbW9McUlDaFA0NXZ5eiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548553),
('7zTz1z6QQZxx81ds8DyyrizPxqsFimVpqqqu44tx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiczE2R1RvVklZSnpaNUdPSnlCWHgyUG9kRUtPU01FT25lQlVmTXFwTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545714),
('83XWGEVD3BaNYKIN8BSL3JG8hCHa3sE2JxrSPanN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ0d3NzdKUDVveDRyQ3ptRkpPdWJna2RqaDFsMHRtRTdXUEpiQ2tJQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544079),
('86jpkaqm5lkI5FpO4AvNc8Ud81owTDs9E7sTtjbu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGVBalZXNGJ0bmh5cno0WE5Ec0pDcjNLYXJHSnF1RXJISTZya0xIMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544017),
('870TBgeqlypjtFY4AmFVkRQCF1ob0LwlAtyDPSWT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibWQ3dVM1V015Q0VSMGROWXhYbERlQ3F1ZTJYSlJoenVzUXBKWmFTNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547255),
('8GAWcAzIm9PlE6INXKQejE69LR5NS4A8mvrWMOf5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0RvRTVYNHlQZmVOYXJHeE5LcGJCMUdjZXhjcGNVNWIwMjlqTlViTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548522),
('8HADSP5glz81uChW77E19CKFl9iruXJiTtIRA48q', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQnpjSWYwU2dBU3hoekd2R3lOVkxkQjMwRFFMRkt4OFBEQzVhM1JXRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545405),
('8MQbvmdKzlwl4tf3mgDGiSVpKo2h7V0wUUeAeQrA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMlViR2twNnV5aFNocjRpOFlxbGNnME9TVVJUOE1TOFhxQUxKQzEyVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550185),
('8pKkQivOoOA1uZNlMrgJnBEdScz2L4fDRxDB9KAW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMWY2TXFxbU11WW1DM1djbnFGaXRFUVo3RE5qa2VaNGk3cXQxSHd5QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544203),
('8RK8vgLB768d8F6wHYIkb3z1EU2rwm74lky9hT4F', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNktEOXZKcFFGZ3hCSFBEa3QyZGtvalY1TFdEOGREbUVRZmREYkVGZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543209),
('8UcgseM2YqRem3WaiXEReN0Q0xFD59SfNmVkRdhd', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRW90U1k5RkpidmxHMzFKUDkzWlU5cUNjTlVrTHRJTzdtMzVMYlhaUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545867),
('8Y99BTA2aLacMW99PMKh5ahiNQTFcn5iknea91sQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUVvZVo0cTRjOG13Nzl0RzFiSU9wT0dnekpVd0lZdjlTSmhmU0FIeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549106),
('92A9O84dE0JELoYedgiH3MbMgF4ksFRHMJEn8hN3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0hjOWVLQ05BU0JOU3ZNY0Z2OU01aHZiMm1GVG1YZnhZblNFcjFvRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543551),
('95s81eK7xOWUWnw3m9evHTaEi8gNAUpp8C0G1RUS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNFJSTXdiRnY0UEJUT3hEelVRODlFWG9XQm1pOGZXUlY4anhMRmVUdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549968),
('98qvpXu4R24pkork1RA6iJgFt24ZH2i3Cf9YLBXN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ1ptZm05ODhvZkVEZHpIdmJQRlJDenNQZ21mYW1XazQzTGhrRmZVdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546761),
('9afbrhT7egg6O6GmGfKtysmW0fPZlMyi26F7f9u2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmV1dnc3b3JUMU41dklkY1poc0RGSUp5WXh2MTFQdnRidnp6RXRMZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542807),
('9d38zZQ8wL4vrSU2PkGDXk59etzJundUwmYWRuWR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUFUwWEIweTZKZFpPaE9kRG1rZzV6S3Q2bFpQbHJoUUEyY1BsdlM2SSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548584),
('9EVyiwULhyM3NuyaRaCFMkW0ocyARiO3NwS3WMPC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjZxZUk4MjdTc1VCNzQybElHYUxEb3Z5UlU4T2dObVdjeEl5QTE5YSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547441),
('9fa8kwbbvGoEZEwnwO39TGRRNsEX17KfJQkTCKAu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiazhQRGhNV09jcHY4OVZaMnVYM0RFem5kdjR4R2RKTjVVR2tzblM4dyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543831),
('9gXdkEmvcphaqg9T8Kzn2990iPYs36q0f41alfvi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOW5TbFk2Q3VZWUtRWGh3YXNXRnRPMm51QmJTYVRoRFc3WHlHVzNvSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546113),
('9qeCzbFjkQrkOe2XlNSr1ZHQMX469a3fRRCMHZZb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMlQ5dmtZeXl1ckZ0ME5WUlBGSFBmT1ptVU1sWkhSa2o4ZHFlcDd2WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548861),
('9ucRwiOe4ysqrhdReHPg5YpFRchKzRBrxnYHotEY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRzVUenhHandjVXo4QVVTY2kycFZNakZCdExXSlNpUVFHQ2VSc3FaViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542838),
('9UtQzgzCNGRvyTdXSlcNwBqQTAiyvE7DDPFREytP', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWFNCSEFpQkRVSTl0Q0JNMm9tT3lXaHhVeVhwY0dQU3lhZWxWYzViUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543116),
('9xlkf5HqqdQxexLFyrXvBK4KcI0Oz6uhqn4lFOGb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibFlGQmlXdXJpaUpoWFhmQjB3ZGhLTVRkY0NuMUg2VXlKVG1JRjM5bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542684),
('9Y4JB7ndsIe21nqZGGgEgCntOXKyRwjirbGIKI8K', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ2o4OE1EWGpiYlNTaUFBR1JoWDdESXVBUmp0QkZ1Z0praWJYZ3lWMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542962),
('A0VcyYJFsYTJ00yhUGqfN6MzHB3sPMG9GjkCvd9x', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMDJGekUxY3lFSGliMHM3WktZSmpVcXNJMW5rQ3F5STdxWlFlQmtURSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542591),
('a8N3NKVykLMckBznuC7hHL9UBkcQVvlD6PRqQ73i', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMktiTVc5VmtuRDY2anRwQTZkdXNsVzFUTkdFNW93Rjc0VWRST3NMdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549107),
('AaRZItfJdWxVU0BcGc3VBjLKcc6075NSTCvwF6p8', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOXdxRW5Kd0U2R1VpbGpJY0kxRHh0YUNUbTBPYzliUWhBUDJ4TXR6cSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549753),
('aaWnqjc9fHU66vc5t4epaDFBAmnVMD2jis2aKgPw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidzhnV2lBVDNzTUNUMmwwRks3akcyeXBMeEFpTkI1dEFGRUxaSHN0SSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546484),
('abqlsEVv8furgFTVnHyrnX2ne9Hd2pvQBWuG6EdQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMkhVSzluMUUzY0NzZXFjcnVhVGhFUVhjT1NjRDIzN2k1U1JWNTRTNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544511),
('AdOmTQyNykCiCo7zqe9oItdi75I0uMhplHbQGaD4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWURoblFiRms3Vzc4WDZTVXFDUDNEd25yYmlTYlB5Mkttd2doM05GMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544295),
('afA60TPS6bUYSNeaogPZBdm9xTkoRnXfvUuyFp4X', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2JJb3N5QnJWVUp6aGlZaTZWQmVhRklsUGxiTDlhSlBOVmhwVTNsVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549937),
('aJOUB1F9zjIiVHyyu9sdmQnP8hHJEawhRa6l2uWw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWU83bWh3azdIUjEyN25uazBPTzhjVkRGRk9kY0ZhQUtodDNOc1dSQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546083),
('AJUu5wjFNSGTDJh9Mjie8TBycVptcEKmiSD99Fof', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQjNYT0xYMjU1ekRjSjZUYUFrdnR4cEU3ZGJENUtPeTFQN0d2VFlnUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547410),
('alX7hLipdDQnM3Qpjc3AtkLfEZdNdVHqH2GSiQKA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSklHaVR6OXExVUU5emFjV25KYVl3aGtBTXo0QlNxM2EzVE5UMEtoUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548088),
('ansjkKlDLl4bJPnESOZxSoHQTy8JCLPXmv1GNfHf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYXdnM05VSWJEMFJsWHRCUzhJZXdDTlpKQURuN3l2U2lZWVlmR3c1biI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544542),
('AqgHlk5FQ4JFrTMUnGX7ol3W49ObrVsHbK0k9HcS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidEFFSGppR3cwQzI1TFpQZVJuU0xlNFJPdFRvNjU5R1ZaaXkyeFlQbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543024),
('aUxBdICQnpU7fV3nGSSp4dwTPPw62BPiqIvl0f7h', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNzZBeGVEZGNJM2pkc0pQT054YXdHTlQ4bkZ2YzZ0NUw4MDJQanpRSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544943),
('azJFuEpSTIduM0A2ZAXKOYWmbQxJEtP7Xo99hZY5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVVZKckV6Y3ZMUm5JV0JUaWtwRHRXZFlLakllVmZ2V3Q5U3BWQUJqMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543583),
('B1IoKJ2bFM78Vlkp3y12NPdUUtuUsPBzFNC3A1FV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaHQ4aHFiWng5Z1RHNEREYm5JcTB0MGNld2syYlo0d3NieDBNc1B0OSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543332),
('BcQnMXX0iVQ7kXW6Y66Desq1Dqh6slmSUOvi2kk2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic01VdDk4N0tRcTBPUTZ5TWFrNDU3QjZmdG1HY285UG15eDE3VWdCYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547255),
('bCVnRapQgmcYZJcf6AgVKGBDcBxDk5zCRqAxCTu2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVnVnSjkzMnZQUXpGOVVBNWhNamxTMEhXaHFJTU9pejU3aktHMmpTeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548429),
('bD3U6eFPWykwSIX8XqHLHzCOmKCLQGh8R8NcMtMa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3lqRkpDRURzNXR6Qk1GMkNmUFp4V1RuSk1tMno3ZkhSOTVHSVlYRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545466),
('BeUEQfCwpRf5gyJlBja7sh1MqQjbrkoXKLE4HPq7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjhaMThSRU1yeFc5QW9tRGpzVnI5WDlqaVJTTVFlR0c4OHRuV2J1cCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549446),
('BhpradsF76EFS9lAnU4DVZhtG13LGJppKGRnSunF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWWROclJjUUdLM2txOFRESUlxblFLZmlhalRNR012eWpDdmVRbGp0NyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547534),
('bi3XBUMgCuocpXCwgKI2Fi0e8fK0Q4OqGUVUH9QY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiU281OFdkS0dNVzNGSG8zU3JmQ1NWeWV1cnhRMmxCTWFOYjhGMW5odCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546269),
('biMFiFgabqfrcTWZ7al1T6a5M9IinTXmY2JCDVve', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRE9jTnpaWEZpekhRWGRPOEhlSmtpRWdaTXFRTjFCNUVUQXpiWjQ4WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543986),
('BJPgYDdhkWhIEzuQhs3nWghNvjX0D0u1VArpzqUS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWEJKSUE5UW1MRFp5dEJqRGNqVGxzZTNJdG9JcnJ1WXE4dk41MG1JSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546514),
('bkYi2rQnG7T4zB1U1eg1weBUCxUDIgItVn8kU4qU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibmU3all1MFVqWDhwTVJzZ0o1a3NSMUR3WHJURWxtUHhsU2xscktqNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542715),
('bmqYtKWw3a6FVVzjN1PGZDtNVDYMaxJbBzAPQj4q', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVG5uRkNVdVQzdHlaVGNsR1NXSWo4M2haWDE5YmxmUDRsNjkwbVpJRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547379),
('BmXZY1uHH8XSEAKKAxVAIhiDPJxegi6jSxQV3yJA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGdPSWFhYXBVZFhvMnNmUFpUQWdmYVY3TXFNZ0dNdVloaGpPMDBkUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546484),
('BMZXeJJwiZ5AGEkuPYL16AnELaBdMB9nEE2nXj4I', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjI5SVh5bmFZWHVIYUVuWkIwT0pQemZJMk12WkJ6OHNNSEpCcG8xaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544820),
('BNdw0j7ooR2ENCymKTWnV5UAmwafnVdegM8yYBd6', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTXllNGZ3V0Z1OVc4QzZqZ05tMVJKMkRLWWc2ZEpyT1JqZFA3N0VuciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549722),
('BQF0Uc6thqDykZcohfJVHjnVGlTWPeaCxZPQwoXt', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibHdjaEV3N0ZpVHJYTFZsd1hjRzF1ZDFBMjlXVVo3ZFVMYjVjMDZidiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549200),
('bRhar5a0iJGW2A9vKk66u5ly5rPsrYUjBN9bVbG7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUpiNXpyM1k1RGNKa2ZuSlRtRFhPNjlLY1VzMzFKNDBYanlZS2NsQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542560),
('bSb4LU9g4GCvXsZQa5GuIRM1Z6KhgiXHsxZwZXre', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHppUDBDb3J1MEhWYnMybGNoMno0QmFYcVdvQXUyMDI1UzNxbndhMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549415),
('BTeWTH2xpZ1mnCWjP9cE0xwufgO0tdByXcdsFlmu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWHpVOGp3V2I5dDc5dFNNdGkwam5oZ3lDcDIxZmdsT2FObE14UG1JVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549599),
('bUxzJlHKuxDYsa7oUaHLsZjb7bUcwNseHf3P3Dit', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiakc3YTgwYlR2YlQ5MDlqb2s4dHpFOFJRMTMzQlFxU1JhbVA4amZJciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550030),
('bVEBigLe30nGg1xnAFzcyWr8CNfOPgYFFMkayD4w', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUIzT05SVlV3Nkp5c3kzQVY2ajl6c3pUcXZMdms5TnFYVWhPcVRhMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546822),
('BwbPRZqTZpV4vyN8mNn5tqILvEVOmvDNIaQoKjPt', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUpPanRnZWtiYWdhbkJ5T2JEWkViV0N5Z2hRSUZMVnl1OHpuVmp2RyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545621),
('BwEbn7FWlBfN8Y82walqNlN29cnm1PvdVqkC244M', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZExzdEUxVjZtYVAwY1VVQ2VQUkc5UHJ4RVg1MWs2UnczMzZRS2djeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546083),
('BX6F08yiIDZq3t4hzjt9myMoOqkNI7xAzdrzG3Q0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHhlU2wybFdSM21MNTNKV1hYVzV5VXhpS0QwWDZrQzY1akhMSjZHYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545190),
('bxdca2waclvJc8CFAgutxTmviIwu8IYz1v6ZqTu1', 67, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiemhMaGh5S21ZTmtmamtUa2VqdHJ6cU5NTll0WktNVDE2elBVRk5nVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Njc7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6ImJmYzM4NzJhNWU0MDIxN2IzMjZlNWU4YTJjNmI0MzBkZDJkOWMwMjE3YjJjM2VlZDQ1MGVlNzYwOTU4NzM0Y2QiO30=', 1795550180),
('bXjkw8Vsnb16I3zyP692gjBDZiAizHU5C3dXz41H', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3BueDNSaEU2VnpBdmZWZnB1Z0djMEFvQzBhTDNNTnBJQk1GN3duRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544728),
('bxtN1mHICeSLn1TvcsChFHsRCBHQHMI1aW805Kqz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzlpNkhuTmhPTDZHTHc1eE1PUUVoNG53Z3RPTlNtY3ZUUUhrNGo5OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549876),
('BZ6ezjt1xW0z5gkTGkIONpYVhaKlV0TqojOcv1XG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia0ZJQnVtQVJDY0pNVFEwTWpXTmtObnBrRnBhMjJ3UUlQQ3FNWkM4NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543457),
('cBcoYoCQAwnHYyiOFvh5RWOuiQxMHH0KO8J6Aqb4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRWp6bWk4dDA5aWJTNDhwQnhqQ0dZblVWb1NZWFNNS3RYb080MVgzOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546175),
('CbLHZiC5rwhlbAm2nMIf6cdDPUXANsywhFLkZhbD', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2xlTmtEb2k5OVQ2V24xemRhS0hldWZUNGZHa2g2QktROWVGNGxPYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545744),
('CE1ctUK1KIlHY7MgwSOhEooPk9d7ftf62U71EOXW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUjhXSWNvR2ZXenRiMjNBajdrVUNxM1hjMnVYSGdDR1ZUTmtxOUpCcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543271),
('cKsvgKj2ZOgz1lh1AbOrYxLZcCMfjwah2gXNrmlf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFNHSDdENVpCUjR6V25MZDNIeE9POUpwdnlJTU5jeFRIMnlVMEh6ayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546822),
('cleDbm0RJxzOzZFMq5yxyVW3NEnO37Dlc6F4h1l5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTzg4YWZSTjQ5TXVrRDJGc3BZcFBiNzhIb1VYMjlnUll2QW1sanFzSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549353),
('cOFCg5U3SX0i57v4hSJsMVBjpupROWrNL5yyTR9M', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZzd3R01seEZZbExJU3Y1alFWUHpnZ253Z2xHZGpNMFlHM1k0NVdOdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550092);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('CQFg7DduNvuyMeRavQffmyYlSI92glRKlFrrkGkS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQzBtRktSOEN2Z29zSWNYWlZSYkJLYmxEMFFwUDNJNHQyWlk5ZWx3TiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547841),
('cUo07lpRZBuUbGp6AUoPst0JokcsSWqIh985J12V', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3hLcGkzNmM0TkdBRzlDekMxNk9nWFRTSXAzdFBKbU5vOTI2QTA5eiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542745),
('CwCH87kAW1HGkkFPSWhv2k9ANYrbcsytdYGVbQu8', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiazFQMWRlV1E1Q0xEZ1FNVnFOQThjU2xxaFo1UGlYYU9JTlpNbnRFRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547595),
('Cx8d87sHb9qcO15q5Pi2i1KwqMmTwQvf3EjnePVU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic3lRdTB5Z3hoNEhwNzZGUDJ1aXpiN1BkVE1zaE9tQlgxYVJDbGpyNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545929),
('CxBCxtKlr1JmWmRlQONbmEUxhwacLAIaoOcfd6Kz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUHhMUVh0dEFQUXAyWHBSdjUyUW10RTdiZ3Axb3ZjcDU1RnFjRng2VSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549476),
('d718elDnFATjmHVIaAvBKxz7tr57apfeJ9pgXh9H', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUhSZzdScE43ckJPd3kzbEV6YmhQaThPUlE5bldBbXJqckRSS2haVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548181),
('dg2D53hLenlpUGv2ugs3gGqBuoUK18F80Hh4otkR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYndHRTg3QUZJV0IyeEpHZG1mck5meTNKVTFaRWZQcEQwTjJWTHVLRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543055),
('DhonoFYQ8JpqoUuEn7LXDrOJPDnOle2zMi9Q8NWa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYmVIMnlLYzZqZ1oxaHhQRWRvWjNHcmhIblFmaVAwZEpwUWVpYWl1TiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544635),
('dkK2YwuwIbOxnzcUSVtvSYoP8X6PrDEES5d8SX6I', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia091dmJlVURGYkthOHo4SndDOVRvZWxYMzNYU2VDempudWpNcXNyeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549507),
('DKX5Au083feGrj9qCbnLPkZzhnJXHHm8znSJFMZx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieEhmM2Zyc3J3Q1Q2dEJURHNEaWlYV2lJdXVGQ0VYUnRHWk5RbThiQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543955),
('dlGfqVQTAkeSrvjnKE2OzLCksOHe7ffvW0HhC6i1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMnN2WmVzcVBHZ3NXRnIzUHFGUmxKUzkxcW5IOEFIcGxQTzFrZUlXYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544696),
('DNu4NhvTsWl11KIpD652xnV8XnxkMsX2nG2teAhG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNkc1RlFyc0t0VnMzeHRaMUcyUG16MnZJZ2hCV2JSdzl6MEJMZUNDOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549907),
('dpH2sCAgitvCumahfoN0t8BJyuXlZTA7vD0QLMe1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieUI5STBQdllrNmZXQUlBMlpWWTF4SzhyUjNmQjg0bVhKcGh0VWxDbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543085),
('DPkI4VBonEhTfNrWBygCQNaBILFqOIE4qgacKB7C', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibGdBd1NZT0tVVWYwaDNjRjN6Y1BqdFZUWEpQdDE3ZG1zaWtCRVJQSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546453),
('dPmyz3b55CrW4b3jpMxNRt4oGY8S1tMcUiYEPYzM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoienViSWN3d3dUUlRzNER0eXJTaElpcUJ3elpjTUFaTTFUV1lIV0c0WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543334),
('dPUluCfrxvS30AqavVNaLP6et13b8vJXXMPzrSN4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNDR3QTNiR3BIcUw3aFNFY0swTVBVV0FHQmxWUXQwUXVsT2psbGZZayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544172),
('Dq7ctGOuHwqij7RDi6OmNurwpz5NxoDpH3tYuukg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVURiOEFCRUdPc1BocFdqbllyZEs3c0s5bUJzTnZ5RDlUak9CVW9CZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548922),
('dRw3ZfleYNsiq5P27sngikGwxbLYH16HlQRQurCT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1B5WGt2UWJGb2pkTXRVdDlHQ2VxV3FiT2xsMDJQVmVhREFDT09tZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549292),
('dzUvcBuYDgh1PDSTXmItdVT250qUyMDN9rGYcPNO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVBUdXloVFI5STdqZEg5TVI0aUhSeUpzRUtlNUlWUXdIckFtaGpBUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542622),
('e8HtBj4Ql776KM0I9BCwowO9pigkaziLZuueWcjp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMFBmOGhYcWh0Y2ZTY3BIOVlObkMzMHRmWkhncmJ5UnZxTzhiRkd2WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548707),
('eA2opIy4ED7K9SmE0OPlRLL5SvwCQDN4yDetabGE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZWZtbjFiM2YxV1BJYVFDcXJha0hlb0RsZ213VW02ZnJjMFo0NDhZYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545375),
('Eb8pCTpNmCjREzdK7PdA42jiJqouCMMJhfNwB6Pp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUENlcVNLZHg0b1FYQkJEY0UxSExPTWM4WUplbEJhV2M5Vk00OVRXRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545467),
('eChQameOa4epVeY0c9sxppZBhUSAbxOfZe1Iu1kj', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZThHUlk1VFJITWNhcndmZ0prbXJkSzllU3BGTTRnTXozQlZJVW5nYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546423),
('EgAcwbETdW0MZNurxJ5qulIhy3cDMFWuXKAFdI0l', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicVdnZ2dhMkpoV0I0UmRBbHh5S1J6MGo1OHZUZ2xqb3N0R25FUVl2YiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550061),
('eIFKUuYrESvi150lfvlNrblrBM4E78zEvvg1TEkr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3VTMmZIbnFGSWJBdFlKQ3FJeDhlbWZhNWE2YWdNblNSMHZqYmEzYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549538),
('eio4BtqO770acgVBYxZEbLyuW3QmSnwmEiIIjb23', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGhoOEYzalJuRkcyaXczQUN1SGNidzk5T3c2VUJpVW5ZUG9RdkNwNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544110),
('EkD262nOKG0ib9RX0gW036nzvuNLWFfGAhdOZO1e', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkNNMDNvSGRSZzJLNFZFZFNYZkNYQk1NYjVTV3dRaTB2b2s5c2lsZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543706),
('EKNPpqThDE37XYOWzWs7RGVfbQRvLRKJOUbTmjIn', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGx2ZGpVUjFTczFGZzRmMk83QzU3SXpBT0xybzEyMlZpMTVINmRNOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545620),
('em6j78B2fuJmmPnFz0TZlPlW4ZI8AHYk4AvRUoHv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ1BRdzRjNXFkV3RHWEs5S0NJYjI0WXhaOTBuZE5vR2Myamt6WTZJayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546237),
('eobZw9WER8k3B5kLKYmLQgzrup1VjM8PaGjDmtjF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNDNnZzNseW9ENnNCTTRSdml2TWp3eFlhS3Y4TEttUHZEVkFWaVRjMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544727),
('EOIWPIMPV6lP62OegdNQMa5QOiX1NOQb26qn5ven', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVkwzbXMzZXRYZnJ4ZzJITlBwRXpFaDQ2bTE3bGJIUWI3bE9vR0dNViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546607),
('Er3kVghRn9dZbPu296bxOW5eoyGekkxrQAS7oZUU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieVAzQ1pCV0VLVVBMVjJKM1NRc0pMMm5CdnZTalgwdFBjMkRmem1XTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543240),
('EWjWAzNvu5Qx0y9vzP5ckYKH9HlG2LD4zunGy9Ok', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiODcwRUNLZ3V4MTZmaGM1SG85VEpOQ3dFUlJwMFRVTHNqc0c5TTJuWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548799),
('eX8uNDOMHZWLCFCo6agcs6IGH9wTSnFmvCdX6Vyv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjJsRUVRaTNNRXpaZmtGSXdVamJwazNSZWFucFBzZEF6SFJzQ3Y4MyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547564),
('eXrT18LNO6V7YM758HxoJMWWQvSLyGAIlpW4PT5Y', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEUzbW91MXBwQ1JFRWluR1dWbWNjdHZQY3hHZFZFUHJIRnNZNGRtMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547933),
('f0cUJKKz8zCKgHOrnqmeFqKkaNPNX7FgyX1eSHxN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWEk0bmJpRUk0ZGZ4UnFpZ1pRMmR5UWxwRG1rTGNHSDJlNHQ5VmlociI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546946),
('F9gW9TFQfDLN8QSbWpInjcL70ZpQ4HoiFIjuI7fY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWUhCN3g2SENrQ1V4eTNtVkZsaEQwZHVFV0JaMUU3UVo0THNoUm52TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548891),
('FbP00AOXeysC1HFjor9X6lUOCp0DrSNI4kwQbZZT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoianVaSVIyQWx3emo0YlpJS1JFYnhGc3dYdU5OSUEwTzhtRVU5dnlOUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547718),
('fdHExQOlezDyX8ryp5RdOPeWQMJOGiGYLq6WDeNK', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMG8xZVBwQnduYmthaGZabUxVSGVGaTJsM1AyVUFGVGN3VzUwVFg2TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546237),
('fDSUZ8QHLnQI6Qx0WhvRANGEyU3tftViFnnraSqf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUlV1UFdmWTdqc08wTjdUZGc5bEhmMDBKVm5QNElKdHl2SDVHR05rRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549630),
('FEJ8GgJXsvvbBB0qvOppS5gskNWIQT8ffwqY2Pfg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicGZVSTNIZmxtNGd6N2tMOUNCODBRdlQ1OWRMc2FRYXk2ZmNpTXhZYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543614),
('feyvNWXMNyWeQO1FJv7gVY8LeQNpEtXMhQHSxPIu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicWhtNTFKNjVRV0FnQ0xwVGhnMmJmSjRvQXNVQldtNzduRTB3cjdyTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547472),
('fhGqCy09leWy1G2iPXjWsmXYXSC3GhtmOygctUnb', 67, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoidnNWcUM5aDlHVW1IUldNUlRjNVB6YkZGRUJDa0c3TlphQml1U0hxViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvd2VhdGhlciI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Njc7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6ImJmYzM4NzJhNWU0MDIxN2IzMjZlNWU4YTJjNmI0MzBkZDJkOWMwMjE3YjJjM2VlZDQ1MGVlNzYwOTU4NzM0Y2QiO30=', 1795550017),
('FHRDLu3xDBBns6jCF2WGmzJg3IECZob10HB6F9q2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieXplQWJoU3BPQ1o3WDhFcjFEaFdDbUVDRVFmbHhUYWxXb2FoUmQ4NSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544388),
('fLfxP15OEZ0LobIQ4phVSyBImFNPUYE0WfUGkMNg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibVZxV2llaGtmN2dHbVVwT0N4NkxkSzRIUDhLOHd2dHhjN1FOY3JveiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548830),
('FonEeanvDDMTVEBcOzJRrbOxtJsDraMQ6dFmV7FW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibzh0dEFMa1N3NEtZalNUcjBxeDh0VWtFcENNdFE3SzI5ZUFONndYMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547688),
('Fpyn27LCaTNfSrBYSfEeHEORVsRMUAqhqDBkg7EL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlp1c2FvSEdEMHFKUTdRNWJuYjZWMnl5YUV1RjdqajhKU1JWVGI2bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548213),
('FWCSLjpV7AtD2J6eGwOnlC0gojy1jguMQWKhrlno', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZlFUd2ZBM3dHRXE5U3RiT3k2UUx5QUtoUGpiMFdLbk1OWk96NnkzbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546761),
('fwydhdiWvZBjhb7f6Z2BzovYMSI3zZvB4wh4KnsJ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZklwOXBMWmNsblhLUTVvUU9LcUc5eEZUTmNKcktPY3ZhRk5sMG1zRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548953),
('Fx14raTJerGEtrHMCsCqpjb8BBqzs61gOi6DePDM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoickxzZUNQS013N2FNSXJjOXM5MUtIMGlrQllQdUVFYmk5c1FQRTFNaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544511),
('fXR3zmO1YDSgVNEP8fH4CnCDAlOtW1CAc4ZxwmBf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVFVOekFjaHJXSEx0ZkpjSnFQaGpPMlA3YzJZbW1zR0xqYkF6REl4eCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545036),
('fyH07zRp7M6xIcGIUBS9oMACZLgOEjuvY5hOWY11', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZXBtYzQ1eGp4TjQwcG9VN0xBYUdmdXhzbWdJNnJaTXJCNHpXeVdxZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548243),
('fzhbOQV0afGc8DWtbYc2W1hNnpHh16DB0BfBqcIZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkZpR3l1SUVNdFA4MllKVzgzU2lTcGVRd0ZwZ1NUbzQ4bENYTnlPVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548212),
('GAJCNPfW3Vj6rX9kAtfaAVGGD0XauKrHJbNzuUI6', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmtBMGhsWWd3WXd3OE5EYU1kOHhrdzR6cEozZ3lJblB1aVBKNjVGUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547965),
('GEH3Gx3MOoqCNgKfP95M3iFifJ1qJoJX63xJmRgz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUg3UlYwREVTWm04VGczOWxkZldTY210MFJwU3ZhQmRYQ0xKaEdWVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545652),
('gg84StLGPkCj4ip2bvjEKZDqyJtm5yuJLrWq8F6E', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUFJV0NrdWpQSGtDVFg0SnlMT08yaFZMWGF4TWJDYU9HTE56dTVqOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548676),
('GiDnW4lOlZmfJQesQfuzdbrR5dFTfCYDHz0xWh7b', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibEdkeUp5S1RXWmRJOWw1QjJDa2o3OWtZdXpBenk5aEFhR0xid1NiYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546052),
('GJjZNhKfSMBNFfsxA9tLpUKR5P5NdShnbP4vqWsr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWU4U2hPMnZrWk1ob3B6T3NKdkZlQ0RJMTJTUU1HbVpkbTdtZDFjNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543209),
('GkhGB9yhknnWgWJs7keltpZ8j8VVbf5Z1EFxoTJs', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiODhvR2RhZU13d1d0cnFhUnlxYjZ2WTNMcjROTWlGUDlrb3pUYmM1ViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546730),
('GLEprkOeb9fxrH6Dl4G3fzBc70PjBvjXh8wobsCc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSVhpcks3QWV1Y0ZuanE4dzZWQjdRTzM1czJ0Y0VYcmdzcmJZWVd3aCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545344),
('gLXnMTo64KLaCIU3nYitlX3XwTV5C8mYNLeqxjh0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMnp1NWVpdXEwY1ZxSlRxclU1bDNQNnVVcU9BR09pNFkwWmozT2hSQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548492),
('GU7B8mM1m1dxMvwDV7t4cIr7SnNS1UsjQq8nf9Xi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibFc2MkpIWUJrczVJd0NGZFdERjFtaFg1VnB4ZEx5bXhWUm9LQzlvcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545374),
('gZHIvg4mNTqsQQPRcTrB0hOBqkwpubsyea7Gc4SF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQXRGZXNVSTRXRk9CZUFDTzk1TzFxVmlsclRpaDV6akRTNWVXbm5uNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549261),
('h1648ViM2lIw7Sk3VDuxuc8xLt4f49pVCXipyuUb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaGpHQmJMQzNlbjlxZktOMkN6dGhCM2pTVmg2NkhrN2VvRjlRYUlmaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546330),
('H3EcevOMUgsPB0aDwG1Tf3EY05bGnTJuQQmKmunv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieWllMkhOMENYOEZ3R05sNlAxQXVaUXUwSVU5WFhkVUV5cWZoMkdJTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550123),
('H70iS29P9idhcbMSyVAkJYXbc0MiLkSHGulo36Nc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFJLeEZNcmFQMndtOEhZeGlyYUM2cFl6SmNwMWVHbnc5TzhZWUVtYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547070),
('h7OLh9oNFLNVRYHG2fhNa9duaPTkHdbmBRvkiwmC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjF0ZmMwRTJxSGh1ZHpYcG1VcVdiYng4R0ZVVFg5a1FtMHhhbFJXVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545960),
('HaPNS7NPMPAQTKpNGvDZnlOuPpXFUNxsqIHTPcu9', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3FveTZ6b01EUEN3Q3pFVUxJYVpYbjczWTRIUlRhYUYyRjZubmV1dCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545806),
('hcrK15UO8BskHwAoEORjni79t2Hy5EFU3WaBQccc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0t0WmVXNzFwdzFFOHpWUzhMOE5jbk1xeVExNlNFQVpQOXVpQXlzSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548460),
('hDJTJAjNbstfTcRSbH587c0i5kE4yTqncPJw8Wvl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2N5SkhFR1dzcGtCR2RpOEcxdHgzaXRob0ZGeHRjU1ZqMzlrU1pOdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543519),
('Hefu0jWs4BUsbxTXAthK0XXaWj4A8X9IicsTV6II', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRTF2d050RkJxRW1ZUEs3T1VoWnFBejhQYU5KOXE0dnh2cVpiSzRSVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544820),
('HnSgSamQCXXg9Szl85iIPv2sbgbzyoqyoZr53c4x', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNjJWS0hYVmlQQXhVbEpNdkRSWDlNajlBZGZxdDNvUmp4ZHhvcDh4dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547069),
('HOlxvHoUKyBLWPRdf6vT67yYVeOlZwAeaXbIcy08', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3l4cHV1UjU3T2w3N2U5RWVpNkZCM2RsMkl6TWcxd05aR01MRlpWMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545129),
('hqV2rwljuGfEY6mhnjExg85W1libE92ylNWHEN05', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOGZrNWZmelNMQjVtZVBFeFExMldxekgwVVJ1Tzk5M3BuODFWbTdDeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549446),
('HvDUqYByGcKgZqp01UAhBVkRl2TJBqC3qXo5qzcQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3FlaFhwNVdBeXVlQm1rRnM4eWQ4RTdob0VrSzNPSXYzVnY4V1l4aiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548057),
('hzDgHqoLJxjmkozP1tVLgrAY1BIhqew9DpqbSyUn', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRTdEUEx1dkZTR0dJUjZBYTFNM25YYUtaWGN6YnlKYkwwaVJMN2N6WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547657),
('HZmomhvnkVtmu7Jp0ebBvpei9W6fu7gSHeeB0fBp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUnZHeDJxenhWNjhQb3htSThLTXdYSnptVjFjTVdBZEpaQmFpeGNEdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546977),
('I458MjlKdInbnwyJghV0KJ5sflK31qqnSyh7sHey', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWE1VZXE0elVmWDRWTlBKSkQwRWdiZkhuYnJHSFFaMzBGb2RxSFBJbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543956),
('I69hfPtyK7cNDzPPUW47XT3oAApVDd6kJ604ghyR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3FWdFdVbTdMNjdvc0I5dmU0TnhCWlNSYVBCTHM2OUVzSDBKTzlMWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549538),
('idjfnoSCFDS7mhz6iirCNvdE5SkyfGQT2ZUEDzsq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibm43N3ZlRFByTVJnVk16Y3dUNWhOQ01kMmw3dXF1dWdJMG9FNnZ6ViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545590),
('iDJHkZZ7DPOTkTSXeM379kHnG0GKZhDGiiucIPkq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMkhKTkpqNmhSNVBHRE9YNG1tcHBrRWNwU0dLTUdLS09lRk1VeE96eSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548398),
('IhCayyD2eakNCz3xmY7VvMVKXSJ1osijFKEJZUiB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMzZGQm5qZDRxWGd0Zm5PTGZrd0Y4OXlua0x5V09ibUxtWlBudXVlbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544419),
('IpVsdKyILMplgoFaKWuMiPgDGdWkRxg7BkM5nKYv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVmVHcmlDelJNNTU2VDljYW5IakFiWFNBSnpmeWxxcHpmUzlwNGcxRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544634),
('IPzcDkJzgNCRAlqIBQqW9gfXAylHBWqyiDMlVjhW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicHY0MEhlNkxyM09qTTI1QnVmcmFhWkJySDRzSEcyMjdOM09EVGhHayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542714),
('Iq6UJl6z068sgMGC1ozREtZTqVUdXMi5rQqWOt8C', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUVJQeHBsRXJYU3lxNnZzaXhWdFc3SWxtdU1weHQwcTVXWlNSWE1TUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548491),
('iQAGvemGGZQTaQVk3KjUgpWO3kyMaRMHK2cGe7Gp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHh5MHEwOGZ2SEJnVERhTlRDSzFUQ3FXbnlFWjVDSU0wMzJqd014RCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546976),
('irygMhb8Lf3ohK80ynGBmCEaTTzsgANiL2Gjv36K', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGpZc0V6OEo3YThubXJKYXhlMWIyT1N3RmZyN3pPNE9rdUtBV2Q1VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544480),
('isF52KKetHeYGJQcbDI2FTrtCHz8iarNAZVIODAz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVdwQVc5bHpiTG9seThaQmVvTHB1d21ETnh0VW5RSFpSekVIZGozcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547379),
('ItbaQZUEoF1DiXRMr0pQ5GAprXaaP4T5ZZcBiW6g', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTXY3cGx2ZkRkclNRUjlsWE1ONDIzZThaaFZoekdndE5TZG1SSGN2YSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546668),
('ithYFcgR1549BYmYRBax8EzdN0hXvpqYai0ZsUSZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaVVCQWZFQUJHRHdNVVA4ZHF3ejhrM2hHUzFBNzBZdExSNnFaVXVCUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549969),
('IX6E7M1CEyjeAGPCUcCJfO7pWJlyBNaYUJ6ZntJO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZmRudUFNYk9YS1h2ZVJ5YzJoY29QdVYxNXNWYUJxcVgxMnk2RUlGQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548984),
('IXh7Pnp37egzPW5AkiCrNlcTumlSci2r7purUy8e', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNmVkQk9xSTZZbXY3bG5XTjdWRHJJTzdXNU5FTFNYQVQzSURnWUlrOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546144),
('iYDt92tNrtbOnmP9UTJFEAFnRppizwJ8OKHp6q1H', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVm50NUpmR080ZzFTY2thSHduQnc1NzVTV0hKM1V4OVpNWVJWUjM1UiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546853),
('iyfXPk9NHwUMrIVW7TQd8ZnqF9BkwIIYQHol4sI2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOGtoclZ2NWhMZWlLQXl2a0pOcTJuVUJZVW5nVnhEZlhLTHFLbGxDViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545559),
('IyRPs8d8bpTCs31eG982Pq1EulvOVSSqSGURiUqR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidzRvQlBybVFIeHpkV29XTHVPQkNhVnZHZmpxMk1BQmtIeklqVEtreiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542653),
('izUbVOpwUmpUEA38vBm8SePAbPTRKBBZTkxZyUUi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3dLVjNwTk9UUGtEckZmWWtIdVkyNVYyZnRGeEprTTZkR1hHaGdrWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542870),
('j6ie0ghitWo4FbMdFoxl2IIlxEWJ04WQTPmYJ3Lp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRE1iWUE5d0d2UzhWVU1oZ3k2V1RuRFhTVDVMQkZ4RHBnZnl2Q1VEcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544449),
('j78lzOtF2W7vXqKKE7ROWZ5SS6XYqoksEpKFs003', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUVBhTEdkTjh4QWlmSFlaQzY3dWwwaUFWeERNeURqeXFkNExpSWtKbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542503),
('jaOuo8vODwiDWggy3GF2LmrqZE42R6TaR7iS81UB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRTMzeXp1TENrQlg1RzVma29QMHUyQ3FUU2h4dUFRWkpWMXZkN0gxQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549815),
('JbEPLjjDi3lAC13euaklUBAEq1FPWb7gAOt7zuvB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWRFSzdTajlmZk5SOEs4UGlXMFdEbE1HNGI0SkpaYWt3QnFLM0QyZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542653),
('jegFt1MAoU0Fe82kVzHMwrRmSPEC0GVQ1AAKpCRc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicnllV0Rhcnc3MmxWaUxjcDJLbllYNmoxUE5VZGtYeTJyMm1mcGtLRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548119),
('jf5YIAtYxMvwmgWjSzT3uDfvSGtGIcdweAjA3GE6', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZFZVUlhZVnZGek9zYk9RVDgzUmNQTThkUXlYYVdYSVlyQ3RjUzNvRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547687),
('JHqukqyo14MaKv6PHUNbqG7UDrb4KBrYbUR7Mqqi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnNtR0dBQVRQamRwb2U5MjI5d1dvaTVRdG1kSzRqcUdxSDlvcThUaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546637),
('Ji5FuwSfgNB4Fs6cDKRmxSL0dAOBeANChYAg4rVZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTERleTJVcEMxelI5QnllUkNGb2VKbkFpR29RWWxpZGM4N29LRWNTZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546175),
('jIrheoiEqgaAPNVCGTK72dafoNrENgUrN8Vephqj', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTjQzaDUwdG54REdrYzIwSklUVmszQmNJUERjbXpFN04xRWQ4b3JjeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545098),
('jKIlrKCEuIc10HxlXXVcIkjuySX1QtHbK3BN1hfo', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZm1PbUJUT0d1T29PcmJXZUJGd21BcDY3RDhwOGtFbDhlQ0EzaDBKdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548614),
('jkRdXznVy8mdp3fGLyoe1c2llof0FA7ws4FYZsRM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWTh5TVVIVlNsQjhTRWw2Ukd0MUtxOGphM1pxREwwNDVId0FzNVZsOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545683),
('jQ8Rx6BaRYfLLHiPt2m9GOHJSEzKtFl9JbmSWw8P', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVA2MzZqb0xjZVF3cnE5ZE1TU25Eamx0YlQ3SXZqZlh4dHNwUk5tcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545899),
('JRei1sPoGZ0NZgLqN1rU01ld8cWe73dlTFGL71JC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVJTOE94dVd3M0hYYW9TWEVnT0gwZEZ4SHBjYk1VZzdXd2ViaXg2dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546699),
('Js3AuZ4magu1Nj6rV9cNXacctjs2c3jPnnIusgm3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaWtWaVFpY0cxTmRTdzZvOHZMYUlKZnhkMjBSN3UxRWtzNXY4M1VNYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543271),
('jUctyUFJAkIgnCtIOeS0afGamjQFbffaogDF5MBa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN01UVWs5ejU2bEdBWktOUlhmdEl0Q2tRaW5lR1ZRUk9DUmUzQnlFQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549354),
('K1QyRrWpI3eGXzoifRwXPEdCmNZ2RVBj3BWJFlyP', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ0o3WWVGS3BqV2lMMkdJckZRUVBBVklWMHh1RmxseTlXWEVMb1RkUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543675),
('k3Ai28xtWqbzSbOn5dPjqm4oY8BMyRmGBsiFonww', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieVJIUTV2YU5VZGIwdmR2UmJuN3FIZ2RIeklZblJJSkkwNkpsT3g4NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548830),
('k6uH8Ra3V55zfFDjh6WlXCFw4Qz188rUxuyFw8Iv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSUdmbnk1RkdRdXloRFRxSXFjRUZIVDkwZ285MWNFaGZWNHRUdXgxdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549845),
('K8FjCqf3ne1a28mi7bhCXp4OtnpwAOB1lFIYgiPQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOXlDb1REUGFzT2dRT3FrZmtmd2ROaE14dkRUc0xjQlFNRmtUaFgyMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547995),
('KCfUjG31AI3iAXOvG2F3LMZNKWrQGRCg2wSFMEm2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieER6dTRIajhqZUtHZUQ1ZkM1ZXRlOGdnYUZDcGtBZ3NFV29neldxcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548922),
('KcKZJnC35CAGxWnebM1sSplpZi1JtPOFlktAvwh0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVd0QXc2SXdSdjNyOVZOZ0t2WW04eGlWRWpKMW9MMXB2NDZZSUYwViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544882),
('KfkmkSBZbgBQqGKkcAOi42Ow1VKhzK0VCTQpCiVa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicVdWaUsweDBjMG5Rd25jc3J2d1NoQ1Uxbm10Z1dROEJQaHBndGg1WCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549323),
('KGiRBMqPsa9Cf4aex0mI58tUrq5M9J8U8eIhproj', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSGVQSkFSZTRQbU9haU5sTXQ5VnBLcEY4d3JhbURERjZNTlFzOENxeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547872),
('kkXabOprU983PFJXiObbfBgICKjOARdwMfiYLOAE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicnFnMFB0ZXEwWmlFTWxtQlV6cFlSV3hXU2E2ajFTVU1pdzVUVlF4WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545344),
('kmmyMzjyN2UPXvtxgFiaMPWfvmjFtk7gKHtcz9y4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmtVcUR3TlNGYVhoWWxDTU1iQWVaV3YxM2kxb2tmNlpnTUsxUWpPQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546453),
('kNrFG3AR0xuar79qLT6FIxLmz0N1z8IKGVw2pu1r', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVzdnbWs5ZzgyRmdQRmNhZEtmQnd2bHZ5dkZQSnBpVUpkMEJabGprZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546884),
('kOx4D7njgXwsYIaRG3zvMkUhRrsdHXVzjncNheTi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOHM3c085QU9rQVZmb1BVYldNMVBLcHB1WlFTUURNY1ZuZTF6MDlTYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547008),
('KwTtkoAqlK0Ej42tEgieFWh2oCLCHFs2xjJeQx0s', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVlYUUwzSlFicHRzbzJLQ3lMSm84cHJ2cjVZUVlJaVR0ZDk4NGREZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547656),
('KwXXVCJO7EweKSjvXNJZCPvgTmpNmtX3ZZQRCa7t', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVTZzRWZ4NlpLVXR6ZlIzajRDQUdheUxiTkh5dHJWbDdCSTlhVGhGcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545960),
('KxHBaKN9UBOcOduvcTJcqhB6A99X9CkLPv0lmBz6', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWkxFdzhoWGZhakM5eHptUlFIOWVMWlc5bkxTVEtxUXFPaVJvU0RpZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546144),
('L8JF05Ga7EviNenwRcF6SxYNc66B5DHv7oQFMXaP', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZHI3eEJWc0V2YVpGMHptRUZwV0NnYUZXN2l0a0lrZFhWRG1GbXNDZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548336),
('l8RfIMJH5uC6z5llq8gjk7FdUOCQY8Jmwyo2iypk', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic3d6YnlOMnlxUE5WcWprRU15b1JUaVFzbDU1TEc2OHY0d1RHTHkwdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549231),
('lbDrFFFXzj2JF5aKNTJcB3cOHJkQRVZueS2H2TrJ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTTN3cjJKbExWTFdhZ3gzb0N4dWs2UnhnOFh5TUdqbER4Q2MzTXNVaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548057),
('lIC4GUfgunjoH8fdpg5IYiyL5W92tjiOByBtk2Ou', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZzdYU0Z2c2JBNnNuclZWZ1I5VjFiWnE3TXZHczZKQXVrWnQzemNnWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546792),
('lko35Jy7Inimu4ZSRbAgDKp9lsbhMSn8uD2dWf0S', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOWVwM3lLcHM5M2NlemhXN3lYZVQxUlo5RjBDN3pIVXEzVGtSdWlzMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545837);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('Lom3dO2fULje0yCgTRv5vH7zAr3FwaoKn8Gz834m', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTZOaTBDd1F5YjhOQ0lmRnVON0gzYVJXN0lZZVdxQzBqNlEwYktsRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543768),
('lRl4yu9oqn6aQMZQG0OoW68grnpSTbiJVFxELmB1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicTlGQlJKSFl2WUxwcWJhbTJzQXhJaVdlWTBZWEZxbUo5THZGbTAwSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544480),
('lSrMt01SLgs9KAZ2WoeycUdoDb4ti80srWFacMzv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnl4d3ljOVdmbjljaTJKZmEyMGxLN29XaEJjZjhMdnlGT01UOGVkdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546914),
('LuBKj749WY8Nz1TnZZ9lBYzgaBjVoqYXJIvjBx12', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiclYyRXhIOThPVWpCZ3Z2TnhlNmRmaHpLaGdlUEgySnptUjMzbFFUOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544697),
('lxxI35BWlfiYX5yrOEmmrcTEbaA0eUGxSA5Oi25I', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOUdRcGttVU5kNHI2dVkyTHltN1JTbURTbEFFN09YMXNjR3FReFA0NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550154),
('M052Xtc3ChWu9LYkTkQQuRLdCvfeFrGF42peiRX4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjhRbDg5U0pmaUVKM2tncU9sRXVTaWZlcERBOEVscHN2U2p2WjBHMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546545),
('M0FNwczUjUQXOVB6bDwnL9T92jsfoAUaPCqiClkB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaU1ZUGRsdjZmWERhbWI3aVE2VW9tU05taGdKSW12MHYwc0hIU21BcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544541),
('M6O4HXiUrMPNOpxKcAHFyODh5WhEDYXmhXv3omw4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiU0hZa1R2QnpXS1k5SE5QOVJ1TXpXaHVnUnhBWnRNeWlRTTVocVk4UiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550092),
('m6uga42OOO3N6ZRCPiqKHF4kOKxITsAqKtVG5Gf7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVEFtZmU4Y2tTTVc5bWxDUzU4cEtNZjdOTzhzYWp0ZzR1WEo5TUFsMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544943),
('mAZSMHkl5vUbFaWfryQTX3u5j4iWqo98qfUOcfS0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibnczMHdoS2h4R0gzRlNnb1A5YmZTdVpPeGJETDF4S1NITjlrcWo0MCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542931),
('mDc3pTmiKvMzZACMWmP84Mv5nl1g3UXWBUu1YXti', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEExbWt6dGx4eWJ3eTRJenNBZ29yVmloWHYxaEd5M0JHMURGdW5rVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545129),
('MIRgUg4wC8psBlWb76Q9YXzopXhP3x7nziD3fwoA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUtyN1dLZkxBTTVITFhad3lUVlA2QUgzVVd0ZWt2VXFvbTVtdnFWQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549784),
('mJxHECDsauivqrHSh8IkPCsrLIyVMjlyTaYzZ26l', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTWo2dE84UGNPTGUwZHFZUHpaT1NiOGhzRE82ZjRmUnN0dzRCdFNvQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543894),
('ML8YO0fa06xrsLXHIN4GW84YaFwY0K2OfYUGCYNM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidUN0enpVbXpvUGYxOU5vZHpFRkRyVjNaTW9HOWV5RG1TRzZwcUx1SCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544759),
('mn4xTm0y4c0qjNM4udqEolag4Z6rqTo1L2nGlewD', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0hFQXphVGFqbWJrM1lyYUNqY2hlM1oyZWtjVE5EUjloTFlzSjMwTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546300),
('MnYZbYxR2uDiMg0fFYTENqORNJMFDVrbTv47lspG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQkpCNTdzN25CYnM0MTh0RjdLRGQ1RnhHdU5YNmpKR3FnaGJTQU1RdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548244),
('MRL76QphyH7pVVfSoFyaNz1DoQORrKzmZDKjSHMV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ0hUb1d5cmlsZjVnUlhrUmpXMmFMclNWbDFDd3RHbUN4QkI2dnU0NiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546392),
('MuXKiLSLQygfJtCC9Otvjzrkj9RlqxTNvGCNopKL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMmJQTUFHZUZWTkhSVW9tSnM4MVlSZGo2VFNZTTJDNG9kdTY5TG9OaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545929),
('MUZDClKv8lglosedZzcJHyC8C4hkAVrTl5hfZ3w1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidG1McjYxU2daN2dEcThGQXpMWWlub1hNWXZzbEhYSzRHdHhlM0p2VyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549876),
('MWlxqAtrPOLAY0e5IxH7QsyYAG9DRppOWmHp0YTf', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaXhLcHhvZmpYa291TWJrRzNKMDVQQWJYazY1ZTRrUmYwbHFrM0dpOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545313),
('n1QeybF6UtQfS9YcgbSsN5SBsqbtIvPFqIahRDqH', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHFEeVpsUHU4S1NYTHJJeFJVMUxKUjFZdlg3c0FIS0VyZXNQem1rdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546391),
('n7u2GDS37hvf5JEPQmKucGJYkzi9UuP0CbQdqBo9', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHJ4Z3Q0bHpreFFTemJGRjJKdXJCUTFsSEhTWWJoQU1wNnlXSkFsZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549076),
('n8jkDsysquxZDlDndCBBqkmrcH03oEz6v226Grrh', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2MxMGNYYVk0T204bW82U3F2c3pxWkwyOGl6WjladFdEZ2RPa0RMNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548368),
('nAyjWUWa450gdBwq3R8mYGSzDoRNnuK2CQdLYqLV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiam1Jb0pHUXhhZ1hsZkhHN2piRzhJZ1pnZldFWFhtUUpxOWlsQ0t2TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544357),
('NB9hkWZMAKVVtaZBw4kwI8Fv3bfXVqqSfkVSDffB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3FtaDZBYlJLNnpUZXdBaFRGMHU4RFF3WGtCSktxYkJVeGpMdjJXSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542529),
('nbuIThWOwjvo1HngheVW0aZIGaGMcBKnUcvzCRIs', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkZ4RzFwZGcyTFRKbVVpd2g0aEhBbTlzSzRtYkdXdkl5U09rTjluVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549815),
('nEznXMvrL2gUZAi6aVjgqdQ78AqcCC7PZgeWbd6b', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUkxvenc1UG55bDlDYWtZOE5SeVNFU1BXZFZRdVkxc2RyQzJ3RGhFcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548522),
('nFnps2OdxOG7GcSxarvcHg7QzyK2MZiDXZKXZcmj', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRmFRYzBISHlES3FMajJyaUxRT0kwT2s3cTBlUjFIdXUzOHhGS25GbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549384),
('ngFGucWp9ESZ5ifuQ9J2IXkIHSr1oGjRPdPXcUho', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicHhQWUgxWGxCVG9Lb3BBN1VWVEJLbjNGc2I5OHc4cUxhQW5FN2xpSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546545),
('nGPp1Zu2orhQcJ4CRMGgvPXDp2Nw1k3OlMSy7PRU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNldOWkZMdWh5TEMyM01jRHh5eW9iREZLQXBORUFMMWxVRXplcU5ycSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543862),
('nHE93X4lC02ECh5KuIpHxq3nOHDFIDzV7FLnQwWZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMzF1MU00WDViUGhybDFobnlVaGhhVThYbXJ4V0xaQ2Nia0pNNWRJUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544912),
('nHnITphwqllcIxcjsEWXNwehydBEij1mq3HnBntB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibVdsb0MzNlFwZGhiNXJkZXB4OGxVaGw2YU1WdHd0TEw5OHFaNEg0NSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546669),
('NI0Mn3eZAmaf0je3qMlBd1Z9wHPvTl9xGxSMpYtL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid1FaQmZyR1c4dnl2RFZ4S3Z0Sk1wMWNFa3RGTDJ2bmFYUHdGdFFUYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545682),
('niPuwzdL44CO4RJ0nHhdXbLnMbvciSAnE5Wy7Jti', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYjlGZUJuZlAzbGN1OERjTkJBdmhxMzVBYVVKblNzQzg3a1BRcGI0VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544449),
('NKK4TPsChuxh01PcMB1bjCuvscFbehmWYTvC2Drn', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTFyRlZJR3lQdE0yYmc3a1RuMGlURm1lQ2pRQ25TV2FyMDlGU1RCdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543862),
('nPnICLVnf9vaCSKR7Jyqvgper0hYZKc3l0KSLzit', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidHhjMHk3bldHdWFLYmlrRElKSmdDdDN3aTk0SGU3TGRFRWQxYm42UiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543117),
('NPYPMoxZqBYFFbXZBuJhp6qfLFLkcN7aZajITW9E', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRjNubURDcGtqUDY0MWV3eklTenFXMThxdTJxZmdLR0xieVN2RmJLNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548584),
('NZeXkkrAKwe4LFzk9UhOGrIQvYhDoHL9IcjcjtAB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTY3bkw1VmtuWU5jSWdjNzcySFRQeXEyQ0ZmRXp1U1FDamlycHlDbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549014),
('O7Mse6t0z5p9N1r2ltpRJjCkWoQZvrEnrtgx0fcx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnB5c2YwQzdtUnlPVkRIQVJ6VURHTlF4b0hIU1o0T3lXQ0taS3AxTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543426),
('Ocx5feuE1N9W2PL77ye8AGz5tvwWEL8vAxf4H6oa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicGwzS0dIZGNNZFJJdWx2YUNvZHVKMzRxczNQTHNGOE1ST3FzMnU4ZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548461),
('OGmlaPV2DHMqHL2Zy1tYaKImJYT9h2Lgu2q5NVfS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGtmZEc5dTgzSDZDNXU1bUxhdzdwWDQwT2NNYjR6dWgwR3AyU2xXSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543488),
('oI8LwTtiIN28SuanpgkoHFL43GQjV5tR4B3NBra7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnVCd2JOaGRaaEl1VWk1Zms4RjJDa0F5R1RTNVBacjJJVHRhSTEzRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543395),
('OJbO8QP1lfYt3PXmcjW4TQFXF9e0mx1g9tFJCSQF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWhoY0pPZTdsY2p6SnpsU1FOM2VrNjA3SVFWbzduckR0R2NzNGhpSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544233),
('oKLeLwsweSHFAx6DHlE6DTX5RO7Jg1My30b6KkPi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUmU4SjBSZ3NCMGJvTGJmNE9GcGtZdkU3a0FPb0pVeGd4VGpGa2ZFcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547872),
('omc8g7A63OQAdyPhCpw8YTHUo3lxTeNI6okkyYl3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaHlhNTREOVhieFBzM2dPcENWbkJBdVpHQ01WYkFIejloSlRwTUJjTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547441),
('OOX1SS6L490kT2g2tiTgIeLTMqE0ba9BxAihRaHu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkhsRllVbFd0Yk0ya2hpdWxZc09IWUREZFFDTEVIY3AwcHRrYjFETiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543768),
('OPSh5nHHRh8vPl0EfH9XvRszUokbVV3oCvZTUYXH', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnJrU0pNT1g5bmMwcXFIU2MzdUhMZW5mRU03cFpaYmJGaXBxQW82biI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543893),
('orEx4RzkUE4XcfZE75jTeXwWDbdX65V6rcmLZtNR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmtpVXdjZkZkUlVQaHliVWxqRDBzMzdlcDdtWk5rNUIxU3ZrdEwyVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547626),
('oVp08wYNwTWoMlG5csx1JRFZWYHUJRr8abBsGraJ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVGYyTDFmdUFXNm9wRDlOT3YyTWU1NU81Nm92RFhDa2VDR1ZxU0tCdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548151),
('OVzvk2OdjLDni3t9102C8mYzNskyp8aWeVNOTeL3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTzV4OWVxRDRTVEhkelk3ZlVueVlCdzQ0cmw5aU5FUWxPSkFOemRxWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547193),
('ow39mgc8RawwK1Z9qeg037VyhiT9zdt1cgpxMnnR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiakNFcklkUmF5bUFYeGtOQU0yT3A5OWhLNW84RWtqRlJxWlVUck5HaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543645),
('oxiWEjpZazPvQlp3r2tffybY2hhEijNwsy9UU6DY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidzFFSHdPNmg1QnA5MzlwZzVYeDIzMEQ5ZkdZRzVQUEdlTmpmWm1IbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547779),
('ozp6xSnYNY0UrmYO3PCAUrfibGS0mx6xQerkB1aE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiU3hoMVlnZWdWcmd5VFNrcmtmd3h2cHhnNHh0WUoxcmJEUEF6M3VrMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545868),
('P54DyQCGU0lGXouJzIrhguYw3RHIEXcPVnEyICWw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGg1YW9xVkhEWHlpMmtsSFhRa3RyVXR2Y2tJWDdvdkQ4R096TDBkZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543302),
('p5SCRVnQ5dLL4z3stzgrs9LyyLjAQBfT1ZSrtSOG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYlltd2x6QTQ2Q1BmSlBRdjdCams3a0lGWDE5ZElFbUZtMGdsQXJvUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544974),
('p7ddnJ1svINKSXRNIqsxiJiLN3oQYd5IxeRUSYAw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmlITThoR3lKdU1UUkpXdGlJNkJlekgxdmdlV0NiUmhlbUljNk9CMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545837),
('P8P3UM5CcNFOWHNLGcTkOJbaLZ5Fjpieo4YoonsE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0x2OGlROWtlT2FYa3kyQ1ZMb0g5RG4waHE3dVdBd3NUY1NsSzRFNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543426),
('pMwrlzBDLYsaq9gLhjMGFIXQ57f7owI69Zfb2sw2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTmdsSDJVOFNxRFdPTUJuUDdwVUVCNGpvZ1hYWUk1RU9teVd2bGFpOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546361),
('pt9JthlWiLNtetkFp2WTpoRo6gui2bto8zXwXshk', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjRGQUtrZWg2WUxsZUhhZVZrNlVNalRHNkVhc0hRd0JOcmRJemRoMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545991),
('PuAeQ49eL47J3Hq147RuBaQjX9M0yfYRkWRK4DMC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUFyRVpsZnNMN0IzSmhZdFFJeHB1YldxbkU0WWZ2cXNZYjVUeTJ1TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545221),
('Px75EhV6j3T18BfzXu15PIosUV6LJ1XLJFruH45N', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYk9tWlowUEVVTENBWHdzZ1RlUDg4TjNVNDVhMmtsd3Zkd3pZZWJGVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546361),
('q45Z0sNcemF2VYFn6xjQSHu6s7caV8PTH0fJ6TFb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNW54c2tLYXN1NVAzM3Nsd0I5Wlg2ZFFqSHl6M2U4Y3lGY1FnWkt0bSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547964),
('Q6DfJAXY4KRNYQcsiPMcKHxArkzts8izDBKhLcPr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2JnN0daNXo5aHhKQmhnTzJiOVhJMWdGSXdJZzI3TGlISnV6RVBDVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549999),
('q7fqA8iwpWQUB1j3duAIJ6OQBeoY8s6MwTTvDGHt', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidnVhWXl3MldFdkg1NlpSS0tKbWRVZmZ4SmtXMHplM1lXMm1rTmV1TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545436),
('QBIjrFYje8TPq1oP6ANfKsyQ9UKm3hcxJMHynFDl', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiU2t2TGludVZQY1QzNm91QmhaUzYzMG9aRVk4NVlzUVFpVUNGdUFzdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvd2VhdGhlciI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTA7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6Ijg5ZDEzYTg1YTY2YTc5NTkxMmUyOGZkN2QzYWI2Y2JiYWM2OTUyNGFmMWU0OTE4NWNmOTA5ZTkxMTc4NzU1MGQiO30=', 1795550004),
('QdlR2NdmJiuR3PlRDaNaSJwHge2IzS0ykHlBO5YM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZEdYa0dMdWU2MWRVZDQzcTIzZE9EWENBMDlJZnpYaXk1VWdvTXVpUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544017),
('qh6gUulKOTQQhf2HEWf63T5DPQ0zngzo5Lfxotqj', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTExLMWVTV2hSMDJCRUFyTTRlYlZ4c1laa1ZOSjZub1hHSnpiWFlsQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549076),
('qhLJSMvzBnhda3eAfi2y6zEX0pGpikAeaqgsdUFq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSVZsdVNFV0pOaGtzVHVsWVBRNU1KMzdxaW5yVmM4Nm9SM2RZZkFFdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542746),
('QJw0Pmp9Z68YCHSIyp2JdfeXbROjn0cNDVHXpNNA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMkZUTjNZcnpnNXF5TjZPZGN4bjRDZExvTEpHSmhiSk4yMld5M0hrNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549569),
('qjwW7O7mvmdmRVIW092kGrkxk70ht97YOWwyGYqF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVk5GUnNWVTBSYm8yQUJ2bmU1cVYzbUlzR1RSVFBwNEp5THJXZGNVRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548707),
('QLepYUvSsjfeG9OjSbW5mzdQxSjvw9TwzEfjsaQS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUDdyWm94SDZ0R1RJNnFqcmhQdmM5V0YxdnNZb3UycWlVS3hDVHJiOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542962),
('qTqvSSU1cBl4LJwD4vrVxpjyisaJAYUdWMdCLcFL', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRFJBd2RCekZrVkxEUVBoQ21DVkxWZ2hENVhCRHc2ZXZsUWg4c2RFVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549292),
('quaW4cknBS2p8iMWDlHBoiOIy4FgIMuEvM7qZDca', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWFSSEg3b1RGQTJ4VWxTcUE0d21HeEJCcjNzbmI4UUsyak5UQmNEeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548615),
('quoTTXn2fjmC8Y1qp8ta5cZnl5vAw2LufrLffPmA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0xQU0FORlMzbEZkMDNvU2l6bzdJVGdzUVpzY21BYjZEMnYzMjNacyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549630),
('QxaMzeh3hIGmIhaf3Vh6uWNYm6C4HgtUvGSEPSO7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHo3Ung2dm1valdEQmZIZjJyc1BkYmhjVkN1dFBNU292TXdMUzlEQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542993),
('QZnNIbyrn9RTATejllq8PW3zFUOpxLJ0SMI8nqtc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYkJET3VKTzNnaEN4WDJEN2RDUEswYTBoeDVIcVI5alA4UkhUbHJtUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549045),
('R1uCERwGUvS1IXHwG92bxAjFkWOC13DSADB5EKML', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSGhYbWNNUVBIRkVCWlozVm9mNDFhRkNjbTJTTVhUOWY0Zkc5VXdTdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546699),
('r2GOCV4Lp6Vtv4iM8qLkuEy16S5p4HeDu9eoi4Qr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3JrbXdsUE9Eb3g5Q0UyNUlYQkk4Y3d0bm00aDUxRUhnMHlzMnVrVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543613),
('r8HTat0sE76y70gRl06NzTsY6BAtw2U1Vh5vogfO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT0ZabXJIUEpNNjdlSFNvZGtuT2xRdk53Ukh2ZkVKYTVuSmZ5MVkwUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549477),
('rAPEhyDNT33lAwJcwK6cK9K7gXWd7udOc0eMfXZ4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS1FEZEp4Vm1QY3RucnlqRzFOQlZtbUFQdEQ5VUsyR0I1NVpGaVRGMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547101),
('rebgnOmPtQz2uuqC7gaCN7RCtZCgqK8LUxBA9nYX', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN25DOTBraGhMT1RSbEI0Tjl5OHFWY1F2OHBnd0NjVjU0UUZsQ2owaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548026),
('rhIyplytg9oCp0YrzIVlDl6i7kguqUmXXM6QCNCO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVZhOXZWdVVDNG5mc2tDNThCR1pyVmFuMzBvemJETEloQjl2bWNjcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547193),
('rJHMa51M2WIy24M4k24K1522lSFOLbdewae17g7s', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoielByYnZJMDFJSGcyR3I2UXQ3UEo0OTBLYmhPMVdmeEtmY3FHSGhHYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542869),
('RNJ39J0qLEv5BsI98QDwp4jpnFNGtSJbRde2MduB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRXJDWFRBdGcyamRra2lnd1FTdXZmemx6d1dVaGRUa2k2VEZSanFXeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544604),
('RPimjYQOjgTrsOD4cat8pwkDSMWYIJFsoDOtdLf0', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic05BR0lUeFljZ0o2OWZVSjIwVlltRFB5SENVaFRYY2t0c0NQTDRNMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544048),
('rvDS9VEAA30MTOo5GFVmAzIVgIG5KRmaAHBYGPPH', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicmRIR3ZLU2NpdEJaQ2x3YW52djR2dnprVjFMTHRxaWlDRGpTRWR0ZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549661),
('RwJ7vtJACzA6xMHj9BrkFNleuQGiu58V0wtxDlAN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0VENm1rNm1xek1qaWVqZXZDV21HalRHV0pGWjhZQnBJaXhLYXlHZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545775),
('SBcYsRREVEx8R3iNcwKj3HtjUohyJU6dhcKmVMG3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZFhRVnAxb3pJUTJUZXRuN1pSVjl4NGJ4ZHh6YjRpcmVDMFFETVZZSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549568),
('SBDXndpeqBGQUzDPbLd3CwZDDpPzrcGmFMAQyEsq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidnpkRW9KRk9PeW5Ldmd6QndyMkdVd1kzTVk1R1ZNREs5WHlGM1dsWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546299),
('sbOoqezxGCDJ7CRCWex62BgHFw6E4o6dmqiXp5lm', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYXdaY1hrVXUwUnU0Q1l3Umt2bmtIQUtaWVJLaTBUa284S3hHUzdBWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549384),
('SepBu9rAredDYBRmKa0MOgcbNMJZXTuifmpo4JTb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUkpnRFNnRWpaOEFsWDRaalZhYllrYk9xd09VRHIxMVBLV1VuVDJSTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543178),
('SEqKjZzllr2whN52jqcSArMOJDx4qlO9gFsQBOh5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVhIUFJ1TzE2YnBoMERjeXhDT2w0MTdNQVBGWWhjaVJ5ek1TWVI2MSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547286),
('SIeHcIhIW9VZ7FKf9az8EsyUWtu7EMRjrvkGeqCd', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWjVHdVNYQnJoTE4yNFk3TDRBZXFUYkVnenlWQWwyYThNYmRvZEZXdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547317),
('sjAFxvWsVqIrmwttl3WVmE5nIx9CS0r8LKmuVttZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRGE3R2VnQWVFSXZXTmpzQWlQTXhETU5vYlZYS084d2YzNUlKT0hUdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544851),
('SJAHxHsDCfNuDZsgkdPsKhTnxENXUFPhrbAccZnK', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRHIwMFhoQXdZdlFhWU5sSUg3aGxrYjNqTnEwN2lONEhmQktVZEx6dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543675),
('sLxBeCl3laepqsaVAVRu5tZLtd8Ky7RjZ8kpL9Ym', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaVVXanNIUkM4dmZHTENveGFkYVNSUjN4Umc1bVlmTVRlc3ZFbFQ1UiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545652),
('sM7qTgjCD5ewRWlNma8FZeN264EH2iIHFtBvhSXD', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicGFYUVc4ZjZ3eFZqdkJDSFdnWEJ1MTZWWVpCVGxHVHVHQzRSZllNTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549168),
('smFewgeQczwpvYVjuod2prXCHIC7P1rOQogO5lfY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2hFVnNTSDdKSGZqMmNTdnBSNzl0U1dCTG53b2tQcHZVdVB3enJNMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548120),
('snNiB6eoztHiRH9Z9JarB1Z5VvjppEXEAQWS109V', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOUVZSmFrQTR0WEJ5QmNrZG9mWDdUSGxRSXhCcjhjT1BQSXU5SW14MCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545559),
('SowZyx4rphegkA6PIoy59b6DdafmYJz4waX9LsR5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWp5UFREeTFwZXowTUJObXVESVZrR3l2a2lRajhpbTJyazlWSG85NyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550154),
('spBzvoBXAOQwGlvsCsy6iGHeNcR4ka4VwLljLDoi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGduckdOYm82U3lWN0tzbTNVYmk0TVBCTXh3UWlPZHdXeVRpRUNrYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548800),
('ss6J8zyVtQeYPvSM9xl9pmlOim0m4DeNAUde5mEB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibnVENWdKekFLemV1V0RES3NVV2tHeEN2S1RGSE81eGVrWkNCdnRxSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546422),
('stU32dEzb8iYA1BDqxKDHcC4bnPQVY84prWLGWSE', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMmE5UkRhNGVTOTh2MFpMUlAxZ3Q4cXhuZGRYSG55V2l4SnpZWFJmRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549230),
('Sv1Xh0m5WcQ01Of0crW7DyJHQoLx7W6JWwUXrtLa', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUVVDbE54cGFEbEhZTUJDQjczeWZidmRzMzNYbUxYa09XMktZRnpSbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545160),
('sWxMTktDfjWTUiUjxgqChIwCHBjDtBgDtdWJyVyI', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMXJIOXZvd1VkTlVIeVd4UGllWGwwRWM2M2lBalF2T1JaZGpLanRpZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549045),
('SZyZJppMQCZJT741Cgi6jFxH2c6Rd3XfNklHxicM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYnQ0NHFlQnIybUlmZTZPWkRjZTlPMk1vR0lBNWxoMXRCUTYyc0o3ZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548274),
('t2gRImixxayu7J62ZKiaTTOEw7K0u59ZpqX2oEKM', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieFlnblA3Q1BadDJXWk9XbjJiaGNNY2w3YVRnNHFhS1VoM2t5Zm90VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543799),
('t2y89YMuYkqWGPtHj73UkoYYCg9ZWegZygayfba8', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOWZ4MEpuOUM4ZnczcHB3N25NUUtHNDhCaWdYR25YUkR0TXN2T1k5WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543925),
('T3q1i1cCQMwSDfoeeHfLGj07Gxl9rbELSXG98P2K', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiczVkZEVqc0JsOXNOZU5qNnpKRDNQd2F3S2NHNUlOd0IxODlYaU1UOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544234),
('T4FjDGUTczGFhjFXEYJTsXgPAepzpddKpkKp59iO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQXczNnNHa3Y0QU55OW1BcFI1Z3U4akxaZmM2THBtamcxZ1NaZnE4RSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547626),
('t7D6aJr1ZbmbkzlQw3S7BZ78A8J3xAd4fb2vV5qz', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUE1NzBhQnAxdlJwOXZiRXdqVGZYSEpjMUpweGo0aGlaUXRmeHRvVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547317),
('TAKKY9ErIv5TCiHTTbo68a6mbTdi8pP0HTg84Fzd', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQzhmRlhEZ0s1N3hka1RnbkdZOFdlVXkzN2FJMTJqbFByZnBnSzhhRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543831),
('tfP3xZ6yzJJqeWw3BJGON7vUIsmZL8eh0uDdOzXF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUJadjZyQjRGdERHY3dvNFB6UjJCbzJ1QXZwWHpHNlduRW03NVFBUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542684),
('TI6q5E7RLjQCUo38ZdVukuMtbQPomX461CPVFjNi', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlJtalhwOEhoUzlVS1BOeDl2Y05idlBFdFFva2ZRNkMzdmFtSEJvcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543147),
('tI731oqO9aAz6exhmRhaxMDwMlwdQes3PksqNggF', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0xqaTEyR2lwVEx1dDFURVlES29seHhSc3BPN3d0VktMQXB1eXVUZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549415),
('tK8NsYcT72yA20ynILcGQV8l4NwDkgkJrCVybe72', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3lxZWhqQjV6Q3RsVGtlVDBGT21Ndkl3cnIxVE5GNU5kb3Q1eVNEZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544604),
('TohGpWyumDsTbhaGXSqREPMMrtColA1eHh49X0F8', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGlyb2F0YjNKbE1uTHdUemp6SXJqUUhjMGlUN0dpd3RJNzBNa2ZjbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545528),
('tpF0dDwA5D669y4bDFiu2v0cdBKxOiXutsF35BOr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSGozRUVISUxiM2xXZEtzT2lKQTl6dEJwUkJwalM5U0UxN2lNTG5BdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548367),
('tqA17CoyMTIsOmMDLf7dNbVyW64N7ragbCq1nlbr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUR2V2pJd2ZpMXI5bDg4SEQ0U1hxYXJEOEdGMHNKZnFLRWxFVktDSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547100),
('tQglDimOhYrfJvyh2drTjTgPeEDvfJGcIidPrTZx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidFZvYWNhZFhwY3RvaFd0VVFvMFVrN3VNM28zWFZYMmdvTDZ3RGI2WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550185),
('TVhBfeRspt3hmCLg2yDTY1p1ADz5DFyFodYdHD2J', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTEFHd2s2QkpscUI4MEtRa01wVjc3NlZwdFc1R3lnQWNtQUJ6NXpkaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543395),
('tVRXKqb2xJS5tbGMT8MYR40oolh2at0RTsNMmA06', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaDQ3ZzY2S3BacHZobDJ2OW1ORjJlekxSb0xVUXc5RHVLalVuZGttUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545190),
('TWEpzJ9t23ZfKcr8dtj3A2absLeaJwvOFdOuMuH7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGN3dVJNaVFBenBOSVh6U0xpY2Mwcm1RU1AwOEVQQTk0S2RST3NGdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544913),
('TyatUzJOivtbWCQupe19on8Uq41qRnClMAsEtgBQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzRyWHhDOWdya1BCa0VONmJZV2swNnFSdGxtMXV0T0xLc1RNbnNVbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545497),
('U0zzYmohbiSVrgzGBVMAItKBmJyMyASJp6q59Wsh', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibkhDaVo4bHZ3bHdZc2F5VERQZ1lPY0xwTFRpV09DaXFCYVZYSVMzRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547131),
('u6jVn7R3p9mZhtH0IwZOPaGOqLaMol3RVQ7hQcdD', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGZoc01lZVp4WTZBU0Q5Y2RCdThRM2hOd0doU2hvV2JCZlhNT0pjNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545436),
('u8A6zd29lw5Njtyx7kn0WooLYlClvlUBafKI8YbZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGdIbE80TXZqZ1BNME5RblV6V3ZBQ3dCNHdOTEo1UWRQUjFRTFFORCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549784),
('UAGLv52c3GRd1ze6UMaelSyYM7ILvCR2r1mO1UTT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRlNHa3dyZlBGY2RRUVNHblJacFpiTm55UVVFdUFJUU5DaUhiT2s3MCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543147),
('uBKHOUVSeJznJOsXIMzIFzpV7XBZhEUKCVEhVesO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQU1lZnFCNnB3ajM2c2dBUVpsaWJIR1liTkpLZ0tCYkZGNGZPcDlGUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549907),
('UdKVo5PJUuH3bndzP5D3RdLksZPocSnJf1VK7yf1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWUREamMydW1JM3NLa0ZoUUl3WGNsREhwTGZLSk9iT0VnbmYzbGV3ZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550061),
('Udv750KrRRfFYGfe6KyVGh9xXN8qPf8clKmlqCIO', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicEVnSXFLckJrV1NkS01iY0NtRnlybXMxMmFSbk9xaDBESGN3b053OSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547810);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('UgdnZEOhNXSHLFiU63pkz7y9kR4S7HihyVwCZjYu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTjlEN1BTSGNGd0k0ZlVjZHY1SmZZcFJISWtPYnNYSjh4eWkxSFJ2SiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544758),
('uGDU9ObI74hPlPPc6BrBJAWwNIUQXRJS29PTxFep', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOERZUWlYT3MxQ1BPQVo0UDZnSnNBaGxUVlFYOTRtMXZVZE5nblRDNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545744),
('uGQcTC4uE89pMSMF43KCHuM8ePobi5bfKbLJUDF4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid2FVRnNtZUhuS2xncUlYb09YcXdhU2F0czBUc0RzdmQxQ3pjZHdkNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545991),
('UiatmJcPLPabHpXIImdRNlwJBHIJRa8LHqtfJweu', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0VRMnRZeXN5bGJFbTdDaXk2M3Z2UllpUktWM1dGa042Szl6QTA0ciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549723),
('ujHwExwtJHRi30p5p3UYBYunLqcru0nHgwuVIZ55', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS095S2tJQXl3MkgxQ2FTVnVGck1TMUNRZzV5TkhXWVU3dnF3QUxuayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544079),
('ujr4AXIrIQWH0vb26v3Fi4aTBvzQeEgkBaHaQ4qU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidjVTQ1Q0QWpScGllODNZS0tBaHVqWWJCYUJmdTVWTGJ1TWxXeTJpeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548892),
('Uk13hhKCSr9yUYFTlfWsFwxNjh8hvcQVjppbCT4t', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTG9hM3ZDekNNY3JpRkFucVp0RElvRHpRT0s2RmxtdXY0VUdzcUFESiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544357),
('Uqs28BifXtiThOe41w3uZw84JPiOsoQ6ms57hQwA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaGF0TWpzOUdROUlSaDFjWkRxRmE3OGRkb25jdTZmcDRUS1pjSVFxaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546021),
('UU7jvp5Q9hXRXiF2PDdoBFZk5pxeI2q8UmdfzWhC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHI5QU1DSTN4VkpQb0dvZVBpNk1QYnRDNkprY01mMzFoQzhPclRNNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545528),
('Uv7WtuQOOatvjhUhwcRyRFeY9ZfuXVJpSKLTzHMt', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic2thWWJwZEYwczlqUzZWc2FJSDlZZXFRZkJaRWxzZVYyYkx4U0E5eSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548429),
('uWuu6V8O9Zrd9bqlgbmaNPwc1qzuAxZ6N82az6yN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1A2ZXUxaVo2MGh1SW0wS2lnbFhrYTZBVWVodFJ5T1M4UUI0dmZVNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544264),
('V8yArQLtCaqM12UtqhKpc3au2uXrGV6qf0C7PQlT', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVNRMURDUTJkRWF5R1g5RmRGWmxaeE96MTZRTGt1ZGlOWGJUUE1YVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543458),
('V9JLGGTfMa1t34j0nV2OZhYcChZlXYBwmWdW8Ehp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQWhqUlVzTlVsbElaTGtlSkxyb3J3WmE5WHN0VUh4dkZZRUhpcHh6diI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546330),
('vcKuGTFmO9Ek2wCHE3u1Ii0d5bzq7yUPv15n6FDG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzhCdWhsRmJ4TzNocXJjc1c3U1RiVmJRVFNFbXExRGFIZVQ1Q0dvMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543520),
('VDAy5B5IoyYkqrRyW8EfMe1jxYrw2lh2Z0P5WKJS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibVNDTDBVRnZNYjBtRFc3Z1lCM1lmNm5uZ01ReU9LWmhZQkt2d09LaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543986),
('Vg6bzFRig5Eztlt0QgkTaIMZ9rEh0YCf9y9t0vNC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVXZJM0lxRnVNd3NnR2lHZUVLNmh0cWhTNkhEa0RCTExSQnhEeUFrWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546853),
('vinSdGoHqJsZljIYQuEhTkNtmiQ3J71O5jXT5gPv', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3ZCU1dwUERDWFBpSUNlOTdwb0k3UjJnbEpaWW9FYzlWd1VrZEtRQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544789),
('vKN9A2uIkmDvvII42Kj1W5e8kMByBh2gTJwk5SMy', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV05hbUMyVGhNeGRjbkRwZ0VaRHhRdFNkYlZtcVdHcThydTFvQXljUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547996),
('VnNB5cZKTfF9KF1Y3xFrpQVfRkdkOkAzVA800CRw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWmNUcDJVUFBhRWJGVFNmRk9EUDlIVzRHcXZEZTc5Y2ZMVzhMMkNMdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795550030),
('VPCTID4ZZ9MRkfYQS36M240dTi1aszdYK0s32df8', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVGl4UUVRZ21qMnlRdkRqeUFIWW5VV3RBVE5ENVpPSlU5TEVoVzQ4ViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547503),
('vpMmOGeljJgr9qoUSwCEes21Z6T5uJwtEiiAFvcm', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibTZMUFFzdnpSclVOY3M3NGV0TTJFQjJ3NnoyTkdKUGQ5THl2bGhVQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546576),
('VqROAAkGTPkWgkgp9LBepF8NNgSDxkwHtq8D2sXq', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZGZLVEJHQ0xwMkpUYUxHOUVhVzlFV1Jranp2cWV1aUh3a25GeFJwdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542839),
('vtsa7VQvJPP5vNAABuaeYB3mZB2cune3vWHsw8ox', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN051ZW5QUVk2czRGVDVMdU5qMW91OHRyZHo2RHh4VUVVVTdCOGNTZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547502),
('VTZrhJTMIhpO9ujb9ydw6iUorxgQtvMxdd1i8b6r', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYk1ocnllTGY4eW9HcDZ2YUZsR3ZNamFqMlJZM2hjZUtMcmFDMzNzWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547038),
('VyddcHseYt582J6ftFd4RRuRLkPxmzJTV7m53go3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTklueFpISmFuSTVtVXhTTVdHNE9IUFNJaG9UaXEwSklGWjFXS1ozZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547007),
('VYpG7czlXy7pZ1bbfqCGyverxa7xSgf49EjFjei5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSFFtNVFZWUtQVks4aUp5R3laZVlIeFpKQVpQbVVJUUdhSWN2MFZMTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543706),
('vyRLD7SXgAjLKzc7ODVV7EdPNOBSXElXcj145nwc', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZnJ4dDlqWlVhNEcyMzluUmNlcmxKMFpEd29Yc1FCbXdySUt4TlJJRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543644),
('vZ3XtwLrgznFhHIimGpl7liXbit2jhIvxU1OrCXY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWhpRXpWS0lhUVJlT21CYjI4NlBwck1DWXV2V0trMzNkWkFzZGxMaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547718),
('W4TREPgTZjjxxpJlvof4r6WbjL0fvCGCg6JrOQWX', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaDZhbjJDd2E1eENuZDhVRUJGOXAwbG9jNmQwd1FFdVlxQ21ZTVJEdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549660),
('w6mpTnP4pNDZrDVp5RJIwULhk6NKWx7xA69tz9uG', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1RtQ0RaR2J0THB5QUFiSlZ5SnVKM2FsMmQ1Y0JUVW92NDFoaTZUQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547348),
('wHZFgV2cnQc2T1wSOVGqlNnHt8BAABdtpvRYbIA7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR05FR1p2UnpOaFFGY3FzUFZ3V3FkSjRTVmNZcXR2N1J5WlZFS3hPeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548738),
('wjh0Uy5aHZuP7CiabYSthl2XguAwiOVX41o5e2X7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTVplb2NoMzBSSjBzVkl0SGY4c2VzRloyMGxwVW5teFJHNnpxQ2lvZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543924),
('wMensfCOQtJzpllZaaZaeHJJyVg1MqZbBRJQCN97', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXp3SmdzbTdyQUpTVlZQZ3NzQjdERk4xMEdEYmpzWlcwU1l3aXF6VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544265),
('WpGqclkzi5pRYDxEw5PVjaxDMkDyom9bCh86mwGg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibk5nd292RVdpNmxjZHkyN2plWlFwY0NVWjMxZ2drb1FIem5GUU9tTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549753),
('WPnNk3mTGrqn0wCXhHjWmPzyF20MddnTkrRsOpFx', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlRKd1dZWWR5dlN3SWxqcjBCNVdXcWZlcVBhQ2pkZlpYUXQ2QW1JcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545067),
('WpS5SRPAslcdOMAwSpLFJGU4zsvxPkQTKXlGAJZp', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibWpnUDA0Wm93S1RDbGhBT3hJalVwSVFQUlA0WEtxSUNkWVJIZlp2WCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546607),
('Ws1oPJjQvTR6OuKdCgmgJf2mXLo6lBQWcUZuX2PJ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHg3TkVzT1JwMllXdUR4NTlZVGFoakpYUDFNUUJyc2ZrNzgwT0UwNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544388),
('WxhIptYPXAfbqCHIoAb5SKRAlSpOkSIwaeIrF2a5', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2c3WWlPc0hON3dGcU5rVjVQNDY2bUFWNEMybEh1b0lHWDFwOExDeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544048),
('WXnMk0DmmDzjWn0VVY9Zzw5qHrLw3opPpmnqisiV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNXdRcXU4UlRxVGhTTkZ0NDA4TzZhTXVNc0c2cUN6eWk5MnpKNUxFcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544789),
('wyBbDBSk1lvULF02UyAtU8w3uJvRGqdjjHaEuwD7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSzE2OVJEZUdOUzBwUDBTZ2M3Nm85QlpGMHhicE1UbjNSdTBnd1N4eSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549846),
('WYmNyYSosDkiUPOFvc46rWeG7jlUqnv8ROUM5lmC', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWk1VSTQ1dERQSlZZbTRYaTJ6YjA0NWNVODJlaW9qdENpN1ZUMVBUMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549137),
('X3UsBDVhMVePxwAhLezHHGvxZox0gj5pbTS9O2QW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTWo5WEozN2FsWHN5NHNKUUVubnMzeUpZYmlxV2s1Ujl4MUlzOXZzdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549137),
('x67g6GNeLi5zLnIdgHI5JcnRSVDnvYB4mg8xCyUr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaWdKaXp5U2l2TUF5MllNSW9qdHNhVldZbm1DUUtCbDhTak9pWHJ4ayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542622),
('x6rxryGVtWMrEkkPiof02qAnhFBImU1lrFo4m5p1', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicnY0dXU1Rm9QRmNnaEJ4ZE9mbkE1eGo1MFIxT1FRRnl4Nm5hSGp1QSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549599),
('XdJnA8f1Jf9gLDMb2zfZa0O8eZdexgyeOqEoXTUs', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYzZmWjU1WWhqV2pTOUlZQ1JTSGZFcGZTNWFWU2IyTUVLU3NxRGdBRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544202),
('Xh0mkeH5DG3rNkfxpqXQfrlfTXR1dLJzev4RHJ9J', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0h3MG5WT24yS3A2cVRtM1A4NmRoV3pla291SkRnZ0gxd1VyNnVoQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546915),
('xj4YaP5rxwC1ACN5SX1PLkzrCIGRigqKQQfGZoTw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOVVjTlFsa2lnYkNiaDhyMjk2RnhJUUpMaGoxVzR0WkhiZVhJMmhHZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546730),
('xND6xu9tQVORDAUgWAg7idz0BsSLSe8w28paxFGW', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHJ6RHdwN2lMRndlSnNBZU9oNUxYUmVZSWlIUlprNjRxNVlDTkVWZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547810),
('XnKU3s6c5S1SWwtnXCj1HRzGi1QDpD0JF07YKax2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHQ1RmlrM0diSExVNDNydFNlejZmT2RjRzdvZm5lcjljdmZlRXdlMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544665),
('xNUMExU1TRn8LrHHca5eBIPMLpa0pC6woiiCS6J3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidXg1Q3R2Yk15Z1I3N2xlOUtuZ2czaDIzRG9nS005blpxUUdXT1c4bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548182),
('Xq1uBoKgenBviqr8Kz6QelIbD8RieJTbju2gp0gr', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT2Z0aXYzcTVUY3JkalBUWWprclYxWEhiYUxUSVI0ZEJyU3RDeGRkcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545775),
('xqog3bq6gFd4yjd0mYveR7dP2A7hckboaJF74Ocl', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZmRkWEtIeVdsamg4UVVGcFFNc2owQ0ptUnF3dmRtYnNhejMwRmp0RiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542561),
('xuYvB6Cbl0TEPQoiNWw0wZsxOnAhQHUs5E7ZOMCh', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTEZXN3lhZ3dZSkI3VXhhTDZBNTFMbm5NcXhuOFNIYTJNQjBNOHNDWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543054),
('xxexBgNUKVnS9cVorE5BzJuVmsDRSfDr5fdj3kWQ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidTVDZG1wMGRhdDJKTjN1ZzFOMGRpQ3VKRVdTVng5ajBkNlMxREptdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544573),
('XzICiI9NxgZlMjO5jJPPxXCXlzVWEWoNclm7i55m', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidUtQYUdFVEUwaGJnNU1RTG9KQU9UQzZMRTc3d3owNjBMSk9kYm9sayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546022),
('Y9ZL2hia7dCMBowarmGox511K1l8cALIHWx0y0uX', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMHV1NFZDS29MeWIzRFNFaG1Pc1NHU3ZFOHVEOVpFYlEya2kzSW5kNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545066),
('ycwZmXvANQtbghK1tdl9C1PvVYTqwV5ntwXbHdMV', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkJ6UXh0djFwbW1FTHliOFRTU1htb2pYNDJpSk1LQmRGYTZGMEx2SyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547780),
('yemq3aefoOcRGXZdIHpzdHC2mGihSMuBUSwV3GS4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1c2NURvdHlyWjdoVG9LeldxcnBxbkFneWhNcEFscHE1UFJZWVVjWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547595),
('YFCo4NND6cNXeLtCAuHLQSEE4iwANdm6bAzO3teI', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0Vqc1o3SUdHSlpyeXBZT0NkRVRCS0tCdkxOZVRoOUtIcEhUZE1oUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549999),
('YfgSz8ijhDrOBp9RdnPau3f45l5iNAdjz9jcryOw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGEydVFxMjNETEx3STNVa09zSW1UeGhhRno0SlIyS1VmMXh6b05zWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547565),
('yJY2BKQkyUyZhnMjZJATOfcGnIb6ICzpEbdqJsxd', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUtJQUc1MFBIYjlpbWtTR3NjbGM1YVVwSHMxeGNWeUk2ckJHNDB5NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543551),
('YNudXkiRudpyr9CXu9jnyuxQhoCkE3Yco6i8SD2B', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibmdDMzE4WGxTM0ZuZkZ4dzBYVGJudldlbVVWU1FvY0dRZkJHRE9hOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547749),
('yowSnYPN7WNGFYbNR9WA94KcT2EaMyCMGVwR2VVs', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV01qcmlhUUE1T1Jzdno1Rm0wZ01teVBUV1d6dzJ4VDVXNE53SU5IcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546791),
('YSx80Sg8XRKyitphB2khtNQACUjjoHWzeGr7yrd7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNVhUTUZaeFlrdFdsSHJ4SXR5Q1NYcnppanp4MWpKMXgxZ1hDVjV0QSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547934),
('YsyPOLNcUpxEo1iLaauuJb6v644MunC0AQ8mLLpm', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRklvWFhZcGdGNzEyc25FekdSZG42MkhseFdHc1plVzJRb0Q1aENCYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547471),
('yT2LR3TrnhK1aCqVAaMaDCVFTRsJpn6ksOryEB1U', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieVBsQ3pETFRLWlNEdG9OYnphWllkSVpJaHZxTmNWc0JXWjFJcWlqeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549323),
('yuIDSMAbN8yFTC2AgRVcBr8pc15P40yMPuBHz5we', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZTI0ZWdYQlNuOXF0aXRlSThNTGRCYUxqNnprUjkySG85ejdhN21zQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546576),
('yuwmicB6D7qbksTRApzfAIcERrU3yOPwScfTtnfm', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUnhFZHlLUEwyQ2hPUWNURWFXQmFka0FHWDNUMVI4RGM3TUZnNFZTUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545098),
('yUWZNpzuK0mXgPlk0aMUi5c7IQiHbS5lWIKiETG4', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMFRicmpLdzNpV29iUmZLUE10Q0FVUHdyOUttOG1LQ3hYTTFSMjVmVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548150),
('YVJ8WDYw8HcrQGiGZrxvIdQrh8IjEW1YASKMkvb3', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1luejZlZWxWMUxZVmptbElCOXZBekNJV1pMRUJwZkV1TFdKZ2M4YSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547534),
('yW4Wi3NYhrkNhjlI7eZ7kqwtEHf3HWnz6pXb3u2S', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid1dDWXNDc0hFamh0OVU1VU8ybjFYM2VEUzFNQXdkTlN5MVc4c1BtZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543024),
('YXjwB8qLg7hOOpUgfGrvKWeFwnDjyTzqHNZXUkSZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSUduWWptTU5TaExBNkkwTmNZMFV2d1VmSjA5eDFoSEtKODZHdWo3UiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543737),
('yZtPvLYgMGLuiXHLzGgF8heA0gxC1ZmudlEsJojy', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0hXUEpTQ1FaRmxJYzg1Y2xMM2ozVkZNNkg5Q0VpVUlWaVVyaG9VOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543489),
('Z0LdkbHBayvcLPhpFltpceHQm9CFJXhWpYpISYuY', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ25TOGRtWlZFQWVrSW91WGxoZGlIT0RYR2dkYml6aHVuSVg4eHFVNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543582),
('z0r0T849gb9RlXpbyqwT34Yu1pbVEzKRaHWsPgCB', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVJrNUhSWkZSZUt6SjBxRWNmamc5VGM0OWR5NEtwOExsTmQxQm9UYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542900),
('Z0xfnlRHfdjgi9wFdrP8KJuit3y5DeIXZpJHso1k', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTDZDVTZTT0twQzVQUVEyMTdtaUNuUjNwOU5hVGhFR2Y1OEJqVW5pMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542931),
('z8h9liCUdjnSpTdkJfH2K4E81wfAgNccGPuSRSwo', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmFNRFhhSTVqODlvVlRRUlBGTE9HeWhncHZISWJTcmloandtWVpnMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548768),
('z9OhMSXVcJue3fz1Jb5cDtCy6jZC1R2m0HkLbR0P', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiejcwNDR3VVRBOVhQTXZBNUxoZXZ2clFBM1VCWDVTZDNBZ2poZjhDMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795543364),
('ZcT4t4C5sYgzBcDZpsgwVNXcs7hO0AYAgZyPIlDS', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiejFGeEM3SHVacWxQemp0N2t1VWV0ZTN0NWRUeW8zTHhSZnZVQzB4WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546114),
('Zd4Lhh9HAqjqEZZr2zD4ZoC4cJX8KJisFt6HryBb', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN2VrOWREbnBqM0YxM3paUDF6S1RnU0hGOVcyRG1MUUgzM21lN0ZjbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795546945),
('zd5YhGwRoQb35mlyOcRkygJhskhwHBtUPYqN0UnN', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1ByZm1ibGpNQ3N3VmUzOXRFZ0tqMkdVV1F5eXhLUkloYzExMnFTSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547410),
('ZDbygyAQqcDAC0s8K07d1bBBFeYoXsoSBp5wjkhP', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUZKN3NHZjFZMzF6VVBLQzBHSW8zclh1TGNiWkl5YXdzeTlhcjR4QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545035),
('zDNEmJKrw6JmVf5kcsjQTkkTxvUI52GWfqceKlgw', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidWlwZ2lJQmxsWUV0bmtYcFl3cktpMmpLUDVoR2h6M29FbHplMzRNdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545252),
('zgkYN6Tt2sntlqZLLbwIglDSfEVYpDF0Rjd8mwlU', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUjVWbFJYd0FwR0VnZWRCS1lKZG01U3dVSVEzaWYyYXFRdktVd3NzTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544295),
('zHUb3bdElda71kLDJk0fldlLpvu6WBdJMn1u9ySR', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHZvOHlTRUt5dlJlbEpoWXM0Q1RmOEpVZnJESzdBZXRCaUIyNm9MMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795544141),
('ZIG7HJnkICvOnoX1OV1MGpcCSVzZ7W18rewk5uxZ', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSm1FTWRGcFZJQldmM2RPcW5BWjhKdzRGOVhpek1tWGQ3cnFyaUI4RiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542777),
('zkpzMpWWKOvcz1mkVZ7aG9RsKLjuR28NOoRmZ4Ho', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicXhhVVRnejNKQ1A5R25aamhqY090c013ZkxIbTRtSzJObGZPMmlpSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545806),
('ZlMHVHitKGhZdDXHgLGhn5rGj8dK6kMdrt5MyJkA', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN1BTMHpBSmtQa0o3dmpIQTNubUNqZG9lazduSlltMjRLTFh4Yk11TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795548769),
('ZoxJ5XQ0ktFuyEwo9m8zC07DVcZHKMipyiK2YCX2', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMjZyejFFVEFJMEVnOVpNcU5SZFl2YmtOd3FOb05DUjJUVDVIRWFKdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545252),
('ztLxn00hxImhABzBxC7vdUd0qSwWFgd6qqxrR3gg', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicXpqbVJOQzJHUEV4bmhBZFJYelVvUzFqNU9IbFJJQTRUNG1hOWdURyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795549014),
('ZWQeVISL4EUExNWtuWKOTgSM2HxSwWwXCU30tun7', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZVI5WWRLblVldXZsZkZxcEhlbm1aN0ZKb3NWSzR5aEtqdFBZUjc2diI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795542900),
('ZWuXzpbanJubQjs0uP54XDI0nUBPuz4IERxOGk9f', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS1BuaWdLRW5tUHlUbHRhTlZZSHhqZVhydmR3S1NCVzJFOGc5Y0pjMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9oZWFsdGgiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795545898),
('ZxFH6pcx94e3fTGq5vyZMTV7Pqw8BDvj6yJSKX7G', NULL, '127.0.0.1', 'opencode/latest/2.2.7/cli', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia0xKbVdpdXVuZHpvQUN4QXZFNTJ0MjBnVThSdWNvQjZXQmI5Y0Z2ViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC92MS9tb2RlbHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1795547286);

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
  `is_private` tinyint(1) NOT NULL DEFAULT '1',
  `created_by` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `transaction_type_id`, `workflow_definition_id`, `office_id`, `reference_number`, `title`, `is_done`, `is_archive`, `is_private`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(40, 11, 61, 24, 'NU5A-C47R-ESAV', NULL, 0, 0, 1, 1, '2026-09-30 08:09:17', '2026-09-30 08:09:17', NULL),
(41, 11, 66, 24, 'AEFT-WUDT-SHDA', NULL, 0, 0, 1, 1, '2026-10-04 09:34:21', '2026-10-04 09:34:21', NULL),
(50, 1, 17, 24, '3BRU-SA8W-QRGR', 'sharief kundo mudrikal', 0, 0, 1, 10, '2026-10-16 11:37:24', '2026-10-16 11:37:24', NULL),
(51, 2, 7, 24, 'P00V-E8YI-EAOW', 'sharief procurement', 0, 0, 1, 10, '2026-10-16 11:40:38', '2026-10-16 11:40:38', NULL),
(52, 11, 66, 24, 'WBFQ-HKOG-LDKE', 'sharief', 0, 0, 1, 10, '2026-10-16 11:44:18', '2026-10-16 11:44:18', NULL),
(53, 1, 17, 24, 'WJVR-4V6U-2ZRT', 'Inoferio, Charl\'s Benedick Martel Wee. - PAYROLL', 1, 0, 1, 1, '2026-10-19 10:25:54', '2026-11-04 23:23:08', NULL),
(54, 1, 17, 24, 'V4E0-O3TL-W9BS', 'Charls inoferio Payroll October 1 - 15 2026', 0, 0, 1, 1, '2026-10-19 15:13:46', '2026-10-19 15:13:46', NULL),
(55, 11, 66, 24, 'ACV0-ALRI-XZAG', 'Anthony Procurement', 0, 0, 1, 1, '2026-10-20 13:05:41', '2026-10-20 13:05:41', NULL),
(59, 11, 72, 24, 'VPWN-I12N-H2OH', 'vincent anthony procurement', 0, 0, 1, 59, '2026-10-21 13:55:58', '2026-10-21 13:55:58', NULL),
(60, 11, 72, 24, 'WTJW-93XH-W5CY', NULL, 0, 0, 1, 59, '2026-10-22 13:56:00', '2026-10-22 13:56:00', NULL),
(61, 11, 72, 24, 'GQZ5-C05U-WL85', NULL, 0, 0, 1, 59, '2026-10-22 13:58:16', '2026-10-22 13:58:16', NULL),
(62, 11, 72, 5, 'VJIK-GNG6-1IXR', NULL, 0, 0, 1, 40, '2026-10-22 14:16:57', '2026-10-22 14:16:57', NULL),
(63, 11, 72, 24, 'HFSH-PS3K-TYOD', NULL, 0, 0, 1, 59, '2026-10-22 14:19:11', '2026-10-22 14:19:11', NULL),
(64, 1, 67, 24, '9IRD-DMGH-XSJG', NULL, 1, 0, 1, 1, '2026-10-26 08:25:08', '2026-11-16 15:58:51', NULL),
(65, 1, 80, 24, 'JZJO-GQWY-CMD5', NULL, 1, 1, 1, 1, '2026-10-27 09:10:47', '2026-11-04 23:23:23', NULL),
(66, 1, 80, 24, 'Y36S-XQWD-0QVH', NULL, 0, 1, 1, 1, '2026-10-29 19:24:36', '2026-11-04 23:10:10', NULL),
(67, 11, 74, 16, '9BW8-WZLF-ZWL0', 'LENIN LENIN', 0, 0, 1, 1, '2026-11-04 23:46:58', '2026-11-18 21:18:06', NULL);

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
(65, 40, 392, 74, NULL, 202, 'AR.pdf', NULL, 'attachments/40/392/If8wTVtno3BZ9gJXLaBQqsARvDK6dSi8VSd0J9C3.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:17', '2026-10-01 16:12:24'),
(66, 40, 392, 73, NULL, 202, 'AR.pdf', NULL, 'attachments/40/392/WrqrhZCU9iVa4ZOZlGmoLspGYOCRnCeGVmcnOuqD.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:21', '2026-10-01 16:12:24'),
(67, 40, 393, 75, NULL, 203, 'AR.pdf', NULL, 'attachments/40/393/kHHtEGfe7S3jBlIJ5gWrk5tIy5XWeAvZzcATXFRB.pdf', 'local', 'application/pdf', 679398, 1, '2026-10-01 16:12:37', '2026-10-01 16:12:38'),
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
(103, 64, 424, NULL, NULL, 268, '2025 ANNUAL ACCOMPLISHMENT REPORT.pdf', 'wadwad', 'attachments/2026/10/64/424/4W8Y4uRLbfJaqe9BAmR0eDdSKYmbSPrmkkDc2CRu.pdf', 'local', 'application/pdf', 584366, 1, '2026-10-26 08:29:59', '2026-11-16 15:58:00'),
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
(208, 53, 74, 32, NULL, NULL, 'ACCEPTANCE AND INSPECTION REPORT  LENIN COMP SYSTEM INC.pdf', NULL, 'attachments/2026/11/53/74/EovZvDhrJwerYzhx3pH8hbdcmJb5BZjSilWuevwj.pdf', 'local', 'application/pdf', 470731, 1, '2026-11-04 23:23:06', '2026-11-04 23:23:06'),
(209, 67, 475, 198, NULL, 262, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', NULL, 'attachments/2026/11/67/475/u0nBc5GwUnF8obcoLcFXE8xskqYCZFD35l7gLYGC.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-10 17:45:47', '2026-11-10 17:45:55'),
(210, 67, 475, 195, NULL, 262, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', NULL, 'attachments/2026/11/67/475/QR41k8IOqDzCGCiHVSACl6AuczrDI9vHnV9Nj22L.pdf', 'local', 'application/pdf', 8594822, 1, '2026-11-10 17:45:52', '2026-11-10 17:45:55'),
(211, 40, 394, 76, 67, 263, 'AR.pdf', NULL, 'attachments/40/393/kHHtEGfe7S3jBlIJ5gWrk5tIy5XWeAvZzcATXFRB.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-10 23:16:07', '2026-11-10 23:16:09'),
(212, 67, 476, 199, 210, 264, 'ACCEPTANCE AND INSPECTION REPORT ULTIMATE VISION DEVELOPER OPC.pdf', NULL, 'attachments/2026/11/67/475/QR41k8IOqDzCGCiHVSACl6AuczrDI9vHnV9Nj22L.pdf', 'local', 'application/pdf', 8594822, 1, '2026-11-15 09:23:15', '2026-11-15 09:23:19'),
(213, 67, 477, 200, NULL, 265, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', NULL, 'attachments/2026/11/67/477/jPxN9jFIbiW1QSWr5KT0USfcRdHMXc0VPiMTEFQU.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-15 17:02:49', '2026-11-15 17:02:51'),
(214, 67, 478, 192, 213, 266, 'ACCEPTANCE AND INSPECTION REPORT      KIKOMONSTER GRAPHIC DESIGN.pdf', NULL, 'attachments/2026/11/67/477/jPxN9jFIbiW1QSWr5KT0USfcRdHMXc0VPiMTEFQU.pdf', 'local', 'application/pdf', 385033, 1, '2026-11-15 21:55:14', '2026-11-15 21:55:16'),
(215, 64, 424, 115, NULL, 268, 'AUTHORITY TO CONDUCT INSPECTION AND PHYSICAL INVENTORY.pdf', NULL, 'attachments/2026/11/64/424/8zaWoKAglUSgQGUHxVximXuq4OKrNh62iQ8qi9fa.pdf', 'local', 'application/pdf', 359202, 1, '2026-11-16 15:57:43', '2026-11-16 15:58:00'),
(216, 64, 424, 110, NULL, 268, 'AR.pdf', NULL, 'attachments/2026/11/64/424/LXKps1HtXuUOLFaVMGY6N9F0dnXGbsEZhzzJV6uf.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-16 15:57:46', '2026-11-16 15:58:00'),
(217, 64, 424, 112, NULL, 268, 'AR.pdf', NULL, 'attachments/2026/11/64/424/20RlsUd9jbQJLnw3eiWR8tzQ1a6nPO3HmW9guQAf.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-16 15:57:58', '2026-11-16 15:58:00'),
(218, 64, 425, 111, 217, 269, 'AR.pdf', NULL, 'attachments/2026/11/64/424/20RlsUd9jbQJLnw3eiWR8tzQ1a6nPO3HmW9guQAf.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-16 15:58:22', '2026-11-16 15:58:29'),
(219, 64, 425, 113, 217, 269, 'AR.pdf', NULL, 'attachments/2026/11/64/424/20RlsUd9jbQJLnw3eiWR8tzQ1a6nPO3HmW9guQAf.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-16 15:58:26', '2026-11-16 15:58:29'),
(220, 64, 426, 116, NULL, NULL, 'AR.pdf', NULL, 'attachments/2026/11/64/426/6jvCj3oYPRR8Ji2yyMvMBbm3RclTBTsZW7snkMY6.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-16 15:58:50', '2026-11-16 15:58:50'),
(221, 67, 479, 193, NULL, 276, 'AR.pdf', NULL, 'attachments/2026/11/67/479/Pbeae1Bp4efIV0IZOYa60IVpuIvZxK7h56gpbew5.pdf', 'local', 'application/pdf', 679398, 1, '2026-11-18 21:18:47', '2026-11-18 21:18:49');

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
(76, 53, 74, 19, 1, '2026-11-04 23:22:50', '2026-11-04 23:22:50', '2026-11-04 23:22:50'),
(77, 40, 394, 47, 1, '2026-11-10 23:15:51', '2026-11-10 23:15:51', '2026-11-10 23:15:51'),
(78, 67, 476, 126, 1, '2026-11-15 09:23:02', '2026-11-15 09:23:02', '2026-11-15 09:23:02'),
(79, 67, 476, 127, 1, '2026-11-15 09:23:05', '2026-11-15 09:23:05', '2026-11-15 09:23:05'),
(80, 67, 477, 128, 1, '2026-11-15 17:02:38', '2026-11-15 17:02:38', '2026-11-15 17:02:38'),
(81, 67, 478, 129, 1, '2026-11-15 21:55:06', '2026-11-15 21:55:06', '2026-11-15 21:55:06'),
(82, 64, 425, 74, 1, '2026-11-16 15:58:08', '2026-11-16 15:58:08', '2026-11-16 15:58:08'),
(83, 64, 425, 76, 1, '2026-11-16 15:58:10', '2026-11-16 15:58:10', '2026-11-16 15:58:10'),
(84, 64, 426, 72, 1, '2026-11-16 15:58:39', '2026-11-16 15:58:39', '2026-11-16 15:58:39'),
(85, 64, 426, 73, 1, '2026-11-16 15:58:40', '2026-11-16 15:58:40', '2026-11-16 15:58:40'),
(86, 67, 479, 130, 1, '2026-11-18 21:18:29', '2026-11-18 21:18:29', '2026-11-18 21:18:29');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_officer_assignments`
--
CREATE TABLE `transaction_officer_assignments` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `transaction_step_run_id` bigint UNSIGNED NOT NULL,
  `from_user_id` bigint UNSIGNED DEFAULT NULL,
  `to_user_id` bigint UNSIGNED DEFAULT NULL,
  `assigned_by` bigint UNSIGNED DEFAULT NULL,
  `from_user_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_user_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_by_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_at` timestamp NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_automatic` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_officer_assignments`
--

INSERT INTO `transaction_officer_assignments` (`id`, `transaction_id`, `transaction_step_run_id`, `from_user_id`, `to_user_id`, `assigned_by`, `from_user_name`, `to_user_name`, `assigned_by_name`, `assigned_at`, `reason`, `is_automatic`) VALUES
(1, 67, 275, 1, 43, 1, 'Vince', 'Carlo Miguel Saavedra', 'Vince', '2026-11-18 21:18:06', 'wala man sya ngani', 0);

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
(123, 40, 392, 74, 1, '2026-09-30 09:07:56', '2026-09-30 09:07:56', '2026-09-30 09:07:56'),
(124, 40, 392, 73, 1, '2026-09-30 09:07:57', '2026-09-30 09:07:57', '2026-09-30 09:07:57'),
(125, 40, 393, 75, 1, '2026-10-01 16:12:33', '2026-10-01 16:12:33', '2026-10-01 16:12:33'),
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
(197, 53, 74, 32, 1, '2026-11-04 23:22:54', '2026-11-04 23:22:54', '2026-11-04 23:22:54'),
(198, 67, 475, 198, 1, '2026-11-10 17:45:41', '2026-11-10 17:45:41', '2026-11-10 17:45:41'),
(199, 67, 475, 195, 1, '2026-11-10 17:45:42', '2026-11-10 17:45:42', '2026-11-10 17:45:42'),
(200, 40, 394, 76, 1, '2026-11-10 23:15:59', '2026-11-10 23:15:59', '2026-11-10 23:15:59'),
(201, 67, 476, 199, 1, '2026-11-15 09:23:12', '2026-11-15 09:23:12', '2026-11-15 09:23:12'),
(202, 67, 477, 200, 1, '2026-11-15 17:02:41', '2026-11-15 17:02:41', '2026-11-15 17:02:41'),
(203, 67, 478, 192, 1, '2026-11-15 21:55:09', '2026-11-15 21:55:09', '2026-11-15 21:55:09'),
(204, 64, 424, 112, 1, '2026-11-16 15:57:23', '2026-11-16 15:57:23', '2026-11-16 15:57:23'),
(205, 64, 424, 115, 1, '2026-11-16 15:57:24', '2026-11-16 15:57:24', '2026-11-16 15:57:24'),
(206, 64, 425, 111, 1, '2026-11-16 15:58:16', '2026-11-16 15:58:16', '2026-11-16 15:58:16'),
(207, 64, 425, 113, 1, '2026-11-16 15:58:18', '2026-11-16 15:58:18', '2026-11-16 15:58:18'),
(208, 64, 426, 116, 1, '2026-11-16 15:58:44', '2026-11-16 15:58:44', '2026-11-16 15:58:44'),
(209, 67, 479, 193, 1, '2026-11-18 21:18:35', '2026-11-18 21:18:35', '2026-11-18 21:18:35');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_states`
--
CREATE TABLE `transaction_states` (
  `id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `current_step_id` bigint UNSIGNED NOT NULL,
  `current_run_id` bigint UNSIGNED DEFAULT NULL,
  `entered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_states`
--

INSERT INTO `transaction_states` (`id`, `transaction_id`, `current_step_id`, `current_run_id`, `entered_at`, `created_at`, `updated_at`) VALUES
(40, 40, 395, 263, '2026-11-10 23:16:09', '2026-09-30 08:09:17', '2026-11-10 23:16:09'),
(41, 41, 416, 207, '2026-10-04 09:34:21', '2026-10-04 09:34:21', '2026-10-04 09:34:21'),
(50, 50, 73, 226, '2026-10-16 11:38:52', '2026-10-16 11:37:24', '2026-10-16 11:38:52'),
(51, 51, 39, 228, '2026-10-16 11:41:08', '2026-10-16 11:40:38', '2026-10-16 11:41:08'),
(52, 52, 417, 230, '2026-10-16 11:44:41', '2026-10-16 11:44:18', '2026-10-16 11:44:41'),
(53, 53, 74, 260, '2026-10-19 11:52:49', '2026-10-19 10:25:54', '2026-10-19 11:52:49'),
(54, 54, 72, 234, '2026-10-19 15:13:46', '2026-10-19 15:13:46', '2026-10-19 15:13:46'),
(55, 55, 416, 235, '2026-10-20 13:05:41', '2026-10-20 13:05:41', '2026-10-20 13:05:41'),
(59, 59, 462, 252, '2026-10-22 15:03:26', '2026-10-21 13:55:58', '2026-10-22 15:03:26'),
(60, 60, 459, 244, '2026-10-22 13:56:00', '2026-10-22 13:56:00', '2026-10-22 13:56:00'),
(61, 61, 462, 248, '2026-10-22 14:04:49', '2026-10-22 13:58:16', '2026-10-22 14:04:49'),
(62, 62, 459, 249, '2026-10-22 14:16:57', '2026-10-22 14:16:57', '2026-10-22 14:16:57'),
(63, 63, 459, 250, '2026-10-22 14:19:11', '2026-10-22 14:19:11', '2026-10-22 14:19:11'),
(64, 64, 426, 270, '2026-11-16 15:58:29', '2026-10-26 08:25:08', '2026-11-16 15:58:51'),
(65, 65, 500, 259, '2026-11-04 23:22:09', '2026-10-27 17:10:47', '2026-11-04 23:22:09'),
(66, 66, 499, 257, '2026-10-29 19:25:42', '2026-10-29 19:24:36', '2026-10-29 19:25:42'),
(67, 67, 480, 276, '2026-11-18 21:18:49', '2026-11-04 23:46:58', '2026-11-18 21:18:49');

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

--
-- Dumping data for table `transaction_step_data`
--

INSERT INTO `transaction_step_data` (`id`, `transaction_id`, `workflow_step_data_id`, `transaction_step_run_id`, `workflow_step_id`, `data_value`, `entered_by`, `entered_at`, `created_at`, `updated_at`) VALUES
(1, 67, 2, 262, 475, 'waawd', 1, '2026-11-10 17:45:55', '2026-11-10 17:45:55', '2026-11-10 17:45:55');

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
  `updated_at` timestamp NULL DEFAULT NULL,
  `assigned_to` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_step_runs`
--

INSERT INTO `transaction_step_runs` (`id`, `transaction_id`, `from_step_id`, `to_step_id`, `action_code`, `remarks`, `flagged_items`, `performed_by`, `performed_at`, `received_at`, `received_by`, `received_office_id`, `sla_minutes_snapshot`, `created_at`, `updated_at`, `assigned_to`) VALUES
(201, 40, 392, 392, 'create', 'Transaction created', NULL, 1, '2026-09-30 08:09:17', '2026-09-30 08:09:17', 1, 8, 0, '2026-09-30 08:09:17', '2026-09-30 08:09:17', NULL),
(202, 40, 392, 393, 'submit', NULL, NULL, 1, '2026-10-01 16:12:24', '2026-10-01 16:12:26', 1, 24, 120, '2026-10-01 16:12:24', '2026-10-01 16:12:26', NULL),
(203, 40, 393, 394, 'submit', NULL, NULL, 1, '2026-10-01 16:12:38', '2026-10-01 16:16:55', 1, 5, 120, '2026-10-01 16:12:38', '2026-10-01 16:16:55', NULL),
(204, 40, 394, 392, 'return', 'kulan man ni bai', NULL, 1, '2026-10-01 16:17:51', '2026-10-01 16:17:52', 1, 8, 0, '2026-10-01 16:17:51', '2026-10-01 16:17:52', NULL),
(205, 40, 392, 393, 'submit', NULL, NULL, 1, '2026-10-02 18:06:10', '2026-10-02 18:06:17', 1, 24, 120, '2026-10-02 18:06:10', '2026-10-02 18:06:17', NULL),
(206, 40, 393, 394, 'submit', NULL, NULL, 1, '2026-10-04 09:31:35', '2026-10-04 09:31:40', 1, 5, 120, '2026-10-04 09:31:35', '2026-10-04 09:31:40', NULL),
(207, 41, 416, 416, 'create', 'Transaction created', NULL, 1, '2026-10-04 09:34:21', '2026-10-04 09:34:21', 1, 8, 0, '2026-10-04 09:34:21', '2026-10-04 09:34:21', NULL),
(225, 50, 72, 72, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:37:24', '2026-10-16 11:37:24', 10, NULL, 960, '2026-10-16 11:37:24', '2026-10-16 11:37:24', NULL),
(226, 50, 72, 73, 'submit', NULL, NULL, 10, '2026-10-16 11:38:52', NULL, NULL, 4, 960, '2026-10-16 11:38:52', '2026-10-16 11:38:52', NULL),
(227, 51, 38, 38, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:40:38', '2026-10-16 11:40:38', 10, NULL, 960, '2026-10-16 11:40:38', '2026-10-16 11:40:38', NULL),
(228, 51, 38, 39, 'submit', NULL, NULL, 10, '2026-10-16 11:41:08', NULL, NULL, NULL, 960, '2026-10-16 11:41:08', '2026-10-16 11:41:08', NULL),
(229, 52, 416, 416, 'create', 'Transaction created', NULL, 10, '2026-10-16 11:44:18', '2026-10-16 11:44:18', 10, 8, 0, '2026-10-16 11:44:18', '2026-10-16 11:44:18', NULL),
(230, 52, 416, 417, 'submit', NULL, NULL, 10, '2026-10-16 11:44:41', NULL, NULL, 24, 120, '2026-10-16 11:44:41', '2026-10-16 11:44:41', NULL),
(231, 53, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-10-19 10:25:54', '2026-10-19 10:25:54', 1, NULL, 960, '2026-10-19 10:25:54', '2026-10-19 10:25:54', NULL),
(232, 53, 72, 73, 'submit', NULL, NULL, 1, '2026-10-19 11:52:22', '2026-10-19 11:52:25', 1, 4, 960, '2026-10-19 11:52:22', '2026-10-19 11:52:25', NULL),
(233, 53, 73, 74, 'approve', NULL, NULL, 1, '2026-10-19 19:52:49', '2026-11-04 23:22:46', 1, NULL, 1440, '2026-10-19 19:52:49', '2026-11-04 23:22:46', NULL),
(234, 54, 72, 72, 'create', 'Transaction created', NULL, 1, '2026-10-19 15:13:46', '2026-10-19 15:13:46', 1, NULL, 960, '2026-10-19 15:13:46', '2026-10-19 15:13:46', NULL),
(235, 55, 416, 416, 'create', 'Transaction created', NULL, 1, '2026-10-20 13:05:41', '2026-10-20 13:05:41', 1, 8, 0, '2026-10-20 13:05:41', '2026-10-20 13:05:41', NULL),
(239, 59, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-21 13:55:58', '2026-10-21 13:55:58', 59, 24, 0, '2026-10-21 13:55:58', '2026-10-21 13:55:58', NULL),
(240, 59, 459, 460, 'submit', 'testing vers 1', NULL, 59, '2026-10-21 13:56:31', '2026-10-21 13:57:29', 42, 8, 120, '2026-10-21 13:56:31', '2026-10-21 13:57:29', NULL),
(241, 59, 460, 461, 'submit', NULL, NULL, 42, '2026-10-21 13:58:33', '2026-10-21 14:16:41', 40, 5, 120, '2026-10-21 13:58:33', '2026-10-21 14:16:41', NULL),
(242, 59, 461, 459, 'return', 'wrong name spelling encode the correct name of the employee please', '[{\"code\": \"pr_number\", \"name\": \"PR with Number\", \"requirement_definition_id\": 175}]', 40, '2026-10-21 14:17:30', '2026-10-21 14:19:35', 59, 24, 0, '2026-10-21 14:17:30', '2026-10-21 14:19:35', NULL),
(243, 59, 459, 460, 'submit', 'ganyan talaga name ko helllo?', NULL, 59, '2026-10-21 14:19:58', '2026-10-22 15:02:15', 42, 8, 120, '2026-10-21 14:19:58', '2026-10-22 15:02:15', NULL),
(244, 60, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 13:56:00', '2026-10-22 13:56:00', 59, 24, 0, '2026-10-22 13:56:00', '2026-10-22 13:56:00', NULL),
(245, 61, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 13:58:16', '2026-10-22 13:58:16', 59, 24, 0, '2026-10-22 13:58:16', '2026-10-22 13:58:16', NULL),
(246, 61, 459, 460, 'submit', NULL, NULL, 59, '2026-10-22 13:58:55', '2026-10-22 14:01:15', 42, 8, 120, '2026-10-22 13:58:55', '2026-10-22 14:01:15', NULL),
(247, 61, 460, 461, 'submit', NULL, NULL, 42, '2026-10-22 14:01:35', '2026-10-22 14:04:27', 40, 5, 120, '2026-10-22 14:01:35', '2026-10-22 14:04:27', NULL),
(248, 61, 461, 462, 'submit', NULL, NULL, 40, '2026-10-22 14:04:49', NULL, NULL, 24, 120, '2026-10-22 14:04:49', '2026-10-22 14:04:49', NULL),
(249, 62, 459, 459, 'create', 'Transaction created', NULL, 40, '2026-10-22 14:16:57', '2026-10-22 14:16:57', 40, 5, 0, '2026-10-22 14:16:57', '2026-10-22 14:16:57', NULL),
(250, 63, 459, 459, 'create', 'Transaction created', NULL, 59, '2026-10-22 14:19:11', '2026-10-22 14:19:11', 59, 24, 0, '2026-10-22 14:19:11', '2026-10-22 14:19:11', NULL),
(251, 59, 460, 461, 'submit', NULL, NULL, 42, '2026-10-22 15:02:23', '2026-10-22 15:03:12', 40, 5, 120, '2026-10-22 15:02:23', '2026-10-22 15:03:12', NULL),
(252, 59, 461, 462, 'submit', NULL, NULL, 40, '2026-10-22 23:03:26', NULL, NULL, NULL, 120, '2026-10-22 23:03:26', '2026-10-22 23:03:26', NULL),
(253, 64, 424, 424, 'create', 'Transaction created', NULL, 1, '2026-10-26 08:25:08', '2026-10-26 08:25:08', 1, 24, 960, '2026-10-26 08:25:08', '2026-10-26 08:25:08', NULL),
(254, 65, 498, 498, 'create', 'Transaction created', NULL, 1, '2026-10-27 09:10:47', '2026-10-27 09:10:47', 1, 24, 960, '2026-10-27 09:10:47', '2026-10-27 09:10:47', NULL),
(255, 65, 498, 499, 'submit', NULL, NULL, 1, '2026-10-29 18:03:09', '2026-10-29 18:03:13', 1, 4, 960, '2026-10-29 18:03:09', '2026-10-29 18:03:13', NULL),
(256, 66, 498, 498, 'create', 'Transaction created', NULL, 1, '2026-10-29 19:24:36', '2026-10-29 19:24:36', 1, 24, 960, '2026-10-29 19:24:36', '2026-10-29 19:24:36', NULL),
(257, 66, 498, 499, 'submit', 'Kulang bai', NULL, 1, '2026-10-29 19:25:42', '2026-10-29 19:25:45', 1, 4, 960, '2026-10-29 19:25:42', '2026-10-29 19:25:45', NULL),
(258, 65, 499, 500, 'approve', NULL, NULL, 1, '2026-11-04 23:22:09', '2026-11-04 23:22:12', 1, 24, 1440, '2026-11-04 23:22:09', '2026-11-04 23:22:12', NULL),
(259, 65, 500, 500, 'finalize', 'Transaction finalized', NULL, 1, '2026-11-04 23:22:33', '2026-11-04 23:22:33', 1, 24, 1440, '2026-11-04 23:22:33', '2026-11-04 23:22:33', NULL),
(260, 53, 74, 74, 'finalize', 'Transaction finalized', NULL, 1, '2026-11-04 23:23:08', '2026-11-04 23:23:08', 1, 24, 1440, '2026-11-04 23:23:08', '2026-11-04 23:23:08', NULL),
(261, 67, 475, 475, 'create', 'Transaction created', NULL, 1, '2026-11-04 23:46:58', '2026-11-04 23:46:58', 1, 16, 0, '2026-11-04 23:46:58', '2026-11-04 23:46:58', NULL),
(262, 67, 475, 476, 'submit', NULL, NULL, 1, '2026-11-10 17:45:55', '2026-11-10 17:47:54', 1, 8, 120, '2026-11-10 17:45:55', '2026-11-10 17:47:54', NULL),
(263, 40, 394, 395, 'submit', NULL, NULL, 1, '2026-11-10 23:16:09', '2026-11-10 23:16:12', 1, 24, 120, '2026-11-10 23:16:09', '2026-11-10 23:16:12', NULL),
(264, 67, 476, 477, 'submit', NULL, NULL, 1, '2026-11-15 09:23:19', '2026-11-15 09:36:24', 1, 5, 120, '2026-11-15 09:23:19', '2026-11-15 09:36:24', NULL),
(265, 67, 477, 478, 'submit', NULL, NULL, 1, '2026-11-15 17:02:51', '2026-11-15 17:31:34', 1, 16, 120, '2026-11-15 17:02:51', '2026-11-15 17:31:34', NULL),
(266, 67, 478, 479, 'submit', NULL, NULL, 1, '2026-11-15 21:55:16', '2026-11-15 21:55:49', 1, 9, 120, '2026-11-15 21:55:16', '2026-11-15 21:55:49', NULL),
(267, 67, 479, 475, 'return', 'Mali', '[{\"code\": \"cto_app\", \"name\": \"CTO approve PR\", \"requirement_definition_id\": 192}]', 1, '2026-11-15 22:30:36', '2026-11-15 22:30:45', 1, 16, 0, '2026-11-15 22:30:36', '2026-11-15 22:30:45', NULL),
(268, 64, 424, 425, 'submit', NULL, NULL, 1, '2026-11-16 15:58:00', '2026-11-16 15:58:05', 1, 4, 960, '2026-11-16 15:58:00', '2026-11-16 15:58:05', NULL),
(269, 64, 425, 426, 'approve', NULL, NULL, 1, '2026-11-16 15:58:29', '2026-11-16 15:58:32', 1, 24, 1440, '2026-11-16 15:58:29', '2026-11-16 15:58:32', NULL),
(270, 64, 426, 426, 'finalize', 'Transaction finalized', NULL, 1, '2026-11-16 15:58:51', '2026-11-16 15:58:51', 1, 24, 1440, '2026-11-16 15:58:51', '2026-11-16 15:58:51', NULL),
(271, 67, 475, 479, 'resend', 'awdawdaw', NULL, 1, '2026-11-17 00:25:53', '2026-11-17 00:25:58', 1, 9, 120, '2026-11-17 00:25:53', '2026-11-17 00:25:58', NULL),
(272, 67, 479, 475, 'return', 'Kulang', '[{\"code\": \"cto_app\", \"name\": \"CTO approve PR\", \"requirement_definition_id\": 192}]', 1, '2026-11-17 00:31:42', '2026-11-17 00:31:46', 1, 16, 0, '2026-11-17 00:31:42', '2026-11-17 00:31:46', NULL),
(273, 67, 475, 479, 'resend', 'awdawd', NULL, 1, '2026-11-17 16:51:24', '2026-11-17 16:51:27', 1, 9, 120, '2026-11-17 16:51:24', '2026-11-17 16:51:27', NULL),
(274, 67, 479, 475, 'return', 'd', NULL, 1, '2026-11-18 16:38:20', '2026-11-18 16:38:22', 1, 16, 0, '2026-11-18 16:38:20', '2026-11-18 16:38:22', NULL),
(275, 67, 475, 479, 'resend', 'rfrfrf', NULL, 1, '2026-11-18 16:38:35', '2026-11-18 16:38:37', 1, 9, 120, '2026-11-18 16:38:35', '2026-11-18 21:18:06', 43),
(276, 67, 479, 480, 'submit', NULL, NULL, 1, '2026-11-18 21:18:49', '2026-11-18 21:18:55', 1, 1, 120, '2026-11-18 21:18:49', '2026-11-18 21:18:55', NULL);

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
  `username` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_id` bigint UNSIGNED DEFAULT NULL,
  `Contact_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `position` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `office_id`, `Contact_number`, `email_verified_at`, `password`, `is_active`, `approved_at`, `approved_by`, `remember_token`, `created_at`, `updated_at`, `position`) VALUES
(1, 'Vince', 'superadmin', 'vinzmuloc@gmail.com', NULL, NULL, NULL, '$2y$12$0qYrVEsSWeB1IRG9q7pAYefTu456iEGLGc26EfllLoZprYDLUTLX2', 1, '2026-03-09 21:24:36', NULL, '8Q2Ee5khzqudHTEnjDBYPMgV7GUPQcgrfOKxMKcEKJVFTBNCHYJMlgjB1tDF', '2026-03-09 21:24:36', '2026-11-12 16:45:08', 'Super Visor'),
(2, 'End User', 'enduser', 'enduser@lgu.test', NULL, NULL, NULL, '$2y$12$Hn3rfdfNGa5OUVsghdyOr.DVZR.G4DMNc43uJSfKpbg9tRFQN9jXa', 1, '2026-03-09 21:24:37', NULL, NULL, '2026-03-09 21:24:37', '2026-11-12 16:45:08', NULL),
(10, 'Sharief Kundo Mudrikal', 'csdadmin', 'admin@gmail.com', 24, NULL, NULL, '$2y$12$0qYrVEsSWeB1IRG9q7pAYefTu456iEGLGc26EfllLoZprYDLUTLX2', 1, '2026-09-10 13:08:36', NULL, NULL, '2026-09-10 13:08:36', '2026-11-12 16:45:08', NULL),
(33, 'Guest Viewer', 'viewer', 'viewer@lgu.test', NULL, NULL, NULL, '$2y$12$uwcCeYFp3vLZKw2HOHrfpeH283z0B8sUPG.o6TbPWNyQJRsVdO/hO', 1, '2026-10-19 08:48:36', NULL, NULL, '2026-10-19 08:48:36', '2026-11-12 16:45:08', NULL),
(36, 'Maria Theresa Climaco', 'ocmclerk', 'mtclimaco.ocm@gmail.com', 1, '09171234501', '2026-10-20 13:57:40', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:40', 1, NULL, '2026-10-20 13:57:40', '2026-11-12 16:45:08', NULL),
(39, 'Ramon Enriquez', 'ocasclerk', 'ramon.enriquez.zc@gmail.com', 4, '09351234504', '2026-10-20 13:57:41', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:41', 1, NULL, '2026-10-20 13:57:41', '2026-11-12 16:45:08', NULL),
(40, 'Angelica Mae Navarro', 'chrmoclerk', 'angelicamae.navarro@gmail.com', 21, '09451234505', '2026-10-20 13:57:42', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:42', 1, NULL, '2026-10-20 13:57:42', '2026-11-12 16:45:08', NULL),
(42, 'Rhea Lyn Francisco', 'gsoclerk', 'rhealyn.francisco.gso@gmail.com', 8, '09661234507', '2026-10-20 13:57:42', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:42', 1, NULL, '2026-10-20 13:57:42', '2026-11-12 16:45:08', NULL),
(43, 'Carlo Miguel Saavedra', 'ocbclerk', 'cmsaavedra.budget@gmail.com', 9, '09771234508', '2026-10-20 13:57:43', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:43', 1, NULL, '2026-10-20 13:57:43', '2026-11-12 16:45:08', NULL),
(58, 'Arnel Go', 'paadclerk', 'arnel.go.paad@gmail.com', 26, '09451234523', '2026-10-20 13:57:48', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-20 13:57:48', 1, NULL, '2026-10-20 13:57:48', '2026-11-12 16:45:08', NULL),
(59, 'John Rey Wee', 'csdclerk', 'johnrey.wee.csd@gmail.com', 24, '09271234521', '2026-10-21 13:47:00', '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-10-21 13:47:00', 1, NULL, '2026-10-21 13:47:00', '2026-11-12 16:45:08', NULL),
(64, 'Juan dila', 'csdclerk2', 'juandela@gmail.com', 24, '09093392171', NULL, '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK', 1, '2026-11-05 16:46:24', 1, NULL, '2026-11-05 16:33:43', '2026-11-12 16:45:08', NULL),
(66, 'Franklin James I. Oliveros', 'gsoclerk2', NULL, 8, NULL, NULL, '$2y$12$.EPlmLXyBMTo7DTiouqUXuAicvdsDT0wGEIGHJXf5d0u30lcMg0My', 1, '2026-11-19 17:09:48', 1, NULL, '2026-11-19 17:09:48', '2026-11-19 17:09:48', 'clerk'),
(67, 'Sir Bry', 'csdadminaid', NULL, 24, NULL, NULL, '$2y$12$aXJowKTlvcyWzcd2wBwA6eT.t1GbRI18utDbsUWBU5czYSkBc2ZKm', 1, '2026-11-23 16:42:02', 10, NULL, '2026-11-23 16:42:02', '2026-11-23 16:42:02', 'Admin Aid');

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
(1, 1, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(2, 1, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(3, 1, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(4, 2, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 960, 1, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(5, 2, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 960, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(6, 2, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 960, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(7, 2, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 960, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(8, 2, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(9, 2, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(10, 2, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(11, 2, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 960, 0, 0, 1, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(12, 2, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(13, 2, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(14, 2, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(15, 2, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(16, 2, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 960, 0, 0, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(17, 2, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 960, 0, 1, 0, '2026-03-09 13:24:39', '2026-03-09 13:24:39', NULL),
(18, 3, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 15:49:26', '2026-03-09 15:49:26', NULL),
(19, 3, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 15:49:41', '2026-03-09 15:49:41', NULL),
(20, 4, NULL, 1, 'station_1', 'Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 15:56:26', '2026-03-09 15:56:26', NULL),
(21, 4, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 15:56:26', '2026-03-09 15:56:26', NULL),
(22, 5, NULL, 1, 'ridz', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-03-09 16:30:24', '2026-09-13 14:43:17', NULL),
(23, 5, NULL, 2, 'station_2', 'Station 2', NULL, NULL, 60, 0, 1, 0, '2026-03-09 16:30:24', '2026-03-09 16:30:24', NULL),
(38, 7, NULL, 1, 'create_pr', 'Create Purchase Request + Attach E-Signature', 'end_user', NULL, 960, 1, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(39, 7, NULL, 2, 'upload_drive', 'Upload to Google Drive (Get File Link)', 'end_user', NULL, 960, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(40, 7, NULL, 3, 'create_dts', 'Create DTS Transaction + Attach Drive Link', 'end_user', NULL, 960, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(41, 7, NULL, 4, 'email_gso', 'Email Document to GSO', 'end_user', NULL, 960, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(42, 7, NULL, 5, 'gso_input_pr_no', 'Input PR Number', 'gso', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(43, 7, NULL, 6, 'gso_return_esig', 'Return to End User to Re-attach E-Sig', 'gso', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(44, 7, NULL, 7, 'city_admin_sign', 'City Administrator Attaches E-Signature', 'city_admin', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(45, 7, NULL, 8, 'email_cto', 'Email Document to CTO', 'end_user', NULL, 960, 0, 0, 1, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(46, 7, NULL, 9, 'treasurer_sign', 'City Treasurer Attaches E-Signature', 'city_treasurer', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(47, 7, NULL, 10, 'email_cadmin', 'CTO Emails Document to CAdmin', 'cto', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(48, 7, NULL, 11, 'email_cbo', 'CAdmin Emails Document to CBO', 'cadmin', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(49, 7, NULL, 12, 'cbo_validate', 'CBO Downloads Valid & Untampered Document', 'cbo', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(50, 7, NULL, 13, 'cbo_earmark', 'CBO Prints & Fills Earmark Details', 'cbo', NULL, 960, 0, 0, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(51, 7, NULL, 14, 'submit_bac_paad', 'CBO Submits Documents to BAC-PAAD', 'bac_paad', NULL, 960, 0, 1, 0, '2026-09-11 12:07:42', '2026-09-11 12:07:42', NULL),
(70, 16, NULL, 1, 'communication_1', 'Communication Station 1', NULL, NULL, 60, 1, 0, 0, '2026-09-13 14:43:22', '2026-09-13 14:49:48', NULL),
(71, 16, NULL, 2, 'communication_2', 'Communication Station End', NULL, NULL, 60, 0, 1, 0, '2026-09-13 14:43:22', '2026-09-13 14:49:48', NULL),
(72, 17, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 0, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
(73, 17, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-09-13 16:53:40', '2026-09-24 11:04:24', NULL),
(74, 17, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-09-13 16:53:40', '2026-09-13 16:53:40', NULL),
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
(424, 67, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(425, 67, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
(426, 67, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-20 09:54:10', '2026-10-20 09:54:10', NULL),
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
(483, 75, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(484, 75, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(485, 75, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:08:11', '2026-10-27 09:08:11', NULL),
(486, 76, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(487, 76, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(488, 76, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:08:26', '2026-10-27 09:08:26', NULL),
(489, 77, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(490, 77, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(491, 77, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:09:57', '2026-10-27 09:09:57', NULL),
(492, 78, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(493, 78, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(494, 78, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:10:04', '2026-10-27 09:10:04', NULL),
(495, 79, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(496, 79, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(497, 79, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:10:15', '2026-10-27 09:10:15', NULL),
(498, 80, NULL, 1, 'collect_dtr', 'Collect DTR', 'HR', NULL, 960, 1, 0, 1, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(499, 80, NULL, 2, 'validate_dtr', 'Validate DTR', 'HR', 4, 960, 0, 0, 0, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL),
(500, 80, NULL, 3, 'finalize_payroll', 'Finalize Payroll', 'Accounting', NULL, 1440, 0, 1, 0, '2026-10-27 09:10:26', '2026-10-27 09:10:26', NULL);

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
  ADD KEY `audit_logs_actor_user_id_index` (`actor_user_id`),
  ADD KEY `audit_logs_actor_user_id_created_at_index` (`actor_user_id`,`created_at`),
  ADD KEY `audit_logs_module_action_created_at_index` (`module`,`action`,`created_at`),
  ADD KEY `audit_logs_office_id_created_at_index` (`office_id`,`created_at`),
  ADD KEY `audit_logs_transaction_id_created_at_index` (`transaction_id`,`created_at`),
  ADD KEY `audit_logs_created_at_index` (`created_at`),
  ADD KEY `audit_logs_actor_office_id_index` (`actor_office_id`),
  ADD KEY `audit_logs_module_index` (`module`),
  ADD KEY `audit_logs_action_index` (`action`),
  ADD KEY `audit_logs_office_id_index` (`office_id`),
  ADD KEY `audit_logs_transaction_id_index` (`transaction_id`),
  ADD KEY `audit_logs_step_run_id_index` (`step_run_id`),
  ADD KEY `audit_logs_request_id_index` (`request_id`);

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
  ADD UNIQUE KEY `roles_code_unique` (`code`),
  ADD KEY `roles_office_id_foreign` (`office_id`);

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
-- Indexes for table `transaction_officer_assignments`
--
ALTER TABLE `transaction_officer_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_officer_assignments_from_user_id_foreign` (`from_user_id`),
  ADD KEY `transaction_officer_assignments_to_user_id_foreign` (`to_user_id`),
  ADD KEY `transaction_officer_assignments_assigned_by_foreign` (`assigned_by`),
  ADD KEY `transaction_officer_assignments_transaction_id_id_index` (`transaction_id`,`id`),
  ADD KEY `transaction_officer_assignments_transaction_step_run_id_id_index` (`transaction_step_run_id`,`id`);

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
  ADD KEY `transaction_states_current_step_id_foreign` (`current_step_id`),
  ADD KEY `transaction_states_current_run_id_foreign` (`current_run_id`);

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
  ADD KEY `transaction_step_runs_to_step_id_received_at_index` (`to_step_id`,`received_at`),
  ADD KEY `transaction_step_runs_assigned_to_foreign` (`assigned_to`);

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
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=289;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=222;

--
-- AUTO_INCREMENT for table `transaction_checklist_checks`
--
ALTER TABLE `transaction_checklist_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `transaction_officer_assignments`
--
ALTER TABLE `transaction_officer_assignments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaction_requirement_checks`
--
ALTER TABLE `transaction_requirement_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaction_step_runs`
--
ALTER TABLE `transaction_step_runs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=277;

--
-- AUTO_INCREMENT for table `transaction_types`
--
ALTER TABLE `transaction_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

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
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE RESTRICT;

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
-- Constraints for table `transaction_officer_assignments`
--
ALTER TABLE `transaction_officer_assignments`
  ADD CONSTRAINT `transaction_officer_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_officer_assignments_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_officer_assignments_to_user_id_foreign` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transaction_officer_assignments_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_officer_assignments_transaction_step_run_id_foreign` FOREIGN KEY (`transaction_step_run_id`) REFERENCES `transaction_step_runs` (`id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `transaction_states_current_run_id_foreign` FOREIGN KEY (`current_run_id`) REFERENCES `transaction_step_runs` (`id`) ON DELETE SET NULL,
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
  ADD CONSTRAINT `transaction_step_runs_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL,
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
