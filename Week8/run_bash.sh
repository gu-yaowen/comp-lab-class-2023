#!/bin/bash

echo "Starting the simulations..."

start_density=0.5
end_density=1.1
increment=0.1


for density in $(seq $start_density $increment $end_density)
do
    mkdir Inputs/WCA_${density}
    logfile=Inputs/WCA_${density}/log_${density}.log
    dcdfile=Inputs/WCA_${density}/traj_${density}.dcd
    final_structure=Inputs/WCA_${density}/final_${density}.lammpstrj
    mpirun lmp -in Inputs/2dWCA.in -var density $density -log $logfile -var dcdfile $dcdfile -var final_structure $final_structure

    # 以下步骤需要手动执行:
    # 使用 VMD 查看最终帧以判断是否发生结晶
    # 如果需要，在确定的密度之间运行另一个密度
    # 在 VMD 中保存结晶和非结晶相的图片

    # 注意: 确保修改 LAMMPS 输入文件 '2dWCA.in' 以接受密度作为变量
done

echo "Simulations completed."
