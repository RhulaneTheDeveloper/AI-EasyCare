import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './MedicationReminder.css';

function MedicationReminder() {
  const navigate = useNavigate();
  const [medications, setMedications] = useState([]);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    medicationName: '',
    dosage: '',
    frequency: '',
    reminderTime: '',
    description: ''
  });

  const handleAddMedication = (e) => {
    e.preventDefault();
    const newMedication = {
      id: Date.now(),
      ...formData,
      isActive: true,
      createdAt: new Date()
    };
    setMedications([...medications, newMedication]);
    setFormData({ medicationName: '', dosage: '', frequency: '', reminderTime: '', description: '' });
    setShowForm(false);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <div className="medication-page">
      <header className="page-header">
        <div className="header-content">
          <button onClick={() => navigate('/dashboard')} className="back-btn">← Back</button>
          <h1>Medication Reminders</h1>
        </div>
      </header>

      <div className="page-container">
        <button 
          onClick={() => setShowForm(!showForm)} 
          className="button button-primary add-btn"
        >
          {showForm ? '✕ Cancel' : '+ Add Medication'}
        </button>

        {showForm && (
          <div className="medication-form">
            <h3>Add New Medication</h3>
            <form onSubmit={handleAddMedication}>
              <div className="form-group">
                <label>Medication Name</label>
                <input
                  type="text"
                  name="medicationName"
                  value={formData.medicationName}
                  onChange={handleInputChange}
                  required
                  placeholder="e.g., Aspirin"
                />
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label>Dosage</label>
                  <input
                    type="text"
                    name="dosage"
                    value={formData.dosage}
                    onChange={handleInputChange}
                    required
                    placeholder="e.g., 500mg"
                  />
                </div>
                <div className="form-group">
                  <label>Frequency</label>
                  <select
                    name="frequency"
                    value={formData.frequency}
                    onChange={handleInputChange}
                    required
                  >
                    <option value="">Select frequency</option>
                    <option value="Once daily">Once daily</option>
                    <option value="Twice daily">Twice daily</option>
                    <option value="Three times daily">Three times daily</option>
                    <option value="Every 6 hours">Every 6 hours</option>
                    <option value="Every 8 hours">Every 8 hours</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label>Reminder Time</label>
                <input
                  type="time"
                  name="reminderTime"
                  value={formData.reminderTime}
                  onChange={handleInputChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Description</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleInputChange}
                  placeholder="Any special instructions"
                  rows="3"
                />
              </div>

              <button type="submit" className="button button-primary">Add Medication</button>
            </form>
          </div>
        )}

        <div className="medications-list">
          {medications.length === 0 ? (
            <div className="empty-state">
              <p>No medications added yet</p>
              <p className="text-muted">Add your first medication to get started</p>
            </div>
          ) : (
            medications.map(med => (
              <div key={med.id} className="medication-card">
                <div className="med-header">
                  <h3>{med.medicationName}</h3>
                  <span className="badge">💊</span>
                </div>
                <div className="med-details">
                  <p><strong>Dosage:</strong> {med.dosage}</p>
                  <p><strong>Frequency:</strong> {med.frequency}</p>
                  <p><strong>Reminder Time:</strong> {med.reminderTime}</p>
                  {med.description && <p><strong>Notes:</strong> {med.description}</p>}
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

export default MedicationReminder;
