#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

#Function to display service
DISPLAY_SERVICES() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while IFS="|" read ID NAME
  do
    echo "$ID) $NAME"
  done
}

#MAIN MENU

DISPLAY_SERVICES

read SERVICE_ID_SELECTED

#Validate service
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

#Not null
if [[ -z $SERVICE_NAME ]]
then
  DISPLAY_SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
fi

#Phone
echo "What is your number phone?"
read CUSTOMER_PHONE

#Customer phone exist
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

#Customer phone no exist
if [[ -z $CUSTOMER_NAME ]]
then
  echo "What is your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

#Customer id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

#Time
echo "What time would you like your appointment?"
read SERVICE_TIME

#Appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

#OUTPUT MESSAGE
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
