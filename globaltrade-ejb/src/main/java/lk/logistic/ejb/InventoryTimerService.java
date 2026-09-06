package lk.logistic.ejb;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Inventory;

import java.time.LocalDateTime;
import java.util.List;

@Singleton
@Startup
public class InventoryTimerService {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    @Schedule(hour = "0", minute = "0", second = "0", persistent = false, info = "Daily Low Stock Check")
    public void checkLowStockDaily() {

        System.out.println("--- [SYSTEM TIMER] Starting Daily Low Stock Check ---");

        List<Inventory> lowStockItems = em.createNamedQuery("Inventory.findLowStockItems", Inventory.class)
                .getResultList();

        if (lowStockItems != null && !lowStockItems.isEmpty()) {

            for (Inventory item : lowStockItems) {

                AuditLog log = new AuditLog();
                log.setUsername("SYSTEM_TIMER");
                log.setAction("LOW_STOCK_ALERT");
                log.setDetails("URGENT: Item " + item.getItemName() + " (" + item.getItemCode() +
                        ") is below reorder level. Current Qty: " + item.getQuantity());
                log.setTimestamp(LocalDateTime.now());

                em.persist(log);

                System.out.println("[ALERT] Low Stock: " + item.getItemName() + " (Qty: " + item.getQuantity() + ")");
            }

        } else {
            System.out.println("--- [SYSTEM TIMER] All stock levels are sufficient. ---");
        }
    }
}