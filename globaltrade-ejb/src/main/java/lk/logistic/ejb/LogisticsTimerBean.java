package lk.logistic.ejb;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.Shipment;

import java.time.LocalDateTime;
import java.util.List;

@Singleton
@Startup
public class LogisticsTimerBean {
    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    @Schedule(hour = "*",minute = "*/30",persistent = false)
    private void monitorShipmentDeadlines(){
        System.out.println("[Timer Service] Running automated Shipment Deadline Verification....");

        LocalDateTime now = LocalDateTime.now();

        List<Shipment> delayedShipments = em.createNamedQuery("Shipment.findDelayedShipments", Shipment.class)
                .setParameter("now", now)
                .getResultList();

        for(Shipment shipment : delayedShipments){
            shipment.setStatus("DELAYED");
            em.merge(shipment);
            System.out.println("[Alert] Shipment Tracking No: " + shipment.getTrackingNumber() + " is marked as DELAYED.");        }
    }



}
