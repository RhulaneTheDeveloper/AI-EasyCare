package com.easycare.repository;

import com.easycare.entity.MedicationHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface MedicationHistoryRepository extends JpaRepository<MedicationHistory, Long> {
    List<MedicationHistory> findByMedicationId(Long medicationId);
    List<MedicationHistory> findByMedicationIdAndScheduledTimeBetween(Long medicationId, LocalDateTime start, LocalDateTime end);
}
