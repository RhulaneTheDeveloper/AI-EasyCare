-- ===================================================
-- AI EASYCARE DATABASE SCHEMA
-- Healthcare Medication Reminder & AI Assistant
-- ===================================================

-- Create Users Table
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(10),
  role ENUM('PATIENT', 'CAREGIVER', 'HEALTHCARE_PROVIDER', 'ADMIN') NOT NULL DEFAULT 'PATIENT',
  status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  profile_picture_url VARCHAR(500),
  bio TEXT,
  address VARCHAR(255),
  city VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  language_preference VARCHAR(50) DEFAULT 'en',
  notification_preference ENUM('EMAIL', 'SMS', 'PUSH', 'ALL') DEFAULT 'ALL',
  two_factor_enabled BOOLEAN DEFAULT FALSE,
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_role (role),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Caregiver-Patient Relationships Table
CREATE TABLE caregiver_patient_relationships (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  caregiver_id BIGINT NOT NULL,
  patient_id BIGINT NOT NULL,
  relationship_type VARCHAR(100) NOT NULL,
  access_level ENUM('VIEW_ONLY', 'MANAGE_MEDICATIONS', 'FULL_ACCESS') DEFAULT 'MANAGE_MEDICATIONS',
  notes TEXT,
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ended_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (caregiver_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_relationship (caregiver_id, patient_id),
  INDEX idx_caregiver (caregiver_id),
  INDEX idx_patient (patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Medications Table
CREATE TABLE medications (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  medication_name VARCHAR(255) NOT NULL,
  generic_name VARCHAR(255),
  dosage_amount DECIMAL(10, 2),
  dosage_unit VARCHAR(50),
  frequency VARCHAR(100),
  frequency_type ENUM('DAILY', 'WEEKLY', 'MONTHLY', 'CUSTOM') DEFAULT 'DAILY',
  times_per_day INT,
  instruction_times VARCHAR(255),
  route_of_administration VARCHAR(50),
  duration_type ENUM('INDEFINITE', 'TEMPORARY', 'AS_NEEDED') DEFAULT 'INDEFINITE',
  start_date DATE NOT NULL,
  end_date DATE,
  reason_for_use TEXT,
  side_effects TEXT,
  contraindications TEXT,
  refill_reminder_days INT DEFAULT 7,
  medication_image_url VARCHAR(500),
  barcode VARCHAR(100),
  status ENUM('ACTIVE', 'INACTIVE', 'COMPLETED', 'DISCONTINUED') DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_start_date (start_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Medication Schedules Table
CREATE TABLE medication_schedules (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  medication_id BIGINT NOT NULL,
  scheduled_time TIME NOT NULL,
  day_of_week INT,
  reminder_before_minutes INT DEFAULT 15,
  reminder_enabled BOOLEAN DEFAULT TRUE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
  INDEX idx_medication (medication_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Medication History Table
CREATE TABLE medication_history (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  medication_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  scheduled_date DATE NOT NULL,
  scheduled_time TIME NOT NULL,
  status ENUM('TAKEN', 'MISSED', 'SKIPPED', 'PENDING') DEFAULT 'PENDING',
  actual_time TIMESTAMP NULL,
  confirmed_by_user_id BIGINT,
  confirmation_method ENUM('MANUAL', 'VOICE', 'BIOMETRIC', 'CAREGIVER_CONFIRM') DEFAULT 'MANUAL',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (confirmed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_medication (medication_id),
  INDEX idx_scheduled_date (scheduled_date),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Prescriptions Table
CREATE TABLE prescriptions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  medication_id BIGINT NOT NULL,
  prescribed_by_name VARCHAR(255),
  prescribed_by_license VARCHAR(100),
  healthcare_provider_id BIGINT,
  prescription_date DATE NOT NULL,
  valid_from DATE NOT NULL,
  valid_until DATE NOT NULL,
  quantity INT,
  refills_allowed INT,
  refills_used INT DEFAULT 0,
  notes TEXT,
  file_url VARCHAR(500),
  file_type VARCHAR(50),
  status ENUM('ACTIVE', 'EXPIRED', 'USED_UP', 'CANCELLED') DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
  FOREIGN KEY (healthcare_provider_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_medication (medication_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Alerts Table
CREATE TABLE alerts (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  alert_type ENUM('MISSED_DOSE', 'REFILL_NEEDED', 'PRESCRIPTION_EXPIRED', 'HEALTH_WARNING', 'APPOINTMENT_REMINDER', 'GENERAL_ALERT') NOT NULL,
  medication_id BIGINT,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
  is_read BOOLEAN DEFAULT FALSE,
  is_acknowledged BOOLEAN DEFAULT FALSE,
  action_required BOOLEAN DEFAULT FALSE,
  action_url VARCHAR(500),
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL,
  acknowledged_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_alert_type (alert_type),
  INDEX idx_is_read (is_read),
  INDEX idx_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Notifications Table
CREATE TABLE notifications (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  notification_type ENUM('MEDICATION_REMINDER', 'ALERT', 'MESSAGE', 'APPOINTMENT', 'ACHIEVEMENT') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  delivery_method ENUM('EMAIL', 'SMS', 'PUSH', 'IN_APP') NOT NULL,
  is_sent BOOLEAN DEFAULT FALSE,
  sent_at TIMESTAMP NULL,
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_is_sent (is_sent),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create AI Chatbot Conversations Table
CREATE TABLE ai_conversations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  conversation_title VARCHAR(255),
  start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  end_time TIMESTAMP NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create AI Chat Messages Table
CREATE TABLE ai_chat_messages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  conversation_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  sender_type ENUM('USER', 'AI') NOT NULL,
  message TEXT NOT NULL,
  intent VARCHAR(100),
  confidence_score DECIMAL(3, 2),
  medication_mentioned BIGINT,
  health_advice_given TEXT,
  requires_human_review BOOLEAN DEFAULT FALSE,
  reviewed_by_provider BOOLEAN DEFAULT FALSE,
  reviewed_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (medication_mentioned) REFERENCES medications(id) ON DELETE SET NULL,
  INDEX idx_conversation (conversation_id),
  INDEX idx_user (user_id),
  INDEX idx_sender_type (sender_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Health Records Table
CREATE TABLE health_records (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  record_type ENUM('BLOOD_PRESSURE', 'BLOOD_GLUCOSE', 'HEART_RATE', 'WEIGHT', 'TEMPERATURE', 'CUSTOM') NOT NULL,
  value DECIMAL(10, 2) NOT NULL,
  unit VARCHAR(50),
  notes TEXT,
  recorded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_record_type (record_type),
  INDEX idx_recorded_date (recorded_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Achievements/Milestones Table
CREATE TABLE achievements (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  achievement_type ENUM('DAYS_STREAK', 'PERFECT_ADHERENCE', 'MILESTONE_DAYS', 'CUSTOM') NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  badge_icon_url VARCHAR(500),
  milestone_value INT,
  achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_achievement_type (achievement_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Audit Logs Table
CREATE TABLE audit_logs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,
  action VARCHAR(255) NOT NULL,
  entity_type VARCHAR(100),
  entity_id BIGINT,
  old_values JSON,
  new_values JSON,
  ip_address VARCHAR(50),
  user_agent VARCHAR(500),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_action (action),
  INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Emergency Contacts Table
CREATE TABLE emergency_contacts (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  contact_name VARCHAR(255) NOT NULL,
  relationship VARCHAR(100),
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(255),
  is_primary BOOLEAN DEFAULT FALSE,
  notify_on_missed_dose BOOLEAN DEFAULT TRUE,
  notify_on_critical_alert BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Appointments Table
CREATE TABLE appointments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  healthcare_provider_id BIGINT,
  appointment_type VARCHAR(100),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  duration_minutes INT DEFAULT 30,
  location VARCHAR(255),
  status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW') DEFAULT 'SCHEDULED',
  reminder_sent BOOLEAN DEFAULT FALSE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (healthcare_provider_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_appointment_date (appointment_date),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Medication Refills Table
CREATE TABLE medication_refills (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  medication_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  refill_date DATE NOT NULL,
  refill_status ENUM('PENDING', 'APPROVED', 'DISPENSED', 'REJECTED') DEFAULT 'PENDING',
  pharmacy_name VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_medication (medication_id),
  INDEX idx_refill_status (refill_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Device Tokens Table (for push notifications)
CREATE TABLE device_tokens (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  device_token VARCHAR(500) NOT NULL UNIQUE,
  device_type ENUM('iOS', 'ANDROID', 'WEB') NOT NULL,
  device_name VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_device_token (device_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================================================
-- END OF INITIAL SCHEMA
-- ===================================================
