# scripts

自己写的一些工具脚本。

用于简化一些日常运维中的重复操作。

## deploy

将grails3工程打包，使用当前日期归档war包到指定目录，更新war包中的配置文件，部署至指定的tomcat。

### 使用说明

脚本deploy-core.sh完成了主要的过程，deploy.sh用于收集环境变量。可以复制deploy.sh中的内容编写多个脚本，实现同一个工程使用不同的配置，部署至不同的tomcat。
根据deploy.sh脚本中的环境变量说明修改环境变量，运行脚本即可。
