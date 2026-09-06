package lk.logistic.service;

import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException;
import lk.logistic.interceptor.LogisticsAuditInterceptor;

import java.util.List;

@Stateless
@Interceptors(LogisticsAuditInterceptor.class)
public class VendorManagementServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public List<Shipment> getVendorShipments(String vendorUsername) {
        return em.createQuery(
                        "SELECT s FROM Shipment s WHERE s.vendor.vendorName = :username AND (s.status = 'PENDING' OR s.status = 'PREPARING')",
                        Shipment.class)
                .setParameter("username", vendorUsername)
                .getResultList();
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

    public void updateVendorShipmentStatus(String trackingNumber, String status, String username) {
        Shipment shipment = findShipmentByTracking(trackingNumber);
        if (shipment != null) {
            shipment.setStatus(status);
            em.merge(shipment);
        }

        AuditLog audit = new AuditLog();
        audit.setUsername(username);
        audit.setAction(status);
        audit.setDetails("Vendor updated shipment " + trackingNumber + " status to: " + status);
        em.persist(audit);
    }
}