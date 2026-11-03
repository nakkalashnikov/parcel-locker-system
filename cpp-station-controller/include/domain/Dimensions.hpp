#pragma once

#include <iostream>
#include <stdexcept>

namespace locker::domain {

struct Dimensions {
    double width_cm{0.0};
    double height_cm{0.0};
    double depth_cm{0.0};
    double weight_kg{0.0};

    [[nodiscard]] constexpr double volumeCm3() const noexcept {
        return width_cm * height_cm * depth_cm;
    }

    [[nodiscard]] constexpr bool fitsWithin(const Dimensions& container) const noexcept {
        return width_cm <= container.width_cm &&
               height_cm <= container.height_cm &&
               depth_cm <= container.depth_cm &&
               weight_kg <= container.weight_kg;
    }

    bool operator<(const Dimensions& other) const noexcept {
        return volumeCm3() < other.volumeCm3();
    }

    friend std::ostream& operator<<(std::ostream& os, const Dimensions& d) {
        return os << d.width_cm << "x" << d.height_cm << "x" << d.depth_cm
                  << " cm, " << d.weight_kg << " kg";
    }
};

}
