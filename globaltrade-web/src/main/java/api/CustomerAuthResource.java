package api;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.dto.CustomerLoginDTO;
import lk.logistic.entity.User;
import lk.logistic.service.CustomerServiceBean;

import java.util.Date;

@Path("/customer/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomerAuthResource {

    @Inject
    private CustomerServiceBean customerServiceBean;

    @POST
    @Path("/login")
    public Response login(CustomerLoginDTO loginDTO){
        User authenticatedUser = customerServiceBean.authenticate(loginDTO.getEmail(), loginDTO.getPassword());

        if(authenticatedUser != null){
            String token = Jwts.builder()
                    .setSubject(authenticatedUser.getEmail())
                    .claim("role", "CUSTOMER")
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 3600 * 1000))
                    .signWith(SignatureAlgorithm.HS256, "GlobalTradeSecretKey123456")
                    .compact();

            return Response.ok("{\"accessToken\": \"" + token + "\", \"tokenType\": \"Bearer\", \"message\": \"Login successful\"}").build();
        }

        return Response.status(Response.Status.UNAUTHORIZED)
                .entity("{\"error\": \"Invalid email or password\"}")
                .build();
    }
}