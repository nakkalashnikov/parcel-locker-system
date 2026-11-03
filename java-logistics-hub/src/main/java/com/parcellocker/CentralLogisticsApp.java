package com.parcellocker;

import com.parcellocker.domain.ParcelDto;
import java.time.Instant;

public class CentralLogisticsApp implements AutoCloseable {

    private final String hubIdentifier;
    private final Instant startupTime;
    private boolean isRunning;

    public CentralLogisticsApp(String hubIdentifier) {
        if (hubIdentifier == null || hubIdentifier.isBlank()) {
            throw new IllegalArgumentException("Hub identifier must not be empty");
        }
        this.hubIdentifier = hubIdentifier;
        this.startupTime = Instant.now();
        this.isRunning = true;
    }

    public void run() {
        System.out.println("====================================================");
        System.out.println("  Central Logistics Dispatcher Hub: " + hubIdentifier);
        System.out.println("====================================================");

        ParcelDto sample = new ParcelDto(
            "WAW-778899",
            "+48501234567",
            "klient@example.pl",
            "WAW-001",
            "WAW-001-B01",
            3.2,
            12000.0,
            ParcelDto.ParcelStatus.CREATED,
            Instant.now()
        );

        System.out.println("Registered parcel: " + sample.trackingNumber() + " [" + sample.status() + "]");
    }

    @Override
    public void close() {
        if (isRunning) {
            System.out.println("Shutting down Logistics Hub (" + hubIdentifier + ")...");
            isRunning = false;
        }
    }

    public static void main(String[] args) {
        try (CentralLogisticsApp app = new CentralLogisticsApp("HUB-WARSZAWA-MAIN")) {
            app.run();
        }
    }
}
