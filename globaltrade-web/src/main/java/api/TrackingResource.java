package api;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException;
import lk.logistic.service.TrackingShipmentBean;

@Path("/customer")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TrackingResource {

    @Inject
    private TrackingShipmentBean trackingShipmentBean;

    @GET
    @Path("/track/{trackingNo}")
    public Response trackShipment(@PathParam("trackingNo") String trackingNo) {
        try {
            Shipment shipment = trackingShipmentBean.trackingShipment(trackingNo);

            return Response.ok(shipment).build();

        } catch (ShipmentNotFoundException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"An unexpected error occurred: " + e.getMessage() + "\"}")
                    .build();
        }
    }
}