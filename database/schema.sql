DO $$
DECLARE
    enum_definition RECORD;
BEGIN
    FOR enum_definition IN
        SELECT type_name, labels
        FROM (VALUES
            ('compartment_tier', ARRAY['SMALL', 'MEDIUM', 'LARGE', 'REFRIGERATED']),
            ('compartment_state', ARRAY['AVAILABLE', 'RESERVED', 'OCCUPIED', 'MAINTENANCE']),
            ('parcel_status', ARRAY['CREATED', 'ASSIGNED_TO_COURIER', 'IN_TRANSIT', 'STORED_IN_LOCKER', 'DELIVERED', 'SECURITY_LOCKED', 'EXPIRED_RETURN_PENDING', 'RETURNED']),
            ('courier_shift_status', ARRAY['ON_DUTY', 'OFF_DUTY']),
            ('assignment_purpose', ARRAY['DELIVERY', 'RETURN']),
            ('assignment_status', ARRAY['ACTIVE', 'COMPLETED', 'CANCELLED']),
            ('pickup_pin_status', ARRAY['ACTIVE', 'USED', 'EXPIRED', 'REVOKED']),
            ('audit_event_type', ARRAY['DOOR_OPENED', 'DOOR_CLOSED', 'STATUS_CHANGED', 'COMPARTMENT_STATE_CHANGED', 'ACCESS_GRANTED', 'ACCESS_DENIED', 'PIN_ATTEMPT_FAILED']),
            ('notification_kind', ARRAY['PIN_ISSUED', 'RETURN_SCHEDULED', 'REDIRECTED']),
            ('notification_status', ARRAY['PENDING', 'CLAIMED', 'SENT', 'FAILED'])
        ) AS enum_definitions (type_name, labels)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = enum_definition.type_name) THEN
            EXECUTE format(
                'CREATE TYPE %I AS ENUM (%s)',
                enum_definition.type_name,
                (SELECT string_agg(quote_literal(label), ', ') FROM unnest(enum_definition.labels) AS label)
            );
        END IF;
    END LOOP;
END
$$;

