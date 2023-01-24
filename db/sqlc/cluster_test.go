package db

import (
	"context"
	"database/sql"
	"fmt"
	"testing"
	"time"

	"github.com/Jinx-Heniux/jun-radium-go-gin/util"
	"github.com/stretchr/testify/require"
)

func createRandomCluster(t *testing.T) Cluster {
	cid := util.RandomClusterID()
	url := fmt.Sprintf("https://radiumlabmgmt.bosch.com/dashboard/c/%s/", cid)
	arg := CreateClusterParams{
		ClusterName: util.RandomClusterName(), // "bmlp-ops",
		ClusterID:   cid,                      // "c-f6dmz",
		Provider:    sql.NullString{String: "RKE1", Valid: true},
		K8sVersion:  sql.NullString{String: "v1.21.12", Valid: true},
		Url:         sql.NullString{String: url, Valid: true},
		// Url:         sql.NullString{String: "https://radiumlabmgmt.bosch.com/dashboard/c/c-f6dmz/", Valid: true},
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

	return cluster
}

func TestCreateCluster(t *testing.T) {
	createRandomCluster(t)
}

func TestGetCluster(t *testing.T) {
	cluster1 := createRandomCluster(t)
	cluster2, err := testQueries.GetCluster(context.Background(), cluster1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, cluster2)

	require.Equal(t, cluster1.ClusterName, cluster2.ClusterName)
	require.Equal(t, cluster1.ClusterID, cluster2.ClusterID)
	require.Equal(t, cluster1.Provider.String, cluster2.Provider.String)
	require.Equal(t, cluster1.K8sVersion.String, cluster2.K8sVersion.String)
	require.Equal(t, cluster1.Url.String, cluster2.Url.String)

	require.WithinDuration(t, cluster1.CreatedAt.Time, cluster2.CreatedAt.Time, time.Second)
}

func TestUpdateCluster(t *testing.T) {
	cluster1 := createRandomCluster(t)

	arg := UpdateClusterParams{
		ID:         cluster1.ID,
		Provider:   sql.NullString{String: "RKE2", Valid: true},
		K8sVersion: sql.NullString{String: "v1.21.13", Valid: true},
		Url:        cluster1.Url,
	}

	cluster2, err := testQueries.UpdateCluster(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, cluster2)

	require.Equal(t, cluster1.ClusterName, cluster2.ClusterName)
	require.Equal(t, cluster1.ClusterID, cluster2.ClusterID)
	require.Equal(t, arg.Provider.String, cluster2.Provider.String)
	require.Equal(t, arg.K8sVersion.String, cluster2.K8sVersion.String)
	require.Equal(t, cluster1.Url.String, cluster2.Url.String)

	require.WithinDuration(t, cluster1.CreatedAt.Time, cluster2.CreatedAt.Time, time.Second)
}

func TestDeleteCluster(t *testing.T) {
	cluster1 := createRandomCluster(t)
	err := testQueries.DeleteCluster(context.Background(), cluster1.ID)

	require.NoError(t, err)

	cluster2, err := testQueries.GetCluster(context.Background(), cluster1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, cluster2)
}

func TestListCluster(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomCluster(t)
	}

	arg := ListClustersParams{
		Limit:  5,
		Offset: 5,
	}

	clusters, err := testQueries.ListClusters(context.Background(), arg)

	require.NoError(t, err)
	require.Len(t, clusters, 5)

	for _, cluster := range clusters {
		require.NotEmpty(t, cluster)
	}
}
