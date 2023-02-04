CREATE TABLE "users" (
  "username" varchar PRIMARY KEY,
  "hashed_password" varchar NOT NULL,
  "full_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_changed_at" timestamptz NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "accounts" (
  "id" bigserial PRIMARY KEY,
  "owner" varchar NOT NULL,
  "balance" bigint NOT NULL,
  "currency" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "entries" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "transfers" (
  "id" bigserial PRIMARY KEY,
  "from_account_id" bigint NOT NULL,
  "to_account_id" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "clusters" (
  "id" bigserial PRIMARY KEY,
  "cluster_name" varchar NOT NULL,
  "cluster_id" varchar NOT NULL,
  "provider" varchar,
  "k8s_version" varchar,
  "url" varchar,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "projects" (
  "id" bigserial PRIMARY KEY,
  "project_name" varchar NOT NULL,
  "project_id" varchar NOT NULL,
  "cluster" varchar NOT NULL,
  "url" varchar,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "modules" (
  "id" bigserial PRIMARY KEY,
  "provider" varchar NOT NULL,
  "product" varchar NOT NULL,
  "module_name" varchar NOT NULL,
  "module_type" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "accounts" ("owner");

--CREATE UNIQUE INDEX ON "accounts" ("owner", "currency");
ALTER TABLE "accounts" ADD CONSTRAINT "owner_currency_key" UNIQUE ("owner", "currency");

CREATE INDEX ON "entries" ("account_id");

CREATE INDEX ON "transfers" ("from_account_id");

CREATE INDEX ON "transfers" ("to_account_id");

CREATE INDEX ON "transfers" ("from_account_id", "to_account_id");

CREATE INDEX ON "clusters" ("cluster_name");

CREATE UNIQUE INDEX ON "clusters" ("cluster_id");

CREATE INDEX ON "projects" ("project_name");

CREATE UNIQUE INDEX ON "projects" ("project_id");

CREATE INDEX ON "modules" ("module_name");

CREATE INDEX ON "modules" ("provider");

CREATE INDEX ON "modules" ("product");

CREATE UNIQUE INDEX ON "modules" ("provider", "product");

COMMENT ON COLUMN "entries"."amount" IS 'can be negative or positive';

COMMENT ON COLUMN "transfers"."amount" IS 'must be positive';

ALTER TABLE "accounts" ADD FOREIGN KEY ("owner") REFERENCES "users" ("username");

ALTER TABLE "entries" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");

ALTER TABLE "projects" ADD FOREIGN KEY ("cluster") REFERENCES "clusters" ("cluster_id");
