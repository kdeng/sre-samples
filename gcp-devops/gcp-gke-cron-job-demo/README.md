# GKE Cron Job POC

This POC descibes a possible solution by utilizing GKE auto-provisioning feature and Kubernetes CronJob resource to auto-scale node pool size.

## Limitations

1. There is no Google Cloud region has GPUs in all zones. So, we have to initialise node-pool for a single zone with supported accelerator type.
https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#gpu_regional_cluster

2. In order to enable auto-provisioning with GPUs, we need to install NVIDIA's device drivers to the node.
https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers

3. `CRON_TZ=<timezone>` prefix is not available yet until version 1.22. Currently, the latest GKE version is 1.21.5.
* https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-schedule-syntax
* https://stackoverflow.com/questions/68950893/how-can-i-specify-cron-timezone-in-k8s-cron-job

So, you have to use UTC timezone in current version.
