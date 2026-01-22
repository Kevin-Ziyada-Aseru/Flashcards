import express from 'express';
import { pool } from '../server.js';


const router = express.Router();



router.post('/', async (req, res) => {
    const detail = req.body.detail
    const name = req.body.name

    console.log("name:", name, "detail:", detail);
    try {
        const { rows } = await pool.query(
            'INSERT INTO flashsets(name, detail) VALUES($1, $2) RETURNING * ',
            [name, detail]
        )
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({error: error.message})
    }
})


router.get('/', async (req, res) => {
    try {
        const { rows } = await pool.query(
            'SELECT * FROM flashsets ORDER BY name ASC'
        )
        res.json(rows)
    } catch (error) {
        res.status(500).json({error: error.message})

        
    }
})


// router.delete('/:id', async (req, res) => {

//     const { id } = req.params;
//     try {
//         const { rows }  = await pool.query(
//             'DELETE FROM flashsets WHERE id = $1 RETURNING *',
//             [id]
//         );
//         if (rows.length === 0) {
//             return res.status(404).json({error: "the record does not exist"})
//         }
//         res.json({message: 'Deletion successful', deletedItem: rows[0]})
//     } catch (error) {
//         res.status(500).json({error: error.message})
//     }
// })


router.delete('/:id', async (req, res) => {
    const { id } = req.params

    try {
        const { rows } = await pool.query(
            'DELETE FROM flashsets WHERE id = $1 RETURNING *',
            [id]
        ) 
        if (rows.length === 0) {
            return res.status(404).json({error: 'This record does not exist'})
        }
        res.json({message: 'Deletion successful', deletedItem: rows[0]})
    } catch (error) {

        res.status(500).json({ error: error.message })
        
    }
    
})

router.put('/:id', async (req, res) => {
    const { id } = req.params;
    const { name, detail } = req.body;

    try {
        const { rows } = await pool.query(
            'UPDATE flashsets SET name = $1, detail = $2 WHERE id = $3 RETURNING *',
            [name, detail, id]
        );
        if (rows.length === 0) {
            return req.status(404).json({ error: "Flashset not found" });

        }
        res.json({ message: "Update successful", updatedItem: rows[0] });
        
    } catch (error) {
        
        res.status(500).json({ error: error.message });
    }
    
});



export default router