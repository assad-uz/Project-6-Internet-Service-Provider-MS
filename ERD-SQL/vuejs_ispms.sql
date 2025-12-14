-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 14, 2025 at 09:54 PM
-- Server version: 10.11.15-MariaDB
-- PHP Version: 8.4.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `assaduzt_ispms`
--

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE `areas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Mirpur-10', '2025-11-18 23:50:52', '2025-11-18 23:50:52'),
(2, 'Mirpur-2', '2025-11-18 23:51:00', '2025-11-18 23:51:00'),
(3, 'Mirpur-1', '2025-11-18 23:51:18', '2025-11-18 23:51:18'),
(4, 'Mirpur-12', '2025-11-18 23:51:39', '2025-11-18 23:51:39');

-- --------------------------------------------------------

--
-- Table structure for table `billings`
--

CREATE TABLE `billings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `connection_id` bigint(20) UNSIGNED NOT NULL,
  `package_id` bigint(20) UNSIGNED NOT NULL,
  `billing_month` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `due_date` date NOT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('unpaid','paid','partially_paid','cancelled') NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `billings`
--

INSERT INTO `billings` (`id`, `customer_id`, `connection_id`, `package_id`, `billing_month`, `amount`, `due_date`, `discount`, `status`, `created_at`, `updated_at`) VALUES
(3, 2, 2, 5, '2025-11-01', 1500.00, '2025-11-10', 0.00, 'paid', '2025-11-19 08:35:21', '2025-12-02 05:35:01');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `connections`
--

CREATE TABLE `connections` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `package_id` bigint(20) UNSIGNED NOT NULL,
  `distribution_box_id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `mac_address` varchar(20) DEFAULT NULL,
  `box_port_number` smallint(5) UNSIGNED DEFAULT NULL,
  `connection_type` enum('Optical Fiber','CAT-5','UTP') NOT NULL,
  `connection_date` date NOT NULL,
  `status` enum('active','suspended','terminated') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `connections`
--

INSERT INTO `connections` (`id`, `customer_id`, `package_id`, `distribution_box_id`, `username`, `password`, `ip_address`, `mac_address`, `box_port_number`, `connection_type`, `connection_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 1, 'swiftNet@sifat', '12341234', '172.168.1.1', '00:1A:2B:3C:4D:5E', 8080, 'Optical Fiber', '2025-11-19', 'active', '2025-11-18 23:57:39', '2025-11-18 23:58:30'),
(2, 2, 5, 2, 'swiftNet@hares', '12341234', '172.168.1.1', '00:1A:2B:3C:4D:5E', 8080, 'Optical Fiber', '2025-11-19', 'active', '2025-11-18 23:58:14', '2025-11-18 23:58:14');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text NOT NULL,
  `area_id` bigint(20) UNSIGNED NOT NULL,
  `customer_type_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `email`, `address`, `area_id`, `customer_type_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Sifat Hossain', '01515-255355', 'sifat@gmail.com', 'House No: 17/C/1', 2, 1, 'active', '2025-11-18 23:53:54', '2025-11-18 23:53:54'),
(2, 'Hares Islam', '01515-255256', 'hares@gmail.com', 'House No: 17/C/2', 1, 1, 'active', '2025-11-18 23:56:41', '2025-11-18 23:56:41');

-- --------------------------------------------------------

--
-- Table structure for table `customer_types`
--

CREATE TABLE `customer_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_types`
--

INSERT INTO `customer_types` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Residential', '2025-11-18 23:48:10', '2025-11-18 23:48:10'),
(2, 'SME', '2025-11-18 23:48:20', '2025-11-18 23:48:20'),
(3, 'Corporate', '2025-11-18 23:48:29', '2025-11-18 23:48:29');

-- --------------------------------------------------------

--
-- Table structure for table `distribution_boxes`
--

CREATE TABLE `distribution_boxes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `box_code` varchar(50) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `area_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `distribution_boxes`
--

