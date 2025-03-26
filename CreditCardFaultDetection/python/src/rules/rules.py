from db.dao import HBaseDao
from db.geo_map import GEO_Map
from datetime import datetime
import uuid

lookup_table = 'lookup_data_hbase'
master_table = 'hbase_card_transactions'

# Rule - 1

def check_ucl(card_id,amount):
    try:
        hbase = HBaseDao.get_instance()
        card_row_data = hbase.get_data(key = str(card_id),table = lookup_table)
        card_ucl = ( card_row_data [b'card_data':'ucl']).decode("utf-8")
        if amount < float(card_ucl):
            return 'True'
        else:
            return 'False'
    except Exception as e:
        raise Exception(e)

# Rule 2 verify credit score 
def check_credit_score(card_id):
    try:
        hbase = HBaseDao.get_instance()
        card_row_data  = hbase.get_data(key = str(card_id),table = lookup_table)
        card_score = ( card_row_data [b'card_data':'score']).decode("utf-8")
        if int(card_score)>200:
            return 'True'
        else:
            return 'False'
    except Exception as e:
        raise Exception(e)
# Rule3 verify distance

def check_distance(card_id,postcode,transaction_dt):
    try:
        hbase = HBaseDao.get_instance()
        geo_map = GEO_Map.get_instance()
        card_row_data  =  hbase.get_data(key = str(card_id),table = lookup_table)
        last_transaction = ( card_row_data [b'card_data':'transaction_dt']).decode("utf-8")
        last_postcode = ( card_row_data [b'card_data':'postcode']).decode("utf-8")

        current_lat = geo_map.get_lat(str(postcode))
        current_lon = geo_map.get_long(str(postcode))

        last_current_lat = geo_map.get_lat(str(last_postcode))
        last_current_lon = geo_map.get_lat(str(last_postcode))

        dist = geo_map.distance(lat1=current_lat,long1=current_lon,lat2=last_current_lat,long2=last_current_lon)
        speed = calculate_spped(dist,transactiondt1,transactiondt2)
    except Exception as e:
        raise Exception(e)

def calculate_speed(dist,transactiondt1,transactiondt2):
    transactiondt1 = datetime.strptime(transactiondt1 ,'%d-%m-%y %H:%M:%S')
    transactiondt2 = datetime.strptime(transactiondt2 ,'%d-%m-%y %H:%M:%S')
    time_diff = transactiondt1-transactiondt2
    time_diff = time_diff.total_seconds()
    try:
        return dist/time_diff
    except ZeroDivisionError:
        return '300000'

def check_all3_rule_meet(card_id,member_id,amount,pos_id,postcode,transaction_dt):
    hbase = HBaseDao.get_instance()

    rule1 = check_ucl(card_id,amount)
    rule2 = check_credit_score(card_id)
    rule3 = check_distance(card_id,postcode,transaction_dt)
    
    if all([rule1,rule2,rule3]):
        status = 'Genuine'
        hbase.write_data(key=str(card_id),
                         row={'card_data:postcode':str(postcode),'card_data:transaction_dt':str(transaction_dt)},
                         table=lookup_table)
    else:
        status = 'Fraud'

    new_id = str(uuid.uuid4()).replace('-','')
    hbase.write_data(key=new_id,
                     row={'cardDetail:card_id':str(card_id),'cardDetail:member_id':str(member_id),
                                        'transactionDetail:amount':str(amount),
                                        'transactionDetail:pos_id':str(pos_id),
                                        'transactionDetail:postcode':str(postcode),
                                        'transactionDetail:status':str(status),
                                        'transactionDetail:transaction_dt':str(transaction_dt)}
                        ,table=master_table)
    return status






