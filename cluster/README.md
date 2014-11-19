# Seafile Cluster Environemnt #

There are three nodes in the cluster:

* One node for running haproxy (With vagrant identifier `seafile_lb`)
* Two nodes, `seafile_node1`, and `seafile_node2` for running seafile server. `seafile_node2` also runs the background tasks.

`seafile_node2` is allocated 2GB memory, and the other two nodes are allocated 512MB each.

# Start the cluster #

```sh
vagrant up
```

On node1 and node2, Use `/data` as the seafile data folder. They are mapped to `seafile-vagrant/cluster/data/node1` and `seafile-vagrant/cluster/data/node2` respectively.
