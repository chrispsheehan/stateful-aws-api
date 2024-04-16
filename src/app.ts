import express from 'express';
import awsServerlessExpress from 'aws-serverless-express';
import taskHandlers from './taskHandlers';

const app = express();
app.use(express.json());

const basePath = "/api"

app.get('/hello', (_req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app
  .route(`${basePath}/task`)
  .put(taskHandlers.putTask);

const server = awsServerlessExpress.createServer(app);

export const handler = (event: any, context: any) => {
  awsServerlessExpress.proxy(server, event, context);
};

export default app;


// const Task = mongoose.model('Task', taskSchema);

// // Middleware
// app.use(bodyParser.json());

// // Routes
// app.get('/tasks', async (req, res) => {
//   try {
//     const tasks = await Task.find();
//     res.json(tasks);
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// });

// app.post('/tasks', async (req, res) => {
//   const task = new Task({
//     title: req.body.title,
//     description: req.body.description,
//     completed: req.body.completed || false
//   });

//   try {
//     const newTask = await task.save();
//     res.status(201).json(newTask);
//   } catch (error) {
//     res.status(400).json({ message: error.message });
//   }
// });

// app.get('/tasks/:id', async (req, res) => {
//   try {
//     const task = await Task.findById(req.params.id);
//     if (task == null) {
//       return res.status(404).json({ message: 'Task not found' });
//     }
//     res.json(task);
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// });

// app.put('/tasks/:id', async (req, res) => {
//   try {
//     const task = await Task.findById(req.params.id);
//     if (task == null) {
//       return res.status(404).json({ message: 'Task not found' });
//     }
//     if (req.body.title != null) {
//       task.title = req.body.title;
//     }
//     if (req.body.description != null) {
//       task.description = req.body.description;
//     }
//     if (req.body.completed != null) {
//       task.completed = req.body.completed;
//     }
//     const updatedTask = await task.save();
//     res.json(updatedTask);
//   } catch (error) {
//     res.status(400).json({ message: error.message });
//   }
// });

// app.delete('/tasks/:id', async (req, res) => {
//   try {
//     const task = await Task.findById(req.params.id);
//     if (task == null) {
//       return res.status(404).json({ message: 'Task not found' });
//     }
//     await task.remove();
//     res.json({ message: 'Task deleted' });
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// });
