package api;

import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.SecurityContext;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Inventory;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.InsufficientInventoryException;
import lk.logistic.service.AuditLogServiceBean;
import lk.logistic.service.InventoryServiceBean;
import lk.logistic.service.ShipmentServiceBean;

import java.util.List;

@Path("/logistics")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@RolesAllowed({"LOGISTICS_COORDINATOR","VENDOR","WAREHOUSE_MANAGER","CUSTOMS_OFFICER"})
public class LogisticsResource {

    @Inject
    private ShipmentServiceBean shipmentService;

    @Inject
    private InventoryServiceBean inventoryService;

    @Inject
    private AuditLogServiceBean auditLogService;

    @Inject
    private HttpServletRequest request;

    @GET
    @Path("/shipments")
    public List<Shipment> getAllShipments() {
        return shipmentService.getAllShipments();
    }


    @GET
    @Path("/vendor-shipments")
    public List<Shipment> getVendorShipments(@QueryParam("vendorId") Long vendorId) {
        List<Shipment> allShipments = shipmentService.getAllShipments();

        return allShipments.stream()
                .filter(s -> s.getVendor() != null)
                .filter(s -> vendorId == null || s.getVendor().getId().equals(vendorId))
                .filter(s -> "PENDING".equals(s.getStatus()) || "READY_FOR_DISPATCH".equals(s.getStatus()))
                .toList();
    }
    @POST
    @Path("/shipment")
    public Response createShipment(Shipment shipment) {
        shipmentService.createShipment(shipment);
        return Response.status(Response.Status.CREATED).entity("{\"message\": \"Shipment created successfully as PENDING\"}").build();
    }

    @PUT
    @Path("/shipment/status/{trackingNumber}")
    public Response updateShipmentStatus(@PathParam("trackingNumber") String trackingNumber, @QueryParam("status") String status) {

        Shipment shipment = shipmentService.findShipmentByTracking(trackingNumber);
        if (shipment == null) {
            return Response.status(Response.Status.NOT_FOUND).entity("{\"error\": \"Shipment not found\"}").build();
        }

        String oldStatus = shipment.getStatus();


        if ("IN_TRANSIT".equals(status) && ("PENDING".equals(oldStatus) || "READY_FOR_DISPATCH".equals(oldStatus))) {
            if (shipment.getInventory() != null) {
                Long inventoryId = shipment.getInventory().getId();
                Inventory item = inventoryService.getInventoryById(inventoryId);

                if (item != null) {
                    int shipmentQty = shipment.getQty();
                    int currentStock = item.getQuantity();

                    if (currentStock >= shipmentQty) {

                        inventoryService.updateStock(inventoryId, -shipmentQty);

                    } else {
                        throw new InsufficientInventoryException("Insufficient stock in inventory! Required: " + shipmentQty + ", Available: " + currentStock);
                    }
                }
            }
        }

        shipmentService.updateShipmentStatus(trackingNumber, status);
        return Response.ok("{\"message\": \"Shipment status updated to " + status + " and inventory deducted successfully.\"}").build();
    }

    @POST
    @Path("/ship-item")
    public Response shipItem(Shipment shipment, @QueryParam("inventoryId") Long inventoryId, @QueryParam("qty") int qty) {
        Inventory item = inventoryService.getInventoryById(inventoryId);
        if (item == null) {
            return Response.status(Response.Status.NOT_FOUND).entity("{\"error\": \"Inventory item not found\"}").build();
        }

        if (item.getQuantity() < qty) {
            return Response.status(Response.Status.BAD_REQUEST).entity("{\"error\": \"Insufficient stock quantity\"}").build();
        }

        inventoryService.updateStock(inventoryId, -qty);

        shipment.setInventory(item);
        shipment.setStatus("IN_TRANSIT");
        shipment.setQty(qty);

        shipmentService.createShipment(shipment);

        return Response.status(Response.Status.CREATED).entity("{\"message\": \"Item shipped and inventory updated successfully\"}").build();
    }

    @GET
    @Path("/inventory")
    public List<Inventory> getAllInventory() {
        return inventoryService.getAllInventory();
    }

    @POST
    @Path("/inventory")
    public Response addInventory(Inventory inventory) {
        inventoryService.addInventory(inventory);
        return Response.status(Response.Status.CREATED).entity("{\"message\": \"Inventory added successfully\"}").build();
    }

    @PUT
    @Path("/inventory/{id}")
    public Response updateInventoryStock(@PathParam("id") Long id, Inventory inventory) {
        inventoryService.updateStock(id, inventory.getQuantity());
        return Response.ok("{\"message\": \"Inventory updated successfully\"}").build();
    }

    @GET
    @Path("/audit-logs")
    public List<AuditLog> getAllAuditLogs() {
        return auditLogService.getAllAuditLogs();
    }

    @PUT
    @Path("/shipment/reschedule/{trackingNumber}")
    public Response rescheduleShipment(@PathParam("trackingNumber") String trackingNumber, @QueryParam("newDate") String newDate) {
        try {
            shipmentService.rescheduleShipment(trackingNumber, newDate, "Logistics Coordinator");
            return Response.ok("{\"message\": \"Shipment rescheduled successfully\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Failed to reschedule shipment: " + e.getMessage() + "\"}")
                    .build();
        }
    }
}