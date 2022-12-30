package db

import (
	"context"
	"database/sql"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCreateCluster(t *testing.T) {
	arg := CreateClusterParams{
		ClusterName: "bmlp-ops",
		ClusterID:   "c-f6dmz",
		Provider:    sql.NullString{String: "RKE1", Valid: true},
		K8sVersion:  sql.NullString{String: "v1.21.12", Valid: true},
		Url:         sql.NullString{String: "https://radiumlabmgmt.bosch.com/dashboard/c/c-f6dmz/", Valid: true},
	}

	cluster, err := testQueries.CreateCluster(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, cluster)

	require.Equal(t, arg.ClusterName, cluster.ClusterName)
	require.Equal(t, arg.ClusterID, cluster.ClusterID)
	require.Equal(t, arg.Provider.String, cluster.Provider.String)
	require.Equal(t, arg.K8sVersion.String, cluster.K8sVersion.String)
	require.Equal(t, arg.Url.String, cluster.Url.String)

	require.NotZero(t, cluster.ID)
	require.NotZero(t, cluster.CreatedAt)
}
