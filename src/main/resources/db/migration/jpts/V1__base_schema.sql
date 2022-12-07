
CREATE TABLE batch (
    id bigint NOT NULL,
    creditcount bigint,
    creditamount numeric(16,2),
    creditcashbackcount bigint,
    creditcashbackamount numeric(16,2),
    creditreversalcount bigint,
    creditreversalamount numeric(16,2),
    debitcount bigint,
    debitamount numeric(16,2),
    debitcashbackcount bigint,
    debitcashbackamount numeric(16,2),
    debitreversalcount bigint,
    debitreversalamount numeric(16,2),
    compcreditcount bigint,
    compcreditamount numeric(16,2),
    compcreditcashbackcount bigint,
    compcreditcashbackamount numeric(16,2),
    compcreditreversalcount bigint,
    compcreditreversalamount numeric(16,2),
    compdebitcount bigint,
    compdebitamount numeric(16,2),
    compdebitcashbackcount bigint,
    compdebitcashbackamount numeric(16,2),
    compdebitreversalcount bigint,
    compdebitreversalamount numeric(16,2)
);

CREATE TABLE binrange (
    id bigint NOT NULL,
    start text,
    "end" text,
    weight integer,
    cardproduct bigint
);

CREATE TABLE cardproducts (
    id bigint NOT NULL,
    name text,
    active character(1),
    pos character(1),
    atm character(1),
    moto character(1),
    ecommerce character(1),
    startdate date,
    enddate date,
    ds text,
    pvk text,
    cvvoffset integer,
    servicecodeoffset integer
);


CREATE TABLE consumer (
    id text NOT NULL,
    hash text,
    active character(1),
    deleted character(1),
    startdate date,
    enddate date,
    eeuser bigint
);


CREATE TABLE consumer_props (
    id text NOT NULL,
    propname text NOT NULL,
    propvalue text
);


CREATE TABLE consumer_roles (
    consumer text NOT NULL,
    role bigint NOT NULL
);

CREATE TABLE eeuser (
    id bigint NOT NULL,
    nick text NOT NULL,
    passwordhash text,
    name text,
    email text,
    active character(1),
    deleted character(1),
    verified character(1),
    startdate date,
    enddate date,
    forcepasswordchange character(1),
    lastlogin timestamp without time zone,
    passwordchanged timestamp without time zone,
    loginattempts integer
);

CREATE TABLE eeuser_passwordhistory (
    eeuser bigint NOT NULL,
    id integer NOT NULL,
    value text NOT NULL
);


CREATE TABLE eeuser_props (
    id bigint NOT NULL,
    propname text NOT NULL,
    propvalue text
);

CREATE TABLE eeuser_roles (
    eeuser bigint NOT NULL,
    role bigint NOT NULL
);

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE realm (
    id bigint NOT NULL,
    description text,
    name text
);

CREATE SEQUENCE realm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE revision (
    id bigint NOT NULL,
    date timestamp without time zone,
    info text,
    ref text,
    author bigint
);

CREATE TABLE role (
    id bigint NOT NULL,
    name text NOT NULL,
    realm bigint,
    parent bigint
);


CREATE TABLE role_perms (
    role bigint NOT NULL,
    name text NOT NULL
);

CREATE TABLE ruleinfo (
    id bigint NOT NULL,
    clazz text,
    param text,
    ss text,
    ds text,
    cardproduct bigint
);

CREATE TABLE stations (
    id bigint NOT NULL,
    name text,
    zmk text,
    zpk text,
    newzpk text,
    zmkkcv text,
    zpkkcv text,
    newzpkkcv text,
    status text,
    lastecho timestamp without time zone,
    lastzpkchange timestamp without time zone
);

CREATE TABLE sysconfig (
    id text NOT NULL,
    readperm text,
    value text,
    writeperm text
);

CREATE TABLE syslog (
    id bigint NOT NULL,
    date timestamp without time zone,
    deleted character(1),
    source text,
    type text,
    severity integer,
    summary text,
    detail text,
    trace text
);


