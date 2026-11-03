#include "domain/Dimensions.hpp"
#include "domain/Enums.hpp"
#include "domain/Parcel.hpp"
#include "concurrency/SafeQueue.hpp"
#include <iostream>

using namespace std;

int main() {
    cout << "====================================================\n";
    cout << "  Parcel Locker Terminal Station Controller v1.0\n";
    cout << "====================================================\n";

    locker::domain::Dimensions box_size{30.0, 15.0, 50.0, 4.5};
    locker::domain::Parcel parcel("WAW-992819", "+48501111222", box_size);

    cout << "Parcel: " << parcel.getTrackingNumber() << "\n";
    cout << "Dimensions: " << parcel.getDimensions() << "\n";
    cout << "Status: " << locker::domain::toString(parcel.getStatus()) << "\n";

    locker::concurrency::SafeQueue<string> event_queue(10);
    event_queue.push("HARDWARE_ONLINE_CHECK_OK");

    auto event = event_queue.pop();
    if (event) {
        cout << "Event: " << *event << "\n";
    }

    return 0;
}
