resource "hcloud_placement_group" "control_plane" {
  name = "${local.cluster_prefix}control-plane"
  type = "spread"
  labels = {
    "cluster" = var.cluster_name
  }
}

# One placement group per distinct value of `worker_nodes[*].placement_group`.
# This lets callers shard worker pools (system / database / workers / …) onto
# their own spread groups so they fail and scale independently — and so a
# single pool can stay under Hetzner's 10-servers-per-group limit. Callers that
# don't set `placement_group` fall back to the "worker" key, which preserves
# the pre-existing single-group layout.
resource "hcloud_placement_group" "worker" {
  for_each = toset(distinct([for node in var.worker_nodes : node.placement_group]))

  name = "${local.cluster_prefix}${each.value}"
  type = "spread"
  labels = {
    "cluster"         = var.cluster_name
    "placement_group" = each.value
  }
}
