package lk.logistic.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "customs_declarations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@NamedQueries({
        @NamedQuery(name = "CustomsDeclaration.findByShipmentId", query = "SELECT c FROM CustomsDeclaration c WHERE c.shipment.id = :shipmentId"),
        @NamedQuery(name = "CustomsDeclaration.findAll", query = "SELECT c FROM CustomsDeclaration c ORDER BY c.submissionDate DESC")})
public class CustomsDeclaration implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String declarationNumber;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shipment_id", nullable = false)
    private Shipment shipment;

    @Column(nullable = false, length = 50)
    private String clearanceStatus; // PENDING, CUSTOMS_APPROVED, CUSTOMS_HELD

    @Column(name = "submission_date")
    private LocalDateTime submissionDate;

    @Column(name = "clearance_date")
    private LocalDateTime clearanceDate;
}