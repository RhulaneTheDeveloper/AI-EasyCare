import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Pages.css';

function CaregiverMonitor() {
  const navigate = useNavigate();

  return (
    <div className="page">
      <header className="page-header">
        <div className="header-content">
          <button onClick={() => navigate('/dashboard')} className="back-btn">← Back</button>
          <h1>Caregiver Monitoring Dashboard</h1>
        </div>
      </header>

      <div className="page-container">
        <div className="feature-card">
          <h2>Monitor Patient Medication Adherence</h2>
          <p>View real-time updates on patient medication schedules and adherence patterns.</p>
          <div className="feature-list">
            <ul>
              <li>✓ Real-time medication status tracking</li>
              <li>✓ Patient medication history</li>
              <li>✓ Adherence statistics</li>
              <li>✓ Alert notifications</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default CaregiverMonitor;
