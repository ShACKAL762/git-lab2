-- =============================================
-- ХАБЫ (Hubs)
-- =============================================

CREATE TABLE hub_applicant (
    applicant_hk  CHAR(32)     PRIMARY KEY,       -- MD5 от бизнес-ключа
    applicant_bk  VARCHAR(50)  NOT NULL UNIQUE,   -- бизнес-ключ (паспорт)
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE hub_category (
    category_hk   CHAR(32)     PRIMARY KEY,
    category_bk   VARCHAR(10)  NOT NULL UNIQUE,   -- код категории
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE hub_driving_school (
    school_hk     CHAR(32)     PRIMARY KEY,
    school_bk     VARCHAR(50)  NOT NULL UNIQUE,   -- номер лицензии
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE hub_instructor (
    instructor_hk CHAR(32)     PRIMARY KEY,
    instructor_bk VARCHAR(50)  NOT NULL UNIQUE,   -- табельный номер
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE hub_application (
    application_hk CHAR(32)    PRIMARY KEY,
    application_bk VARCHAR(50) NOT NULL UNIQUE,   -- номер заявления
    load_date      TIMESTAMP   NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE hub_license (
    license_hk    CHAR(32)     PRIMARY KEY,
    license_bk    VARCHAR(50)  NOT NULL UNIQUE,   -- номер удостоверения
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual'
);

-- =============================================
-- ССЫЛКИ (Links)
-- =============================================

CREATE TABLE link_application_applicant (
    link_hk        CHAR(32) PRIMARY KEY,
    application_hk CHAR(32) NOT NULL REFERENCES hub_application(application_hk),
    applicant_hk   CHAR(32) NOT NULL REFERENCES hub_applicant(applicant_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE link_application_category (
    link_hk        CHAR(32) PRIMARY KEY,
    application_hk CHAR(32) NOT NULL REFERENCES hub_application(application_hk),
    category_hk    CHAR(32) NOT NULL REFERENCES hub_category(category_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE link_application_school (
    link_hk        CHAR(32) PRIMARY KEY,
    application_hk CHAR(32) NOT NULL REFERENCES hub_application(application_hk),
    school_hk      CHAR(32) NOT NULL REFERENCES hub_driving_school(school_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE link_school_instructor (
    link_hk        CHAR(32) PRIMARY KEY,
    school_hk      CHAR(32) NOT NULL REFERENCES hub_driving_school(school_hk),
    instructor_hk  CHAR(32) NOT NULL REFERENCES hub_instructor(instructor_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE link_license_applicant (
    link_hk        CHAR(32) PRIMARY KEY,
    license_hk     CHAR(32) NOT NULL REFERENCES hub_license(license_hk),
    applicant_hk   CHAR(32) NOT NULL REFERENCES hub_applicant(applicant_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

CREATE TABLE link_license_category (
    link_hk        CHAR(32) PRIMARY KEY,
    license_hk     CHAR(32) NOT NULL REFERENCES hub_license(license_hk),
    category_hk    CHAR(32) NOT NULL REFERENCES hub_category(category_hk),
    load_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual'
);

-- =============================================
-- САТЕЛЛИТЫ (Satellites)
-- =============================================

CREATE TABLE sat_applicant_details (
    applicant_hk  CHAR(32)     NOT NULL REFERENCES hub_applicant(applicant_hk),
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    last_name     VARCHAR(100) NOT NULL,
    first_name    VARCHAR(100) NOT NULL,
    middle_name   VARCHAR(100),
    birth_date    DATE         NOT NULL,
    phone         VARCHAR(20),
    email         VARCHAR(100),
    hash_diff     CHAR(32),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (applicant_hk, load_date)
);

CREATE TABLE sat_category_details (
    category_hk   CHAR(32)     NOT NULL REFERENCES hub_category(category_hk),
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    category_name VARCHAR(100) NOT NULL,
    description   TEXT,
    hash_diff     CHAR(32),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (category_hk, load_date)
);

CREATE TABLE sat_school_details (
    school_hk     CHAR(32)     NOT NULL REFERENCES hub_driving_school(school_hk),
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    school_name   VARCHAR(200) NOT NULL,
    address       VARCHAR(300),
    phone         VARCHAR(20),
    hash_diff     CHAR(32),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (school_hk, load_date)
);

CREATE TABLE sat_instructor_details (
    instructor_hk CHAR(32)     NOT NULL REFERENCES hub_instructor(instructor_hk),
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    last_name     VARCHAR(100) NOT NULL,
    first_name    VARCHAR(100) NOT NULL,
    middle_name   VARCHAR(100),
    phone         VARCHAR(20),
    hash_diff     CHAR(32),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (instructor_hk, load_date)
);

CREATE TABLE sat_application_details (
    application_hk   CHAR(32)  NOT NULL REFERENCES hub_application(application_hk),
    load_date        TIMESTAMP NOT NULL DEFAULT NOW(),
    application_date TIMESTAMP NOT NULL,
    status           VARCHAR(20) NOT NULL,
    comments         TEXT,
    hash_diff        CHAR(32),
    record_source    VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (application_hk, load_date)
);

CREATE TABLE sat_license_details (
    license_hk    CHAR(32)     NOT NULL REFERENCES hub_license(license_hk),
    load_date     TIMESTAMP    NOT NULL DEFAULT NOW(),
    issue_date    DATE         NOT NULL,
    expiry_date   DATE         NOT NULL,
    issued_by     VARCHAR(200),
    status        VARCHAR(20)  NOT NULL,
    hash_diff     CHAR(32),
    record_source VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (license_hk, load_date)
);

CREATE TABLE sat_medical_certificate (
    applicant_hk         CHAR(32) NOT NULL REFERENCES hub_applicant(applicant_hk),
    load_date            TIMESTAMP NOT NULL DEFAULT NOW(),
    issue_date           DATE NOT NULL,
    expiry_date          DATE NOT NULL,
    medical_organization VARCHAR(200),
    conclusion           VARCHAR(100),
    hash_diff            CHAR(32),
    record_source        VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (applicant_hk, load_date)
);

CREATE TABLE sat_exam (
    application_hk CHAR(32)     NOT NULL REFERENCES hub_application(application_hk),
    load_date      TIMESTAMP    NOT NULL DEFAULT NOW(),
    exam_type      VARCHAR(20)  NOT NULL,
    exam_date      TIMESTAMP    NOT NULL,
    result         VARCHAR(10)  NOT NULL,
    score          INT,
    inspector_name VARCHAR(200),
    hash_diff      CHAR(32),
    record_source  VARCHAR(100) NOT NULL DEFAULT 'manual',
    PRIMARY KEY (application_hk, load_date)
);