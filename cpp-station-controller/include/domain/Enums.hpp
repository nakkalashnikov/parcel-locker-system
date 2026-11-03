#pragma once

#include <string_view>

namespace locker::domain {

enum class ParcelStatus {
    Created,
    AssignedToCourier,
    InTransit,
    StoredInLocker,
    Delivered,
    SecurityLocked,
    ExpiredReturnPending
};

enum class CompartmentTier {
    Small,
    Medium,
    Large,
    Refrigerated
};

enum class CompartmentState {
    Available,
    Reserved,
    Occupied,
    Maintenance
};

[[nodiscard]] constexpr std::string_view toString(ParcelStatus status) noexcept {
    switch (status) {
        case ParcelStatus::Created: return "CREATED";
        case ParcelStatus::AssignedToCourier: return "ASSIGNED_TO_COURIER";
        case ParcelStatus::InTransit: return "IN_TRANSIT";
        case ParcelStatus::StoredInLocker: return "STORED_IN_LOCKER";
        case ParcelStatus::Delivered: return "DELIVERED";
        case ParcelStatus::SecurityLocked: return "SECURITY_LOCKED";
        case ParcelStatus::ExpiredReturnPending: return "EXPIRED_RETURN_PENDING";
    }
    return "UNKNOWN";
}

[[nodiscard]] constexpr std::string_view toString(CompartmentTier tier) noexcept {
    switch (tier) {
        case CompartmentTier::Small: return "SMALL";
        case CompartmentTier::Medium: return "MEDIUM";
        case CompartmentTier::Large: return "LARGE";
        case CompartmentTier::Refrigerated: return "REFRIGERATED";
    }
    return "UNKNOWN";
}

[[nodiscard]] constexpr std::string_view toString(CompartmentState state) noexcept {
    switch (state) {
        case CompartmentState::Available: return "AVAILABLE";
        case CompartmentState::Reserved: return "RESERVED";
        case CompartmentState::Occupied: return "OCCUPIED";
        case CompartmentState::Maintenance: return "MAINTENANCE";
    }
    return "UNKNOWN";
}

} // namespace locker::domain
