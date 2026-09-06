package lk.logistic.service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.logistic.dto.UserDto;
import lk.logistic.entity.User;
import lk.logistic.entity.UserGroup;
import lk.logistic.util.PasswordUtil;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Stateless
public class UserServiceBean {

    @PersistenceContext(unitName = "GlobaltradePU")
    private EntityManager em;

    public boolean registerUser(UserDto dto) {
        try {
            User user = new User();
            user.setUsername(dto.getUsername());
            user.setPassword(PasswordUtil.hashPassword(dto.getPassword()));
            user.setFullName(dto.getFullName());
            user.setEmail(dto.getEmail());
            user.setActive(true);
            user.setCreated_at(Timestamp.from(Instant.now()));

            em.persist(user);

            UserGroup userGroup = new UserGroup();
            userGroup.setUser(user);
            userGroup.setGroupName(dto.getRole());
            em.persist(userGroup);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<UserDto> getUserRoleDTOs(String role) {
        List<User> users = em.createNamedQuery("User.findByRole", User.class)
                .setParameter("role", role)
                .getResultList();

        return users.stream().map(user -> {
            UserDto dto = new UserDto();
            dto.setUsername(user.getUsername());
            dto.setFullName(user.getFullName());
            dto.setEmail(user.getEmail());
            dto.setRole(role);
            return dto;
        }).collect(Collectors.toList());
    }
}