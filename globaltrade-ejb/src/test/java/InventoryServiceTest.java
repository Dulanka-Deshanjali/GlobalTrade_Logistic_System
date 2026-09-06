import jakarta.persistence.EntityManager;
import jakarta.transaction.UserTransaction;
import lk.logistic.entity.Inventory;
import lk.logistic.service.InventoryServiceBean;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class InventoryServiceTest {

    @Mock
    private EntityManager entityManager;

    @Mock
    private UserTransaction utx;

    @InjectMocks
    private InventoryServiceBean inventoryService;

    @Test
    public void testUpdateStockSucceeds() {
        Long itemId = 1L;

        Inventory mockInventory = new Inventory();
        mockInventory.setId(itemId);
        mockInventory.setQuantity(10);

        when(entityManager.find(Inventory.class, itemId)).thenReturn(mockInventory);

        assertDoesNotThrow(() -> {
            inventoryService.updateStock(itemId, 5);
        }, "Stock update should succeed");

        assertEquals(15, mockInventory.getQuantity());
    }

    @Test
    public void testInsufficientInventoryThrowsException() {
        Long itemId = 1L;

        Inventory mockInventory = new Inventory();
        mockInventory.setId(itemId);
        mockInventory.setQuantity(10);

        when(entityManager.find(Inventory.class, itemId)).thenReturn(mockInventory);

        assertThrows(RuntimeException.class, () -> {
            inventoryService.updateStock(itemId, -9999);
        }, "Should throw an exception for insufficient stock");
    }
}