ALTER TABLE CARD_PRODUCTS
    ADD COLUMN KEY_SET_ID BIGINT,
    ADD COLUMN CVV_POSITION_ON_TRACK1 INT NOT NULL DEFAULT 7,
    ADD COLUMN CVV_POSITION_ON_TRACK2 INT NOT NULL DEFAULT 0,
    ADD COLUMN CVV_LENGTH          INT NOT NULL DEFAULT 3,
    ADD COLUMN ALLOW_INT_CASHBACK CHARACTER(1) NOT NULL DEFAULT 'N',
    ADD CONSTRAINT FK_CARD_PRODUCTS_KEY_SET FOREIGN KEY (KEY_SET_ID) REFERENCES KEY_SET (ID);