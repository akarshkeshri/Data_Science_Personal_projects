"""
Calls the other files and should be the entry point of your code. 
contain the code to read the messages from Kafka and call necessary
functions from the python files present in the "rules" and "db" directory
to classify the incoming transaction as fraud or genuine.
"""

import sys
import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from rules.rules import *ditCardFraud').getOrCreate()
spark.sparkContext.setLogLevel('Error')

Credit_Crad = spark.readStream \
    .format('Kafka') \
    .option("kafka.bootstrap.servers","18.211.252.152:9092") \
    .option("startingOffsets","earliest") \
    .option("failOnDataLoss","False") \
    .option("Subscribe","transactions-topic-verified") \
    .load()

schema_type = StructType() \
    .add('card_id',LongType()) \
    .add('member_id',LongType()) \
    .add('amount',DoubleType()) \
    .add('pos_id',LongType()) \
    .add('postcode',IntegerType()) \
    .add('transaction_dt',StringType())

Credit_Crad = Credit_Crad.selectExpr("cast(value as string)")
credit_data_stream = Credit_Crad.select(from_json(col ='value',schema=schema_type).alias("Credit_Crad").select("Credit_Crad.*"))
#checking all rule
verify_all_rulsses = udf(check_all3_rule_meet(card_id,member_id,amount,pos_id,postcode,transaction_dt),StringType())
final_data = credit_datsa_stream \
    .withcolumn('status',verify_all_srules(credit_data_stream['card_id'],
                                          credit_data_stream['member_id'],
                                          credit_data_stream['amount'],
                                          credit_data_stream['pos_id'],
                                          credit_data_stream['postcode'],
                                          credit_data_stream['transaction_dt']))
output_data = Credit_Crad \
    .select("card_id","member_id","amount","pos_id","postcode","transaction_dt") \
    .writeStream \
    .outputMode("append") \
    .format("console") \
    .option