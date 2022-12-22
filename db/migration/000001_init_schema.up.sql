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
  "product" varchar,
  "app_name" varchar NOT NULL,
  "app_version" varchar NOT NULL,
  "created_at" timestamptz DEFAULT (now())
);

CREATE TABLE "modules" (
  "id" bigserial PRIMARY KEY,
  "module_name" varchar,
  "module_version" varchar,
  "app_id" bigint,
  "created_at" timestamptz DEFAULT (now())
);

CREATE INDEX ON "clusters" ("cluster_name");

CREATE UNIQUE INDEX ON "clusters" ("cluster_id");

CREATE INDEX ON "projects" ("project_name");

CREATE UNIQUE INDEX ON "projects" ("project_id");

CREATE INDEX ON "applications" ("app_name");

CREATE UNIQUE INDEX ON "applications" ("app_name", "app_version");

CREATE INDEX ON "modules" ("app_id");

CREATE UNIQUE INDEX ON "modules" ("module_name", "module_version");

ALTER TABLE "projects" ADD FOREIGN KEY ("cluster_id") REFERENCES "clusters" ("cluster_id");

ALTER TABLE "modules" ADD FOREIGN KEY ("app_id") REFERENCES "applications" ("id");
