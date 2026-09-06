package lk.logistic.entity;

import jakarta.json.bind.annotation.JsonbTransient;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.io.Serializable;
import java.time.LocalDateTime;


@Entity
@Table(name = "shipments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@NamedQueries({
        @NamedQuery(name = "Shipment.findAll", query = "SELECT s FROM Shipment s"),
        @NamedQuery(name = "Shipment.findByTrackingNumber", query = "SELECT s FROM Shipment s WHERE s.trackingNumber = :tn"),
        @NamedQuery(name = "Shipment.findDelayedShipments", query = "SELECT s FROM Shipment s WHERE s.estimatedDelivery < :now AND s.status = 'IN_TRANSIT'")
})
public class Shipment implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String trackingNumber;

    @Column(nullable = false, length = 100)
    private String origin;

    @Column(nullable = false, length = 100)
    private int qty;

    @Column(nullable = false, length = 100)
    private String destination;

    @Column(nullable = false, length = 50)
    private String status; // PENDING, IN_TRANSIT, DELIVERED, DELAYED

    @Column(name = "current_location", length = 100)
    private String currentLocation;

    @Column(name = "estimated_delivery")
    private LocalDateTime estimatedDelivery;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendor_id")
    private Vendor vendor;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inventory_id")
    private Inventory inventory;


    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}