import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Dashboard.css';

function Dashboard() {
  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  const handleLogout = () => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('user');
    navigate('/login');
  };

  const menuItems = [
    {
      title: 'Medication Reminders',
      description: 'Manage your medication schedule and receive reminders',
      icon: '💊',
      path: '/medications'
    },
    {
      title: 'Caregiver Monitor',
      description: 'Monitor patients and their medication adherence',
      icon: '👨‍⚕️',
      path: '/caregiver'
    },
    {
      title: 'Health Assistant',
      description: 'Get AI-powered healthcare guidance',
      icon: '🤖',
      path: '/health-assistant'
    }
  ];

  return (
    <div className="dashboard">
      <header className="dashboard-header">
        <div className="header-content">
          <h1>Welcome, {user.firstName}!</h1>
          <button onClick={handleLogout} className="logout-btn">Logout</button>
        </div>
      </header>

      <div className="dashboard-container">
        <div className="welcome-section">
          <h2>Dashboard</h2>
          <p>Your AI Healthcare Assistant Platform</p>
        </div>

        <div className="menu-grid">
          {menuItems.map((item, index) => (
            <div
              key={index}
              className="menu-card"
              onClick={() => navigate(item.path)}
            >
              <div className="menu-icon">{item.icon}</div>
              <h3>{item.title}</h3>
              <p>{item.description}</p>
              <button className="menu-btn">Access →</button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
