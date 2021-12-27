pv is a piece of storage in cluster that has been provisioned by admin or dynamically by storage class.

PV have a lifecycle independent of pod.

PVC is a request for storage by user. It's similar to pod.

Pod consume node resources and pvc consume pv resource.

Cluster admin need to be able to offer different PVs without exposing users to the details of how those volumes are implemented. So we need StorageClass resource.

### LifeCycle of a volume and claim

- Provisioning
    - Static
    - Dynamic
- Binding: A control loop in the master watches for new PVCs, finds a matching PV and bind them.
- Using
- Reclaiming
    - Retain
    - Delete
    - Recycle
    

### Storage Class

A storage class provide way for admin to describe the "classes" of storage they offer.

k get storageclass