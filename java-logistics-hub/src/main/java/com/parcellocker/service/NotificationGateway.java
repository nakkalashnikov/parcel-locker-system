package com.parcellocker.service;

import java.util.concurrent.CompletableFuture;

/**
 * Strategy interface for asynchronous customer notifications.
 * Fulfills Polymorphism, Interface, and Parallel Programming requirements.
 */
public interface NotificationGateway {

    /**
     * Asynchronously dispatches a notification message.
     * @param recipient Target destination (phone number or email)
     * @param message Payload text
     * @return CompletableFuture holding dispatch result
     */
    CompletableFuture<Boolean> sendAsync(String recipient, String message);

    /**
     * Supported notification channel identifier.
     * @return channel name
     */
    String getChannelName();
}
