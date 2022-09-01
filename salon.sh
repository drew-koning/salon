#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n\n~~~~~ Salon Scheduler ~~~~~~\n\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  
  echo -e "\n1) Boys Cut\n2) Girls Cut\n3) Hair Dye\n4) Shampoo"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-4]$ ]]
  then
    MAIN_MENU "Please select a valid service id."
  # if valid selection ask for phone number
  else
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  PHONE_RESULT=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
    # if phone not found add new customer
    if [[ -z $PHONE_RESULT ]]
      then
      echo -e "\nPlease enter your name."
      read CUSTOMER_NAME
      ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
  # pull customer name and ID from db
  CUSTOMER_NAME=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")

  # ask for time
  echo "At what time would you like an appointment?"
  read SERVICE_TIME

  #Insert appointment into db
  INSERT_APP_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")

  #output success message
  SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME." 
  fi
}


MAIN_MENU "Please select a service"