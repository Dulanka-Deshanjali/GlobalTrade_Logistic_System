package lk.logistic.service;

import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException;

@Stateless
@RolesAllowed("CUSTOMER")
public class TrackingShipmentBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public Shipment trackingShipment(String trackingNumber) throws ShipmentNotFoundException {
        try {
            Shipment shipment = em.createQuery("SELECT s FROM Shipment s WHERE s.trackingNumber = :tNo", Shipment.class)
                    .setParameter("tNo", trackingNumber)
                    .getSingleResult();

            if (shipment == null) {
                throw new ShipmentNotFoundException("Shipment with tracking number " + trackingNumber + " was not found.");
            }
            return shipment;

        } catch (NoResultException e) {
            throw new ShipmentNotFoundException("No shipment found for tracking number: " + trackingNumber);
        } catch (Exception e) {
            throw new RuntimeException("An error occurred while tracking the shipment: " + e.getMessage(), e);
        }
    }
}