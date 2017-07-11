
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