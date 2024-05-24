import db from '../config/database.js'

export const getAllMessages = (req, res) => {
    db.query("SELECT messages.*, users.username, users.name FROM messages INNER JOIN users ON messages.user_id = users.id", (err, result) => {
        if(err) {
            console.log(err)
            res.send(err)
        }
        else {
            res.json(result)
        }
    })
}

export const storeMessage = (req, res) => {
    console.log(req.body)
    db.query("INSERT INTO messages SET ?", req.body, (err, result) => {
        if(err) {
            console.log(err)
            return res.status(500).json({ message: "Sorry something went wrong." })
        }
        else {
            console.log(result)
            return res.status(201).json({ message: 'Message sent successfully' })
        }
    })
}

export const deleteMessage = (req, res) => {
    console.log(req.params)
    db.query("UPDATE messages SET deleted_at = NOW() WHERE id = ?", req.params.id, (err, result) => {
        if(err) {
            console.log(err)
            return res.status(500).json({ message: "Sorry something went wrong." })
        }
        else {
            console.log(result)
            return res.status(201).json({ message: 'Message deleted successfully' })
        }
    })
}