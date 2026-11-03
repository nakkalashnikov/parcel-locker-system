-- ============================================================================
-- Parcel Locker Delivery System — Relational Schema (PostgreSQL 15+)
-- Complies with 3NF Normalization and Business Rules BR1 - BR8
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ----------------------------------------------------------------------------
-- 1. Physical Stations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stations (
    station_id          VARCHAR(32) PRIMARY KEY,
    name                VARCHAR(128) NOT NULL,
    address             VARCHAR(256) NOT NULL,
    latitude            NUMERIC(9, 6) NOT NULL,
    longitude           NUMERIC(9, 6) NOT NULL,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 2. Compartment Types & Compartments
-- ----------------------------------------------------------------------------
CREATE TYPE compartment_tier AS ENUM ('SMALL', 'MEDIUM', 'LARGE', 'REFRIGERATED');
CREATE TYPE compartment_state AS ENUM ('AVAILABLE', 'RESERVED', 'OCCUPIED', 'MAINTENANCE');

CREATE TABLE IF NOT EXISTS compartments (
    compartment_id      VARCHAR(32) PRIMARY KEY,
    station_id          VARCHAR(32) NOT NULL REFERENCES stations(station_id) ON DELETE CASCADE,
    tier                compartment_tier NOT NULL,
    state               compartment_state NOT NULL DEFAULT 'AVAILABLE',
    max_weight_kg       NUMERIC(6, 2) NOT NULL CHECK (max_weight_kg > 0),
    width_cm            NUMERIC(6, 2) NOT NULL CHECK (width_cm > 0),
    height_cm           NUMERIC(6, 2) NOT NULL CHECK (height_cm > 0),
    depth_cm            NUMERIC(6, 2) NOT NULL CHECK (depth_cm > 0),
    is_locked           BOOLEAN NOT NULL DEFAULT TRUE,
    last_modified       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 3. Users: Customers & Couriers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name           VARCHAR(128) NOT NULL,
    phone_number        VARCHAR(32) NOT NULL UNIQUE,
    email               VARCHAR(128) NOT NULL UNIQUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS couriers (
    courier_id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name           VARCHAR(128) NOT NULL,
    phone_number        VARCHAR(32) NOT NULL UNIQUE,
    is_on_duty          BOOLEAN NOT NULL DEFAULT FALSE,
    vehicle_plate       VARCHAR(32),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 4. Parcels
-- ----------------------------------------------------------------------------
CREATE TYPE parcel_status AS ENUM (
    'CREATED',
    'ASSIGNED_TO_COURIER',
    'IN_TRANSIT',
    'STORED_IN_LOCKER',
    'DELIVERED',
    'SECURITY_LOCKED',
    'EXPIRED_RETURN_PENDING'
);

CREATE TABLE IF NOT EXISTS parcels (
    tracking_number     VARCHAR(64) PRIMARY KEY,
    sender_id           UUID NOT NULL REFERENCES customers(customer_id),
    recipient_id        UUID NOT NULL REFERENCES customers(customer_id),
    target_station_id   VARCHAR(32) NOT NULL REFERENCES stations(station_id),
    compartment_id      VARCHAR(32) REFERENCES compartments(compartment_id),
    courier_id          UUID REFERENCES couriers(courier_id),
    status              parcel_status NOT NULL DEFAULT 'CREATED',
    weight_kg           NUMERIC(6, 2) NOT NULL CHECK (weight_kg > 0),
    width_cm            NUMERIC(6, 2) NOT NULL CHECK (width_cm > 0),
    height_cm           NUMERIC(6, 2) NOT NULL CHECK (height_cm > 0),
    depth_cm            NUMERIC(6, 2) NOT NULL CHECK (depth_cm > 0),
    pickup_pin_hash     VARCHAR(128),
    pin_expiry          TIMESTAMPTZ,
    pin_failed_attempts INT NOT NULL DEFAULT 0 CHECK (pin_failed_attempts >= 0),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 5. Immutable Audit Event Log (BR6)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_event_log (
    event_id            BIGSERIAL PRIMARY KEY,
    entity_name         VARCHAR(64) NOT NULL,
    entity_id           VARCHAR(64) NOT NULL,
    event_type          VARCHAR(64) NOT NULL,
    details             JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_parcels_status ON parcels(status);
CREATE INDEX IF NOT EXISTS idx_compartments_station_state ON compartments(station_id, state);
