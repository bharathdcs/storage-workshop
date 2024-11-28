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
