CREATE TABLE "cluster" (
  "id" bigserial PRIMARY KEY,
  "cluster_name" varchar NOT NULL,
  "cluster_id" varchar NOT NULL,
  "provider" varchar,
  "k8s_version" varchar,
  "url" varchar,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "project" (
  "id" bigserial PRIMARY KEY,
  "project_name" varchar NOT NULL,
  "project_id" varchar NOT NULL,
  "cluster_id" varchar NOT NULL,
  "url" varchar,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "application" (
  "id" bigserial PRIMARY KEY,
  "provider" varchar,
  "product" varchar,
  "app_name" varchar NOT NULL,
  "app_version" varchar NOT NULL,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "module" (
  "id" bigserial PRIMARY KEY,
  "module_name" varchar,
  "module_version" varchar,
  "app_id" bigint,
  "created_at" timestamptz DEFAULT (now())
);

CREATE INDEX ON "cluster" ("cluster_name");

CREATE UNIQUE INDEX ON "cluster" ("cluster_id");

CREATE INDEX ON "project" ("project_name");

CREATE UNIQUE INDEX ON "project" ("project_id");

CREATE INDEX ON "application" ("app_name");

CREATE UNIQUE INDEX ON "application" ("app_name", "app_version");

CREATE INDEX ON "module" ("app_id");

CREATE UNIQUE INDEX ON "module" ("module_name", "module_version");

ALTER TABLE "project" ADD FOREIGN KEY ("cluster_id") REFERENCES "cluster" ("cluster_id");

ALTER TABLE "module" ADD FOREIGN KEY ("app_id") REFERENCES "application" ("id");