CREATE TABLE tranlog (
    id bigint NOT NULL,
    subclass text NOT NULL,
    localid bigint,
    node text,
    ss text,
    ds text,
    acquirer text,
    forwarding text,
    mid text,
    tid text,
    hash text,
    kid text,
    securedata bytea,
    ss_stan text,
    ss_rrn text,
    ds_rrn text,
    ds_stan text,
    ca_name text,
    ca_city text,
    ca_region text,
    ca_postal_code text,
    ca_country text,
    mcc text,
    functioncode text,
    sstransportdata text,
    dstransportdata text,
    posdatacode bytea,
    responsecode text,
    approvalnumber text,
    displaymessage text,
    reversalcount integer,
    reversalid bigint,
    completioncount integer,
    completionid bigint,
    voidcount integer,
    voidid bigint,
    notificationcount integer,
    originalmti text,
    date timestamp without time zone NOT NULL,
    transmissiondate timestamp without time zone,
    localtransactiondate timestamp without time zone,
    capturedate date,
    settlementdate date,
    batchnumber bigint,
    sourcebatchnumber bigint,
    destinationbatchnumber bigint,
    itc text,
    srcaccttype text,
    destaccttype text,
    irc text,
    currencycode text,
    amount numeric(16,2),
    additionalamount numeric(16,2),
    amountcardholderbilling numeric(16,2),
    acquirerfee numeric(16,2),
    issuerfee numeric(16,2),
    returnedbalances text,
    rc text,
    extrc text,
    duration integer,
    outstanding integer,
    ssrc text,
    dsrc text,
    sspcode text,
    dspcode text,
    cardproduct bigint,
    refid bigint,
    notification bigint
);


CREATE TABLE tranlog_followups (
    id bigint NOT NULL,
    date timestamp without time zone,
    detail text,
    tranlog bigint
);

CREATE TABLE velocity_profiles (
    id bigint NOT NULL,
    name text,
    active character(1) NOT NULL,
    approvalsonly character(1) NOT NULL,
    scopecard character(1),
    scopeaccount character(1),
    validonpurchase character(1),
    validonwithdrawal character(1),
    validontransfer character(1),
    currencycode text NOT NULL,
    numberofdays integer NOT NULL,
    usagelimit integer NOT NULL,
    amountlimit numeric(15,2) NOT NULL
);

ALTER TABLE ONLY realm ALTER COLUMN id SET DEFAULT nextval('realm_id_seq'::regclass);
ALTER TABLE ONLY batch ADD CONSTRAINT batch_pkey PRIMARY KEY (id);
ALTER TABLE ONLY binrange ADD CONSTRAINT binrange_pkey PRIMARY KEY (id);
ALTER TABLE ONLY cardproducts ADD CONSTRAINT cardproducts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY consumer ADD CONSTRAINT consumer_pkey PRIMARY KEY (id);
ALTER TABLE ONLY consumer_props ADD CONSTRAINT consumer_props_pkey PRIMARY KEY (id, propname);
ALTER TABLE ONLY consumer_roles ADD CONSTRAINT consumer_roles_pkey PRIMARY KEY (consumer, role);
ALTER TABLE ONLY eeuser_passwordhistory ADD CONSTRAINT eeuser_passwordhistory_pkey PRIMARY KEY (eeuser, id);
ALTER TABLE ONLY eeuser ADD CONSTRAINT eeuser_pkey PRIMARY KEY (id);
ALTER TABLE ONLY eeuser_props ADD CONSTRAINT eeuser_props_pkey PRIMARY KEY (id, propname);
ALTER TABLE ONLY eeuser_roles ADD CONSTRAINT eeuser_roles_pkey PRIMARY KEY (eeuser, role);
ALTER TABLE ONLY realm ADD CONSTRAINT realm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY revision ADD CONSTRAINT revision_pkey PRIMARY KEY (id);
ALTER TABLE ONLY role_perms ADD CONSTRAINT role_perms_pkey PRIMARY KEY (role, name);
ALTER TABLE ONLY role ADD CONSTRAINT role_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ruleinfo ADD CONSTRAINT ruleinfo_pkey PRIMARY KEY (id);
ALTER TABLE ONLY stations ADD CONSTRAINT stations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sysconfig ADD CONSTRAINT sysconfig_pkey PRIMARY KEY (id);
ALTER TABLE ONLY syslog ADD CONSTRAINT syslog_pkey PRIMARY KEY (id);
ALTER TABLE ONLY tranlog_followups ADD CONSTRAINT tranlog_followups_pkey PRIMARY KEY (id);
ALTER TABLE ONLY tranlog ADD CONSTRAINT tranlog_pkey PRIMARY KEY (id);
ALTER TABLE ONLY stations ADD CONSTRAINT uk_station_name UNIQUE (name);
ALTER TABLE ONLY eeuser ADD CONSTRAINT uk_eeuser_nick UNIQUE (nick);
ALTER TABLE ONLY realm ADD CONSTRAINT uk_realm_name UNIQUE (name);
ALTER TABLE ONLY role ADD CONSTRAINT uk_rolerealmname UNIQUE (name, realm);
ALTER TABLE ONLY velocity_profiles ADD CONSTRAINT velocity_profiles_pkey PRIMARY KEY (id);

