SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

-----------------------------------------------------------------------------------

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
;

SELECT pg_catalog.setval('hibernate_sequence', 1667, true);


-----------------------------------------------------------------------------------
-- TABLES CREATION ----------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE TABLE currency
(
    id     character varying(5)  NOT NULL,
    name   character varying(255),
    symbol character varying(16) NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE acct
(
    id          bigint                 NOT NULL,
    subclass    character varying(1)   NOT NULL,
    root        bigint,
    code        character varying(255) NOT NULL,
    description character varying(255),
    created     date,
    expiration  date,
    type        smallint,
    currency    character varying(5),
    parent      bigint,
    tags        character varying(255),
    PRIMARY KEY (id),
    UNIQUE (code),
    UNIQUE (root, code),
    FOREIGN KEY (root) REFERENCES acct (id),
    FOREIGN KEY (parent) REFERENCES acct (id),
    FOREIGN KEY (currency) REFERENCES currency (id)
);


CREATE TABLE journal
(
    id       bigint                NOT NULL,
    name     character varying(32) NOT NULL,
    start    date,
    end_     date,
    closed   boolean,
    lockdate date,
    chart    bigint                NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name),
    FOREIGN KEY (chart) REFERENCES acct (id)
);


CREATE TABLE acctlock
(
    journal bigint NOT NULL,
    account bigint NOT NULL,
    PRIMARY KEY (journal, account),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);


CREATE TABLE balance_cache
(
    journal bigint                NOT NULL,
    account bigint                NOT NULL,
    layers  character varying(32) NOT NULL,
    ref     bigint,
    balance numeric(14, 2)        NOT NULL,
    PRIMARY KEY (journal, account, layers),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);


