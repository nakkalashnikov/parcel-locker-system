#pragma once

#include "domain/Dimensions.hpp"
#include "domain/Enums.hpp"
#include "domain/Parcel.hpp"
#include <memory>
#include <optional>
#include <string>

namespace locker::interface {

/**
 * @brief Abstract polymorphic base class for all locker compartments.
 * Satisfies Prof. Kutria's requirements for inheritance, virtual methods,
 * and polymorphism.
 */
class ICompartment {
public:
    virtual ~ICompartment() = default;

    [[nodiscard]] virtual const std::string& getId() const noexcept = 0;
    [[nodiscard]] virtual domain::CompartmentTier getTier() const noexcept = 0;
    [[nodiscard]] virtual domain::CompartmentState getState() const noexcept = 0;
    [[nodiscard]] virtual const domain::Dimensions& getCapacity() const noexcept = 0;
    [[nodiscard]] virtual bool isDoorLocked() const noexcept = 0;

    /// Pure virtual: Determines if this specific compartment can accommodate the parcel.
    [[nodiscard]] virtual bool canAccommodate(const domain::Parcel& parcel) const noexcept = 0;

    /// Mutates compartment state to OCCUPIED and stores parcel reference.
    virtual void depositParcel(domain::Parcel parcel) = 0;

    /// Releases parcel and marks compartment as AVAILABLE.
    virtual domain::Parcel retrieveParcel() = 0;

    /// Hardware actuation
    virtual void lockDoor() = 0;
    virtual void unlockDoor() = 0;
};

using CompartmentPtr = std::unique_ptr<ICompartment>;

} // namespace locker::interface
