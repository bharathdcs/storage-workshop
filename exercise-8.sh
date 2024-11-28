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

sleep(60)


oc get objectbucketclaims

oc extract configmap/my-object-bucket-claim --to=-

oc extract secret/my-object-bucket-claim --to=-
