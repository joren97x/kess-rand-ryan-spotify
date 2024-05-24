import express from 'express';
import { createServer } from 'node:http';
import cors from 'cors'
import router from './routes/index.js'

const app = express();
const server = createServer(app);
app.use(express.json())
app.use(cors())
app.use(router)

server.listen(3000, () => {
  console.log('server running at http://localhost:3000');
});