package lk.logistic.service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.entity.AuditLog;
import java.util.List;

@Stateless
public class AuditLogServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public List<AuditLog> getAllAuditLogs() {
        return em.createQuery("SELECT a FROM AuditLog a ORDER BY a.timestamp DESC", AuditLog.class)
                .getResultList();
    }
}