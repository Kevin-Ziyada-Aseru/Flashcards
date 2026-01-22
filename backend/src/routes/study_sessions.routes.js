import express from 'express'
import { pool } from '../server.js'


const router = express.Router();

router.post('/', async (req, res) =>
{
    const { set_id, total_cards, correct_count, wrong_count } = req.body;
    
    try {
        const { rows } = await pool.query(
            `INSERT INTO study_sessions (set_id, total_cards, correct_count, wrong_count) 
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [set_id, total_cards, correct_count, wrong_count]
        )
        res.status(201).json(rows[0]);
        
    } catch (error) {
        res.status(500).json({error: error.message})
        
    }

})

router.get('/set/:setId', async (req, res) => {
    const { setId } = req.params;
    try {

        const { rows } = await pool.query(
            'SELECT * FROM study_sessions WHERE set_id = $1 ORDER BY created_at DESC',
            [setId]
        );

        res.json(rows);
        
    } catch (error) {
        res.status(500).json({error: error.message})
        
    }
})

export default router
