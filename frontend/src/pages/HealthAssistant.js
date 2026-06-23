import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Pages.css';

function HealthAssistant() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');

  const handleSendMessage = (e) => {
    e.preventDefault();
    if (input.trim()) {
      setMessages([...messages, { role: 'user', content: input }]);
      setInput('');
      // Mock AI response
      setTimeout(() => {
        setMessages(prev => [...prev, { 
          role: 'assistant', 
          content: 'Thank you for your question. I am here to help with medication guidance and health support.' 
        }]);
      }, 500);
    }
  };

  return (
    <div className="page">
      <header className="page-header">
        <div className="header-content">
          <button onClick={() => navigate('/dashboard')} className="back-btn">← Back</button>
          <h1>AI Health Assistant</h1>
        </div>
      </header>

      <div className="page-container">
        <div className="chat-container">
          <div className="chat-messages">
            {messages.map((msg, idx) => (
              <div key={idx} className={`message ${msg.role}`}>
                <p>{msg.content}</p>
              </div>
            ))}
            {messages.length === 0 && (
              <div className="welcome-message">
                <p>Hello! I'm your AI Health Assistant. How can I help you today?</p>
              </div>
            )}
          </div>

          <form onSubmit={handleSendMessage} className="chat-form">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Ask me a health question..."
            />
            <button type="submit" className="button button-primary">Send</button>
          </form>
        </div>
      </div>
    </div>
  );
}

export default HealthAssistant;
