CREATE TABLE saf.message_queue
(
    id                       bigint NOT NULL,
    original_mti             text,
    original_pcode           text,
    ds_name                  text,
    secure_data              bytea,
    data                     jsonb,
    number_of_retries        bigint,
    last_attempt             timestamp with time zone,
    last_attempt_message     jsonb,
    last_successful_attempt  timestamp with time zone,
    last_failed_attempt      timestamp with time zone,
    status                   text,
    trace_id                 text
);

CREATE TABLE saf.destination_settings
(
    id                     bigint NOT NULL,
    ds_name                text UNIQUE,
    max_attempts           bigint,
    exp_backoff_multiplier integer
);

ALTER TABLE ONLY saf.message_queue
    ADD CONSTRAINT fk_dsname_dst_settings FOREIGN KEY (ds_name) REFERENCES saf.destination_settings (ds_name);

INSERT INTO saf.destination_settings (id, ds_name, max_attempts, exp_backoff_multiplier) VALUES (1, 'jpts', 3, 2 )
