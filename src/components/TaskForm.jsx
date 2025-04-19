import React, { useState } from 'react';
import { db } from '../services/firebase';
import { collection, addDoc } from 'firebase/firestore';

export default function TaskForm() {
  const [task, setTask] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (task.trim()) {
      await addDoc(collection(db, "tasks"), { text: task });
      setTask("");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={task} onChange={e => setTask(e.target.value)} />
      <button type="submit">Add Task</button>
    </form>
  );
}