CREATE INDEX approvalnumber ON tranlog USING btree (approvalnumber);
CREATE INDEX batchnumber ON tranlog USING btree (batchnumber);
CREATE INDEX date ON tranlog USING btree (date);
CREATE INDEX ds_rrn ON tranlog USING btree (ds_rrn);
CREATE INDEX ds_stan ON tranlog USING btree (ds_stan);
CREATE INDEX eeuser_nick ON eeuser USING btree (nick);
CREATE INDEX hash ON tranlog USING btree (hash);
CREATE INDEX mid ON tranlog USING btree (mid);
CREATE INDEX ref ON revision USING btree (ref);
CREATE INDEX ss_rrn ON tranlog USING btree (ss_rrn);
CREATE INDEX ss_stan ON tranlog USING btree (ss_stan);
CREATE INDEX tid ON tranlog USING btree (tid);
ALTER TABLE ONLY ruleinfo ADD CONSTRAINT fk_ruleinfo_cardproduct FOREIGN KEY (cardproduct) REFERENCES cardproducts(id);
ALTER TABLE ONLY tranlog ADD CONSTRAINT fk_tranlog_ref_tranlog_id FOREIGN KEY (refid) REFERENCES tranlog(id);
ALTER TABLE ONLY role ADD CONSTRAINT fk_roleparent FOREIGN KEY (parent) REFERENCES role(id);
ALTER TABLE ONLY role_perms ADD CONSTRAINT fk_rolepermissions FOREIGN KEY (role) REFERENCES role(id);
ALTER TABLE ONLY role ADD CONSTRAINT fk_rolerealm FOREIGN KEY (realm) REFERENCES realm(id);
ALTER TABLE ONLY binrange ADD CONSTRAINT fk_binrange_cardproduct FOREIGN KEY (cardproduct) REFERENCES cardproducts(id);
ALTER TABLE ONLY consumer_props ADD CONSTRAINT fkconsumerprops FOREIGN KEY (id) REFERENCES consumer(id);
ALTER TABLE ONLY consumer_roles ADD CONSTRAINT fkconsumerrolesconsumer FOREIGN KEY (consumer) REFERENCES consumer(id);
ALTER TABLE ONLY consumer_roles ADD CONSTRAINT fkconsumerrolesrole FOREIGN KEY (role) REFERENCES role(id);
ALTER TABLE ONLY consumer ADD CONSTRAINT fkconsumeruser FOREIGN KEY (eeuser) REFERENCES eeuser(id);
ALTER TABLE ONLY eeuser_passwordhistory ADD CONSTRAINT fk_eeuser_password_eeuser FOREIGN KEY (eeuser) REFERENCES eeuser(id);
ALTER TABLE ONLY tranlog ADD CONSTRAINT fk_tranlog_not_tranlog FOREIGN KEY (notification) REFERENCES tranlog(id);
ALTER TABLE ONLY revision ADD CONSTRAINT fk_revision_eeuser FOREIGN KEY (author) REFERENCES eeuser(id);
ALTER TABLE ONLY tranlog_followups ADD CONSTRAINT fk_tranlog_followup_tranlog FOREIGN KEY (tranlog) REFERENCES tranlog(id);
ALTER TABLE ONLY tranlog ADD CONSTRAINT fk_tranlog_cardproduct FOREIGN KEY (cardproduct) REFERENCES cardproducts(id);
ALTER TABLE ONLY eeuser_props ADD CONSTRAINT fkuserprops FOREIGN KEY (id) REFERENCES eeuser(id);
ALTER TABLE ONLY eeuser_roles ADD CONSTRAINT fkuserrolesrole FOREIGN KEY (role) REFERENCES role(id);
ALTER TABLE ONLY eeuser_roles ADD CONSTRAINT fkuserrolesuser FOREIGN KEY (eeuser) REFERENCES eeuser(id);
