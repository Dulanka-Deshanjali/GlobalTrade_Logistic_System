package api;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.SecurityContext;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException; // ඔබේ Custom Exception එක
import lk.logistic.service.VendorManagementServiceBean;
import lk.logistic.service.VendorServiceBean;

import java.util.List;

@Path("/vendor")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class VendorManagementResource {

    @Inject
    private VendorManagementServiceBean vendorServiceBean;

    @GET
    @Path("/shipments")
    public List<Shipment> getVendorShipments(@Context SecurityContext securityContext) {
        String currentVendor = securityContext.getUserPrincipal() != null ?
                securityContext.getUserPrincipal().getName() : "default_vendor";

        return vendorServiceBean.getVendorShipments(currentVendor);
    }

    @PUT
    @Path("/shipment/status/{trackingNumber}")
    public Response updateStatus(@PathParam("trackingNumber") String trackingNumber, @QueryParam("status") String status) {
        try {
            Shipment shipment = vendorServiceBean.findShipmentByTracking(trackingNumber);
            if (shipment == null) {
                throw new ShipmentNotFoundException("Shipment with tracking number " + trackingNumber + " not found!");
            }

            vendorServiceBean.updateVendorShipmentStatus(trackingNumber, status, "VENDOR_REPRESENTATIVE");

            return Response.ok("{\"message\": \"Shipment status successfully updated to " + status + "\"}").build();

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