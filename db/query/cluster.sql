-- name: CreateCluster :one
INSERT INTO clusters (
  cluster_name,
  cluster_id,
  provider,
  k8s_version,
  url
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetCluster :one
SELECT * FROM clusters
WHERE id = $1 LIMIT 1;

-- name: ListClusters :many
SELECT * FROM clusters
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateCluster :one
UPDATE clusters
  set provider = $2,
  k8s_version = $3,
  url = $4
WHERE id = $1
RETURNING *;

-- name: DeleteCluster :exec
DELETE FROM clusters
WHERE id = $1;