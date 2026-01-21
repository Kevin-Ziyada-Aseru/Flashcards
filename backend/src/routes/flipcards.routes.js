import express from 'express';
import { pool } from '../server.js';


const router = express.Router();

// router.get("/", async (req, res) => {
//     try {
        
//     } catch (error) {
        
//     }
// })

router.post('/', async (req, res) =>
{
    const detail  = req.body.detail
    const name = req.body.name

    console.log("name:", name , "detail:",detail);
    
    try {
        const { rows } = await pool.query(
            'INSERT INTO flashsets (name, detail) VALUES ($1, $2) RETURNING *',
            [name, detail],
        )
        res.json(rows[0]);
        
        
    } catch (error) {
        res.status(500).json({error: error.message});
        
    }
}
)

router.get('/', async (req, res) => {
    try {
        const { rows } = await pool.query(
            'SELECT * FROM flashsets ORDER BY id ASC'
        )
        res.json(rows)
        
    } catch (error) {
        res.status(500).json({error: error.message});

        
    }
})
export default router