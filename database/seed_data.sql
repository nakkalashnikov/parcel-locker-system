-- ============================================================================
-- Parcel Locker Delivery System — Seed Dataset (Polish Logistics Network)
-- Realistic mock dataset for academic evaluation (Prof. Baraban)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Stations in Polish Major Metropolitan Areas
-- ----------------------------------------------------------------------------
INSERT INTO stations (station_id, name, address, latitude, longitude, is_active) VALUES
('WAW-001', 'Paczkomat Warszawa Centrum', 'ul. Marszałkowska 104, 00-017 Warszawa', 52.2319, 21.0067, TRUE),
('WAW-002', 'Paczkomat Warszawa Złota', 'ul. Złota 44, 00-120 Warszawa', 52.2315, 21.0028, TRUE),
('KRA-001', 'Paczkomat Kraków Stare Miasto', 'ul. Floriańska 15, 31-019 Kraków', 50.0632, 19.9398, TRUE),
('WRO-001', 'Paczkomat Wrocław Rynek', 'ul. Świdnicka 8, 50-067 Wrocław', 51.1079, 17.0315, TRUE),
('POZ-001', 'Paczkomat Poznań Stary Browar', 'ul. Półwiejska 42, 61-888 Poznań', 52.4012, 16.9272, TRUE)
ON CONFLICT (station_id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 2. Compartments for Station WAW-001 (Mixed tiers)
-- ----------------------------------------------------------------------------
INSERT INTO compartments (compartment_id, station_id, tier, state, max_weight_kg, width_cm, height_cm, depth_cm, is_locked) VALUES
('WAW-001-A01', 'WAW-001', 'SMALL', 'AVAILABLE', 5.00, 41.00, 8.00, 64.00, TRUE),
('WAW-001-A02', 'WAW-001', 'SMALL', 'AVAILABLE', 5.00, 41.00, 8.00, 64.00, TRUE),
('WAW-001-B01', 'WAW-001', 'MEDIUM', 'AVAILABLE', 15.00, 41.00, 19.00, 64.00, TRUE),
('WAW-001-B02', 'WAW-001', 'MEDIUM', 'AVAILABLE', 15.00, 41.00, 19.00, 64.00, TRUE),
('WAW-001-C01', 'WAW-001', 'LARGE', 'AVAILABLE', 25.00, 41.00, 38.00, 64.00, TRUE),
('WAW-001-R01', 'WAW-001', 'REFRIGERATED', 'AVAILABLE', 12.00, 41.00, 25.00, 64.00, TRUE)
ON CONFLICT (compartment_id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. Couriers (Polish format)
-- ----------------------------------------------------------------------------
INSERT INTO couriers (courier_id, full_name, phone_number, is_on_duty, vehicle_plate) VALUES
('c0000001-0000-0000-0000-000000000001', 'Piotr Wiśniewski', '+48 601 234 567', TRUE, 'WI 4892A'),
('c0000002-0000-0000-0000-000000000002', 'Tomasz Kowalczyk', '+48 602 345 678', TRUE, 'KR 8310E')
ON CONFLICT (phone_number) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 4. Customers
-- ----------------------------------------------------------------------------
INSERT INTO customers (customer_id, full_name, phone_number, email) VALUES
('d0000001-0000-0000-0000-000000000001', 'Jan Kowalski', '+48 501 111 222', 'jan.kowalski@example.pl'),
('d0000002-0000-0000-0000-000000000002', 'Anna Nowak', '+48 502 333 444', 'anna.nowak@example.pl')
ON CONFLICT (phone_number) DO NOTHING;
