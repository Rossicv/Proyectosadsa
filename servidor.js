const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'leon.10404', 
    database: 'alma_quinta',
    port: 3306 
});

db.connect(err => {
    if (err) {
        console.error("Error conectando a la DB:", err.message);
        return;
    }
    console.log("¡Conectado a MySQL para Alma Quinta!");
});

app.post('/login', (req, res) => {
    const { email, password } = req.body;
    console.log(">>> Petición recibida para:", email);

    const sql = "SELECT * FROM usuarios WHERE email = ? AND password_hash = ?";
    
    db.query(sql, [email, password], (err, result) => {
        if (err) {
            console.error("Error en SQL:", err);
            return res.status(500).json({ status: "error", message: err.message });
        }
        
        if (result.length > 0) {
            console.log("✔ Acceso concedido a:", result[0].nombre);
            res.json({ status: "success", nombre: result[0].nombre });
        } else {
            console.log("✘ Credenciales no encontradas en la DB");
            res.json({ status: "fail", message: "Usuario no encontrado" });
        }
    });
});

// Ruta para guardar reportes de tareas
app.post('/guardar-reporte', (req, res) => {
    const { titulo, descripcion, usuarioNombre } = req.body;
    console.log(`>>> Guardando reporte de: ${usuarioNombre}`);

    const sqlUser = "SELECT id_usuario FROM usuarios WHERE nombre = ?";
    
    db.query(sqlUser, [usuarioNombre], (err, userResult) => {
        if (err || userResult.length === 0) {
            return res.status(500).json({ status: "error", message: "Usuario no encontrado" });
        }

        const id_usuario = userResult[0].id_usuario;
        const sqlInsert = "INSERT INTO reportes (id_usuario, titulo_tarea, descripcion) VALUES (?, ?, ?)";
        
        db.query(sqlInsert, [id_usuario, titulo, descripcion], (err, result) => {
            if (err) {
                return res.status(500).json({ status: "error", message: err.message });
            }
            res.json({ status: "success", message: "Reporte guardado" });
        });
    });
});

// ==========================================
// NUEVA RUTA PARA LEER TAREAS (AGREGADA AQUÍ)
// ==========================================
app.get('/obtener-reportes/:nombre', (req, res) => {
    const nombreUsuario = req.params.nombre;

    const sql = `
        SELECT r.titulo_tarea, r.descripcion, r.estado 
        FROM reportes r
        JOIN usuarios u ON r.id_usuario = u.id_usuario
        WHERE u.nombre = ?
        ORDER BY r.fecha_creacion DESC`;

    db.query(sql, [nombreUsuario], (err, results) => {
        if (err) {
            console.error("Error al obtener reportes:", err);
            return res.status(500).json({ status: "error", message: err.message });
        }
        res.json(results); 
    });
});
// ==========================================

app.listen(3000, () => {
    console.log("Servidor escuchando en el puerto 3000");
});