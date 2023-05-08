import mysql.connector

# Create a connection to the database
cnx = mysql.connector.connect(user='your_username', password='your_password', host='localhost', database='little_lemon')

# Create a cursor to execute SQL statements
cursor = cnx.cursor()

# Execute a SELECT statement to fetch data from the Customers table
query = 'SELECT * FROM Customers'
cursor.execute(query)

# Fetch all rows of data returned by the SELECT statement
rows = cursor.fetchall()

# Print the data
for row in rows:
    print(row)

# Close the cursor and connection

def orders_inserted(order_id):
    # Perform some action in response to the new order being inserted
    print(f"New order inserted: order_id={order_id}")

# Create a connection to the database
cnx = mysql.connector.connect(user='your_username', password='your_password', host='localhost', database='little_lemon')

# Create a cursor to execute SQL statements
cursor = cnx.cursor()

# Create the orders_inserted stored procedure
cursor.execute("""
CREATE PROCEDURE orders_inserted (IN order_id INT)
BEGIN
  -- Call a Python function to handle the new order
  CALL python_call('orders_inserted', order_id);
END
""")

# Close the cursor and connection
cursor.close()
cnx.close()
