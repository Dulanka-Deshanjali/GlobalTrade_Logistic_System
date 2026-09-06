import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Shipment;
import lk.logistic.entity.Vendor;
import lk.logistic.exception.ShipmentNotFoundException;
import lk.logistic.service.VendorManagementServiceBean;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class VendorManagementServiceTest {

    @Mock
    private EntityManager entityManager;

    @InjectMocks
    private VendorManagementServiceBean vendorManagementService;

    @Test
    public void testGetVendorShipmentsSuccess() {
        String vendorName = "Global Shipping Inc.";

        Shipment shipment1 = new Shipment();
        shipment1.setTrackingNumber("TRK-001");
        shipment1.setStatus("PENDING");

        TypedQuery<Shipment> typedQuery = mock(TypedQuery.class);
        when(entityManager.createQuery(anyString(), eq(Shipment.class))).thenReturn(typedQuery);
        when(typedQuery.setParameter("username", vendorName)).thenReturn(typedQuery);
        when(typedQuery.getResultList()).thenReturn(Arrays.asList(shipment1));

        List<Shipment> shipments = vendorManagementService.getVendorShipments(vendorName);

        assertNotNull(shipments);
        assertEquals(1, shipments.size());
        assertEquals("TRK-001", shipments.get(0).getTrackingNumber());
    }

    @Test
    public void testFindShipmentByTrackingSuccess() {
        String trackingNum = "TRK-500";
        Shipment mockShipment = new Shipment();
        mockShipment.setTrackingNumber(trackingNum);

        TypedQuery<Shipment> typedQuery = mock(TypedQuery.class);
        when(entityManager.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class))
                .thenReturn(typedQuery);
        when(typedQuery.setParameter("tn", trackingNum)).thenReturn(typedQuery);
        when(typedQuery.getResultStream()).thenReturn(Stream.of(mockShipment));

        Shipment result = vendorManagementService.findShipmentByTracking(trackingNum);

        assertNotNull(result);
        assertEquals(trackingNum, result.getTrackingNumber());
    }

    @Test
    public void testFindShipmentByTrackingNotFoundThrowsException() {
        String trackingNum = "TRK-9999";

        TypedQuery<Shipment> typedQuery = mock(TypedQuery.class);
        when(entityManager.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class))
                .thenReturn(typedQuery);
        when(typedQuery.setParameter("tn", trackingNum)).thenReturn(typedQuery);
        when(typedQuery.getResultStream()).thenReturn(Stream.empty());

        assertThrows(ShipmentNotFoundException.class, () -> {
            vendorManagementService.findShipmentByTracking(trackingNum);
        });
    }

    @Test
    public void testUpdateVendorShipmentStatusSuccess() {
        String trackingNum = "TRK-200";
        String newStatus = "PREPARING";
        String username = "VendorAdmin";

        Shipment mockShipment = new Shipment();
        mockShipment.setTrackingNumber(trackingNum);
        mockShipment.setStatus("PENDING");

        TypedQuery<Shipment> typedQuery = mock(TypedQuery.class);
        when(entityManager.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class))
                .thenReturn(typedQuery);
        when(typedQuery.setParameter("tn", trackingNum)).thenReturn(typedQuery);
        when(typedQuery.getResultStream()).thenReturn(Stream.of(mockShipment));

        vendorManagementService.updateVendorShipmentStatus(trackingNum, newStatus, username);


        assertEquals(newStatus, mockShipment.getStatus());
        verify(entityManager, times(1)).merge(mockShipment);
        verify(entityManager, times(1)).persist(any(AuditLog.class));
    }
}
