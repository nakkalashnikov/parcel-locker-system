#pragma once

#include <stdexcept>
#include <string>

namespace locker::exception {

class LockerException : public std::runtime_error {
public:
    explicit LockerException(const std::string& message)
        : std::runtime_error(message) {}
};

class CompartmentOccupiedException : public LockerException {
public:
    explicit CompartmentOccupiedException(const std::string& compartment_id)
        : LockerException("Compartment is already occupied or reserved: " + compartment_id) {}
};

class DimensionExceededException : public LockerException {
public:
    DimensionExceededException()
        : LockerException("Parcel dimensions or weight exceed compartment capacity") {}
};

class InvalidPinException : public LockerException {
public:
    InvalidPinException()
        : LockerException("Invalid pickup PIN entered") {}
};

class HardwareFaultException : public LockerException {
public:
    explicit HardwareFaultException(const std::string& component)
        : LockerException("Hardware sensor or lock failure: " + component) {}
};

}
