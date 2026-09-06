package api;

import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.entity.User;
import lk.logistic.entity.UserGroup;
import lk.logistic.service.CustomerServiceBean;

@Path("/customer")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomerRegistrationResource {

    @Inject
    private CustomerServiceBean customerServiceBean;

    @POST
    @Path("/register")
    public Response registerCustomer(User user) {
        try {

            UserGroup userGroup = new UserGroup();
            userGroup.setGroupName("CUSTOMER");

            customerServiceBean.registerCustomer(user, userGroup);

            return Response.ok("{\"message\": \"Registration successful! Please login.\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
}