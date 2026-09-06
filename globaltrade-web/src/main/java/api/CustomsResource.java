package api;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.dto.AuditLogResponseDTO;
import lk.logistic.entity.CustomsDeclaration;
import lk.logistic.entity.Shipment;
import lk.logistic.service.CustomsServiceBean;
import lk.logistic.service.ShipmentServiceBean;

import java.util.List;

@Path("/customs")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomsResource {

    @Inject
    private ShipmentServiceBean shipmentService;

    @Inject
    private CustomsServiceBean customsService;

    @GET
    @Path("/shipments")
    public List<Shipment> getPendingShipments() {
        return shipmentService.getShipmentsByStatus("IN_TRANSIT");
    }

    @PUT
    @Path("/shipment/clearance/{trackingNumber}")
    public Response updateCustomsStatus(@PathParam("trackingNumber") String trackingNumber, @QueryParam("status") String status) {

        Shipment shipment = shipmentService.findShipmentByTracking(trackingNumber);
        if (shipment == null) {
            return Response.status(Response.Status.NOT_FOUND).entity("{\"error\": \"Shipment not found\"}").build();
        }

        try {
            customsService.processCustomsClearance(trackingNumber, status, "CUSTOMS_OFFICER");
            return Response.ok("{\"message\": \"Customs status updated to " + status + "\"}").build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to process customs clearance: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/audit-logs")
    public List<AuditLogResponseDTO> getAuditLogs() {
        return shipmentService.getCustomsAuditLogDTOs();
    }


    @GET
    @Path("/declarations")
    public Response getAllDeclarations() {
        try {
            List<CustomsDeclaration> declarations = customsService.getAllDeclaration();
            return Response.ok(declarations).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to retrieve declarations: " + e.getMessage() + "\"}")
                    .build();
        }
    }
}