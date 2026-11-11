#pragma once

#include <cmath>
#include <locale>
#include <memory>
#include <ostream>

namespace flutter {
class EncodableValue;

// Flutter's event-channel diagnostic streams a unique_ptr, which MSVC accepts.
// Keep the preview on C++17 and provide that diagnostic operator through ADL.
inline std::ostream& operator<<(std::ostream& stream,
    const std::unique_ptr<EncodableValue>& value) {
    return stream << static_cast<const void*>(value.get());
}
}
