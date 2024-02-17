#!/usr/bin/python3
import sys
import secret
IST_ID = 'ist1102571'
host = 'db.tecnico.ulisboa.pt'
port = 5432
password = secret.my_pass
db_name = IST_ID
credentials = 'host={} port={} user={} password={} dbname={}'.format(host, port, IST_ID, password, db_name)
