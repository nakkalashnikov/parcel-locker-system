package com.parcellocker.repository;

import java.util.List;
import java.util.Optional;

/**
 * Generic repository interface providing CRUD abstractions.
 * Satisfies Prof. Kutria's Generic class/interface requirement.
 *
 * @param <T> Entity type
 * @param <ID> Primary key identifier type
 */
public interface Repository<T, ID> {

    /**
     * Persists or updates an entity.
     * @param entity Entity to save
     * @return Saved instance
     */
    T save(T entity);

    /**
     * Finds entity by unique primary identifier.
     * @param id Identifier
     * @return Optional containing entity if found
     */
    Optional<T> findById(ID id);

    /**
     * Retrieves all persisted instances.
     * @return List of all entities
     */
    List<T> findAll();

    /**
     * Deletes entity by identifier.
     * @param id Identifier
     * @return true if deleted, false otherwise
     */
    boolean deleteById(ID id);

    /**
     * Counts total entities in store.
     * @return count
     */
    long count();
}
