import express from 'express';
import { pool } from '../server.js';

const router = express.Router()

router.post('/:setId', async (req, res) => {
    const {setId} = req.params
    const { question, answer } = req.body
    
    try {
        const { rows } = await pool.query(
            'INSERT INTO cards (question, answer, set_id) VALUES ($1, $2, $3) RETURNING *',
            [question, answer, setId]
        );

       

        res.json(rows[0]);
    } catch (error) {

        res.status(500).json({error: error.message})
        
    }
})

router.get('/set/:setId', async (req, res) => {
    const { setId } = req.params;
    try {
        const { rows } = await pool.query(
            'SELECT * FROM cards WHERE set_id = $1 ORDER BY id ASC',
            [setId]
        );
        res.json(rows);
    } catch (error) {
        res.status(500).json({error: error.message})
    }
})

// router.get('full-set/:setId', async (req, res) => {
//     const { setId } = req.params;
//     try {
//         const query = `
//         SELECT f.name AS set_name, f.detail AS set_detail, c_id AS card_id, c.question, c.answer
//         FROM flashsets f
//         LEFT JOIN cards c ON f.id = c.set_id
//         WHERE f.id = $1
//         `;

//         const { rows } = pool.query(query, [setId]);

//         if (rows.)
//     }
// })



export default router