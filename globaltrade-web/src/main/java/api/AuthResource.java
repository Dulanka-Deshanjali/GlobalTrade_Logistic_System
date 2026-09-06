package api;

import jakarta.annotation.security.DeclareRoles;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.dto.UserDto;
import lk.logistic.service.UserServiceBean;


@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
//@RolesAllowed("LOGISTIC COORDINATOR")
public class AuthResource {

    @Inject
    private UserServiceBean userService;

    @POST
    @Path("/register")
    public Response registerUser(UserDto dto) {
        boolean isCreated = userService.registerUser(dto);
        if (isCreated) {
            return Response.status(Response.Status.CREATED)
                    .entity("{\"message\": \"User registered successfully!\"}")
                    .build();
        } else {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Registration failed. Username or Email may already exist.\"}")
                    .build();
        }
    }
}
