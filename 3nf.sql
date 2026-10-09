-- 1. Справочник категорий водительских прав
CREATE TABLE category (
    category_id     SERIAL PRIMARY KEY,
    category_code   VARCHAR(10)  NOT NULL UNIQUE,
    category_name   VARCHAR(100) NOT NULL,
    description     TEXT
);

-- 2. Справочник автошкол
CREATE TABLE driving_school (
    school_id       SERIAL PRIMARY KEY,
    school_name     VARCHAR(200) NOT NULL,
    address         VARCHAR(300),
    phone           VARCHAR(20),
    license_number  VARCHAR(50)  NOT NULL UNIQUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 3. Кандидаты (заявители)
CREATE TABLE applicant (
    applicant_id    SERIAL PRIMARY KEY,
    last_name       VARCHAR(100) NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    middle_name     VARCHAR(100),
    birth_date      DATE         NOT NULL,
    passport_series VARCHAR(10)  NOT NULL,
    passport_number VARCHAR(20)  NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
    UNIQUE (passport_series, passport_number)
);

-- 4. Инструкторы
CREATE TABLE instructor (
    instructor_id   SERIAL PRIMARY KEY,
    school_id       INT NOT NULL REFERENCES driving_school(school_id),
    last_name       VARCHAR(100) NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    middle_name     VARCHAR(100),
    phone           VARCHAR(20)
);

-- 5. Медицинские справки
CREATE TABLE medical_certificate (
    medical_cert_id       SERIAL PRIMARY KEY,
    applicant_id          INT NOT NULL REFERENCES applicant(applicant_id),
    issue_date            DATE NOT NULL,
    expiry_date           DATE NOT NULL,
    medical_organization  VARCHAR(200),
    conclusion            VARCHAR(100),
    created_at            TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (expiry_date > issue_date)
);

-- 6. Заявления на получение прав
CREATE TABLE application (
    application_id   SERIAL PRIMARY KEY,
    applicant_id     INT NOT NULL REFERENCES applicant(applicant_id),
    category_id      INT NOT NULL REFERENCES category(category_id),
    school_id        INT REFERENCES driving_school(school_id),
    application_date TIMESTAMP NOT NULL DEFAULT NOW(),
    status           VARCHAR(20) NOT NULL DEFAULT 'submitted'
                     CHECK (status IN ('submitted','approved','rejected','completed')),
    comments         TEXT
);

-- 7. Экзамены
CREATE TABLE exam (
    exam_id         SERIAL PRIMARY KEY,
    application_id  INT NOT NULL REFERENCES application(application_id),
    exam_type       VARCHAR(20) NOT NULL CHECK (exam_type IN ('theory','practice')),
    exam_date       TIMESTAMP NOT NULL,
    result          VARCHAR(10) NOT NULL CHECK (result IN ('pass','fail')),
    score           INT CHECK (score >= 0),
    inspector_name  VARCHAR(200)
);

-- 8. Водительские удостоверения
CREATE TABLE license (
    license_id      SERIAL PRIMARY KEY,
    applicant_id    INT NOT NULL REFERENCES applicant(applicant_id),
    category_id     INT NOT NULL REFERENCES category(category_id),
    license_number  VARCHAR(50) NOT NULL UNIQUE,
    issue_date      DATE NOT NULL,
    expiry_date     DATE NOT NULL,
    issued_by       VARCHAR(200),
    status          VARCHAR(20) NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active','suspended','revoked')),
    CHECK (expiry_date > issue_date)
);