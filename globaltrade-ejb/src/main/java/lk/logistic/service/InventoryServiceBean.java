package lk.logistic.service;

import jakarta.annotation.Resource;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import jakarta.transaction.UserTransaction;
import lk.logistic.entity.Inventory;
import lk.logistic.exception.InsufficientInventoryException;
import lk.logistic.interceptor.LogisticsAuditInterceptor;

import java.util.List;

@Stateless
@Interceptors(LogisticsAuditInterceptor.class)
@TransactionManagement(TransactionManagementType.BEAN)
@RolesAllowed({"LOGISTICS_COORDINATOR","WAREHOUSE_MANAGER","VENDOR"})
public class InventoryServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;


    @SuppressWarnings("EjbEnvironmentInspection")
    @Resource
    private UserTransaction utx;

    public List<Inventory> getAllInventory() {
        return em.createNamedQuery("Inventory.findAll", Inventory.class).getResultList();
    }

    public Inventory getInventoryById(Long id) {
        return em.find(Inventory.class, id);
    }

    public List<Inventory> getLowStockItems() {
        return em.createNamedQuery("Inventory.findLowStockItems", Inventory.class).getResultList();
    }


    public void addInventory(Inventory inventory) {
        try {
            utx.begin();
            em.persist(inventory);
            utx.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                utx.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("Failed to add inventory: " + e.getMessage());
        }
    }


    public void updateStock(Long id, int changeQuantity) {
        try {
            utx.begin();

            Inventory item = em.find(Inventory.class, id);

            if (item != null) {

                int updatedQuantity = item.getQuantity() + changeQuantity;

                if (updatedQuantity < 0) {
                    utx.rollback();
                    throw new InsufficientInventoryException("Cannot update stock. Insufficient inventory for: " + item.getItemName());
                }

                item.setQuantity(updatedQuantity);
                em.merge(item);

                utx.commit();

            } else {
                utx.rollback();
                throw new RuntimeException("Inventory item not found with ID: " + id);
            }

        } catch (InsufficientInventoryException e) {
            throw e;
        } catch (Exception e) {
            try { utx.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            throw new RuntimeException("Failed to update stock: " + e.getMessage());
        }
    }
}