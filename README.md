# Usage

Copy the dir template to your home and rename it as `tracing`, or change the variables in the script `entry.sh`.

Run `entry.sh` directly, it will call `job.sh`. The program generate the marker list for each job in `<Working Dir>/job`; Vaa3D logs in `<Working Dir>/log`, sorted by brain ID; output swc in `<Working Dir>/out`, sorted by brain ID. It also generates all markers list in `<Working Dir>/all_markers.csv` and a decoy marker file (means marker in the center of a 1024x1024x512 image) for Vaa3D.

You can specify # of jobs and # of nodes for the 1st and 2nd args. They are 20 and 10 as default. You can modify the code to support # of processes, because we only have 10 nodes, though I deem it not necessary enough.

Good luck and be gentle with the server.

Zuohan