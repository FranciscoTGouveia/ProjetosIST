#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("Delete a Product:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    connection.autocommit = True
    cursor = connection.cursor()
    sku = form.getvalue('sku')
    if (not sku):
        print('<form method="post" action="dproduct.cgi"')
        print('<label for="sku">Product SKU:</label>')
        print('<input type="text" id="sku" name="sku"required><br><br>')
        print('<input type="submit" value="Submit">')
        print('</form>')
    else:
        sql = 'SELECT * FROM product WHERE product.SKU = %(sku)s ;'
        cursor.execute(sql,{'sku':sku})
        result = cursor.fetchall()
        if len(result) != 0 :
            sql = 'SELECT A.order_no FROM (SELECT order_no FROM contains WHERE contains.sku = %(blob)s) AS A JOIN contains on contains.order_no = A.order_no GROUP BY A.order_no HAVING (COUNT(A.order_no) = 1);'
            cursor.execute(sql,{'blob': sku})
            orders = cursor.fetchall()
            connection.autocommit = False

            sql = """
                START TRANSACTION;
                SET CONSTRAINTS ALL DEFERRED;
                DELETE FROM delivery
                        WHERE tin IN (SELECT tin FROM delivery AS d NATURAL JOIN (SELECT sup.tin FROM supplier AS sup WHERE sku = %(blob)s) AS subquery_alias);
                DELETE FROM supplier 
                        WHERE SKU = %(blob)s;
                COMMIT;
            """
            cursor.execute(sql,{'blob':sku})
            connection.commit()

            cursor.execute("SET CONSTRAINTS	ALL	DEFERRED")
            cursor.execute("BEGIN")


            sql = "DELETE FROM contains WHERE SKU = %(blob)s;"
            cursor.execute(sql,{'blob':sku})


            for order_no in orders:
                sql ="""DELETE FROM process
                            WHERE order_no = %(blob)s;
                        DELETE FROM pay
                            WHERE order_no = %(blob)s;
                        DELETE FROM orders
                            WHERE order_no = %(blob)s;
                    """
                cursor.execute(sql,{'blob':order_no})

            sql = "DELETE FROM product WHERE SKU = %(blob)s;"
            cursor.execute(sql,{'blob':sku})
            connection.commit()
            print('<h3>Product {} sucessfully removed</h3>'.format(sku))
            print('<button type="button"><a href="dproduct.cgi">Remove another product</a></button>')

        else:
            print('<h3>Product {} does not exist</h3>'.format(sku))
            print('<button type="button"><a href="dproduct.cgi">Try Again</a></button>')
        
    # Getting new customer information
    aux.finish_page(cursor)    

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="dproduct.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
