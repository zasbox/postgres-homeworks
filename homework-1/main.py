"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import csv

employees = []
customers = []
orders = []

conn = psycopg2.connect(host='localhost', database='north', user='postgres', password='postgres')

try:
    with conn:
        with open("north_data/employees_data.csv", encoding='utf-8') as r_file:
            file_reader = csv.DictReader(r_file, delimiter=",")
            for row in file_reader:
                employees.append((row['employee_id'], row['first_name'], row['last_name'], row['title'],
                                  row['birth_date'], row['notes']))

        with conn.cursor() as cursor:
            cursor.executemany("INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)", employees)

        with open("north_data/customers_data.csv", encoding='utf-8') as r_file:
            file_reader = csv.DictReader(r_file, delimiter=",")
            for row in file_reader:
                customers.append((row['customer_id'], row['company_name'], row['contact_name']))

        with conn.cursor() as cursor:
            cursor.executemany("INSERT INTO customers VALUES (%s, %s, %s)", customers)

        with open("north_data/orders_data.csv", encoding='utf-8') as r_file:
            file_reader = csv.DictReader(r_file, delimiter=",")
            for row in file_reader:
                orders.append((row['order_id'], row['customer_id'], row['employee_id'], row['order_date'], row['ship_city']))

        with conn.cursor() as cursor:
            cursor.executemany("INSERT INTO orders VALUES (%s, %s, %s, %s, %s)", orders)
finally:
    conn.close()




