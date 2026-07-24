package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/route53"
	route53types "github.com/aws/aws-sdk-go-v2/service/route53/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	opts := ctx.TerratestTerraformOptions()
	zoneID := terraform.Output(t, opts, "zone_id")
	zoneName := terraform.Output(t, opts, "name")
	zoneARN := terraform.Output(t, opts, "id")
	nameServers := terraform.OutputList(t, opts, "name_servers")

	assert.Equal(t, zoneID, zoneARN, "id should equal zone_id for Route53 hosted zones")
	require.NotEmpty(t, zoneName, "zone name should be set")
	require.Len(t, nameServers, 4, "Route53 zones have 4 name servers")

	cfg, err := config.LoadDefaultConfig(context.Background())
	require.NoError(t, err)

	client := route53.NewFromConfig(cfg)
	result, err := client.GetHostedZone(context.Background(), &route53.GetHostedZoneInput{
		Id: aws.String(zoneID),
	})
	require.NoError(t, err)
	require.NotNil(t, result.HostedZone)
	apiZoneName := strings.TrimSuffix(aws.ToString(result.HostedZone.Name), ".")
	assert.Equal(t, zoneName, apiZoneName, "zone name should match")
	apiZoneID := strings.TrimPrefix(aws.ToString(result.HostedZone.Id), "/hostedzone/")
	assert.Equal(t, zoneID, apiZoneID, "zone ID should match")

	recordName := "test-record." + zoneName
	_, err = client.ChangeResourceRecordSets(context.Background(), &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: aws.String(zoneID),
		ChangeBatch: &route53types.ChangeBatch{
			Changes: []route53types.Change{
				{
					Action: route53types.ChangeActionUpsert,
					ResourceRecordSet: &route53types.ResourceRecordSet{
						Name: aws.String(recordName),
						Type: route53types.RRTypeA,
						TTL:  aws.Int64(300),
						ResourceRecords: []route53types.ResourceRecord{
							{Value: aws.String("192.0.2.1")},
						},
					},
				},
			},
		},
	})
	require.NoError(t, err)

	recordResult, err := client.ListResourceRecordSets(context.Background(), &route53.ListResourceRecordSetsInput{
		HostedZoneId: aws.String(zoneID),
		MaxItems:     aws.Int32(100),
	})
	require.NoError(t, err)
	var found bool
	expectedName := recordName + "."
	for _, rr := range recordResult.ResourceRecordSets {
		if aws.ToString(rr.Name) == expectedName {
			found = true
			assert.Equal(t, route53types.RRTypeA, rr.Type)
			break
		}
	}
	require.True(t, found, "created A record should exist in zone")
}

func TestComposableCompleteReadOnly(t *testing.T, ctx types.TestContext) {
	opts := ctx.TerratestTerraformOptions()
	zoneID := terraform.Output(t, opts, "zone_id")
	zoneName := terraform.Output(t, opts, "name")
	zoneARN := terraform.Output(t, opts, "arn")
	nameServers := terraform.OutputList(t, opts, "name_servers")

	assert.Equal(t, zoneID, terraform.Output(t, opts, "id"), "id should equal zone_id")
	require.NotEmpty(t, zoneName, "zone name should be set")
	require.Len(t, nameServers, 4, "Route53 zones have 4 name servers")
	require.NotEmpty(t, zoneARN, "zone ARN should be set")

	cfg, err := config.LoadDefaultConfig(context.Background())
	require.NoError(t, err)

	client := route53.NewFromConfig(cfg)
	result, err := client.GetHostedZone(context.Background(), &route53.GetHostedZoneInput{
		Id: aws.String(zoneID),
	})
	require.NoError(t, err)
	require.NotNil(t, result.HostedZone)
	apiZoneName := strings.TrimSuffix(aws.ToString(result.HostedZone.Name), ".")
	assert.Equal(t, zoneName, apiZoneName, "zone name should match via API")
	apiZoneID := strings.TrimPrefix(aws.ToString(result.HostedZone.Id), "/hostedzone/")
	assert.Equal(t, zoneID, apiZoneID, "zone ID should match via API")
}
