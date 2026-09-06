package exception;

import lk.logistic.exception.InsufficientInventoryException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

@Provider
public class InsufficientInventoryExceptionMapper implements ExceptionMapper<InsufficientInventoryException> {

    @Override
    public Response toResponse(InsufficientInventoryException exception) {
        String jsonError = "{error: " + exception.getMessage() + "}";

        return Response.status(Response.Status.BAD_REQUEST)
                .entity(jsonError)
                .header("Content-Type", "application/json")
                .build();
    }
}