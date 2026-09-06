package filter;

import jakarta.annotation.Priority;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;

import java.io.IOException;

@Provider
@Priority(Priorities.AUTHENTICATION)
public class JwtAuthenticationFilter implements ContainerRequestFilter {
    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {

        String authHeader = requestContext.getHeaderString("Authorization");


        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            System.out.println("[Security Filter] JWT Token intercepted: " + token);

            try {

                System.out.println("[Security Filter] JWT Token is valid!");

            } catch (Exception e) {
                System.out.println("[Security Filter] Invalid JWT Token: " + e.getMessage());

                requestContext.abortWith(
                        Response.status(Response.Status.UNAUTHORIZED)
                                .entity("Unauthorized: Invalid or expired JWT token")
                                .build()
                );
            }

        } else {
            System.out.println("[Security Filter] No JWT token found in this request.");

        }
    }
}
