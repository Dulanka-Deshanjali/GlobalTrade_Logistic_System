package api;

import jakarta.annotation.security.DeclareRoles;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lk.logistic.dto.UserDto;
import lk.logistic.entity.User;
import lk.logistic.entity.Vendor;
import lk.logistic.service.UserServiceBean;
import lk.logistic.service.VendorServiceBean;

import java.util.List;

@Path("/vendors")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
//@RolesAllowed("LOGISTIC COORDINATOR")
public class VendorResource {

    @Inject
    private VendorServiceBean vendorService;

    @Inject
    private UserServiceBean userServiceBean;


    @GET
    public Response getAllVendors() {
        List<Vendor> vendors = vendorService.getAllVendors();
        return Response.ok(vendors).build();
    }


    @GET
    @Path("/users")
    public Response getUsersByRole(@QueryParam("role") String role) {
        try {
            List<UserDto> users = userServiceBean.getUserRoleDTOs(role);
            return Response.ok(users).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to load users\"}")
                    .build();
        }
    }


    @POST
    public Response createVendor(Vendor vendor) {
        try {
            vendorService.saveVendor(vendor);
            return Response.status(Response.Status.CREATED)
                    .entity("{\"message\": \"Vendor saved successfully\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Failed to save vendor. Email may already exist.\"}")
                    .build();
        }
    }


    @PUT
    @Path("/{id}")
    public Response updateVendor(@PathParam("id") Long id, Vendor vendor) {
        vendor.setId(id);
        vendorService.saveVendor(vendor);
        return Response.ok("{\"message\": \"Vendor updated successfully\"}").build();
    }


    @DELETE
    @Path("/{id}")
    public Response deleteVendor(@PathParam("id") Long id) {
        vendorService.deleteVendor(id);
        return Response.ok("{\"message\": \"Vendor deleted successfully\"}").build();
    }
}