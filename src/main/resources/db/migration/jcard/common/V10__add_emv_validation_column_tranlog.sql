ALTER TABLE tranlog
    ADD COLUMN IF NOT EXISTS emv_validations jsonb;
