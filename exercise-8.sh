echo "Install AWS Cli"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sleep 20

oc new-project test

oc apply -f - <<EOF
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: my-object-bucket-claim
  namespace: test
spec:
  storageClassName: openshift-storage.noobaa.io
  generateBucketName: my-object-bucket-claim
EOF

echo "Wait for the creation of Object Bucket Claim"

sleep 60

oc get objectbucketclaims

oc extract configmap/my-object-bucket-claim --to=-

NOBAA_HOST=$(oc get route -n openshift-storage s3 -ojsonpath={.spec.host})

AWS_ACCESS_KEY_ID=$(oc extract secret/my-object-bucket-claim --keys=AWS_ACCESS_KEY_ID --to=-)

AWS_SECRET_ACCESS_KEY=$(oc extract secret/my-object-bucket-claim --keys=AWS_SECRET_ACCESS_KEY --to=-)

