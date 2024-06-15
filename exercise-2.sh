export NFS_SERVER=$(hostname -I|cut -d' ' -f1)
echo "/data/volumes        $NFS_SERVER(rw,sync,no_wdelay,no_root_squash,insecure)" >> /etc/exports
mkdir -p /data/volumes
chmod 777 /data/volumes
exportfs -rav
oc delete pod -l app=nfs-client-provisioner -n default

echo "Wait for the pod to restart" 
oc wait --for=condition=Ready pod -l app=nfs-client-provisioner -n default


echo "Create a test volume"

oc apply -f - <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
  annotations:
    nfs.io/storage-path: "test-path"
spec:
  storageClassName: managed-nfs-storage
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
EOF

echo "Test if volume creation succeeded"

oc get pvc test-claim
