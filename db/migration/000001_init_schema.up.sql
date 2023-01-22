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

ALTER TABLE "entries" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");

CREATE INDEX ON "accounts" ("owner");

CREATE INDEX ON "entries" ("account_id");

CREATE INDEX ON "transfers" ("from_account_id");

CREATE INDEX ON "transfers" ("to_account_id");

CREATE INDEX ON "transfers" ("from_account_id", "to_account_id");

COMMENT ON COLUMN "entries"."amount" IS 'can be negative or positive';

COMMENT ON COLUMN "transfers"."amount" IS 'must be positive';

CREATE TABLE "clusters" (
  "id" bigserial PRIMARY KEY,
  "cluster_name" varchar NOT NULL,
  "cluster_id" varchar NOT NULL,
  "provider" varchar,
  "k8s_version" varchar,
  "url" varchar,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "projects" (
  "id" bigserial PRIMARY KEY,
  "project_name" varchar NOT NULL,
  "project_id" varchar NOT NULL,
  "cluster_id" varchar NOT NULL,
  "url" varchar,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "applications" (
  "id" bigserial PRIMARY KEY,
  "provider" varchar,
  "app_name" varchar NOT NULL,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "modules" (
  "id" bigserial PRIMARY KEY,
  "provider" varchar,
  "module_name" varchar NOT NULL,
  "created_at" timestamptz DEFAULT (now())
);

CREATE INDEX ON "clusters" ("cluster_name");

CREATE UNIQUE INDEX ON "clusters" ("cluster_id");

CREATE INDEX ON "projects" ("project_name");

CREATE UNIQUE INDEX ON "projects" ("project_id");

CREATE UNIQUE INDEX ON "applications" ("app_name");

CREATE UNIQUE INDEX ON "modules" ("module_name");

ALTER TABLE "projects" ADD FOREIGN KEY ("cluster_id") REFERENCES "clusters" ("cluster_id");