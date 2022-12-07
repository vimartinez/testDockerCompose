create table key_set
(
    id     bigint NOT NULL,
    name   text,
    cvk    text,
    mdk_ac text,
    pek    text,
    pvk_a  text,
    pvk_b  text,
    pvk_i  text,

    PRIMARY KEY (id),
    UNIQUE (name)
);

insert into key_set
    (id, name, cvk, mdk_ac, pek, pvk_a, pvk_b, pvk_i)
values (nextval('hibernate_sequence'),
        'visa-key-set',
        'HSM_CVK',
        'HSM_MDK',
        'HSM_PEK',
        'HSM_PVKA',
        'HSM_PVKB',
        'HSM_PVKI'),
       (nextval('hibernate_sequence'),
        'mastercard-key-set',
        'HSM_MASTERCARD_CVK',
        'HSM_MASTERCARD_MDK',
        'HSM_MASTERCARD_PEK',
        'HSM_MASTERCARD_PVKA',
        'HSM_MASTERCARD_PVKB',
        'HSM_MASTERCARD_PVKI');