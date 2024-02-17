#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("Delete a Supplier:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    tin = form.getvalue('tin')
    if (not tin):
        print('<form method="post" action="dsupplier.cgi"')
        print('<label for="tin">Supplier TIN:</label>')
        print('<input type="text" id="tin" name="tin" required><br><br>')
        print('<input type="submit" value="Submit">')
        print('</form>')
    else:
        sql = 'SELECT * FROM supplier WHERE supplier.TIN = %(tin)s ;'
        cursor.execute(sql,{'tin':tin})
        result = cursor.fetchall()
        if len(result) != 0 :
            sql = """
                START TRANSACTION;
                SET CONSTRAINTS ALL DEFERRED;
                DELETE FROM delivery
                    WHERE TIN = %(blob)s;
                DELETE FROM supplier
                    WHERE TIN = %(blob)s;
                COMMIT;
            """
            cursor.execute(sql,{'blob':tin})
            connection.commit()
            print('<h3>Supplier {} sucessfully removed</h3>'.format(tin))
            print('<button type="button"><a href="dsupplier.cgi">Remove another supplier</a></button>')
        else:
            print('<h3>Supplier {} does not exist</h3>'.format(tin))
            print('<button type="button"><a href="dsupplier.cgi">Try Again</a></button>')

    # Getting new customer information
    aux.finish_page(cursor)

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="dsupplier.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
