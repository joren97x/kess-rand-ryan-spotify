import mysql from 'mysql2'

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'spotify-chat'
})

export default db