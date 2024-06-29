oc apply -f - <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-rbd-2
spec:
  storageClassName: ocs-storagecluster-ceph-rbd
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
EOF


oc apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: pod3
  name: pod3
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - pod4
        topologyKey: kubernetes.io/hostname
  containers:
  - image: registry.access.redhat.com/ubi8/ubi:8.10-901.1717584420
    imagePullPolicy: IfNotPresent
    name: test-ephemeral
    command: ["sleep", "360"]
    resources:
      limits:
        memory: 128Mi
        cpu: 500m
        ephemeral-storage: 100Mi
    volumeMounts:
    - mountPath: /user-home
      name: shared-vol
  volumes:
  - name: shared-vol
    persistentVolumeClaim:
      claimName: test-rbd-2
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: pod4
  name: pod4
spec:
  containers:
  - image: registry.access.redhat.com/ubi8/ubi:8.10-901.1717584420
    imagePullPolicy: IfNotPresent
    name: test-ephemeral
    command: ["sleep", "360"]
    resources:
      limits:
        memory: 128Mi
        cpu: 500m
        ephemeral-storage: 100Mi
    volumeMounts:
    - mountPath: /user-home
      name: shared-vol
  volumes:
  - name: shared-vol
    persistentVolumeClaim:
      claimName: test-rbd-2
EOF