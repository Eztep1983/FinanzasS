-- Crear la base de datos (opcional, puede depender de tu configuración)
CREATE DATABASE IF NOT EXISTS finanzas_cliente;
USE finanzas_cliente;

-- Tabla para los usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    fecha_registro DATE DEFAULT (CURRENT_DATE()),
    aporte_mensual DECIMAL(10, 2) NOT NULL
);

-- Tabla para la configuración de límites de aportes
CREATE TABLE configuracion_aportes (
    id_config INT AUTO_INCREMENT PRIMARY KEY,
    limite_inferior DECIMAL(10, 2) NOT NULL,
    limite_superior DECIMAL(10, 2) NOT NULL,
    fecha_ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para registrar los aportes mensuales
CREATE TABLE aportes (
    id_aporte INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_ingreso DATE DEFAULT (CURRENT_DATE()),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla unificada para los ingresos (múltiples y vehiculares)
CREATE TABLE ingresos (
    id_ingreso INT AUTO_INCREMENT PRIMARY KEY,
    tipo_ingreso ENUM('multiple', 'vehicular') NOT NULL,
    descripcion VARCHAR(255),
    monto DECIMAL(10, 2) NOT NULL,
    fecha_ingreso DATE DEFAULT (CURRENT_DATE())
);

-- Tabla para registrar los préstamos
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    monto_prestado DECIMAL(10, 2) NOT NULL,
    interes_mensual DECIMAL(5, 2) DEFAULT 2.00, -- Interés mensual del 2%
    fecha_inicio DATE DEFAULT (CURRENT_DATE()),
    fecha_final DATE,
    estado ENUM('activo', 'pagado', 'mora') DEFAULT 'activo',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Vista para calcular el monto total a pagar por préstamo
CREATE OR REPLACE VIEW vista_prestamos_totales AS
SELECT 
    p.id_prestamo,
    p.id_usuario,
    p.monto_prestado,
    p.interes_mensual,
    p.fecha_inicio,
    p.fecha_final,
    p.estado,
    (p.monto_prestado + (p.monto_prestado * (p.interes_mensual / 100))) AS monto_total_pagar
FROM prestamos p;

-- Tabla para registrar el cálculo mensual del interés total generado
CREATE TABLE intereses_generados (
    id_interes INT AUTO_INCREMENT PRIMARY KEY,
    total_interes_mes DECIMAL(10, 2) NOT NULL,
    fecha_calculo DATE DEFAULT (CURRENT_DATE())
);

-- Tabla para consolidar los ingresos totales
CREATE TABLE ingresos_totales (
    id_ingreso_total INT AUTO_INCREMENT PRIMARY KEY,
    monto_total DECIMAL(10, 2) NOT NULL,
    fecha_calculo DATE DEFAULT (CURRENT_DATE())
);

-- Vista para calcular ingresos totales del mes (suma de aportes e ingresos)
CREATE OR REPLACE VIEW vista_ingresos_totales AS
SELECT 
    IFNULL(SUM(a.monto), 0) AS total_aportes,
    IFNULL((SELECT SUM(i.monto) FROM ingresos i WHERE i.tipo_ingreso = 'multiple'), 0) AS total_multiples,
    IFNULL((SELECT SUM(i.monto) FROM ingresos i WHERE i.tipo_ingreso = 'vehicular'), 0) AS total_vehiculares,
    IFNULL(SUM(a.monto), 0) + 
    IFNULL((SELECT SUM(i.monto) FROM ingresos i WHERE i.tipo_ingreso = 'multiple'), 0) + 
    IFNULL((SELECT SUM(i.monto) FROM ingresos i WHERE i.tipo_ingreso = 'vehicular'), 0) AS total_general
FROM aportes a;

-- Insertar datos de prueba para un cálculo mensual de intereses
INSERT INTO intereses_generados (total_interes_mes, fecha_calculo)
SELECT 
    IFNULL(SUM(monto_prestado * (interes_mensual / 100)), 0), 
    CURRENT_DATE()
FROM prestamos;

-- Insertar ingresos consolidados
INSERT INTO ingresos_totales (monto_total, fecha_calculo)
SELECT total_general, CURRENT_DATE()
FROM vista_ingresos_totales;
