ALTER TABLE card_state_transition
    DROP COLUMN tracking_id,
    DROP COLUMN created_time;

ALTER TABLE card_state_transition
    ADD COLUMN updated_at  timestamp without time zone NOT NULL,
    ADD COLUMN type  varchar(10) NOT NULL,
    ADD COLUMN token        varchar(50) NOT NULL;

ALTER TABLE public.card
    DROP CONSTRAINT card_hash_key;