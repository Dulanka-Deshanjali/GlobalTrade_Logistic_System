package lk.logistic.service;

import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.CustomsDeclaration;
import lk.logistic.entity.Shipment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Stateless
@RolesAllowed("CUSTOMS_OFFICER")
public class CustomsServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public void processCustomsClearance(String trackingNumber, String status, String username) {

        Shipment shipment = em.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class)
                .setParameter("tn", trackingNumber)
                .getResultStream()
                .findFirst()
                .orElse(null);

        if (shipment != null) {
            shipment.setStatus(status);
            em.merge(shipment);

            CustomsDeclaration declaration = em.createNamedQuery("CustomsDeclaration.findByShipmentId", CustomsDeclaration.class)
                    .setParameter("shipmentId", shipment.getId())
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (declaration == null) {
                declaration = new CustomsDeclaration();
                declaration.setDeclarationNumber("CUS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                declaration.setShipment(shipment);
                declaration.setSubmissionDate(LocalDateTime.now());
            }

            declaration.setClearanceStatus(status);

            if ("CUSTOMS_APPROVED".equals(status)) {
                declaration.setClearanceDate(LocalDateTime.now());
            } else {
                declaration.setClearanceDate(null);
            }

            if (declaration.getId() == null) {
                em.persist(declaration);
            } else {
                em.merge(declaration);
            }

            AuditLog log = new AuditLog();
            log.setUsername(username);
            log.setAction(status);
            log.setDetails("Shipment " + trackingNumber + " customs clearance status updated to " + status + ". (Ref: " + declaration.getDeclarationNumber() + ")");
            em.persist(log);
        }
    }

    public List<CustomsDeclaration> getAllDeclaration(){

        return em.createNamedQuery("CustomsDeclaration.findAll", CustomsDeclaration.class)
                .getResultList();

    }
}