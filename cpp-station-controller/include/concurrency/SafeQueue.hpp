#pragma once

#include <condition_variable>
#include <mutex>
#include <optional>
#include <queue>

namespace locker::concurrency {

template <typename T>
class SafeQueue {
public:
    explicit SafeQueue(size_t max_capacity = 100)
        : max_capacity_(max_capacity) {}

    ~SafeQueue() {
        shutdown();
    }

    void push(T item) {
        std::unique_lock<std::mutex> lock(mutex_);
        cv_not_full_.wait(lock, [this]() {
            return is_shutdown_ || queue_.size() < max_capacity_;
        });

        if (is_shutdown_) {
            return;
        }

        queue_.push(std::move(item));
        cv_not_empty_.notify_one();
    }

    [[nodiscard]] std::optional<T> pop() {
        std::unique_lock<std::mutex> lock(mutex_);
        cv_not_empty_.wait(lock, [this]() {
            return is_shutdown_ || !queue_.empty();
        });

        if (queue_.empty()) {
            return std::nullopt;
        }

        T item = std::move(queue_.front());
        queue_.pop();
        cv_not_full_.notify_one();
        return item;
    }

    void shutdown() noexcept {
        {
            std::lock_guard<std::mutex> lock(mutex_);
            is_shutdown_ = true;
        }
        cv_not_empty_.notify_all();
        cv_not_full_.notify_all();
    }

    [[nodiscard]] size_t size() const noexcept {
        std::lock_guard<std::mutex> lock(mutex_);
        return queue_.size();
    }

    [[nodiscard]] bool empty() const noexcept {
        std::lock_guard<std::mutex> lock(mutex_);
        return queue_.empty();
    }

private:
    mutable std::mutex mutex_;
    std::condition_variable cv_not_empty_;
    std::condition_variable cv_not_full_;
    std::queue<T> queue_;
    size_t max_capacity_{100};
    bool is_shutdown_{false};
};

}
