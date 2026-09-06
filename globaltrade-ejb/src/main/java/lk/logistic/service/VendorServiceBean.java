package lk.logistic.service;


import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.Vendor;
import java.util.List;

@Stateless
public class VendorServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public List<Vendor> getAllVendors() {
        return em.createQuery("SELECT v FROM Vendor v", Vendor.class).getResultList();
    }

    public void saveVendor(Vendor vendor) {
        if (vendor.getId() == null) {
            em.persist(vendor);
        } else {
            em.merge(vendor);
        }
    }

    public void deleteVendor(Long id) {
        Vendor vendor = em.find(Vendor.class, id);
        if (vendor != null) {
            em.remove(vendor);
        }
    }
}