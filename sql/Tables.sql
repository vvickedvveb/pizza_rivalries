CREATE TABLE Company (
    id          BIGINT PRIMARY KEY,
    company     VARCHAR(100),
    ticker      VARCHAR(10)
);


CREATE TABLE Stock_Quotes (
    id          BIGINT PRIMARY KEY,
    str_date    TEXT,
    date        TEXT,
    open        REAL,
    high        REAL,
    low         REAL,
    close       REAL,
    adj_close   REAL,
    volume      INTEGER,
    created     TEXT,
    updated     TEXT,
    company_id  INTEGER,
    FOREIGN KEY(company_id) REFERENCES Company(id)
);