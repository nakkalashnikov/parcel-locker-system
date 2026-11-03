#pragma once

#include "domain/Dimensions.hpp"
#include "domain/Enums.hpp"
#include "domain/Parcel.hpp"
#include <memory>
#include <optional>
#include <string>

namespace locker::interface {

class ICompartment {
public:
    virtual ~ICompartment() = default;

    [[nodiscard]] virtual const std::string& getId() const noexcept = 0;
    [[nodiscard]] virtual domain::CompartmentTier getTier() const noexcept = 0;
    [[nodiscard]] virtual domain::CompartmentState getState() const noexcept = 0;
    [[nodiscard]] virtual const domain::Dimensions& getCapacity() const noexcept = 0;
    [[nodiscard]] virtual bool isDoorLocked() const noexcept = 0;

    [[nodiscard]] virtual bool canAccommodate(const domain::Parcel& parcel) const noexcept = 0;
    virtual void depositParcel(domain::Parcel parcel) = 0;
    virtual domain::Parcel retrieveParcel() = 0;

    virtual void lockDoor() = 0;
    virtual void unlockDoor() = 0;
};

using CompartmentPtr = std::unique_ptr<ICompartment>;

}
