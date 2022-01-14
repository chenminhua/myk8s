```py
from pyspark.sql import Window
from pyspark.sql import SparkSession
from pyspark.sql import functions

spark = SparkSession.builder.enableHiveSupport() \
    .config("hive.exec.dynamic.partition", "true") \
    .config("hive.metastore.uris", "thrift://my-hive-metastore.default.svc.cluster.local:9083") \
    .config("hive.exec.dynamic.partition.mode", "nonstrict") \
    .getOrCreate()

spark.catalog.listDatabases()
df = spark.sql("select * from pokes")
df.show()
```
