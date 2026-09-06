package lk.logistic.dto;

public class InventoryDto {
    private Long id;
    private String itemCode;
    private String itemName;
    private int quantity;
    private String location;


    public InventoryDto() {}

    public InventoryDto(Long id, String itemCode, String itemName, int quantity, String location) {
        this.id = id;
        this.itemCode = itemCode;
        this.itemName = itemName;
        this.quantity = quantity;
        this.location = location;
    }


    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getItemCode() { return itemCode; }
    public void setItemCode(String itemCode) { this.itemCode = itemCode; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}