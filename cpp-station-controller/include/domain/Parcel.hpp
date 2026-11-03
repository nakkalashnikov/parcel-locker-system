#pragma once

#include "domain/Dimensions.hpp"
#include "domain/Enums.hpp"
#include <string>

namespace locker::domain {

class Parcel {
public:
    Parcel(std::string tracking_number,
           std::string recipient_phone,
           Dimensions dimensions,
           bool requires_refrigeration = false)
        : tracking_number_(std::move(tracking_number)),
          recipient_phone_(std::move(recipient_phone)),
          dimensions_(dimensions),
          requires_refrigeration_(requires_refrigeration),
          status_(ParcelStatus::Created) {}

    [[nodiscard]] const std::string& getTrackingNumber() const noexcept {
        return tracking_number_;
    }

    [[nodiscard]] const std::string& getRecipientPhone() const noexcept {
        return recipient_phone_;
    }

    [[nodiscard]] const Dimensions& getDimensions() const noexcept {
        return dimensions_;
    }

    [[nodiscard]] bool requiresRefrigeration() const noexcept {
        return requires_refrigeration_;
    }

    [[nodiscard]] ParcelStatus getStatus() const noexcept {
        return status_;
    }

    void setStatus(ParcelStatus new_status) noexcept {
        status_ = new_status;
    }

private:
    std::string tracking_number_;
    std::string recipient_phone_;
    Dimensions dimensions_;
    bool requires_refrigeration_{false};
    ParcelStatus status_{ParcelStatus::Created};
};

}
