CREATE TABLE shipping_detail
(
    id            bigint       NOT NULL,
    street        varchar(255) NOT NULL,
    street_number varchar(10)  NOT NULL,
    city          varchar(40)  NOT NULL,
    state         varchar(5)   NOT NULL,
    country       varchar(3)   NOT NULL,
    postal_code   varchar(10)  NOT NULL,
    floor         varchar(2),
    apt           varchar(3),
    extra_comment varchar(255),
    CONSTRAINT shipping_detail_pk PRIMARY KEY (id)
);

ALTER TABLE fulfillment_detail
    ALTER COLUMN tracking_id DROP NOT NULL,
    ADD COLUMN shipping_detail_id bigint,
    ADD COLUMN code_currier varchar(10),
    ADD CONSTRAINT fk_shipping_detail FOREIGN KEY (shipping_detail_id) REFERENCES shipping_detail(id);