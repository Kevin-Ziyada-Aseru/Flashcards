import express from 'express';
import { pool } from '../server.js';

const router = express.Router()
// Create a new card in a specific set
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

// Get all cards for a specific set
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

// Get full set details including cards
router.get('/full-set/:setId', async (req, res) => {
    const { setId } = req.params;
    try {
        const query = `
        SELECT f.name AS set_name, f.detail AS set_detail, c.id AS card_id, c.question, c.answer
        FROM flashsets f
        LEFT JOIN cards c ON f.id = c.set_id
        WHERE f.id = $1
        `;

        const { rows } = await pool.query(query, [setId]);

        if (rows.length === 0) {
            return res.status(404).json({ error: "Set not found" });
        }

        const response = {
            setName: rows[0].set_name,
            setDetail: rows[0].set_detail,
            cards: rows[0].card_id ? rows.map(r => ({
                id: r.card_id,
                question: r.question
            })) : []

        };
        res.json(response);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// Update a specific card
router.patch('/:cardId', async (req, res) => {
    const { cardId } = req.params;
    const { question, answer } = req.body;

    try {
        const { rows } = await pool.query(
            'UPDATE cards SET question = $1, answer = $2 WHERE id = $3 RETURNING *',
            [question, answer, cardId]
        )

        if (rows.length === 0) {
            return res.status(404).json({error: 'Card not found'})
        }

        res.json({ message: 'Card Updated', cards: rows[0] })

    } catch (error) {
        res.status(500).json({error: error.message})
    }

})
// Delete a specific card
router.delete('/:cardId', async (req, res) => {
    const { cardId } = req.params
    
    try {

        const {rows} = await pool.query(
            'DELETE FROM cards WHERE id = $1 RETURNING *',
            [cardId]
        )

        if (rows.length === 0) {
            return res.status(404).json({error: "Card does not exist"})
        }
        res.json({message: "Card Deleted"})


        
    } catch (error) {
        res.status(500).json({error:error.message})
        
    }
})
export default router