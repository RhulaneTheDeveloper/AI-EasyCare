import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import './App.css';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import MedicationReminder from './pages/MedicationReminder';
import CaregiverMonitor from './pages/CaregiverMonitor';
import HealthAssistant from './pages/HealthAssistant';

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      setIsAuthenticated(true);
    }
  }, []);

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login setIsAuthenticated={setIsAuthenticated} />} />
        <Route path="/register" element={<Register />} />
        <Route path="/dashboard" element={isAuthenticated ? <Dashboard /> : <Navigate to="/login" />} />
        <Route path="/medications" element={isAuthenticated ? <MedicationReminder /> : <Navigate to="/login" />} />
        <Route path="/caregiver" element={isAuthenticated ? <CaregiverMonitor /> : <Navigate to="/login" />} />
        <Route path="/health-assistant" element={isAuthenticated ? <HealthAssistant /> : <Navigate to="/login" />} />
        <Route path="/" element={isAuthenticated ? <Navigate to="/dashboard" /> : <Navigate to="/login" />} />
      </Routes>
    </Router>
  );
}

export default App;
