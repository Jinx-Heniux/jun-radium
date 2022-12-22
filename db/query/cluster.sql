-- name: CreateCluster :one
INSERT INTO cluster (
  cluster_name,
  cluster_id,
  provider,
  k8s_version,
  url
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;