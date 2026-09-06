package lk.logistic.service;

import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;
import jakarta.persistence.NonUniqueResultException;
import jakarta.transaction.UserTransaction;
import jakarta.annotation.Resource;
import lk.logistic.entity.User;
import lk.logistic.entity.UserGroup;
import lk.logistic.util.PasswordUtil;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
@RolesAllowed("CUSTOMER")
public class CustomerServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    @SuppressWarnings("EjbEnvironmentInspection")
    @Resource
    private UserTransaction utx;

    public void registerCustomer(User user, UserGroup userGroup) {
        try {
            utx.begin();


            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            user.setActive(true);

            em.persist(user);


            userGroup.setUser(user);
            em.persist(userGroup);

            utx.commit();
        } catch (Exception e) {
            try { utx.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            throw new RuntimeException("Failed to register customer: " + e.getMessage());
        }
    }

    public User authenticate(String email, String rawPassword) {
        try {

            User user = em.createNamedQuery("User.findByEmail", User.class)
                    .setParameter("email", email)
                    .getSingleResult();

            if (user != null) {
                String hashedInputPassword = PasswordUtil.hashPassword(rawPassword);
                if (user.getPassword().equals(hashedInputPassword)) {
                    return user;
                }
            }
        } catch (NoResultException e) {

            return null;
        } catch (NonUniqueResultException e) {

            return null;
        } catch (Exception e) {

            e.printStackTrace();
        }
        return null;
    }

}