CREATE TABLE issuers
(
    id              bigint                NOT NULL,
    institutionid   character varying(11) NOT NULL,
    active          character(1),
    name            character varying(40),
    tz              character varying(32),
    startdate       date,
    enddate         date,
    journal         bigint                NOT NULL,
    assetsaccount   bigint,
    earningsaccount bigint,
    lossesaccount   bigint,
    partialauthsupport char NOT NULL DEFAULT 'Y',
    PRIMARY KEY (id),
    UNIQUE (institutionid),
    FOREIGN KEY (assetsaccount) REFERENCES acct (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);


CREATE TABLE card_products
(
    id                 bigint NOT NULL,
    name               character varying(40),
    active             character(1),
    pos                character(1),
    atm                character(1),
    moto               character(1),
    ecommerce          character(1),
    tips               character(1),
    anonymous          character(1),
    startdate          date,
    enddate            date,
    issuedaccount      bigint NOT NULL,
    feeaccount         bigint,
    issuer             bigint,
    externalaccount    character varying(40),
    bin                character varying(8),
    binextended        character varying(10),
    extended           character(1) DEFAULT 'N'::bpchar,
    binvirtual         character varying(6),
    binextendedvirtual character varying(10),
    cardnumberlength   smallint     DEFAULT 0,
    smart              character(1) DEFAULT 'N'::bpchar,
    randomcardnumber   character(1) DEFAULT 'N'::bpchar,
    code               character varying(40),
    lossesaccount      bigint,
    range              character varying(3),
    minloadamount INTEGER NOT NULL DEFAULT 40,
    maxloadamount INTEGER NOT NULL DEFAULT 300000,
    bai VARCHAR(255) NOT NULL DEFAULT 'AA,PP,WT,FT,BI,FD,GD,MD,OG,LO,CP,TU',
    minpurchaseamount bigint,
    authcashbacklimit bigint NOT NULL DEFAULT 300000,
    maxriskvisa bigint,
    embossing_producer text default 'org.jpos.embossing.prisma.PrismaEmbossingProducer',
    usage_limit_id bigint,
    PRIMARY KEY (id),
    UNIQUE (code),
    UNIQUE (name),
    FOREIGN KEY (issuedaccount) REFERENCES acct (id),
    FOREIGN KEY (lossesaccount) REFERENCES acct (id),
    FOREIGN KEY (feeaccount) REFERENCES acct (id),
    FOREIGN KEY (issuer) REFERENCES issuers (id)
);


CREATE TABLE cardholder
(
    id                  bigint NOT NULL,
    realid              character varying(32),
    active              character(1),
    startdate           date,
    enddate             date,
    honorific           character varying(10),
    gender              character varying(1),
    firstname           character varying(40),
    middlename          character varying(40),
    lastname            character varying(40),
    lastname2           character varying(40),
    email               character varying(255),
    nationality         character varying(40),
    birthdate           date,
    notes               character varying(255),
    phone               character varying(255),
    searchpath          character varying(64),
    issuer              bigint,
    national_identifier text,

    PRIMARY KEY (id),
    FOREIGN KEY (issuer) REFERENCES issuers (id)
);

CREATE INDEX realid ON cardholder USING btree (realid);


CREATE TABLE cardholder_accounts
(
    id       bigint               NOT NULL,
    account  bigint               NOT NULL,
    currency character varying(5) NOT NULL,
    PRIMARY KEY (id, currency),
    FOREIGN KEY (id) REFERENCES cardholder (id),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (currency) REFERENCES currency (id)
);

CREATE TABLE cardholder_phones
(
    id           bigint      NOT NULL,
    cardholderid bigint      NOT NULL,
    active       character(1),
    type         varchar(8)  not null,
    number       varchar(50) not null,
    country      varchar(3)  not null,
    PRIMARY KEY (id),
    FOREIGN KEY (cardholderid) REFERENCES cardholder (id)
);

CREATE TABLE cardholder_identifications
(
    id           bigint      NOT NULL,
    cardholderid bigint      NOT NULL,
    active       character(1),
    type         varchar(8)  not null,
    number       varchar(50) not null,
    country      varchar(3)  not null,
    PRIMARY KEY (id),
    FOREIGN KEY (cardholderid) REFERENCES cardholder (id)
);

CREATE TABLE cardholder_address
(
    id           bigint       NOT NULL,
    cardholderid bigint       NOT NULL,
    active       character(1) NOT NULL,
    type         varchar(10)  NOT NULL,
    street       varchar(255) NOT NULL,
    number       varchar(10)  NOT NULL,
    locality     varchar(40)  NOT NULL,
    state        varchar(5)   NOT NULL,
    country      varchar(3)   NOT NULL,
    postal_code  varchar(10)  NOT NULL,
    floor        varchar(2),
    apartment    varchar(3),
    PRIMARY KEY (id),
    FOREIGN KEY (cardholderid) REFERENCES cardholder (id)
);

CREATE TABLE card
(
    id              bigint  NOT NULL,
    token           bpchar(100),
    bin             character varying(8),
    lastfour        character varying(4),
    kid             character varying(8),
    securedata      bytea,
    hash            character(40),
    startdate       date,
    enddate         date,
    cardholder      bigint,
    cardproduct     bigint,
    account         bigint,
    smart           character(1) DEFAULT 'N'::bpchar,
    virtual         character(1) DEFAULT 'N'::bpchar,
    createdtime     date,
    lastmodified    date,
    physical_state character varying(255) DEFAULT NULL,
    virtual_state character varying(255) DEFAULT 'CREATED',
    observation_state character varying(255),
    csn VARCHAR(3) NOT NULL DEFAULT '000',
    usage_limit_id bigint,
    embossed_at timestamp,
    type character varying(255) NOT NULL DEFAULT 'VIRTUAL',
    PRIMARY KEY (id),
    UNIQUE (token),
    UNIQUE (hash),
    FOREIGN KEY (cardproduct) REFERENCES card_products (id),
    FOREIGN KEY (cardholder) REFERENCES cardholder (id),
    FOREIGN KEY (account) REFERENCES acct (id)
);

CREATE TABLE change_pin_log
(
    id                  bigint          NOT NULL,
    session_id          text            NOT NULL,
    requested_date      timestamp       NOT NULL,
    finish_date         timestamp               ,
    tpk                 text            NOT NULL,
    status              text            NOT NULL,
    card_id             bigint          NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (card_id) REFERENCES card (id)
);
CREATE TABLE embossing_detail
(
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    fourth_line character varying(255),
    CONSTRAINT embossing_detail_pk PRIMARY KEY (id)
);
CREATE TABLE fulfillment_detail
(
    id bigint NOT NULL,
    tracking_id character varying(255) NOT NULL,
    CONSTRAINT fulfillment_detail_pk PRIMARY KEY (id)
);


CREATE INDEX idx_cardacct ON card USING btree (account);
CREATE INDEX idx_ch ON card USING btree (cardholder);
CREATE INDEX idx_cp ON card USING btree (cardproduct);


CREATE TABLE card_accounts
(
    id       bigint               NOT NULL,
    account  bigint               NOT NULL,
    currency character varying(5) NOT NULL,
    PRIMARY KEY (id, currency),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (id) REFERENCES card (id),
    FOREIGN KEY (currency) REFERENCES currency (id)
);

CREATE TABLE card_state_transition
(
    id                  bigint  NOT NULL,
    cardid 		        bigint  NOT NULL,
    created_time        timestamp without time zone NOT NULL,
    state               varchar(15) NOT NULL,
    reason              varchar(255)  NOT NULL,
    tracking_id         varchar(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (cardid) REFERENCES card (id)
);

CREATE TABLE checkpoint
(
    date    timestamp without time zone NOT NULL,
    layers  character varying(32)       NOT NULL,
    journal bigint                      NOT NULL,
    account bigint                      NOT NULL,
    balance numeric(14, 2)              NOT NULL,
    PRIMARY KEY (date, layers, journal, account),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);

CREATE TABLE eeuser
(
    id                  bigint                NOT NULL,
    nick                character varying(64) NOT NULL,
    passwordhash        character varying(8192),
    name                character varying(128),
    email               character varying(128),
    active              character(1),
    deleted             character(1),
    verified            character(1),
    startdate           date,
    enddate             date,
    forcepasswordchange character(1) DEFAULT 'N'::bpchar,
    lastlogin           timestamp without time zone,
    passwordchanged     timestamp without time zone,
    loginattempts       integer      DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE (nick)
);


CREATE TABLE consumer
(
    id        character varying(255) NOT NULL,
    active    character(1),
    deleted   character(1),
    startdate date,
    enddate   date,
    eeuser    bigint,
    hash      character varying(8192),
    PRIMARY KEY (id),
    FOREIGN KEY (eeuser) REFERENCES eeuser (id)
);


CREATE TABLE consumer_props
(
    id        character varying(255) NOT NULL,
    propvalue character varying(255),
    propname  character varying(64)  NOT NULL,
    PRIMARY KEY (id, propname),
    FOREIGN KEY (id) REFERENCES consumer (id)
);


CREATE TABLE realm
(
    id          bigint NOT NULL,
    description character varying(8192),
    name        character varying(64),
    PRIMARY KEY (id),
    UNIQUE (name)
);


CREATE SEQUENCE realm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    OWNED BY realm.id;

SELECT pg_catalog.setval('realm_id_seq', 1, false);

ALTER TABLE realm
    ALTER COLUMN id SET DEFAULT nextval('realm_id_seq'::regclass);

CREATE TABLE role
(
    id     bigint                NOT NULL,
    name   character varying(64) NOT NULL,
    realm  bigint,
    parent bigint,
    PRIMARY KEY (id),
    UNIQUE (name),
    UNIQUE (name, realm),
    FOREIGN KEY (parent) REFERENCES role (id),
    FOREIGN KEY (realm) REFERENCES realm (id)
);


CREATE TABLE role_perms
(
    role bigint                NOT NULL,
    name character varying(64) NOT NULL,
    PRIMARY KEY (role, name),
    FOREIGN KEY (role) REFERENCES role (id)
);

CREATE TABLE consumer_roles
(
    consumer character varying(255) NOT NULL,
    role     bigint                 NOT NULL,
    PRIMARY KEY (consumer, role),
    FOREIGN KEY (consumer) REFERENCES consumer (id),
    FOREIGN KEY (role) REFERENCES role (id)
);



CREATE TABLE eeuser_passwordhistory
(
    eeuser bigint                  NOT NULL,
    value  character varying(8192) NOT NULL,
    id     integer                 NOT NULL,
    PRIMARY KEY (eeuser, id),
    FOREIGN KEY (eeuser) REFERENCES eeuser (id)
);


CREATE TABLE eeuser_props
(
    id        bigint                NOT NULL,
    propvalue character varying(255),
    propname  character varying(64) NOT NULL,
    PRIMARY KEY (id, propname),
    FOREIGN KEY (id) REFERENCES eeuser (id)
);


CREATE TABLE eeuser_roles
(
    eeuser bigint NOT NULL,
    role   bigint NOT NULL,
    PRIMARY KEY (eeuser, role),
    FOREIGN KEY (role) REFERENCES role (id),
    FOREIGN KEY (eeuser) REFERENCES eeuser (id)
);


CREATE TABLE fees
(
    id          bigint         NOT NULL,
    type        character varying(255),
    amount      numeric(19, 2) NOT NULL,
    startdate   date,
    enddate     date,
    cardproduct bigint,
    startamount numeric(19, 2),
    endamount   numeric(19, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (cardproduct) REFERENCES card_products (id)
);


CREATE TABLE financial_institutions
(
    id      bigint NOT NULL,
    name    character varying(255),
    account character varying(255),
    PRIMARY KEY (id),
    UNIQUE (name)
);


CREATE TABLE gluser
(
    id   bigint                 NOT NULL,
    nick character varying(32)  NOT NULL,
    name character varying(128) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (nick)
);


CREATE TABLE glperm
(
    id      bigint                NOT NULL,
    name    character varying(64) NOT NULL,
    gluser  bigint,
    journal bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (journal) REFERENCES journal (id),
    FOREIGN KEY (gluser) REFERENCES gluser (id)
);

CREATE INDEX perm_name ON glperm USING btree (name);


CREATE TABLE acquirers
(
    id                 bigint                NOT NULL,
    active             character(1),
    institutionid      character varying(11) NOT NULL,
    name               character varying(40),
    transactionaccount bigint                NOT NULL,
    feeaccount         bigint,
    refundaccount      bigint,
    depositaccount     bigint,
    issuer             bigint,
    PRIMARY KEY (id),
    UNIQUE (institutionid),
    FOREIGN KEY (issuer) REFERENCES issuers (id),
    FOREIGN KEY (depositaccount) REFERENCES acct (id),
    FOREIGN KEY (feeaccount) REFERENCES acct (id),
    FOREIGN KEY (refundaccount) REFERENCES acct (id),
    FOREIGN KEY (transactionaccount) REFERENCES acct (id)
);



CREATE TABLE layer
(
    id      smallint NOT NULL,
    journal bigint   NOT NULL,
    name    character varying(80),
    PRIMARY KEY (id, journal),
    FOREIGN KEY (journal) REFERENCES journal (id)
);


CREATE TABLE merchant
(
    id         bigint                NOT NULL,
    subclass   character varying(1)  NOT NULL,
    merchantid character varying(15) NOT NULL,
    name       character varying(40),
    active     character(1),
    contact    character varying(40),
    address1   character varying(40),
    address2   character varying(40),
    city       character varying(40),
    state      character varying(2),
    province   character varying(20),
    zip        character varying(10),
    phone      character varying(40),
    country    character varying(40),
    acquirer   bigint,
    parent     bigint,
    PRIMARY KEY (id),
    UNIQUE (merchantid),
    FOREIGN KEY (parent) REFERENCES merchant (id),
    FOREIGN KEY (acquirer) REFERENCES acquirers (id)
);


CREATE TABLE merchant_external_info
(
    id            bigint                NOT NULL,
    mid           character varying(15),
    tid           character varying(8),
    interchangeid character varying(16) NOT NULL,
    PRIMARY KEY (id, interchangeid),
    FOREIGN KEY (id) REFERENCES merchant (id)
);


CREATE TABLE rc
(
    id          bigint NOT NULL,
    mnemonic    character varying(255),
    description character varying(255),
    PRIMARY KEY (id),
    UNIQUE (mnemonic)
);


CREATE TABLE rc_locale
(
    id                 bigint                NOT NULL,
    resultcode         character varying(4),
    resultinfo         character varying(255),
    extendedresultcode character varying(32),
    locale             character varying(32) NOT NULL,
    PRIMARY KEY (id, locale),
    FOREIGN KEY (id) REFERENCES rc (id)
);


CREATE TABLE revision
(
    id     bigint NOT NULL,
    date   timestamp without time zone,
    info   character varying(8192),
    ref    character varying(64),
    author bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (author) REFERENCES eeuser (id)
);

CREATE INDEX ref ON revision USING btree (ref);


CREATE TABLE ruleinfo
(
    id          bigint NOT NULL,
    description character varying(255),
    clazz       character varying(255),
    layers      character varying(255),
    param       character varying(255),
    journal     bigint,
    account     bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);


CREATE TABLE sysconfig
(
    id        character varying(64) NOT NULL,
    value     text,
    readperm  character varying(32),
    writeperm character varying(32),
    PRIMARY KEY (id)
);


CREATE TABLE syslog
(
    id       bigint NOT NULL,
    date     timestamp without time zone,
    deleted  character(1),
    source   character varying(64),
    type     character varying(32),
    severity integer,
    summary  character varying(255),
    detail   text,
    trace    text,
    PRIMARY KEY (id)
);


CREATE TABLE terminal_profile
(
    id     character varying(32) NOT NULL,
    audit  character(1),
    active character(1),
    PRIMARY KEY (id)
);


CREATE TABLE terminal
(
    id          bigint        NOT NULL,
    terminalid  character(16) NOT NULL,
    active      character(1),
    info        character varying(40),
    softversion character varying(32),
    merchant    bigint,
    profile     character varying(32),
    PRIMARY KEY (id),
    FOREIGN KEY (profile) REFERENCES terminal_profile (id),
    FOREIGN KEY (merchant) REFERENCES merchant (id)
);

CREATE INDEX terminal_id ON terminal USING btree (terminalid);


CREATE TABLE terminal_external_info
(
    id            bigint                NOT NULL,
    mid           character varying(15),
    tid           character varying(8),
    interchangeid character varying(16) NOT NULL,
    PRIMARY KEY (id, interchangeid),
    FOREIGN KEY (id) REFERENCES terminal (id)
);


CREATE TABLE invoice
(
    id        int8         NOT NULL,
    request   json,
    start_date    timestamp    NULL,
    end_date timestamp NULL,
    status    varchar(50),
    token     uuid,
    step text NULL,
    errormsg text NULL,
    report text NULL,
    CONSTRAINT invoice_pkey PRIMARY KEY (id)
);


CREATE TABLE invoice_account
(
    id           int8 NOT NULL,
    invoiceid    bigint,
    type         varchar(50),
    cardholder  bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (invoiceid) REFERENCES invoice (id)
);

CREATE TABLE transacc
(
    id          bigint                      NOT NULL,
    detail      character varying(255),
    tags        character varying(255),
    "timestamp" timestamp without time zone NOT NULL,
    postdate    timestamp without time zone,
    journal     bigint                      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (journal) REFERENCES journal (id)
);

CREATE TABLE tranlog
(
    id                     bigint NOT NULL,
    deleted                character(1),
    localid                bigint,
    node                   character varying(8),
    acquirer               character varying(11),
    mid                    character varying(15),
    tid                    character varying(16),
    stan                   character(12),
    rrn                    character varying(32),
    lifecycleindicator     character varying(1),
    lifecycletrace         character(15),
    lifecyclesequence      character varying(2),
    lifecycleauthtoken     character varying(4),
    ca_name                character varying(255),
    ca_city                character varying(255),
    ca_region              character varying(255),
    ca_country             character varying(255),
    ca_address             character varying(255),
    ca_postalcode          character varying(255),
    ca_phone               character varying(255),
    latitude               double precision,
    longitude              double precision,
    mcc                    character varying(4),
    functioncode           character varying(3),
    reasoncode             character varying(4),
    filename               character varying(16),
    responsecode           character varying(4),
    approvalnumber         character varying(6),
    displaymessage         character varying(99),
    reversalcount          integer,
    reversalid             bigint,
    completioncount        integer,
    completionid           bigint,
    voidcount              integer,
    voidid                 bigint,
    date                   timestamp without time zone,
    transmissiondate       timestamp without time zone,
    localtransactiondate   timestamp without time zone,
    capturedate            date,
    settlementdate         date,
    batchnumber            bigint,
    itc                    character varying(50),
    irc                    character varying(4),
    originalitc            character varying(50),
    currencycode           character varying(5),
    amount                 numeric(14, 2),
    additionalamount       numeric(14, 2),
    replacementamount      numeric(14, 2),
    acquirerfee            numeric(14, 2),
    issuerfee              numeric(14, 2),
    returnedbalances       character varying(60),
    ss                     character varying(32),
    ssdata                 character varying(1024),
    pdc                    bytea,
    rc                     character varying(40),
    extrc                  character varying(255),
    duration               integer,
    outstanding            integer,
    request                bytea,
    response               bytea,
    refid                  bigint,
    cardholder             bigint,
    card                   bigint,
    account                bigint,
    account2               bigint,
    gltransaction          bigint,
    additionaldata         character varying(8192),
    tags                   character varying(255),
    invoice                bigint,
    externalsortxnid       uuid,
    brandIdentifier        varchar,
    transactionborder      character varying(70),
    approvalcode           character varying(255),
    currency_conversion character varying(2000),
    atc integer,
    sicore_process_id bigint,
    bai VARCHAR(4),
    mttidentifier character(1),
    recurrent character(1),
    risklevel bigint,
    presentation_count INTEGER DEFAULT 0,
    presentation_id bigint,
    surcharge_fee numeric(19, 2),
    cashback numeric(19, 2),
    issuer_settlement bigint NULL,
    exchange_rate numeric(16, 8),
    transaction_amount numeric(14, 2),
    transaction_currency_code character varying(5),
    total_amount numeric(14, 2),
    total_currency_code character varying(5),
    settlement_amount numeric(20, 6) NULL,
    settlement_currency_code varchar(5) NULL,
    acquirer_country_code varchar(255) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (card) REFERENCES card (id),
    FOREIGN KEY (refid) REFERENCES tranlog (id),
    FOREIGN KEY (gltransaction) REFERENCES transacc (id),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (account2) REFERENCES acct (id),
    FOREIGN KEY (cardholder) REFERENCES cardholder (id),
    FOREIGN KEY (invoice) REFERENCES invoice (id),
    CONSTRAINT fk_tranlog_presentation FOREIGN KEY (presentation_id) REFERENCES tranlog(id)
);

CREATE INDEX batchnumber ON tranlog USING btree (batchnumber);
CREATE INDEX lifecycletrace ON tranlog USING btree (lifecycletrace);
CREATE INDEX mid ON tranlog USING btree (mid);
CREATE INDEX rrn ON tranlog USING btree (rrn);
CREATE INDEX stan ON tranlog USING btree (stan);
CREATE INDEX tid ON tranlog USING btree (tid);
CREATE INDEX tranlog_date ON tranlog USING btree (date);


CREATE TABLE apicalllog
(
    id                   int8           NOT NULL,
    localid              int8           NULL,
    node                 varchar(8)     NULL,
    "date"               timestamp      NULL,
    transmissiondate     timestamp      NULL,
    localtransactiondate timestamp      NULL,
    capturedate          date           NULL,
    itc                  varchar(80)    NULL,
    irc                  varchar(4)     NULL,
    currencycode         varchar(5)     NULL,
    originalitc          varchar(80)    NULL,
    amount               numeric(14, 2) NULL,
    additionalamount     numeric(14, 2) NULL,
    replacementamount    numeric(14, 2) NULL,
    ss                   varchar(32)    NULL,
    pdc                  bytea          NULL,
    gltransaction        bigint,
    cardholder           bigint,
    invoice              bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (currencycode) REFERENCES currency (id),
    FOREIGN KEY (cardholder) REFERENCES cardholder (id),
    FOREIGN KEY (gltransaction) REFERENCES transacc (id),
    FOREIGN KEY (invoice) REFERENCES invoice (id)
);


CREATE TABLE tranlog_followups
(
    id      bigint NOT NULL,
    date    timestamp without time zone,
    detail  text,
    tranlog bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (tranlog) REFERENCES tranlog (id)
);


CREATE TABLE transentry
(
    id          bigint               NOT NULL,
    subclass    character varying(1) NOT NULL,
    detail      character varying(255),
    tags        character varying(255),
    credit      character(1),
    layer       integer              NOT NULL,
    account     bigint               NOT NULL,
    transaction bigint,
    amount      numeric(14, 2)       NOT NULL,
    posn        integer,
    PRIMARY KEY (id),
    FOREIGN KEY (account) REFERENCES acct (id),
    FOREIGN KEY (transaction) REFERENCES transacc (id)
);

CREATE INDEX idx_acct ON transentry USING btree (account);
CREATE INDEX idx_txn ON transentry USING btree (transaction);


CREATE TABLE transgroup
(
    id   bigint NOT NULL,
    name character varying(32),
    PRIMARY KEY (id),
    UNIQUE (name)
);


CREATE TABLE transgroup_transactions
(
    transactiongroup bigint NOT NULL,
    transaction      bigint NOT NULL,
    PRIMARY KEY (transactiongroup, transaction),
    FOREIGN KEY (transaction) REFERENCES transacc (id),
    FOREIGN KEY (transactiongroup) REFERENCES transgroup (id)
);


CREATE TABLE velocity_profiles
(
    id                bigint               NOT NULL,
    name              character varying(40),
    active            character(1)         NOT NULL,
    approvalsonly     character(1)         NOT NULL,
    scopecard         character(1),
    scopeaccount      character(1),
    validonpurchase   character(1),
    validonwithdrawal character(1),
    validontransfer   character(1),
    currencycode      character varying(5) NOT NULL,
    numberofdays      integer,
    usagelimit        integer,
    amountlimit       numeric(15, 2)       NOT NULL,
    cardproduct       bigint,
    posn              integer,
    validoncredit     character(1),
    scopemonthly      character(1) DEFAULT 'N'::bpchar,
    scopedaily        character(1) DEFAULT 'N'::bpchar,
    PRIMARY KEY (id),
    FOREIGN KEY (cardproduct) REFERENCES card_products (id)
);


CREATE TABLE visitor
(
    id         character varying(36) NOT NULL,
    lastupdate timestamp without time zone,
    eeuser     bigint REFERENCES eeuser (id),
    PRIMARY KEY (id)
);


CREATE TABLE visitor_props
(
    id        character varying(36) NOT NULL,
    propvalue character varying(255),
    propname  character varying(32) NOT NULL,
    PRIMARY KEY (id, propname),
    FOREIGN KEY (id) REFERENCES visitor (id)
);


CREATE TABLE sicore_process
(
    id                  bigint          NOT NULL,
    from_date           DATE            NOT NULL,
    to_date             DATE            NOT NULL,
    status              varchar(20)     NOT NULL,
    error               TEXT,
    error_description   TEXT,
    created_at          timestamp       NOT NULL,
    last_updated        timestamp       NOT NULL,
    PRIMARY KEY (id)
);


ALTER TABLE tranlog ADD CONSTRAINT fk_sicore_process FOREIGN KEY (sicore_process_id) REFERENCES sicore_process(id);

CREATE TABLE s3link (
                               id bigint NOT NULL,
                               url text NOT NULL,
                               detail text NULL,
                               "date" timestamp NOT NULL,
                               CONSTRAINT s3link_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE issuer_settlements_id_seq
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    START 1
    CACHE 1
    NO CYCLE;

CREATE TABLE issuer_settlements (
                                           id bigint NOT NULL DEFAULT nextval('issuer_settlements_id_seq'::regclass),
                                           creation_date timestamp NOT NULL,
                                           done boolean NOT NULL DEFAULT false,
                                           text text NOT NULL DEFAULT 'PENDING'::text,
                                           headers varchar NOT NULL DEFAULT '',
                                           state text NOT NULL DEFAULT 'PENDING'::text,
                                           CONSTRAINT issuer_settlements_pk PRIMARY KEY (id)
);

ALTER SEQUENCE issuer_settlements_id_seq OWNED BY issuer_settlements.id;


ALTER TABLE tranlog ADD CONSTRAINT tranlog_issset_fkey FOREIGN KEY (issuer_settlement) REFERENCES issuer_settlements(id);

CREATE OR REPLACE VIEW fast_transacc
AS
SELECT t.id,
       gl.account,
       C.token,
       array_to_string(array_agg(DISTINCT gl.layer), ','::text) AS layers,
       array_to_string(array_agg(DISTINCT gl.detail), ','::text) AS entry_details,
       array_to_string(array_agg(DISTINCT gl.tags), ','::text) AS tags,
       sum(
               CASE
                   WHEN gl.subclass::text = 'C'::text THEN gl.amount
                   ELSE 0::numeric
               END) - sum(
               CASE
                   WHEN gl.subclass::text = 'D'::text THEN gl.amount
                   ELSE 0::numeric
               END) AS amount,
       t."timestamp"
FROM transentry gl
         JOIN transacc t ON t.id = gl.transaction
         JOIN card_accounts CA ON gl.account = CA.account
         JOIN card C ON C.id = CA.id
GROUP BY t.id, gl.account, C.token
ORDER BY t.timestamp DESC;

CREATE TABLE usage_limit
(
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    createdtimestamp date,
    allowecommerce character varying(255),
    allowpurchasechip character varying(255),
    allowpurchasecontactless character varying(255),
    allowatmoperation character varying(255),
    allowatmwithdrawal character varying(255),
    allowoct character varying(255),
    allowpurchasemagneticstripe character varying(255),
    bannedmcclist character varying(255) NOT NULL DEFAULT '5169, 5261, 2741',
    countrieswhitelist character varying(255),
    countriesblacklist character varying(255),
    bannedtcclist character varying(255),
    PRIMARY KEY (id),
    UNIQUE (name)
);
CREATE TABLE usage_limit_account
(
    id bigint NOT NULL,
    usageLimit bigint,
    finalAccount bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (usageLimit) REFERENCES usage_limit (id),
    FOREIGN KEY (finalAccount) REFERENCES acct (id)
);


ALTER TABLE card ADD CONSTRAINT fk_usageLimit FOREIGN KEY (usage_limit_id) REFERENCES usage_limit(id);
CREATE INDEX idx_card_usageLimit ON card USING btree (usage_limit_id);
ALTER TABLE card_products ADD CONSTRAINT fk_usageLimit FOREIGN KEY (usage_limit_id) REFERENCES usage_limit(id);
CREATE INDEX idx_cardproduct_usageLimit ON card_products USING btree (usage_limit_id);

CREATE TABLE tcc (
                     code character varying(1) NOT NULL,
                     description character varying(255) NOT NULL,
                     PRIMARY KEY (code)
);

CREATE TABLE mcc (
                     code character varying(4) NOT NULL,
                     description character varying(255) NOT NULL,
                     tcc character varying(1),
                     PRIMARY KEY (code),
                     FOREIGN KEY (tcc) REFERENCES tcc (code)
);

create table embossing_batches
(
    id                        bigint  not null primary key,
    start_date                timestamp,
    end_date                  timestamp,
    number_of_embossed_cards  integer not null default 0,
    number_of_requested_cards integer not null default 0,
    first_embossing_queue_id  bigint,
    last_embossing_queue_id   bigint


);

create table embossing_files
(
    id              bigint not null primary key,
    card_product_id bigint not null,
    reason          text   not null,
    card_scheme     text   not null,
    product_name    text   not null,
    batch_id        bigint not null,
    file            BYTEA,

    FOREIGN KEY (card_product_id) REFERENCES card_products (id),
    FOREIGN KEY (batch_id) REFERENCES embossing_batches (id)

);


create table embossing_queue
(
    id                bigint    not null primary key,
    card_id           bigint    not null,
    reason            text      not null,
    status            text      not null,
    error             text,
    requested_date    timestamp not null,
    processed_date    timestamp,
    embossing_file_id bigint,
    fulfillment_detail_id bigint,
    embossing_detail_id bigint,
    FOREIGN KEY (card_id) REFERENCES card (id),
    FOREIGN KEY (embossing_file_id) REFERENCES embossing_files (id),
    CONSTRAINT fk_fulfillment_detail FOREIGN KEY (fulfillment_detail_id) REFERENCES fulfillment_detail(id),
    CONSTRAINT fk_embossing_detail FOREIGN KEY (embossing_detail_id) REFERENCES embossing_detail(id)
);

ALTER TABLE embossing_batches
    ADD CONSTRAINT fk_embossing_batch_queue_first FOREIGN KEY (first_embossing_queue_id) REFERENCES embossing_queue (id),
    ADD CONSTRAINT fk_embossing_batch_queue_last FOREIGN KEY (last_embossing_queue_id) REFERENCES embossing_queue (id);

CREATE TABLE claim
(
    id                   bigint         NOT NULL,
    tranlog              bigint         NOT NULL,
    amount               numeric(14, 2) NOT NULL,
    txn_date             date           NOT NULL,
    initial_transaction   bigint NULL,
    confirmed_transaction bigint NULL,
    "date"               timestamp without time zone NOT NULL,
    status               TEXT           NOT NULL,
    brand_claim_id TEXT NOT NULL DEFAULT '',
    CONSTRAINT claim_pk PRIMARY KEY (id),
    CONSTRAINT claim_tranlog_un UNIQUE (tranlog),
    FOREIGN KEY (tranlog) REFERENCES tranlog (id),
    FOREIGN KEY (initial_transaction) REFERENCES transacc (id),
    FOREIGN KEY (confirmed_transaction) REFERENCES transacc (id)
);




-----------------------------------------------------------------------------------
-- DATA INSERTION -----------------------------------------------------------------
-----------------------------------------------------------------------------------

--------------------
-- rc & rc_locale --
--------------------
INSERT INTO rc (id, mnemonic, description)
VALUES
    (0, '0000', 'Transaction approved'),
    (1, '0001', 'ORIGINAL 0001'),
    (2, '0002', 'PARTIALLY APPROVED'),
    (3, '0003', 'ORIGINAL 0003'),
    (4, '0004', 'ORIGINAL 0004'),
    (5, '0005', 'ORIGINAL 0005'),
    (6, '0006', 'ORIGINAL 0006'),
    (7, '0007', 'ORIGINAL 0007'),
    (8, '0008', 'ORIGINAL 0008'),
    (9, '0009', 'ORIGINAL 0009'),
    (10, '0010', 'ORIGINAL 0010'),
    (11, '0011', 'ORIGINAL 0011'),
    (12, '0012', 'ORIGINAL 0012'),
    (13, '0013', 'ORIGINAL 0013'),
    (14, '0014', 'ORIGINAL 0014'),
    (15, '0015', 'ORIGINAL 0015'),
    (16, '0016', 'ORIGINAL 0016'),
    (17, '0017', 'ORIGINAL 0017'),
    (18, '0018', 'ORIGINAL 0018'),
    (19, '0019', 'ORIGINAL 0019'),
    (20, '0020', 'ORIGINAL 0020'),
    (21, '0021', 'ORIGINAL 0021'),
    (22, '0022', 'ORIGINAL 0022'),
    (23, '0023', 'ORIGINAL 0023'),
    (24, '0024', 'ORIGINAL 0024'),
    (25, '0025', 'ORIGINAL 0025'),
    (26, '0026', 'ORIGINAL 0026'),
    (27, '0027', 'ORIGINAL 0027'),
    (28, '0028', 'ORIGINAL 0028'),
    (29, '0029', 'ORIGINAL 0029'),
    (30, '0030', 'ORIGINAL 0030'),
    (31, '0031', 'ORIGINAL 0031'),
    (32, '0032', 'ORIGINAL 0032'),
    (33, '0033', 'ORIGINAL 0033'),
    (34, '0034', 'ORIGINAL 0034'),
    (35, '0035', 'ORIGINAL 0035'),
    (36, '0036', 'ORIGINAL 0036'),
    (37, '0037', 'ORIGINAL 0037'),
    (38, '0038', 'ORIGINAL 0038'),
    (39, '0039', 'ORIGINAL 0039'),
    (40, '0040', 'ORIGINAL 0040'),
    (41, '0041', 'ORIGINAL 0041'),
    (42, '0042', 'ORIGINAL 0042'),
    (43, '0043', 'ORIGINAL 0043'),
    (44, '0044', 'ORIGINAL 0044'),
    (45, '0045', 'ORIGINAL 0045'),
    (46, '0046', 'ORIGINAL 0046'),
    (47, '0047', 'ORIGINAL 0047'),
    (48, '0048', 'ORIGINAL 0048'),
    (49, '0049', 'ORIGINAL 0049'),
    (50, '0050', 'ORIGINAL 0050'),
    (51, '0051', 'ORIGINAL 0051'),
    (52, '0052', 'ORIGINAL 0052'),
    (53, '0053', 'ORIGINAL 0053'),
    (54, '0054', 'ORIGINAL 0054'),
    (55, '0055', 'ORIGINAL 0055'),
    (56, '0056', 'ORIGINAL 0056'),
    (57, 'not.permitted', 'Not Permitted'),
    (58, '0058', 'ORIGINAL 0058'),
    (59, '0059', 'ORIGINAL 0059'),
    (60, '0060', 'ORIGINAL 0060'),
    (61, '0061', 'ORIGINAL 0061'),
    (62, '0062', 'ORIGINAL 0062'),
    (63, '0063', 'ORIGINAL 0063'),
    (64, '0064', 'ORIGINAL 0064'),
    (65, '0065', 'ORIGINAL 0065'),
    (66, '0066', 'ORIGINAL 0066'),
    (67, '0067', 'ORIGINAL 0067'),
    (68, '0068', 'ORIGINAL 0068'),
    (69, '0069', 'ORIGINAL 0069'),
    (70, '0070', 'ORIGINAL 0070'),
    (71, '0071', 'ORIGINAL 0071'),
    (72, '0072', 'ORIGINAL 0072'),
    (73, '0073', 'ORIGINAL 0073'),
    (74, '0074', 'ORIGINAL 0074'),
    (75, '0075', 'ORIGINAL 0075'),
    (76, '0076', 'ORIGINAL 0076'),
    (77, '0077', 'ORIGINAL 0077'),
    (78, '0078', 'ORIGINAL 0078'),
    (79, '0079', 'ORIGINAL 0079'),
    (80, '0080', 'ORIGINAL 0080'),
    (81, '0081', 'ORIGINAL 0081'),
    (82, '0082', 'ORIGINAL 0082'),
    (83, '0083', 'ORIGINAL 0083'),
    (84, '0084', 'ORIGINAL 0084'),
    (85, '0085', 'ORIGINAL 0085'),
    (86, '0086', 'ORIGINAL 0086'),
    (87, '0087', 'ORIGINAL 0087'),
    (88, '0088', 'ORIGINAL 0088'),
    (89, '0089', 'ORIGINAL 0089'),
    (90, '0090', 'ORIGINAL 0090'),
    (91, '0091', 'ORIGINAL 0091'),
    (92, '0092', 'ORIGINAL 0092'),
    (93, '0093', 'ORIGINAL 0093'),
    (94, '0094', 'ORIGINAL 0094'),
    (95, '0095', 'ORIGINAL 0095'),
    (96, '0096', 'ORIGINAL 0096'),
    (97, '0097', 'ORIGINAL 0097'),
    (98, '0098', 'ORIGINAL 0098'),
    (99, '0099', 'ORIGINAL 0099'),
    (1001, 'card.expired', 'Card expired'),
    (1002, 'card.suspicious', 'Card suspicious'),
    (1003, 'card.suspended', 'Card suspended'),
    (1004, 'card.stolen', 'Card stolen - pickup'),
    (1005, 'card.lost', 'Card lost'),
    (1011, 'card.not.found', 'Card not found'),
    (1012, 'cardholder.not.found', 'Cardholder not found'),
    (1014, 'account.not.found', 'Account not found'),
    (1015, 'invalid.request', 'Invalid request'),
    (1016, 'not.sufficient.funds', 'Not sufficient funds'),
    (1017, 'incorrect.pin', 'Incorrect PIN'),
    (1018, 'previously.completed', 'Previously reversed'),
    (1019, 'activity.prevents.reversal', 'Further activity prevents reversal'),
    (1020, 'activity.prevents.void', 'Further activity prevents void'),
    (1021, 'previously.voided', 'Original transaction has been voided'),
    (1025, 'fallback.rejected', 'Transaction not permitted to cardholder'),
    (1802, 'missing.fields', 'Missing fields'),
    (1803, 'extra.fields', 'Extra fields exist'),
    (1804, 'invalid.card', 'Invalid card number'),
    (1805, 'invalid.track1', 'Invalid track 1'),
    (1806, 'card.not.active', 'Card not active'),
    (1807, 'invalid.track2', 'Invalid track 2'),
    (1808, 'card.not.configured', 'Card not configured'),
    (1810, 'invalid.amount', 'Invalid amount'),
    (1811, 'sys.error.db', 'System Error'),
    (1812, 'sys.error.txn', 'System Error'),
    (1813, 'cardholder.not.active', 'Cardholder not active'),
    (1814, 'cardholder.not.configured', 'Cardholder not configured'),
    (1815, 'cardholder.expired', 'CardHolder expired'),
    (1816, 'original.not.found', 'Original not found'),
    (1817, 'usage.limit.reached', 'Usage Limit Reached'),
    (1818, 'SYSCONFIG_ERROR', 'Configuration error'),
    (1819, 'invalid.terminal', 'Invalid terminal'),
    (1820, 'inactive.terminal', 'Inactive terminal'),
    (1821, 'invalid.merchant', 'Invalid merchant'),
    (1822, 'duplicate.entity', 'Duplicate entity'),
    (1823, 'invalid.acquirer', 'Invalid Acquirer'),
    (1824, 'gl.exception.error', 'Accounting Exception'),
    (1825, 'previously.reversed', 'Previously reversed'),
    (1826, 'previously.transmitted', 'Previously transmitted'),
    (1827, 'invalid.issuer', 'Invalid issuer institutionId'),
    (1829, 'amount.limit.reached', 'Amount Limit Reached'),
    (1834, 'inactive.account', 'The account is deactivated.'),
    (8444, 'pending.credit', 'Pending credit'),
    (8500, 'invalid.installment', 'Invalid installment count'),
    (8501, 'cvv2.omitted', 'CVV2 Omitted'),
    (8502, 'cvv2.invalid', 'CVV2 Invalid'),
    (8503, 'cvv2.account.verification', 'CVV2 Account Verification'),
    (8601, 'icc.omitted', 'ICC data Omitted'),
    (8602, 'icc.invalid', 'ICC data Invalid'),
    (8603, 'icc.not.validate', 'ICC data not validate'),
    (8700, 'unsupported.transaction', 'Unsupported Transaction'),
    (8701, 'previously.approved', 'Previously approved'),
    (8801, 'cavv.not.present', 'CAVV not present'),
    (8802, 'cavv.non.secure', 'Non Secure Transaction'),
    (9102, '9102', 'Invalid transaction'),
    (9104, 'cashback.limit.exceeded', 'Cashback limit exceeded'),
    (9107, 'issuer.not.available', 'Issuer not available');

INSERT INTO rc_locale (id, resultcode, resultinfo, extendedresultcode, locale)
VALUES
    (0, '0000', 'Transaction approved', null, 'JCARD'),
    (1, '0001', 'ORIGINAL 0001', null, 'JCARD'),
    (2, '0002', 'PARTIALLY APPROVED', null, 'JCARD'),
    (3, '0003', 'ORIGINAL 0003', null, 'JCARD'),
    (4, '0004', 'ORIGINAL 0004', null, 'JCARD'),
    (5, '0005', 'ORIGINAL 0005', null, 'JCARD'),
    (6, '0006', 'ORIGINAL 0006', null, 'JCARD'),
    (7, '0007', 'ORIGINAL 0007', null, 'JCARD'),
    (8, '0008', 'ORIGINAL 0008', null, 'JCARD'),
    (9, '0009', 'ORIGINAL 0009', null, 'JCARD'),
    (10, '0010', 'ORIGINAL 0010', null, 'JCARD'),
    (11, '0011', 'ORIGINAL 0011', null, 'JCARD'),
    (12, '0012', 'ORIGINAL 0012', null, 'JCARD'),
    (13, '0013', 'ORIGINAL 0013', null, 'JCARD'),
    (14, '0014', 'ORIGINAL 0014', null, 'JCARD'),
    (15, '0015', 'ORIGINAL 0015', null, 'JCARD'),
    (16, '0016', 'ORIGINAL 0016', null, 'JCARD'),
    (17, '0017', 'ORIGINAL 0017', null, 'JCARD'),
    (18, '0018', 'ORIGINAL 0018', null, 'JCARD'),
    (19, '0019', 'ORIGINAL 0019', null, 'JCARD'),
    (20, '0020', 'ORIGINAL 0020', null, 'JCARD'),
    (21, '0021', 'ORIGINAL 0021', null, 'JCARD'),
    (22, '0022', 'ORIGINAL 0022', null, 'JCARD'),
    (23, '0023', 'ORIGINAL 0023', null, 'JCARD'),
    (24, '0024', 'ORIGINAL 0024', null, 'JCARD'),
    (25, '0025', 'ORIGINAL 0025', null, 'JCARD'),
    (26, '0026', 'ORIGINAL 0026', null, 'JCARD'),
    (27, '0027', 'ORIGINAL 0027', null, 'JCARD'),
    (28, '0028', 'ORIGINAL 0028', null, 'JCARD'),
    (29, '0029', 'ORIGINAL 0029', null, 'JCARD'),
    (30, '0030', 'ORIGINAL 0030', null, 'JCARD'),
    (31, '0031', 'ORIGINAL 0031', null, 'JCARD'),
    (32, '0032', 'ORIGINAL 0032', null, 'JCARD'),
    (33, '0033', 'ORIGINAL 0033', null, 'JCARD'),
    (34, '0034', 'ORIGINAL 0034', null, 'JCARD'),
    (35, '0035', 'ORIGINAL 0035', null, 'JCARD'),
    (36, '0036', 'ORIGINAL 0036', null, 'JCARD'),
    (37, '0037', 'ORIGINAL 0037', null, 'JCARD'),
    (38, '0038', 'ORIGINAL 0038', null, 'JCARD'),
    (39, '0039', 'ORIGINAL 0039', null, 'JCARD'),
    (40, '0040', 'ORIGINAL 0040', null, 'JCARD'),
    (41, '0041', 'ORIGINAL 0041', null, 'JCARD'),
    (42, '0042', 'ORIGINAL 0042', null, 'JCARD'),
    (43, '0043', 'ORIGINAL 0043', null, 'JCARD'),
    (44, '0044', 'ORIGINAL 0044', null, 'JCARD'),
    (45, '0045', 'ORIGINAL 0045', null, 'JCARD'),
    (46, '0046', 'ORIGINAL 0046', null, 'JCARD'),
    (47, '0047', 'ORIGINAL 0047', null, 'JCARD'),
    (48, '0048', 'ORIGINAL 0048', null, 'JCARD'),
    (49, '0049', 'ORIGINAL 0049', null, 'JCARD'),
    (50, '0050', 'ORIGINAL 0050', null, 'JCARD'),
    (51, '0051', 'ORIGINAL 0051', null, 'JCARD'),
    (52, '0052', 'ORIGINAL 0052', null, 'JCARD'),
    (53, '0053', 'ORIGINAL 0053', null, 'JCARD'),
    (54, '0054', 'ORIGINAL 0054', null, 'JCARD'),
    (55, '0055', 'ORIGINAL 0055', null, 'JCARD'),
    (56, '0056', 'ORIGINAL 0056', null, 'JCARD'),
    (57, '0057', 'Not Permitted', null, 'JCARD'),
    (58, '0058', 'ORIGINAL 0058', null, 'JCARD'),
    (59, '0059', 'ORIGINAL 0059', null, 'JCARD'),
    (60, '0060', 'ORIGINAL 0060', null, 'JCARD'),
    (61, '0061', 'ORIGINAL 0061', null, 'JCARD'),
    (62, '0062', 'ORIGINAL 0062', null, 'JCARD'),
    (63, '0063', 'ORIGINAL 0063', null, 'JCARD'),
    (64, '0064', 'ORIGINAL 0064', null, 'JCARD'),
    (65, '0065', 'ORIGINAL 0065', null, 'JCARD'),
    (66, '0066', 'ORIGINAL 0066', null, 'JCARD'),
    (67, '0067', 'ORIGINAL 0067', null, 'JCARD'),
    (68, '0068', 'ORIGINAL 0068', null, 'JCARD'),
    (69, '0069', 'ORIGINAL 0069', null, 'JCARD'),
    (70, '0070', 'ORIGINAL 0070', null, 'JCARD'),
    (71, '0071', 'ORIGINAL 0071', null, 'JCARD'),
    (72, '0072', 'ORIGINAL 0072', null, 'JCARD'),
    (73, '0073', 'ORIGINAL 0073', null, 'JCARD'),
    (74, '0074', 'ORIGINAL 0074', null, 'JCARD'),
    (75, '0075', 'ORIGINAL 0075', null, 'JCARD'),
    (76, '0076', 'ORIGINAL 0076', null, 'JCARD'),
    (77, '0077', 'ORIGINAL 0077', null, 'JCARD'),
    (78, '0078', 'ORIGINAL 0078', null, 'JCARD'),
    (79, '0079', 'ORIGINAL 0079', null, 'JCARD'),
    (80, '0080', 'ORIGINAL 0080', null, 'JCARD'),
    (81, '0081', 'ORIGINAL 0081', null, 'JCARD'),
    (82, '0082', 'ORIGINAL 0082', null, 'JCARD'),
    (83, '0083', 'ORIGINAL 0083', null, 'JCARD'),
    (84, '0084', 'ORIGINAL 0084', null, 'JCARD'),
    (85, '0085', 'ORIGINAL 0085', null, 'JCARD'),
    (86, '0086', 'ORIGINAL 0086', null, 'JCARD'),
    (87, '0087', 'ORIGINAL 0087', null, 'JCARD'),
    (88, '0088', 'ORIGINAL 0088', null, 'JCARD'),
    (89, '0089', 'ORIGINAL 0089', null, 'JCARD'),
    (90, '0090', 'ORIGINAL 0090', null, 'JCARD'),
    (91, '0091', 'ORIGINAL 0091', null, 'JCARD'),
    (92, '0092', 'ORIGINAL 0092', null, 'JCARD'),
    (93, '0093', 'ORIGINAL 0093', null, 'JCARD'),
    (94, '0094', 'ORIGINAL 0094', null, 'JCARD'),
    (95, '0095', 'ORIGINAL 0095', null, 'JCARD'),
    (96, '0096', 'ORIGINAL 0096', null, 'JCARD'),
    (97, '0097', 'ORIGINAL 0097', null, 'JCARD'),
    (98, '0098', 'ORIGINAL 0098', null, 'JCARD'),
    (99, '0099', 'ORIGINAL 0099', null, 'JCARD'),
    (1001, '1001', 'Card expired', null, 'JCARD'),
    (1002, '1002', 'Card suspicious', null, 'JCARD'),
    (1003, '1003', 'Card suspended', null, 'JCARD'),
    (1004, '1004', 'Card stolen - pickup', null, 'JCARD'),
    (1005, '1005', 'Card lost', null, 'JCARD'),
    (1011, '1011', 'Card not found', null, 'JCARD'),
    (1012, '1012', 'Cardholder not found', null, 'JCARD'),
    (1014, '1014', 'Account not found', null, 'JCARD'),
    (1015, '1015', 'Invalid request', null, 'JCARD'),
    (1016, '1016', 'Not sufficient funds', null, 'JCARD'),
    (1017, '1017', 'Incorrect PIN', null, 'JCARD'),
    (1018, '1018', 'Previously reversed', null, 'JCARD'),
    (1019, '1019', 'Further activity prevents reversal', null, 'JCARD'),
    (1020, '1020', 'Further activity prevents void', null, 'JCARD'),
    (1021, '1021', 'Original transaction has been voided', null, 'JCARD'),
    (1025, 1025, 'Transaction not permitted to cardholder', null, 'JCARD'),
    (1802, '1802', 'Missing fields', null, 'JCARD'),
    (1803, '1803', 'Extra fields exist', null, 'JCARD'),
    (1804, '1804', 'Invalid card number', null, 'JCARD'),
    (1806, '1806', 'Card not active', null, 'JCARD'),
    (1808, '1808', 'Card not configured', null, 'JCARD'),
    (1810, '1810', 'Invalid amount', null, 'JCARD'),
    (1811, '1811', 'System Error', null, 'JCARD'),
    (1812, '1812', 'System Error', null, 'JCARD'),
    (1813, '1813', 'Cardholder not active', null, 'JCARD'),
    (1814, '1814', 'Cardholder not configured', null, 'JCARD'),
    (1815, '1815', 'CardHolder expired', null, 'JCARD'),
    (1816, '1816', 'Original not found', null, 'JCARD'),
    (1817, '1817', 'Usage Limit Reached', null, 'JCARD'),
    (1818, '1818', 'Configuration error', null, 'JCARD'),
    (1819, '1819', 'Invalid terminal', null, 'JCARD'),
    (1820, '1820', 'Inactive terminal', null, 'JCARD'),
    (1821, '1821', 'Invalid merchant', null, 'JCARD'),
    (1822, '1822', 'Duplicate entity', null, 'JCARD'),
    (1823, '1823', 'Invalid Acquirer', null, 'JCARD'),
    (1824, '1824', 'Accounting Exception', null, 'JCARD'),
    (1825, '1825', 'Previously reversed', null, 'JCARD'),
    (1826, '1826', 'Previously transmitted', null, 'JCARD'),
    (1827, '1827', 'Invalid issuer institutionId', null, 'JCARD'),
    (1829, '1829', 'Amount Limit Reached', null, 'JCARD'),
    (1834, '1834', 'The account is deactivated.', NULL, 'JCARD'),
    (8444, '8444', 'Pending credit', NULL, 'JCARD'),
    (8500, '8500', 'Invalid installment', null, 'JCARD'),
    (8501, '8501', 'CVV2 Omitted', NULL, 'JCARD'),
    (8502, '8502', 'CVV2 Invalid', NULL, 'JCARD'),
    (8503, '8503', 'CVV2 Account Verification', null, 'JCARD'),
    (8601, '8601', 'ICC data Omitted', NULL, 'JCARD'),
    (8602, '8602', 'ICC data Invalid', NULL, 'JCARD'),
    (8603, '8603', 'ICC data not validate', NULL, 'JCARD'),
    (8700, '8700', 'Unsupported Transaction', null, 'JCARD'),
    (8701, '8701', 'Previously approved', null, 'JCARD'),
    (8801, '8801', 'CAVV not present', NULL, 'JCARD'),
    (8802, '8802', 'Non Secure Transaction', NULL, 'JCARD'),
    (9102, '9102', 'Invalid transaction', null, 'JCARD'),
    (9104, '9104', 'Cashback limit exceeded', NULL, 'JCARD'),
    (9107, '9107', 'Issuer not available', NULL, 'JCARD');


-------------------
-- users & perms --
-------------------

INSERT INTO role (id, name, realm, parent)
VALUES
    (62, 'admin', null, null),
    (63, 'restapi', null, null),
    (64, 'guest', null, null);

INSERT INTO role_perms (role, name)
VALUES
    (62, 'sysadmin'),
    (62, 'login'),
    (62, 'users.write'),
    (62, 'users.read'),
    (62, 'accounting'),
    (64, 'login'),
    (63, 'login'),
    (63, 'sysconfig.write'),
    (62, 'sysconfig.read'),
    (63, 'sysconfig.read'),
    (62, 'sysconfig.write');

INSERT INTO eeuser (id, nick, passwordhash, name, email, active, deleted, verified, startdate, enddate,
                    forcepasswordchange, lastlogin, passwordchanged, loginattempts)
VALUES
    (60, 'admin',
     'ARR5oS7UxDv5uwh6KwV++xK1LBDtg4SE+0EQOYFQiFJz/wEMSN0vTjeh388mvecXWP+Y5Cep3vxV8VRR4XF1FgSGPQvaFMQkihg1Zm1Avc5w2auD3UrcorhyZNuht7WvrU3eM4aSOnsetWf7gzhhQV9zZi5Xo9L3CDszvvwpIdblcFD7s9Waz66FWfb4oInqaj0nWciL6RNcv0MgUhMYYUmAV6RUvaG0w1Z7akES1SJBy5up9FUBW7lXH43T/nWtNSrMPsJ3lPerDLW7Gj2Z2wjk282kByzSseqkD2emneaq0roZM0ho4bAVE8CuMv/ygehuR1m4q6ckaNU6aduftMXMa7IVF4C8ZMUmUNwx9Uuf',
     'User Administrator', null, 'Y', 'N', 'N', null, null, 'N', null, null, 0),
    (65, 'guest',
     'AZSVT7r0hGegL6+vMQuTLUdaCDJcd5vnzY4GBfdqg7EEKczUJgIiLGC9Qe1p2+tC3QVTWM3DkIruv44B/mN7gbNdT+o6jwxnjUHCzRKQibL4dEPT3ZNIa+uN0HtVbgo1LMRs009YkmszFcp9aQaeWQdwpKkCzKB9LEcDrC1i3aq33vbPaO0k/+SHOsdE4rmRWehGY7C38Te4sh0hA/EO8n4cH8811APojSOfqFdfpdEVvveTNZ6htfwvMphFT+z5YhjZ1wuOWUCf14iascMPV1S+kPsvAQqqQcZ1Jj/x3kAcD5H6OTbq9ReF4iSX3m0Q1azKBklKCoYCb85meGRgvpM0M5yEZ4M02+rg2JlVAsW8',
     'Guest', null, 'Y', 'N', 'N', null, null, 'N', null, null, 0);

INSERT INTO eeuser_roles (eeuser, role)
VALUES
    (60, 62),
    (65, 64);

INSERT INTO consumer (id, active, deleted, startdate, enddate, eeuser, hash)
VALUES
    ('c400ded2-f9cc-11e4-accc-3c15c2cf79f2', 'Y', 'N', null, null, 60, '12b12b12');

INSERT INTO consumer_roles (consumer, role)
VALUES
    ('c400ded2-f9cc-11e4-accc-3c15c2cf79f2', 63);
