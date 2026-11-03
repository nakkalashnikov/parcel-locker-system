package com.parcellocker.service;

import java.util.concurrent.CompletableFuture;

public interface NotificationGateway {

    CompletableFuture<Boolean> sendAsync(String recipient, String message);

    String getChannelName();
}
