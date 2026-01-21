import express from 'express';
const PORT = 3000;
import pkg from 'pg';
const { Pool } = pkg;
import flipcardsRoutes from './routes/flipcards.routes.js'
import cors from 'cors'




const app = express()
app.use(cors())
app.use(express.json())

app.use('/flipcards', flipcardsRoutes)



export const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'flipcards',
  password: '5557',
  port: 5432,
});


app.get('/', (req, res) => {
  res.send('Hello World!');
});

// app.get('/about', (req, res) => {
//   res.send('About Page');
// });
// app.post('/data', (req, res) => {
//   res.send('Data received');
// });





app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});