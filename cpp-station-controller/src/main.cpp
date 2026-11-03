#include "domain/Dimensions.hpp"
#include "domain/Enums.hpp"
#include "domain/Parcel.hpp"
#include "concurrency/SafeQueue.hpp"
#include <iostream>

int main() {
    std::cout << "====================================================\n";
    std::cout << "  📦 Parcel Locker Terminal Station Controller v1.0\n";
    std::cout << "  C++20 Edge Hardware Controller & Simulator\n";
    std::cout << "====================================================\n";

    locker::domain::Dimensions box_size{30.0, 15.0, 50.0, 4.5};
    locker::domain::Parcel parcel("WAW-992819", "+48501111222", box_size);

    std::cout << "Sample Parcel Registered: " << parcel.getTrackingNumber() << "\n";
    std::cout << "Dimensions: " << parcel.getDimensions() << "\n";
    std::cout << "Status: " << locker::domain::toString(parcel.getStatus()) << "\n";

    locker::concurrency::SafeQueue<std::string> event_queue(10);
    event_queue.push("HARDWARE_ONLINE_CHECK_OK");

    auto event = event_queue.pop();
    if (event) {
        std::cout << "Telemetry Event: " << *event << "\n";
    }

    std::cout << "System initialized successfully.\n";
    return 0;
}
