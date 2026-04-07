CREATE DATABASE IF NOT EXISTS alma_quinta;
USE alma_quinta;

-- 2. Ahora sí, borrar la tabla si existía de pruebas anteriores
DROP TABLE IF EXISTS usuarios;

-- 3. Crear la tabla definitiva
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'usuario') DEFAULT 'usuario',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

USE alma_quinta;

-- Limpiamos la tabla para insertar los datos con los cargos específicos
TRUNCATE TABLE usuarios;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'leon.10404';
FLUSH PRIVILEGES;

-- Insertando al equipo con su Rol/Cargo como nombre
INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES 
('Ingenier@ de Sistemas', 'sistemas@alma.com', 'pass123', 'admin'),
('Jefe de Proyectos Digitales', 'proyectos@alma.com', 'pass123', 'admin'),
('Desarrollador Backend', 'backend@alma.com', 'pass123', 'usuario'),
('Desarrollador de Software', 'software@alma.com', 'pass123', 'usuario'),
('Contadora', 'contabilidad@alma.com', 'pass123', 'usuario'),
('Ejecutiva Comercial', 'comercial@alma.com', 'pass123', 'usuario'),
('Marketing Digital 1', 'mkt1@alma.com', 'pass123', 'usuario'),
('Diseñadora UX/UI', 'uxui@alma.com', 'pass123', 'usuario'),
('Marketing Digital 2', 'mkt2@alma.com', 'pass123', 'usuario'),
('Desarrollador Frontend', 'frontend@alma.com', 'pass123', 'usuario'),
('Desarrollador Full Stack', 'fullstack@alma.com', 'pass123', 'usuario'),
('Ingeniero de Ciberseguridad', 'seguridad@alma.com', 'pass123', 'usuario');



-- ======================================================
-- CREACIÓN DE LA TABLA DE REPORTES (PARA EL CHATBOT)
-- ======================================================

CREATE TABLE reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT, 
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    estado ENUM('pendiente', 'en proceso', 'finalizado') DEFAULT 'pendiente',
    evidencia_url VARCHAR(255), 
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Esto vincula el reporte con el usuario que lo creó
    CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Insertamos un reporte de prueba asignado al 'Ingeniero de Sistemas' (ID 1)
INSERT INTO reportes (id_usuario, titulo, descripcion, estado) VALUES 
(1, 'Prueba de Sistema', 'Reporte inicial para verificar la conexión con la base de datos.', 'en proceso');