#!/bin/bash

if [ $# -lt 1 ]; then
    echo "$0 <yum_root>"
    exit 0
fi

yum_root=$(echo $1 | sed 's/\/$//g')


#
# make link
#
link="""
./ops/6 6Server
./ops/4 4AS/
./ops/5 5Server
./aliyun/6 6Server
./aliyun/4 4AS
./aliyun/5 5Server
./taobao/6Server 6
./taobao/4AS 4
./taobao/5Server 5
./redhat/6.0/ScalableFileSystem/Packages ../Packages
./redhat/6.0/LoadBalancer/Packages ../Packages
./redhat/6.0/Server/Packages ../Packages
./redhat/6.0/ResilientStorage/Packages ../Packages
./redhat/6.0/repodata Server/repodata
./redhat/6.0/HighAvailability/Packages ../Packages
./redhat/6u2/os/x86_64/Server ../../../6.2/Server
./redhat/6u2/os/x86_64/Packages ../../../6.2/Packages
./redhat/6Server/os/x86_64/Server ../../../6.3/Server
./redhat/6Server/os/x86_64/Packages ../../../6.3/Packages
./redhat/5u8/os/x86_64/Cluster ../../../5.8/Cluster
./redhat/5u8/os/x86_64/VT ../../../5.8/VT
./redhat/5u8/os/x86_64/ClusterStorage ../../../5.8/ClusterStorage
./redhat/5u8/os/x86_64/Server ../../../5.8/Server
./redhat/5u4/os/x86_64/Cluster ../../../5.4/Cluster
./redhat/5u4/os/x86_64/VT ../../../5.4/VT
./redhat/5u4/os/x86_64/ClusterStorage ../../../5.4/ClusterStorage
./redhat/5u4/os/x86_64/Server ../../../5.4/Server
./redhat/6u1/os/x86_64/Server ../../../6.1/Server
./redhat/6u1/os/x86_64/Packages ../../../6.1/Packages
./redhat/5u6/os/x86_64/Cluster ../../../5.6/Cluster
./redhat/5u6/os/x86_64/VT ../../../5.6/VT
./redhat/5u6/os/x86_64/ClusterStorage ../../../5.6/ClusterStorage
./redhat/5u6/os/x86_64/Server ../../../5.6/Server
./redhat/6 6Server
./redhat/6u0/os/x86_64/Server ../../../6.0/Server
./redhat/6u0/os/x86_64/Packages ../../../6.0/Packages
./redhat/5u7/os/x86_64/Cluster ../../../5.7/Cluster
./redhat/5u7/os/x86_64/VT ../../../5.7/VT
./redhat/5u7/os/x86_64/ClusterStorage ../../../5.7/ClusterStorage
./redhat/5u7/os/x86_64/Server ../../../5.7/Server
./redhat/4AS/os/x86_64 ../../4.8/x86_64
./redhat/4AS/os/i386 ../../4.8/i386
./redhat/5u2/os/x86_64/Cluster ../../../5.2/Cluster
./redhat/5u2/os/x86_64/VT ../../../5.2/VT
./redhat/5u2/os/x86_64/ClusterStorage ../../../5.2/ClusterStorage
./redhat/5u2/os/x86_64/Server ../../../5.2/Server
./redhat/5u3/os/x86_64/Cluster ../../../5.3/Cluster
./redhat/5u3/os/x86_64/VT ../../../5.3/VT
./redhat/5u3/os/x86_64/ClusterStorage ../../../5.3/ClusterStorage
./redhat/5u3/os/x86_64/Server ../../../5.3/Server
./redhat/6u3/os/x86_64/Server ../../../6.3/Server
./redhat/6u3/os/x86_64/Packages ../../../6.3/Packages
./redhat/5.4/VT/VT ../../../5.4/VT
./redhat/5.4/Server/Server ../../../5.4/Server
./redhat/5 5Server
./redhat/5Server/os/x86_64/Cluster ../../../5.8/Cluster
./redhat/5Server/os/x86_64/VT ../../../5.8/VT
./redhat/5Server/os/x86_64/ClusterStorage ../../../5.8/ClusterStorage
./redhat/5Server/os/x86_64/Server ../../../5.8/Server
./alibase/6 6Server
./alibase/4 4AS
./alibase/5 5Server
./alios/6Server 6
./alios/5Server 5
"""

echo "$link" | while read line; do
    if [ "$line" == "" ]; then
        continue
    fi
    tgt=`echo $line | awk '{print $1}' | sed 's/^.\///g'`
    src=`echo $line | awk '{print $2}'`
    test -L $yum_root/$tgt
    if [ $? -eq 0 ]; then
    	l=`readlink $yum_root/$tgt`
		if [ "$l" == "$src" ]; then
			echo "OK    $yum_root/$tgt"
		else
			echo "ERROR $yum_root/$tgt"
		fi
    else
    	ln -s $src "$yum_root/$tgt"
    fi
done

#
# create repo
#
repo_arr='5 6'
arch_arr='i386 x86_64 noarch SRPMS'
br_arr='current test stable'
for repo in $repo_arr
do
    for arch in $arch_arr
    do
        for br in $br_arr
        do
            createrepo -d -p --update -s sha1 $yum_root/taobao/$repo/$arch/$br/
        done
    done
done
