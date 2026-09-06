import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import lk.logistic.entity.AuditLog;
import lk.logistic.entity.Shipment;
import lk.logistic.exception.ShipmentNotFoundException;
import lk.logistic.service.ShipmentServiceBean;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ShipmentServiceTest {

    @Mock
    private EntityManager entityManager;

    @InjectMocks
    private ShipmentServiceBean shipmentService;

    @Test
    public void testFindShipmentByTrackingSuccess() {
        String trackingNum = "TRK-1001";
        Shipment mockShipment = new Shipment();
        mockShipment.setTrackingNumber(trackingNum);
        mockShipment.setStatus("PENDING");


        TypedQuery<Shipment> typedQuery = mock(TypedQuery.class);
        when(entityManager.createNamedQuery("Shipment.findByTrackingNumber", Shipment.class))
                .thenReturn(typedQuery);
        when(typedQuery.setParameter("tn", trackingNum)).thenReturn(typedQuery);
        when(typedQuery.getResultStream()).thenReturn(Stream.of(mockShipment));

        Shipment result = shipmentService.findShipmentByTracking(trackingNum);

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
            shipmentService.findShipmentByTracking(trackingNum);
        });
    }

    @Test
    public void testCreateShipmentSetsDefaultStatusAndPersists() {
        Shipment shipment = new Shipment();
        shipment.setTrackingNumber("TRK-011");
        shipment.setOrigin("Colombo");
        shipment.setDestination("Kandy");
        shipment.setQty(10);


        shipmentService.createShipment(shipment);


        assertEquals("PENDING", shipment.getStatus());


        verify(entityManager, times(1)).persist(shipment);
        verify(entityManager, times(1)).persist(any(AuditLog.class));
    }
}
