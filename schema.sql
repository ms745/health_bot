-- Database Schema for Health Assistant Bot (PostgreSQL)

CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    language VARCHAR(50),
    contact VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    specialization VARCHAR(100),
    availability_status BOOLEAN DEFAULT TRUE
);

CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    floor INT,
    room_number VARCHAR(20),
    description TEXT
);

CREATE TABLE Appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patients(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id),
    appointment_time TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Scheduled'
);

CREATE TABLE Hospital_Map (
    node_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100),
    floor INT,
    coordinates_x FLOAT,
    coordinates_y FLOAT,
    qr_code_data TEXT
);

-- Seed Data
INSERT INTO Departments (name, floor, room_number, description) VALUES
('Cardiology', 1, '102', 'Heart and vascular care'),
('Neurology', 2, '205', 'Brain and nervous system'),
('Pediatrics', 1, '110', 'Child healthcare'),
('Emergency', 0, 'ER-1', 'Critical care');

INSERT INTO Doctors (name, department, specialization) VALUES
('Dr. Smith', 'Cardiology', 'Cardiologist'),
('Dr. Doe', 'Neurology', 'Neurologist');
