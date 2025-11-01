import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [newItem, setNewItem] = useState('');

  const API_URL = process.env.REACT_APP_API_URL || '/api';

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/items`);
      setData(response.data);
      setError(null);
    } catch (err) {
      setError('Failed to fetch data');
      console.error('Error fetching data:', err);
    } finally {
      setLoading(false);
    }
  };

  const addItem = async (e) => {
    e.preventDefault();
    if (!newItem.trim()) return;

    try {
      const response = await axios.post(`${API_URL}/items`, {
        name: newItem,
        timestamp: new Date().toISOString()
      });
      setData([...data, response.data]);
      setNewItem('');
    } catch (err) {
      setError('Failed to add item');
      console.error('Error adding item:', err);
    }
  };

  const deleteItem = async (id) => {
    try {
      await axios.delete(`${API_URL}/items/${id}`);
      setData(data.filter(item => item._id !== id));
    } catch (err) {
      setError('Failed to delete item');
      console.error('Error deleting item:', err);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Multi-Service Docker Application</h1>
        <p>Frontend: React | Backend: Node.js/Express | Database: MongoDB | Cache: Redis</p>
      </header>

      <main className="App-main">
        <div className="container">
          <section className="add-item-section">
            <h2>Add New Item</h2>
            <form onSubmit={addItem} className="add-item-form">
              <input
                type="text"
                value={newItem}
                onChange={(e) => setNewItem(e.target.value)}
                placeholder="Enter item name"
                className="item-input"
              />
              <button type="submit" className="add-button">Add Item</button>
            </form>
          </section>

          <section className="items-section">
            <h2>Items List</h2>
            {loading && <p className="loading">Loading...</p>}
            {error && <p className="error">{error}</p>}
            
            <div className="items-grid">
              {data.map((item) => (
                <div key={item._id} className="item-card">
                  <h3>{item.name}</h3>
                  <p className="timestamp">
                    Created: {new Date(item.timestamp).toLocaleString()}
                  </p>
                  <button
                    onClick={() => deleteItem(item._id)}
                    className="delete-button"
                  >
                    Delete
                  </button>
                </div>
              ))}
            </div>
            
            {!loading && data.length === 0 && (
              <p className="no-items">No items found. Add some items to get started!</p>
            )}
          </section>
        </div>
      </main>
    </div>
  );
}

export default App;