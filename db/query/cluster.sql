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

-- name: GetCluster :one
SELECT * FROM cluster
WHERE id = $1 LIMIT 1;

-- name: ListClusters :many
SELECT * FROM cluster
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateCluster :exec
UPDATE cluster
  set provider = $2,
  k8s_version = $3,
  url = $4
WHERE id = $1;

-- name: DeleteCluster :exec
DELETE FROM cluster
WHERE id = $1;