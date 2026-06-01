moved {
  from = hcloud_server.workers_new
  to   = hcloud_server.workers
}

# Backward-compat: `hcloud_placement_group.worker` was a singleton before
# per-pool placement groups landed. Existing clusters whose worker_nodes don't
# specify `placement_group` default to "worker", so the singleton migrates to
# the "worker"-keyed instance without recreating the resource (and so without
# rolling every worker server).
moved {
  from = hcloud_placement_group.worker
  to   = hcloud_placement_group.worker["worker"]
}

removed {
  from = hcloud_floating_ip_assignment.this

  lifecycle {
    destroy = false
  }
}
