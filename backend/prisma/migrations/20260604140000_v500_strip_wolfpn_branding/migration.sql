-- ─── v5.0.0: убрать-брендинг из seed-данных существующих БД ────────────


-- 1) auto_broadcast_rules.message — убираем «к» / «в»
UPDATE auto_broadcast_rules
SET message = REPLACE(message, 'к WolfPN, но', ', но'),
    updated_at = NOW()
WHERE message LIKE '%к WolfPN, но%';

UPDATE auto_broadcast_rules
SET message = REPLACE(message, 'в WolfPN —', '—'),
    updated_at = NOW()
WHERE message LIKE '%в WolfPN —%';

-- Общий fallback на любую оставшуюся «» (на случай если админ слегка переписал)
UPDATE auto_broadcast_rules
SET message = REPLACE(REPLACE(message, ' WolfPN', ''), 'WolfPN', ''),
    updated_at = NOW()
WHERE message LIKE '%WolfPN%';

-- Если в тексте остались волчий emoji 🐺 рядом с пустотой — удаляем хвосты " 🐺"
UPDATE auto_broadcast_rules
SET message = REGEXP_REPLACE(message, '\s*🐺\s*', ' 🛡 ', 'g'),
    updated_at = NOW()
WHERE message LIKE '%🐺%';

-- 2) auto_broadcast_rules.button_url / button2_url — заменяем хардкод @Testv2wolfpnbot
--    на универсальный internal-link menu:tariffs.
UPDATE auto_broadcast_rules
SET button_url = 'menu:tariffs',
    updated_at = NOW()
WHERE button_url LIKE '%wolfpnbot%' OR button_url LIKE '%Testv2wolfpn%';

UPDATE auto_broadcast_rules
SET button2_url = 'menu:tariffs',
    updated_at = NOW()
WHERE button2_url LIKE '%wolfpnbot%' OR button2_url LIKE '%Testv2wolfpn%';

-- 3) system_settings: text-поля с в дефолтах (proxy_help_text, gift_text, bot_welcome_text)
UPDATE system_settings
SET value = REPLACE(REPLACE(value, 'WolfPN', 'VPN'), 'WolfPN', 'VPN')
WHERE value ILIKE '%WolfPN%';