CREATE TABLE IF NOT EXISTS stations (
    station_id          VARCHAR(32) PRIMARY KEY,
    name                VARCHAR(128) NOT NULL,
    address             VARCHAR(256) NOT NULL,
    latitude            NUMERIC(9, 6) NOT NULL CHECK (latitude BETWEEN 49.0 AND 54.9),
    longitude           NUMERIC(9, 6) NOT NULL CHECK (longitude BETWEEN 14.1 AND 24.2),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS station_fallbacks (
    station_id          VARCHAR(32) NOT NULL REFERENCES stations(station_id) ON DELETE CASCADE,
    fallback_station_id VARCHAR(32) NOT NULL REFERENCES stations(station_id) ON DELETE CASCADE,
    PRIMARY KEY (station_id, fallback_station_id),
    CONSTRAINT station_fallbacks_distinct_stations CHECK (station_id <> fallback_station_id)
);

CREATE TABLE IF NOT EXISTS compartment_tier_specs (
    tier                compartment_tier PRIMARY KEY,
    max_weight_kg       NUMERIC(6, 2) NOT NULL CHECK (max_weight_kg > 0),
    width_cm            NUMERIC(6, 2) NOT NULL CHECK (width_cm > 0),
    height_cm           NUMERIC(6, 2) NOT NULL CHECK (height_cm > 0),
    depth_cm            NUMERIC(6, 2) NOT NULL CHECK (depth_cm > 0)
);

CREATE TABLE IF NOT EXISTS compartments (
    compartment_id      VARCHAR(32) PRIMARY KEY,
    station_id          VARCHAR(32) NOT NULL REFERENCES stations(station_id) ON DELETE CASCADE,
    tier                compartment_tier NOT NULL REFERENCES compartment_tier_specs(tier) ON DELETE RESTRICT,
    state               compartment_state NOT NULL DEFAULT 'AVAILABLE',
    is_locked           BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name           VARCHAR(128) NOT NULL,
    phone_number        VARCHAR(32) NOT NULL UNIQUE,
    email               VARCHAR(128) NOT NULL UNIQUE CHECK (email LIKE '%_@_%'),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS couriers (
    courier_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name           VARCHAR(128) NOT NULL,
    phone_number        VARCHAR(32) NOT NULL UNIQUE,
    shift_status        courier_shift_status NOT NULL DEFAULT 'OFF_DUTY',
    vehicle_plate       VARCHAR(32),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS parcels (
    tracking_number         VARCHAR(64) PRIMARY KEY,
    sender_id               UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    recipient_id            UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    target_station_id       VARCHAR(32) NOT NULL REFERENCES stations(station_id) ON DELETE RESTRICT,
    compartment_id          VARCHAR(32) REFERENCES compartments(compartment_id) ON DELETE RESTRICT,
    status                  parcel_status NOT NULL DEFAULT 'CREATED',
    weight_kg               NUMERIC(6, 2) NOT NULL CHECK (weight_kg > 0),
    width_cm                NUMERIC(6, 2) NOT NULL CHECK (width_cm > 0),
    height_cm               NUMERIC(6, 2) NOT NULL CHECK (height_cm > 0),
    depth_cm                NUMERIC(6, 2) NOT NULL CHECK (depth_cm > 0),
    requires_refrigeration  BOOLEAN NOT NULL DEFAULT FALSE,
    stored_at               TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT parcels_distinct_sender_and_recipient CHECK (sender_id <> recipient_id),
    CONSTRAINT parcels_stored_status_requires_compartment CHECK (
        status NOT IN ('STORED_IN_LOCKER', 'SECURITY_LOCKED', 'EXPIRED_RETURN_PENDING')
        OR (compartment_id IS NOT NULL AND stored_at IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS courier_assignments (
    assignment_id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tracking_number     VARCHAR(64) NOT NULL REFERENCES parcels(tracking_number) ON DELETE RESTRICT,
    courier_id          UUID NOT NULL REFERENCES couriers(courier_id) ON DELETE RESTRICT,
    purpose             assignment_purpose NOT NULL,
    status              assignment_status NOT NULL DEFAULT 'ACTIVE',
    assigned_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at        TIMESTAMPTZ,
    CONSTRAINT courier_assignments_completion_order CHECK (completed_at IS NULL OR completed_at >= assigned_at),
    CONSTRAINT courier_assignments_completed_has_time CHECK ((status = 'COMPLETED') = (completed_at IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS pickup_pins (
    pin_id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tracking_number     VARCHAR(64) NOT NULL REFERENCES parcels(tracking_number) ON DELETE RESTRICT,
    pin_hash            VARCHAR(128) NOT NULL,
    status              pickup_pin_status NOT NULL DEFAULT 'ACTIVE',
    issued_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at          TIMESTAMPTZ NOT NULL,
    failed_attempts     INT NOT NULL DEFAULT 0 CHECK (failed_attempts BETWEEN 0 AND 3),
    CONSTRAINT pickup_pins_expiry_after_issue CHECK (expires_at > issued_at)
);

CREATE TABLE IF NOT EXISTS parcel_status_transitions (
    from_status         parcel_status NOT NULL,
    to_status           parcel_status NOT NULL,
    PRIMARY KEY (from_status, to_status),
    CONSTRAINT parcel_status_transitions_change_status CHECK (from_status <> to_status)
);

CREATE TABLE IF NOT EXISTS audit_event_log (
    event_id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entity_name         VARCHAR(64) NOT NULL,
    entity_id           VARCHAR(64) NOT NULL,
    event_type          audit_event_type NOT NULL,
    actor_role          NAME NOT NULL DEFAULT current_user,
    details             JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS notification_outbox (
    notification_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tracking_number     VARCHAR(64) NOT NULL REFERENCES parcels(tracking_number) ON DELETE RESTRICT,
    recipient_id        UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    kind                notification_kind NOT NULL,
    payload             JSONB NOT NULL DEFAULT '{}'::jsonb,
    status              notification_status NOT NULL DEFAULT 'PENDING',
    attempts            INT NOT NULL DEFAULT 0 CHECK (attempts >= 0),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    claimed_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_parcels_one_parcel_per_compartment
    ON parcels (compartment_id) WHERE compartment_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS ux_courier_assignments_one_active_per_purpose
    ON courier_assignments (tracking_number, purpose) WHERE status = 'ACTIVE';

CREATE UNIQUE INDEX IF NOT EXISTS ux_pickup_pins_one_active_per_parcel
    ON pickup_pins (tracking_number) WHERE status = 'ACTIVE';

CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_compartments_set_updated_at ON compartments;
CREATE TRIGGER trg_compartments_set_updated_at
    BEFORE UPDATE ON compartments
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_parcels_set_updated_at ON parcels;
CREATE TRIGGER trg_parcels_set_updated_at
    BEFORE UPDATE ON parcels
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
