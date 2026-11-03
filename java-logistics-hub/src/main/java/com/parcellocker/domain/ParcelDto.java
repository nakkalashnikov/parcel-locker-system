package com.parcellocker.domain;

import java.time.Instant;

public record ParcelDto(
    String trackingNumber,
    String recipientPhone,
    String recipientEmail,
    String targetStationId,
    String compartmentId,
    double weightKg,
    double volumeCm3,
    ParcelStatus status,
    Instant createdAt
) {
    public enum ParcelStatus {
        CREATED,
        ASSIGNED_TO_COURIER,
        IN_TRANSIT,
        STORED_IN_LOCKER,
        DELIVERED,
        SECURITY_LOCKED,
        EXPIRED_RETURN_PENDING
    }
}
