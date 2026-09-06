package lk.logistic.service;

import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.dto.AuditLogResponseDTO;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException;
import lk.logistic.interceptor.LogisticsAuditInterceptor;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Stateless
@Interceptors(LogisticsAuditInterceptor.class)
public class ShipmentServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public List<Shipment> getAllShipments() {
        return em.createNamedQuery("Shipment.findAll", Shipment.class).getResultList();
    }

    public void createShipment(Shipment shipment) {
        if (shipment.getStatus() == null) {
            shipment.setStatus("PENDING");
        }
        em.persist(shipment);

        AuditLog log = new AuditLog();
        log.setUsername("Logistics Coordinator");
        log.setAction("CREATED_SHIPMENT");
        log.setDetails("Created new shipment with tracking number: " + shipment.getTrackingNumber());
        em.persist(log);
    }

    public void updateShipmentStatus(String trackingNumber, String status) {
        Shipment shipment = em.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class)
                .setParameter("tn", trackingNumber)
                .getSingleResult();
        if (shipment != null) {
            shipment.setStatus(status);
            em.merge(shipment);

            AuditLog log = new AuditLog();
            log.setUsername("Warehouse Manager");
            log.setAction("SHIPMENT_STATUS_UPDATE");
            log.setDetails("Updated shipment " + trackingNumber + " status to: " + status);
            em.persist(log);
        }
    }

    public Shipment findShipmentByTracking(String trackingNumber) {
        Shipment shipment = em.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class)
                .setParameter("tn", trackingNumber)
                .getResultStream()
                .findFirst()
                .orElse(null);

        if (shipment == null) {
            throw new ShipmentNotFoundException("Shipment with tracking number " + trackingNumber + " not found!");
        }
        return shipment;
    }

    public List<Shipment> getPendingShipments() {
        return em.createQuery("SELECT s FROM Shipment s WHERE s.status = 'PENDING'", Shipment.class)
                .getResultList();
    }

    public List<Shipment> getShipmentsByStatus(String status) {
        return em.createQuery("SELECT s FROM Shipment s WHERE s.status = :status", Shipment.class)
                .setParameter("status", status)
                .getResultList();
    }

    public void updateCustomsStatusWithAudit(String trackingNumber, String status, String username) {
        Shipment shipment = findShipmentByTracking(trackingNumber);
        if (shipment != null) {
            shipment.setStatus(status);
            em.merge(shipment);
        }

        AuditLog audit = new AuditLog();
        audit.setUsername(username);
        audit.setAction(status);
        audit.setDetails("Shipment " + trackingNumber + " was updated.");
        em.persist(audit);
    }

    public List<AuditLogResponseDTO> getCustomsAuditLogDTOs() {
        List<AuditLog> auditLogs = em.createQuery(
                        "SELECT a FROM AuditLog a WHERE a.action IN ('CUSTOMS_APPROVED', 'CUSTOMS_HELD') ORDER BY a.id DESC",
                        AuditLog.class)
                .getResultList();


        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        return auditLogs.stream().map(log -> {
            AuditLogResponseDTO dto = new AuditLogResponseDTO();
            dto.setId(log.getId());
            dto.setUsername(log.getUsername());
            dto.setAction(log.getAction());
            dto.setDetails(log.getDetails());


            if (log.getTimestamp() != null) {
                dto.setFormattedTimestamp(log.getTimestamp().format(formatter));
            } else {
                dto.setFormattedTimestamp("");
            }

            return dto;
        }).collect(Collectors.toList());
    }

    public void rescheduleShipment(String trackingNumber, String newDateString, String username) {
        Shipment shipment = findShipmentByTracking(trackingNumber);
        if (shipment != null) {

            java.time.LocalDateTime newDate = java.time.LocalDateTime.parse(newDateString);
            shipment.setEstimatedDelivery(newDate);

            em.merge(shipment);

            AuditLog log = new AuditLog();
            log.setUsername(username);
            log.setAction("SHIPMENT_RESCHEDULED");
            log.setDetails("Shipment " + trackingNumber + " rescheduled to " + newDateString);
            em.persist(log);
        } else {
            throw new ShipmentNotFoundException("Shipment with tracking number " + trackingNumber + " not found!");
        }
    }
}