
import sys
import _mysql

RDS_NAME=sys.argv[1]
RDS_USER=sys.argv[2]
RDS_PASS=sys.argv[3]
RDS_HOST=sys.argv[4]
RDS_PORT=sys.argv[5]
NSOT_EMAIL=sys.argv[6]
NSOT_PASS=sys.argv[7]

params = {
    'user': RDS_USER, 
    'password': RDS_PASS,
    'host': RDS_HOST,
    'database': RDS_NAME
}

db=_mysql.connect(**params) 

params2 = ('', NSOT_PASS, '2017-07-10 21:24:22', '1', NSOT_EMAIL, '1', '1', '2017-07-10 21:24:22', 'h0Ylj-Gx0JCoZnVK4jPeENy88YWtLmRupHfU1luT0ms=' )
with db:
   cur = con.cursor()
   cur.execute("""INSERT INTO nsot_user() VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""", params2)

    'ENGINE': 'django.db.backends.mysql',
        'NAME': 'nsot',
        'USER': 'cosmos',
        'PASSWORD': 'cosmoscosmos',
        'HOST': 'cosmosdb.cwmhue7rrx9p.us-west-2.rds.amazonaws.com',
        'PORT': '3306',


from mysql.connector import MySQLConnection, Error
from python_mysql_dbconfig import read_db_config
 
def insert_user(pword, user):
    query = "INSERT INTO nsot_user() " \
            "VALUES('',%s,'','1',%s,'1','1','','h0Ylj-Gx0JCoZnVK4jPeENy88YWtLmRupHfU1luT0ms=')"
    args = (pword, user)
 
    try:
        db_config = read_db_config()
        conn = MySQLConnection(**db_config)
 
        cursor = conn.cursor()
        cursor.execute(query, args)
 
        if cursor.lastrowid:
            print('last insert id', cursor.lastrowid)
        else:
            print('last insert id not found')
 
        conn.commit()
    except Error as error:
        print(error)
 
    finally:
        cursor.close()
        conn.close()
 
def main():
   insert_user('test@testtest.com','test')
 
if __name__ == '__main__':
    main()