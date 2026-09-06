package exception;

import jakarta.ejb.AccessLocalException;
import jakarta.ejb.EJBException;
import jakarta.ejb.EJBAccessException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

@Provider
public class SecurityExceptionMapper implements ExceptionMapper<EJBException> {

    @Override
    public Response toResponse(EJBException exception) {

        if (exception instanceof EJBAccessException ||
                exception.getCause() instanceof AccessLocalException ||
                (exception.getMessage() != null && exception.getMessage().contains("not authorized"))) {

            String jsonError = "{error: 403 Forbidden, message: Access Denied. You do not have permission to access this resource.}";

            return Response.status(Response.Status.FORBIDDEN)
                    .entity(jsonError)
                    .header("Content-Type", "application/json")
                    .build();
        }

        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("{error: 500 Internal Server Error, message: Server error occurred.}")
                .header("Content-Type", "application/json")
                .build();
    }
}