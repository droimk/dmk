################################################################################
#huangjun @ 2015/09/15~20
# v01
################################################################################
#脚本作用：在开始编译之前拷贝文件到目标位置
#工作时机：所有编译之开始之前拷贝
#工作频率：第一次编译时，文件更新时
#脚本格式:DROI_NEED_REPLACE_MK +=filename:target-patch/filename1
#			filename与filename1可以不同
#注   意：目前不做目标检查，允许多对一，一对多的拷贝
################################################################################
