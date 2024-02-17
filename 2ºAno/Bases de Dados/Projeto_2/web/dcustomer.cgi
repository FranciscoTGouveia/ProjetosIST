#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("Delete a Customer:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    cnumber = form.getvalue('cnumber')
    if (not cnumber):
        print('<form method="post" action="dcustomer.cgi"')
        print('<label for="cnumber">Customer Number:</label>')
        print('<input type="text" id="cnumber" name="cnumber" required><br><br>')
        print('<input type="submit" value="Submit">')
        print('</form>')
    else:
        sql = 'SELECT * FROM customer WHERE customer.cust_no = %(cust_no)s ;'
        cursor.execute(sql,{'cust_no':cnumber})
        result = cursor.fetchall()
        if len(result) != 0 :
            sql = """
                START TRANSACTION;
                SET CONSTRAINTS ALL DEFERRED;
                DELETE FROM process
                    WHERE order_no IN (SELECT order_no FROM orders WHERE cust_no = %(blob)s);
                DELETE FROM pay
                    WHERE order_no IN (SELECT order_no FROM orders WHERE cust_no = %(blob)s);
                DELETE FROM pay WHERE cust_no = %(blob)s;
                DELETE FROM contains
                    WHERE order_no IN (SELECT order_no FROM orders WHERE cust_no = %(blob)s);
                DELETE FROM orders WHERE cust_no = %(blob)s;
                DELETE FROM customer WHERE cust_no = %(blob)s;
                COMMIT;
            """
            cursor.execute(sql,{'blob':cnumber})
            connection.commit()
            print('<h3>Customer number {} sucessfully removed</h3>'.format(cnumber))
            print('<button type="button"><a href="dcustomer.cgi">Remove another customer</a></button>')
        else:
            print('<h3>Customer number {} does not exist</h3>'.format(cnumber))
            print('<button type="button"><a href="dcustomer.cgi">Try Again</a></button>')

    # Getting new customer information
    aux.finish_page(cursor)

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="dcustomer.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