INSERT INTO `distribution_boxes` (`id`, `box_code`, `name`, `area_id`, `created_at`, `updated_at`) VALUES
(1, 'M2-SP-001', 'South Pirerbag', 2, '2025-11-18 23:52:16', '2025-11-18 23:52:16'),
(2, 'M10-SA-001', 'Shah Ali', 1, '2025-11-18 23:52:31', '2025-11-18 23:52:31');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_10_20_045618_create_packages_table', 1),
(5, '2025_11_01_045440_create_customer_types_table', 1),
(6, '2025_11_01_083847_create_areas_table', 1),
(7, '2025_11_01_090221_create_distribution_boxes_table', 1),
(8, '2025_11_01_093153_create_customers_table', 1),
(9, '2025_11_01_122741_create_connections_table', 1),
(10, '2025_11_01_171610_create_billings_table', 1),
(11, '2025_11_01_172753_create_payments_table', 1),
(12, '2025_11_15_075451_create_newsletter_subscriptions_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `newsletter_subscriptions`
--

CREATE TABLE `newsletter_subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `is_confirmed` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `newsletter_subscriptions`
--

INSERT INTO `newsletter_subscriptions` (`id`, `email`, `is_confirmed`, `created_at`, `updated_at`) VALUES
(6, 'akib@gmail.com', 1, '2025-11-18 22:56:38', '2025-11-18 22:56:38'),
(8, 'Rafi@gmail.com', 1, '2025-11-18 22:56:54', '2025-11-18 22:56:54');

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `package_code` varchar(10) NOT NULL,
  `package_name` varchar(100) NOT NULL,
  `speed` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`id`, `package_code`, `package_name`, `speed`, `price`, `created_at`, `updated_at`) VALUES
(2, 'P-01', 'Bronze Pack', '15', 600.00, '2025-11-18 23:48:47', '2025-11-18 23:48:47'),
(3, 'P-02', 'Silver Pack', '20', 800.00, '2025-11-18 23:49:00', '2025-11-18 23:49:00'),
(4, 'P-03', 'Gold Pack', '30', 1000.00, '2025-11-18 23:49:29', '2025-11-18 23:50:08'),
(5, 'P-04', 'Platinum Pack', '60', 1500.00, '2025-11-18 23:50:24', '2025-11-18 23:50:24');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `billing_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `collected_by` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_method` enum('cash','bKash','card','bank') NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT '2025-11-17 21:13:48',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `billing_id`, `customer_id`, `collected_by`, `payment_method`, `transaction_id`, `amount`, `payment_date`, `created_at`, `updated_at`) VALUES
(3, 3, 2, 2, 'cash', 'xauy63gkiogb', 1500.00, '2025-12-02 00:00:00', '2025-12-02 05:35:01', '2025-12-02 05:35:01');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('5UCxKV4Xx3lzPn5e1n97hf5NAvKlNjTuszCBrf6y', NULL, '143.110.209.179', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlR6TG1TMmx4cW9HbmJ0aE1NMlZZSk1FY241bjNyWEF1NTVRbGlyUyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly93d3cubGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1764922131),
('6bF01CTR132daMLBLPwN0sbHuKDsS54jt5MP8zzp', NULL, '114.130.89.114', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMW5WekdsUFRkazFReFhYa3RNazdqVmI4TmljYXR2SWs5YUxBRTV4TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly9sYXJhdmVsLWlzcG1zLmFzc2FkLXV6LnRvcC9jdXN0b21lcl90eXBlcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1764653910),
('aoeIH8cgHfo3nePd8WH4cKFpF9B7jdhYmbxvq7hQ', NULL, '103.59.38.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36 EdgA/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidXNHazJ5T2pRMU9lNGRSQmJLcGZ3RjlCcGZQY21hSVB4U3ZMRDVtdyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vbGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1765113692),
('f6f2GhUqXq0psvOPuKXPBlB3w6F90TCAInxkUQxC', NULL, '103.59.38.37', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlVtWHJ5TGlxU2pscjJYNEczeWJTUVQxb0t3ak5reGpUeFE3ancwSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDU6Imh0dHBzOi8vbGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AvbmV3c2xldHRlciI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1765113966),
('niLCU2d4KoOKckWsciRWseBnBpSbp0h24ThnjWVR', NULL, '143.110.209.179', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibTFPYWd4MGY4MHZDV0d6c3BJVlN6cjNRWTI1eE0ydThMN290bldVOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHBzOi8vd3d3LmxhcmF2ZWwtaXNwbXMuYXNzYWQtdXoudG9wIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1764922131),
('QMmZ2IAqJrydqSbU7CfhGhztTufggeUvgNqHEpTn', NULL, '74.7.227.31', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.3; +https://openai.com/gptbot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZzVUZ0Z6SUtJdVN5b2JuNENVdEE2TUpTaDZYYnl6akNMWkYxTmc3RCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vbGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1765189390),
('SnJaqyV1Qmrl9oju67Q0rp1nQfCArg8TAAw26a8z', NULL, '44.222.20.176', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRFRRUEVzeURHRFQ2UlREeFZhSzVkWFZwQTdRWFNsUEdyS2phZXRIQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vbGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1764660317),
('VoAoYdW5Aa4iFCk3t2HqDB0anf8iFRagFlTyEcCL', NULL, '34.244.239.30', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia1Y1dTVnZTFmcUpZc0tDZHpXZHpDNU5BZjhEaDVDQXc1ZzNJbzBMMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHBzOi8vd3d3LmxhcmF2ZWwtaXNwbXMuYXNzYWQtdXoudG9wIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1765721785),
('XT6nIibqvG1EKt7XfVt9AKaMpDzCqNtkFdmNmffk', NULL, '103.59.38.37', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ0NFd1lCa0k1dzZrdVViTlpxQUNpc0RWUk15R0JYMWZmRUg2ZUozTyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vbGFyYXZlbC1pc3Btcy5hc3NhZC11ei50b3AiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1765127154);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','manager','technician') NOT NULL DEFAULT 'technician',
  `avatar` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `phone`, `email`, `email_verified_at`, `password`, `role`, `avatar`, `remember_token`, `created_at`, `updated_at`, `last_login_at`) VALUES
(1, 'Assaduzzaman Shaon', '01234-567890', 'admin@assad.com', NULL, '$2y$12$0vUkUJg0LxYsfx5wb4q6JufM.e4JebomddU3jW8xtmzpegNeb6Xni', 'admin', 'avatars/DT2UnVkYqdtAtGWgVLUCQ5CwX4wCl7a2Z9lePBtN.jpg', NULL, '2025-11-17 21:19:32', '2025-11-17 21:19:32', NULL),
(2, 'Akib Hossain', '01515-255453', 'akib@assad.com', NULL, '$2y$12$m9YuMUabksJVHgR48bnOlubqXHNj5wl.HNAslks23rUmZqgrnt4ve', 'manager', 'avatars/mMOWKGfKHdbSzWGB5qVaKA5QfCMrrIuoFrXtwPIG.jpg', NULL, '2025-11-18 23:45:58', '2025-11-18 23:45:58', NULL),
(3, 'Hares Islam', '01515-545245', 'hares@assad.com', NULL, '$2y$12$aazPKW0//oWfY6h3ZdcpzuOcYyHqQwIpdPdP/YRjGD186tdZ.GdN6', 'technician', 'avatars/x8LIf5BZWMRDWDiLAcv5O3un8BY7A4FLDW8jVDYr.jpg', NULL, '2025-11-18 23:46:51', '2025-11-18 23:46:51', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `areas_name_unique` (`name`);

--
-- Indexes for table `billings`
--
ALTER TABLE `billings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_connection_month` (`connection_id`,`billing_month`),
  ADD KEY `billings_customer_id_foreign` (`customer_id`),
  ADD KEY `billings_package_id_foreign` (`package_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `connections`
--
ALTER TABLE `connections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `connections_username_unique` (`username`),
  ADD KEY `connections_customer_id_foreign` (`customer_id`),
  ADD KEY `connections_package_id_foreign` (`package_id`),
  ADD KEY `connections_distribution_box_id_foreign` (`distribution_box_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_phone_unique` (`phone`),
  ADD UNIQUE KEY `customers_email_unique` (`email`),
  ADD KEY `customers_area_id_foreign` (`area_id`),
  ADD KEY `customers_customer_type_id_foreign` (`customer_type_id`);

--
-- Indexes for table `customer_types`
--
ALTER TABLE `customer_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_types_name_unique` (`name`);

--
-- Indexes for table `distribution_boxes`
--
ALTER TABLE `distribution_boxes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `distribution_boxes_box_code_unique` (`box_code`),
  ADD KEY `distribution_boxes_area_id_foreign` (`area_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

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
-- Indexes for table `newsletter_subscriptions`
--
ALTER TABLE `newsletter_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `newsletter_subscriptions_email_unique` (`email`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `packages_package_code_unique` (`package_code`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_billing_id_foreign` (`billing_id`),
  ADD KEY `payments_customer_id_foreign` (`customer_id`),
  ADD KEY `payments_collected_by_foreign` (`collected_by`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `areas`
--
ALTER TABLE `areas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `billings`
--
ALTER TABLE `billings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `connections`
--
ALTER TABLE `connections`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_types`
--
ALTER TABLE `customer_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `distribution_boxes`
--
ALTER TABLE `distribution_boxes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `newsletter_subscriptions`
--
ALTER TABLE `newsletter_subscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billings`
--
ALTER TABLE `billings`
  ADD CONSTRAINT `billings_connection_id_foreign` FOREIGN KEY (`connection_id`) REFERENCES `connections` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `billings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `billings_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `connections`
--
ALTER TABLE `connections`
  ADD CONSTRAINT `connections_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `connections_distribution_box_id_foreign` FOREIGN KEY (`distribution_box_id`) REFERENCES `distribution_boxes` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `connections_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_area_id_foreign` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `customers_customer_type_id_foreign` FOREIGN KEY (`customer_type_id`) REFERENCES `customer_types` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `distribution_boxes`
--
ALTER TABLE `distribution_boxes`
  ADD CONSTRAINT `distribution_boxes_area_id_foreign` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_billing_id_foreign` FOREIGN KEY (`billing_id`) REFERENCES `billings` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_collected_by_foreign` FOREIGN KEY (`collected_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
