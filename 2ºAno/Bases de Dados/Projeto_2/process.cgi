#!/usr/bin/python3
import psycopg2
import cgi
from datetime import datetime
import login
import aux
aux.print_init_page("Process Order:")
connection = None
form = cgi.FieldStorage()
connection = psycopg2.connect(login.credentials)

cursor = connection.cursor()
connection.autocommit = True
try:
    connection.autocommit =False
    cursor = connection.cursor()

    cust_no = form.getvalue('cust_no')
    sql = 'SELECT cust_no FROM customer WHERE cust_no = %s;'
    cursor.execute(sql % cust_no)
    result = cursor.fetchall()
    num = len(result)
    connection.commit()


    sql = 'SELECT MAX(order_no) AS highest_order_no FROM orders;'
    cursor.execute(sql)
    result = cursor.fetchall()
    order_no = result[0][0] + 1
    current_datetime = datetime.now()
    connection.commit()


    if num != 0:
        selected_keys = form.keys()
        notfound = True
        formatted_date = current_datetime.strftime("%Y-%m-%d")
        
        
        cursor.execute("SET CONSTRAINTS	ALL	DEFERRED")
        cursor.execute("BEGIN")
        sql = ' INSERT INTO orders (cust_no,order_no,odate) VALUES (%(cust_no)s, %(order_no)s, %(formatted_date)s);'
        cursor.execute(sql, {'cust_no': cust_no,'order_no':order_no,'formatted_date':formatted_date})

        for key in selected_keys:
            if key == 'cust_no':
                continue
            else:
                qty = form.getvalue(key)
                if int(qty) != 0 :
                    notfound = False
                    sql = 'INSERT INTO contains (order_no,SKU,qty) VALUES (%(order_no)s, %(SKU)s, %(qty)s);'
                    cursor.execute(sql, {'order_no':order_no,'SKU':key,'qty':qty})
        if not(notfound) :
            connection.commit()
            print('<h3>Your order number is {}. Thank you for your purchase! </h3>'.format(order_no))
            print('<button type="button"><a href="order.cgi">Make another order</a></button>')
            print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')
        else:
            connection.rollback()
            print('<h3>No product was selected</h3>')
            print('<button type="button"><a href="order.cgi">Go Back to Order Menu</a></button>')
    else:
        connection.rollback()
        print('<h3>Client number does not exist</h3>')
        print('<button type="button"><a href="order.cgi">Go Back to Order Menu</a></button>')
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    connection.rollback()
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="process.cgi">Try again</a></button>')
    
finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
